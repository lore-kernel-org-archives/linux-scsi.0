From: "Parthiban M" <parthi_m@hotmail.com>
Subject: Memory leak trace utility for kernel module !
Date: Fri, 29 Nov 2002 16:44:58 +0530
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <F136CASlDxzcIZChJhX0001c50a@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: pamanick@npd.hcltech.com
List-Id: linux-scsi@vger.kernel.org

Hello all,

      I've implemented linux kernel modules "for IP storage " using 
kernel(2.4.18-3)
socket's and sending/receiving data of size more than MBs. I'm iteratively 
doing
copy operation to remote machine after 15 hours my machine running out of 
memory, seems to be memory leak in my driver.

plz let me know any memory trace utility available for linux 
kernel(2.4.18-3) or any
info. regarding my problem.

Thx,
Parthi.

Note : haven't enabled kernel preemption patch in my running kernel.



_________________________________________________________________
STOP MORE SPAM with the new MSN 8 and get 2 months FREE* 
http://join.msn.com/?page=features/junkmail
