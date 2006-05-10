From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Wed, 10 May 2006 11:50:12 -0500
Message-ID: <1147279812.3671.8.camel@mulgrave.il.steeleye.com>
References: <4461EFD0.50902@suse.de>  <446217D5.3020606@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58085 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964920AbWEJQu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:50:28 -0400
In-Reply-To: <446217D5.3020606@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2006-05-10 at 12:41 -0400, Douglas Gilbert wrote:
> Looks good. There is no proposed change to sg.c .
> Could SG_FLAG_FAILFAST be made to work via sg device
> nodes?

Rather than having to maintain two separate paths for SG_IO and hence
keep running into this issue, what will it take for sg to use the block
scsi_ioctl.c?

James


