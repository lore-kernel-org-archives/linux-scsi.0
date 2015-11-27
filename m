From: Felix Matouschek <felix.matouschek@vipco.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Fri, 27 Nov 2015 11:28:28 +0100
Message-ID: <5658304C.3060904@vipco.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.vipco.de ([89.238.67.2]:33164 "EHLO mail.vipco.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbbK0K6e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Nov 2015 05:58:34 -0500
Received: from [192.168.178.24] ([87.165.198.230])
	(authenticated user felix.matouschek@vipco.de)
	by mail.vipco.de (Kerio Connect 8.5.0)
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128 bits))
	for linux-scsi@vger.kernel.org;
	Fri, 27 Nov 2015 11:28:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've encountered a similiar error like Matthias Prager did in his first 
mail in this thread in 2012.

I use Debian 8 Kernel 3.16 and also own a LSI 2008 card flashed to IT 
mode (firmware P20) and have problems with disks that were spun down.
Writing to them when they are spun down usually ends in the following 
errors:

[59526.359997] sd 0:0:1:0: [sdc] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[59526.360003] sd 0:0:1:0: [sdc] CDB:
[59526.360006] Read(16): 88 00 00 00 00 00 31 28 fd 58 00 00 00 08 00 00
[59526.360022] blk_update_request: I/O error, dev sdc, sector 824769880
[59544.111090] sd 0:0:0:0: [sdb] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[59544.111097] sd 0:0:0:0: [sdb] CDB:
[59544.111100] Read(16): 88 00 00 00 00 00 31 28 fd 50 00 00 00 08 00 00
[59544.111115] blk_update_request: I/O error, dev sdb, sector 824769872
[59544.114465] sd 0:0:4:0: [sdf] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[59544.114468] sd 0:0:4:0: [sdf] CDB:
[59544.114469] Read(16): 88 00 00 00 00 00 31 28 fd 58 00 00 00 08 00 00
[59544.114483] blk_update_request: I/O error, dev sdf, sector 824769880
[59552.117436] sd 0:0:3:0: [sde] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[59552.117443] sd 0:0:3:0: [sde] CDB:
[59552.117446] Read(16): 88 00 00 00 00 00 31 28 fd b0 00 00 00 08 00 00
[59552.117462] blk_update_request: I/O error, dev sde, sector 824769968
[59572.951158] sd 0:0:2:0: [sdd] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[59572.951167] sd 0:0:2:0: [sdd] CDB:
[59572.951170] Read(16): 88 00 00 00 00 00 31 28 fd b0 00 00 00 08 00 00
[59572.951192] blk_update_request: I/O error, dev sdd, sector 824769968
[59572.955679] sd 0:0:5:0: [sdg] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[59572.955695] sd 0:0:5:0: [sdg] CDB:
[59572.955701] Read(16): 88 00 00 00 00 00 31 28 fd b0 00 00 00 08 00 00
[59572.955720] blk_update_request: I/O error, dev sdg, sector 824769968
[70357.782677] sd 0:0:4:0: [sdf] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[70357.782686] sd 0:0:4:0: [sdf] CDB:
[70357.782690] Read(16): 88 00 00 00 00 00 85 c1 c9 08 00 00 00 08 00 00
[70357.782712] blk_update_request: I/O error, dev sdf, sector 2244069640
[70368.087947] sd 0:0:0:0: [sdb] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[70368.087953] sd 0:0:0:0: [sdb] CDB:
[70368.087955] Read(16): 88 00 00 00 00 00 85 c1 c9 00 00 00 00 08 00 00
[70368.087969] blk_update_request: I/O error, dev sdb, sector 2244069632

Notice the lack of the "Device not ready" message, otherwise these 
errors look very similiars to Matthias' errors.

I have no clue what to do to fix this problem. Any suggestions?

Greetings,
Felix


