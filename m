From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: libsas: Add missing license and update to SPDX license identifier
Date: Tue, 27 Nov 2018 22:15:32 +0800
Message-ID: <1543328132-243266-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently sas_task.c has no license specifier, so add SPDX license
identifier for GPL-2.0+.

As mentioned in commit b24413180f56 ("License cleanup: add SPDX GPL-2.0
license identifier to files with no license"), files with no license in
the kernel are under default kernel license.

While I'm at it, all other libsas source code files are updated to use
SPDX license identifier for GPL-2.0+.

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 13739bfa..bdc6bce 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -4,22 +4,7 @@
 # Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
-# This file is licensed under GPLv2.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation; version 2 of the
-# License.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-# General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write to the Free Software
-# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
-# USA
+# SPDX-License-Identifier: GPL-2.0+
 #
 
 config SCSI_SAS_LIBSAS
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 5d51520..75998b7 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -4,22 +4,7 @@
 # Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
-# This file is licensed under GPLv2.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation; version 2 of the
-# License.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-# General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write to the Free Software
-# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
-# USA
+# SPDX-License-Identifier: GPL-2.0+
 
 obj-$(CONFIG_SCSI_SAS_LIBSAS) += libsas.o
 libsas-y +=  sas_init.o     \
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index daf898c..43e5377 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Support for SATA devices on Serial Attached SCSI (SAS) controllers
  *
@@ -5,20 +6,6 @@
  *
  * Written by: Darrick J. Wong <djwong@us.ibm.com>, IBM Corporation
  *
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
  */
 
 #include <linux/scatterlist.h>
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 726ada9..43db4ec 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -1,25 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) Discover process
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index b1e0f7d..b7d2a8b 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -1,25 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) Event processing
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 17eb418..fbec655 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1,25 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) Expander discovery and configuration
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 9ead93d..253ba3b 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -1,12 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Serial Attached SCSI (SAS) Expander discovery and configuration
  *
  * Copyright (C) 2007 James E.J. Bottomley
  *		<James.Bottomley@HansenPartnership.com>
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; version 2 only.
  */
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 221340e..11be84b 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -1,26 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) Transport Layer initialization
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 2cdb981..e4a2ec1 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -1,26 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Serial Attached SCSI (SAS) class internal header file
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 0374243..bbe3b65 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -1,25 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) Phy class
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 03fe479..bcd9ac4 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -1,25 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) Port class
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 674789b..0b68ecd 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1,26 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Serial Attached SCSI (SAS) class SCSI Host glue.
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index c3b9bef..3adc5c3 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 
 #include "sas_internal.h"
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3de3b10..8ab2424 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -1,26 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * SAS host prototypes and structures header file
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 42a84ef..788d0f2 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -1,26 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * SAS structures and definitions header file
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
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
index 00f41ae..1a6163a 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Support for SATA devices on Serial Attached SCSI (SAS) controllers
  *
@@ -5,21 +6,6 @@
  *
  * Written by: Darrick J. Wong <djwong@us.ibm.com>, IBM Corporation
  *
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
1.9.1
