From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: read capacity 16
Date: Thu, 9 Dec 2004 06:33:15 -0800
Message-ID: <47F3C2BE74738E4683574107469DFA206783D7@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:54347 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S261469AbULIOdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 09:33:18 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>, linux-scsi@vger.kernel.org

This works as expected using SGI's 2.6.5-rc3-mm4 on ia64 and on Windows
server 2003 SP1 (still a beta).
Does anyone know how to get kernels > than 2.4.19 to work ?

I tried setting max_cmd_len to 16 in hosts.c, but it doesn't change
anything.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Frank Borich
Sent: Wednesday, December 08, 2004 3:08 PM
To: linux-scsi@vger.kernel.org
Subject: read capacity 16

Please forgive my ignorance here.  
 
I am unable to get the kernel (2.4.21) to send a read capacity 16 to a
lun that requires more than 4 bytes to specify it's last LBA,
automatically.
If I
use the sg driver to send a read capacity 16 staraight away, it works
fine.  
I am using the qlogic device driver 7.00.03 (which I believe supports 16
byte commands).  
 
When I do the bus scan (using modprobe), a READ CAPACITY 10 is sent and
FFFFFFFF is returned in LBA field, this should signal linux kernel to
send larger READ CAPACITY 16 to get correct size but it's not.  Instead
the lun is seen as 0 MB in size.  
 
I can't seem to find any good documentation on this.  Can I patch this
kernel to do this ?
 
Regards,
 
Frank
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
