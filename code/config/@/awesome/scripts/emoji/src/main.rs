/// Source: https://github.com/Mange/rofi-emoji
///
/// EMOJI_BYTES        - The bytes of the emoji, for example "🤣". This is what is acted on.
/// \t                 - Tab character
/// GROUP_NAME         - The name of the group, for example "Smileys & Emotion".
/// \t                 - Tab character
/// SUBGROUP           - The name of the subgroup, for example "face-smiling".
/// \t                 - Tab character
/// NAME               - Name of emoji, for example "rolling on the floor laughing".
/// \t                 - Tab character
/// KEYWORD_1          - Keyword of the emoji, for example "rofl".
/// (" | " KEYWORD_n)… - Additional keywords are added with pipes and spaces between them.
/// \n                 - Newline ends the current record.
const ALL_EMOJIS: &str = include_str!("../all_emojis.txt");

fn main() {
    for line in ALL_EMOJIS.lines() {
        let mut it = line.split('\t');
        let parts: [&str; 5] = core::array::from_fn(|_| it.next().unwrap());
        if parts[4].is_empty() {
            println!("{} {}<:>{}", parts[0], parts[3], parts[0]);
        } else {
            println!("{} {} {}<:>{}", parts[0], parts[3], parts[4], parts[0]);
        }
    }
}
