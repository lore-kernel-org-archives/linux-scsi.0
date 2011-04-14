From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.39-rc3-git3 crashs after booting
Date: Thu, 14 Apr 2011 13:32:32 -0500
Message-ID: <1302805952.9800.7.camel@mulgrave.site>
References: <web-504663160@zbackend1.aha.ru>
	 <20110414104039.c0e655bd.akpm@linux-foundation.org>
	 <1302803619.9800.4.camel@mulgrave.site>  <20110414181514.GA13977@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59315 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964806Ab1DNScf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 14:32:35 -0400
In-Reply-To: <20110414181514.GA13977@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>, gregkh@suse.de, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, 2011-04-14 at 20:15 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > +	/* temporary expedient, try to catch use of queue lock after
> > +	 * free of sdev */
> > +	sdev->request_queue = NULL;
> 
> Couldnt help to notice this small ugliness while skimming the patch - please 
> use the customary (multi-line) comment style:
> 
>   /*
>    * Comment .....
>    * ...... goes here.
>    */

It's just code motion, so it was cut and paste.  The actual file is a
nasty mix of comment styles, so it doesn't really matter one way or the
other.

James


