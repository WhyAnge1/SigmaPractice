import 'package:get/get.dart';

class Strings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'error': 'Error',
          'message': 'Message',
          'createYourAccount': 'Create your account',
          'username': 'Username',
          'email': 'Email',
          'password': 'Password',
          'confirmPassword': 'Confirm password',
          'createAnAccount': 'Create an account',
          'accountFor': 'Account for',
          'createdSuccessfully': 'created successfully',
          'emailExistError': 'User with this email adress is already exist',
          'systemErrorPleaseContactUs':
              'System error occurred! Please contact us if this error persist',
          'emptyUsernameError': 'Username must not be empty!',
          'emailNotValidError': 'Email is not valid!',
          'emptyPasswordError': 'Password must not be empty!',
          'weekPasswordError':
              'Password must contain at least 1 uppercase, 1 lower case characters, 1 digit and be at least 8 characters long!',
          'notMatchPasswordError': 'Passwords do not match',
          'loginToYourAccount': 'Login to your account',
          'rememberMe': 'Remember me',
          'login': 'Login',
          'forgotPassword': 'Forgot password',
          'userEmailExistError': 'User with this email does not exist!',
          'userNotExistOrPasswordWrongError':
              'User with this email does not exist or password is incorrect!',
          'emptyEmailError': 'Email should not be empty!',
          'convert': 'Convert',
          'enterYourText': 'Enter your text',
          'convertTextToSpeach': 'Convert text to speach',
          'emptyTextError': 'Text must not be empty!',
          'textToSpeachConvertionNotAvailableError':
              'Text to speach convertion is not available at this moment',
        },
      };
}
