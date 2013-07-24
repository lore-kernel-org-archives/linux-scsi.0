From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 0/2] Minor scsi_dh_emc error path fixes
Date: Wed, 24 Jul 2013 11:04:59 -0400
Message-ID: <20130724110459.3c7cd9d3@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:52374 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3GXPFe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 11:05:34 -0400
In-Reply-To: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On Tue, 28 May 2013 17:18:37 -0400
Joe Lawrence <Joe.Lawrence@stratus.com> wrote:

> These two patches spun out of the blk_get_request return type changes
> I've been working on [1].
> 
>   [1] http://thread.gmane.org/gmane.linux.scsi/80934
> 
> Should that patch go in, there are a few other device handler changes
> possible for 3.11 [2], but the following bugfixes are unrelated, so I
> thought I'd post them in case they could apply for 3.10.
> 
>   [2] http://thread.gmane.org/gmane.linux.scsi/81130
> 
> The first bug was spotted by Mike in thread [2], the second when I
> traced the call path of clariion_send_inquiry back out through
> clariion_set_params and its caller parse_path. The latter fix could have
> been made in parse_path, but it didn't seem appropriate for that file to
> sort through SCSI_DH enums.
> 
> Comments welcome, unfortunately I don't have the HW to verify, so these
> are only compile tested.
> 
> Thanks,
> 
> Joe Lawrence (2):
>   scsi_dh_emc: handle zero-senselen send_inquiry_cmd errors
>   scsi_dh_emc: set_params callback should consistently return errno
> 
>  drivers/scsi/device_handler/scsi_dh_emc.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 

Hello Hannes, Mike,

I'm cleaning out some older work and came across these patches.  These
appear to be very minor bugs for HW I don't have access to, but I
thought I'd give the patches one last ping.

(link to thread):
http://thread.gmane.org/gmane.linux.scsi/82290

Regards,

-- Joe
