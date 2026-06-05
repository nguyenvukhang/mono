macro_rules! str_enum {
    ($name:ident, $(($enum:ident, $str:expr)),* $(,)?) => {
        #[allow(unused)]
        pub enum $name {
            $($enum),*
        }

        impl $name {
            pub const fn as_str(&self) -> &'static str {
                match self {
                    $(Self::$enum => $str,)*
                }
            }
        }
    };
}
