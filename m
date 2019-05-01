From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 14/24] libiscsi: switch to SPDX tags
Date: Wed,  1 May 2019 12:14:07 -0400
Message-ID: <20190501161417.32592-15-hch@lst.de>
References: <20190501161417.32592-1-hch@lst.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDUNBGN3R4KRBHMMU7TAKGQE3KJRTIA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20190501161417.32592-1-hch-jcswGhMUV9g@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "James E . J . Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Willem Riede <osst-BKTAy3DeTVvYtjvyW6yDsg@public.gmane.org>, Doug Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, osst-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Use the the GPLv2+ SPDX tag instead of verbose boilerplate text.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/scsi/libiscsi.c       | 15 +--------------
 drivers/scsi/libiscsi_tcp.c   | 13 +------------
 include/scsi/iscsi_if.h       | 13 +------------
 include/scsi/iscsi_proto.h    | 13 +------------
 include/scsi/libiscsi.h       | 15 +--------------
 include/scsi/libiscsi_tcp.h   | 13 +------------
 include/scsi/scsi_bsg_iscsi.h | 16 +---------------
 7 files changed, 7 insertions(+), 91 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e893949a3d11..040b58a3d7d3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * iSCSI lib functions
  *
@@ -6,20 +7,6 @@
  * Copyright (C) 2004 - 2005 Dmitry Yusupov
  * Copyright (C) 2004 - 2005 Alex Aizman
  * maintained by open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/types.h>
 #include <linux/kfifo.h>
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index c3fe3f3a78f5..e0255bb2748f 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * iSCSI over TCP/IP Data-Path lib
  *
@@ -7,18 +8,6 @@
  * Copyright (C) 2006 Red Hat, Inc.  All rights reserved.
  * maintained by open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * See the file COPYING included with this distribution for more details.
- *
  * Credits:
  *	Christoph Hellwig
  *	FUJITA Tomonori
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index d66c07077d68..5b8af179b7ac 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -1,21 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * iSCSI User/Kernel Shares (Defines, Constants, Protocol definitions, etc)
  *
  * Copyright (C) 2005 Dmitry Yusupov
  * Copyright (C) 2005 Alex Aizman
  * maintained by open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * See the file COPYING included with this distribution for more details.
  */
 
 #ifndef ISCSI_IF_H
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index df156f1d50b2..3e930ab9b859 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -1,21 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * RFC 3720 (iSCSI) protocol data types
  *
  * Copyright (C) 2005 Dmitry Yusupov
  * Copyright (C) 2005 Alex Aizman
  * maintained by open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * See the file COPYING included with this distribution for more details.
  */
 
 #ifndef ISCSI_PROTO_H
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c9bd935f4fd1..7992f6bb2ebc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * iSCSI lib definitions
  *
@@ -5,20 +6,6 @@
  * Copyright (C) 2004 - 2006 Mike Christie
  * Copyright (C) 2004 - 2005 Dmitry Yusupov
  * Copyright (C) 2004 - 2005 Alex Aizman
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #ifndef LIBISCSI_H
 #define LIBISCSI_H
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 30520d5ee3d1..b7ce80422215 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -1,21 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * iSCSI over TCP/IP Data-Path lib
  *
  * Copyright (C) 2008 Mike Christie
  * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
  * maintained by open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * See the file COPYING included with this distribution for more details.
  */
 
 #ifndef LIBISCSI_TCP_H
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index fd5689d4c052..aa76c1e5b36f 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -1,22 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  *  iSCSI Transport BSG Interface
  *
  *  Copyright (C) 2009   James Smart, Emulex Corporation
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
 
 #ifndef SCSI_BSG_ISCSI_H
-- 
2.20.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
