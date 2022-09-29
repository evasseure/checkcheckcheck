use std::cmp;
use std::collections::HashMap;
use std::time::Instant;

const LETTERS: [&str; 26] = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
    "t", "u", "v", "w", "x", "y", "z",
];

fn splits(word: &str) -> Vec<[&str; 2]> {
    let mut word_splits = vec![];
    for i in 0..word.len() + 1 {
        word_splits.push([&word[..i], &word[i..]]);
    }

    return word_splits;
}

fn deletes(splits: &Vec<[&str; 2]>) -> Vec<String> {
    let mut words: Vec<String> = vec![];
    for split in splits {
        let [head, tail] = split;
        if tail.len() > 0 {
            words.push(format!("{}{}", head, &tail[1..]))
        }
    }

    return words;
}

fn transposes(splits: &Vec<[&str; 2]>) -> Vec<String> {
    let mut words: Vec<String> = vec![];
    for split in splits {
        let [head, tail] = split;
        if tail.len() > 1 {
            words.push(format!(
                "{}{}{}{}",
                head,
                &tail[1..2],
                &tail[0..1],
                &tail[2..]
            ))
        }
    }
    return words;
}

fn replaces(splits: &Vec<[&str; 2]>) -> Vec<String> {
    let mut words: Vec<String> = vec![];
    for letter in LETTERS {
        for split in splits {
            let [head, tail] = split;
            if tail.len() > 0 {
                words.push(format!("{}{}{}", head, letter, &tail[1..]))
            }
        }
    }
    return words;
}

fn inserts(splits: &Vec<[&str; 2]>) -> Vec<String> {
    let mut words: Vec<String> = vec![];
    for letter in LETTERS {
        for split in splits {
            let [head, tail] = split;
            if tail.len() > 0 {
                words.push(format!("{}{}{}", head, letter, tail))
            }
        }
    }
    return words;
}

fn get_variations(word: &str) -> Vec<String> {
    let splits = splits(word);

    let mut possibilities = vec![];

    possibilities.append(&mut deletes(&splits));
    possibilities.append(&mut transposes(&splits));
    possibilities.append(&mut replaces(&splits));
    possibilities.append(&mut inserts(&splits));

    return possibilities;
}

fn check_word(word: &str, dictionnary: &HashMap<String, u64>) -> Vec<String> {
    let mut suggestions: Vec<String> = vec![];

    let variations = get_variations(word);

    for variation in &variations {
        if dictionnary.contains_key(variation) {
            suggestions.push(String::from(variation))
        }
    }

    if suggestions.len() == 0 {
        for variation in &variations {
            let second_level_variations = get_variations(&variation);
            // println!("{}", second_level_variations.len())
            // let mut second_level_variations = Vec::new();
            // for elem in 0..600 {
            //     second_level_variations.push(String::from("value: T"))
            // }
            // for slv in second_level_variations {
            //     if dictionnary.contains_key(&slv) {
            //         suggestions.push(slv)
            //     }
            // }
        }
    }

    return suggestions[..cmp::min(3, suggestions.len())].to_vec();
}

#[rustler::nif]
fn correct(text: &str, dictionnary: HashMap<String, u64>) -> Vec<String> {
    let now = Instant::now();
    let mut suggestions = vec![];
    for sentence in text.split(".") {
        for word in sentence.split(" ") {
            if !dictionnary.contains_key(word) {
                suggestions.append(&mut check_word(word, &dictionnary));
            }
        }
    }

    let elapsed = now.elapsed();
    println!("Elapsed: {:.2?}", elapsed);
    return suggestions;
}

rustler::init!("Elixir.RustWordChecker", [correct]);
