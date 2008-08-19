From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc class: terminate callback fixes
Date: Tue, 19 Aug 2008 11:37:06 -0400
Message-ID: <48AAE8A2.2090702@emulex.com>
References: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu> <48A89016.5080807@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41459 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYHSPhW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2008 11:37:22 -0400
In-Reply-To: <48A89016.5080807@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yep - I just sent the ack...

Thanks

-- james s

Mike Christie wrote:
> michaelc@cs.wisc.edu wrote:
>> This fixes the problems discussed in this thread:
>> http://marc.info/?l=linux-scsi&m=121573444523292&w=2
>> where we need to call scsi_target_unblock in the code
>> path where the terminate call back is used. The unblock calls is
>> need so that IO does not get stuck when removing the rport. And for
>> the fast IO fail case, I merged the patch to fast fail
>> IO so it does not bounce around between the queue
>> and driver and is returned to the upper layer quickly.
>> These patch then solve all the issues and fix the problem
>> for drivers that were not implementing the callback.
>>
>> The patches were made over scsi-misc and the qlogic update
>> in that thread.
>>
> 
> Hey JamesS,
> 
> Are these patches ok?
> 
