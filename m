From: Jason Harrop <jharrop@speedlegal.com>
Subject: PERC3/Di crashes, even with kernel 2.4.25 and aacraid 1.1.5
Date: Sat, 10 Apr 2004 12:03:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <407755DB.8000800@speedlegal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.xn.com.au ([203.89.254.34]:34477 "HELO ns.xn.com.au")
	by vger.kernel.org with SMTP id S261791AbUDJCHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 22:07:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-poweredge@dell.com

Dell 2650 BIOS A15
PERC3/Di firmware 3170
ext3 filesystem

It crashed less than 2 days after rebooting, which is less uptime than 
with RedHat kernel 2.4.18-14smp

See below for contents of log.

cheers,

Jason

--------------

Apr 10 04:03:51 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:04:51 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:05:01 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:06:01 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:06:11 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:07:11 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:07:21 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:08:21 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:08:31 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:09:31 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:09:41 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:10:41 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:10:51 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
:
Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
Apr 10 04:15:31 promo kernel: scsi: device set offline - command error 
recover failed: host 0 channel 0 id 0 lun 0
Apr 10 04:15:31 promo kernel: SCSI disk error : host 0 channel 0 id 0 
lun 0 return code = 6000000
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 11014520
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 12058624
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 12058856
:
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 39846008
Apr 10 04:15:31 promo kernel:  I/O errev 08:03, sector 262368
:
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 19398840
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 19398856
Apr 10 04:15:31 promo kernel:  I/O error: dev 0 sector 9464
Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 74856



