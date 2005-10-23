From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 3/6] SCSI HCIL: add scsi_scan_target()
Date: Sat, 22 Oct 2005 21:54:49 -0400
Message-ID: <435AED69.80609@pobox.com>
References: <20051023013618.GA18201@havoc.gtf.org> <20051023013849.GC18279@havoc.gtf.org> <20051023015042.GB1605@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:58303 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751384AbVJWByw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:54:52 -0400
In-Reply-To: <20051023015042.GB1605@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Oct 22, 2005 at 09:38:49PM -0400, Jeff Garzik wrote:
> 
>>+/**
>>+ * scsi_scan_target - scan a target id, possibly including all LUNs on the
>>+ *     target.
>>+ * @target:	target to scan
>>+ * @lun:	Specific LUN to scan or SCAN_WILD_CARD
>>+ * @rescan:	passed to LUN scanning routines
>>+ *
>>+ * Description:
>>+ *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
>>+ *     and possibly all LUNs on the target id.
> 
> 
> Need to fix @parent, @channel and @id in the kerneldoc.

where?  The above looks right to me.

	Jeff



