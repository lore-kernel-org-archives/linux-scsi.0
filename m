From: "tester7 A." <benew666@hotmail.com>
Subject: Re: QLA2300, Infortrand and LBD?
Date: Tue, 22 Jun 2004 09:31:56 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BAY22-F258y61Pyp2td000a4862@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay22-f25.bay22.hotmail.com ([64.4.16.75]:47623 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S266462AbUFVAb5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 20:31:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, tech@storageone.co.kr

I have sent the those 2 questions to the Infortrend. When I get the answer, 
I will get back to you.

Thank you very much.



>From: James Bottomley <James.Bottomley@steeleye.com>
>To: "tester7 A." <benew666@hotmail.com>
>CC: SCSI Mailing List <linux-scsi@vger.kernel.org>, tech@storageone.co.kr
>Subject: Re: QLA2300, Infortrand and LBD?
>Date: 21 Jun 2004 09:09:44 -0500
>
>On Sun, 2004-06-20 at 03:43, tester7 A. wrote:
> > SCSI device sdc: 3022966784 512-byte hdwr sectors (1547759 MB)
> > SCSI device sdc: drive cache: write through
> > sdc: sdc1
> > Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0
>
>The drive itself replied with that capacity, which is incorrect.  It's
>supposed to reply with the largest possible capacity (0xffffffff) and we
>use that as a signal to retry with READ_CAPACITY_16.
>
>Could you contact the support line of the array and make sure of two
>things:
>
>1) It does actually support single LUNs with a capacity of >2TB (lots of
>arrays don't)
>2) And if 1) is true, why is it not responding correctly to the READ
>CAPACITY(10)? The spec (spc-2 Rev 8, 5.2.11) says "If the number of
>logical blocks exceeds the maximum value[...]the device server shall
>transfer FFFFFFFFh in the RETURNED LOGICAL BLOCK ADDRESS field"
>
>James
>
>

_________________________________________________________________
Add photos to your messages with MSN 8. Get 2 months FREE*. 
http://join.msn.com/?page=features/featuredemail

