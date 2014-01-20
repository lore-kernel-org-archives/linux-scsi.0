From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM TOPIC] [ATTEND] scsi_eh updates
Date: Mon, 20 Jan 2014 13:55:23 +0100
Message-ID: <52DD1CBB.6050708@acm.org>
References: <52B45A15.4090009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yahoo.smtp.stone-is.be ([5.134.1.31]:39082 "EHLO
	yahoo.smtp.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaATNDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2014 08:03:20 -0500
In-Reply-To: <52B45A15.4090009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>

On 12/20/13 15:54, Hannes Reinecke wrote:
> I'd like to attend LSF 2014.
> 
> During that I'd like to discuss the current status of the SCSI EH
> and the future planned updates.
> 
> As discussed during last year's LSF the SCSI error handler should be
> updated to handle modern SCSI transports better.
> While some patchsets are already merged, there are some issues which
> are still open:
> - Handling of requests during host reset:
>   Do we need to keep hold of outstanding requests during host reset?
>   Or is it save to return them prior to host reset?
> - Check for transport status prior to sending TMFs.
>   Task management functions typically need a working I_T nexus,
>   so it does make sense to first check the transport status
>   prior to attempting any TMFs
> - Further steps for updating SCSI EH
> As these are tricky issues which have possible repercussions on the
> entire subsystem and LLDDs it'd be good to have a broader discussion
> here.

+1 for this topic.

Given my recent contributions to the error detection and recovery code
in the SRP initiator driver I think I can provide valuable inputs for
this discussion.

Bart.
