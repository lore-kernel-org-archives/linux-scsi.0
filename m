From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel
 Errors
Date: Fri, 19 Dec 2003 01:26:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FE2C440.5050305@us.ibm.com>
References: <Pine.LNX.4.44.0312180142350.27247-200000@dyn319634.beaverton.ibm.com> <003601c3c5d5$e31bed30$0200000a@nightsky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:45526 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262114AbTLSJ0c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 04:26:32 -0500
In-Reply-To: <003601c3c5d5$e31bed30$0200000a@nightsky>
List-Id: linux-scsi@vger.kernel.org
To: James Daniel <jdaniel@dakotacom.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>


> // all prior lines same as previous, including the error handler messages..
> SCSI device sda: drive cache: write back
> sda:/*~25 second pause*/scsi: Device offlined - not ready after error
> recover: host 0 channel 0 id 1 lun 0
> SCSI error : <0 0 1 0> return code - 0x6000000
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> scsi0 (1:0): rejection I/O to offline device
> Buffer I/O error on device sda, logical block 0
>  unable to read partition table
> Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
> 

Ok, in the orginal patch I forgot to replace the shared buffer with a 
DMA-API equiv. This will take some time.

mike

