import torch
print('PyTorch:', torch.__version__)
print('CUDA disponível:', torch.cuda.is_available())
print('Versão CUDA:', torch.version.cuda)
print('Número de GPUs:', torch.cuda.device_count())
for i in range(torch.cuda.device_count()):
    print(f'  GPU {i}:', torch.cuda.get_device_name(i))
