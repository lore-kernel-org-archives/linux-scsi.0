From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [ANNOUNCE] Emulex lpfcdriver v8.0.7 available
Date: Fri, 23 Jul 2004 17:15:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040723211529.GQ20738@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dhcp-78-101.ma.emulex.com ([138.239.78.101]:22936 "EHLO
	wintermute.ma.emulex.com") by vger.kernel.org with ESMTP
	id S268066AbUGWVPl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2004 17:15:41 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Christoph,

We've posted the 8.0.7 lpfc driver tarball on SourceForge.  The LUN
handling is gone and your patch to remove some dead code related to
lpfc_build_scsi_cmd() is included along with some other cleanup.

The tarball is here:
http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.7.tar.gz?download

The full ChangeLog is on SourceForge:
http://sourceforge.net/forum/forum.php?forum_id=393984

Thanks,
Jamie
Jamie.Wellnitz@emulex.com
