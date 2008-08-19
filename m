From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: fc class: terminate callback fixes
Date: Tue, 19 Aug 2008 18:46:44 -0500
Message-ID: <48AB5B64.9010604@cs.wisc.edu>
References: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu> <48A89016.5080807@cs.wisc.edu> <48AAE8A2.2090702@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50532 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbYHSXqv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:46:51 -0400
In-Reply-To: <48AAE8A2.2090702@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> Yep - I just sent the ack...
> 

Ok. I will rediff for the current scsi-misc and fix up the bit setting 
and resend.

Thanks.

> Thanks
> 
> -- james s
> 
> Mike Christie wrote:
>> michaelc@cs.wisc.edu wrote:
>>> This fixes the problems discussed in this thread:
>>> http://marc.info/?l=linux-scsi&m=121573444523292&w=2
>>> where we need to call scsi_target_unblock in the code
>>> path where the terminate call back is used. The unblock calls is
>>> need so that IO does not get stuck when removing the rport. And for
>>> the fast IO fail case, I merged the patch to fast fail
>>> IO so it does not bounce around between the queue
>>> and driver and is returned to the upper layer quickly.
>>> These patch then solve all the issues and fix the problem
>>> for drivers that were not implementing the callback.
>>>
>>> The patches were made over scsi-misc and the qlogic update
>>> in that thread.
>>>
>>
>> Hey JamesS,
>>
>> Are these patches ok?
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

