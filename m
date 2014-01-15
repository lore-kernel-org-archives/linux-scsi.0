From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] [ATTEND] scsi_eh updates
Date: Wed, 15 Jan 2014 15:12:27 -0800
Message-ID: <1389827547.5567.604.camel@haakon3.risingtidesystems.com>
References: <52B45A15.4090009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57505 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaAOXKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 18:10:31 -0500
In-Reply-To: <52B45A15.4090009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2013-12-20 at 15:54 +0100, Hannes Reinecke wrote:
> Hi all,
> 
> (before leaving for holiday ...)
> 
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

+1 on this too.

Without upstream movement on scsi_eh, it's going to be a long and
painful road for scsi-mq.

--nab

