From: Nicolas Bouthors <guizmow@nbi.fr>
Subject: Strange problem from 2.4.9 to 2.4.20
Date: Mon, 02 Aug 2004 09:59:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410DF47A.1060501@nbi.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chez.nicolas.bouthors.org ([82.227.155.112]:1768 "EHLO
	chez.nicolas.bouthors.org") by vger.kernel.org with ESMTP
	id S266353AbUHBH7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2004 03:59:12 -0400
Received: from nbi.fr (unknown [192.168.0.19])
	by chez.nicolas.bouthors.org (Postfix) with ESMTP id E247071C002
	for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2004 09:59:09 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I hope this is not a FAQ, I tried to look in the archives but couldn't 
find anything relevant :
I have a problem with a change of kernel. The machine is a dell with 2 
internal SCSI
drives and an external RAID array the machine has 4 Adaptec controlers 
and evetything
works fine with kernel 2.4.9 from Redhat. For testing purpose I compiled 
a 2.4.20 and
when I boot I get the following message :

(scsi2:A:3): 80.000MB/s transfers (40.000MHz DT, offset 31, 16bit)
(scsi2:A:3:0): parity error detected in Command phase. SEQADDR(0x1a2) 
SCSIRATE(0xc3)
  CRC Value Mismatch
  No terminal CRC packet recevied
  Illegal CRC packet request
  Unexpected non-DT Data Phase
scsi2:A:3: Missed busfree. Lastphase = 0xe0, Curphase = 0x0
(scsi2:A:3:0): parity error detected in Command phase. SEQADDR(0x1a2) 
SCSIRATE(0xc3)
  CRC Value Mismatch
  No terminal CRC packet recevied
  Illegal CRC packet request
  Unexpected non-DT Data Phase
scsi2:A:3: Missed busfree. Lastphase = 0xe0, Curphase = 0x0

sdc should be the external RAID array but it is not seed by Linux after 
this message and not usable.

The rest of dmesg is normal, except for this part and the hardware 
configuration didn't change,
only the kernel.

Any comment apreciated,

Thanks,

    Nicolas Bouthors


