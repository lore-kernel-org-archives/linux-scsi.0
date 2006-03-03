From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [SCSI] Fix missing prototypes by including <linux/interrupt.h>.
Date: Fri, 3 Mar 2006 17:02:45 +0000
Message-ID: <20060303170245.GA27487@linux-mips.org>
References: <20060303152148.GA10566@linux-mips.org> <20060303152506.GL1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mipsfw.mips-uk.com ([194.74.144.146]:39437 "EHLO
	bacchus.dhis.org") by vger.kernel.org with ESMTP id S1030239AbWCCRCx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 12:02:53 -0500
Content-Disposition: inline
In-Reply-To: <20060303152506.GL1598@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 03, 2006 at 08:25:06AM -0700, Matthew Wilcox wrote:

> If you're adding linux/interrupt.h, you should probably remove the
> asm/irq.h since it'll be pulled in through asm/hardirq.h

Indeed.  Resending in separate mail.

  Ralf
