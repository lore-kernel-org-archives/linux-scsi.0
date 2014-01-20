From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] [ATTEND] scsi_eh updates
Date: Mon, 20 Jan 2014 11:05:20 -0800
Message-ID: <1390244720.341.30.camel@dabdike.int.hansenpartnership.com>
References: <D63B9804CB63AD4FAAD9660376956646470290B2@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56962 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaATTFY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jan 2014 14:05:24 -0500
In-Reply-To: <D63B9804CB63AD4FAAD9660376956646470290B2@avmb2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2014-01-20 at 18:44 +0000, Giridhar Malavali wrote:
> 
> On 12/20/13 6:54 AM, "Hannes Reinecke" <hare@suse.de> wrote:
> 
> >Hi all,
> >
> >(before leaving for holiday ...)
> >
> >I'd like to attend LSF 2014.
> >
> >During that I'd like to discuss the current status of the SCSI EH
> >and the future planned updates.
> >
> >As discussed during last year's LSF the SCSI error handler should be
> >updated to handle modern SCSI transports better.
> >While some patchsets are already merged, there are some issues which
> >are still open:
> >- Handling of requests during host reset:
> >  Do we need to keep hold of outstanding requests during host reset?
> >  Or is it save to return them prior to host reset?
> >- Check for transport status prior to sending TMFs.
> >  Task management functions typically need a working I_T nexus,
> >  so it does make sense to first check the transport status
> >  prior to attempting any TMFs
> >- Further steps for updating SCSI EH
> >As these are tricky issues which have possible repercussions on the
> >entire subsystem and LLDDs it'd be good to have a broader discussion
> >here.
> 
> +1
> 
> I would like to participate in this discussion to provide inputs from
> LLDDs.

For the last time, this isn't the way to ask for a place.  You need to
send in an ATTEND request according to the CFP.

http://marc.info/?l=linux-scsi&m=138753185305739

Thanks,

James



