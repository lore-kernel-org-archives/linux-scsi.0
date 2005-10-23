From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 3/6] SCSI HCIL: add scsi_scan_target()
Date: Sat, 22 Oct 2005 20:00:32 -0600
Message-ID: <20051023020032.GE1605@parisc-linux.org>
References: <20051023013618.GA18201@havoc.gtf.org> <20051023013849.GC18279@havoc.gtf.org> <20051023015042.GB1605@parisc-linux.org> <435AED69.80609@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58008 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751386AbVJWCAc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 22:00:32 -0400
Content-Disposition: inline
In-Reply-To: <435AED69.80609@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 22, 2005 at 09:54:49PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >On Sat, Oct 22, 2005 at 09:38:49PM -0400, Jeff Garzik wrote:
> >
> >>+/**
> >>+ * scsi_scan_target - scan a target id, possibly including all LUNs on 
> >>the
> >>+ *     target.
> >>+ * @target:	target to scan
> >>+ * @lun:	Specific LUN to scan or SCAN_WILD_CARD
> >>+ * @rescan:	passed to LUN scanning routines
> >>+ *
> >>+ * Description:
> >>+ *     Scan the target id on @parent, @channel, and @id. Scan at least 
> >>LUN 0,
> >>+ *     and possibly all LUNs on the target id.
> >
> >
> >Need to fix @parent, @channel and @id in the kerneldoc.
> 
> where?  The above looks right to me.

"Scan the target id on @parent, @channel, and @id"

these aren't parameters to the function.  How about just deleting that
sentence ...

"Scan at least LUN 0, and possibly all LUNs on @target"
