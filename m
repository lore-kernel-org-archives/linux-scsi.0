From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] add scsi_cmd_ioctl (SG_IO) support for st
Date: Sun, 1 Feb 2004 17:28:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201222818.GI26962@serve.riede.org>
References: <20040201124803.A18050@beaverton.ibm.com> <20040201125031.A18128@beaverton.ibm.com> <20040201213552.B17988@infradead.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:43205 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S265467AbUBAW2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 17:28:20 -0500
Content-Disposition: inline
In-Reply-To: <20040201213552.B17988@infradead.org> (from hch@infradead.org on Sun, Feb 01, 2004 at 16:35:52 -0500)
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 2004.02.01 16:35, Christoph Hellwig wrote:
> > +static void st_intr(struct scsi_cmnd *SCpnt)
> > +{
> 
> What about st_done instead?  I know sd and sr use the intr names, but
> they're really misleading.  Also convention for new code is to use
> cmd or scmd as variable names for scsi commands.

Is there any desire to change SCpnt to scmd in existing code (such as osst)?

Thanks, Willem Riede.
