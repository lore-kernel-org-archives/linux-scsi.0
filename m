From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: QLA2300, Infortrand and LBD?
Date: Mon, 21 Jun 2004 07:28:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA20433950@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:62420 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S264165AbUFUO2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2004 10:28:12 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, "tester7 A." <benew666@hotmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, tech@storageone.co.kr

Is this true of both 2.4 and 2.6 ?

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>owner@vger.kernel.org] On Behalf Of James Bottomley
>>Sent: Monday, June 21, 2004 9:10 AM
>>To: tester7 A.
>>Cc: SCSI Mailing List; tech@storageone.co.kr
>>Subject: Re: QLA2300, Infortrand and LBD?
>>
>>On Sun, 2004-06-20 at 03:43, tester7 A. wrote:
>>> SCSI device sdc: 3022966784 512-byte hdwr sectors (1547759 MB)
>>> SCSI device sdc: drive cache: write through
>>> sdc: sdc1
>>> Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0
>>
>>The drive itself replied with that capacity, which is incorrect.  It's
>>supposed to reply with the largest possible capacity (0xffffffff) and
we
>>use that as a signal to retry with READ_CAPACITY_16.
>>
>>Could you contact the support line of the array and make sure of two
>>things:
>>
>>1) It does actually support single LUNs with a capacity of >2TB (lots
of
>>arrays don't)
>>2) And if 1) is true, why is it not responding correctly to the READ
>>CAPACITY(10)? The spec (spc-2 Rev 8, 5.2.11) says "If the number of
>>logical blocks exceeds the maximum value[...]the device server shall
>>transfer FFFFFFFFh in the RETURNED LOGICAL BLOCK ADDRESS field"
>>
>>James
>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
