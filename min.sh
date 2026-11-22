#!/bin/bash

if [ -z "$1" ]
then
	echo "No file input"
else
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90',setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "default-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:mc_mode=aobmc,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "aombc-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:me_mode=bidir,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "bidir-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:me=esa,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "esa-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:me=umh,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "umh-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:mb_size=4,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "mbsize-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:search_param=64,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "search_param-${1%.*}.mp4"
	ffmpeg -ss 5 -i "$1" -vf "minterpolate='fps=90':mi_mode=mci:vsbmc=1,setpts=N/(29.97*TB)" -r 29.97 -t 15 -an -c:v libx264 -crf 21 -pix_fmt yuv420p -preset fast "vsbmc-${1%.*}.mp4"
fi