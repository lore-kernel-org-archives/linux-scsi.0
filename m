From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: QLA2300, Infortrand and LBD?
Date: Wed, 28 Jul 2004 06:46:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CC855@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:40953 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266914AbUG1NqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2004 09:46:14 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "tester7 A." <benew666@hotmail.com>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, tech@storageone.co.kr

Looking at an FC trace on an Infortrend controller I have, shows that
for a LUN 3586680 MB in size, the LBA is B5D3BFFF in the "RETURNED
LOGICAL BLOCK ADDRESS FIELD" 
and with in the "BLOCK LENGTH IN BYTES FIELD" field is 200h , ( B5D3BFFF
* 200h =  approx. 1.6 TB). Seems that infortrend does NOT respond
properly to READ_CAPACITY_10, at least in my case. 
James, this may be a dumb question, please excuse my ignorance of the
internals of the scsi subsystem, 
but is there a plan to implement LBD support in the 2.4 tree ?

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 
 

>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org 
>>[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of tester7 A.
>>Sent: Monday, June 21, 2004 7:32 PM
>>To: James.Bottomley@steeleye.com
>>Cc: linux-scsi@vger.kernel.org; tech@storageone.co.kr
>>Subject: Re: QLA2300, Infortrand and LBD?
>>
>>I have sent the those 2 questions to the Infortrend. When I 
>>get the answer, I will get back to you.
>>
>>Thank you very much.
>>
>>
>>
>>>From: James Bottomley <James.Bottomley@steeleye.com>
>>>To: "tester7 A." <benew666@hotmail.com>
>>>CC: SCSI Mailing List <linux-scsi@vger.kernel.org>, 
>>>tech@storageone.co.kr
>>>Subject: Re: QLA2300, Infortrand and LBD?
>>>Date: 21 Jun 2004 09:09:44 -0500
>>>
>>>On Sun, 2004-06-20 at 03:43, tester7 A. wrote:
>>> > SCSI device sdc: 3022966784 512-byte hdwr sectors 
>>(1547759 MB) SCSI 
>>> > device sdc: drive cache: write through
>>> > sdc: sdc1
>>> > Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0
>>>
>>>The drive itself replied with that capacity, which is 
>>incorrect.  It's 
>>>supposed to reply with the largest possible capacity 
>>(0xffffffff) and 
>>>we use that as a signal to retry with READ_CAPACITY_16.
>>>
>>>Could you contact the support line of the array and make sure of two
>>>things:
>>>
>>>1) It does actually support single LUNs with a capacity of 
>>>2TB (lots 
>>>of arrays don't)
>>>2) And if 1) is true, why is it not responding correctly to the READ 
>>>CAPACITY(10)? The spec (spc-2 Rev 8, 5.2.11) says "If the number of 
>>>logical blocks exceeds the maximum value[...]the device server shall 
>>>transfer FFFFFFFFh in the RETURNED LOGICAL BLOCK ADDRESS field"
>>>
>>>James
>>>
>>>
>>
>>_________________________________________________________________
>>Add photos to your messages with MSN 8. Get 2 months FREE*. 
>>http://join.msn.com/?page=features/featuredemail
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe 
>>linux-scsi" in the body of a message to 
>>majordomo@vger.kernel.org More majordomo info at  
>>http://vger.kernel.org/majordomo-info.html
>>
>>
