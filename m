From: Larkin Lowrey <llowrey@gmail.com>
Subject: Re: mvsas sata drives with high ioerr_cnt and long stalls
Date: Thu, 16 Nov 2017 21:11:02 -0500
Message-ID: <d5c8b3f2-4f60-4e94-3c4d-a762d5308a5b@gmail.com>
References: <2efdd536-caa8-8da7-9c82-58d63670eb57@gmail.com>
 <33f1827f-e4fa-11a2-1c2f-94c7a4958d3b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:39911 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754930AbdKQCLI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2017 21:11:08 -0500
Received: by mail-vk0-f47.google.com with SMTP id t184so856200vka.6
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 18:11:08 -0800 (PST)
Received: from ?IPv6:2601:6c5:8000:1480:54ff:ba2b:b29:792c? ([2601:6c5:8000:1480:54ff:ba2b:b29:792c])
        by smtp.gmail.com with ESMTPSA id 4sm1592383vkq.43.2017.11.16.18.11.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Nov 2017 18:11:06 -0800 (PST)
In-Reply-To: <33f1827f-e4fa-11a2-1c2f-94c7a4958d3b@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's another error. This time I was doing a sequential write to a 
single drive.

[ 2546.890238] ata12: log page 10h reported inactive tag 30
[ 2546.895887] ata12.00: exception Emask 0x1 SAct 0x1 SErr 0x0 action 0x6
[ 2546.902780] ata12.00: failed command: WRITE FPDMA QUEUED
[ 2546.908404] ata12.00: cmd 61/00:00:00:4c:0e/04:00:05:00:00/40 tag 0 
ncq dma 524288 out
[ 2546.908404]          res 01/04:f0:00:48:0e/00:00:05:00:00/40 Emask 
0x3 (HSM violation)
[ 2546.925209] ata12.00: status: { ERR }
[ 2546.929165] ata12.00: error: { ABRT }
[ 2546.933105] ata12: hard resetting link
[ 2547.097692] ata12.00: configured for UDMA/100
[ 2547.102363] ata12: EH complete

--Larkin
