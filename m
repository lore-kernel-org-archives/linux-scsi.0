From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] block: Ensure physical block size is unsigned int
Date: Wed, 13 Oct 2010 15:12:59 -0400
Message-ID: <20101013191258.GA3172@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <1285605664-27027-2-git-send-email-martin.petersen@oracle.com>
 <20100927174052.GA14180@redhat.com>
 <yq1hbgxs1rm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0JMTND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 15:13:03 -0400
Content-Disposition: inline
In-Reply-To: <yq1hbgxs1rm.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Fri, Oct 08 2010 at  1:15am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> Physical block size was declared unsigned int to accomodate the
> >> maximum size reported by READ CAPACITY(16).  Make sure we use the
> >> right type in the related functions.
> >> 
> >> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Mike> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> Jens, ping on the block fix.
> 
> James, ping on the sd ditto.

Hi Jens,

James had added the sd fix to his scsi-misc-2.6 tree:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=526f7c7950b

Any chance you can stage the block fix for-2.6.37?

(guess its too late for 2.6.36... maybe cc: stable when adding to the
block fix to your tree?  with a requires on the sd fix?)

Thanks,
Mike
