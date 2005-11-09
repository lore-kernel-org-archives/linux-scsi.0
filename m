From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.14
Date: Wed, 09 Nov 2005 12:35:11 -0600
Message-ID: <4372415F.6060702@cs.wisc.edu>
References: <1131207491.3614.5.camel@mulgrave> <20051108233546.GA21618@cs.umn.edu> <20051109050911.GA3202@infradead.org> <20051109150709.GA19002@cs.umn.edu> <4372405E.6020302@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57513 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751362AbVKISfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 13:35:22 -0500
In-Reply-To: <4372405E.6020302@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Dave C Boutcher wrote:
> 
>> On Wed, Nov 09, 2005 at 05:09:11AM +0000, Christoph Hellwig wrote:
>>
>>> On Tue, Nov 08, 2005 at 05:35:46PM -0600, Dave C Boutcher wrote:
>>>
>>>> On Sat, Nov 05, 2005 at 10:18:11AM -0600, James Bottomley wrote:
>>>>
>>>>> This is Part I of the pending SCSI patches (I still need to go over 
>>>>> all
>>>>> the flood that came in after 2.6.14 was declared).
>>>>>
>>>>> This patch is available from:
>>>>>
>>>>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-for-linus-2.6.git 
>>>>>
>>>>
>>>>
>>>> James, I note that my favorite masterpiece of ibmvscsis.c is not
>>>> currently included.  Does that fall into part of the "flood"?
>>>
>>>
>>> it shouldn't go in.  we already have a version using the proper target
>>> framework, that should be imroved upon to get production quality and 
>>> then
>>> merged.
>>
>>
>>
>> My only problem with that is the amount of time it is going to keep the
>> driver out of the tree.  I'm happy to commit to merging to a converged
>> infrastructure as soon as it is available.
>>
> 
> Your driver needs some work as it is. We are trying to kill scsi_request 
> usage, your bio segments are wrong if cluster is not used (iscsi in 
> mainline does not use clustering), and you could use bio_map_kern(). 
> There are others, but I did not review it so closely.

oh yeah we have a function to do the lun to integer stuff I beleive.
