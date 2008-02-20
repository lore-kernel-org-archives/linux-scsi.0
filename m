From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] arcmsr: fix message allocation
Date: Wed, 20 Feb 2008 10:28:42 -0600
Message-ID: <1203524922.3109.34.camel@localhost.localdomain>
References: <20080220132905.EAA849D4144@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48996 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934532AbYBTQ2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 11:28:52 -0500
In-Reply-To: <20080220132905.EAA849D4144@zog.reactivated.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: josh@hoblitt.com, kimhh@control.aau.dk, erich@areca.com.tw, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw

On Wed, 2008-02-20 at 13:29 +0000, Daniel Drake wrote:
> arcmsr_iop_message_xfer() is called from atomic context under the
> queuecommand scsi_host_template handler. James Bottomley pointed out
> that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we are in
> atomic context, secondly this memory is not used for DMA.
> Also removed some unneeded casts.

This looks good to me.  It would be nice to have acks from Areca, but
I'll queue it for upstream fixes in a day or so regardless.

James


