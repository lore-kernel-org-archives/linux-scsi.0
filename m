From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] take 2 yet another patch to limit mode sense usage
Date: Tue, 16 Sep 2003 10:17:54 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309161015200.761-100000@ida.rowland.org>
References: <20030915142244.A10286@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261898AbTIPOR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 10:17:56 -0400
In-Reply-To: <20030915142244.A10286@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, 15 Sep 2003, Patrick Mansfield wrote:

> Patch to allow overriding or setting of mode sense related flags, includes
> Alan Stern's as95 patch minus his scsiglue.c changes. Per Matthew's
> comment use BLIST_MS_SKIP_PAGE_08 rather than BLIST_MS_SKIP_PAGE_3F in
> scsiglue.c.
> 
> In addition:
> 
> Moves scsi_devinfo.h for use outside of drivers/scsi, and adds three new
> devinfo flags:
> 
> 	BLIST_MS_SKIP_PAGE_08
> 	BLIST_MS_SKIP_PAGE_3F
> 	BLIST_USE_10_BYTE_MS
> 
> Adds a per host template flags, and use of it in scsiglue.c. The per host
> value can be overridden by a devinfo entry. The patch does not allow
> scsi_default_dev_flags to override default host values.

Patrick's patch is more elaborate than mine but is also more generally
applicable.  I would support the adoption of either one.

Alan Stern

