package in.appyflow.splash;


public enum AppEnvironment {

    SANDBOX {
        @Override
        public String merchant_Key() {
            return "LLKwG0";
        }

        @Override
        public String merchant_ID() {
            return "393463";
        }

        @Override
        public String furl() {
            return "https://www.payumoney.com/mobileapp/payumoney/failure.php";
        }

        @Override
        public String surl() {
            return "https://www.payumoney.com/mobileapp/payumoney/success.php";
        }

//        @Override
//        public String salt() {
//            return "qauKbEAJ";
//        }

        @Override
        public boolean debug() {
            return true;
        }
    },
    PRODUCTION {
        @Override
        public String merchant_Key() {
            return "3gg2kYvx";
        }  //O15vkB

        @Override
        public String merchant_ID() {
            return "6516964";
        }   //4819816

        @Override
        public String furl() {
            return "https://www.payumoney.com/mobileapp/payumoney/failure.php";
        }

        @Override
        public String surl() {
            return "https://www.payumoney.com/mobileapp/payumoney/success.php";
        }

//        @Override
//        public String salt() {
//            return "Ydlj9Y14YZ";
//        }     //LU1EhObh

        @Override
        public boolean debug() {
            return false;
        }
    };

    public abstract String merchant_Key();

    public abstract String merchant_ID();

    public abstract String furl();

    public abstract String surl();

//    public abstract String salt();

    public abstract boolean debug();


}
