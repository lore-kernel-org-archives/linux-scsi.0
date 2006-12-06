From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 11:25:31 -0600
Message-ID: <1165425931.2810.37.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612061207550.3298-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35717 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936930AbWLFRbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 12:31:46 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612061207550.3298-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 2006-12-06 at 12:21 -0500, Alan Stern wrote:
> So only the legacy sg character-device files need attention, which
> means 
> that only the part of the patch affecting sg.c is necessary.  The new 
> SG_GET_MAX_TRANSFER_LENGTH ioctl can remain unimplemented by the
> block 
> layer -- just as SG_[SG]ET_RESERVED_SIZE should be.
> 
> How does that sound?

Actually, I'd just connect sg up to the block ioctl ... it has a block
queue and valid parameters, so BLKSECTGET will work for it as well.

James


