From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LBD support with 2.6.10
Date: Mon, 3 Jan 2005 22:11:49 +0000
Message-ID: <20050103221149.GA26669@infradead.org>
References: <47F3C2BE74738E4683574107469DFA20678BA0@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:19840 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261942AbVACWLt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 17:11:49 -0500
Content-Disposition: inline
In-Reply-To: <47F3C2BE74738E4683574107469DFA20678BA0@XYUSEX01.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org

> sfdisk: BLKGETSIZE ioctl failed for /dev/sda
> 
> Did I miss something regarding LBD support ?
> Any ideas ?

You can't use old DOS-style partition tables for really big disks.
SGI successfully uses IRIX disk labels, but others may work aswell.

