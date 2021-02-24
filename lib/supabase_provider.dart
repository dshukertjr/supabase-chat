import 'package:supabase/supabase.dart';

// ignore: avoid_classes_with_only_static_members
class SupabaseProvider {
  static final instance = SupabaseClient(
      'https://ucvdfmhwjjomlpgavbow.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNDE2NTk3OSwiZXhwIjoxOTI5NzQxOTc5fQ.mDsptmPFh3SORYOt3Mol_rZ3Dp5jBVjV7Y8erhkn4fE');
}
