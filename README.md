# Capstone_Design2  
## 요약  
DHM(Digital Holographic Microscopy)을 통해 얻게 되는 fringe pattern을 그대로 압축시키는 방식보다 그 중 일부인 phase를 압축시키는 방식이 더 큰 성능이 있음이 증명되었다. 이때 phase를 압축시키기 위해 phase를 wrapping했다가 원래대로 복구시키기 위해 unwrapping하는 과정(phase retrieval)이 이뤄지게 된다. 여러 unwrapping방법 중 딥러닝을 기반으로 한 unwrapping방법에 대해 분석하며 이를 다른 알고리즘 방법들과 비교한다.

## Phase Unwrapping(Puma & DCT)
Fringe Pattern을DHM에 있는 CCD센서를 통해 얻은 이미지라고 할 때 그 이미지가 8bit의 표현범위를 갖는다고 가정한다면 0~255사이의 정수 값을 가지게 된다. 여기서 물체의 두께를 알고자 한다면 실수로 표현되는 위상 값을 알아야 한다([그림4-(1)]). 이 뿐만 아니라 두께에 따른 정확한 위상을 알기 위해 Wrapping된 위상을 원래의 위상 값으로 복원하는 작업이 필요하게 된다. 이때 Wrapping된 위상은 그 위상 값이 0에서 2π범위에 속하게 된다. 다시 말하면 이미지에서 Wrapping된 위상을 분리하는 위상 추출과정과 추출된 위상을 원래의 위상 값으로 복원하는 Phase unwrapping과정이 필요하다([그림4-(2)]).   
![image](https://user-images.githubusercontent.com/68431716/204094211-80c90ee7-5216-4d01-b2a1-489b1f6241e2.png)
![image](https://user-images.githubusercontent.com/68431716/204094216-136d0bdf-6022-47ba-b6a1-b551bec9802f.png)   
                                          [그림 4 홀로그램 압축 방식] 


*Puma와 DCT의 소스코드가 들어있으며 정확한 위상값의 범위를 맞춰야 한다.

## Res-UNet 모델  
이 구조는 기본적으로 residual network와 U-Net구조를 따르고 있다. 크게 왼쪽(contracting path), 가운데(bridge), 오른쪽(expanding path)3부분으로 나눠서 볼 수 있다. 왼쪽부분은 두번의 3x3 convolution 연산(BN과 ReLU)이 5번 반복되어서 사용된다. 이때 연산이 바로 이어서 진행되는 것이 아니라 중간에 두 연산의 위치 가운데에 residual block이 사용되었다. 가운데 부분은 왼쪽 부분에서 max pooling을 제거함으로써 얻고 오른쪽 부분은 왼쪽과 거의 동일한 구조를 가진다. 왼쪽부분과 오른쪽 부분의 차이를 보자면, 왼쪽 부분은 여러 개의 convolution layer의 특징 추출을 통해 input space의 정보를 더 추상적이고 high-level feature로 변환시키는 데에 반해 오른쪽 부분은 이러한 추상적이고 high-level의 정보를 여러 개의 deconvolution layer를 거쳐 output space의 표현으로 변환된다. 즉 왼쪽 부분은 downsampling을, 오른쪽 부분은 upsampling을 한다고 이해할 수 있다.
Res-UNet 모델의 구조 및 train,test function이 포함되어 있다.  
![image](https://user-images.githubusercontent.com/68431716/204094300-865f7948-aff8-4824-8b81-dffb7c676768.png)  
                                          [그림 6 U-Net 기반 모델의 구조]    


