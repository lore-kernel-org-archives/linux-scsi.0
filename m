From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add scsi_cmd_ioctl (SG_IO) support for st
Date: Sun, 1 Feb 2004 22:36:49 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201223649.A18653@infradead.org>
References: <20040201124803.A18050@beaverton.ibm.com> <20040201125031.A18128@beaverton.ibm.com> <20040201213552.B17988@infradead.org> <20040201222818.GI26962@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:14093 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265465AbUBAWgu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 17:36:50 -0500
Content-Disposition: inline
In-Reply-To: <20040201222818.GI26962@serve.riede.org>; from wrlk@riede.org on Sun, Feb 01, 2004 at 05:28:18PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 01, 2004 at 05:28:18PM -0500, Willem Riede wrote:
> > What about st_done instead?  I know sd and sr use the intr names, but
> > they're really misleading.  Also convention for new code is to use
> > cmd or scmd as variable names for scsi commands.
> 
> Is there any desire to change SCpnt to scmd in existing code (such as osst)?

For the scsi midlayer (and new driver if possible) it would be nice to
have a single common notation.  For existing drivers it's of course
left to the author.

That beeing said it would of course be nice to have driver/scsi/ as
homogeneous as possible.

