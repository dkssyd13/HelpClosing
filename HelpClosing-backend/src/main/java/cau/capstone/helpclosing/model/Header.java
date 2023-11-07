package cau.capstone.helpclosing.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Header<T> {

    //api 결과
    private boolean result;

    //api 통신 설명
    private String description;

    private T value;

    // OK
    public static <T> Header<T> OK() {
        return (Header<T>) Header.builder()
                .result(true)
                .build();
    }

    // OK description
    public static <T> Header<T> OK(String description) {
        return (Header<T>) Header.builder()
                .description(description)
                .result(true)
                .build();
    }

    // DATA OK
    public static <T> Header<T> OK(T data, String description) {
        return (Header<T>)Header.builder()
                .description(description)
                .result(true)
                .value(data)
                .build();
    }

    // ERROR
    public static <T> Header<T> ERROR(String description) {
        return (Header<T>)Header.builder()
                .result(false)
                .description(description)
                .build();
    }

}