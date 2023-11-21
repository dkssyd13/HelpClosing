package cau.capstone.helpclosing.FCM;


import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Repository;

@Repository
public class FCMCRUD {

    public static final String COLLECTION_NAME_TOKEN = "Token";


    //유저 이메일에 따라 토큰 불러오기
    public FCMToken getFCMToken(String email) throws Exception {
        Firestore firestore = FirestoreClient.getFirestore();
        DocumentReference dr = firestore.collection(COLLECTION_NAME_TOKEN).document(email);
        ApiFuture<DocumentSnapshot> apiFuture = dr.get();
        DocumentSnapshot ds = apiFuture.get();
        FCMToken fcmToken = null;

        if(ds.exists()) {
            fcmToken = ds.toObject(FCMToken.class);
            return fcmToken;
        } else {
            return null;
        }
    }


    //저장하기ㅇㅇ 업데이트도 포함
    public String insertFCMToken(FCMToken fcmToken) throws Exception {
        Firestore firestore = FirestoreClient.getFirestore();
        if (getFCMToken(fcmToken.getEmail()) == null){
            ApiFuture<WriteResult> apiFuture = firestore.collection(COLLECTION_NAME_TOKEN).document(fcmToken.getEmail()).set(fcmToken);
            return apiFuture.get().getUpdateTime().toString();
        }
        else{
            ApiFuture<WriteResult> apiFuture = firestore.collection(COLLECTION_NAME_TOKEN).document(fcmToken.getEmail()).set(fcmToken);
            return apiFuture.get().getUpdateTime().toString();
        }
    }

//
//    public String updateFCMToken(FCMToken fcmToken) throws Exception {
//        if (getFCMToken(fcmToken.getEmail()) == null){
//            return insertFCMToken(fcmToken);
//        }
//        else {
//            ApiFuture<WriteResult> apiFuture = firestore.collection(COLLECTION_NAME_TOKEN).document(fcmToken.getEmail()).set(fcmToken);
//            return apiFuture.get().getUpdateTime().toString();
//        }
//    }

    public String deleteFCMToken(String email) throws Exception{
        Firestore firestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> apiFuture = firestore.collection(COLLECTION_NAME_TOKEN).document(email).delete();
        return apiFuture.get().getUpdateTime().toString() + email + "'s token deleted";
    }

    //유저 이메일에 따라 토큰 저장하고 불러오고 삭제하고 ㅇㅇ
}
