From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC] 2.6.0 EDD enhancements
Date: Mon, 29 Dec 2003 14:05:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229140541.A31985@lists.us.dell.com>
References: <Pine.LNX.4.44.0312191254550.2465-100000@humbolt.us.dell.com> <20031219130129.B6530@lists.us.dell.com> <20031228200854.B22668@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:11947 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S265060AbTL2UGT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 15:06:19 -0500
Content-Disposition: inline
In-Reply-To: <20031228200854.B22668@infradead.org>; from hch@infradead.org on Sun, Dec 28, 2003 at 08:08:54PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> As James already said you're poking far too deep into scsi internals.
> In addition to his comment I'd suggest putting the symlink creating
> into scsi_sysfs.c and exporting a procedural interface for the edd
> code.  That way it'll get updated automatically if we change something.

Thanks for the feedback.  I'll rework it to move to scsi_sysfs.c (and
for the similar IDE and pci_dev pieces likewise).

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
