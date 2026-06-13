//! This script serves to check that all those workflows that use path filters
//! filter for sub-projects as well as itself.
//!
//! In the future if the complexity grows and we use path filters for other
//! things, this script needs to be updated. (This script currently will also
//! assert that we _only_ use path filters for the known purpose.)

mod workflow;

fn main() {
    workflow::main();
}
