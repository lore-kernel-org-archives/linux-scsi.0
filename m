From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] yet another patch to limit mode sense usage
Date: Mon, 15 Sep 2003 14:15:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915141503.A10193@beaverton.ibm.com>
References: <20030915132330.A9823@beaverton.ibm.com> <20030915134513.A31961@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:28321 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261626AbTIOVQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 17:16:04 -0400
Content-Disposition: inline
In-Reply-To: <20030915134513.A31961@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Mon, Sep 15, 2003 at 01:45:13PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org

On Mon, Sep 15, 2003 at 01:45:13PM -0700, Matthew Dharm wrote:
> On Mon, Sep 15, 2003 at 01:23:30PM -0700, Patrick Mansfield wrote:
> > Patch to allow overriding or setting of mode sense related flags, includes
> > Alan Stern's as95 patch minus his scsiglue.c changes.
> > +	/* modify scsi_device bits on probe */
> > +	.flags = (BLIST_MS_SKIP_PAGE_3F | BLIST_USE_10_BYTE_MS),
> > +
> 
> In my view, the problem isn't page 0x3F, but page 0x8.

Oops, I meant to use page 0x8 there. I'll send an updated patch.

-- Patrick Mansfield
