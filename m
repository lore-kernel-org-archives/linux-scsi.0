From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 0/9] RFC: handle queue_depth adjustments because of
 QUEUE_FULLs in scsi_error.c
Date: Tue, 01 Sep 2009 20:46:05 -0500
Message-ID: <4A9DCE5D.2040208@cs.wisc.edu>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com> <1251845853.27437.69.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54259 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZIBBqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 21:46:13 -0400
In-Reply-To: <1251845853.27437.69.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: linux-scsi@vger.kernel.org

On 09/01/2009 05:57 PM, Vasu Dev wrote:
> On Wed, 2009-08-26 at 11:03 -0700, Vasu Dev wrote:
>> First four patches are from Mike Christie's original RFC at:-
>>
>> http://www.spinics.net/lists/linux-scsi/msg35959.html
>> http://www.spinics.net/lists/linux-scsi/msg35962.html
>> http://www.spinics.net/lists/linux-scsi/msg35961.html
>> http://www.spinics.net/lists/linux-scsi/msg35963.html
>> http://www.spinics.net/lists/linux-scsi/msg35964.html
>>
>> Above four patches adds ramp down code and I appended ramp
>> up code in following patches and tested this entire
>> series with libfc/fcoe. This series works fine without any
>> regression and also queue_depth adjustment works for both
>> ramp down and ramp up.
>>
>> Above patches are updated to scsi-misc -rc7 plus recently
>> submitted 64 fcoe patches series by Rob
>> "[PATCH 00/64] libfc, libfcoe and fcoe updates for scsi-misc"
>> This series also applies cleanly to scsi-misc -rc7.
>>
>> I'd appreciate review comments for added more patches for
>> ramp up.
>>
>> I'll post my final patches to this list skipping fcoe list,
>> this as per Rob Love suggestion since mostly scsi changes
>> by this series beyond fcoe/libfc. However Rob agreed to
>> review/Ack fcoe/libfc changes at this list.
>>
>> Mike, I'll be able to post my ramp up patches only once
>> you send final patches for ramp down on which my patches
>> depends. As I said your patches are tested for libfc,
>> so most common code is already tested and they are
>> good go as far as libfc goes.
>>
>
> Hey Mike,
>
> 	I'd like to get final patches of this series out this week to
> get them into next merge window but not sure how to get final patches
> out with your first four RFC patches in this series on which rest all
> patches depends. Please help me on this.
>



You should just post your patches with mine. I do not have time to test 
my stuff right now with the current kernel, and since you need them and 
are going to have to test your patches just make it easy for 
James/reviewers and send it all in one patchset so people do not have to 
search for dependencies.

For my patches just add your signed off after mine, since you are 
sending them and I had written them.

You can/should probably also pick up Christop's stuff too for him (zfcp 
patches).
