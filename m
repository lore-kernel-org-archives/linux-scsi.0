From: "James Daniel" <jdaniel@dakotacom.net>
Subject: Re: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel Errors
Date: Thu, 18 Dec 2003 19:14:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <003601c3c5d5$e31bed30$0200000a@nightsky>
References: <Pine.LNX.4.44.0312180142350.27247-200000@dyn319634.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from breaker.dakotacom.net ([66.192.152.146]:52948 "EHLO
	breaker.dakotacom.net") by vger.kernel.org with ESMTP
	id S265419AbTLSCOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 21:14:16 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <mikenc@us.ibm.com>

> Try the attached patch. It was built against 2.6.0-test11. I do not have
> the HW and the other testers I know about are only using their card for
> scsi cd writers, so I only know it compiles.
>
>
> mike

// all prior lines same as previous, including the error handler messages..
SCSI device sda: drive cache: write back
sda:/*~25 second pause*/scsi: Device offlined - not ready after error
recover: host 0 channel 0 id 1 lun 0
SCSI error : <0 0 1 0> return code - 0x6000000
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
scsi0 (1:0): rejection I/O to offline device
Buffer I/O error on device sda, logical block 0
 unable to read partition table
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0

still no root fs.

The errors have changed.. and I consider that a degree of progress. Thank
you Mike :)

-- James Daniel

