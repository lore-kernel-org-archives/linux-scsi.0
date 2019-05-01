From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/24] scsi_netlink: remove duplicate GPL boilerplate text
Date: Wed,  1 May 2019 12:13:56 -0400
Message-ID: <20190501161417.32592-4-hch@lst.de>
References: <20190501161417.32592-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501161417.32592-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The SCSI netlink uapi header already has a proper SPDX tag, remove the
duplicate boilerplate text.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/uapi/scsi/scsi_netlink.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_netlink.h
index 5ccc2333acab..5dd382054e45 100644
--- a/include/uapi/scsi/scsi_netlink.h
+++ b/include/uapi/scsi/scsi_netlink.h
@@ -4,21 +4,6 @@
  *    Used for the posting of outbound SCSI transport events
  *
  *  Copyright (C) 2006   James Smart, Emulex Corporation
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 #ifndef SCSI_NETLINK_H
 #define SCSI_NETLINK_H
-- 
2.20.1
