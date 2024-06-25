#!/bin/bash
PROMPT_VERSION=llava_v1
# DATA_ROOT=./playground/data
model_size=7b

deepspeed --master_port 12347 llava/train/train_mem.py \
    --deepspeed ./scripts/zero2.json \
    --model_name_or_path model_weights \
    --version $PROMPT_VERSION \
    --data_path jsons/rename_full_hand_made_v3.json \
    --image_folder training_dataset/ \
    --vision_tower clip_4layers_336 \
    --mm_projector_type mlp2x_gelu \
    --mm_vision_select_layer -2 \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --image_aspect_ratio pad \
    --bf16 True \
    --output_dir ./checkpoints \
    --num_train_epochs 10 \
    --per_device_train_batch_size 8 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 1 \
    --save_epochs 10 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 500000 \
    --save_total_limit 1 \
    --learning_rate 2e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 2048 \
    --gradient_checkpointing True \
    --dataloader_num_workers 4 \
    --lazy_preprocess True \