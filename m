From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] block: Ensure physical block size is unsigned int
Date: Wed, 13 Oct 2010 21:15:54 +0200
Message-ID: <4CB6056A.2040002@fusionio.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com> <1285605664-27027-2-git-send-email-martin.petersen@oracle.com> <20100927174052.GA14180@redhat.com> <yq1hbgxs1rm.fsf@sermon.lab.mkp.net> <20101013191258.GA3172@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58225 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0JMTQF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 15:16:05 -0400
In-Reply-To: <20101013191258.GA3172@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-10-13 21:12, Mike Snitzer wrote:
> On Fri, Oct 08 2010 at  1:15am -0400,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
>>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
>>
>>>> Physical block size was declared unsigned int to accomodate the
>>>> maximum size reported by READ CAPACITY(16).  Make sure we use the
>>>> right type in the related functions.
>>>>
>>>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>
>> Mike> Acked-by: Mike Snitzer <snitzer@redhat.com>
>>
>> Jens, ping on the block fix.
>>
>> James, ping on the sd ditto.
> 
> Hi Jens,
> 
> James had added the sd fix to his scsi-misc-2.6 tree:
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=526f7c7950b
> 
> Any chance you can stage the block fix for-2.6.37?
> 
> (guess its too late for 2.6.36... maybe cc: stable when adding to the
> block fix to your tree?  with a requires on the sd fix?)

Yep will do, and mark for stable.

-- 
Jens Axboe

