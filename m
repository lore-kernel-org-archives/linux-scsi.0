From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 10:35:13 -0500
Message-ID: <49146031.70003@hp.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com> <49145E0C.4030705@hp.com> <Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6424 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYKGPfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 10:35:17 -0500
In-Reply-To: <Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

David Woodhouse wrote:
> On Fri, 7 Nov 2008, jim owens wrote:
> 
>> Ric Wheeler wrote:
>>
>>> The type of allocation that would help most is something that tries 
>>> to keep the lower block ranges "hot" for allocation, second best 
>>> policy would simply keep the allocated blocks in each block group hot 
>>> and re-allocate them.
>>
>> This block reuse policy ignores the issue of wear leveling...
>> as in most design things, trading one problem for another.
> 
> For SSDs we're being told not to worry our pretty little heads about 
> wear levelling. That gets done for us, with varying degrees of 
> competence, within the black box. All we can do to improve that is 
> pray... and maybe sacrifice the occasional goat.
> 

I'm talking DISK wear not SSD.  The array vendors who are causing
this problem are doing petabyte san devices, not SSDs.

Rewriting the same sectors causes more bad block remaps
until the drive eventually runs out of remap space.



