/////////////////// task1
module tb;
int arr1[] = '{9,7,4,6,2,8,6,5};
int e_arr[$];
int o_arr[$];
initial begin
        foreach(arr1[i])begin
            if (arr1[i] % 2 == 0) //even
                e_arr.push_back(arr1[i]);
            else //odd
                o_arr.push_back(arr1[i]);
        end
    $display("even array:%p",e_arr);
    $display("even array:%p",o_arr);
end








//////////////////// task2

    // int arr[] = '{1,1,0,1,1,1,1,0,0,0,1};
    int arr2[] = '{3,3,0,4,4,4,4,0,0,0,1};

    int counter;
    int f_num;
    int f_count;
    initial begin
    f_num = arr2[0];
    f_count = 1;
    counter = 1;
        for (int i = 0; i < arr2.size() - 1; i++)begin

            if (arr2[i] == arr2[i+1])begin
                    ++counter;
            end else begin
                counter = 1;
            end


            if (counter > f_count) begin
            f_count = counter;
            f_num = arr2[i];
            end
        end
//     f_num = 3;f_count = 1 ;counter = 1;arr[0] = 3  befor loop
//     f_num = 3;f_count = 1 ;counter = 2;arr[0] = 3
//     f_num = 3;f_count = 1 ;counter = 2;arr[1] = 3
//     f_num = 3;f_count = 2 ;counter = 1;arr[2] = 0
//     f_num = 3;f_count = 2 ;counter = 1;arr[3] = 4
//     f_num = 3;f_count = 2 ;counter = 2;arr[4] = 4
//     f_num = 4;f_count = 3 ;counter = 3;arr[5] = 4
//     f_num = 4;f_count = 4 ;counter = 4;arr[6] = 4
//     f_num = 4;f_count = 4 ;counter = 1;arr[7] = 0
//     f_num = 4;f_count = 4 ;counter = 2;arr[8] = 0
//     f_num = 4;f_count = 4 ;counter = 3;arr[9] = 0

        $display("number has max consecutive : %d " ,f_num );
        $display("max consecutive : %d " ,f_count );

    end
    







//////////////////// task3


int arr3[] = '{45, 34, 67, 89, 78};
int max1;
int max2;
int arr4 [$];// arr3 // without max1
  initial begin
    max1 = arr3.max()[0]; // max1
    // max2 = arr3.max() with (item < max1);// max2 is smaller than max one
    foreach (arr3[i])
        if (arr3[i] != max1)
            arr4.push_back(arr3[i]);
    max2 = arr4.max()[0];

    $display("Second Max = %0d", max2);
  end







//////////////////// task4


int arr5[] = '{3, 3, 4, 5, 6, 3, 5, 4, 6, 8, 7, 6, 4, 3, 5, 6};
int freq[int]; // associative arrays to store the number as an index and the count as a value
int number ;
  initial begin
    foreach (arr5[i]) begin
        number =arr5[i]; //the number represent its owne number on the array
        freq[number]++; //counts of this number
    end
    
    foreach (freq[i]) begin
      $display("num %0d : %0d", i, freq[i]);
    end
end
endmodule