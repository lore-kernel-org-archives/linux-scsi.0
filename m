From: Mehul <mis06ec@yahoo.co.in>
Subject: Query regarding data transfer in UFS
Date: Sat, 2 Aug 2014 03:22:15 +0000 (UTC)
Message-ID: <loom.20140802T052135-709@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33086 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaHBEaK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Aug 2014 00:30:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XDQxJ-0000kK-0r
	for linux-scsi@vger.kernel.org; Sat, 02 Aug 2014 06:30:05 +0200
Received: from 103.255.224.90 ([103.255.224.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 02 Aug 2014 06:30:05 +0200
Received: from mis06ec by 103.255.224.90 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 02 Aug 2014 06:30:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am new to UFS. I have few queries in it,

(1) As per UFS specification, WRITE(6,10,16) command is used to transfer 
logical blocks and WRITE BUFFER is used to transfer data in terms of bytes.
So, here my query is, what is the difference between those two commands as in 
both case data is transferred?  

(2) In WRITE(6, 10, 16) and WRITE BUFFER command, both buffer and cache memory 
will be written? If yes, then how to control data length in WRITE BUFFER as 
host is transmitting in terms of bytes while cache will be controlled through 
logical block?

(3) Does below arch. is correct?
UFS_HOST => UFS_DEVICE => BUFFER => CACHE_RAM
i.e. UFS host transfers command to UFS device. For data transmission, UFS 
device will send RTT based on buffer size. Then UFS host sends DATA OUT 
command and UFS device will first store it into buffer. Then it will be 
written into cache memory.

(4) In write command, host is driving logical address. But in Ready-to-
transfer and DATA OUT/DATA IN command, data buffer offset is provided. Then, 
how the device will handle this data for storing as logical block at 
particular logical address?

Thank you,
Mehul

