From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/24] libsas: switch remaining files to SPDX tags
Date: Wed,  1 May 2019 12:14:10 -0400
Message-ID: <20190501161417.32592-18-hch@lst.de>
References: <20190501161417.32592-1-hch@lst.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDUNBGN3R4KRBIUMU7TAKGQEFCNLBYY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Use the the GPLv2 SPDX tag instead of verbose boilerplate text.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/scsi/libsas/sas_discover.c  | 18 +-----------------
 drivers/scsi/libsas/sas_event.c     | 18 +-----------------
 drivers/scsi/libsas/sas_expander.c  | 16 +---------------
 drivers/scsi/libsas/sas_host_smp.c  |  5 +----
 drivers/scsi/libsas/sas_init.c      | 19 +------------------
 drivers/scsi/libsas/sas_internal.h  | 19 +------------------
 drivers/scsi/libsas/sas_phy.c       | 18 +-----------------
 drivers/scsi/libsas/sas_port.c      | 18 +-----------------
 drivers/scsi/libsas/sas_scsi_host.c | 19 +------------------
 include/scsi/libsas.h               | 19 +------------------
 include/scsi/sas.h                  | 19 +------------------
 include/scsi/sas_ata.h              | 17 +----------------
 12 files changed, 12 insertions(+), 193 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 726ada9b8c79..2518cecb7edf 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -1,25 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Discover process
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include <linux/scatterlist.h>
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index b1e0f7d2b396..a1852f6c042b 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -1,25 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Event processing
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include <linux/export.h>
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 83f2fd70ce76..76ea83ddafa7 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Expander discovery and configuration
  *
@@ -5,21 +6,6 @@
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
  *
  * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include <linux/scatterlist.h>
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 9ead93df3a6e..55dcc9c934b2 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -1,12 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Expander discovery and configuration
  *
  * Copyright (C) 2007 James E.J. Bottomley
  *		<James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; version 2 only.
  */
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 28a460c36c0b..8f2608995726 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -1,26 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Transport Layer initialization
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 2cdb981cf476..1bc248a1b4ea 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Serial Attached SCSI (SAS) class internal header file
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
  */
 
 #ifndef _SAS_INTERNAL_H_
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index e030e1452136..2455199e5ffc 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -1,25 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Phy class
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include "sas_internal.h"
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 38a10478605c..11f028a441dd 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -1,25 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Port class
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  */
 
 #include "sas_internal.h"
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b775445892af..602bd1a17a63 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1,26 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) class SCSI Host glue.
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
  */
 
 #include <linux/kthread.h>
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index b08febec7895..901355a1bc53 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * SAS host prototypes and structures header file
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
  */
 
 #ifndef _LIBSAS_H_
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 42a84ef42683..ded4d6b7a377 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * SAS structures and definitions header file
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
  */
 
 #ifndef _SAS_H_
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 00f41aeeecf5..9f5ce0a3e63e 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -1,25 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Support for SATA devices on Serial Attached SCSI (SAS) controllers
  *
  * Copyright (C) 2006 IBM Corporation
  *
  * Written by: Darrick J. Wong <djwong-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, IBM Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
  */
 
 #ifndef _SAS_ATA_H_
-- 
2.20.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
