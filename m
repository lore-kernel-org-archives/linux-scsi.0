From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/6] bfa: Brocade BFA FC SCSI driver (include)
Date: Tue, 21 Jul 2009 16:10:52 -0700
Message-ID: <200907212310.n6LNAqsA007455@swe57.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756539AbZGUXLl@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com, xmzhang@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains common header files for linux driver,
hardware/firmeare interface, and FC state machines.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 aen/bfa_aen.h             |   94 ++
 aen/bfa_aen_adapter.h     |   31 
 aen/bfa_aen_audit.h       |   31 
 aen/bfa_aen_ethport.h     |   35 
 aen/bfa_aen_ioc.h         |   37 +
 aen/bfa_aen_itnim.h       |   33 
 aen/bfa_aen_lport.h       |   51 +
 aen/bfa_aen_port.h        |   57 +
 aen/bfa_aen_rport.h       |   37 +
 bfa.h                     |  177 ++++
 bfa_fcpim.h               |  159 ++++
 bfa_fcptm.h               |   47 +
 bfa_svc.h                 |  324 +++++++++
 bfa_timer.h               |   53 +
 bfi/bfi.h                 |  174 ++++
 bfi/bfi_boot.h            |   34 
 bfi/bfi_cbreg.h           |  305 ++++++++
 bfi/bfi_cee.h             |  119 +++
 bfi/bfi_ctreg.h           |  611 +++++++++++++++++
 bfi/bfi_fabric.h          |   92 ++
 bfi/bfi_fcpim.h           |  301 ++++++++
 bfi/bfi_fcxp.h            |   71 +
 bfi/bfi_ioc.h             |  202 +++++
 bfi/bfi_iocfc.h           |  177 ++++
 bfi/bfi_lport.h           |   89 ++
 bfi/bfi_lps.h             |   96 ++
 bfi/bfi_port.h            |  115 +++
 bfi/bfi_pport.h           |  184 +++++
 bfi/bfi_rport.h           |  104 ++
 bfi/bfi_uf.h              |   52 +
 cna/bfa_cna_trcmod.h      |   36 +
 cna/cee/bfa_cee.h         |   77 ++
 cna/port/bfa_port.h       |   69 +
 cna/pstats/ethport_defs.h |   36 +
 cna/pstats/phyport_defs.h |  218 ++++++
 cs/bfa_checksum.h         |   60 +
 cs/bfa_debug.h            |   44 +
 cs/bfa_log.h              |  184 +++++
 cs/bfa_perf.h             |   34 
 cs/bfa_plog.h             |  162 ++++
 cs/bfa_q.h                |   81 ++
 cs/bfa_sm.h               |   69 +
 cs/bfa_trc.h              |  176 ++++
 cs/bfa_wc.h               |   68 +
 defs/bfa_defs_adapter.h   |   82 ++
 defs/bfa_defs_aen.h       |   73 ++
 defs/bfa_defs_audit.h     |   38 +
 defs/bfa_defs_auth.h      |  112 +++
 defs/bfa_defs_boot.h      |   71 +
 defs/bfa_defs_cee.h       |  159 ++++
 defs/bfa_defs_driver.h    |   40 +
 defs/bfa_defs_ethport.h   |   98 ++
 defs/bfa_defs_fcpim.h     |   45 +
 defs/bfa_defs_im_common.h |   32 
 defs/bfa_defs_im_team.h   |   72 ++
 defs/bfa_defs_ioc.h       |  152 ++++
 defs/bfa_defs_iocfc.h     |  310 ++++++++
 defs/bfa_defs_ipfc.h      |   70 +
 defs/bfa_defs_itnim.h     |  126 +++
 defs/bfa_defs_led.h       |   35 
 defs/bfa_defs_lport.h     |   68 +
 defs/bfa_defs_mfg.h       |   58 +
 defs/bfa_defs_pci.h       |   41 +
 defs/bfa_defs_pm.h        |   33 
 defs/bfa_defs_pom.h       |   56 +
 defs/bfa_defs_port.h      |  245 ++++++
 defs/bfa_defs_pport.h     |  383 ++++++++++
 defs/bfa_defs_qos.h       |   99 ++
 defs/bfa_defs_rport.h     |  199 +++++
 defs/bfa_defs_status.h    |  255 +++++++
 defs/bfa_defs_tin.h       |  118 +++
 defs/bfa_defs_tsensor.h   |   43 +
 defs/bfa_defs_types.h     |   30 
 defs/bfa_defs_version.h   |   22 
 defs/bfa_defs_vf.h        |   74 ++
 defs/bfa_defs_vport.h     |   91 ++
 fcb/bfa_fcb.h             |   33 
 fcb/bfa_fcb_fcpim.h       |   76 ++
 fcb/bfa_fcb_port.h        |  113 +++
 fcb/bfa_fcb_rport.h       |   80 ++
 fcb/bfa_fcb_vf.h          |   47 +
 fcb/bfa_fcb_vport.h       |   47 +
 fcs/bfa_fcs.h             |   73 ++
 fcs/bfa_fcs_auth.h        |   82 ++
 fcs/bfa_fcs_fabric.h      |  112 +++
 fcs/bfa_fcs_fcpim.h       |  131 +++
 fcs/bfa_fcs_fdmi.h        |   63 +
 fcs/bfa_fcs_lport.h       |  226 ++++++
 fcs/bfa_fcs_rport.h       |  104 ++
 fcs/bfa_fcs_vport.h       |   63 +
 log/bfa_log_fcs.h         |   28 
 log/bfa_log_hal.h         |   30 
 log/bfa_log_linux.h       |   44 +
 log/bfa_log_wdrv.h        |   36 +
 protocol/ct.h             |  492 +++++++++++++
 protocol/fc.h             | 1105 ++++++++++++++++++++++++++++++
 protocol/fc_sp.h          |  224 ++++++
 protocol/fcp.h            |  186 +++++
 protocol/fdmi.h           |  163 ++++
 protocol/pcifw.h          |   75 ++
 protocol/scsi.h           | 1648 ++++++++++++++++++++++++++++++++++++++++++++++
 protocol/types.h          |   42 +
 102 files changed, 13859 insertions(+)

diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen.h patch/drivers/scsi/bfa/include/aen/bfa_aen.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_AEN_H__
+#define __BFA_AEN_H__
+
+#include "defs/bfa_defs_aen.h"
+
+#define BFA_AEN_MAX_ENTRY   512
+
+extern s32 bfa_aen_max_cfg_entry;
+struct bfa_aen_s {
+	void		*bfad;
+	s32		max_entry;
+	s32		write_index;
+	s32		read_index;
+	u32	bfad_num;
+	u32	seq_num;
+	void		(*aen_cb_notify)(void *bfad);
+	void		(*gettimeofday)(struct bfa_timeval_s *tv);
+	struct bfa_trc_mod_s 	*trcmod;
+	struct bfa_aen_entry_s	list[BFA_AEN_MAX_ENTRY]; /* Must be the last */
+};
+
+
+/**
+ * Public APIs
+ */
+static inline void
+bfa_aen_set_max_cfg_entry(int max_entry)
+{
+	bfa_aen_max_cfg_entry = max_entry;
+}
+
+static inline s32
+bfa_aen_get_max_cfg_entry(void)
+{
+	return bfa_aen_max_cfg_entry;
+}
+
+static inline s32
+bfa_aen_get_meminfo(void)
+{
+	return (sizeof(struct bfa_aen_entry_s) * bfa_aen_get_max_cfg_entry());
+}
+
+static inline s32
+bfa_aen_get_wi(struct bfa_aen_s *aen)
+{
+	return aen->write_index;
+}
+
+static inline s32
+bfa_aen_get_ri(struct bfa_aen_s *aen)
+{
+	return aen->read_index;
+}
+
+static inline s32
+bfa_aen_fetch_count(struct bfa_aen_s *aen, s32 read_index)
+{
+	return ((aen->write_index + aen->max_entry) - read_index)
+		% aen->max_entry;
+}
+
+s32 bfa_aen_init(struct bfa_aen_s *aen, struct bfa_trc_mod_s *trcmod,
+		void *bfad, u32 inst_id, void (*aen_cb_notify)(void *),
+		void (*gettimeofday)(struct bfa_timeval_s *));
+
+s32 bfa_aen_post(struct bfa_aen_s *aen, enum bfa_aen_category aen_category,
+		     int aen_type, union bfa_aen_data_u *aen_data);
+
+s32 bfa_aen_fetch(struct bfa_aen_s *aen, struct bfa_aen_entry_s *aen_entry,
+		      s32 entry_space, s32 rii, s32 *ri_arr,
+		      s32 ri_arr_cnt);
+
+s32 bfa_aen_get_inst(struct bfa_aen_s *aen);
+
+char *wwn2str(char *buf, int bufsize, u64 wwn);
+
+#endif /* __BFA_AEN_H__ */
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h patch/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_adapter.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_ADAPTER Module */
+#ifndef	__bfa_aen_adapter_h__
+#define	__bfa_aen_adapter_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_ADAPTER_ADD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ADAPTER, BFA_ADAPTER_AEN_ADD)
+#define BFA_AEN_ADAPTER_REMOVE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ADAPTER, BFA_ADAPTER_AEN_REMOVE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_audit.h patch/drivers/scsi/bfa/include/aen/bfa_aen_audit.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_audit.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_audit.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_AUDIT Module */
+#ifndef	__bfa_aen_audit_h__
+#define	__bfa_aen_audit_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_AUDIT_AUTH_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_AUDIT, BFA_AUDIT_AEN_AUTH_ENABLE)
+#define BFA_AEN_AUDIT_AUTH_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_AUDIT, BFA_AUDIT_AEN_AUTH_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_ethport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_ETHPORT Module */
+#ifndef	__bfa_aen_ethport_h__
+#define	__bfa_aen_ethport_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_ETHPORT_LINKUP \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_LINKUP)
+#define BFA_AEN_ETHPORT_LINKDOWN \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_LINKDOWN)
+#define BFA_AEN_ETHPORT_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_ENABLE)
+#define BFA_AEN_ETHPORT_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ETHPORT, BFA_ETHPORT_AEN_DISABLE)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h patch/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_IOC Module */
+#ifndef	__bfa_aen_ioc_h__
+#define	__bfa_aen_ioc_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_IOC_HBGOOD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_HBGOOD)
+#define BFA_AEN_IOC_HBFAIL \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_HBFAIL)
+#define BFA_AEN_IOC_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_ENABLE)
+#define BFA_AEN_IOC_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_DISABLE)
+#define BFA_AEN_IOC_FWMISMATCH \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_FWMISMATCH)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h patch/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_itnim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_ITNIM Module */
+#ifndef	__bfa_aen_itnim_h__
+#define	__bfa_aen_itnim_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_ITNIM_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_ONLINE)
+#define BFA_AEN_ITNIM_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_OFFLINE)
+#define BFA_AEN_ITNIM_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_ITNIM, BFA_ITNIM_AEN_DISCONNECT)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_lport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_lport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_lport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_LPORT Module */
+#ifndef	__bfa_aen_lport_h__
+#define	__bfa_aen_lport_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_LPORT_NEW \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW)
+#define BFA_AEN_LPORT_DELETE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE)
+#define BFA_AEN_LPORT_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_ONLINE)
+#define BFA_AEN_LPORT_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_OFFLINE)
+#define BFA_AEN_LPORT_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DISCONNECT)
+#define BFA_AEN_LPORT_NEW_PROP \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW_PROP)
+#define BFA_AEN_LPORT_DELETE_PROP \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE_PROP)
+#define BFA_AEN_LPORT_NEW_STANDARD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NEW_STANDARD)
+#define BFA_AEN_LPORT_DELETE_STANDARD \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_DELETE_STANDARD)
+#define BFA_AEN_LPORT_NPIV_DUP_WWN \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_DUP_WWN)
+#define BFA_AEN_LPORT_NPIV_FABRIC_MAX \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_FABRIC_MAX)
+#define BFA_AEN_LPORT_NPIV_UNKNOWN \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_LPORT, BFA_LPORT_AEN_NPIV_UNKNOWN)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_port.h patch/drivers/scsi/bfa/include/aen/bfa_aen_port.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_port.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_PORT Module */
+#ifndef	__bfa_aen_port_h__
+#define	__bfa_aen_port_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_PORT_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_ONLINE)
+#define BFA_AEN_PORT_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_OFFLINE)
+#define BFA_AEN_PORT_RLIR \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_RLIR)
+#define BFA_AEN_PORT_SFP_INSERT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_INSERT)
+#define BFA_AEN_PORT_SFP_REMOVE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_REMOVE)
+#define BFA_AEN_PORT_SFP_POM \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_POM)
+#define BFA_AEN_PORT_ENABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_ENABLE)
+#define BFA_AEN_PORT_DISABLE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_DISABLE)
+#define BFA_AEN_PORT_AUTH_ON \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_AUTH_ON)
+#define BFA_AEN_PORT_AUTH_OFF \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_AUTH_OFF)
+#define BFA_AEN_PORT_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_DISCONNECT)
+#define BFA_AEN_PORT_QOS_NEG \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_QOS_NEG)
+#define BFA_AEN_PORT_FABRIC_NAME_CHANGE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_FABRIC_NAME_CHANGE)
+#define BFA_AEN_PORT_SFP_ACCESS_ERROR \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_ACCESS_ERROR)
+#define BFA_AEN_PORT_SFP_UNSUPPORT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_PORT, BFA_PORT_AEN_SFP_UNSUPPORT)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/aen/bfa_aen_rport.h patch/drivers/scsi/bfa/include/aen/bfa_aen_rport.h
--- orig/drivers/scsi/bfa/include/aen/bfa_aen_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/aen/bfa_aen_rport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for BFA_AEN_CAT_RPORT Module */
+#ifndef	__bfa_aen_rport_h__
+#define	__bfa_aen_rport_h__
+
+#include  <cs/bfa_log.h>
+#include  <defs/bfa_defs_aen.h>
+
+#define BFA_AEN_RPORT_ONLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_ONLINE)
+#define BFA_AEN_RPORT_OFFLINE \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_OFFLINE)
+#define BFA_AEN_RPORT_DISCONNECT \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_DISCONNECT)
+#define BFA_AEN_RPORT_QOS_PRIO \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_QOS_PRIO)
+#define BFA_AEN_RPORT_QOS_FLOWID \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_RPORT, BFA_RPORT_AEN_QOS_FLOWID)
+
+#endif
+
diff -urpN orig/drivers/scsi/bfa/include/bfa.h patch/drivers/scsi/bfa/include/bfa.h
--- orig/drivers/scsi/bfa/include/bfa.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,177 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_H__
+#define __BFA_H__
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_debug.h>
+#include <cs/bfa_q.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+#include <cs/bfa_plog.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_ioc.h>
+#include <defs/bfa_defs_iocfc.h>
+#include <aen/bfa_aen.h>
+#include <bfi/bfi.h>
+
+struct bfa_s;
+#include <bfa_intr_priv.h>
+
+struct bfa_pcidev_s;
+
+/**
+ * PCI devices supported by the current BFA
+ */
+struct bfa_pciid_s {
+	u16        device_id;
+	u16        vendor_id;
+};
+
+extern char     bfa_version[];
+
+/**
+ * BFA Power Mgmt Commands
+ */
+enum bfa_pm_cmd {
+	BFA_PM_CTL_D0 = 0,
+	BFA_PM_CTL_D1 = 1,
+	BFA_PM_CTL_D2 = 2,
+	BFA_PM_CTL_D3 = 3,
+};
+
+/**
+ * BFA memory resources
+ */
+enum bfa_mem_type {
+	BFA_MEM_TYPE_KVA = 1,	/*! Kernel Virtual Memory *(non-dma-able) */
+	BFA_MEM_TYPE_DMA = 2,	/*! DMA-able memory */
+	BFA_MEM_TYPE_MAX = BFA_MEM_TYPE_DMA,
+};
+
+struct bfa_mem_elem_s {
+	enum bfa_mem_type mem_type;	/*  see enum bfa_mem_type 	*/
+	u32        mem_len;	/*  Total Length in Bytes	*/
+	u8       	*kva;		/*  kernel virtual address	*/
+	u64        dma;		/*  dma address if DMA memory	*/
+	u8       	*kva_curp;	/*  kva allocation cursor	*/
+	u64        dma_curp;	/*  dma allocation cursor	*/
+};
+
+struct bfa_meminfo_s {
+	struct bfa_mem_elem_s meminfo[BFA_MEM_TYPE_MAX];
+};
+#define bfa_meminfo_kva(_m)	\
+	(_m)->meminfo[BFA_MEM_TYPE_KVA - 1].kva_curp
+#define bfa_meminfo_dma_virt(_m)	\
+	(_m)->meminfo[BFA_MEM_TYPE_DMA - 1].kva_curp
+#define bfa_meminfo_dma_phys(_m)	\
+	(_m)->meminfo[BFA_MEM_TYPE_DMA - 1].dma_curp
+
+/**
+ * Generic Scatter Gather Element used by driver
+ */
+struct bfa_sge_s {
+	u32        sg_len;
+	void           *sg_addr;
+};
+
+#define bfa_sge_to_be(__sge) do {                                          \
+	((u32 *)(__sge))[0] = bfa_os_htonl(((u32 *)(__sge))[0]);      \
+	((u32 *)(__sge))[1] = bfa_os_htonl(((u32 *)(__sge))[1]);      \
+	((u32 *)(__sge))[2] = bfa_os_htonl(((u32 *)(__sge))[2]);      \
+} while (0)
+
+
+/*
+ * bfa stats interfaces
+ */
+#define bfa_stats(_mod, _stats)	(_mod)->stats._stats ++
+
+#define bfa_ioc_get_stats(__bfa, __ioc_stats)	\
+	bfa_ioc_fetch_stats(&(__bfa)->ioc, __ioc_stats)
+#define bfa_ioc_clear_stats(__bfa)	\
+	bfa_ioc_clr_stats(&(__bfa)->ioc)
+
+/*
+ * bfa API functions
+ */
+void bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids);
+void bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg);
+void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
+void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo);
+void bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo,
+			struct bfa_pcidev_s *pcidev);
+void bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod);
+void bfa_init_log(struct bfa_s *bfa, struct bfa_log_mod_s *logmod);
+void bfa_init_aen(struct bfa_s *bfa, struct bfa_aen_s *aen);
+void bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog);
+void bfa_detach(struct bfa_s *bfa);
+void bfa_init(struct bfa_s *bfa);
+void bfa_start(struct bfa_s *bfa);
+void bfa_stop(struct bfa_s *bfa);
+void bfa_attach_fcs(struct bfa_s *bfa);
+void bfa_cb_init(void *bfad, bfa_status_t status);
+void bfa_cb_stop(void *bfad, bfa_status_t status);
+void bfa_cb_updateq(void *bfad, bfa_status_t status);
+
+bfa_boolean_t bfa_intx(struct bfa_s *bfa);
+void bfa_isr_enable(struct bfa_s *bfa);
+void bfa_isr_disable(struct bfa_s *bfa);
+void bfa_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
+			u32 *num_vecs, u32 *max_vec_bit);
+#define bfa_msix(__bfa, __vec) (__bfa)->msix.handler[__vec](__bfa, __vec)
+
+void bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q);
+void bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q);
+void bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q);
+
+typedef void (*bfa_cb_ioc_t) (void *cbarg, enum bfa_status status);
+void bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr);
+bfa_status_t bfa_iocfc_get_stats(struct bfa_s *bfa,
+			struct bfa_iocfc_stats_s *stats,
+			bfa_cb_ioc_t cbfn, void *cbarg);
+bfa_status_t bfa_iocfc_clear_stats(struct bfa_s *bfa,
+			bfa_cb_ioc_t cbfn, void *cbarg);
+void bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr);
+
+void bfa_adapter_get_attr(struct bfa_s *bfa,
+			struct bfa_adapter_attr_s *ad_attr);
+u64 bfa_adapter_get_id(struct bfa_s *bfa);
+
+bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
+			struct bfa_iocfc_intr_attr_s *attr);
+
+void bfa_iocfc_enable(struct bfa_s *bfa);
+void bfa_iocfc_disable(struct bfa_s *bfa);
+void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
+void bfa_cb_ioc_disable(void *bfad);
+void bfa_timer_tick(struct bfa_s *bfa);
+#define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)	\
+	bfa_timer_begin(&(_bfa)->timer_mod, _timer, _timercb, _arg, _timeout)
+
+/*
+ * BFA debug API functions
+ */
+bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
+bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
+
+#include "bfa_priv.h"
+
+#endif /* __BFA_H__ */
diff -urpN orig/drivers/scsi/bfa/include/bfa_fcpim.h patch/drivers/scsi/bfa/include/bfa_fcpim.h
--- orig/drivers/scsi/bfa/include/bfa_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_fcpim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCPIM_H__
+#define __BFA_FCPIM_H__
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_fcpim.h>
+#include <defs/bfa_defs_fcpim.h>
+
+/*
+ * forward declarations
+ */
+struct bfa_itnim_s;
+struct bfa_ioim_s;
+struct bfa_tskim_s;
+struct bfad_ioim_s;
+struct bfad_tskim_s;
+
+/*
+ * bfa fcpim module API functions
+ */
+void		bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov);
+u16	bfa_fcpim_path_tov_get(struct bfa_s *bfa);
+void		bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth);
+u16	bfa_fcpim_qdepth_get(struct bfa_s *bfa);
+bfa_status_t bfa_fcpim_get_modstats(struct bfa_s *bfa,
+			struct bfa_fcpim_stats_s *modstats);
+bfa_status_t bfa_fcpim_clr_modstats(struct bfa_s *bfa);
+
+/*
+ * bfa itnim API functions
+ */
+struct bfa_itnim_s *bfa_itnim_create(struct bfa_s *bfa,
+					struct bfa_rport_s *rport, void *itnim);
+void		bfa_itnim_delete(struct bfa_itnim_s *itnim);
+void		bfa_itnim_online(struct bfa_itnim_s *itnim,
+				 bfa_boolean_t seq_rec);
+void		bfa_itnim_offline(struct bfa_itnim_s *itnim);
+void		bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
+			struct bfa_itnim_hal_stats_s *stats);
+void		bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
+
+
+/**
+ * 		BFA completion callback for bfa_itnim_online().
+ *
+ * @param[in]		itnim		FCS or driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_online(void *itnim);
+
+/**
+ * 		BFA completion callback for bfa_itnim_offline().
+ *
+ * @param[in]		itnim		FCS or driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_offline(void *itnim);
+void            bfa_cb_itnim_tov_begin(void *itnim);
+void            bfa_cb_itnim_tov(void *itnim);
+
+/**
+ * 		BFA notification to FCS/driver for second level error recovery.
+ *
+ * Atleast one I/O request has timedout and target is unresponsive to
+ * repeated abort requests. Second level error recovery should be initiated
+ * by starting implicit logout and recovery procedures.
+ *
+ * @param[in]		itnim		FCS or driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_sler(void *itnim);
+
+/*
+ * bfa ioim API functions
+ */
+struct bfa_ioim_s	*bfa_ioim_alloc(struct bfa_s *bfa,
+					struct bfad_ioim_s *dio,
+					struct bfa_itnim_s *itnim,
+					u16 nsgles);
+
+void		bfa_ioim_free(struct bfa_ioim_s *ioim);
+void		bfa_ioim_start(struct bfa_ioim_s *ioim);
+void		bfa_ioim_abort(struct bfa_ioim_s *ioim);
+void 		bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
+				      bfa_boolean_t iotov);
+
+
+/**
+ * 		I/O completion notification.
+ *
+ * @param[in]		dio			driver IO structure
+ * @param[in]		io_status		IO completion status
+ * @param[in]		scsi_status		SCSI status returned by target
+ * @param[in]		sns_len			SCSI sense length, 0 if none
+ * @param[in]		sns_info		SCSI sense data, if any
+ * @param[in]		residue			Residual length
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
+				  enum bfi_ioim_status io_status,
+				  u8 scsi_status, int sns_len,
+				  u8 *sns_info, s32 residue);
+
+/**
+ * 		I/O good completion notification.
+ *
+ * @param[in]		dio			driver IO structure
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_good_comp(void *bfad, struct bfad_ioim_s *dio);
+
+/**
+ * 		I/O abort completion notification
+ *
+ * @param[in]		dio			driver IO that was aborted
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_abort(void *bfad, struct bfad_ioim_s *dio);
+void		bfa_cb_ioim_resfree(void *hcb_bfad);
+
+void 			bfa_cb_ioim_resfree(void *hcb_bfad);
+
+/*
+ * bfa tskim API functions
+ */
+struct bfa_tskim_s	*bfa_tskim_alloc(struct bfa_s *bfa,
+					struct bfad_tskim_s *dtsk);
+void		bfa_tskim_free(struct bfa_tskim_s *tskim);
+void		bfa_tskim_start(struct bfa_tskim_s *tskim,
+				struct bfa_itnim_s *itnim, lun_t lun,
+				enum fcp_tm_cmnd tm, u8 t_secs);
+void		bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
+				  enum bfi_tskim_status tsk_status);
+
+#endif /* __BFA_FCPIM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfa_fcptm.h patch/drivers/scsi/bfa/include/bfa_fcptm.h
--- orig/drivers/scsi/bfa/include/bfa_fcptm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_fcptm.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c)  2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCPTM_H__
+#define __BFA_FCPTM_H__
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_fcptm.h>
+
+/*
+ * forward declarations
+ */
+struct bfa_tin_s;
+struct bfa_iotm_s;
+struct bfa_tsktm_s;
+
+/*
+ * bfa fcptm module API functions
+ */
+void bfa_fcptm_path_tov_set(struct bfa_s *bfa, u16 path_tov);
+u16 bfa_fcptm_path_tov_get(struct bfa_s *bfa);
+void bfa_fcptm_qdepth_set(struct bfa_s *bfa, u16 q_depth);
+u16 bfa_fcptm_qdepth_get(struct bfa_s *bfa);
+
+/*
+ * bfa tin API functions
+ */
+void bfa_tin_get_stats(struct bfa_tin_s *tin, struct bfa_tin_stats_s *stats);
+void bfa_tin_clear_stats(struct bfa_tin_s *tin);
+
+#endif /* __BFA_FCPTM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfa_svc.h patch/drivers/scsi/bfa/include/bfa_svc.h
--- orig/drivers/scsi/bfa/include/bfa_svc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_svc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,324 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_SVC_H__
+#define __BFA_SVC_H__
+
+/*
+ * forward declarations
+ */
+struct bfa_fcxp_s;
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_rport.h>
+#include <defs/bfa_defs_qos.h>
+#include <cs/bfa_sm.h>
+#include <bfa.h>
+
+/**
+ * 		BFA rport information.
+ */
+struct bfa_rport_info_s {
+	u16        max_frmsz;	/*  max rcv pdu size               */
+	u32        pid : 24,	/*  remote port ID                 */
+			lp_tag : 8;
+	u32        local_pid : 24,	/*  local port ID		    */
+			cisc : 8;	/*  CIRO supported		    */
+	u8         fc_class;	/*  supported FC classes. enum fc_cos */
+	u8         vf_en;		/*  virtual fabric enable          */
+	u16        vf_id;		/*  virtual fabric ID              */
+	enum bfa_pport_speed speed;	/*  Rport's current speed	    */
+};
+
+/**
+ * BFA rport data structure
+ */
+struct bfa_rport_s {
+	struct list_head        qe;	  /*  queue element */
+	bfa_sm_t	      sm; 	  /*  state machine */
+	struct bfa_s          *bfa;	  /*  backpointer to BFA */
+	void                  *rport_drv; /*  fcs/driver rport object */
+	u16              fw_handle; /*  firmware rport handle */
+	u16              rport_tag; /*  BFA rport tag */
+	struct bfa_rport_info_s rport_info; /*  rport info from *fcs/driver */
+	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
+	struct bfa_cb_qe_s    hcb_qe;	 /*  BFA callback qelem */
+	struct bfa_rport_hal_stats_s stats; /*  BFA rport statistics  */
+	struct bfa_rport_qos_attr_s  qos_attr;
+	union a {
+		bfa_status_t    status;	 /*  f/w status */
+		void            *fw_msg; /*  QoS scn event */
+	} event_arg;
+};
+#define BFA_RPORT_FC_COS(_rport)	((_rport)->rport_info.fc_class)
+
+/**
+ * Send completion callback.
+ */
+typedef void (*bfa_cb_fcxp_send_t) (void *bfad_fcxp, struct bfa_fcxp_s *fcxp,
+			void *cbarg, enum bfa_status req_status,
+			u32 rsp_len, u32 resid_len,
+			struct fchs_s *rsp_fchs);
+
+/**
+ * BFA fcxp allocation (asynchronous)
+ */
+typedef void (*bfa_fcxp_alloc_cbfn_t) (void *cbarg, struct bfa_fcxp_s *fcxp);
+
+struct bfa_fcxp_wqe_s {
+	struct list_head         qe;
+	bfa_fcxp_alloc_cbfn_t  alloc_cbfn;
+	void           *alloc_cbarg;
+};
+
+typedef u64 (*bfa_fcxp_get_sgaddr_t) (void *bfad_fcxp, int sgeid);
+typedef u32 (*bfa_fcxp_get_sglen_t) (void *bfad_fcxp, int sgeid);
+
+#define BFA_UF_BUFSZ	(2 * 1024 + 256)
+
+/**
+ * @todo private
+ */
+struct bfa_uf_buf_s {
+	u8         d[BFA_UF_BUFSZ];
+};
+
+
+struct bfa_uf_s {
+	struct list_head	qe;		/*  queue element	  */
+	struct bfa_s	*bfa;		/*  bfa instance	  */
+	u16        uf_tag;		/*  identifying tag f/w messages */
+	u16        vf_id;
+	u16        src_rport_handle;
+	u16        rsvd;
+	u8        	*data_ptr;
+	u16        data_len;	/*  actual receive length	  */
+	u16        pb_len;		/*  posted buffer length	  */
+	void           	*buf_kva;	/*  buffer virtual address	  */
+	u64        buf_pa;		/*  buffer physical address	  */
+	struct bfa_cb_qe_s    hcb_qe;	/*  comp: BFA comp qelem	  */
+	struct bfa_sge_s   	sges[BFI_SGE_INLINE_MAX];
+};
+
+typedef void (*bfa_cb_pport_t) (void *cbarg, enum bfa_status status);
+
+/**
+ * bfa lport login/logout service interface
+ */
+struct bfa_lps_s {
+	struct list_head	qe;		/*  queue element */
+	struct bfa_s	*bfa;		/*  parent bfa instance	*/
+	bfa_sm_t	sm;		/*  finite state machine	*/
+	u8		lp_tag;		/*  lport tag			*/
+	u8		reqq;		/*  lport request queue	*/
+	u8		alpa;		/*  ALPA for loop topologies	*/
+	u32	lp_pid;		/*  lport port ID		*/
+	bfa_boolean_t	fdisc;		/*  send FDISC instead of FLOGI*/
+	bfa_boolean_t	auth_en;	/*  enable authentication	*/
+	bfa_boolean_t	auth_req;	/*  authentication required	*/
+	bfa_boolean_t	npiv_en;	/*  NPIV is allowed by peer	*/
+	bfa_boolean_t	fport;		/*  attached peer is F_PORT	*/
+	bfa_boolean_t	brcd_switch;/*  attached peer is brcd switch	*/
+	bfa_status_t	status;		/*  login status		*/
+	u16	pdusz;		/*  max receive PDU size 	*/
+	u16	pr_bbcred;	/*  BB_CREDIT from peer 	*/
+	u8		lsrjt_rsn;	/*  LSRJT reason		*/
+	u8		lsrjt_expl;	/*  LSRJT explanation		*/
+	wwn_t		pwwn;		/*  port wwn of lport		*/
+	wwn_t		nwwn;		/*  node wwn of lport		*/
+	wwn_t		pr_pwwn;	/*  port wwn of lport peer	*/
+	wwn_t		pr_nwwn;	/*  node wwn of lport peer	*/
+	mac_t		lp_mac;		/*  fpma/spma MAC for lport	*/
+	mac_t		fcf_mac;	/*  FCF MAC of lport		*/
+	struct bfa_reqq_wait_s	wqe;	/*  request wait queue element	*/
+	void		*uarg;		/*  user callback arg		*/
+	struct bfa_cb_qe_s hcb_qe;	/*  comp: callback qelem	*/
+	struct bfi_lps_login_rsp_s *loginrsp;
+	bfa_eproto_status_t	ext_status;
+};
+
+/*
+ * bfa pport API functions
+ */
+bfa_status_t bfa_pport_enable(struct bfa_s *bfa);
+bfa_status_t bfa_pport_disable(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_speed(struct bfa_s *bfa,
+			enum bfa_pport_speed speed);
+enum bfa_pport_speed bfa_pport_get_speed(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_topology(struct bfa_s *bfa,
+			enum bfa_pport_topology topo);
+enum bfa_pport_topology bfa_pport_get_topology(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
+bfa_boolean_t bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
+u8 bfa_pport_get_myalpa(struct bfa_s *bfa);
+bfa_status_t bfa_pport_clr_hardalpa(struct bfa_s *bfa);
+bfa_status_t bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
+u16 bfa_pport_get_maxfrsize(struct bfa_s *bfa);
+u32 bfa_pport_mypid(struct bfa_s *bfa);
+u8 bfa_pport_get_rx_bbcredit(struct bfa_s *bfa);
+bfa_status_t bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap);
+bfa_status_t bfa_pport_trunk_disable(struct bfa_s *bfa);
+bfa_boolean_t bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
+void bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
+wwn_t bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
+bfa_status_t bfa_pport_get_stats(struct bfa_s *bfa,
+			union bfa_pport_stats_u *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+void bfa_pport_event_register(struct bfa_s *bfa,
+			void (*event_cbfn) (void *cbarg,
+			bfa_pport_event_t event), void *event_cbarg);
+bfa_boolean_t bfa_pport_is_disabled(struct bfa_s *bfa);
+void bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
+void bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
+bfa_status_t bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa,
+			enum bfa_pport_speed speed);
+enum bfa_pport_speed bfa_pport_get_ratelim_speed(struct bfa_s *bfa);
+
+void bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
+void bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status);
+void bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+			bfa_boolean_t link_e2e_beacon);
+void bfa_cb_pport_event(void *cbarg, bfa_pport_event_t event);
+void bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr);
+void bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+			struct bfa_qos_vc_attr_s *qos_vc_attr);
+bfa_status_t bfa_pport_get_qos_stats(struct bfa_s *bfa,
+			union bfa_pport_stats_u *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+bfa_boolean_t     bfa_pport_is_ratelim(struct bfa_s *bfa);
+bfa_boolean_t	bfa_pport_is_linkup(struct bfa_s *bfa);
+
+/*
+ * bfa rport API functions
+ */
+struct bfa_rport_s *bfa_rport_create(struct bfa_s *bfa, void *rport_drv);
+void bfa_rport_delete(struct bfa_rport_s *rport);
+void bfa_rport_online(struct bfa_rport_s *rport,
+			struct bfa_rport_info_s *rport_info);
+void bfa_rport_offline(struct bfa_rport_s *rport);
+void bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed);
+void bfa_rport_get_stats(struct bfa_rport_s *rport,
+			struct bfa_rport_hal_stats_s *stats);
+void bfa_rport_clear_stats(struct bfa_rport_s *rport);
+void bfa_cb_rport_online(void *rport);
+void bfa_cb_rport_offline(void *rport);
+void bfa_cb_rport_qos_scn_flowid(void *rport,
+			struct bfa_rport_qos_attr_s old_qos_attr,
+			struct bfa_rport_qos_attr_s new_qos_attr);
+void bfa_cb_rport_qos_scn_prio(void *rport,
+			struct bfa_rport_qos_attr_s old_qos_attr,
+			struct bfa_rport_qos_attr_s new_qos_attr);
+void bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
+			struct bfa_rport_qos_attr_s *qos_attr);
+
+/*
+ * bfa fcxp API functions
+ */
+struct bfa_fcxp_s *bfa_fcxp_alloc(void *bfad_fcxp, struct bfa_s *bfa,
+			int nreq_sgles, int nrsp_sgles,
+			bfa_fcxp_get_sgaddr_t get_req_sga,
+			bfa_fcxp_get_sglen_t get_req_sglen,
+			bfa_fcxp_get_sgaddr_t get_rsp_sga,
+			bfa_fcxp_get_sglen_t get_rsp_sglen);
+void bfa_fcxp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
+			bfa_fcxp_alloc_cbfn_t alloc_cbfn, void *cbarg);
+void bfa_fcxp_walloc_cancel(struct bfa_s *bfa,
+			struct bfa_fcxp_wqe_s *wqe);
+void bfa_fcxp_discard(struct bfa_fcxp_s *fcxp);
+
+void *bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp);
+void *bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp);
+
+void bfa_fcxp_free(struct bfa_fcxp_s *fcxp);
+
+void bfa_fcxp_send(struct bfa_fcxp_s *fcxp,
+			struct bfa_rport_s *rport, u16 vf_id, u8 lp_tag,
+			bfa_boolean_t cts, enum fc_cos cos,
+			u32 reqlen, struct fchs_s *fchs,
+			bfa_cb_fcxp_send_t cbfn,
+			void *cbarg,
+			u32 rsp_maxlen, u8 rsp_timeout);
+bfa_status_t bfa_fcxp_abort(struct bfa_fcxp_s *fcxp);
+u32        bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp);
+u32	bfa_fcxp_get_maxrsp(struct bfa_s *bfa);
+
+static inline void *
+bfa_uf_get_frmbuf(struct bfa_uf_s *uf)
+{
+	return uf->data_ptr;
+}
+
+static inline   u16
+bfa_uf_get_frmlen(struct bfa_uf_s *uf)
+{
+	return uf->data_len;
+}
+
+/**
+ *      Callback prototype for unsolicited frame receive handler.
+ *
+ * @param[in]           cbarg           callback arg for receive handler
+ * @param[in]           uf              unsolicited frame descriptor
+ *
+ * @return None
+ */
+typedef void (*bfa_cb_uf_recv_t) (void *cbarg, struct bfa_uf_s *uf);
+
+/*
+ * bfa uf API functions
+ */
+void bfa_uf_recv_register(struct bfa_s *bfa, bfa_cb_uf_recv_t ufrecv,
+			void *cbarg);
+void bfa_uf_free(struct bfa_uf_s *uf);
+
+/**
+ * bfa lport service api
+ */
+
+struct bfa_lps_s *bfa_lps_alloc(struct bfa_s *bfa);
+void bfa_lps_delete(struct bfa_lps_s *lps);
+void bfa_lps_discard(struct bfa_lps_s *lps);
+void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa, u16 pdusz,
+		   wwn_t pwwn, wwn_t nwwn, bfa_boolean_t auth_en);
+void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
+		   wwn_t nwwn);
+void bfa_lps_flogo(struct bfa_lps_s *lps);
+void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
+u8 bfa_lps_get_tag(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_npiv_en(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_fport(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_brcd_fabric(struct bfa_lps_s *lps);
+bfa_boolean_t bfa_lps_is_authreq(struct bfa_lps_s *lps);
+bfa_eproto_status_t bfa_lps_get_extstatus(struct bfa_lps_s *lps);
+u32 bfa_lps_get_pid(struct bfa_lps_s *lps);
+u8 bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid);
+u16 bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps);
+wwn_t bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps);
+wwn_t bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps);
+u8 bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps);
+u8 bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps);
+void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
+void bfa_cb_lps_flogo_comp(void *bfad, void *uarg);
+void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
+void bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg);
+
+#endif /* __BFA_SVC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfa_timer.h patch/drivers/scsi/bfa/include/bfa_timer.h
--- orig/drivers/scsi/bfa/include/bfa_timer.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfa_timer.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_TIMER_H__
+#define __BFA_TIMER_H__
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_q.h>
+
+struct bfa_s;
+
+typedef void (*bfa_timer_cbfn_t)(void *);
+
+/**
+ * BFA timer data structure
+ */
+struct bfa_timer_s {
+	struct list_head	qe;
+	bfa_timer_cbfn_t timercb;
+	void            *arg;
+	int             timeout;	/**< in millisecs. */
+};
+
+/**
+ * Timer module structure
+ */
+struct bfa_timer_mod_s {
+	struct list_head timer_q;
+};
+
+#define BFA_TIMER_FREQ 500 /**< specified in millisecs */
+
+void bfa_timer_beat(struct bfa_timer_mod_s *mod);
+void bfa_timer_init(struct bfa_timer_mod_s *mod);
+void bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
+			bfa_timer_cbfn_t timercb, void *arg,
+			unsigned int timeout);
+void bfa_timer_stop(struct bfa_timer_s *timer);
+
+#endif /* __BFA_TIMER_H__ */
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi.h patch/drivers/scsi/bfa/include/bfi/bfi.h
--- orig/drivers/scsi/bfa/include/bfi/bfi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,174 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_H__
+#define __BFI_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_status.h>
+
+#pragma pack(1)
+
+/**
+ * Msg header common to all msgs
+ */
+struct bfi_mhdr_s {
+	u8         msg_class;	/*  @ref bfi_mclass_t	    */
+	u8         msg_id;		/*  msg opcode with in the class   */
+	union {
+		struct {
+			u8         rsvd;
+			u8         lpu_id;	/*  msg destination	    */
+		} h2i;
+		u16        i2htok;	/*  token in msgs to host	    */
+	} mtag;
+};
+
+#define bfi_h2i_set(_mh, _mc, _op, _lpuid) do {		\
+	(_mh).msg_class 		= (_mc);      \
+	(_mh).msg_id			= (_op);      \
+	(_mh).mtag.h2i.lpu_id	= (_lpuid);      \
+} while (0)
+
+#define bfi_i2h_set(_mh, _mc, _op, _i2htok) do {		\
+	(_mh).msg_class 		= (_mc);      \
+	(_mh).msg_id			= (_op);      \
+	(_mh).mtag.i2htok		= (_i2htok);      \
+} while (0)
+
+/*
+ * Message opcodes: 0-127 to firmware, 128-255 to host
+ */
+#define BFI_I2H_OPCODE_BASE	128
+#define BFA_I2HM(_x) 			((_x) + BFI_I2H_OPCODE_BASE)
+
+/**
+ ****************************************************************************
+ *
+ * Scatter Gather Element and Page definition
+ *
+ ****************************************************************************
+ */
+
+#define BFI_SGE_INLINE	1
+#define BFI_SGE_INLINE_MAX	(BFI_SGE_INLINE + 1)
+
+/**
+ * SG Flags
+ */
+enum {
+	BFI_SGE_DATA	= 0,	/*  data address, not last	     */
+	BFI_SGE_DATA_CPL	= 1,	/*  data addr, last in current page */
+	BFI_SGE_DATA_LAST	= 3,	/*  data address, last		     */
+	BFI_SGE_LINK	= 2,	/*  link address		     */
+	BFI_SGE_PGDLEN	= 2,	/*  cumulative data length for page */
+};
+
+/**
+ * DMA addresses
+ */
+union bfi_addr_u {
+	struct {
+		u32        addr_lo;
+		u32        addr_hi;
+	} a32;
+};
+
+/**
+ * Scatter Gather Element
+ */
+struct bfi_sge_s {
+#ifdef __BIGENDIAN
+	u32        flags	: 2,
+			rsvd	: 2,
+			sg_len	: 28;
+#else
+	u32        sg_len	: 28,
+			rsvd	: 2,
+			flags	: 2;
+#endif
+	union bfi_addr_u sga;
+};
+
+/**
+ * Scatter Gather Page
+ */
+#define BFI_SGPG_DATA_SGES		7
+#define BFI_SGPG_SGES_MAX		(BFI_SGPG_DATA_SGES + 1)
+#define BFI_SGPG_RSVD_WD_LEN	8
+struct bfi_sgpg_s {
+	struct bfi_sge_s sges[BFI_SGPG_SGES_MAX];
+	u32	rsvd[BFI_SGPG_RSVD_WD_LEN];
+};
+
+/*
+ * Large Message structure - 128 Bytes size Msgs
+ */
+#define BFI_LMSG_SZ		128
+#define BFI_LMSG_PL_WSZ	\
+			((BFI_LMSG_SZ - sizeof(struct bfi_mhdr_s)) / 4)
+
+struct bfi_msg_s {
+	struct bfi_mhdr_s mhdr;
+	u32	pl[BFI_LMSG_PL_WSZ];
+};
+
+/**
+ * Mailbox message structure
+ */
+#define BFI_MBMSG_SZ		7
+struct bfi_mbmsg_s {
+	struct bfi_mhdr_s	mh;
+	u32		pl[BFI_MBMSG_SZ];
+};
+
+/**
+ * Message Classes
+ */
+enum bfi_mclass {
+	BFI_MC_IOC		= 1,	/*  IO Controller (IOC)	    */
+	BFI_MC_DIAG		= 2,	/*  Diagnostic Msgs		    */
+	BFI_MC_FLASH		= 3,	/*  Flash message class	    */
+	BFI_MC_CEE		= 4,
+	BFI_MC_FC_PORT		= 5,	/*  FC port		   	    */
+	BFI_MC_IOCFC		= 6,	/*  FC - IO Controller (IOC)	    */
+	BFI_MC_LL		= 7,	/*  Link Layer		 	    */
+	BFI_MC_UF		= 8,	/*  Unsolicited frame receive	    */
+	BFI_MC_FCXP		= 9,	/*  FC Transport		    */
+	BFI_MC_LPS		= 10,	/*  lport fc login services	    */
+	BFI_MC_RPORT		= 11,	/*  Remote port		    */
+	BFI_MC_ITNIM		= 12,	/*  I-T nexus (Initiator mode)	    */
+	BFI_MC_IOIM_READ	= 13,	/*  read IO (Initiator mode)	    */
+	BFI_MC_IOIM_WRITE	= 14,	/*  write IO (Initiator mode)	    */
+	BFI_MC_IOIM_IO		= 15,	/*  IO (Initiator mode)	    */
+	BFI_MC_IOIM		= 16,	/*  IO (Initiator mode)	    */
+	BFI_MC_IOIM_IOCOM	= 17,	/*  good IO completion		    */
+	BFI_MC_TSKIM		= 18,	/*  Initiator Task management	    */
+	BFI_MC_SBOOT		= 19,	/*  SAN boot services		    */
+	BFI_MC_IPFC		= 20,	/*  IP over FC Msgs		    */
+	BFI_MC_PORT		= 21,	/*  Physical port		    */
+	BFI_MC_MAX		= 32
+};
+
+#define BFI_IOC_MAX_CQS		4
+#define BFI_IOC_MAX_CQS_ASIC	8
+#define BFI_IOC_MSGLEN_MAX	32	/* 32 bytes */
+
+#pragma pack()
+
+#endif /* __BFI_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_boot.h patch/drivers/scsi/bfa/include/bfi/bfi_boot.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_boot.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_boot.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+/*
+ * bfi_boot.h
+ */
+
+#ifndef __BFI_BOOT_H__
+#define __BFI_BOOT_H__
+
+#define BFI_BOOT_TYPE_OFF		8
+#define BFI_BOOT_PARAM_OFF		12
+
+#define BFI_BOOT_TYPE_NORMAL 		0	/* param is device id */
+#define	BFI_BOOT_TYPE_FLASH		1
+#define	BFI_BOOT_TYPE_MEMTEST		2
+
+#define BFI_BOOT_MEMTEST_RES_ADDR   0x900
+#define BFI_BOOT_MEMTEST_RES_SIG    0xA0A1A2A3
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_cbreg.h patch/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_cbreg.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_cbreg.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,305 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * bfi_cbreg.h crossbow host block register definitions
+ *
+ * !!! Do not edit. Auto generated. !!!
+ */
+
+#ifndef __BFI_CBREG_H__
+#define __BFI_CBREG_H__
+
+
+#define HOSTFN0_INT_STATUS               0x00014000
+#define __HOSTFN0_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN0_INT_STATUS_LVL_SH      20
+#define __HOSTFN0_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN0_INT_STATUS_LVL_SH)
+#define __HOSTFN0_INT_STATUS_P           0x000fffff
+#define HOSTFN0_INT_MSK                  0x00014004
+#define HOST_PAGE_NUM_FN0                0x00014008
+#define __HOST_PAGE_NUM_FN               0x000001ff
+#define HOSTFN1_INT_STATUS               0x00014100
+#define __HOSTFN1_INT_STAT_LVL_MK        0x00f00000
+#define __HOSTFN1_INT_STAT_LVL_SH        20
+#define __HOSTFN1_INT_STAT_LVL(_v)       ((_v) << __HOSTFN1_INT_STAT_LVL_SH)
+#define __HOSTFN1_INT_STAT_P             0x000fffff
+#define HOSTFN1_INT_MSK                  0x00014104
+#define HOST_PAGE_NUM_FN1                0x00014108
+#define APP_PLL_400_CTL_REG              0x00014204
+#define __P_400_PLL_LOCK                 0x80000000
+#define __APP_PLL_400_SRAM_USE_100MHZ    0x00100000
+#define __APP_PLL_400_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_400_RESET_TIMER_SH     17
+#define __APP_PLL_400_RESET_TIMER(_v)    ((_v) << __APP_PLL_400_RESET_TIMER_SH)
+#define __APP_PLL_400_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_400_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_400_CNTLMT0_1_SH       14
+#define __APP_PLL_400_CNTLMT0_1(_v)      ((_v) << __APP_PLL_400_CNTLMT0_1_SH)
+#define __APP_PLL_400_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_400_JITLMT0_1_SH       12
+#define __APP_PLL_400_JITLMT0_1(_v)      ((_v) << __APP_PLL_400_JITLMT0_1_SH)
+#define __APP_PLL_400_HREF               0x00000800
+#define __APP_PLL_400_HDIV               0x00000400
+#define __APP_PLL_400_P0_1_MK            0x00000300
+#define __APP_PLL_400_P0_1_SH            8
+#define __APP_PLL_400_P0_1(_v)           ((_v) << __APP_PLL_400_P0_1_SH)
+#define __APP_PLL_400_Z0_2_MK            0x000000e0
+#define __APP_PLL_400_Z0_2_SH            5
+#define __APP_PLL_400_Z0_2(_v)           ((_v) << __APP_PLL_400_Z0_2_SH)
+#define __APP_PLL_400_RSEL200500         0x00000010
+#define __APP_PLL_400_ENARST             0x00000008
+#define __APP_PLL_400_BYPASS             0x00000004
+#define __APP_PLL_400_LRESETN            0x00000002
+#define __APP_PLL_400_ENABLE             0x00000001
+#define APP_PLL_212_CTL_REG              0x00014208
+#define __P_212_PLL_LOCK                 0x80000000
+#define __APP_PLL_212_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_212_RESET_TIMER_SH     17
+#define __APP_PLL_212_RESET_TIMER(_v)    ((_v) << __APP_PLL_212_RESET_TIMER_SH)
+#define __APP_PLL_212_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_212_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_212_CNTLMT0_1_SH       14
+#define __APP_PLL_212_CNTLMT0_1(_v)      ((_v) << __APP_PLL_212_CNTLMT0_1_SH)
+#define __APP_PLL_212_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_212_JITLMT0_1_SH       12
+#define __APP_PLL_212_JITLMT0_1(_v)      ((_v) << __APP_PLL_212_JITLMT0_1_SH)
+#define __APP_PLL_212_HREF               0x00000800
+#define __APP_PLL_212_HDIV               0x00000400
+#define __APP_PLL_212_P0_1_MK            0x00000300
+#define __APP_PLL_212_P0_1_SH            8
+#define __APP_PLL_212_P0_1(_v)           ((_v) << __APP_PLL_212_P0_1_SH)
+#define __APP_PLL_212_Z0_2_MK            0x000000e0
+#define __APP_PLL_212_Z0_2_SH            5
+#define __APP_PLL_212_Z0_2(_v)           ((_v) << __APP_PLL_212_Z0_2_SH)
+#define __APP_PLL_212_RSEL200500         0x00000010
+#define __APP_PLL_212_ENARST             0x00000008
+#define __APP_PLL_212_BYPASS             0x00000004
+#define __APP_PLL_212_LRESETN            0x00000002
+#define __APP_PLL_212_ENABLE             0x00000001
+#define HOST_SEM0_REG                    0x00014230
+#define __HOST_SEMAPHORE                 0x00000001
+#define HOST_SEM1_REG                    0x00014234
+#define HOST_SEM2_REG                    0x00014238
+#define HOST_SEM3_REG                    0x0001423c
+#define HOST_SEM0_INFO_REG               0x00014240
+#define HOST_SEM1_INFO_REG               0x00014244
+#define HOST_SEM2_INFO_REG               0x00014248
+#define HOST_SEM3_INFO_REG               0x0001424c
+#define HOSTFN0_LPU0_CMD_STAT            0x00019000
+#define __HOSTFN0_LPU0_MBOX_INFO_MK      0xfffffffe
+#define __HOSTFN0_LPU0_MBOX_INFO_SH      1
+#define __HOSTFN0_LPU0_MBOX_INFO(_v)     ((_v) << __HOSTFN0_LPU0_MBOX_INFO_SH)
+#define __HOSTFN0_LPU0_MBOX_CMD_STATUS   0x00000001
+#define LPU0_HOSTFN0_CMD_STAT            0x00019008
+#define __LPU0_HOSTFN0_MBOX_INFO_MK      0xfffffffe
+#define __LPU0_HOSTFN0_MBOX_INFO_SH      1
+#define __LPU0_HOSTFN0_MBOX_INFO(_v)     ((_v) << __LPU0_HOSTFN0_MBOX_INFO_SH)
+#define __LPU0_HOSTFN0_MBOX_CMD_STATUS   0x00000001
+#define HOSTFN1_LPU1_CMD_STAT            0x00019014
+#define __HOSTFN1_LPU1_MBOX_INFO_MK      0xfffffffe
+#define __HOSTFN1_LPU1_MBOX_INFO_SH      1
+#define __HOSTFN1_LPU1_MBOX_INFO(_v)     ((_v) << __HOSTFN1_LPU1_MBOX_INFO_SH)
+#define __HOSTFN1_LPU1_MBOX_CMD_STATUS   0x00000001
+#define LPU1_HOSTFN1_CMD_STAT            0x0001901c
+#define __LPU1_HOSTFN1_MBOX_INFO_MK      0xfffffffe
+#define __LPU1_HOSTFN1_MBOX_INFO_SH      1
+#define __LPU1_HOSTFN1_MBOX_INFO(_v)     ((_v) << __LPU1_HOSTFN1_MBOX_INFO_SH)
+#define __LPU1_HOSTFN1_MBOX_CMD_STATUS   0x00000001
+#define CPE_Q0_DEPTH                     0x00010014
+#define CPE_Q0_PI                        0x0001001c
+#define CPE_Q0_CI                        0x00010020
+#define CPE_Q1_DEPTH                     0x00010034
+#define CPE_Q1_PI                        0x0001003c
+#define CPE_Q1_CI                        0x00010040
+#define CPE_Q2_DEPTH                     0x00010054
+#define CPE_Q2_PI                        0x0001005c
+#define CPE_Q2_CI                        0x00010060
+#define CPE_Q3_DEPTH                     0x00010074
+#define CPE_Q3_PI                        0x0001007c
+#define CPE_Q3_CI                        0x00010080
+#define CPE_Q4_DEPTH                     0x00010094
+#define CPE_Q4_PI                        0x0001009c
+#define CPE_Q4_CI                        0x000100a0
+#define CPE_Q5_DEPTH                     0x000100b4
+#define CPE_Q5_PI                        0x000100bc
+#define CPE_Q5_CI                        0x000100c0
+#define CPE_Q6_DEPTH                     0x000100d4
+#define CPE_Q6_PI                        0x000100dc
+#define CPE_Q6_CI                        0x000100e0
+#define CPE_Q7_DEPTH                     0x000100f4
+#define CPE_Q7_PI                        0x000100fc
+#define CPE_Q7_CI                        0x00010100
+#define RME_Q0_DEPTH                     0x00011014
+#define RME_Q0_PI                        0x0001101c
+#define RME_Q0_CI                        0x00011020
+#define RME_Q1_DEPTH                     0x00011034
+#define RME_Q1_PI                        0x0001103c
+#define RME_Q1_CI                        0x00011040
+#define RME_Q2_DEPTH                     0x00011054
+#define RME_Q2_PI                        0x0001105c
+#define RME_Q2_CI                        0x00011060
+#define RME_Q3_DEPTH                     0x00011074
+#define RME_Q3_PI                        0x0001107c
+#define RME_Q3_CI                        0x00011080
+#define RME_Q4_DEPTH                     0x00011094
+#define RME_Q4_PI                        0x0001109c
+#define RME_Q4_CI                        0x000110a0
+#define RME_Q5_DEPTH                     0x000110b4
+#define RME_Q5_PI                        0x000110bc
+#define RME_Q5_CI                        0x000110c0
+#define RME_Q6_DEPTH                     0x000110d4
+#define RME_Q6_PI                        0x000110dc
+#define RME_Q6_CI                        0x000110e0
+#define RME_Q7_DEPTH                     0x000110f4
+#define RME_Q7_PI                        0x000110fc
+#define RME_Q7_CI                        0x00011100
+#define PSS_CTL_REG                      0x00018800
+#define __PSS_I2C_CLK_DIV_MK             0x00030000
+#define __PSS_I2C_CLK_DIV_SH             16
+#define __PSS_I2C_CLK_DIV(_v)            ((_v) << __PSS_I2C_CLK_DIV_SH)
+#define __PSS_LMEM_INIT_DONE             0x00001000
+#define __PSS_LMEM_RESET                 0x00000200
+#define __PSS_LMEM_INIT_EN               0x00000100
+#define __PSS_LPU1_RESET                 0x00000002
+#define __PSS_LPU0_RESET                 0x00000001
+
+
+/*
+ * These definitions are either in error/missing in spec. Its auto-generated
+ * from hard coded values in regparse.pl.
+ */
+#define __EMPHPOST_AT_4G_MK_FIX          0x0000001c
+#define __EMPHPOST_AT_4G_SH_FIX          0x00000002
+#define __EMPHPRE_AT_4G_FIX              0x00000003
+#define __SFP_TXRATE_EN_FIX              0x00000100
+#define __SFP_RXRATE_EN_FIX              0x00000080
+
+
+/*
+ * These register definitions are auto-generated from hard coded values
+ * in regparse.pl.
+ */
+#define HOSTFN0_LPU_MBOX0_0              0x00019200
+#define HOSTFN1_LPU_MBOX0_8              0x00019260
+#define LPU_HOSTFN0_MBOX0_0              0x00019280
+#define LPU_HOSTFN1_MBOX0_8              0x000192e0
+
+
+/*
+ * These register mapping definitions are auto-generated from mapping tables
+ * in regparse.pl.
+ */
+#define BFA_IOC0_HBEAT_REG               HOST_SEM0_INFO_REG
+#define BFA_IOC0_STATE_REG               HOST_SEM1_INFO_REG
+#define BFA_IOC1_HBEAT_REG               HOST_SEM2_INFO_REG
+#define BFA_IOC1_STATE_REG               HOST_SEM3_INFO_REG
+#define BFA_FW_USE_COUNT                 HOST_SEM4_INFO_REG
+
+#define CPE_Q_DEPTH(__n) \
+	(CPE_Q0_DEPTH + (__n) * (CPE_Q1_DEPTH - CPE_Q0_DEPTH))
+#define CPE_Q_PI(__n) \
+	(CPE_Q0_PI + (__n) * (CPE_Q1_PI - CPE_Q0_PI))
+#define CPE_Q_CI(__n) \
+	(CPE_Q0_CI + (__n) * (CPE_Q1_CI - CPE_Q0_CI))
+#define RME_Q_DEPTH(__n) \
+	(RME_Q0_DEPTH + (__n) * (RME_Q1_DEPTH - RME_Q0_DEPTH))
+#define RME_Q_PI(__n) \
+	(RME_Q0_PI + (__n) * (RME_Q1_PI - RME_Q0_PI))
+#define RME_Q_CI(__n) \
+	(RME_Q0_CI + (__n) * (RME_Q1_CI - RME_Q0_CI))
+
+#define CPE_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define RME_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define CPE_Q_MASK(__q)  ((__q) & 0x3)
+#define RME_Q_MASK(__q)  ((__q) & 0x3)
+
+
+/*
+ * PCI MSI-X vector defines
+ */
+enum {
+    BFA_MSIX_CPE_Q0 = 0,
+    BFA_MSIX_CPE_Q1 = 1,
+    BFA_MSIX_CPE_Q2 = 2,
+    BFA_MSIX_CPE_Q3 = 3,
+    BFA_MSIX_CPE_Q4 = 4,
+    BFA_MSIX_CPE_Q5 = 5,
+    BFA_MSIX_CPE_Q6 = 6,
+    BFA_MSIX_CPE_Q7 = 7,
+    BFA_MSIX_RME_Q0 = 8,
+    BFA_MSIX_RME_Q1 = 9,
+    BFA_MSIX_RME_Q2 = 10,
+    BFA_MSIX_RME_Q3 = 11,
+    BFA_MSIX_RME_Q4 = 12,
+    BFA_MSIX_RME_Q5 = 13,
+    BFA_MSIX_RME_Q6 = 14,
+    BFA_MSIX_RME_Q7 = 15,
+    BFA_MSIX_ERR_EMC = 16,
+    BFA_MSIX_ERR_LPU0 = 17,
+    BFA_MSIX_ERR_LPU1 = 18,
+    BFA_MSIX_ERR_PSS = 19,
+    BFA_MSIX_MBOX_LPU0 = 20,
+    BFA_MSIX_MBOX_LPU1 = 21,
+    BFA_MSIX_CB_MAX = 22,
+};
+
+/*
+ * And corresponding host interrupt status bit field defines
+ */
+#define __HFN_INT_CPE_Q0                   0x00000001U
+#define __HFN_INT_CPE_Q1                   0x00000002U
+#define __HFN_INT_CPE_Q2                   0x00000004U
+#define __HFN_INT_CPE_Q3                   0x00000008U
+#define __HFN_INT_CPE_Q4                   0x00000010U
+#define __HFN_INT_CPE_Q5                   0x00000020U
+#define __HFN_INT_CPE_Q6                   0x00000040U
+#define __HFN_INT_CPE_Q7                   0x00000080U
+#define __HFN_INT_RME_Q0                   0x00000100U
+#define __HFN_INT_RME_Q1                   0x00000200U
+#define __HFN_INT_RME_Q2                   0x00000400U
+#define __HFN_INT_RME_Q3                   0x00000800U
+#define __HFN_INT_RME_Q4                   0x00001000U
+#define __HFN_INT_RME_Q5                   0x00002000U
+#define __HFN_INT_RME_Q6                   0x00004000U
+#define __HFN_INT_RME_Q7                   0x00008000U
+#define __HFN_INT_ERR_EMC                  0x00010000U
+#define __HFN_INT_ERR_LPU0                 0x00020000U
+#define __HFN_INT_ERR_LPU1                 0x00040000U
+#define __HFN_INT_ERR_PSS                  0x00080000U
+#define __HFN_INT_MBOX_LPU0                0x00100000U
+#define __HFN_INT_MBOX_LPU1                0x00200000U
+#define __HFN_INT_MBOX1_LPU0               0x00400000U
+#define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_CPE_MASK                 0x000000ffU
+#define __HFN_INT_RME_MASK                 0x0000ff00U
+
+
+/*
+ * crossbow memory map.
+ */
+#define PSS_SMEM_PAGE_START	0x8000
+#define PSS_SMEM_PGNUM(_pg0, _ma)	((_pg0) + ((_ma) >> 15))
+#define PSS_SMEM_PGOFF(_ma)	((_ma) & 0x7fff)
+
+/*
+ * End of crossbow memory map
+ */
+
+
+#endif /* __BFI_CBREG_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_cee.h patch/drivers/scsi/bfa/include/bfi/bfi_cee.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_cee.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_cee.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+/**
+ *  Copyright (c) 2006-2009 Brocade Communications Systems, Inc.
+ *  All rights reserved.
+ *
+ *  bfi_dcbx.h BFI Interface (Mailbox commands and related structures)
+ * between host driver and DCBX/LLDP firmware module.
+ *
+**/
+
+#ifndef __BFI_CEE_H__
+#define __BFI_CEE_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+
+enum bfi_cee_h2i_msgs_e {
+	BFI_CEE_H2I_GET_CFG_REQ = 1,
+	BFI_CEE_H2I_RESET_STATS = 2,
+	BFI_CEE_H2I_GET_STATS_REQ = 3,
+};
+
+
+enum bfi_cee_i2h_msgs_e {
+	BFI_CEE_I2H_GET_CFG_RSP = BFA_I2HM(1),
+	BFI_CEE_I2H_RESET_STATS_RSP = BFA_I2HM(2),
+	BFI_CEE_I2H_GET_STATS_RSP = BFA_I2HM(3),
+};
+
+
+/* Data structures */
+
+/*
+ * BFI_CEE_H2I_RESET_STATS
+ */
+struct bfi_lldp_reset_stats_s {
+	struct bfi_mhdr_s  mh;
+};
+
+/*
+ * BFI_CEE_H2I_RESET_STATS
+ */
+struct bfi_cee_reset_stats_s {
+	struct bfi_mhdr_s  mh;
+};
+
+/*
+ * BFI_CEE_H2I_GET_CFG_REQ
+ */
+struct bfi_cee_get_req_s {
+	struct bfi_mhdr_s  mh;
+	union bfi_addr_u   dma_addr;
+};
+
+
+/*
+ * BFI_CEE_I2H_GET_CFG_RSP
+ */
+struct bfi_cee_get_rsp_s {
+	struct bfi_mhdr_s  mh;
+	u8            cmd_status;
+	u8            rsvd[3];
+};
+
+/*
+ * BFI_CEE_H2I_GET_STATS_REQ
+ */
+struct bfi_cee_stats_req_s {
+	struct bfi_mhdr_s  mh;
+	union bfi_addr_u   dma_addr;
+};
+
+
+/*
+ * BFI_CEE_I2H_GET_STATS_RSP
+ */
+struct bfi_cee_stats_rsp_s {
+	struct bfi_mhdr_s  mh;
+	u8 		   cmd_status;
+	u8 		   rsvd[3];
+};
+
+
+
+union bfi_cee_h2i_msg_u {
+	struct bfi_mhdr_s           mh;
+	struct bfi_cee_get_req_s   get_req;
+	struct bfi_cee_stats_req_s stats_req;
+};
+
+
+union bfi_cee_i2h_msg_u {
+	struct bfi_mhdr_s         mh;
+	struct bfi_cee_get_rsp_s  get_rsp;
+	struct bfi_cee_stats_rsp_s stats_rsp;
+};
+
+#pragma pack()
+
+
+#endif /* __BFI_CEE_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_ctreg.h patch/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_ctreg.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ctreg.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,611 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * bfi_ctreg.h catapult host block register definitions
+ *
+ * !!! Do not edit. Auto generated. !!!
+ */
+
+#ifndef __BFI_CTREG_H__
+#define __BFI_CTREG_H__
+
+
+#define HOSTFN0_LPU_MBOX0_0              0x00019200
+#define HOSTFN1_LPU_MBOX0_8              0x00019260
+#define LPU_HOSTFN0_MBOX0_0              0x00019280
+#define LPU_HOSTFN1_MBOX0_8              0x000192e0
+#define HOSTFN2_LPU_MBOX0_0              0x00019400
+#define HOSTFN3_LPU_MBOX0_8              0x00019460
+#define LPU_HOSTFN2_MBOX0_0              0x00019480
+#define LPU_HOSTFN3_MBOX0_8              0x000194e0
+#define HOSTFN0_INT_STATUS               0x00014000
+#define __HOSTFN0_HALT_OCCURRED          0x01000000
+#define __HOSTFN0_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN0_INT_STATUS_LVL_SH      20
+#define __HOSTFN0_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN0_INT_STATUS_LVL_SH)
+#define __HOSTFN0_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN0_INT_STATUS_P_SH        16
+#define __HOSTFN0_INT_STATUS_P(_v)       ((_v) << __HOSTFN0_INT_STATUS_P_SH)
+#define __HOSTFN0_INT_STATUS_F           0x0000ffff
+#define HOSTFN0_INT_MSK                  0x00014004
+#define HOST_PAGE_NUM_FN0                0x00014008
+#define __HOST_PAGE_NUM_FN               0x000001ff
+#define HOST_MSIX_ERR_INDEX_FN0          0x0001400c
+#define __MSIX_ERR_INDEX_FN              0x000001ff
+#define HOSTFN1_INT_STATUS               0x00014100
+#define __HOSTFN1_HALT_OCCURRED          0x01000000
+#define __HOSTFN1_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN1_INT_STATUS_LVL_SH      20
+#define __HOSTFN1_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN1_INT_STATUS_LVL_SH)
+#define __HOSTFN1_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN1_INT_STATUS_P_SH        16
+#define __HOSTFN1_INT_STATUS_P(_v)       ((_v) << __HOSTFN1_INT_STATUS_P_SH)
+#define __HOSTFN1_INT_STATUS_F           0x0000ffff
+#define HOSTFN1_INT_MSK                  0x00014104
+#define HOST_PAGE_NUM_FN1                0x00014108
+#define HOST_MSIX_ERR_INDEX_FN1          0x0001410c
+#define APP_PLL_425_CTL_REG              0x00014204
+#define __P_425_PLL_LOCK                 0x80000000
+#define __APP_PLL_425_SRAM_USE_100MHZ    0x00100000
+#define __APP_PLL_425_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_425_RESET_TIMER_SH     17
+#define __APP_PLL_425_RESET_TIMER(_v)    ((_v) << __APP_PLL_425_RESET_TIMER_SH)
+#define __APP_PLL_425_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_425_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_425_CNTLMT0_1_SH       14
+#define __APP_PLL_425_CNTLMT0_1(_v)      ((_v) << __APP_PLL_425_CNTLMT0_1_SH)
+#define __APP_PLL_425_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_425_JITLMT0_1_SH       12
+#define __APP_PLL_425_JITLMT0_1(_v)      ((_v) << __APP_PLL_425_JITLMT0_1_SH)
+#define __APP_PLL_425_HREF               0x00000800
+#define __APP_PLL_425_HDIV               0x00000400
+#define __APP_PLL_425_P0_1_MK            0x00000300
+#define __APP_PLL_425_P0_1_SH            8
+#define __APP_PLL_425_P0_1(_v)           ((_v) << __APP_PLL_425_P0_1_SH)
+#define __APP_PLL_425_Z0_2_MK            0x000000e0
+#define __APP_PLL_425_Z0_2_SH            5
+#define __APP_PLL_425_Z0_2(_v)           ((_v) << __APP_PLL_425_Z0_2_SH)
+#define __APP_PLL_425_RSEL200500         0x00000010
+#define __APP_PLL_425_ENARST             0x00000008
+#define __APP_PLL_425_BYPASS             0x00000004
+#define __APP_PLL_425_LRESETN            0x00000002
+#define __APP_PLL_425_ENABLE             0x00000001
+#define APP_PLL_312_CTL_REG              0x00014208
+#define __P_312_PLL_LOCK                 0x80000000
+#define __ENABLE_MAC_AHB_1               0x00800000
+#define __ENABLE_MAC_AHB_0               0x00400000
+#define __ENABLE_MAC_1                   0x00200000
+#define __ENABLE_MAC_0                   0x00100000
+#define __APP_PLL_312_RESET_TIMER_MK     0x000e0000
+#define __APP_PLL_312_RESET_TIMER_SH     17
+#define __APP_PLL_312_RESET_TIMER(_v)    ((_v) << __APP_PLL_312_RESET_TIMER_SH)
+#define __APP_PLL_312_LOGIC_SOFT_RESET   0x00010000
+#define __APP_PLL_312_CNTLMT0_1_MK       0x0000c000
+#define __APP_PLL_312_CNTLMT0_1_SH       14
+#define __APP_PLL_312_CNTLMT0_1(_v)      ((_v) << __APP_PLL_312_CNTLMT0_1_SH)
+#define __APP_PLL_312_JITLMT0_1_MK       0x00003000
+#define __APP_PLL_312_JITLMT0_1_SH       12
+#define __APP_PLL_312_JITLMT0_1(_v)      ((_v) << __APP_PLL_312_JITLMT0_1_SH)
+#define __APP_PLL_312_HREF               0x00000800
+#define __APP_PLL_312_HDIV               0x00000400
+#define __APP_PLL_312_P0_1_MK            0x00000300
+#define __APP_PLL_312_P0_1_SH            8
+#define __APP_PLL_312_P0_1(_v)           ((_v) << __APP_PLL_312_P0_1_SH)
+#define __APP_PLL_312_Z0_2_MK            0x000000e0
+#define __APP_PLL_312_Z0_2_SH            5
+#define __APP_PLL_312_Z0_2(_v)           ((_v) << __APP_PLL_312_Z0_2_SH)
+#define __APP_PLL_312_RSEL200500         0x00000010
+#define __APP_PLL_312_ENARST             0x00000008
+#define __APP_PLL_312_BYPASS             0x00000004
+#define __APP_PLL_312_LRESETN            0x00000002
+#define __APP_PLL_312_ENABLE             0x00000001
+#define MBIST_CTL_REG                    0x00014220
+#define __EDRAM_BISTR_START              0x00000004
+#define __MBIST_RESET                    0x00000002
+#define __MBIST_START                    0x00000001
+#define MBIST_STAT_REG                   0x00014224
+#define __EDRAM_BISTR_STATUS             0x00000008
+#define __EDRAM_BISTR_DONE               0x00000004
+#define __MEM_BIT_STATUS                 0x00000002
+#define __MBIST_DONE                     0x00000001
+#define HOST_SEM0_REG                    0x00014230
+#define __HOST_SEMAPHORE                 0x00000001
+#define HOST_SEM1_REG                    0x00014234
+#define HOST_SEM2_REG                    0x00014238
+#define HOST_SEM3_REG                    0x0001423c
+#define HOST_SEM0_INFO_REG               0x00014240
+#define HOST_SEM1_INFO_REG               0x00014244
+#define HOST_SEM2_INFO_REG               0x00014248
+#define HOST_SEM3_INFO_REG               0x0001424c
+#define ETH_MAC_SER_REG                  0x00014288
+#define __APP_EMS_CKBUFAMPIN             0x00000020
+#define __APP_EMS_REFCLKSEL              0x00000010
+#define __APP_EMS_CMLCKSEL               0x00000008
+#define __APP_EMS_REFCKBUFEN2            0x00000004
+#define __APP_EMS_REFCKBUFEN1            0x00000002
+#define __APP_EMS_CHANNEL_SEL            0x00000001
+#define HOSTFN2_INT_STATUS               0x00014300
+#define __HOSTFN2_HALT_OCCURRED          0x01000000
+#define __HOSTFN2_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN2_INT_STATUS_LVL_SH      20
+#define __HOSTFN2_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN2_INT_STATUS_LVL_SH)
+#define __HOSTFN2_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN2_INT_STATUS_P_SH        16
+#define __HOSTFN2_INT_STATUS_P(_v)       ((_v) << __HOSTFN2_INT_STATUS_P_SH)
+#define __HOSTFN2_INT_STATUS_F           0x0000ffff
+#define HOSTFN2_INT_MSK                  0x00014304
+#define HOST_PAGE_NUM_FN2                0x00014308
+#define HOST_MSIX_ERR_INDEX_FN2          0x0001430c
+#define HOSTFN3_INT_STATUS               0x00014400
+#define __HALT_OCCURRED                  0x01000000
+#define __HOSTFN3_INT_STATUS_LVL_MK      0x00f00000
+#define __HOSTFN3_INT_STATUS_LVL_SH      20
+#define __HOSTFN3_INT_STATUS_LVL(_v)     ((_v) << __HOSTFN3_INT_STATUS_LVL_SH)
+#define __HOSTFN3_INT_STATUS_P_MK        0x000f0000
+#define __HOSTFN3_INT_STATUS_P_SH        16
+#define __HOSTFN3_INT_STATUS_P(_v)       ((_v) << __HOSTFN3_INT_STATUS_P_SH)
+#define __HOSTFN3_INT_STATUS_F           0x0000ffff
+#define HOSTFN3_INT_MSK                  0x00014404
+#define HOST_PAGE_NUM_FN3                0x00014408
+#define HOST_MSIX_ERR_INDEX_FN3          0x0001440c
+#define FNC_ID_REG                       0x00014600
+#define __FUNCTION_NUMBER                0x00000007
+#define FNC_PERS_REG                     0x00014604
+#define __F3_FUNCTION_ACTIVE             0x80000000
+#define __F3_FUNCTION_MODE               0x40000000
+#define __F3_PORT_MAP_MK                 0x30000000
+#define __F3_PORT_MAP_SH                 28
+#define __F3_PORT_MAP(_v)                ((_v) << __F3_PORT_MAP_SH)
+#define __F3_VM_MODE                     0x08000000
+#define __F3_INTX_STATUS_MK              0x07000000
+#define __F3_INTX_STATUS_SH              24
+#define __F3_INTX_STATUS(_v)             ((_v) << __F3_INTX_STATUS_SH)
+#define __F2_FUNCTION_ACTIVE             0x00800000
+#define __F2_FUNCTION_MODE               0x00400000
+#define __F2_PORT_MAP_MK                 0x00300000
+#define __F2_PORT_MAP_SH                 20
+#define __F2_PORT_MAP(_v)                ((_v) << __F2_PORT_MAP_SH)
+#define __F2_VM_MODE                     0x00080000
+#define __F2_INTX_STATUS_MK              0x00070000
+#define __F2_INTX_STATUS_SH              16
+#define __F2_INTX_STATUS(_v)             ((_v) << __F2_INTX_STATUS_SH)
+#define __F1_FUNCTION_ACTIVE             0x00008000
+#define __F1_FUNCTION_MODE               0x00004000
+#define __F1_PORT_MAP_MK                 0x00003000
+#define __F1_PORT_MAP_SH                 12
+#define __F1_PORT_MAP(_v)                ((_v) << __F1_PORT_MAP_SH)
+#define __F1_VM_MODE                     0x00000800
+#define __F1_INTX_STATUS_MK              0x00000700
+#define __F1_INTX_STATUS_SH              8
+#define __F1_INTX_STATUS(_v)             ((_v) << __F1_INTX_STATUS_SH)
+#define __F0_FUNCTION_ACTIVE             0x00000080
+#define __F0_FUNCTION_MODE               0x00000040
+#define __F0_PORT_MAP_MK                 0x00000030
+#define __F0_PORT_MAP_SH                 4
+#define __F0_PORT_MAP(_v)                ((_v) << __F0_PORT_MAP_SH)
+#define __F0_VM_MODE                     0x00000008
+#define __F0_INTX_STATUS                 0x00000007
+enum {
+    __F0_INTX_STATUS_MSIX            = 0x0,
+    __F0_INTX_STATUS_INTA            = 0x1,
+    __F0_INTX_STATUS_INTB            = 0x2,
+    __F0_INTX_STATUS_INTC            = 0x3,
+    __F0_INTX_STATUS_INTD            = 0x4,
+};
+#define OP_MODE                          0x0001460c
+#define __APP_ETH_CLK_LOWSPEED           0x00000004
+#define __GLOBAL_CORECLK_HALFSPEED       0x00000002
+#define __GLOBAL_FCOE_MODE               0x00000001
+#define HOST_SEM4_REG                    0x00014610
+#define HOST_SEM5_REG                    0x00014614
+#define HOST_SEM6_REG                    0x00014618
+#define HOST_SEM7_REG                    0x0001461c
+#define HOST_SEM4_INFO_REG               0x00014620
+#define HOST_SEM5_INFO_REG               0x00014624
+#define HOST_SEM6_INFO_REG               0x00014628
+#define HOST_SEM7_INFO_REG               0x0001462c
+#define HOSTFN0_LPU0_MBOX0_CMD_STAT      0x00019000
+#define __HOSTFN0_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN0_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN0_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN0_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN0_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN0_LPU1_MBOX0_CMD_STAT      0x00019004
+#define __HOSTFN0_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN0_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN0_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN0_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN0_LPU1_MBOX0_CMD_STATUS  0x00000001
+#define LPU0_HOSTFN0_MBOX0_CMD_STAT      0x00019008
+#define __LPU0_HOSTFN0_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN0_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN0_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN0_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN0_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN0_MBOX0_CMD_STAT      0x0001900c
+#define __LPU1_HOSTFN0_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN0_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN0_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN0_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN1_LPU0_MBOX0_CMD_STAT      0x00019010
+#define __HOSTFN1_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN1_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN1_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN1_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN1_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN1_LPU1_MBOX0_CMD_STAT      0x00019014
+#define __HOSTFN1_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN1_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN1_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN1_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN1_LPU1_MBOX0_CMD_STATUS  0x00000001
+#define LPU0_HOSTFN1_MBOX0_CMD_STAT      0x00019018
+#define __LPU0_HOSTFN1_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN1_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN1_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN1_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN1_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN1_MBOX0_CMD_STAT      0x0001901c
+#define __LPU1_HOSTFN1_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN1_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN1_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN1_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN1_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN2_LPU0_MBOX0_CMD_STAT      0x00019150
+#define __HOSTFN2_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN2_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN2_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN2_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN2_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN2_LPU1_MBOX0_CMD_STAT      0x00019154
+#define __HOSTFN2_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN2_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN2_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN2_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN2_LPU1_MBOX0BOX0_CMD_STATUS 0x00000001
+#define LPU0_HOSTFN2_MBOX0_CMD_STAT      0x00019158
+#define __LPU0_HOSTFN2_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN2_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN2_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN2_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN2_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN2_MBOX0_CMD_STAT      0x0001915c
+#define __LPU1_HOSTFN2_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN2_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN2_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN2_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN2_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN3_LPU0_MBOX0_CMD_STAT      0x00019160
+#define __HOSTFN3_LPU0_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN3_LPU0_MBOX0_INFO_SH     1
+#define __HOSTFN3_LPU0_MBOX0_INFO(_v)    ((_v) << __HOSTFN3_LPU0_MBOX0_INFO_SH)
+#define __HOSTFN3_LPU0_MBOX0_CMD_STATUS  0x00000001
+#define HOSTFN3_LPU1_MBOX0_CMD_STAT      0x00019164
+#define __HOSTFN3_LPU1_MBOX0_INFO_MK     0xfffffffe
+#define __HOSTFN3_LPU1_MBOX0_INFO_SH     1
+#define __HOSTFN3_LPU1_MBOX0_INFO(_v)    ((_v) << __HOSTFN3_LPU1_MBOX0_INFO_SH)
+#define __HOSTFN3_LPU1_MBOX0_CMD_STATUS  0x00000001
+#define LPU0_HOSTFN3_MBOX0_CMD_STAT      0x00019168
+#define __LPU0_HOSTFN3_MBOX0_INFO_MK     0xfffffffe
+#define __LPU0_HOSTFN3_MBOX0_INFO_SH     1
+#define __LPU0_HOSTFN3_MBOX0_INFO(_v)    ((_v) << __LPU0_HOSTFN3_MBOX0_INFO_SH)
+#define __LPU0_HOSTFN3_MBOX0_CMD_STATUS  0x00000001
+#define LPU1_HOSTFN3_MBOX0_CMD_STAT      0x0001916c
+#define __LPU1_HOSTFN3_MBOX0_INFO_MK     0xfffffffe
+#define __LPU1_HOSTFN3_MBOX0_INFO_SH     1
+#define __LPU1_HOSTFN3_MBOX0_INFO(_v)    ((_v) << __LPU1_HOSTFN3_MBOX0_INFO_SH)
+#define __LPU1_HOSTFN3_MBOX0_CMD_STATUS  0x00000001
+#define FW_INIT_HALT_P0                  0x000191ac
+#define __FW_INIT_HALT_P                 0x00000001
+#define FW_INIT_HALT_P1                  0x000191bc
+#define CPE_PI_PTR_Q0                    0x00038000
+#define __CPE_PI_UNUSED_MK               0xffff0000
+#define __CPE_PI_UNUSED_SH               16
+#define __CPE_PI_UNUSED(_v)              ((_v) << __CPE_PI_UNUSED_SH)
+#define __CPE_PI_PTR                     0x0000ffff
+#define CPE_PI_PTR_Q1                    0x00038040
+#define CPE_CI_PTR_Q0                    0x00038004
+#define __CPE_CI_UNUSED_MK               0xffff0000
+#define __CPE_CI_UNUSED_SH               16
+#define __CPE_CI_UNUSED(_v)              ((_v) << __CPE_CI_UNUSED_SH)
+#define __CPE_CI_PTR                     0x0000ffff
+#define CPE_CI_PTR_Q1                    0x00038044
+#define CPE_DEPTH_Q0                     0x00038008
+#define __CPE_DEPTH_UNUSED_MK            0xf8000000
+#define __CPE_DEPTH_UNUSED_SH            27
+#define __CPE_DEPTH_UNUSED(_v)           ((_v) << __CPE_DEPTH_UNUSED_SH)
+#define __CPE_MSIX_VEC_INDEX_MK          0x07ff0000
+#define __CPE_MSIX_VEC_INDEX_SH          16
+#define __CPE_MSIX_VEC_INDEX(_v)         ((_v) << __CPE_MSIX_VEC_INDEX_SH)
+#define __CPE_DEPTH                      0x0000ffff
+#define CPE_DEPTH_Q1                     0x00038048
+#define CPE_QCTRL_Q0                     0x0003800c
+#define __CPE_CTRL_UNUSED30_MK           0xfc000000
+#define __CPE_CTRL_UNUSED30_SH           26
+#define __CPE_CTRL_UNUSED30(_v)          ((_v) << __CPE_CTRL_UNUSED30_SH)
+#define __CPE_FUNC_INT_CTRL_MK           0x03000000
+#define __CPE_FUNC_INT_CTRL_SH           24
+#define __CPE_FUNC_INT_CTRL(_v)          ((_v) << __CPE_FUNC_INT_CTRL_SH)
+enum {
+    __CPE_FUNC_INT_CTRL_DISABLE      = 0x0,
+    __CPE_FUNC_INT_CTRL_F2NF         = 0x1,
+    __CPE_FUNC_INT_CTRL_3QUART       = 0x2,
+    __CPE_FUNC_INT_CTRL_HALF         = 0x3,
+};
+#define __CPE_CTRL_UNUSED20_MK           0x00f00000
+#define __CPE_CTRL_UNUSED20_SH           20
+#define __CPE_CTRL_UNUSED20(_v)          ((_v) << __CPE_CTRL_UNUSED20_SH)
+#define __CPE_SCI_TH_MK                  0x000f0000
+#define __CPE_SCI_TH_SH                  16
+#define __CPE_SCI_TH(_v)                 ((_v) << __CPE_SCI_TH_SH)
+#define __CPE_CTRL_UNUSED10_MK           0x0000c000
+#define __CPE_CTRL_UNUSED10_SH           14
+#define __CPE_CTRL_UNUSED10(_v)          ((_v) << __CPE_CTRL_UNUSED10_SH)
+#define __CPE_ACK_PENDING                0x00002000
+#define __CPE_CTRL_UNUSED40_MK           0x00001c00
+#define __CPE_CTRL_UNUSED40_SH           10
+#define __CPE_CTRL_UNUSED40(_v)          ((_v) << __CPE_CTRL_UNUSED40_SH)
+#define __CPE_PCIEID_MK                  0x00000300
+#define __CPE_PCIEID_SH                  8
+#define __CPE_PCIEID(_v)                 ((_v) << __CPE_PCIEID_SH)
+#define __CPE_CTRL_UNUSED00_MK           0x000000fe
+#define __CPE_CTRL_UNUSED00_SH           1
+#define __CPE_CTRL_UNUSED00(_v)          ((_v) << __CPE_CTRL_UNUSED00_SH)
+#define __CPE_ESIZE                      0x00000001
+#define CPE_QCTRL_Q1                     0x0003804c
+#define __CPE_CTRL_UNUSED31_MK           0xfc000000
+#define __CPE_CTRL_UNUSED31_SH           26
+#define __CPE_CTRL_UNUSED31(_v)          ((_v) << __CPE_CTRL_UNUSED31_SH)
+#define __CPE_CTRL_UNUSED21_MK           0x00f00000
+#define __CPE_CTRL_UNUSED21_SH           20
+#define __CPE_CTRL_UNUSED21(_v)          ((_v) << __CPE_CTRL_UNUSED21_SH)
+#define __CPE_CTRL_UNUSED11_MK           0x0000c000
+#define __CPE_CTRL_UNUSED11_SH           14
+#define __CPE_CTRL_UNUSED11(_v)          ((_v) << __CPE_CTRL_UNUSED11_SH)
+#define __CPE_CTRL_UNUSED41_MK           0x00001c00
+#define __CPE_CTRL_UNUSED41_SH           10
+#define __CPE_CTRL_UNUSED41(_v)          ((_v) << __CPE_CTRL_UNUSED41_SH)
+#define __CPE_CTRL_UNUSED01_MK           0x000000fe
+#define __CPE_CTRL_UNUSED01_SH           1
+#define __CPE_CTRL_UNUSED01(_v)          ((_v) << __CPE_CTRL_UNUSED01_SH)
+#define RME_PI_PTR_Q0                    0x00038020
+#define __LATENCY_TIME_STAMP_MK          0xffff0000
+#define __LATENCY_TIME_STAMP_SH          16
+#define __LATENCY_TIME_STAMP(_v)         ((_v) << __LATENCY_TIME_STAMP_SH)
+#define __RME_PI_PTR                     0x0000ffff
+#define RME_PI_PTR_Q1                    0x00038060
+#define RME_CI_PTR_Q0                    0x00038024
+#define __DELAY_TIME_STAMP_MK            0xffff0000
+#define __DELAY_TIME_STAMP_SH            16
+#define __DELAY_TIME_STAMP(_v)           ((_v) << __DELAY_TIME_STAMP_SH)
+#define __RME_CI_PTR                     0x0000ffff
+#define RME_CI_PTR_Q1                    0x00038064
+#define RME_DEPTH_Q0                     0x00038028
+#define __RME_DEPTH_UNUSED_MK            0xf8000000
+#define __RME_DEPTH_UNUSED_SH            27
+#define __RME_DEPTH_UNUSED(_v)           ((_v) << __RME_DEPTH_UNUSED_SH)
+#define __RME_MSIX_VEC_INDEX_MK          0x07ff0000
+#define __RME_MSIX_VEC_INDEX_SH          16
+#define __RME_MSIX_VEC_INDEX(_v)         ((_v) << __RME_MSIX_VEC_INDEX_SH)
+#define __RME_DEPTH                      0x0000ffff
+#define RME_DEPTH_Q1                     0x00038068
+#define RME_QCTRL_Q0                     0x0003802c
+#define __RME_INT_LATENCY_TIMER_MK       0xff000000
+#define __RME_INT_LATENCY_TIMER_SH       24
+#define __RME_INT_LATENCY_TIMER(_v)      ((_v) << __RME_INT_LATENCY_TIMER_SH)
+#define __RME_INT_DELAY_TIMER_MK         0x00ff0000
+#define __RME_INT_DELAY_TIMER_SH         16
+#define __RME_INT_DELAY_TIMER(_v)        ((_v) << __RME_INT_DELAY_TIMER_SH)
+#define __RME_INT_DELAY_DISABLE          0x00008000
+#define __RME_DLY_DELAY_DISABLE          0x00004000
+#define __RME_ACK_PENDING                0x00002000
+#define __RME_FULL_INTERRUPT_DISABLE     0x00001000
+#define __RME_CTRL_UNUSED10_MK           0x00000c00
+#define __RME_CTRL_UNUSED10_SH           10
+#define __RME_CTRL_UNUSED10(_v)          ((_v) << __RME_CTRL_UNUSED10_SH)
+#define __RME_PCIEID_MK                  0x00000300
+#define __RME_PCIEID_SH                  8
+#define __RME_PCIEID(_v)                 ((_v) << __RME_PCIEID_SH)
+#define __RME_CTRL_UNUSED00_MK           0x000000fe
+#define __RME_CTRL_UNUSED00_SH           1
+#define __RME_CTRL_UNUSED00(_v)          ((_v) << __RME_CTRL_UNUSED00_SH)
+#define __RME_ESIZE                      0x00000001
+#define RME_QCTRL_Q1                     0x0003806c
+#define __RME_CTRL_UNUSED11_MK           0x00000c00
+#define __RME_CTRL_UNUSED11_SH           10
+#define __RME_CTRL_UNUSED11(_v)          ((_v) << __RME_CTRL_UNUSED11_SH)
+#define __RME_CTRL_UNUSED01_MK           0x000000fe
+#define __RME_CTRL_UNUSED01_SH           1
+#define __RME_CTRL_UNUSED01(_v)          ((_v) << __RME_CTRL_UNUSED01_SH)
+#define PSS_CTL_REG                      0x00018800
+#define __PSS_I2C_CLK_DIV_MK             0x007f0000
+#define __PSS_I2C_CLK_DIV_SH             16
+#define __PSS_I2C_CLK_DIV(_v)            ((_v) << __PSS_I2C_CLK_DIV_SH)
+#define __PSS_LMEM_INIT_DONE             0x00001000
+#define __PSS_LMEM_RESET                 0x00000200
+#define __PSS_LMEM_INIT_EN               0x00000100
+#define __PSS_LPU1_RESET                 0x00000002
+#define __PSS_LPU0_RESET                 0x00000001
+#define HQM_QSET0_RXQ_DRBL_P0            0x00038000
+#define __RXQ0_ADD_VECTORS_P             0x80000000
+#define __RXQ0_STOP_P                    0x40000000
+#define __RXQ0_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET1_RXQ_DRBL_P0            0x00038080
+#define __RXQ1_ADD_VECTORS_P             0x80000000
+#define __RXQ1_STOP_P                    0x40000000
+#define __RXQ1_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET0_RXQ_DRBL_P1            0x0003c000
+#define HQM_QSET1_RXQ_DRBL_P1            0x0003c080
+#define HQM_QSET0_TXQ_DRBL_P0            0x00038020
+#define __TXQ0_ADD_VECTORS_P             0x80000000
+#define __TXQ0_STOP_P                    0x40000000
+#define __TXQ0_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET1_TXQ_DRBL_P0            0x000380a0
+#define __TXQ1_ADD_VECTORS_P             0x80000000
+#define __TXQ1_STOP_P                    0x40000000
+#define __TXQ1_PRD_PTR_P                 0x0000ffff
+#define HQM_QSET0_TXQ_DRBL_P1            0x0003c020
+#define HQM_QSET1_TXQ_DRBL_P1            0x0003c0a0
+#define HQM_QSET0_IB_DRBL_1_P0           0x00038040
+#define __IB1_0_ACK_P                    0x80000000
+#define __IB1_0_DISABLE_P                0x40000000
+#define __IB1_0_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET1_IB_DRBL_1_P0           0x000380c0
+#define __IB1_1_ACK_P                    0x80000000
+#define __IB1_1_DISABLE_P                0x40000000
+#define __IB1_1_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET0_IB_DRBL_1_P1           0x0003c040
+#define HQM_QSET1_IB_DRBL_1_P1           0x0003c0c0
+#define HQM_QSET0_IB_DRBL_2_P0           0x00038060
+#define __IB2_0_ACK_P                    0x80000000
+#define __IB2_0_DISABLE_P                0x40000000
+#define __IB2_0_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET1_IB_DRBL_2_P0           0x000380e0
+#define __IB2_1_ACK_P                    0x80000000
+#define __IB2_1_DISABLE_P                0x40000000
+#define __IB2_1_NUM_OF_ACKED_EVENTS_P    0x0000ffff
+#define HQM_QSET0_IB_DRBL_2_P1           0x0003c060
+#define HQM_QSET1_IB_DRBL_2_P1           0x0003c0e0
+
+
+/*
+ * These definitions are either in error/missing in spec. Its auto-generated
+ * from hard coded values in regparse.pl.
+ */
+#define __EMPHPOST_AT_4G_MK_FIX          0x0000001c
+#define __EMPHPOST_AT_4G_SH_FIX          0x00000002
+#define __EMPHPRE_AT_4G_FIX              0x00000003
+#define __SFP_TXRATE_EN_FIX              0x00000100
+#define __SFP_RXRATE_EN_FIX              0x00000080
+
+
+/*
+ * These register definitions are auto-generated from hard coded values
+ * in regparse.pl.
+ */
+
+
+/*
+ * These register mapping definitions are auto-generated from mapping tables
+ * in regparse.pl.
+ */
+#define BFA_IOC0_HBEAT_REG               HOST_SEM0_INFO_REG
+#define BFA_IOC0_STATE_REG               HOST_SEM1_INFO_REG
+#define BFA_IOC1_HBEAT_REG               HOST_SEM2_INFO_REG
+#define BFA_IOC1_STATE_REG               HOST_SEM3_INFO_REG
+#define BFA_FW_USE_COUNT                 HOST_SEM4_INFO_REG
+
+#define CPE_DEPTH_Q(__n) \
+	(CPE_DEPTH_Q0 + (__n) * (CPE_DEPTH_Q1 - CPE_DEPTH_Q0))
+#define CPE_QCTRL_Q(__n) \
+	(CPE_QCTRL_Q0 + (__n) * (CPE_QCTRL_Q1 - CPE_QCTRL_Q0))
+#define CPE_PI_PTR_Q(__n) \
+	(CPE_PI_PTR_Q0 + (__n) * (CPE_PI_PTR_Q1 - CPE_PI_PTR_Q0))
+#define CPE_CI_PTR_Q(__n) \
+	(CPE_CI_PTR_Q0 + (__n) * (CPE_CI_PTR_Q1 - CPE_CI_PTR_Q0))
+#define RME_DEPTH_Q(__n) \
+	(RME_DEPTH_Q0 + (__n) * (RME_DEPTH_Q1 - RME_DEPTH_Q0))
+#define RME_QCTRL_Q(__n) \
+	(RME_QCTRL_Q0 + (__n) * (RME_QCTRL_Q1 - RME_QCTRL_Q0))
+#define RME_PI_PTR_Q(__n) \
+	(RME_PI_PTR_Q0 + (__n) * (RME_PI_PTR_Q1 - RME_PI_PTR_Q0))
+#define RME_CI_PTR_Q(__n) \
+	(RME_CI_PTR_Q0 + (__n) * (RME_CI_PTR_Q1 - RME_CI_PTR_Q0))
+#define HQM_QSET_RXQ_DRBL_P0(__n) \
+	(HQM_QSET0_RXQ_DRBL_P0 + (__n) * (HQM_QSET1_RXQ_DRBL_P0 - \
+	HQM_QSET0_RXQ_DRBL_P0))
+#define HQM_QSET_TXQ_DRBL_P0(__n) \
+	(HQM_QSET0_TXQ_DRBL_P0 + (__n) * (HQM_QSET1_TXQ_DRBL_P0 - \
+	HQM_QSET0_TXQ_DRBL_P0))
+#define HQM_QSET_IB_DRBL_1_P0(__n) \
+	(HQM_QSET0_IB_DRBL_1_P0 + (__n) * (HQM_QSET1_IB_DRBL_1_P0 - \
+	HQM_QSET0_IB_DRBL_1_P0))
+#define HQM_QSET_IB_DRBL_2_P0(__n) \
+	(HQM_QSET0_IB_DRBL_2_P0 + (__n) * (HQM_QSET1_IB_DRBL_2_P0 - \
+	HQM_QSET0_IB_DRBL_2_P0))
+#define HQM_QSET_RXQ_DRBL_P1(__n) \
+	(HQM_QSET0_RXQ_DRBL_P1 + (__n) * (HQM_QSET1_RXQ_DRBL_P1 - \
+	HQM_QSET0_RXQ_DRBL_P1))
+#define HQM_QSET_TXQ_DRBL_P1(__n) \
+	(HQM_QSET0_TXQ_DRBL_P1 + (__n) * (HQM_QSET1_TXQ_DRBL_P1 - \
+	HQM_QSET0_TXQ_DRBL_P1))
+#define HQM_QSET_IB_DRBL_1_P1(__n) \
+	(HQM_QSET0_IB_DRBL_1_P1 + (__n) * (HQM_QSET1_IB_DRBL_1_P1 - \
+	HQM_QSET0_IB_DRBL_1_P1))
+#define HQM_QSET_IB_DRBL_2_P1(__n) \
+	(HQM_QSET0_IB_DRBL_2_P1 + (__n) * (HQM_QSET1_IB_DRBL_2_P1 - \
+	HQM_QSET0_IB_DRBL_2_P1))
+
+#define CPE_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define RME_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
+#define CPE_Q_MASK(__q)  ((__q) & 0x3)
+#define RME_Q_MASK(__q)  ((__q) & 0x3)
+
+
+/*
+ * PCI MSI-X vector defines
+ */
+enum {
+    BFA_MSIX_CPE_Q0 = 0,
+    BFA_MSIX_CPE_Q1 = 1,
+    BFA_MSIX_CPE_Q2 = 2,
+    BFA_MSIX_CPE_Q3 = 3,
+    BFA_MSIX_RME_Q0 = 4,
+    BFA_MSIX_RME_Q1 = 5,
+    BFA_MSIX_RME_Q2 = 6,
+    BFA_MSIX_RME_Q3 = 7,
+    BFA_MSIX_LPU_ERR = 8,
+    BFA_MSIX_CT_MAX = 9,
+};
+
+/*
+ * And corresponding host interrupt status bit field defines
+ */
+#define __HFN_INT_CPE_Q0                   0x00000001U
+#define __HFN_INT_CPE_Q1                   0x00000002U
+#define __HFN_INT_CPE_Q2                   0x00000004U
+#define __HFN_INT_CPE_Q3                   0x00000008U
+#define __HFN_INT_CPE_Q4                   0x00000010U
+#define __HFN_INT_CPE_Q5                   0x00000020U
+#define __HFN_INT_CPE_Q6                   0x00000040U
+#define __HFN_INT_CPE_Q7                   0x00000080U
+#define __HFN_INT_RME_Q0                   0x00000100U
+#define __HFN_INT_RME_Q1                   0x00000200U
+#define __HFN_INT_RME_Q2                   0x00000400U
+#define __HFN_INT_RME_Q3                   0x00000800U
+#define __HFN_INT_RME_Q4                   0x00001000U
+#define __HFN_INT_RME_Q5                   0x00002000U
+#define __HFN_INT_RME_Q6                   0x00004000U
+#define __HFN_INT_RME_Q7                   0x00008000U
+#define __HFN_INT_ERR_EMC                  0x00010000U
+#define __HFN_INT_ERR_LPU0                 0x00020000U
+#define __HFN_INT_ERR_LPU1                 0x00040000U
+#define __HFN_INT_ERR_PSS                  0x00080000U
+#define __HFN_INT_MBOX_LPU0                0x00100000U
+#define __HFN_INT_MBOX_LPU1                0x00200000U
+#define __HFN_INT_MBOX1_LPU0               0x00400000U
+#define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_CPE_MASK                 0x000000ffU
+#define __HFN_INT_RME_MASK                 0x0000ff00U
+
+
+/*
+ * catapult memory map.
+ */
+#define LL_PGN_HQM0                      0x0096
+#define LL_PGN_HQM1                      0x0097
+#define PSS_SMEM_PAGE_START	0x8000
+#define PSS_SMEM_PGNUM(_pg0, _ma)	((_pg0) + ((_ma) >> 15))
+#define PSS_SMEM_PGOFF(_ma)	((_ma) & 0x7fff)
+
+/*
+ * End of catapult memory map
+ */
+
+
+#endif /* __BFI_CTREG_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fabric.h patch/drivers/scsi/bfa/include/bfi/bfi_fabric.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fabric.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fabric.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_FABRIC_H__
+#define __BFI_FABRIC_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_fabric_h2i_msgs {
+	BFI_FABRIC_H2I_CREATE_REQ	= 1,
+	BFI_FABRIC_H2I_DELETE_REQ	= 2,
+	BFI_FABRIC_H2I_SETAUTH		= 3,
+};
+
+enum bfi_fabric_i2h_msgs {
+	BFI_FABRIC_I2H_CREATE_RSP	= BFA_I2HM(1),
+	BFI_FABRIC_I2H_DELETE_RSP	= BFA_I2HM(2),
+	BFI_FABRIC_I2H_SETAUTH_RSP	= BFA_I2HM(3),
+	BFI_FABRIC_I2H_ONLINE		= BFA_I2HM(4),
+	BFI_FABRIC_I2H_OFFLINE		= BFA_I2HM(5),
+};
+
+struct bfi_fabric_create_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u8         vf_en;		/*  virtual fabric enable	*/
+	u8         rsvd;
+	u16        vf_id;		/*  virtual fabric ID		*/
+	wwn_t		pwwn;		/*  port name			*/
+	wwn_t		nwwn;		/*  node name			*/
+};
+
+struct bfi_fabric_create_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host fabric handle		*/
+	u8         status;		/*  fabric create status	*/
+	u8         rsvd;
+};
+
+struct bfi_fabric_delete_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware fabric handle	*/
+	u16        rsvd;
+};
+
+struct bfi_fabric_delete_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host fabric handle		*/
+	u8         status;		/*  fabric deletion status	*/
+	u8         rsvd;
+};
+
+#define BFI_FABRIC_AUTHSECRET_LEN	64
+struct bfi_fabric_setauth_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  f/w handle of fabric	*/
+	u8		algorithm;
+	u8		group;
+	u8		secret[BFI_FABRIC_AUTHSECRET_LEN];
+};
+
+union bfi_fabric_h2i_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_fabric_create_req_s	*create_req;
+	struct bfi_fabric_delete_req_s	*delete_req;
+};
+
+union bfi_fabric_i2h_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_fabric_create_rsp_s	*create_rsp;
+	struct bfi_fabric_delete_rsp_s	*delete_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_FABRIC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fcpim.h patch/drivers/scsi/bfa/include/bfi/bfi_fcpim.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fcpim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,301 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_FCPIM_H__
+#define __BFI_FCPIM_H__
+
+#include "bfi.h"
+#include <protocol/fcp.h>
+
+#pragma pack(1)
+
+/*
+ * Initiator mode I-T nexus interface defines.
+ */
+
+enum bfi_itnim_h2i {
+	BFI_ITNIM_H2I_CREATE_REQ = 1,	/*  i-t nexus creation */
+	BFI_ITNIM_H2I_DELETE_REQ = 2,	/*  i-t nexus deletion */
+};
+
+enum bfi_itnim_i2h {
+	BFI_ITNIM_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_ITNIM_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_ITNIM_I2H_SLER_EVENT = BFA_I2HM(3),
+};
+
+struct bfi_itnim_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        fw_handle;	/*  f/w handle for itnim	 */
+	u8         class;		/*  FC class for IO		 */
+	u8         seq_rec;	/*  sequence recovery support	 */
+	u8         msg_no;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        bfa_handle;	/*  bfa handle for itnim	 */
+	u8         status;		/*  fcp request status		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        fw_handle;	/*  f/w itnim handle		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+	u8         rsvd;
+};
+
+struct bfi_itnim_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        bfa_handle;	/*  bfa handle for itnim	 */
+	u8         status;		/*  fcp request status		 */
+	u8         seq_id;		/*  seq id of the msg		 */
+};
+
+struct bfi_itnim_sler_event_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		 */
+	u16        bfa_handle;	/*  bfa handle for itnim	 */
+	u16        rsvd;
+};
+
+union bfi_itnim_h2i_msg_u {
+	struct bfi_itnim_create_req_s *create_req;
+	struct bfi_itnim_delete_req_s *delete_req;
+	struct bfi_msg_s      *msg;
+};
+
+union bfi_itnim_i2h_msg_u {
+	struct bfi_itnim_create_rsp_s *create_rsp;
+	struct bfi_itnim_delete_rsp_s *delete_rsp;
+	struct bfi_itnim_sler_event_s *sler_event;
+	struct bfi_msg_s      *msg;
+};
+
+/*
+ * Initiator mode IO interface defines.
+ */
+
+enum bfi_ioim_h2i {
+	BFI_IOIM_H2I_IOABORT_REQ = 1,	/*  IO abort request	 */
+	BFI_IOIM_H2I_IOCLEANUP_REQ = 2,	/*  IO cleanup request	 */
+};
+
+enum bfi_ioim_i2h {
+	BFI_IOIM_I2H_IO_RSP = BFA_I2HM(1),	/*  non-fp IO response	 */
+	BFI_IOIM_I2H_IOABORT_RSP = BFA_I2HM(2),/*  ABORT rsp	 */
+};
+
+/**
+ * IO command DIF info
+ */
+struct bfi_ioim_dif_s {
+	u32	dif_info[4];
+};
+
+/**
+ * FCP IO messages overview
+ *
+ * @note
+ * - Max CDB length supported is 64 bytes.
+ * - SCSI Linked commands and SCSI bi-directional Commands not
+ * 	 supported.
+ *
+ */
+struct bfi_ioim_req_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
+	u16        io_tag;		/*  I/O tag			 */
+	u16        rport_hdl;	/*  itnim/rport firmware handle */
+	struct fcp_cmnd_s cmnd;		/*  IO request info		 */
+
+	/**
+	 * SG elements array within the IO request must be double word
+	 * aligned. This aligment is required to optimize SGM setup for the IO.
+	 */
+	struct bfi_sge_s   sges[BFI_SGE_INLINE_MAX];
+	u8         io_timeout;
+	u8         dif_en;
+	u8         rsvd_a[2];
+	struct bfi_ioim_dif_s  dif;
+};
+
+/**
+ * 	This table shows various IO status codes from firmware and their
+ *	meaning. Host driver can use these status codes to further process
+ *	IO completions.
+ *
+ * 	BFI_IOIM_STS_OK		: IO completed with error free SCSI &
+ *					   transport status.
+ * 					   - io-tag can be reused.
+ *
+ * 	BFA_IOIM_STS_SCSI_ERR		: IO completed with scsi error.
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_HOST_ABORTED	: IO was aborted successfully due to
+ *					   host request.
+ * 					   - io-tag cannot be reused yet.
+ *
+ * 	BFI_IOIM_STS_ABORTED		: IO was aborted successfully
+ *					   internally by f/w.
+ * 					   - io-tag cannot be reused yet.
+ *
+ * 	BFI_IOIM_STS_TIMEDOUT	: IO timedout and ABTS/RRQ is happening
+ *					   in the firmware and
+ * 					   - io-tag cannot be reused yet.
+ *
+ * 	BFI_IOIM_STS_SQER_NEEDED	: Firmware could not recover the IO
+ *					  with sequence level error
+ * 					  logic and hence host needs to retry
+ *					  this IO with a different IO tag
+ * 					  - io-tag cannot be used yet.
+ *
+ * 	BFI_IOIM_STS_NEXUS_ABORT	: Second Level Error Recovery from host
+ *					  is required because 2 consecutive ABTS
+ *					  timedout and host needs logout and
+ *					  re-login with the target
+ * 					  - io-tag cannot be used yet.
+ *
+ * 	BFI_IOIM_STS_UNDERRUN	: IO completed with SCSI status good,
+ *					  but the data tranferred is less than
+ *					  the fcp data length in the command.
+ *					  ex. SCSI INQUIRY where transferred
+ *					  data length and residue count in FCP
+ *					  response accounts for total fcp-dl
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_OVERRUN	: IO completed with SCSI status good,
+ *					  but the data transerred is more than
+ *					  fcp data length in the command. ex.
+ *					  TAPE IOs where blocks can of unequal
+ *					  lengths.
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_RES_FREE	: Firmware has completed using io-tag
+ *					  during abort process
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_PROTO_ERR	: Firmware detected a protocol error.
+ *					  ex target sent more data than
+ *					  requested, or there was data frame
+ *					  loss and other reasons
+ * 					  - io-tag cannot be used yet.
+ *
+ * 	BFI_IOIM_STS_DIF_ERR	: Firwmare detected DIF error. ex: DIF
+ * 					  CRC err or Ref Tag err or App tag err.
+ * 					  - io-tag can be reused.
+ *
+ * 	BFA_IOIM_STS_TSK_MGT_ABORT	: IO was aborted because of Task
+ *					  Management command from the host
+ * 					  - io-tag can be reused.
+ *
+ * 	BFI_IOIM_STS_UTAG		: Firmware does not know about this
+ *					  io_tag.
+ * 					  - io-tag can be reused.
+ */
+enum bfi_ioim_status {
+	BFI_IOIM_STS_OK = 0,
+	BFI_IOIM_STS_HOST_ABORTED = 1,
+	BFI_IOIM_STS_ABORTED = 2,
+	BFI_IOIM_STS_TIMEDOUT = 3,
+	BFI_IOIM_STS_RES_FREE = 4,
+	BFI_IOIM_STS_SQER_NEEDED = 5,
+	BFI_IOIM_STS_PROTO_ERR = 6,
+	BFI_IOIM_STS_UTAG = 7,
+	BFI_IOIM_STS_PATHTOV = 8,
+};
+
+#define BFI_IOIM_SNSLEN	(256)
+/**
+ * I/O response message
+ */
+struct bfi_ioim_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header	 	 */
+	u16        io_tag;		/*  completed IO tag		 */
+	u16        bfa_rport_hndl;	/*  releated rport handle	 */
+	u8         io_status;	/*  IO completion status	 */
+	u8         reuse_io_tag;	/*  IO tag can be reused        */
+	u16	abort_tag;	/*  host abort request tag      */
+	u8		scsi_status;	/*  scsi status from target	 */
+	u8		sns_len;	/*  scsi sense length		 */
+	u8		resid_flags;	/*  IO residue flags		 */
+	u8		rsvd_a;
+	u32	residue;	/*  IO residual length in bytes */
+	u32	rsvd_b[3];
+};
+
+struct bfi_ioim_abort_req_s {
+	struct bfi_mhdr_s  mh;          /*  Common msg header  */
+	u16        io_tag;         /*  I/O tag            */
+	u16        abort_tag;      /*  unique request tag */
+};
+
+/*
+ * Initiator mode task management command interface defines.
+ */
+
+enum bfi_tskim_h2i {
+	BFI_TSKIM_H2I_TM_REQ    = 1, /*  task-mgmt command         */
+	BFI_TSKIM_H2I_ABORT_REQ = 2, /*  task-mgmt command         */
+};
+
+enum bfi_tskim_i2h {
+	BFI_TSKIM_I2H_TM_RSP = BFA_I2HM(1),
+};
+
+struct bfi_tskim_req_s {
+	struct bfi_mhdr_s  mh;             /*  Common msg header          */
+	u16        tsk_tag;        /*  task management tag        */
+	u16        itn_fhdl;       /*  itn firmware handle        */
+	lun_t           lun;            /*  LU number                  */
+	u8         tm_flags;       /*  see fcp_tm_cmnd_t          */
+	u8         t_secs;         /*  Timeout value in seconds   */
+	u8         rsvd[2];
+};
+
+struct bfi_tskim_abortreq_s {
+	struct bfi_mhdr_s  mh;             /*  Common msg header          */
+	u16        tsk_tag;        /*  task management tag        */
+	u16        rsvd;
+};
+
+enum bfi_tskim_status {
+	/*
+	 * Following are FCP-4 spec defined status codes,
+	 * **DO NOT CHANGE THEM **
+	 */
+	BFI_TSKIM_STS_OK       = 0,
+	BFI_TSKIM_STS_NOT_SUPP = 4,
+	BFI_TSKIM_STS_FAILED   = 5,
+
+	/**
+	 * Defined by BFA
+	 */
+	BFI_TSKIM_STS_TIMEOUT  = 10,    /*  TM request timedout     */
+	BFI_TSKIM_STS_ABORTED  = 11,    /*  Aborted on host request */
+};
+
+struct bfi_tskim_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
+	u16        tsk_tag;	/*  task mgmt cmnd tag		 */
+	u8         tsk_status;	/*  @ref bfi_tskim_status */
+	u8         rsvd;
+};
+
+#pragma pack()
+
+#endif /* __BFI_FCPIM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_fcxp.h patch/drivers/scsi/bfa/include/bfi/bfi_fcxp.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_fcxp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_fcxp.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_FCXP_H__
+#define __BFI_FCXP_H__
+
+#include "bfi.h"
+
+#pragma pack(1)
+
+enum bfi_fcxp_h2i {
+	BFI_FCXP_H2I_SEND_REQ = 1,
+};
+
+enum bfi_fcxp_i2h {
+	BFI_FCXP_I2H_SEND_RSP = BFA_I2HM(1),
+};
+
+#define BFA_FCXP_MAX_SGES	2
+
+/**
+ * FCXP send request structure
+ */
+struct bfi_fcxp_send_req_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
+	u16        fcxp_tag;	/*  driver request tag		    */
+	u16        max_frmsz;	/*  max send frame size	    */
+	u16        vf_id;		/*  vsan tag if applicable	    */
+	u16        rport_fw_hndl;	/*  FW Handle for the remote port  */
+	u8         class;		/*  FC class used for req/rsp	    */
+	u8         rsp_timeout;	/*  timeout in secs, 0-no response */
+	u8         cts;		/*  continue sequence		    */
+	u8         lp_tag;		/*  lport tag			    */
+	struct fchs_s   fchs;		/*  request FC header structure    */
+	u32        req_len;	/*  request payload length	    */
+	u32        rsp_maxlen;	/*  max response length expected   */
+	struct bfi_sge_s   req_sge[BFA_FCXP_MAX_SGES];	/*  request buf    */
+	struct bfi_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];	/*  response buf   */
+};
+
+/**
+ * FCXP send response structure
+ */
+struct bfi_fcxp_send_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
+	u16        fcxp_tag;	/*  send request tag		    */
+	u8         req_status;	/*  request status		    */
+	u8         rsvd;
+	u32        rsp_len;	/*  actual response length	    */
+	u32        residue_len;	/*  residual response length	    */
+	struct fchs_s   fchs;		/*  response FC header structure   */
+};
+
+#pragma pack()
+
+#endif /* __BFI_FCXP_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_ioc.h patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_ioc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_IOC_H__
+#define __BFI_IOC_H__
+
+#include "bfi.h"
+#include <defs/bfa_defs_ioc.h>
+
+#pragma pack(1)
+
+enum bfi_ioc_h2i_msgs {
+	BFI_IOC_H2I_ENABLE_REQ 		= 1,
+	BFI_IOC_H2I_DISABLE_REQ 	= 2,
+	BFI_IOC_H2I_GETATTR_REQ 	= 3,
+	BFI_IOC_H2I_DBG_SYNC	 	= 4,
+	BFI_IOC_H2I_DBG_DUMP	 	= 5,
+};
+
+enum bfi_ioc_i2h_msgs {
+	BFI_IOC_I2H_ENABLE_REPLY	= BFA_I2HM(1),
+	BFI_IOC_I2H_DISABLE_REPLY 	= BFA_I2HM(2),
+	BFI_IOC_I2H_GETATTR_REPLY 	= BFA_I2HM(3),
+	BFI_IOC_I2H_READY_EVENT 	= BFA_I2HM(4),
+	BFI_IOC_I2H_HBEAT		= BFA_I2HM(5),
+};
+
+/**
+ * BFI_IOC_H2I_GETATTR_REQ message
+ */
+struct bfi_ioc_getattr_req_s {
+	struct bfi_mhdr_s	mh;
+	union bfi_addr_u	attr_addr;
+};
+
+struct bfi_ioc_attr_s {
+	wwn_t           mfg_wwn;
+	mac_t		mfg_mac;
+	u16	rsvd_a;
+	char            brcd_serialnum[STRSZ(BFA_MFG_SERIALNUM_SIZE)];
+	u8         pcie_gen;
+	u8         pcie_lanes_orig;
+	u8         pcie_lanes;
+	u8         rx_bbcredit;	/*  receive buffer credits */
+	u32        adapter_prop;	/*  adapter properties     */
+	u16        maxfrsize;	/*  max receive frame size */
+	char         	asic_rev;
+	u8         rsvd_b;
+	char            fw_version[BFA_VERSION_LEN];
+	char            optrom_version[BFA_VERSION_LEN];
+	struct bfa_mfg_vpd_s	vpd;
+};
+
+/**
+ * BFI_IOC_I2H_GETATTR_REPLY message
+ */
+struct bfi_ioc_getattr_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header          */
+	u8		status;	/*  cfg reply status           */
+	u8		rsvd[3];
+};
+
+/**
+ * Firmware memory page offsets
+ */
+#define BFI_IOC_SMEM_PG0_CB	(0x40)
+#define BFI_IOC_SMEM_PG0_CT	(0x180)
+
+/**
+ * Firmware trace offset
+ */
+#define BFI_IOC_TRC_OFF		(0x4b00)
+#define BFI_IOC_TRC_ENTS	256
+
+#define BFI_IOC_FW_SIGNATURE	(0xbfadbfad)
+#define BFI_IOC_MD5SUM_SZ	4
+struct bfi_ioc_image_hdr_s {
+	u32        signature;	/*  constant signature */
+	u32        rsvd_a;
+	u32        exec;		/*  exec vector        */
+	u32        param;		/*  parameters         */
+	u32        rsvd_b[4];
+	u32        md5sum[BFI_IOC_MD5SUM_SZ];
+};
+
+/**
+ *  BFI_IOC_I2H_READY_EVENT message
+ */
+struct bfi_ioc_rdy_event_s {
+	struct bfi_mhdr_s  mh;			/*  common msg header */
+	u8         init_status;	/*  init event status */
+	u8         rsvd[3];
+};
+
+struct bfi_ioc_hbeat_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u32	   hb_count;	/*  current heart beat count	*/
+};
+
+/**
+ * IOC hardware/firmware state
+ */
+enum bfi_ioc_state {
+	BFI_IOC_UNINIT 	 = 0,		/*  not initialized                 */
+	BFI_IOC_INITING 	 = 1,	/*  h/w is being initialized        */
+	BFI_IOC_HWINIT 	 = 2,		/*  h/w is initialized              */
+	BFI_IOC_CFG 	 = 3,		/*  IOC configuration in progress   */
+	BFI_IOC_OP 		 = 4,	/*  IOC is operational              */
+	BFI_IOC_DISABLING 	 = 5,	/*  IOC is being disabled           */
+	BFI_IOC_DISABLED 	 = 6,	/*  IOC is disabled                 */
+	BFI_IOC_CFG_DISABLED = 7,	/*  IOC is being disabled;transient */
+	BFI_IOC_HBFAIL       = 8,	/*  IOC heart-beat failure          */
+	BFI_IOC_MEMTEST      = 9,	/*  IOC is doing memtest            */
+};
+
+#define BFI_IOC_ENDIAN_SIG  0x12345678
+
+enum {
+	BFI_ADAPTER_TYPE_FC   = 0x01,		/*  FC adapters           */
+	BFI_ADAPTER_TYPE_MK   = 0x0f0000,	/*  adapter type mask     */
+	BFI_ADAPTER_TYPE_SH   = 16,	        /*  adapter type shift    */
+	BFI_ADAPTER_NPORTS_MK = 0xff00,		/*  number of ports mask  */
+	BFI_ADAPTER_NPORTS_SH = 8,	        /*  number of ports shift */
+	BFI_ADAPTER_SPEED_MK  = 0xff,		/*  adapter speed mask    */
+	BFI_ADAPTER_SPEED_SH  = 0,	        /*  adapter speed shift   */
+	BFI_ADAPTER_PROTO     = 0x100000,	/*  prototype adapaters   */
+	BFI_ADAPTER_TTV       = 0x200000,	/*  TTV debug capable     */
+	BFI_ADAPTER_UNSUPP    = 0x400000,	/*  unknown adapter type  */
+};
+
+#define BFI_ADAPTER_GETP(__prop,__adap_prop)          		\
+    (((__adap_prop) & BFI_ADAPTER_ ## __prop ## _MK) >>         \
+     BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_SETP(__prop, __val)         		\
+    ((__val) << BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_IS_PROTO(__adap_type)   			\
+    ((__adap_type) & BFI_ADAPTER_PROTO)
+#define BFI_ADAPTER_IS_TTV(__adap_type)     			\
+    ((__adap_type) & BFI_ADAPTER_TTV)
+#define BFI_ADAPTER_IS_UNSUPP(__adap_type)  			\
+    ((__adap_type) & BFI_ADAPTER_UNSUPP)
+#define BFI_ADAPTER_IS_SPECIAL(__adap_type)                     \
+    ((__adap_type) & (BFI_ADAPTER_TTV | BFI_ADAPTER_PROTO |     \
+			BFI_ADAPTER_UNSUPP))
+
+/**
+ * BFI_IOC_H2I_ENABLE_REQ & BFI_IOC_H2I_DISABLE_REQ messages
+ */
+struct bfi_ioc_ctrl_req_s {
+	struct bfi_mhdr_s	mh;
+	u8			ioc_class;
+	u8         	rsvd[3];
+};
+
+/**
+ * BFI_IOC_I2H_ENABLE_REPLY & BFI_IOC_I2H_DISABLE_REPLY messages
+ */
+struct bfi_ioc_ctrl_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header     */
+	u8         status;		/*  enable/disable status */
+	u8         rsvd[3];
+};
+
+#define BFI_IOC_MSGSZ   8
+/**
+ * H2I Messages
+ */
+union bfi_ioc_h2i_msg_u {
+	struct bfi_mhdr_s 	mh;
+	struct bfi_ioc_ctrl_req_s enable_req;
+	struct bfi_ioc_ctrl_req_s disable_req;
+	struct bfi_ioc_getattr_req_s getattr_req;
+	u32       		mboxmsg[BFI_IOC_MSGSZ];
+};
+
+/**
+ * I2H Messages
+ */
+union bfi_ioc_i2h_msg_u {
+	struct bfi_mhdr_s      	mh;
+	struct bfi_ioc_rdy_event_s 	rdy_event;
+	u32       		mboxmsg[BFI_IOC_MSGSZ];
+};
+
+#pragma pack()
+
+#endif /* __BFI_IOC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_iocfc.h patch/drivers/scsi/bfa/include/bfi/bfi_iocfc.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_iocfc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,177 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_IOCFC_H__
+#define __BFI_IOCFC_H__
+
+#include "bfi.h"
+#include <defs/bfa_defs_ioc.h>
+#include <defs/bfa_defs_iocfc.h>
+#include <defs/bfa_defs_boot.h>
+
+#pragma pack(1)
+
+enum bfi_iocfc_h2i_msgs {
+	BFI_IOCFC_H2I_CFG_REQ 		= 1,
+	BFI_IOCFC_H2I_GET_STATS_REQ 	= 2,
+	BFI_IOCFC_H2I_CLEAR_STATS_REQ	= 3,
+	BFI_IOCFC_H2I_SET_INTR_REQ 	= 4,
+	BFI_IOCFC_H2I_UPDATEQ_REQ = 5,
+};
+
+enum bfi_iocfc_i2h_msgs {
+	BFI_IOCFC_I2H_CFG_REPLY		= BFA_I2HM(1),
+	BFI_IOCFC_I2H_GET_STATS_RSP 	= BFA_I2HM(2),
+	BFI_IOCFC_I2H_CLEAR_STATS_RSP	= BFA_I2HM(3),
+	BFI_IOCFC_I2H_UPDATEQ_RSP = BFA_I2HM(5),
+};
+
+struct bfi_iocfc_cfg_s {
+	u8         num_cqs; 	/*  Number of CQs to be used     */
+	u8         sense_buf_len;	/*  SCSI sense length            */
+	u8         trunk_enabled;	/*  port trunking enabled        */
+	u8         trunk_ports;	/*  trunk ports bit map          */
+	u32        endian_sig;	/*  endian signature of host     */
+
+	/**
+	 * Request and response circular queue base addresses, size and
+	 * shadow index pointers.
+	 */
+	union bfi_addr_u  req_cq_ba[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  req_shadow_ci[BFI_IOC_MAX_CQS];
+	u16    req_cq_elems[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  rsp_cq_ba[BFI_IOC_MAX_CQS];
+	union bfi_addr_u  rsp_shadow_pi[BFI_IOC_MAX_CQS];
+	u16    rsp_cq_elems[BFI_IOC_MAX_CQS];
+
+	union bfi_addr_u  stats_addr;	/*  DMA-able address for stats	  */
+	union bfi_addr_u  cfgrsp_addr;	/*  config response dma address  */
+	union bfi_addr_u  ioim_snsbase;  /*  IO sense buffer base address */
+	struct bfa_iocfc_intr_attr_s intr_attr; /*  IOC interrupt attributes */
+};
+
+/**
+ * Boot target wwn information for this port. This contains either the stored
+ * or discovered boot target port wwns for the port.
+ */
+struct bfi_iocfc_bootwwns {
+	wwn_t		wwn[BFA_BOOT_BOOTLUN_MAX];
+	u8		nwwns;
+	u8		rsvd[7];
+};
+
+struct bfi_iocfc_cfgrsp_s {
+	struct bfa_iocfc_fwcfg_s	fwcfg;
+	struct bfa_iocfc_intr_attr_s	intr_attr;
+	struct bfi_iocfc_bootwwns	bootwwns;
+};
+
+/**
+ * BFI_IOCFC_H2I_CFG_REQ message
+ */
+struct bfi_iocfc_cfg_req_s {
+	struct bfi_mhdr_s      mh;
+	union bfi_addr_u      ioc_cfg_dma_addr;
+};
+
+/**
+ * BFI_IOCFC_I2H_CFG_REPLY message
+ */
+struct bfi_iocfc_cfg_reply_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header          */
+	u8         cfg_success;	/*  cfg reply status           */
+	u8         lpu_bm;		/*  LPUs assigned for this IOC */
+	u8         rsvd[2];
+};
+
+/**
+ *  BFI_IOCFC_H2I_GET_STATS_REQ & BFI_IOCFC_H2I_CLEAR_STATS_REQ messages
+ */
+struct bfi_iocfc_stats_req_s {
+	struct bfi_mhdr_s mh;		/*  msg header            */
+	u32        msgtag;		/*  msgtag for reply      */
+};
+
+/**
+ * BFI_IOCFC_I2H_GET_STATS_RSP & BFI_IOCFC_I2H_CLEAR_STATS_RSP messages
+ */
+struct bfi_iocfc_stats_rsp_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u8         status;		/*  reply status          */
+	u8         rsvd[3];
+	u32        msgtag;		/*  msgtag for reply      */
+};
+
+/**
+ * BFI_IOCFC_H2I_SET_INTR_REQ message
+ */
+struct bfi_iocfc_set_intr_req_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u8		coalesce;	/*  enable intr coalescing*/
+	u8         rsvd[3];
+	u16	delay;		/*  delay timer 0..1125us  */
+	u16	latency;	/*  latency timer 0..225us */
+};
+
+/**
+ * BFI_IOCFC_H2I_UPDATEQ_REQ message
+ */
+struct bfi_iocfc_updateq_req_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u32 reqq_ba;			/*  reqq base addr        */
+	u32 rspq_ba;			/*  rspq base addr        */
+	u32 reqq_sci;			/*  reqq shadow ci        */
+	u32 rspq_spi;			/*  rspq shadow pi        */
+};
+
+/**
+ * BFI_IOCFC_I2H_UPDATEQ_RSP message
+ */
+struct bfi_iocfc_updateq_rsp_s {
+	struct bfi_mhdr_s mh;		/*  common msg header     */
+	u8         status;		/*  updateq  status       */
+	u8         rsvd[3];
+};
+
+/**
+ * H2I Messages
+ */
+union bfi_iocfc_h2i_msg_u {
+	struct bfi_mhdr_s 		mh;
+	struct bfi_iocfc_cfg_req_s 	cfg_req;
+	struct bfi_iocfc_stats_req_s stats_get;
+	struct bfi_iocfc_stats_req_s stats_clr;
+	struct bfi_iocfc_updateq_req_s updateq_req;
+	u32       			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+/**
+ * I2H Messages
+ */
+union bfi_iocfc_i2h_msg_u {
+	struct bfi_mhdr_s      		mh;
+	struct bfi_iocfc_cfg_reply_s 		cfg_reply;
+	struct bfi_iocfc_stats_rsp_s stats_get_rsp;
+	struct bfi_iocfc_stats_rsp_s stats_clr_rsp;
+	struct bfi_iocfc_updateq_rsp_s updateq_rsp;
+	u32       			mboxmsg[BFI_IOC_MSGSZ];
+};
+
+#pragma pack()
+
+#endif /* __BFI_IOCFC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lport.h patch/drivers/scsi/bfa/include/bfi/bfi_lport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_LPORT_H__
+#define __BFI_LPORT_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_lport_h2i_msgs {
+	BFI_LPORT_H2I_CREATE_REQ = 1,
+	BFI_LPORT_H2I_DELETE_REQ = 2,
+};
+
+enum bfi_lport_i2h_msgs {
+	BFI_LPORT_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_LPORT_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_LPORT_I2H_ONLINE	  = BFA_I2HM(3),
+	BFI_LPORT_I2H_OFFLINE	  = BFA_I2HM(4),
+};
+
+#define BFI_LPORT_MAX_SYNNAME	64
+
+enum bfi_lport_role_e {
+	BFI_LPORT_ROLE_FCPIM	= 1,
+	BFI_LPORT_ROLE_FCPTM	= 2,
+	BFI_LPORT_ROLE_IPFC	= 4,
+};
+
+struct bfi_lport_create_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16	fabric_fwhdl;	/*  parent fabric instance	*/
+	u8		roles;		/*  lport FC-4 roles		*/
+	u8		rsvd;
+	wwn_t		pwwn;		/*  port name			*/
+	wwn_t		nwwn;		/*  node name			*/
+	u8		symname[BFI_LPORT_MAX_SYNNAME];
+};
+
+struct bfi_lport_create_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u8         status;		/*  lport creation status	*/
+	u8         rsvd[3];
+};
+
+struct bfi_lport_delete_req_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware lport handle	*/
+	u16        rsvd;
+};
+
+struct bfi_lport_delete_rsp_s {
+	bfi_mhdr_t	mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host lport handle		*/
+	u8         status;		/*  lport deletion status	*/
+	u8         rsvd;
+};
+
+union bfi_lport_h2i_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_lport_create_req_s	*create_req;
+	struct bfi_lport_delete_req_s	*delete_req;
+};
+
+union bfi_lport_i2h_msg_u {
+	bfi_msg_t		*msg;
+	struct bfi_lport_create_rsp_s	*create_rsp;
+	struct bfi_lport_delete_rsp_s	*delete_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_LPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_lps.h patch/drivers/scsi/bfa/include/bfi/bfi_lps.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_lps.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_lps.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_LPS_H__
+#define __BFI_LPS_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_lps_h2i_msgs {
+	BFI_LPS_H2I_LOGIN_REQ	= 1,
+	BFI_LPS_H2I_LOGOUT_REQ	= 2,
+};
+
+enum bfi_lps_i2h_msgs {
+	BFI_LPS_H2I_LOGIN_RSP	= BFA_I2HM(1),
+	BFI_LPS_H2I_LOGOUT_RSP	= BFA_I2HM(2),
+};
+
+struct bfi_lps_login_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		alpa;
+	u16	pdu_size;
+	wwn_t		pwwn;
+	wwn_t		nwwn;
+	u8		fdisc;
+	u8		auth_en;
+	u8		rsvd[2];
+};
+
+struct bfi_lps_login_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		status;
+	u8		lsrjt_rsn;
+	u8		lsrjt_expl;
+	wwn_t		port_name;
+	wwn_t		node_name;
+	u16	bb_credit;
+	u8		f_port;
+	u8		npiv_en;
+	u32	lp_pid : 24;
+	u32	auth_req : 8;
+	mac_t		lp_mac;
+	mac_t		fcf_mac;
+	u8		ext_status;
+	u8  	brcd_switch;/*  attached peer is brcd switch	*/
+};
+
+struct bfi_lps_logout_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		rsvd[3];
+	wwn_t		port_name;
+};
+
+struct bfi_lps_logout_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		status;
+	u8		rsvd[2];
+};
+
+union bfi_lps_h2i_msg_u {
+	struct bfi_mhdr_s		*msg;
+	struct bfi_lps_login_req_s	*login_req;
+	struct bfi_lps_logout_req_s	*logout_req;
+};
+
+union bfi_lps_i2h_msg_u {
+	struct bfi_msg_s		*msg;
+	struct bfi_lps_login_rsp_s	*login_rsp;
+	struct bfi_lps_logout_rsp_s	*logout_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_LPS_H__ */
+
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_port.h patch/drivers/scsi/bfa/include/bfi/bfi_port.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_port.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFI_PORT_H__
+#define __BFI_PORT_H__
+
+#include <bfi/bfi.h>
+#include <defs/bfa_defs_pport.h>
+
+#pragma pack(1)
+
+enum bfi_port_h2i {
+	BFI_PORT_H2I_ENABLE_REQ		= (1),
+	BFI_PORT_H2I_DISABLE_REQ	= (2),
+	BFI_PORT_H2I_GET_STATS_REQ	= (3),
+	BFI_PORT_H2I_CLEAR_STATS_REQ	= (4),
+};
+
+enum bfi_port_i2h {
+	BFI_PORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_PORT_I2H_DISABLE_RSP	= BFA_I2HM(2),
+	BFI_PORT_I2H_GET_STATS_RSP	= BFA_I2HM(3),
+	BFI_PORT_I2H_CLEAR_STATS_RSP	= BFA_I2HM(4),
+};
+
+/**
+ * Generic REQ type
+ */
+struct bfi_port_generic_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32        msgtag;		/*  msgtag for reply		    */
+	u32	rsvd;
+};
+
+/**
+ * Generic RSP type
+ */
+struct bfi_port_generic_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	u8         status;		/*  port enable status		    */
+	u8         rsvd[3];
+	u32        msgtag;		/*  msgtag for reply		    */
+};
+
+/**
+ * @todo
+ * BFI_PORT_H2I_ENABLE_REQ
+ */
+
+/**
+ * @todo
+ * BFI_PORT_I2H_ENABLE_RSP
+ */
+
+/**
+ * BFI_PORT_H2I_DISABLE_REQ
+ */
+
+/**
+ * BFI_PORT_I2H_DISABLE_RSP
+ */
+
+/**
+ * BFI_PORT_H2I_GET_STATS_REQ
+ */
+struct bfi_port_get_stats_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	union bfi_addr_u   dma_addr;
+};
+
+/**
+ * BFI_PORT_I2H_GET_STATS_RSP
+ */
+
+/**
+ * BFI_PORT_H2I_CLEAR_STATS_REQ
+ */
+
+/**
+ * BFI_PORT_I2H_CLEAR_STATS_RSP
+ */
+
+union bfi_port_h2i_msg_u {
+	struct bfi_mhdr_s		mh;
+	struct bfi_port_generic_req_s	enable_req;
+	struct bfi_port_generic_req_s	disable_req;
+	struct bfi_port_get_stats_req_s	getstats_req;
+	struct bfi_port_generic_req_s	clearstats_req;
+};
+
+union bfi_port_i2h_msg_u {
+	struct bfi_mhdr_s         	mh;
+	struct bfi_port_generic_rsp_s	enable_rsp;
+	struct bfi_port_generic_rsp_s	disable_rsp;
+	struct bfi_port_generic_rsp_s	getstats_rsp;
+	struct bfi_port_generic_rsp_s	clearstats_rsp;
+};
+
+#pragma pack()
+
+#endif /* __BFI_PORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_pport.h patch/drivers/scsi/bfa/include/bfi/bfi_pport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_pport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_pport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFI_PPORT_H__
+#define __BFI_PPORT_H__
+
+#include <bfi/bfi.h>
+#include <defs/bfa_defs_pport.h>
+
+#pragma pack(1)
+
+enum bfi_pport_h2i {
+	BFI_PPORT_H2I_ENABLE_REQ		= (1),
+	BFI_PPORT_H2I_DISABLE_REQ		= (2),
+	BFI_PPORT_H2I_GET_STATS_REQ		= (3),
+	BFI_PPORT_H2I_CLEAR_STATS_REQ	= (4),
+	BFI_PPORT_H2I_SET_SVC_PARAMS_REQ	= (5),
+	BFI_PPORT_H2I_ENABLE_RX_VF_TAG_REQ	= (6),
+	BFI_PPORT_H2I_ENABLE_TX_VF_TAG_REQ	= (7),
+	BFI_PPORT_H2I_GET_QOS_STATS_REQ		= (8),
+	BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ	= (9),
+};
+
+enum bfi_pport_i2h {
+	BFI_PPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_PPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
+	BFI_PPORT_I2H_GET_STATS_RSP		= BFA_I2HM(3),
+	BFI_PPORT_I2H_CLEAR_STATS_RSP	= BFA_I2HM(4),
+	BFI_PPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(5),
+	BFI_PPORT_I2H_ENABLE_RX_VF_TAG_RSP	= BFA_I2HM(6),
+	BFI_PPORT_I2H_ENABLE_TX_VF_TAG_RSP	= BFA_I2HM(7),
+	BFI_PPORT_I2H_EVENT			= BFA_I2HM(8),
+	BFI_PPORT_I2H_GET_QOS_STATS_RSP		= BFA_I2HM(9),
+	BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP	= BFA_I2HM(10),
+};
+
+/**
+ * Generic REQ type
+ */
+struct bfi_pport_generic_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32        msgtag;		/*  msgtag for reply		    */
+};
+
+/**
+ * Generic RSP type
+ */
+struct bfi_pport_generic_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		    */
+	u8         status;		/*  port enable status		    */
+	u8         rsvd[3];
+	u32        msgtag;		/*  msgtag for reply		    */
+};
+
+/**
+ * BFI_PPORT_H2I_ENABLE_REQ
+ */
+struct bfi_pport_enable_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header			    */
+	u32        rsvd1;
+	wwn_t           nwwn;		/*  node wwn of physical port	    */
+	wwn_t           pwwn;		/*  port wwn of physical port	    */
+	struct bfa_pport_cfg_s port_cfg;	/*  port configuration	    */
+	union bfi_addr_u  stats_dma_addr;	/*  DMA address for stats  */
+	u32        msgtag;		/*  msgtag for reply		    */
+	u32        rsvd2;
+};
+
+/**
+ * BFI_PPORT_I2H_ENABLE_RSP
+ */
+#define bfi_pport_enable_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_DISABLE_REQ
+ */
+#define bfi_pport_disable_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_I2H_DISABLE_RSP
+ */
+#define bfi_pport_disable_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_GET_STATS_REQ
+ */
+#define bfi_pport_get_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_I2H_GET_STATS_RSP
+ */
+#define bfi_pport_get_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_CLEAR_STATS_REQ
+ */
+#define bfi_pport_clear_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_I2H_CLEAR_STATS_RSP
+ */
+#define bfi_pport_clear_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_GET_QOS_STATS_REQ
+ */
+#define bfi_pport_get_qos_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_H2I_GET_QOS_STATS_RSP
+ */
+#define bfi_pport_get_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ
+ */
+#define bfi_pport_clear_qos_stats_req_t struct bfi_pport_generic_req_s
+
+/**
+ * BFI_PPORT_H2I_CLEAR_QOS_STATS_RSP
+ */
+#define bfi_pport_clear_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
+
+/**
+ * BFI_PPORT_H2I_SET_SVC_PARAMS_REQ
+ */
+struct bfi_pport_set_svc_params_req_s {
+	struct bfi_mhdr_s  mh;		/*  msg header */
+	u16        tx_bbcredit;	/*  Tx credits */
+	u16        rsvd;
+};
+
+/**
+ * BFI_PPORT_I2H_SET_SVC_PARAMS_RSP
+ */
+
+/**
+ * BFI_PPORT_I2H_EVENT
+ */
+struct bfi_pport_event_s {
+	struct bfi_mhdr_s 	mh;	/*  common msg header */
+	struct bfa_pport_link_s	link_state;
+};
+
+union bfi_pport_h2i_msg_u {
+	struct bfi_mhdr_s			*mhdr;
+	struct bfi_pport_enable_req_s		*penable;
+	struct bfi_pport_generic_req_s		*pdisable;
+	struct bfi_pport_generic_req_s		*pgetstats;
+	struct bfi_pport_generic_req_s		*pclearstats;
+	struct bfi_pport_set_svc_params_req_s	*psetsvcparams;
+	struct bfi_pport_get_qos_stats_req_s	*pgetqosstats;
+	struct bfi_pport_generic_req_s		*pclearqosstats;
+};
+
+union bfi_pport_i2h_msg_u {
+	struct bfi_msg_s			*msg;
+	struct bfi_pport_generic_rsp_s		*enable_rsp;
+	struct bfi_pport_disable_rsp_s		*disable_rsp;
+	struct bfi_pport_generic_rsp_s		*getstats_rsp;
+	struct bfi_pport_clear_stats_rsp_s	*clearstats_rsp;
+	struct bfi_pport_set_svc_params_rsp_s	*setsvcparasm_rsp;
+	struct bfi_pport_get_qos_stats_rsp_s	*getqosstats_rsp;
+	struct bfi_pport_clear_qos_stats_rsp_s	*clearqosstats_rsp;
+	struct bfi_pport_event_s		*event;
+};
+
+#pragma pack()
+
+#endif /* __BFI_PPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_rport.h patch/drivers/scsi/bfa/include/bfi/bfi_rport.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_rport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_RPORT_H__
+#define __BFI_RPORT_H__
+
+#include <bfi/bfi.h>
+
+#pragma pack(1)
+
+enum bfi_rport_h2i_msgs {
+	BFI_RPORT_H2I_CREATE_REQ = 1,
+	BFI_RPORT_H2I_DELETE_REQ = 2,
+	BFI_RPORT_H2I_SET_SPEED_REQ  = 3,
+};
+
+enum bfi_rport_i2h_msgs {
+	BFI_RPORT_I2H_CREATE_RSP = BFA_I2HM(1),
+	BFI_RPORT_I2H_DELETE_RSP = BFA_I2HM(2),
+	BFI_RPORT_I2H_QOS_SCN    = BFA_I2HM(3),
+};
+
+struct bfi_rport_create_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host rport handle		*/
+	u16        max_frmsz;	/*  max rcv pdu size		*/
+	u32        pid       : 24,	/*  remote port ID		*/
+			lp_tag    : 8;	/*  local port tag		*/
+	u32        local_pid : 24,	/*  local port ID		*/
+			cisc      : 8;
+	u8         fc_class;	/*  supported FC classes	*/
+	u8         vf_en;		/*  virtual fabric enable	*/
+	u16        vf_id;		/*  virtual fabric ID		*/
+};
+
+struct bfi_rport_create_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8         status;		/*  rport creation status	*/
+	u8         rsvd[3];
+	u16        bfa_handle;	/*  host rport handle		*/
+	u16        fw_handle;	/*  firmware rport handle	*/
+	struct bfa_rport_qos_attr_s qos_attr;  /* QoS Attributes */
+};
+
+struct bfa_rport_speed_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware rport handle	*/
+	u8		speed;		/*! rport's speed via RPSC  */
+	u8		rsvd;
+};
+
+struct bfi_rport_delete_req_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        fw_handle;	/*  firmware rport handle	*/
+	u16        rsvd;
+};
+
+struct bfi_rport_delete_rsp_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host rport handle		*/
+	u8         status;		/*  rport deletion status	*/
+	u8         rsvd;
+};
+
+struct bfi_rport_qos_scn_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u16        bfa_handle;	/*  host rport handle		*/
+	u16        rsvd;
+	struct bfa_rport_qos_attr_s old_qos_attr;  /* Old QoS Attributes */
+	struct bfa_rport_qos_attr_s new_qos_attr;  /* New QoS Attributes */
+};
+
+union bfi_rport_h2i_msg_u {
+	struct bfi_msg_s 		*msg;
+	struct bfi_rport_create_req_s	*create_req;
+	struct bfi_rport_delete_req_s	*delete_req;
+	struct bfi_rport_speed_req_s	*speed_req;
+};
+
+union bfi_rport_i2h_msg_u {
+	struct bfi_msg_s 		*msg;
+	struct bfi_rport_create_rsp_s	*create_rsp;
+	struct bfi_rport_delete_rsp_s	*delete_rsp;
+	struct bfi_rport_qos_scn_s	*qos_scn_evt;
+};
+
+#pragma pack()
+
+#endif /* __BFI_RPORT_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/bfi/bfi_uf.h patch/drivers/scsi/bfa/include/bfi/bfi_uf.h
--- orig/drivers/scsi/bfa/include/bfi/bfi_uf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/bfi/bfi_uf.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_UF_H__
+#define __BFI_UF_H__
+
+#include "bfi.h"
+
+#pragma pack(1)
+
+enum bfi_uf_h2i {
+	BFI_UF_H2I_BUF_POST = 1,
+};
+
+enum bfi_uf_i2h {
+	BFI_UF_I2H_FRM_RCVD = BFA_I2HM(1),
+};
+
+#define BFA_UF_MAX_SGES	2
+
+struct bfi_uf_buf_post_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
+	u16        buf_tag;	/*  buffer tag			*/
+	u16        buf_len;	/*  total buffer length	*/
+	struct bfi_sge_s   sge[BFA_UF_MAX_SGES]; /*  buffer DMA SGEs	*/
+};
+
+struct bfi_uf_frm_rcvd_s {
+	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
+	u16        buf_tag;	/*  buffer tag			*/
+	u16        rsvd;
+	u16        frm_len;	/*  received frame length 	*/
+	u16        xfr_len;	/*  tranferred length		*/
+};
+
+#pragma pack()
+
+#endif /* __BFI_UF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h patch/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
--- orig/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_cna_trcmod.h CNA trace modules
+ */
+
+#ifndef __BFA_CNA_TRCMOD_H__
+#define __BFA_CNA_TRCMOD_H__
+
+#include <cs/bfa_trc.h>
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_CNA_CEE		= 1,
+	BFA_TRC_CNA_PORT	= 2,
+};
+
+#endif /* __BFA_CNA_TRCMOD_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/cee/bfa_cee.h patch/drivers/scsi/bfa/include/cna/cee/bfa_cee.h
--- orig/drivers/scsi/bfa/include/cna/cee/bfa_cee.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/cee/bfa_cee.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_CEE_H__
+#define __BFA_CEE_H__
+
+#include <defs/bfa_defs_cee.h>
+#include <bfa_ioc.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+
+typedef void (*bfa_cee_get_attr_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_cee_get_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_cee_reset_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_cee_hbfail_cbfn_t) (void *dev, bfa_status_t status);
+
+struct bfa_cee_cbfn_s {
+	bfa_cee_get_attr_cbfn_t    get_attr_cbfn;
+	void *get_attr_cbarg;
+	bfa_cee_get_stats_cbfn_t   get_stats_cbfn;
+	void *get_stats_cbarg;
+	bfa_cee_reset_stats_cbfn_t reset_stats_cbfn;
+	void *reset_stats_cbarg;
+};
+
+struct bfa_cee_s {
+	void *dev;
+	bfa_boolean_t get_attr_pending;
+	bfa_boolean_t get_stats_pending;
+	bfa_boolean_t reset_stats_pending;
+	bfa_status_t get_attr_status;
+	bfa_status_t get_stats_status;
+	bfa_status_t reset_stats_status;
+	struct bfa_cee_cbfn_s cbfn;
+	struct bfa_ioc_hbfail_notify_s hbfail;
+	struct bfa_trc_mod_s *trcmod;
+	struct bfa_log_mod_s *logmod;
+	struct bfa_cee_attr_s *attr;
+	struct bfa_cee_stats_s *stats;
+	struct bfa_dma_s attr_dma;
+	struct bfa_dma_s stats_dma;
+	struct bfa_ioc_s *ioc;
+	struct bfa_mbox_cmd_s get_cfg_mb;
+	struct bfa_mbox_cmd_s get_stats_mb;
+	struct bfa_mbox_cmd_s reset_stats_mb;
+};
+
+u32 bfa_cee_meminfo(void);
+void bfa_cee_mem_claim(struct bfa_cee_s *cee, u8 *dma_kva,
+			 u64 dma_pa);
+void bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc, void *dev,
+			struct bfa_trc_mod_s *trcmod,
+			struct bfa_log_mod_s *logmod);
+void bfa_cee_detach(struct bfa_cee_s *cee);
+bfa_status_t bfa_cee_get_attr(struct bfa_cee_s *cee,
+			 struct bfa_cee_attr_s *attr,
+			bfa_cee_get_attr_cbfn_t cbfn, void *cbarg);
+bfa_status_t bfa_cee_get_stats(struct bfa_cee_s *cee,
+			struct bfa_cee_stats_s *stats,
+			bfa_cee_get_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t bfa_cee_reset_stats(struct bfa_cee_s *cee,
+			bfa_cee_reset_stats_cbfn_t cbfn, void *cbarg);
+#endif /* __BFA_CEE_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/port/bfa_port.h patch/drivers/scsi/bfa/include/cna/port/bfa_port.h
--- orig/drivers/scsi/bfa/include/cna/port/bfa_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/port/bfa_port.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_PORT_H__
+#define __BFA_PORT_H__
+
+#include <defs/bfa_defs_port.h>
+#include <bfa_ioc.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+
+typedef void    (*bfa_port_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void    (*bfa_port_endis_cbfn_t) (void *dev, bfa_status_t status);
+
+struct bfa_port_s {
+	void           *dev;
+	struct bfa_ioc_s *ioc;
+	struct bfa_trc_mod_s *trcmod;
+	struct bfa_log_mod_s *logmod;
+	u32        msgtag;
+	bfa_boolean_t   stats_busy;
+	struct bfa_mbox_cmd_s stats_mb;
+	bfa_port_stats_cbfn_t stats_cbfn;
+	void           *stats_cbarg;
+	bfa_status_t    stats_status;
+	union bfa_pport_stats_u *stats;
+	struct bfa_dma_s stats_dma;
+	bfa_boolean_t   endis_pending;
+	struct bfa_mbox_cmd_s endis_mb;
+	bfa_port_endis_cbfn_t endis_cbfn;
+	void           *endis_cbarg;
+	bfa_status_t    endis_status;
+	struct bfa_ioc_hbfail_notify_s hbfail;
+};
+
+void            bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
+				void *dev, struct bfa_trc_mod_s *trcmod,
+				struct bfa_log_mod_s *logmod);
+void            bfa_port_detach(struct bfa_port_s *port);
+void            bfa_port_hbfail(void *arg);
+
+bfa_status_t    bfa_port_get_stats(struct bfa_port_s *port,
+				   union bfa_pport_stats_u *stats,
+				   bfa_port_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t    bfa_port_clear_stats(struct bfa_port_s *port,
+				     bfa_port_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t    bfa_port_enable(struct bfa_port_s *port,
+				bfa_port_endis_cbfn_t cbfn, void *cbarg);
+bfa_status_t    bfa_port_disable(struct bfa_port_s *port,
+				 bfa_port_endis_cbfn_t cbfn, void *cbarg);
+u32        bfa_port_meminfo(void);
+void            bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva,
+				   u64 dma_pa);
+
+#endif /* __BFA_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h patch/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
--- orig/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2006-2008 Brocade Communications Systems, Inc.
+ * All rights reserved.
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __ETHPORT_DEFS_H__
+#define __ETHPORT_DEFS_H__
+
+struct bnad_drv_stats {
+	u64 netif_queue_stop;
+	u64 netif_queue_wakeup;
+	u64 tso4;
+	u64 tso6;
+	u64 tso_err;
+	u64 tcpcsum_offload;
+	u64 udpcsum_offload;
+	u64 csum_help;
+	u64 csum_help_err;
+
+	u64 hw_stats_updates;
+	u64 netif_rx_schedule;
+	u64 netif_rx_complete;
+	u64 netif_rx_dropped;
+};
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h patch/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h
--- orig/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,218 @@
+/*
+ * Copyright (c) 2006-2008 Brocade Communications Systems, Inc.
+ * All rights reserved.
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __PHYPORT_DEFS_H__
+#define __PHYPORT_DEFS_H__
+
+#define BNA_TXF_ID_MAX  	64
+#define BNA_RXF_ID_MAX  	64
+
+/*
+ * Statistics
+ */
+
+/*
+ * TxF Frame Statistics
+ */
+struct bna_stats_txf {
+	u64        ucast_octets;
+	u64        ucast;
+	u64        ucast_vlan;
+
+	u64        mcast_octets;
+	u64        mcast;
+	u64        mcast_vlan;
+
+	u64        bcast_octets;
+	u64        bcast;
+	u64        bcast_vlan;
+
+	u64        errors;
+	u64        filter_vlan;	/* frames filtered due to VLAN */
+	u64        filter_mac_sa;	/* frames filtered due to SA check */
+};
+
+/*
+ * RxF Frame Statistics
+ */
+struct bna_stats_rxf {
+	u64        ucast_octets;
+	u64        ucast;
+	u64        ucast_vlan;
+
+	u64        mcast_octets;
+	u64        mcast;
+	u64        mcast_vlan;
+
+	u64        bcast_octets;
+	u64        bcast;
+	u64        bcast_vlan;
+	u64        frame_drops;
+};
+
+/*
+ * FC Tx Frame Statistics
+ */
+struct bna_stats_fc_tx {
+	u64        txf_ucast_octets;
+	u64        txf_ucast;
+	u64        txf_ucast_vlan;
+
+	u64        txf_mcast_octets;
+	u64        txf_mcast;
+	u64        txf_mcast_vlan;
+
+	u64        txf_bcast_octets;
+	u64        txf_bcast;
+	u64        txf_bcast_vlan;
+
+	u64        txf_parity_errors;
+	u64        txf_timeout;
+	u64        txf_fid_parity_errors;
+};
+
+/*
+ * FC Rx Frame Statistics
+ */
+struct bna_stats_fc_rx {
+	u64        rxf_ucast_octets;
+	u64        rxf_ucast;
+	u64        rxf_ucast_vlan;
+
+	u64        rxf_mcast_octets;
+	u64        rxf_mcast;
+	u64        rxf_mcast_vlan;
+
+	u64        rxf_bcast_octets;
+	u64        rxf_bcast;
+	u64        rxf_bcast_vlan;
+};
+
+/*
+ * RAD Frame Statistics
+ */
+struct cna_stats_rad {
+	u64        rx_frames;
+	u64        rx_octets;
+	u64        rx_vlan_frames;
+
+	u64        rx_ucast;
+	u64        rx_ucast_octets;
+	u64        rx_ucast_vlan;
+
+	u64        rx_mcast;
+	u64        rx_mcast_octets;
+	u64        rx_mcast_vlan;
+
+	u64        rx_bcast;
+	u64        rx_bcast_octets;
+	u64        rx_bcast_vlan;
+
+	u64        rx_drops;
+};
+
+/*
+ * BPC Tx Registers
+ */
+struct cna_stats_bpc_tx {
+	u64        tx_pause[8];
+	u64        tx_zero_pause[8];	/*  Pause cancellation */
+	u64        tx_first_pause[8];	/*  Pause initiation rather
+						 *than retention */
+};
+
+/*
+ * BPC Rx Registers
+ */
+struct cna_stats_bpc_rx {
+	u64        rx_pause[8];
+	u64        rx_zero_pause[8];	/*  Pause cancellation */
+	u64        rx_first_pause[8];	/*  Pause initiation rather
+						 *than retention */
+};
+
+/*
+ * MAC Rx Statistics
+ */
+struct cna_stats_mac_rx {
+	u64        frame_64;	/* both rx and tx counter */
+	u64        frame_65_127;	/* both rx and tx counter */
+	u64        frame_128_255;	/* both rx and tx counter */
+	u64        frame_256_511;	/* both rx and tx counter */
+	u64        frame_512_1023;	/* both rx and tx counter */
+	u64        frame_1024_1518;	/* both rx and tx counter */
+	u64        frame_1518_1522;	/* both rx and tx counter */
+	u64        rx_bytes;
+	u64        rx_packets;
+	u64        rx_fcs_error;
+	u64        rx_multicast;
+	u64        rx_broadcast;
+	u64        rx_control_frames;
+	u64        rx_pause;
+	u64        rx_unknown_opcode;
+	u64        rx_alignment_error;
+	u64        rx_frame_length_error;
+	u64        rx_code_error;
+	u64        rx_carrier_sense_error;
+	u64        rx_undersize;
+	u64        rx_oversize;
+	u64        rx_fragments;
+	u64        rx_jabber;
+	u64        rx_drop;
+};
+
+/*
+ * MAC Tx Statistics
+ */
+struct cna_stats_mac_tx {
+	u64        tx_bytes;
+	u64        tx_packets;
+	u64        tx_multicast;
+	u64        tx_broadcast;
+	u64        tx_pause;
+	u64        tx_deferral;
+	u64        tx_excessive_deferral;
+	u64        tx_single_collision;
+	u64        tx_muliple_collision;
+	u64        tx_late_collision;
+	u64        tx_excessive_collision;
+	u64        tx_total_collision;
+	u64        tx_pause_honored;
+	u64        tx_drop;
+	u64        tx_jabber;
+	u64        tx_fcs_error;
+	u64        tx_control_frame;
+	u64        tx_oversize;
+	u64        tx_undersize;
+	u64        tx_fragments;
+};
+
+/*
+ * Complete statistics
+ */
+struct bna_stats {
+	struct cna_stats_mac_rx mac_rx_stats;
+	struct cna_stats_bpc_rx bpc_rx_stats;
+	struct cna_stats_rad rad_stats;
+	struct bna_stats_fc_rx fc_rx_stats;
+	struct cna_stats_mac_tx mac_tx_stats;
+	struct cna_stats_bpc_tx bpc_tx_stats;
+	struct bna_stats_fc_tx fc_tx_stats;
+	struct bna_stats_rxf rxf_stats[BNA_TXF_ID_MAX];
+	struct bna_stats_txf txf_stats[BNA_RXF_ID_MAX];
+};
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_checksum.h patch/drivers/scsi/bfa/include/cs/bfa_checksum.h
--- orig/drivers/scsi/bfa/include/cs/bfa_checksum.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_checksum.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_checksum.h BFA checksum utilities
+ */
+
+#ifndef __BFA_CHECKSUM_H__
+#define __BFA_CHECKSUM_H__
+
+static inline u32
+bfa_checksum_u32(u32 *buf, int sz)
+{
+	int		i, m = sz >> 2;
+	u32	sum = 0;
+
+	for (i = 0; i < m; i++)
+		sum ^= buf[i];
+
+	return (sum);
+}
+
+static inline u16
+bfa_checksum_u16(u16 *buf, int sz)
+{
+	int             i, m = sz >> 1;
+	u16        sum = 0;
+
+	for (i = 0; i < m; i++)
+		sum ^= buf[i];
+
+	return (sum);
+}
+
+static inline u8
+bfa_checksum_u8(u8 *buf, int sz)
+{
+	int             i;
+	u8         sum = 0;
+
+	for (i = 0; i < sz; i++)
+		sum ^= buf[i];
+
+	return (sum);
+}
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_debug.h patch/drivers/scsi/bfa/include/cs/bfa_debug.h
--- orig/drivers/scsi/bfa/include/cs/bfa_debug.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_debug.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_debug.h BFA debug interfaces
+ */
+
+#ifndef __BFA_DEBUG_H__
+#define __BFA_DEBUG_H__
+
+#define bfa_assert(__cond)	do {					\
+	if (!(__cond)) 							\
+		bfa_panic(__LINE__, __FILE__, #__cond);      \
+} while (0)
+
+#define bfa_sm_fault(__mod, __event)	do {				\
+	bfa_sm_panic((__mod)->logm, __LINE__, __FILE__, __event);      \
+} while (0)
+
+#ifndef BFA_PERF_BUILD
+#define bfa_assert_fp(__cond)	bfa_assert(__cond)
+#else
+#define bfa_assert_fp(__cond)
+#endif
+
+struct bfa_log_mod_s;
+void bfa_panic(int line, char *file, char *panicstr);
+void bfa_sm_panic(struct bfa_log_mod_s *logm, int line, char *file, int event);
+
+#endif /* __BFA_DEBUG_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_log.h patch/drivers/scsi/bfa/include/cs/bfa_log.h
--- orig/drivers/scsi/bfa/include/cs/bfa_log.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_log.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_log.h BFA log library data structure and function definition
+ */
+
+#ifndef __BFA_LOG_H__
+#define __BFA_LOG_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_aen.h>
+
+/*
+ * BFA log module definition
+ *
+ * To create a new module id:
+ * Add a #define at the end of the list below. Select a value for your
+ * definition so that it is one (1) greater than the previous
+ * definition. Modify the definition of BFA_LOG_MODULE_ID_MAX to become
+ * your new definition.
+ * Should have no gaps in between the values because this is used in arrays.
+ * IMPORTANT: AEN_IDs must be at the begining, otherwise update bfa_defs_aen.h
+ */
+
+enum bfa_log_module_id {
+	BFA_LOG_UNUSED_ID	= 0,
+
+	/* AEN defs begin */
+	BFA_LOG_AEN_MIN		= BFA_LOG_UNUSED_ID,
+
+	BFA_LOG_AEN_ID_ADAPTER 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ADAPTER,/* 1 */
+	BFA_LOG_AEN_ID_PORT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_PORT,	/* 2 */
+	BFA_LOG_AEN_ID_LPORT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_LPORT,	/* 3 */
+	BFA_LOG_AEN_ID_RPORT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_RPORT,	/* 4 */
+	BFA_LOG_AEN_ID_ITNIM 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ITNIM,	/* 5 */
+	BFA_LOG_AEN_ID_TIN 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_TIN,	/* 6 */
+	BFA_LOG_AEN_ID_IPFC 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_IPFC,	/* 7 */
+	BFA_LOG_AEN_ID_AUDIT 	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_AUDIT,	/* 8 */
+	BFA_LOG_AEN_ID_IOC	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_IOC,	/* 9 */
+	BFA_LOG_AEN_ID_ETHPORT	= BFA_LOG_AEN_MIN + BFA_AEN_CAT_ETHPORT,/* 10 */
+
+	BFA_LOG_AEN_MAX		= BFA_LOG_AEN_ID_ETHPORT,
+	/* AEN defs end */
+
+	BFA_LOG_MODULE_ID_MIN	= BFA_LOG_AEN_MAX,
+
+	BFA_LOG_FW_ID		= BFA_LOG_MODULE_ID_MIN + 1,
+	BFA_LOG_HAL_ID		= BFA_LOG_MODULE_ID_MIN + 2,
+	BFA_LOG_FCS_ID		= BFA_LOG_MODULE_ID_MIN + 3,
+	BFA_LOG_WDRV_ID		= BFA_LOG_MODULE_ID_MIN + 4,
+	BFA_LOG_LINUX_ID	= BFA_LOG_MODULE_ID_MIN + 5,
+	BFA_LOG_SOLARIS_ID	= BFA_LOG_MODULE_ID_MIN + 6,
+
+	BFA_LOG_MODULE_ID_MAX 	= BFA_LOG_SOLARIS_ID,
+
+	/* Not part of any arrays */
+	BFA_LOG_MODULE_ID_ALL 	= BFA_LOG_MODULE_ID_MAX + 1,
+	BFA_LOG_AEN_ALL 	= BFA_LOG_MODULE_ID_MAX + 2,
+	BFA_LOG_DRV_ALL		= BFA_LOG_MODULE_ID_MAX + 3,
+};
+
+/*
+ * BFA log catalog name
+ */
+#define BFA_LOG_CAT_NAME	"BFA"
+
+/*
+ * bfa log severity values
+ */
+enum bfa_log_severity {
+	BFA_LOG_INVALID = 0,
+	BFA_LOG_CRITICAL = 1,
+	BFA_LOG_ERROR = 2,
+	BFA_LOG_WARNING = 3,
+	BFA_LOG_INFO = 4,
+	BFA_LOG_NONE = 5,
+	BFA_LOG_LEVEL_MAX = BFA_LOG_NONE
+};
+
+#define BFA_LOG_MODID_OFFSET		16
+
+
+struct bfa_log_msgdef_s {
+	u32	msg_id;		/*  message id */
+	int		attributes;	/*  attributes */
+	int		severity;	/*  severity level */
+	char		*msg_value;
+					/*  msg string */
+	char		*message;
+					/*  msg format string */
+	int		arg_type;	/*  argument type */
+	int		arg_num;	/*  number of argument */
+};
+
+/*
+ * supported argument type
+ */
+enum bfa_log_arg_type {
+	BFA_LOG_S = 0,		/*  string */
+	BFA_LOG_D,		/*  decimal */
+	BFA_LOG_I,		/*  integer */
+	BFA_LOG_O,		/*  oct number */
+	BFA_LOG_U,		/*  unsigned integer */
+	BFA_LOG_X,		/*  hex number */
+	BFA_LOG_F,		/*  floating */
+	BFA_LOG_C,		/*  character */
+	BFA_LOG_L,		/*  double */
+	BFA_LOG_P		/*  pointer */
+};
+
+#define BFA_LOG_ARG_TYPE	2
+#define BFA_LOG_ARG0		(0 * BFA_LOG_ARG_TYPE)
+#define BFA_LOG_ARG1		(1 * BFA_LOG_ARG_TYPE)
+#define BFA_LOG_ARG2		(2 * BFA_LOG_ARG_TYPE)
+#define BFA_LOG_ARG3		(3 * BFA_LOG_ARG_TYPE)
+
+#define BFA_LOG_GET_MOD_ID(msgid) ((msgid >> BFA_LOG_MODID_OFFSET) & 0xff)
+#define BFA_LOG_GET_MSG_IDX(msgid) (msgid & 0xffff)
+#define BFA_LOG_GET_MSG_ID(msgdef) ((msgdef)->msg_id)
+#define BFA_LOG_GET_MSG_FMT_STRING(msgdef) ((msgdef)->message)
+#define BFA_LOG_GET_SEVERITY(msgdef) ((msgdef)->severity)
+
+/*
+ * Event attributes
+ */
+#define BFA_LOG_ATTR_NONE	0
+#define BFA_LOG_ATTR_AUDIT	1
+#define BFA_LOG_ATTR_LOG	2
+#define BFA_LOG_ATTR_FFDC	4
+
+#define BFA_LOG_CREATE_ID(msw, lsw) \
+	(((u32)msw << BFA_LOG_MODID_OFFSET) | lsw)
+
+struct bfa_log_mod_s;
+
+/**
+ * callback function
+ */
+typedef void (*bfa_log_cb_t)(struct bfa_log_mod_s *log_mod, u32 msg_id,
+			const char *format, ...);
+
+
+struct bfa_log_mod_s {
+	char		instance_info[16];	/*  instance info */
+	int		log_level[BFA_LOG_MODULE_ID_MAX + 1];
+						/*  log level for modules */
+	bfa_log_cb_t	cbfn; 			/*  callback function */
+};
+
+extern int bfa_log_init(struct bfa_log_mod_s *log_mod,
+			char *instance_name, bfa_log_cb_t cbfn);
+extern int bfa_log(struct bfa_log_mod_s *log_mod, u32 msg_id, ...);
+extern bfa_status_t bfa_log_set_level(struct bfa_log_mod_s *log_mod,
+			int mod_id, enum bfa_log_severity log_level);
+extern bfa_status_t bfa_log_set_level_all(struct bfa_log_mod_s *log_mod,
+			enum bfa_log_severity log_level);
+extern bfa_status_t bfa_log_set_level_aen(struct bfa_log_mod_s *log_mod,
+			enum bfa_log_severity log_level);
+extern enum bfa_log_severity bfa_log_get_level(struct bfa_log_mod_s *log_mod,
+			int mod_id);
+extern enum bfa_log_severity bfa_log_get_msg_level(
+			struct bfa_log_mod_s *log_mod, u32 msg_id);
+/*
+ * array of messages generated from xml files
+ */
+extern struct bfa_log_msgdef_s bfa_log_msg_array[];
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_perf.h patch/drivers/scsi/bfa/include/cs/bfa_perf.h
--- orig/drivers/scsi/bfa/include/cs/bfa_perf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_perf.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFAD_PERF_H__
+#define __BFAD_PERF_H__
+
+#ifdef BFAD_PERF_BUILD
+
+#undef bfa_trc
+#undef bfa_trc32
+#undef bfa_assert
+#undef BFA_TRC_FILE
+
+#define bfa_trc(_trcp, _data)
+#define bfa_trc32(_trcp, _data)
+#define bfa_assert(__cond)
+#define BFA_TRC_FILE(__mod, __submod)
+
+#endif
+
+#endif /* __BFAD_PERF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_plog.h patch/drivers/scsi/bfa/include/cs/bfa_plog.h
--- orig/drivers/scsi/bfa/include/cs/bfa_plog.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_plog.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,162 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_PORTLOG_H__
+#define __BFA_PORTLOG_H__
+
+#include "protocol/fc.h"
+#include <defs/bfa_defs_types.h>
+
+#define BFA_PL_NLOG_ENTS 256
+#define BFA_PL_LOG_REC_INCR(_x) ((_x)++, (_x) %= BFA_PL_NLOG_ENTS)
+
+#define BFA_PL_STRING_LOG_SZ   32   /* number of chars in string log */
+#define BFA_PL_INT_LOG_SZ      8    /* number of integers in the integer log */
+
+enum bfa_plog_log_type {
+	BFA_PL_LOG_TYPE_INVALID = 0,
+	BFA_PL_LOG_TYPE_INT 	= 1,
+	BFA_PL_LOG_TYPE_STRING 	= 2,
+};
+
+/*
+ * the (fixed size) record format for each entry in the portlog
+ */
+struct bfa_plog_rec_s {
+	u32        tv;	/* Filled by the portlog driver when the *
+				 * entry is added to the circular log.   */
+	u8         port;	/* Source port that logged this entry. CM
+				 * entities will use 0xFF */
+	u8         mid;	/* Integer value to be used by all entities *
+				 * while logging. The module id to string   *
+				 * conversion will be done by BFAL. See
+				 * enum bfa_plog_mid */
+	u8         eid;	/* indicates Rx, Tx, IOCTL, etc. See
+				 * enum bfa_plog_eid */
+	u8         log_type; /* indicates string log or integer log.
+				   * see bfa_plog_log_type_t */
+	u8         log_num_ints;
+	/*
+	 * interpreted only if log_type is INT_LOG. indicates number of
+	 * integers in the int_log[] (0-PL_INT_LOG_SZ).
+	 */
+	u8         rsvd;
+	u16        misc;	/* can be used to indicate fc frame length,
+				 *etc.. */
+	union {
+		char            string_log[BFA_PL_STRING_LOG_SZ];
+		u32        int_log[BFA_PL_INT_LOG_SZ];
+	} log_entry;
+
+};
+
+/*
+ * the following #defines will be used by the logging entities to indicate
+ * their module id. BFAL will convert the integer value to string format
+ *
+* process to be used while changing the following #defines:
+ *  - Always add new entries at the end
+ *  - define corresponding string in BFAL
+ *  - Do not remove any entry or rearrange the order.
+ */
+enum bfa_plog_mid {
+	BFA_PL_MID_INVALID 	= 0,
+	BFA_PL_MID_DEBUG 	= 1,
+	BFA_PL_MID_DRVR 	= 2,
+	BFA_PL_MID_HAL 		= 3,
+	BFA_PL_MID_HAL_FCXP 	= 4,
+	BFA_PL_MID_HAL_UF 	= 5,
+	BFA_PL_MID_FCS 		= 6,
+	BFA_PL_MID_MAX 		= 7
+};
+
+#define BFA_PL_MID_STRLEN    8
+struct bfa_plog_mid_strings_s {
+	char            m_str[BFA_PL_MID_STRLEN];
+};
+
+/*
+ * the following #defines will be used by the logging entities to indicate
+ * their event type. BFAL will convert the integer value to string format
+ *
+* process to be used while changing the following #defines:
+ *  - Always add new entries at the end
+ *  - define corresponding string in BFAL
+ *  - Do not remove any entry or rearrange the order.
+ */
+enum bfa_plog_eid {
+	BFA_PL_EID_INVALID 		= 0,
+	BFA_PL_EID_IOC_DISABLE 		= 1,
+	BFA_PL_EID_IOC_ENABLE 		= 2,
+	BFA_PL_EID_PORT_DISABLE 	= 3,
+	BFA_PL_EID_PORT_ENABLE 		= 4,
+	BFA_PL_EID_PORT_ST_CHANGE 	= 5,
+	BFA_PL_EID_TX 			= 6,
+	BFA_PL_EID_TX_ACK1 		= 7,
+	BFA_PL_EID_TX_RJT 		= 8,
+	BFA_PL_EID_TX_BSY 		= 9,
+	BFA_PL_EID_RX 			= 10,
+	BFA_PL_EID_RX_ACK1 		= 11,
+	BFA_PL_EID_RX_RJT 		= 12,
+	BFA_PL_EID_RX_BSY 		= 13,
+	BFA_PL_EID_CT_IN 		= 14,
+	BFA_PL_EID_CT_OUT 		= 15,
+	BFA_PL_EID_DRIVER_START 	= 16,
+	BFA_PL_EID_RSCN 		= 17,
+	BFA_PL_EID_DEBUG 		= 18,
+	BFA_PL_EID_MISC 		= 19,
+	BFA_PL_EID_MAX 			= 20
+};
+
+#define BFA_PL_ENAME_STRLEN    	8
+struct bfa_plog_eid_strings_s {
+	char            e_str[BFA_PL_ENAME_STRLEN];
+};
+
+#define BFA_PL_SIG_LEN	8
+#define BFA_PL_SIG_STR  "12pl123"
+
+/*
+ * per port circular log buffer
+ */
+struct bfa_plog_s {
+	char            plog_sig[BFA_PL_SIG_LEN];	/* Start signature */
+	u8         plog_enabled;
+	u8         rsvd[7];
+	u32        ticks;
+	u16        head;
+	u16        tail;
+	struct bfa_plog_rec_s  plog_recs[BFA_PL_NLOG_ENTS];
+};
+
+void bfa_plog_init(struct bfa_plog_s *plog);
+void bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc, char *log_str);
+void bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			u32 *intarr, u32 num_ints);
+void bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			struct fchs_s *fchdr);
+void bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			struct fchs_s *fchdr, u32 pld_w0);
+void bfa_plog_clear(struct bfa_plog_s *plog);
+void bfa_plog_enable(struct bfa_plog_s *plog);
+void bfa_plog_disable(struct bfa_plog_s *plog);
+bfa_boolean_t	bfa_plog_get_setting(struct bfa_plog_s *plog);
+
+#endif /* __BFA_PORTLOG_H__ */
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_q.h patch/drivers/scsi/bfa/include/cs/bfa_q.h
--- orig/drivers/scsi/bfa/include/cs/bfa_q.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_q.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_q.h Circular queue definitions.
+ */
+
+#ifndef __BFA_Q_H__
+#define __BFA_Q_H__
+
+#define bfa_q_first(_q) ((void *)(((struct list_head *) (_q))->next))
+#define bfa_q_next(_qe)	(((struct list_head *) (_qe))->next)
+#define bfa_q_prev(_qe) (((struct list_head *) (_qe))->prev)
+
+/*
+ * bfa_q_qe_init - to initialize a queue element
+ */
+#define bfa_q_qe_init(_qe) {						\
+	bfa_q_next(_qe) = (struct list_head *) NULL;			\
+	bfa_q_prev(_qe) = (struct list_head *) NULL;			\
+}
+
+/*
+ * bfa_q_deq - dequeue an element from head of the queue
+ */
+#define bfa_q_deq(_q, _qe) {						\
+	if (!list_empty(_q)) {					\
+		(*((struct list_head **) (_qe))) = bfa_q_next(_q);	\
+		bfa_q_prev(bfa_q_next(*((struct list_head **) _qe))) =	\
+						(struct list_head *) (_q); \
+		bfa_q_next(_q) = bfa_q_next(*((struct list_head **) _qe)); \
+		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		\
+	} else {							\
+		*((struct list_head **) (_qe)) = (struct list_head *) NULL; \
+	}								\
+}
+
+/*
+ * bfa_q_deq_tail - dequeue an element from tail of the queue
+ */
+#define bfa_q_deq_tail(_q, _qe) {					    \
+	if (!list_empty(_q)) {					            \
+		*((struct list_head **) (_qe)) = bfa_q_prev(_q);	    \
+		bfa_q_next(bfa_q_prev(*((struct list_head **) _qe))) = 	    \
+						(struct list_head *) (_q);  \
+		bfa_q_prev(_q) = bfa_q_prev(*(struct list_head **) _qe);    \
+		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		    \
+	} else {							    \
+		*((struct list_head **) (_qe)) = (struct list_head *) NULL; \
+	}								    \
+}
+
+/*
+ * #ifdef BFA_DEBUG (Using bfa_assert to check for debug_build is not
+ * consistent across modules)
+ */
+#ifndef BFA_PERF_BUILD
+#define BFA_Q_DBG_INIT(_qe)	bfa_q_qe_init(_qe)
+#else
+#define BFA_Q_DBG_INIT(_qe)
+#endif
+
+#define bfa_q_is_on_q(_q, _qe)		\
+	bfa_q_is_on_q_func(_q, (struct list_head *)(_qe))
+extern int bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe);
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_sm.h patch/drivers/scsi/bfa/include/cs/bfa_sm.h
--- orig/drivers/scsi/bfa/include/cs/bfa_sm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_sm.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfasm.h State machine defines
+ */
+
+#ifndef __BFA_SM_H__
+#define __BFA_SM_H__
+
+typedef void (*bfa_sm_t)(void *sm, int event);
+
+#define bfa_sm_set_state(_sm, _state)	(_sm)->sm = (bfa_sm_t)(_state)
+#define bfa_sm_send_event(_sm, _event)	(_sm)->sm((_sm), (_event))
+#define bfa_sm_get_state(_sm)		((_sm)->sm)
+#define bfa_sm_cmp_state(_sm, _state)	((_sm)->sm == (bfa_sm_t)(_state))
+
+/**
+ * For converting from state machine function to state encoding.
+ */
+struct bfa_sm_table_s {
+	bfa_sm_t	sm;	/*  state machine function	*/
+	int		state;	/*  state machine encoding	*/
+	char		*name;	/*  state name for display	*/
+};
+#define BFA_SM(_sm)	((bfa_sm_t)(_sm))
+
+int bfa_sm_to_state(struct bfa_sm_table_s *smt, bfa_sm_t sm);
+
+/**
+ * State machine with entry actions.
+ */
+typedef void (*bfa_fsm_t)(void *fsm, int event);
+
+/**
+ * oc - object class eg. bfa_ioc
+ * st - state, eg. reset
+ * otype - object type, eg. struct bfa_ioc_s
+ * etype - object type, eg. enum ioc_event
+ */
+#define bfa_fsm_state_decl(oc, st, otype, etype)		\
+	static void oc ## _sm_ ## st(otype * fsm, etype event);      \
+	static void oc ## _sm_ ## st ## _entry(otype * fsm)
+
+#define bfa_fsm_set_state(_fsm, _state) do {	\
+	(_fsm)->fsm = (bfa_fsm_t)(_state);      \
+	_state ## _entry(_fsm);      \
+} while (0)
+
+#define bfa_fsm_send_event(_fsm, _event)	\
+	(_fsm)->fsm((_fsm), (_event))
+#define bfa_fsm_cmp_state(_fsm, _state)		\
+	((_fsm)->fsm == (bfa_fsm_t)(_state))
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_trc.h patch/drivers/scsi/bfa/include/cs/bfa_trc.h
--- orig/drivers/scsi/bfa/include/cs/bfa_trc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_trc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,176 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_TRC_H__
+#define __BFA_TRC_H__
+
+#include <bfa_os_inc.h>
+
+#ifndef BFA_TRC_MAX
+#define BFA_TRC_MAX	(4 * 1024)
+#endif
+
+#ifndef BFA_TRC_TS
+#define BFA_TRC_TS(_trcm)	((_trcm)->ticks ++)
+#endif
+
+struct bfa_trc_s {
+#ifdef __BIGENDIAN
+	u16	fileno;
+	u16	line;
+#else
+	u16	line;
+	u16	fileno;
+#endif
+	u32	timestamp;
+	union {
+		struct {
+			u32	rsvd;
+			u32	u32;
+		} u32;
+		u64	u64;
+	} data;
+};
+
+
+struct bfa_trc_mod_s {
+	u32	head;
+	u32	tail;
+	u32	ntrc;
+	u32	stopped;
+	u32	ticks;
+	u32	rsvd[3];
+	struct bfa_trc_s trc[BFA_TRC_MAX];
+};
+
+
+enum {
+	BFA_TRC_FW   = 1,	/*  firmware modules */
+	BFA_TRC_HAL  = 2,	/*  BFA modules */
+	BFA_TRC_FCS  = 3,	/*  BFA FCS modules */
+	BFA_TRC_LDRV = 4,	/*  Linux driver modules */
+	BFA_TRC_SDRV = 5,	/*  Solaris driver modules */
+	BFA_TRC_VDRV = 6,	/*  vmware driver modules */
+	BFA_TRC_WDRV = 7,	/*  windows driver modules */
+	BFA_TRC_AEN  = 8,	/*  AEN module */
+	BFA_TRC_BIOS = 9,	/*  bios driver modules */
+	BFA_TRC_EFI  = 10,	/*  EFI driver modules */
+	BNA_TRC_WDRV = 11,	/*  BNA windows driver modules */
+	BNA_TRC_VDRV = 12,	/*  BNA vmware driver modules */
+	BNA_TRC_SDRV = 13,	/*  BNA Solaris driver modules */
+	BNA_TRC_LDRV = 14,	/*  BNA Linux driver modules */
+	BNA_TRC_HAL  = 15,	/*  BNA modules */
+	BFA_TRC_CNA  = 16,	/*  Common modules */
+	BNA_TRC_IMDRV = 17	/*  BNA windows intermediate driver modules */
+};
+#define BFA_TRC_MOD_SH	10
+#define BFA_TRC_MOD(__mod)	((BFA_TRC_ ## __mod) << BFA_TRC_MOD_SH)
+
+/**
+ * Define a new tracing file (module). Module should match one defined above.
+ */
+#define BFA_TRC_FILE(__mod, __submod)					\
+	static int __trc_fileno = ((BFA_TRC_ ## __mod ## _ ## __submod) | \
+						 BFA_TRC_MOD(__mod))
+
+
+#define bfa_trc32(_trcp, _data)	\
+	__bfa_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u32)_data)
+
+
+#ifndef BFA_BOOT_BUILD
+#define bfa_trc(_trcp, _data)	\
+	__bfa_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u64)_data)
+#else
+void bfa_boot_trc(struct bfa_trc_mod_s *trcmod, u16 fileno,
+			u16 line, u32 data);
+#define bfa_trc(_trcp, _data)	\
+	bfa_boot_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u32)_data)
+#endif
+
+
+static inline void
+bfa_trc_init(struct bfa_trc_mod_s *trcm)
+{
+	trcm->head = trcm->tail = trcm->stopped = 0;
+	trcm->ntrc = BFA_TRC_MAX;
+}
+
+
+static inline void
+bfa_trc_stop(struct bfa_trc_mod_s *trcm)
+{
+	trcm->stopped = 1;
+}
+
+#ifdef FWTRC
+extern void dc_flush(void *data);
+#else
+#define dc_flush(data)
+#endif
+
+
+static inline void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s 	*trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u64 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+	dc_flush(trc);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+	dc_flush(trcm);
+}
+
+
+static inline void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s *trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u32.u32 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+	dc_flush(trc);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+	dc_flush(trcm);
+}
+
+#ifndef BFA_PERF_BUILD
+#define bfa_trc_fp(_trcp, _data)	bfa_trc(_trcp, _data)
+#else
+#define bfa_trc_fp(_trcp, _data)
+#endif
+
+#endif /* __BFA_TRC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/cs/bfa_wc.h patch/drivers/scsi/bfa/include/cs/bfa_wc.h
--- orig/drivers/scsi/bfa/include/cs/bfa_wc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/cs/bfa_wc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,68 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_wc.h Generic wait counter.
+ */
+
+#ifndef __BFA_WC_H__
+#define __BFA_WC_H__
+
+typedef void (*bfa_wc_resume_t) (void *cbarg);
+
+struct bfa_wc_s {
+	bfa_wc_resume_t wc_resume;
+	void		*wc_cbarg;
+	int		wc_count;
+};
+
+static inline void
+bfa_wc_up(struct bfa_wc_s *wc)
+{
+	wc->wc_count++;
+}
+
+static inline void
+bfa_wc_down(struct bfa_wc_s *wc)
+{
+	wc->wc_count--;
+	if (wc->wc_count == 0)
+		wc->wc_resume(wc->wc_cbarg);
+}
+
+/**
+ * Initialize a waiting counter.
+ */
+static inline void
+bfa_wc_init(struct bfa_wc_s *wc, bfa_wc_resume_t wc_resume, void *wc_cbarg)
+{
+	wc->wc_resume = wc_resume;
+	wc->wc_cbarg = wc_cbarg;
+	wc->wc_count = 0;
+	bfa_wc_up(wc);
+}
+
+/**
+ * Wait for counter to reach zero
+ */
+static inline void
+bfa_wc_wait(struct bfa_wc_s *wc)
+{
+	bfa_wc_down(wc);
+}
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h patch/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_ADAPTER_H__
+#define __BFA_DEFS_ADAPTER_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_version.h>
+#include <defs/bfa_defs_mfg.h>
+
+/**
+ * BFA adapter level attributes.
+ */
+enum {
+	BFA_ADAPTER_SERIAL_NUM_LEN = STRSZ(BFA_MFG_SERIALNUM_SIZE),
+					/*
+					 *!< adapter serial num length
+					 */
+	BFA_ADAPTER_MODEL_NAME_LEN  = 16,  /*  model name length */
+	BFA_ADAPTER_MODEL_DESCR_LEN = 128, /*  model description length */
+	BFA_ADAPTER_MFG_NAME_LEN    = 8,   /*  manufacturer name length */
+	BFA_ADAPTER_SYM_NAME_LEN    = 64,  /*  adapter symbolic name length */
+	BFA_ADAPTER_OS_TYPE_LEN	    = 64,  /*  adapter os type length */
+};
+
+struct bfa_adapter_attr_s {
+	char            manufacturer[BFA_ADAPTER_MFG_NAME_LEN];
+	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
+	u32	rsvd1;
+	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
+	char            model_descr[BFA_ADAPTER_MODEL_DESCR_LEN];
+	wwn_t           pwwn;
+	char            node_symname[FC_SYMNAME_MAX];
+	char            hw_ver[BFA_VERSION_LEN];
+	char            fw_ver[BFA_VERSION_LEN];
+	char            optrom_ver[BFA_VERSION_LEN];
+	char            os_type[BFA_ADAPTER_OS_TYPE_LEN];
+	struct bfa_mfg_vpd_s	vpd;
+	struct mac_s	mac;
+
+	u8		nports;
+	u8		max_speed;
+	u8		prototype;
+	char	        asic_rev;
+
+	u8         pcie_gen;
+	u8         pcie_lanes_orig;
+	u8         pcie_lanes;
+	u8	        cna_capable;
+};
+
+/**
+ * BFA adapter level events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_PORT_AEN_ADD:        [in]: None     [out]: serial_num, pwwn, nports
+ * BFA_PORT_AEN_REMOVE:     [in]: pwwn     [out]: serial_num, pwwn, nports
+ */
+enum bfa_adapter_aen_event {
+	BFA_ADAPTER_AEN_ADD 	= 1,	/*  New Adapter found event */
+	BFA_ADAPTER_AEN_REMOVE 	= 2,	/*  Adapter removed event */
+};
+
+struct bfa_adapter_aen_data_s {
+	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
+	u32        nports;	/*  Number of NPorts */
+	wwn_t           pwwn;	/*  WWN of one of its physical port */
+};
+
+#endif /* __BFA_DEFS_ADAPTER_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_aen.h patch/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_aen.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_aen.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_AEN_H__
+#define __BFA_DEFS_AEN_H__
+
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_ioc.h>
+#include <defs/bfa_defs_adapter.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_lport.h>
+#include <defs/bfa_defs_rport.h>
+#include <defs/bfa_defs_itnim.h>
+#include <defs/bfa_defs_tin.h>
+#include <defs/bfa_defs_ipfc.h>
+#include <defs/bfa_defs_audit.h>
+#include <defs/bfa_defs_ethport.h>
+
+enum bfa_aen_category {
+	BFA_AEN_CAT_ADAPTER 	= 1,
+	BFA_AEN_CAT_PORT 	= 2,
+	BFA_AEN_CAT_LPORT 	= 3,
+	BFA_AEN_CAT_RPORT 	= 4,
+	BFA_AEN_CAT_ITNIM 	= 5,
+	BFA_AEN_CAT_TIN 	= 6,
+	BFA_AEN_CAT_IPFC 	= 7,
+	BFA_AEN_CAT_AUDIT 	= 8,
+	BFA_AEN_CAT_IOC 	= 9,
+	BFA_AEN_CAT_ETHPORT	= 10,
+	BFA_AEN_MAX_CAT 	= 10
+};
+
+#pragma pack(1)
+union bfa_aen_data_u {
+	struct bfa_adapter_aen_data_s 	adapter;
+	struct bfa_port_aen_data_s 	port;
+	struct bfa_lport_aen_data_s 	lport;
+	struct bfa_rport_aen_data_s 	rport;
+	struct bfa_itnim_aen_data_s 	itnim;
+	struct bfa_audit_aen_data_s 	audit;
+	struct bfa_ioc_aen_data_s 	ioc;
+	struct bfa_ethport_aen_data_s 	ethport;
+};
+
+struct bfa_aen_entry_s {
+	enum bfa_aen_category 	aen_category;
+	int			aen_type;
+	union bfa_aen_data_u  	aen_data;
+	struct bfa_timeval_s   	aen_tv;
+	s32         	seq_num;
+	s32         	bfad_num;
+	s32         	rsvd[1];
+};
+
+#pragma pack()
+
+#define bfa_aen_event_t int
+
+#endif /* __BFA_DEFS_AEN_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_audit.h patch/drivers/scsi/bfa/include/defs/bfa_defs_audit.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_audit.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_audit.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_AUDIT_H__
+#define __BFA_DEFS_AUDIT_H__
+
+#include <bfa_os_inc.h>
+
+/**
+ * BFA audit events
+ */
+enum bfa_audit_aen_event {
+	BFA_AUDIT_AEN_AUTH_ENABLE 	= 1,
+	BFA_AUDIT_AEN_AUTH_DISABLE 	= 2,
+};
+
+/**
+ * audit event data
+ */
+struct bfa_audit_aen_data_s {
+	wwn_t           pwwn;
+};
+
+#endif /* __BFA_DEFS_AUDIT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_auth.h patch/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_auth.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_auth.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_AUTH_H__
+#define __BFA_DEFS_AUTH_H__
+
+#include <defs/bfa_defs_types.h>
+
+#define PUBLIC_KEY			15409
+#define PRIVATE_KEY			19009
+#define KEY_LEN				32399
+#define BFA_AUTH_SECRET_STRING_LEN	256
+#define BFA_AUTH_FAIL_TIMEOUT		0xFF
+
+/**
+ * Authentication status
+ */
+enum bfa_auth_status {
+	BFA_AUTH_STATUS_NONE 	= 0,	/*  no authentication */
+	BFA_AUTH_UNINIT 	= 1,	/*  state - uninit */
+	BFA_AUTH_NEG_SEND 	= 2,	/*  state - negotiate send */
+	BFA_AUTH_CHAL_WAIT 	= 3,	/*  state - challenge wait */
+	BFA_AUTH_NEG_RETRY 	= 4,	/*  state - negotiate retry */
+	BFA_AUTH_REPLY_SEND 	= 5,	/*  state - reply send */
+	BFA_AUTH_STATUS_WAIT 	= 6,	/*  state - status wait */
+	BFA_AUTH_SUCCESS 	= 7,	/*  state - success */
+	BFA_AUTH_FAILED 	= 8,	/*  state - failed */
+	BFA_AUTH_STATUS_UNKNOWN = 9,	/*  authentication status unknown */
+};
+
+struct auth_proto_stats_s {
+	u32        auth_rjts;
+	u32        auth_negs;
+	u32        auth_dones;
+
+	u32        dhchap_challenges;
+	u32        dhchap_replies;
+	u32        dhchap_successes;
+};
+
+/**
+ * Authentication related statistics
+ */
+struct bfa_auth_stats_s {
+	u32           auth_failures;	/*  authentication failures */
+	u32           auth_successes;	/*  authentication successes*/
+	struct auth_proto_stats_s auth_rx_stats; /*  Rx protocol stats */
+	struct auth_proto_stats_s auth_tx_stats; /*  Tx protocol stats */
+};
+
+/**
+ * Authentication hash function algorithms
+ */
+enum bfa_auth_algo {
+	BFA_AUTH_ALGO_MD5 	= 1,	/*  Message-Digest algorithm 5 */
+	BFA_AUTH_ALGO_SHA1 	= 2,	/*  Secure Hash Algorithm 1 */
+	BFA_AUTH_ALGO_MS 	= 3,	/*  MD5, then SHA-1 */
+	BFA_AUTH_ALGO_SM 	= 4,	/*  SHA-1, then MD5 */
+};
+
+/**
+ * DH Groups
+ *
+ * Current value could be combination of one or more of the following values
+ */
+enum bfa_auth_group {
+	BFA_AUTH_GROUP_DHNULL 	= 0,	/*  DH NULL (value == 0) */
+	BFA_AUTH_GROUP_DH768 	= 1,	/*  DH group 768 (value == 1) */
+	BFA_AUTH_GROUP_DH1024 	= 2,	/*  DH group 1024 (value == 2) */
+	BFA_AUTH_GROUP_DH1280 	= 4,	/*  DH group 1280 (value == 3) */
+	BFA_AUTH_GROUP_DH1536 	= 8,	/*  DH group 1536 (value == 4) */
+
+	BFA_AUTH_GROUP_ALL 	= 256	/*  Use default DH group order
+					 *    0, 1, 2, 3, 4 */
+};
+
+/**
+ * Authentication secret sources
+ */
+enum bfa_auth_secretsource {
+	BFA_AUTH_SECSRC_LOCAL 	= 1,	/*  locally configured */
+	BFA_AUTH_SECSRC_RADIUS 	= 2,	/*  use radius server */
+	BFA_AUTH_SECSRC_TACACS 	= 3,	/*  TACACS server */
+};
+
+/**
+ * Authentication attributes
+ */
+struct bfa_auth_attr_s {
+	enum bfa_auth_status 	status;
+	enum bfa_auth_algo 	algo;
+	enum bfa_auth_group 	dh_grp;
+	u16		rjt_code;
+	u16		rjt_code_exp;
+	u8			secret_set;
+	u8			resv[7];
+};
+
+#endif /* __BFA_DEFS_AUTH_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_boot.h patch/drivers/scsi/bfa/include/defs/bfa_defs_boot.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_boot.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_boot.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_BOOT_H__
+#define __BFA_DEFS_BOOT_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_pport.h>
+
+enum {
+	BFA_BOOT_BOOTLUN_MAX = 4,	/*  maximum boot lun per IOC */
+};
+
+#define BOOT_CFG_REV1	1
+
+/**
+ *      Boot options setting. Boot options setting determines from where
+ *      to get the boot lun information
+ */
+enum bfa_boot_bootopt {
+    BFA_BOOT_AUTO_DISCOVER = 0,    /*  Boot from blun provided by fabric */
+    BFA_BOOT_STORED_BLUN   = 1,    /*  Boot from bluns stored in flash   */
+    BFA_BOOT_FIRST_LUN     = 2,    /*  Boot from first discovered blun   */
+};
+
+/**
+ * Boot lun information.
+ */
+struct bfa_boot_bootlun_s {
+	wwn_t           pwwn;	/*  port wwn of target */
+	lun_t           lun;	/*  64-bit lun */
+};
+
+/**
+ * BOOT boot configuraton
+ */
+struct bfa_boot_cfg_s {
+	u8         version;
+	u8         rsvd1;
+	u16        chksum;
+
+	u8         enable;		/*  enable/disable SAN boot */
+	u8         speed;		/*  boot speed settings */
+	u8         topology;	/*  boot topology setting */
+	u8         bootopt;	/*  bfa_boot_bootopt_t */
+
+	u32        nbluns;		/*  number of boot luns */
+
+	u32        rsvd2;
+
+	struct bfa_boot_bootlun_s blun[BFA_BOOT_BOOTLUN_MAX];
+	struct bfa_boot_bootlun_s blun_disc[BFA_BOOT_BOOTLUN_MAX];
+};
+
+
+#endif /* __BFA_DEFS_BOOT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_cee.h patch/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_cee.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_cee.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ *  bfa_defs_cee.h Interface declarations between host based
+ *	BFAL and DCBX/LLDP module in Firmware
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_CEE_H__
+#define __BFA_DEFS_CEE_H__
+
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_pport.h>
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+#define BFA_CEE_LLDP_MAX_STRING_LEN (128)
+
+
+/* FIXME: this is coming from the protocol spec. Can the host & apps share the
+   protocol .h files ?
+ */
+#define BFA_CEE_LLDP_SYS_CAP_OTHER       0x0001
+#define BFA_CEE_LLDP_SYS_CAP_REPEATER    0x0002
+#define BFA_CEE_LLDP_SYS_CAP_MAC_BRIDGE  0x0004
+#define BFA_CEE_LLDP_SYS_CAP_WLAN_AP     0x0008
+#define BFA_CEE_LLDP_SYS_CAP_ROUTER      0x0010
+#define BFA_CEE_LLDP_SYS_CAP_TELEPHONE 	 0x0020
+#define BFA_CEE_LLDP_SYS_CAP_DOCSIS_CD   0x0040
+#define BFA_CEE_LLDP_SYS_CAP_STATION     0x0080
+#define BFA_CEE_LLDP_SYS_CAP_CVLAN	     0x0100
+#define BFA_CEE_LLDP_SYS_CAP_SVLAN 	     0x0200
+#define BFA_CEE_LLDP_SYS_CAP_TPMR		 0x0400
+
+
+/* LLDP string type */
+struct bfa_cee_lldp_str_s {
+	u8 sub_type;
+	u8 len;
+	u8 rsvd[2];
+	u8 value[BFA_CEE_LLDP_MAX_STRING_LEN];
+};
+
+
+/* LLDP paramters */
+struct bfa_cee_lldp_cfg_s {
+	struct bfa_cee_lldp_str_s chassis_id;
+	struct bfa_cee_lldp_str_s port_id;
+	struct bfa_cee_lldp_str_s port_desc;
+	struct bfa_cee_lldp_str_s sys_name;
+	struct bfa_cee_lldp_str_s sys_desc;
+	struct bfa_cee_lldp_str_s mgmt_addr;
+	u16    time_to_interval;
+	u16    enabled_system_cap;
+};
+
+enum bfa_cee_dcbx_version_e {
+	DCBX_PROTOCOL_PRECEE = 1,
+	DCBX_PROTOCOL_CEE    = 2,
+};
+
+enum bfa_cee_lls_e {
+	CEE_LLS_DOWN_NO_TLV = 0, /* LLS is down because the TLV not sent by
+				  * the peer */
+	CEE_LLS_DOWN        = 1, /* LLS is down as advertised by the peer */
+	CEE_LLS_UP          = 2,
+};
+
+/* CEE/DCBX parameters */
+struct bfa_cee_dcbx_cfg_s {
+	u8 pgid[8];
+	u8 pg_percentage[8];
+	u8 pfc_enabled;          /* bitmap of priorties with PFC enabled */
+	u8 fcoe_user_priority;   /* bitmap of priorities used for FcoE
+				       * traffic */
+	u8 dcbx_version;	/* operating version:CEE or preCEE */
+	u8 lls_fcoe;	/* FCoE Logical Link Status */
+	u8 lls_lan;	/* LAN Logical Link Status */
+	u8 rsvd[3];
+};
+
+/* CEE status */
+/* Making this to tri-state for the benefit of port list command */
+enum bfa_cee_status_e {
+    CEE_PHY_DOWN = 0,
+    CEE_PHY_UP = 1,
+    CEE_UP = 2,
+};
+
+/* CEE Query */
+struct bfa_cee_attr_s {
+	u8                   cee_status;
+	u8                   error_reason;
+	struct bfa_cee_lldp_cfg_s lldp_remote;
+	struct bfa_cee_dcbx_cfg_s dcbx_remote;
+	mac_t src_mac;
+	u8 link_speed;
+	u8 filler[3];
+};
+
+
+
+
+/* LLDP/DCBX/CEE Statistics */
+
+struct bfa_cee_lldp_stats_s {
+	u32 frames_transmitted;
+	u32 frames_aged_out;
+	u32 frames_discarded;
+	u32 frames_in_error;
+	u32 frames_rcvd;
+	u32 tlvs_discarded;
+	u32 tlvs_unrecognized;
+};
+
+struct bfa_cee_dcbx_stats_s {
+	u32 subtlvs_unrecognized;
+	u32 negotiation_failed;
+	u32 remote_cfg_changed;
+	u32 tlvs_received;
+	u32 tlvs_invalid;
+	u32 seqno;
+	u32 ackno;
+	u32 recvd_seqno;
+	u32 recvd_ackno;
+};
+
+struct bfa_cee_cfg_stats_s {
+	u32 cee_status_down;
+	u32 cee_status_up;
+	u32 cee_hw_cfg_changed;
+	u32 recvd_invalid_cfg;
+};
+
+
+struct bfa_cee_stats_s {
+	struct bfa_cee_lldp_stats_s lldp_stats;
+	struct bfa_cee_dcbx_stats_s dcbx_stats;
+	struct bfa_cee_cfg_stats_s  cfg_stats;
+};
+
+#pragma pack()
+
+
+#endif	/* __BFA_DEFS_CEE_H__ */
+
+
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_driver.h patch/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_driver.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_driver.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_DRIVER_H__
+#define __BFA_DEFS_DRIVER_H__
+
+/**
+ * Driver statistics
+ */
+	u16    tm_io_abort;
+    u16    tm_io_abort_comp;
+    u16    tm_lun_reset;
+    u16    tm_lun_reset_comp;
+    u16    tm_target_reset;
+    u16    tm_bus_reset;
+    u16    ioc_restart;        /*  IOC restart count */
+    u16    io_pending;         /*  outstanding io count per-IOC */
+    u64    control_req;
+    u64    input_req;
+    u64    output_req;
+    u64    input_words;
+    u64    output_words;
+} bfa_driver_stats_t;
+
+
+#endif /* __BFA_DEFS_DRIVER_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,98 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_ETHPORT_H__
+#define __BFA_DEFS_ETHPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <protocol/types.h>
+#include <cna/pstats/phyport_defs.h>
+#include <cna/pstats/ethport_defs.h>
+
+struct bna_tx_info_s {
+	u32    miniport_state;
+	u32    adapter_state;
+	u64    tx_count;
+	u64    tx_wi;
+	u64    tx_sg;
+	u64    tx_tcp_chksum;
+	u64    tx_udp_chksum;
+	u64    tx_ip_chksum;
+	u64    tx_lsov1;
+	u64    tx_lsov2;
+	u64    tx_max_sg_len ;
+};
+
+struct bna_rx_queue_info_s {
+	u16    q_id ;
+	u16    buf_size ;
+	u16    buf_count ;
+	u16    rsvd ;
+	u64    rx_count ;
+	u64    rx_dropped ;
+	u64    rx_unsupported ;
+	u64    rx_internal_err ;
+	u64    rss_count ;
+	u64    vlan_count ;
+	u64    rx_tcp_chksum ;
+	u64    rx_udp_chksum ;
+	u64    rx_ip_chksum ;
+	u64    rx_hds ;
+};
+
+struct bna_rx_q_set_s {
+	u16    q_set_type;
+	u32    miniport_state;
+	u32    adapter_state;
+	struct bna_rx_queue_info_s    rx_queue[2];
+};
+
+struct bna_port_stats_s {
+	struct bna_tx_info_s   tx_stats;
+	u16        qset_count ;
+	struct bna_rx_q_set_s  rx_qset[8];
+};
+
+struct bfa_ethport_stats_s {
+	struct bna_stats_txf	txf_stats[1];
+	struct bna_stats_rxf	rxf_stats[1];
+	struct bnad_drv_stats drv_stats;
+};
+
+/**
+ * Ethernet port events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_PORT_AEN_ETH_LINKUP:    [in]: mac [out]: mac
+ * BFA_PORT_AEN_ETH_LINKDOWN:  [in]: mac [out]: mac
+ * BFA_PORT_AEN_ETH_ENABLE:  [in]: mac [out]: mac
+ * BFA_PORT_AEN_ETH_DISABLE:  [in]: mac [out]: mac
+ *
+ */
+enum bfa_ethport_aen_event {
+	BFA_ETHPORT_AEN_LINKUP = 1, /*  Base Port Ethernet link up event */
+	BFA_ETHPORT_AEN_LINKDOWN = 2, /*  Base Port Ethernet link down event */
+	BFA_ETHPORT_AEN_ENABLE = 3, /*  Base Port Ethernet link enable event */
+	BFA_ETHPORT_AEN_DISABLE = 4, /*  Base Port Ethernet link disable
+				      * event */
+};
+
+struct bfa_ethport_aen_data_s {
+	mac_t mac;	/*  MAC address of the physical port */
+};
+
+
+#endif /* __BFA_DEFS_ETHPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h patch/drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_FCPIM_H__
+#define __BFA_DEFS_FCPIM_H__
+
+struct bfa_fcpim_stats_s {
+	u32        total_ios;	/*  Total IO count */
+	u32        qresumes;	/*  IO waiting for CQ space */
+	u32        no_iotags;	/*  NO IO contexts */
+	u32        io_aborts;	/*  IO abort requests */
+	u32        no_tskims;	/*  NO task management contexts */
+	u32        iocomp_ok;	/*  IO completions with OK status */
+	u32        iocomp_underrun;	/*  IO underrun (good) */
+	u32        iocomp_overrun;	/*  IO overrun (good) */
+	u32        iocomp_aborted;	/*  Aborted IO requests */
+	u32        iocomp_timedout;	/*  IO timeouts */
+	u32        iocom_nexus_abort;	/*  IO selection timeouts */
+	u32        iocom_proto_err;	/*  IO protocol errors */
+	u32        iocom_dif_err;	/*  IO SBC-3 protection errors */
+	u32        iocom_tm_abort;	/*  IO aborted by TM requests */
+	u32        iocom_sqer_needed;	/*  IO retry for SQ error
+						 *recovery */
+	u32        iocom_res_free;	/*  Delayed freeing of IO resources */
+	u32        iocomp_scsierr;	/*  IO with non-good SCSI status */
+	u32        iocom_hostabrts;	/*  Host IO abort requests */
+	u32        iocom_utags;	/*  IO comp with unknown tags */
+	u32        io_cleanups;	/*  IO implicitly aborted */
+	u32        io_tmaborts;	/*  IO aborted due to TM commands */
+	u32        rsvd;
+};
+#endif /*__BFA_DEFS_FCPIM_H__*/
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h patch/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_IM_COMMON_H__
+#define __BFA_DEFS_IM_COMMON_H__
+
+#define	BFA_ADAPTER_NAME_LEN	256
+#define BFA_ADAPTER_GUID_LEN    256
+#define RESERVED_VLAN_NAME      L"PORT VLAN"
+#define PASSTHRU_VLAN_NAME      L"PASSTHRU VLAN"
+
+	u64	tx_pkt_cnt;
+	u64	rx_pkt_cnt;
+	u32	duration;
+	u8		status;
+} bfa_im_stats_t, *pbfa_im_stats_t;
+
+#endif /* __BFA_DEFS_IM_COMMON_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h patch/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_IM_TEAM_H__
+#define __BFA_DEFS_IM_TEAM_H__
+
+#include <protocol/types.h>
+
+#define	BFA_TEAM_MAX_PORTS	8
+#define	BFA_TEAM_NAME_LEN	256
+#define BFA_MAX_NUM_TEAMS	16
+#define BFA_TEAM_INVALID_DELAY -1
+
+	BFA_LACP_RATE_SLOW = 1,
+	BFA_LACP_RATE_FAST
+} bfa_im_lacp_rate_t;
+
+	BFA_TEAM_MODE_FAIL_OVER = 1,
+	BFA_TEAM_MODE_FAIL_BACK,
+	BFA_TEAM_MODE_LACP,
+	BFA_TEAM_MODE_NONE
+} bfa_im_team_mode_t;
+
+	BFA_XMIT_POLICY_L2 = 1,
+	BFA_XMIT_POLICY_L3_L4
+} bfa_im_xmit_policy_t;
+
+	bfa_im_team_mode_t     team_mode;
+	bfa_im_lacp_rate_t     lacp_rate;
+	bfa_im_xmit_policy_t   xmit_policy;
+	int   	          delay;
+	wchar_t    	  primary[BFA_ADAPTER_NAME_LEN];
+	wchar_t        	  preferred_primary[BFA_ADAPTER_NAME_LEN];
+	mac_t	          mac;
+	u16       	  num_ports;
+	u16          num_vlans;
+	u16 vlan_list[BFA_MAX_VLANS_PER_PORT];
+	wchar_t	 team_guid_list[BFA_TEAM_MAX_PORTS][BFA_ADAPTER_GUID_LEN];
+	wchar_t	 ioc_name_list[BFA_TEAM_MAX_PORTS][BFA_ADAPTER_NAME_LEN];
+} bfa_im_team_attr_t;
+
+	wchar_t		             team_name[BFA_TEAM_NAME_LEN];
+	bfa_im_xmit_policy_t	 xmit_policy;
+	int                 	 delay;
+	wchar_t                	 primary[BFA_ADAPTER_NAME_LEN];
+	wchar_t               	 preferred_primary[BFA_ADAPTER_NAME_LEN];
+} bfa_im_team_edit_t, *pbfa_im_team_edit_t;
+
+	wchar_t					team_name[BFA_TEAM_NAME_LEN];
+	bfa_im_team_mode_t      team_mode;
+	mac_t	               	mac;
+} bfa_im_team_info_t;
+
+	bfa_im_team_info_t 		team_info[BFA_MAX_NUM_TEAMS];
+	u16 				num_teams;
+} bfa_im_team_list_t, *pbfa_im_team_list_t;
+
+#endif /* __BFA_DEFS_IM_TEAM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h patch/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,152 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_IOC_H__
+#define __BFA_DEFS_IOC_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_version.h>
+#include <defs/bfa_defs_adapter.h>
+#include <defs/bfa_defs_pm.h>
+
+enum {
+	BFA_IOC_DRIVER_LEN	= 16,
+	BFA_IOC_CHIP_REV_LEN 	= 8,
+};
+
+/**
+ * Driver and firmware versions.
+ */
+struct bfa_ioc_driver_attr_s {
+	char            driver[BFA_IOC_DRIVER_LEN];	/*  driver name */
+	char            driver_ver[BFA_VERSION_LEN];	/*  driver version */
+	char            fw_ver[BFA_VERSION_LEN];	/*  firmware version*/
+	char            bios_ver[BFA_VERSION_LEN];	/*  bios version */
+	char            efi_ver[BFA_VERSION_LEN];	/*  EFI version */
+	char            ob_ver[BFA_VERSION_LEN];	/*  openboot version*/
+};
+
+/**
+ * IOC PCI device attributes
+ */
+struct bfa_ioc_pci_attr_s {
+	u16        vendor_id;	/*  PCI vendor ID */
+	u16        device_id;	/*  PCI device ID */
+	u16        ssid;		/*  subsystem ID */
+	u16        ssvid;		/*  subsystem vendor ID */
+	u32        pcifn;		/*  PCI device function */
+	u32        rsvd;		/* padding */
+	u8         chip_rev[BFA_IOC_CHIP_REV_LEN];	 /*  chip revision */
+};
+
+/**
+ * IOC states
+ */
+enum bfa_ioc_state {
+	BFA_IOC_RESET       = 1,  /*  IOC is in reset state */
+	BFA_IOC_SEMWAIT     = 2,  /*  Waiting for IOC hardware semaphore */
+	BFA_IOC_HWINIT 	    = 3,  /*  IOC hardware is being initialized */
+	BFA_IOC_GETATTR     = 4,  /*  IOC is being configured */
+	BFA_IOC_OPERATIONAL = 5,  /*  IOC is operational */
+	BFA_IOC_INITFAIL    = 6,  /*  IOC hardware failure */
+	BFA_IOC_HBFAIL      = 7,  /*  IOC heart-beat failure */
+	BFA_IOC_DISABLING   = 8,  /*  IOC is being disabled */
+	BFA_IOC_DISABLED    = 9,  /*  IOC is disabled */
+	BFA_IOC_FWMISMATCH  = 10, /*  IOC firmware different from drivers */
+};
+
+/**
+ * IOC firmware stats
+ */
+struct bfa_fw_ioc_stats_s {
+	u32        hb_count;
+	u32        cfg_reqs;
+	u32        enable_reqs;
+	u32        disable_reqs;
+	u32        stats_reqs;
+	u32        clrstats_reqs;
+	u32        unknown_reqs;
+	u32        ic_reqs;		/*  interrupt coalesce reqs */
+};
+
+/**
+ * IOC driver stats
+ */
+struct bfa_ioc_drv_stats_s {
+	u32	ioc_isrs;
+	u32	ioc_enables;
+	u32	ioc_disables;
+	u32	ioc_hbfails;
+	u32	ioc_boots;
+	u32	stats_tmos;
+	u32        hb_count;
+	u32        disable_reqs;
+	u32        enable_reqs;
+	u32        disable_replies;
+	u32        enable_replies;
+};
+
+/**
+ * IOC statistics
+ */
+struct bfa_ioc_stats_s {
+	struct bfa_ioc_drv_stats_s	drv_stats; /*  driver IOC stats */
+	struct bfa_fw_ioc_stats_s 	fw_stats;  /*  firmware IOC stats */
+};
+
+
+enum bfa_ioc_type_e {
+	BFA_IOC_TYPE_FC	  = 1,
+	BFA_IOC_TYPE_FCoE = 2,
+	BFA_IOC_TYPE_LL	  = 3,
+};
+
+/**
+ * IOC attributes returned in queries
+ */
+struct bfa_ioc_attr_s {
+	enum bfa_ioc_type_e		ioc_type;
+	enum bfa_ioc_state 		state;		/*  IOC state      */
+	struct bfa_adapter_attr_s	adapter_attr;	/*  HBA attributes */
+	struct bfa_ioc_driver_attr_s 	driver_attr;	/*  driver attr    */
+	struct bfa_ioc_pci_attr_s	pci_attr;
+	u8				port_id;	/*  port number    */
+};
+
+/**
+ * BFA IOC level events
+ */
+enum bfa_ioc_aen_event {
+	BFA_IOC_AEN_HBGOOD	= 1,	/*  Heart Beat restore event	*/
+	BFA_IOC_AEN_HBFAIL	= 2,	/*  Heart Beat failure event	*/
+	BFA_IOC_AEN_ENABLE	= 3,	/*  IOC enabled event		*/
+	BFA_IOC_AEN_DISABLE	= 4,	/*  IOC disabled event		*/
+	BFA_IOC_AEN_FWMISMATCH	= 5,	/*  IOC firmware mismatch	*/
+};
+
+/**
+ * BFA IOC level event data, now just a place holder
+ */
+struct bfa_ioc_aen_data_s {
+	enum bfa_ioc_type_e ioc_type;
+	wwn_t	pwwn;
+	mac_t	mac;
+};
+
+#endif /* __BFA_DEFS_IOC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h patch/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,310 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_IOCFC_H__
+#define __BFA_DEFS_IOCFC_H__
+
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_version.h>
+#include <defs/bfa_defs_adapter.h>
+#include <defs/bfa_defs_pm.h>
+
+#define BFA_IOCFC_INTR_DELAY	1125
+#define BFA_IOCFC_INTR_LATENCY	225
+
+/**
+ * Interrupt coalescing configuration.
+ */
+struct bfa_iocfc_intr_attr_s {
+	bfa_boolean_t	coalesce;	/*  enable/disable coalescing */
+	u16	latency;	/*  latency in microseconds   */
+	u16	delay;		/*  delay in microseconds     */
+};
+
+/**
+ * IOC firmware configuraton
+ */
+struct bfa_iocfc_fwcfg_s {
+	u16        num_fabrics;	/*  number of fabrics		*/
+	u16        num_lports;	/*  number of local lports	*/
+	u16        num_rports;	/*  number of remote ports	*/
+	u16        num_ioim_reqs;	/*  number of IO reqs		*/
+	u16        num_tskim_reqs;	/*  task management requests	*/
+	u16        num_iotm_reqs;	/*  number of TM IO reqs	*/
+	u16        num_tsktm_reqs;	/*  TM task management requests*/
+	u16        num_fcxp_reqs;	/*  unassisted FC exchanges	*/
+	u16        num_uf_bufs;	/*  unsolicited recv buffers	*/
+	u8		num_cqs;
+	u8		rsvd;
+};
+
+struct bfa_iocfc_drvcfg_s {
+	u16        num_reqq_elems;	/*  number of req queue elements */
+	u16        num_rspq_elems;	/*  number of rsp queue elements */
+	u16        num_sgpgs;	/*  number of total SG pages	  */
+	u16        num_sboot_tgts;	/*  number of SAN boot targets	  */
+	u16        num_sboot_luns;	/*  number of SAN boot luns	  */
+	u16	    ioc_recover;	/*  IOC recovery mode		  */
+	u16	    min_cfg;	/*  minimum configuration	  */
+	u16        path_tov;	/*  device path timeout	  */
+	bfa_boolean_t   delay_comp; /*  delay completion of
+							failed inflight IOs */
+	u32		rsvd;
+};
+/**
+ * IOC configuration
+ */
+struct bfa_iocfc_cfg_s {
+	struct bfa_iocfc_fwcfg_s	fwcfg;	/*  firmware side config */
+	struct bfa_iocfc_drvcfg_s	drvcfg;	/*  driver side config	  */
+};
+
+/**
+ * IOC firmware IO stats
+ */
+struct bfa_fw_io_stats_s {
+	u32	host_abort;		/*  IO aborted by host driver*/
+	u32	host_cleanup;		/*  IO clean up by host driver */
+
+	u32	fw_io_timeout;		/*  IOs timedout */
+	u32	fw_frm_parse;		/*  frame parsed by f/w */
+	u32	fw_frm_data;		/*  fcp_data frame parsed by f/w */
+	u32	fw_frm_rsp;		/*  fcp_rsp frame parsed by f/w */
+	u32	fw_frm_xfer_rdy;	/*  xfer_rdy frame parsed by f/w */
+	u32	fw_frm_bls_acc;		/*  BLS ACC  frame parsed by f/w */
+	u32	fw_frm_tgt_abort;	/*  target ABTS parsed by f/w */
+	u32	fw_frm_unknown;		/*  unknown parsed by f/w */
+	u32	fw_data_dma;		/*  f/w DMA'ed the data frame */
+	u32	fw_frm_drop;		/*  f/w drop the frame */
+
+	u32	rec_timeout;		/*  FW rec timed out */
+	u32	error_rec;			/*  FW sending rec on
+							* an error condition*/
+	u32	wait_for_si;		/*  FW wait for SI */
+	u32	rec_rsp_inval;		/*  REC rsp invalid */
+	u32	seqr_io_abort;		/*  target does not know cmd so abort */
+	u32	seqr_io_retry;		/*  SEQR failed so retry IO */
+
+	u32	itn_cisc_upd_rsp;	/*  ITN cisc updated on fcp_rsp */
+	u32	itn_cisc_upd_data;	/*  ITN cisc updated on fcp_data */
+	u32	itn_cisc_upd_xfer_rdy;	/*  ITN cisc updated on fcp_data */
+
+	u32	fcp_data_lost;		/*  fcp data lost */
+
+	u32	ro_set_in_xfer_rdy;	/*  Target set RO in Xfer_rdy frame */
+	u32	xfer_rdy_ooo_err;	/*  Out of order Xfer_rdy received */
+	u32	xfer_rdy_unknown_err;	/*  unknown error in xfer_rdy frame */
+
+	u32	io_abort_timeout;	/*  ABTS timedout  */
+	u32	sler_initiated;		/*  SLER initiated */
+
+	u32	unexp_fcp_rsp;		/*  fcp response in wrong state */
+
+	u32	fcp_rsp_under_run;	/*  fcp rsp IO underrun */
+	u32        fcp_rsp_under_run_wr;   /*  fcp rsp IO underrun for write */
+	u32	fcp_rsp_under_run_err;	/*  fcp rsp IO underrun error */
+	u32        fcp_rsp_resid_inval;    /*  invalid residue */
+	u32	fcp_rsp_over_run;	/*  fcp rsp IO overrun */
+	u32	fcp_rsp_over_run_err;	/*  fcp rsp IO overrun error */
+	u32	fcp_rsp_proto_err;	/*  protocol error in fcp rsp */
+	u32	fcp_rsp_sense_err;	/*  error in sense info in fcp rsp */
+	u32	fcp_conf_req;		/*  FCP conf requested */
+
+	u32	tgt_aborted_io;		/*  target initiated abort */
+
+	u32	ioh_edtov_timeout_event;/*  IOH edtov timer popped */
+	u32	ioh_fcp_rsp_excp_event;	/*  IOH FCP_RSP exception */
+	u32	ioh_fcp_conf_event;	/*  IOH FCP_CONF */
+	u32	ioh_mult_frm_rsp_event;	/*  IOH multi_frame FCP_RSP */
+	u32	ioh_hit_class2_event;	/*  IOH hit class2 */
+	u32	ioh_miss_other_event;	/*  IOH miss other */
+	u32	ioh_seq_cnt_err_event;	/*  IOH seq cnt error */
+	u32	ioh_len_err_event;		/*  IOH len error - fcp_dl !=
+							* bytes xfered */
+	u32	ioh_seq_len_err_event;	/*  IOH seq len error */
+	u32	ioh_data_oor_event;	/*  Data out of range */
+	u32	ioh_ro_ooo_event;	/*  Relative offset out of range */
+	u32	ioh_cpu_owned_event;	/*  IOH hit -iost owned by f/w */
+	u32	ioh_unexp_frame_event;	/*  unexpected frame recieved
+						 *   count */
+	u32	ioh_err_int;		/*  IOH error int during data-phase
+						 *   for scsi write
+						 */
+};
+
+/**
+ * IOC port firmware stats
+ */
+
+struct bfa_fw_port_fpg_stats_s {
+    u32    intr_evt;
+    u32    intr;
+    u32    intr_excess;
+    u32    intr_cause0;
+    u32    intr_other;
+    u32    intr_other_ign;
+    u32    sig_lost;
+    u32    sig_regained;
+    u32    sync_lost;
+    u32    sync_to;
+    u32    sync_regained;
+    u32    div2_overflow;
+    u32    div2_underflow;
+    u32    efifo_overflow;
+    u32    efifo_underflow;
+    u32    idle_rx;
+    u32    lrr_rx;
+    u32    lr_rx;
+    u32    ols_rx;
+    u32    nos_rx;
+    u32    lip_rx;
+    u32    arbf0_rx;
+    u32    mrk_rx;
+    u32    const_mrk_rx;
+    u32    prim_unknown;
+    u32    rsvd;
+};
+
+
+struct bfa_fw_port_lksm_stats_s {
+    u32    hwsm_success;       /*  hwsm state machine success          */
+    u32    hwsm_fails;         /*  hwsm fails                          */
+    u32    hwsm_wdtov;         /*  hwsm timed out                      */
+    u32    swsm_success;       /*  swsm success                        */
+    u32    swsm_fails;         /*  swsm fails                          */
+    u32    swsm_wdtov;         /*  swsm timed out                      */
+    u32    busybufs;           /*  link init failed due to busybuf     */
+    u32    buf_waits;          /*  bufwait state entries               */
+    u32    link_fails;         /*  link failures                       */
+    u32    psp_errors;         /*  primitive sequence protocol errors  */
+    u32    lr_unexp;           /*  No. of times LR rx-ed unexpectedly  */
+    u32    lrr_unexp;          /*  No. of times LRR rx-ed unexpectedly */
+    u32    lr_tx;              /*  No. of times LR tx started          */
+    u32    lrr_tx;             /*  No. of times LRR tx started         */
+    u32    ols_tx;             /*  No. of times OLS tx started         */
+    u32    nos_tx;             /*  No. of times NOS tx started         */
+};
+
+
+struct bfa_fw_port_snsm_stats_s {
+    u32    hwsm_success;       /*  Successful hwsm terminations        */
+    u32    hwsm_fails;         /*  hwsm fail count                     */
+    u32    hwsm_wdtov;         /*  hwsm timed out                      */
+    u32    swsm_success;       /*  swsm success                        */
+    u32    swsm_wdtov;         /*  swsm timed out                      */
+    u32    error_resets;       /*  error resets initiated by upsm      */
+    u32    sync_lost;          /*  Sync loss count                     */
+    u32    sig_lost;           /*  Signal loss count                   */
+};
+
+
+struct bfa_fw_port_physm_stats_s {
+    u32    module_inserts;     /*  Module insert count                 */
+    u32    module_xtracts;     /*  Module extracts count               */
+    u32    module_invalids;    /*  Invalid module inserted count       */
+    u32    module_read_ign;    /*  Module validation status ignored    */
+    u32    laser_faults;       /*  Laser fault count                   */
+    u32    rsvd;
+};
+
+
+struct bfa_fw_fip_stats_s {
+    u32    disc_req;           /*  Discovery solicit requests          */
+    u32    disc_rsp;           /*  Discovery solicit response          */
+    u32    disc_err;           /*  Discovery advt. parse errors        */
+    u32    disc_unsol;         /*  Discovery unsolicited               */
+    u32    disc_timeouts;      /*  Discovery timeouts                  */
+    u32    linksvc_unsupp;     /*  Unsupported link service req        */
+    u32    linksvc_err;        /*  Parse error in link service req     */
+    u32    logo_req;           /*  Number of FIP logos received        */
+    u32    clrvlink_req;       /*  Clear virtual link req              */
+    u32    op_unsupp;          /*  Unsupported FIP operation           */
+    u32    untagged;           /*  Untagged frames (ignored)           */
+    u32    rsvd;
+};
+
+
+struct bfa_fw_lps_stats_s {
+    u32    mac_invalids;       /*  Invalid mac assigned                */
+    u32    rsvd;
+};
+
+
+struct bfa_fw_fcoe_stats_s {
+    u32    cee_linkups;        /*  CEE link up count                   */
+    u32    cee_linkdns;        /*  CEE link down count                 */
+    u32    fip_linkups;        /*  FIP link up count                   */
+    u32    fip_linkdns;        /*  FIP link up count                   */
+    u32    fip_fails;          /*  FIP fail count                      */
+    u32    mac_invalids;       /*  Invalid mac assigned                */
+};
+
+/**
+ * IOC firmware FCoE port stats
+ */
+struct bfa_fw_fcoe_port_stats_s {
+    struct bfa_fw_fcoe_stats_s  fcoe_stats;
+    struct bfa_fw_fip_stats_s   fip_stats;
+};
+
+/**
+ * IOC firmware FC port stats
+ */
+struct bfa_fw_fc_port_stats_s {
+	struct bfa_fw_port_fpg_stats_s		fpg_stats;
+	struct bfa_fw_port_physm_stats_s	physm_stats;
+	struct bfa_fw_port_snsm_stats_s		snsm_stats;
+	struct bfa_fw_port_lksm_stats_s		lksm_stats;
+};
+
+/**
+ * IOC firmware FC port stats
+ */
+union bfa_fw_port_stats_s {
+	struct bfa_fw_fc_port_stats_s	fc_stats;
+	struct bfa_fw_fcoe_port_stats_s	fcoe_stats;
+};
+
+/**
+ * IOC firmware stats
+ */
+struct bfa_fw_stats_s {
+	struct bfa_fw_ioc_stats_s	ioc_stats;
+	struct bfa_fw_io_stats_s	io_stats;
+	union  bfa_fw_port_stats_s	port_stats;
+};
+
+/**
+ * IOC statistics
+ */
+struct bfa_iocfc_stats_s {
+	struct bfa_fw_stats_s 	fw_stats;	/*  firmware IOC stats      */
+};
+
+/**
+ * IOC attributes returned in queries
+ */
+struct bfa_iocfc_attr_s {
+	struct bfa_iocfc_cfg_s		config;		/*  IOCFC config   */
+	struct bfa_iocfc_intr_attr_s	intr_attr;	/*  interrupt attr */
+};
+
+#define BFA_IOCFC_PATHTOV_MAX	60
+#define BFA_IOCFC_QDEPTH_MAX	2000
+
+#endif /* __BFA_DEFS_IOC_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h patch/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_IPFC_H__
+#define __BFA_DEFS_IPFC_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+#include <defs/bfa_defs_types.h>
+
+/**
+ * FCS ip remote port states
+ */
+enum bfa_iprp_state {
+	BFA_IPRP_UNINIT  = 0,	/*  PORT is not yet initialized */
+	BFA_IPRP_ONLINE  = 1,	/*  process login is complete */
+	BFA_IPRP_OFFLINE = 2,	/*  iprp is offline */
+};
+
+/**
+ * FCS remote port statistics
+ */
+struct bfa_iprp_stats_s {
+	u32        offlines;
+	u32        onlines;
+	u32        rscns;
+	u32        plogis;
+	u32        logos;
+	u32        plogi_timeouts;
+	u32        plogi_rejects;
+};
+
+/**
+ * FCS iprp attribute returned in queries
+ */
+struct bfa_iprp_attr_s {
+	enum bfa_iprp_state state;
+};
+
+struct bfa_ipfc_stats_s {
+	u32 arp_sent;
+	u32 arp_recv;
+	u32 arp_reply_sent;
+	u32 arp_reply_recv;
+	u32 farp_sent;
+	u32 farp_recv;
+	u32 farp_reply_sent;
+	u32 farp_reply_recv;
+	u32 farp_reject_sent;
+	u32 farp_reject_recv;
+};
+
+struct bfa_ipfc_attr_s {
+	bfa_boolean_t enabled;
+};
+
+#endif /* __BFA_DEFS_IPFC_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h patch/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_ITNIM_H__
+#define __BFA_DEFS_ITNIM_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+
+/**
+ * FCS itnim states
+ */
+enum bfa_itnim_state {
+	BFA_ITNIM_OFFLINE 	= 0,	/*  offline */
+	BFA_ITNIM_PRLI_SEND 	= 1,	/*  prli send */
+	BFA_ITNIM_PRLI_SENT 	= 2,	/*  prli sent */
+	BFA_ITNIM_PRLI_RETRY 	= 3,	/*  prli retry */
+	BFA_ITNIM_HCB_ONLINE 	= 4,	/*  online callback */
+	BFA_ITNIM_ONLINE 	= 5,	/*  online */
+	BFA_ITNIM_HCB_OFFLINE 	= 6,	/*  offline callback */
+	BFA_ITNIM_INITIATIOR 	= 7,	/*  initiator */
+};
+
+struct bfa_itnim_hal_stats_s {
+	u32	onlines;	/*  ITN nexus onlines (PRLI done) */
+	u32	offlines;	/*  ITN Nexus offlines 	*/
+	u32	creates;	/*  ITN create requests 	*/
+	u32	deletes;	/*  ITN delete requests 	*/
+	u32	create_comps;	/*  ITN create completions 	*/
+	u32	delete_comps;	/*  ITN delete completions 	*/
+	u32	sler_events;	/*  SLER (sequence level error
+					 * recovery) events */
+	u32	ioc_disabled;	/*  Num IOC disables		*/
+	u32	cleanup_comps;	/*  ITN cleanup completions */
+	u32	tm_cmnds;	/*  task management(TM) cmnds sent */
+	u32	tm_fw_rsps;	/*  TM cmds firmware responses */
+	u32	tm_success;	/*  TM successes */
+	u32	tm_failures;	/*  TM failures */
+	u32	tm_io_comps;	/*  TM IO completions */
+	u32	tm_qresumes;	/*  TM queue resumes (after waiting
+					 * for resources)
+					 */
+	u32	tm_iocdowns;	/*  TM cmnds affected by IOC down */
+	u32	tm_cleanups;	/*  TM cleanups */
+	u32	tm_cleanup_comps;
+					/*  TM cleanup completions */
+	u32	ios;		/*  IO requests */
+	u32	io_comps;	/*  IO completions */
+	u64	input_reqs;	/*  INPUT requests */
+	u64	output_reqs;	/*  OUTPUT requests */
+};
+
+/**
+ * FCS remote port statistics
+ */
+struct bfa_itnim_stats_s {
+	u32        onlines;	/*  num rport online */
+	u32        offlines;	/*  num rport offline */
+	u32        prli_sent;	/*  num prli sent out */
+	u32        fcxp_alloc_wait;/*  num fcxp alloc waits */
+	u32        prli_rsp_err;	/*  num prli rsp errors */
+	u32        prli_rsp_acc;	/*  num prli rsp accepts */
+	u32        initiator;	/*  rport is an initiator */
+	u32        prli_rsp_parse_err;	/*  prli rsp parsing errors */
+	u32        prli_rsp_rjt;	/*  num prli rsp rejects */
+	u32        timeout;	/*  num timeouts detected */
+	u32        sler;		/*  num sler notification from BFA */
+	u32	rsvd;
+	struct bfa_itnim_hal_stats_s	hal_stats;
+};
+
+/**
+ * FCS itnim attributes returned in queries
+ */
+struct bfa_itnim_attr_s {
+	enum bfa_itnim_state state; /*  FCS itnim state        */
+	u8 retry;		/*  data retransmision support */
+	u8	task_retry_id;  /*  task retry ident support   */
+	u8 rec_support;    /*  REC supported              */
+	u8 conf_comp;      /*  confirmed completion supp  */
+};
+
+/**
+ * BFA ITNIM events.
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_ITNIM_AEN_NEW:       [in]: None  [out]: vf_id, lpwwn
+ * BFA_ITNIM_AEN_DELETE:    [in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ * BFA_ITNIM_AEN_ONLINE:    [in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ * BFA_ITNIM_AEN_OFFLINE:   [in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ * BFA_ITNIM_AEN_DISCONNECT:[in]: vf_id, lpwwn, rpwwn (0 = all fcp4 targets),
+ *				  [out]: vf_id, ppwwn, lpwwn, rpwwn
+ */
+enum bfa_itnim_aen_event {
+	BFA_ITNIM_AEN_ONLINE 	= 1,	/*  Target online */
+	BFA_ITNIM_AEN_OFFLINE 	= 2,	/*  Target offline */
+	BFA_ITNIM_AEN_DISCONNECT = 3,	/*  Target disconnected */
+};
+
+/**
+ * BFA ITNIM event data structure.
+ */
+struct bfa_itnim_aen_data_s {
+	u16        vf_id;	/*  vf_id of the IT nexus */
+	u16        rsvd[3];
+	wwn_t           ppwwn;	/*  WWN of its physical port */
+	wwn_t           lpwwn;	/*  WWN of logical port */
+	wwn_t           rpwwn;	/*  WWN of remote(target) port */
+};
+
+#endif /* __BFA_DEFS_ITNIM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_led.h patch/drivers/scsi/bfa/include/defs/bfa_defs_led.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_led.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_led.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_LED_H__
+#define __BFA_DEFS_LED_H__
+
+#define	BFA_LED_MAX_NUM		3
+
+enum bfa_led_op {
+	BFA_LED_OFF   = 0,
+	BFA_LED_ON    = 1,
+	BFA_LED_FLICK = 2,
+	BFA_LED_BLINK = 3,
+};
+
+enum bfa_led_color {
+	BFA_LED_GREEN = 0,
+	BFA_LED_AMBER = 1,
+};
+
+#endif /* __BFA_DEFS_LED_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_lport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_lport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,68 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_LPORT_H__
+#define __BFA_DEFS_LPORT_H__
+
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_port.h>
+
+/**
+ * BFA AEN logical port events.
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_LPORT_AEN_NEW:       [in]: None         [out]: vf_id, ppwwn, lpwwn, roles
+ * BFA_LPORT_AEN_DELETE:    [in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_ONLINE:    [in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_OFFLINE:   [in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_DISCONNECT:[in]: lpwwn        [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NEW_PROP:  [in]: None         [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_DELETE_PROP:     [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NEW_STANDARD:    [in]: None   [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_DELETE_STANDARD: [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NPIV_DUP_WWN:    [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NPIV_FABRIC_MAX: [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ * BFA_LPORT_AEN_NPIV_UNKNOWN:    [in]: lpwwn  [out]: vf_id, ppwwn. lpwwn, roles
+ */
+enum bfa_lport_aen_event {
+	BFA_LPORT_AEN_NEW	= 1,	/*  LPort created event */
+	BFA_LPORT_AEN_DELETE	= 2,	/*  LPort deleted event */
+	BFA_LPORT_AEN_ONLINE	= 3,	/*  LPort online event */
+	BFA_LPORT_AEN_OFFLINE	= 4,	/*  LPort offline event */
+	BFA_LPORT_AEN_DISCONNECT = 5,	/*  LPort disconnect event */
+	BFA_LPORT_AEN_NEW_PROP	= 6,	/*  VPort created event */
+	BFA_LPORT_AEN_DELETE_PROP = 7,	/*  VPort deleted event */
+	BFA_LPORT_AEN_NEW_STANDARD = 8,	/*  VPort created event */
+	BFA_LPORT_AEN_DELETE_STANDARD = 9,  /*  VPort deleted event */
+	BFA_LPORT_AEN_NPIV_DUP_WWN = 10,    /*  VPort configured with
+					     *   duplicate WWN event
+						 */
+	BFA_LPORT_AEN_NPIV_FABRIC_MAX = 11, /*  Max NPIV in fabric/fport */
+	BFA_LPORT_AEN_NPIV_UNKNOWN = 12, /*  Unknown NPIV Error code event */
+};
+
+/**
+ * BFA AEN event data structure
+ */
+struct bfa_lport_aen_data_s {
+	u16        vf_id;	/*  vf_id of this logical port */
+	u16        rsvd;
+	enum bfa_port_role roles;	/*  Logical port mode,IM/TM/IP etc */
+	wwn_t           ppwwn;	/*  WWN of its physical port */
+	wwn_t           lpwwn;	/*  WWN of this logical port */
+};
+
+#endif /* __BFA_DEFS_LPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h patch/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_MFG_H__
+#define __BFA_DEFS_MFG_H__
+
+#include <bfa_os_inc.h>
+
+/**
+ * Manufacturing block version
+ */
+#define BFA_MFG_VERSION				1
+
+/**
+ * Manufacturing block format
+ */
+#define BFA_MFG_SERIALNUM_SIZE			11
+#define BFA_MFG_PARTNUM_SIZE			14
+#define BFA_MFG_SUPPLIER_ID_SIZE		10
+#define BFA_MFG_SUPPLIER_PARTNUM_SIZE	20
+#define BFA_MFG_SUPPLIER_SERIALNUM_SIZE	20
+#define BFA_MFG_SUPPLIER_REVISION_SIZE	4
+#define STRSZ(_n)	(((_n) + 4) & ~3)
+
+/**
+ * VPD data length
+ */
+#define BFA_MFG_VPD_LEN     256
+
+/**
+ * All numerical fields are in big-endian format.
+ */
+struct bfa_mfg_vpd_s {
+    u8     version;    /*  vpd data version */
+    u8     vpd_sig[3]; /*  characters 'V', 'P', 'D' */
+    u8     chksum;     /*  u8 checksum */
+    u8     vendor;     /*  vendor */
+    u8     len;        /*  vpd data length excluding header */
+    u8     rsv;
+    u8     data[BFA_MFG_VPD_LEN];  /*  vpd data */
+};
+
+#pragma pack(1)
+
+#endif /* __BFA_DEFS_MFG_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pci.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pci.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pci.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pci.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_PCI_H__
+#define __BFA_DEFS_PCI_H__
+
+/**
+ * PCI device and vendor ID information
+ */
+enum {
+	BFA_PCI_VENDOR_ID_BROCADE	= 0x1657,
+	BFA_PCI_DEVICE_ID_FC_8G2P	= 0x13,
+	BFA_PCI_DEVICE_ID_FC_8G1P	= 0x17,
+	BFA_PCI_DEVICE_ID_CT		= 0x14,
+};
+
+/**
+ * PCI sub-system device and vendor ID information
+ */
+enum {
+	BFA_PCI_FCOE_SSDEVICE_ID	= 0x14,
+};
+
+#define BFA_PCI_ACCESS_RANGES 1	/* Maximum number of device address ranges
+				 * mapped through different BAR(s). */
+
+#endif /* __BFA_DEFS_PCI_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pm.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pm.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pm.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pm.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_PM_H__
+#define __BFA_DEFS_PM_H__
+
+#include <bfa_os_inc.h>
+
+/**
+ * BFA power management device states
+ */
+enum bfa_pm_ds {
+	BFA_PM_DS_D0 = 0,	/*  full power mode */
+	BFA_PM_DS_D1 = 1,	/*  power save state 1 */
+	BFA_PM_DS_D2 = 2,	/*  power save state 2 */
+	BFA_PM_DS_D3 = 3,	/*  power off state */
+};
+
+#endif /* __BFA_DEFS_PM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pom.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pom.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pom.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pom.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_POM_H__
+#define __BFA_DEFS_POM_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_types.h>
+
+/**
+ * POM health status levels for each attributes.
+ */
+enum bfa_pom_entry_health {
+	BFA_POM_HEALTH_NOINFO  = 1,	/*  no information */
+	BFA_POM_HEALTH_NORMAL  = 2,	/*  health is normal */
+	BFA_POM_HEALTH_WARNING = 3,	/*  warning level */
+	BFA_POM_HEALTH_ALARM   = 4,	/*  alarming level */
+};
+
+/**
+ * Reading of temperature/voltage/current/power
+ */
+struct bfa_pom_entry_s {
+	enum bfa_pom_entry_health health;	/*  POM entry health */
+	u32        curr_value;	/*  current value */
+	u32        thr_warn_high;	/*  threshold warning high */
+	u32        thr_warn_low;	/*  threshold warning low */
+	u32        thr_alarm_low;	/*  threshold alaram low */
+	u32        thr_alarm_high;	/*  threshold alarm high */
+};
+
+/**
+ * POM attributes
+ */
+struct bfa_pom_attr_s {
+	struct bfa_pom_entry_s temperature;	/*  centigrade */
+	struct bfa_pom_entry_s voltage;	/*  volts */
+	struct bfa_pom_entry_s curr;	/*  milli amps */
+	struct bfa_pom_entry_s txpower;	/*  micro watts */
+	struct bfa_pom_entry_s rxpower;	/*  micro watts */
+};
+
+#endif /* __BFA_DEFS_POM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_port.h patch/drivers/scsi/bfa/include/defs/bfa_defs_port.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_port.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,245 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_PORT_H__
+#define __BFA_DEFS_PORT_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_ioc.h>
+
+#define BFA_FCS_FABRIC_IPADDR_SZ  16
+
+/**
+ * symbolic names for base port/virtual port
+ */
+#define BFA_SYMNAME_MAXLEN	128	/* vmware/windows uses 128 bytes */
+struct bfa_port_symname_s {
+	char            symname[BFA_SYMNAME_MAXLEN];
+};
+
+/**
+* Roles of FCS port:
+ *     - FCP IM and FCP TM roles cannot be enabled together for a FCS port
+ *     - Create multiple ports if both IM and TM functions required.
+ *     - Atleast one role must be specified.
+ */
+enum bfa_port_role {
+	BFA_PORT_ROLE_FCP_IM 	= 0x01,	/*  FCP initiator role */
+	BFA_PORT_ROLE_FCP_TM 	= 0x02,	/*  FCP target role */
+	BFA_PORT_ROLE_FCP_IPFC 	= 0x04,	/*  IP over FC role */
+	BFA_PORT_ROLE_FCP_MAX 	= BFA_PORT_ROLE_FCP_IPFC | BFA_PORT_ROLE_FCP_IM
+};
+
+/**
+ * FCS port configuration.
+ */
+struct bfa_port_cfg_s {
+    wwn_t               pwwn;       /*  port wwn */
+    wwn_t               nwwn;       /*  node wwn */
+    struct bfa_port_symname_s  sym_name;   /*  vm port symbolic name */
+    enum bfa_port_role     roles;      /*  FCS port roles */
+	u32			rsvd;
+    u8             tag[16];	/*  opaque tag from application */
+};
+
+/**
+ * FCS port states
+ */
+enum bfa_port_state {
+	BFA_PORT_UNINIT  = 0,	/*  PORT is not yet initialized */
+	BFA_PORT_FDISC   = 1,	/*  FDISC is in progress */
+	BFA_PORT_ONLINE  = 2,	/*  login to fabric is complete */
+	BFA_PORT_OFFLINE = 3,	/*  No login to fabric */
+};
+
+/**
+ * FCS port type. Required for VmWare.
+ */
+enum bfa_port_type {
+	BFA_PORT_TYPE_PHYSICAL = 0,
+	BFA_PORT_TYPE_VIRTUAL,
+};
+
+/**
+ * FCS port offline reason. Required for VmWare.
+ */
+enum bfa_port_offline_reason {
+	BFA_PORT_OFFLINE_UNKNOWN = 0,
+	BFA_PORT_OFFLINE_LINKDOWN,
+	BFA_PORT_OFFLINE_FAB_UNSUPPORTED,	/*  NPIV not supported by the
+						 *    fabric */
+	BFA_PORT_OFFLINE_FAB_NORESOURCES,
+	BFA_PORT_OFFLINE_FAB_LOGOUT,
+};
+
+/**
+ * FCS lport info. Required for VmWare.
+ */
+struct bfa_port_info_s {
+	u8         port_type;	/* bfa_port_type_t : physical or
+					 * virtual */
+	u8         port_state;	/* one of bfa_port_state values */
+	u8         offline_reason;	/* one of bfa_port_offline_reason_t
+					 * values */
+	wwn_t           port_wwn;
+	wwn_t           node_wwn;
+
+	/*
+	 * following 4 feilds are valid for Physical Ports only
+	 */
+	u32        max_vports_supp;	/* Max supported vports */
+	u32        num_vports_inuse;	/* Num of in use vports */
+	u32        max_rports_supp;	/* Max supported rports */
+	u32        num_rports_inuse;	/* Num of doscovered rports */
+
+};
+
+/**
+ * FCS port statistics
+ */
+struct bfa_port_stats_s {
+	u32        ns_plogi_sent;
+	u32        ns_plogi_rsp_err;
+	u32        ns_plogi_acc_err;
+	u32        ns_plogi_accepts;
+	u32        ns_rejects;	/* NS command rejects */
+	u32        ns_plogi_unknown_rsp;
+	u32        ns_plogi_alloc_wait;
+
+	u32        ns_retries;	/* NS command retries */
+	u32        ns_timeouts;	/* NS command timeouts */
+
+	u32        ns_rspnid_sent;
+	u32        ns_rspnid_accepts;
+	u32        ns_rspnid_rsp_err;
+	u32        ns_rspnid_rejects;
+	u32        ns_rspnid_alloc_wait;
+
+	u32        ns_rftid_sent;
+	u32        ns_rftid_accepts;
+	u32        ns_rftid_rsp_err;
+	u32        ns_rftid_rejects;
+	u32        ns_rftid_alloc_wait;
+
+	u32	ns_rffid_sent;
+	u32	ns_rffid_accepts;
+	u32	ns_rffid_rsp_err;
+	u32	ns_rffid_rejects;
+	u32	ns_rffid_alloc_wait;
+
+	u32        ns_gidft_sent;
+	u32        ns_gidft_accepts;
+	u32        ns_gidft_rsp_err;
+	u32        ns_gidft_rejects;
+	u32        ns_gidft_unknown_rsp;
+	u32        ns_gidft_alloc_wait;
+
+	/*
+	 * Mgmt Server stats
+	 */
+	u32        ms_retries;	/* MS command retries */
+	u32        ms_timeouts;	/* MS command timeouts */
+	u32        ms_plogi_sent;
+	u32        ms_plogi_rsp_err;
+	u32        ms_plogi_acc_err;
+	u32        ms_plogi_accepts;
+	u32        ms_rejects;	/* NS command rejects */
+	u32        ms_plogi_unknown_rsp;
+	u32        ms_plogi_alloc_wait;
+
+	u32        num_rscn;	/* Num of RSCN received */
+	u32        num_portid_rscn;/* Num portid format RSCN
+								* received */
+
+	u32	uf_recvs; 	/* unsolicited recv frames      */
+	u32	uf_recv_drops; 	/* dropped received frames	*/
+
+	u32	rsvd; 		/* padding for 64 bit alignment */
+};
+
+/**
+ * BFA port attribute returned in queries
+ */
+struct bfa_port_attr_s {
+	enum bfa_port_state state;		/*  port state */
+	u32         pid;		/*  port ID */
+	struct bfa_port_cfg_s   port_cfg;	/*  port configuration */
+	enum bfa_pport_type port_type;	/*  current topology */
+	u32         loopback;	/*  cable is externally looped back */
+	wwn_t		fabric_name; /*  attached switch's nwwn */
+	u8		fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ]; /*  attached
+							* fabric's ip addr */
+};
+
+/**
+ * BFA physical port Level events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_PORT_AEN_ONLINE:     [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_OFFLINE:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_RLIR:       [in]: None	[out]: pwwn, rlir_data, rlir_len
+ * BFA_PORT_AEN_SFP_INSERT: [in]: pwwn	[out]: port_id, pwwn
+ * BFA_PORT_AEN_SFP_REMOVE: [in]: pwwn	[out]: port_id, pwwn
+ * BFA_PORT_AEN_SFP_POM:    [in]: pwwn	[out]: level, port_id, pwwn
+ * BFA_PORT_AEN_ENABLE:     [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_DISABLE:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_AUTH_ON:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_AUTH_OFF:   [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_DISCONNECT: [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_QOS_NEG:    [in]: pwwn	[out]: pwwn
+ * BFA_PORT_AEN_FABRIC_NAME_CHANGE: [in]: pwwn, [out]: pwwn, fwwn
+ *
+ */
+enum bfa_port_aen_event {
+	BFA_PORT_AEN_ONLINE     = 1,	/*  Physical Port online event */
+	BFA_PORT_AEN_OFFLINE    = 2,	/*  Physical Port offline event */
+	BFA_PORT_AEN_RLIR       = 3,	/*  RLIR event, not supported */
+	BFA_PORT_AEN_SFP_INSERT = 4,	/*  SFP inserted event */
+	BFA_PORT_AEN_SFP_REMOVE = 5,	/*  SFP removed event */
+	BFA_PORT_AEN_SFP_POM    = 6,	/*  SFP POM event */
+	BFA_PORT_AEN_ENABLE     = 7,	/*  Physical Port enable event */
+	BFA_PORT_AEN_DISABLE    = 8,	/*  Physical Port disable event */
+	BFA_PORT_AEN_AUTH_ON    = 9,	/*  Physical Port auth success event */
+	BFA_PORT_AEN_AUTH_OFF   = 10,	/*  Physical Port auth fail event */
+	BFA_PORT_AEN_DISCONNECT = 11,	/*  Physical Port disconnect event */
+	BFA_PORT_AEN_QOS_NEG    = 12,  	/*  Base Port QOS negotiation event */
+	BFA_PORT_AEN_FABRIC_NAME_CHANGE = 13, /*  Fabric Name/WWN change
+					       * event */
+	BFA_PORT_AEN_SFP_ACCESS_ERROR = 14, /*  SFP read error event */
+	BFA_PORT_AEN_SFP_UNSUPPORT = 15, /*  Unsupported SFP event */
+};
+
+enum bfa_port_aen_sfp_pom {
+	BFA_PORT_AEN_SFP_POM_GREEN = 1,	/*  Normal */
+	BFA_PORT_AEN_SFP_POM_AMBER = 2,	/*  Warning */
+	BFA_PORT_AEN_SFP_POM_RED   = 3,	/*  Critical */
+	BFA_PORT_AEN_SFP_POM_MAX   = BFA_PORT_AEN_SFP_POM_RED
+};
+
+struct bfa_port_aen_data_s {
+	enum bfa_ioc_type_e ioc_type;
+	wwn_t           pwwn;	      /*  WWN of the physical port */
+	wwn_t           fwwn;	      /*  WWN of the fabric port */
+	mac_t           mac;	      /*  MAC addres of the ethernet port,
+				       * applicable to CNA port only */
+	int             phy_port_num; /*! For SFP related events */
+	enum bfa_port_aen_sfp_pom level; /*  Only transitions will
+					  * be informed */
+};
+
+#endif /* __BFA_DEFS_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_pport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_pport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_pport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,383 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_PPORT_H__
+#define __BFA_DEFS_PPORT_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/fc.h>
+#include <defs/bfa_defs_types.h>
+#include <defs/bfa_defs_qos.h>
+#include <cna/pstats/phyport_defs.h>
+
+/* Modify char* port_stt[] in bfal_port.c if a new state was added */
+enum bfa_pport_states {
+	BFA_PPORT_ST_UNINIT 		= 1,
+	BFA_PPORT_ST_ENABLING_QWAIT 	= 2,
+	BFA_PPORT_ST_ENABLING 		= 3,
+	BFA_PPORT_ST_LINKDOWN 		= 4,
+	BFA_PPORT_ST_LINKUP 		= 5,
+	BFA_PPORT_ST_DISABLING_QWAIT 	= 6,
+	BFA_PPORT_ST_DISABLING		= 7,
+	BFA_PPORT_ST_DISABLED 		= 8,
+	BFA_PPORT_ST_STOPPED 		= 9,
+	BFA_PPORT_ST_IOCDOWN 		= 10,
+	BFA_PPORT_ST_IOCDIS 		= 11,
+	BFA_PPORT_ST_FWMISMATCH		= 12,
+	BFA_PPORT_ST_MAX_STATE,
+};
+
+/**
+ * 	Port speed settings. Each specific speed is a bit field. Use multiple
+ *      bits to specify speeds to be selected for auto-negotiation.
+ */
+enum bfa_pport_speed {
+	BFA_PPORT_SPEED_UNKNOWN = 0,
+	BFA_PPORT_SPEED_1GBPS 	= 1,
+	BFA_PPORT_SPEED_2GBPS 	= 2,
+	BFA_PPORT_SPEED_4GBPS 	= 4,
+	BFA_PPORT_SPEED_8GBPS 	= 8,
+	BFA_PPORT_SPEED_10GBPS 	= 10,
+	BFA_PPORT_SPEED_AUTO =
+		(BFA_PPORT_SPEED_1GBPS | BFA_PPORT_SPEED_2GBPS |
+		 BFA_PPORT_SPEED_4GBPS | BFA_PPORT_SPEED_8GBPS),
+};
+
+/**
+ * 		Port operational type (in sync with SNIA port type).
+ */
+enum bfa_pport_type {
+	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unkown */
+	BFA_PPORT_TYPE_TRUNKED = 2,	/*  Trunked mode */
+	BFA_PPORT_TYPE_NPORT   = 5,	/*  P2P with switched fabric */
+	BFA_PPORT_TYPE_NLPORT  = 6,	/*  public loop */
+	BFA_PPORT_TYPE_LPORT   = 20,	/*  private loop */
+	BFA_PPORT_TYPE_P2P     = 21,	/*  P2P with no switched fabric */
+	BFA_PPORT_TYPE_VPORT   = 22,	/*  NPIV - virtual port */
+};
+
+/**
+ * 		Port topology setting. A port's topology and fabric login status
+ * 		determine its operational type.
+ */
+enum bfa_pport_topology {
+	BFA_PPORT_TOPOLOGY_NONE = 0,	/*  No valid topology */
+	BFA_PPORT_TOPOLOGY_P2P  = 1,	/*  P2P only */
+	BFA_PPORT_TOPOLOGY_LOOP = 2,	/*  LOOP topology */
+	BFA_PPORT_TOPOLOGY_AUTO = 3,	/*  auto topology selection */
+};
+
+/**
+ * 		Physical port loopback types.
+ */
+enum bfa_pport_opmode {
+	BFA_PPORT_OPMODE_NORMAL   = 0x00, /*  normal non-loopback mode */
+	BFA_PPORT_OPMODE_LB_INT   = 0x01, /*  internal loop back */
+	BFA_PPORT_OPMODE_LB_SLW   = 0x02, /*  serial link wrapback (serdes) */
+	BFA_PPORT_OPMODE_LB_EXT   = 0x04, /*  external loop back (serdes) */
+	BFA_PPORT_OPMODE_LB_CBL   = 0x08, /*  cabled loop back */
+	BFA_PPORT_OPMODE_LB_NLINT = 0x20, /*  NL_Port internal loopback */
+};
+
+#define BFA_PPORT_OPMODE_LB_HARD(_mode)			\
+	((_mode == BFA_PPORT_OPMODE_LB_INT) ||		\
+     (_mode == BFA_PPORT_OPMODE_LB_SLW) ||		\
+     (_mode == BFA_PPORT_OPMODE_LB_EXT))
+
+/**
+		Port State (in sync with SNIA port state).
+ */
+enum bfa_pport_snia_state {
+	BFA_PPORT_STATE_UNKNOWN  = 1,	/*  port is not initialized */
+	BFA_PPORT_STATE_ONLINE   = 2,	/*  port is ONLINE */
+	BFA_PPORT_STATE_DISABLED = 3,	/*  port is disabled by user */
+	BFA_PPORT_STATE_BYPASSED = 4,	/*  port is bypassed (in LOOP) */
+	BFA_PPORT_STATE_DIAG     = 5,	/*  port diagnostics is active */
+	BFA_PPORT_STATE_LINKDOWN = 6,	/*  link is down */
+	BFA_PPORT_STATE_LOOPBACK = 8,	/*  port is looped back */
+};
+
+/**
+ * 		Port link state
+ */
+enum bfa_pport_linkstate {
+	BFA_PPORT_LINKUP 	 = 1,	/*  Physical port/Trunk link up */
+	BFA_PPORT_LINKDOWN 	 = 2,	/*  Physical port/Trunk link down */
+	BFA_PPORT_TRUNK_LINKDOWN = 3,	/*  Trunk link down (new tmaster) */
+};
+
+/**
+ * 		Port link state event
+ */
+#define bfa_pport_event_t enum bfa_pport_linkstate
+
+/**
+ * 		Port link state reason code
+ */
+enum bfa_pport_linkstate_rsn {
+	BFA_PPORT_LINKSTATE_RSN_NONE		= 0,
+	BFA_PPORT_LINKSTATE_RSN_DISABLED 	= 1,
+	BFA_PPORT_LINKSTATE_RSN_RX_NOS 		= 2,
+	BFA_PPORT_LINKSTATE_RSN_RX_OLS 		= 3,
+	BFA_PPORT_LINKSTATE_RSN_RX_LIP 		= 4,
+	BFA_PPORT_LINKSTATE_RSN_RX_LIPF7 	= 5,
+	BFA_PPORT_LINKSTATE_RSN_SFP_REMOVED 	= 6,
+	BFA_PPORT_LINKSTATE_RSN_PORT_FAULT 	= 7,
+	BFA_PPORT_LINKSTATE_RSN_RX_LOS 		= 8,
+	BFA_PPORT_LINKSTATE_RSN_LOCAL_FAULT 	= 9,
+	BFA_PPORT_LINKSTATE_RSN_REMOTE_FAULT 	= 10,
+	BFA_PPORT_LINKSTATE_RSN_TIMEOUT 	= 11,
+
+
+
+	/* CEE related reason codes/errors */
+	CEE_LLDP_INFO_AGED_OUT       = 20,
+	CEE_LLDP_SHUTDOWN_TLV_RCVD   = 21,
+	CEE_PEER_NOT_ADVERTISE_DCBX  = 22,
+	CEE_PEER_NOT_ADVERTISE_PG    = 23,
+	CEE_PEER_NOT_ADVERTISE_PFC   = 24,
+	CEE_PEER_NOT_ADVERTISE_FCOE  = 25,
+	CEE_PG_NOT_COMPATIBLE        = 26,
+	CEE_PFC_NOT_COMPATIBLE       = 27,
+	CEE_FCOE_NOT_COMPATIBLE      = 28,
+	CEE_BAD_PG_RCVD              = 29,
+	CEE_BAD_BW_RCVD              = 30,
+	CEE_BAD_PFC_RCVD             = 31,
+	CEE_BAD_FCOE_PRI_RCVD        = 32,
+	CEE_FCOE_PRI_PFC_OFF         = 33,
+	CEE_DUP_CONTROL_TLV_RCVD     = 34,
+	CEE_DUP_FEAT_TLV_RCVD        = 35,
+	CEE_APPLY_NEW_CFG            = 36,	/* reason, not an error */
+	CEE_PROTOCOL_INIT            = 37,  /* reason, not an error */
+	CEE_PHY_LINK_DOWN            = 38,
+	CEE_LLS_FCOE_ABSENT          = 39,
+	CEE_LLS_FCOE_DOWN            = 40
+};
+
+/**
+ *      Default Target Rate Limiting Speed.
+ */
+#define BFA_PPORT_DEF_TRL_SPEED  BFA_PPORT_SPEED_1GBPS
+
+/**
+ *      Physical port configuration
+ */
+struct bfa_pport_cfg_s {
+	u8         topology;	/*  bfa_pport_topology		*/
+	u8         speed;		/*  enum bfa_pport_speed	*/
+	u8         trunked;	/*  trunked or not		*/
+	u8         qos_enabled;	/*  qos enabled or not		*/
+	u8         trunk_ports;	/*  bitmap of trunked ports	*/
+	u8         cfg_hardalpa;	/*  is hard alpa configured	*/
+	u16        maxfrsize;	/*  maximum frame size		*/
+	u8         hardalpa;	/*  configured hard alpa	*/
+	u8         rx_bbcredit;	/*  receive buffer credits	*/
+	u8         tx_bbcredit;	/*  transmit buffer credits	*/
+	u8         ratelimit;	/*  ratelimit enabled or not	*/
+	u8         trl_def_speed;	/*  ratelimit default speed	*/
+	u8		rsvd[3];
+	u16   	path_tov;	/*  device path timeout	*/
+	u16   	q_depth;	/*  SCSI Queue depth		*/
+};
+
+/**
+ * 		Port attribute values.
+ */
+struct bfa_pport_attr_s {
+	/*
+	 * Static fields
+	 */
+	wwn_t           nwwn;		/*  node wwn */
+	wwn_t           pwwn;		/*  port wwn */
+	enum fc_cos     cos_supported;	/*  supported class of services */
+	u32        rsvd;
+	struct fc_symname_s    port_symname;	/*  port symbolic name */
+	enum bfa_pport_speed speed_supported; /*  supported speeds */
+	bfa_boolean_t   pbind_enabled;	/*  Will be set if Persistent binding
+					 *   enabled. Relevant only in Windows
+					 */
+
+	/*
+	 * Configured values
+	 */
+	struct bfa_pport_cfg_s pport_cfg;	/*  pport cfg */
+
+	/*
+	 * Dynamic field - info from BFA
+	 */
+	enum bfa_pport_states 	port_state;	/*  current port state */
+	enum bfa_pport_speed 	speed;		/*  current speed */
+	enum bfa_pport_topology 	topology;	/*  current topology */
+	bfa_boolean_t		beacon;		/*  current beacon status */
+	bfa_boolean_t		link_e2e_beacon;/*  set if link beacon on */
+	bfa_boolean_t		plog_enabled;	/*  set if portlog is enabled*/
+
+	/*
+	 * Dynamic field - info from FCS
+	 */
+	u32        	pid;		/*  port ID */
+	enum bfa_pport_type 	port_type;	/*  current topology */
+	u32        	loopback;	/*  external loopback */
+	u32		rsvd1;
+	u32		rsvd2;		/*  padding for 64 bit */
+};
+
+/**
+ * 		FC Port statistics.
+ */
+struct bfa_pport_fc_stats_s {
+	u64        secs_reset;	/*  seconds since stats is reset */
+	u64        tx_frames;	/*  transmitted frames */
+	u64        tx_words;	/*  transmitted words */
+	u64        rx_frames;	/*  received frames */
+	u64        rx_words;	/*  received words */
+	u64        lip_count;	/*  LIPs seen */
+	u64        nos_count;	/*  NOS count */
+	u64        error_frames;	/*  errored frames (sent?) */
+	u64        dropped_frames;	/*  dropped frames */
+	u64        link_failures;	/*  link failure count */
+	u64        loss_of_syncs;	/*  loss of sync count */
+	u64        loss_of_signals;/*  loss of signal count */
+	u64        primseq_errs;	/*  primitive sequence protocol */
+	u64        bad_os_count;	/*  invalid ordered set */
+	u64        err_enc_out;	/*  Encoding error outside frame */
+	u64        invalid_crcs;	/*  frames received with invalid CRC*/
+	u64	undersized_frm; /*  undersized frames */
+	u64	oversized_frm;	/*  oversized frames */
+	u64	bad_eof_frm;	/*  frames with bad EOF */
+	struct bfa_qos_stats_s	qos_stats;	/*  QoS statistics */
+};
+
+/**
+ * 		Eth Port statistics.
+ */
+struct bfa_pport_eth_stats_s {
+	u64	secs_reset;	/*  seconds since stats is reset */
+	u64	frame_64;      /*  both rx and tx counter */
+	u64	frame_65_127;      /* both rx and tx counter */
+	u64	frame_128_255;     /* both rx and tx counter */
+	u64	frame_256_511;     /* both rx and tx counter */
+	u64	frame_512_1023;    /* both rx and tx counter */
+	u64	frame_1024_1518;   /* both rx and tx counter */
+	u64	frame_1519_1522;   /* both rx and tx counter */
+
+	u64	tx_bytes;
+	u64	tx_packets;
+	u64	tx_mcast_packets;
+	u64	tx_bcast_packets;
+	u64	tx_control_frame;
+	u64	tx_drop;
+	u64	tx_jabber;
+	u64	tx_fcs_error;
+	u64	tx_fragments;
+
+	u64	rx_bytes;
+	u64	rx_packets;
+	u64	rx_mcast_packets;
+	u64	rx_bcast_packets;
+	u64	rx_control_frames;
+	u64	rx_unknown_opcode;
+	u64	rx_drop;
+	u64	rx_jabber;
+	u64	rx_fcs_error;
+	u64	rx_alignment_error;
+	u64	rx_frame_length_error;
+	u64	rx_code_error;
+	u64	rx_fragments;
+
+	u64	rx_pause; /* BPC */
+	u64	rx_zero_pause; /*  BPC Pause cancellation */
+	u64	tx_pause;      /* BPC */
+	u64	tx_zero_pause; /*  BPC Pause cancellation */
+	u64	rx_fcoe_pause; /* BPC */
+	u64	rx_fcoe_zero_pause; /*  BPC Pause cancellation */
+	u64	tx_fcoe_pause;      /* BPC */
+	u64	tx_fcoe_zero_pause; /*  BPC Pause cancellation */
+};
+
+/**
+ * 		Port statistics.
+ */
+union bfa_pport_stats_u {
+	struct bfa_pport_fc_stats_s	fc;
+	struct bfa_pport_eth_stats_s 	eth;
+};
+
+/**
+ *              Port FCP mappings.
+ */
+struct bfa_pport_fcpmap_s {
+	char		osdevname[256];
+	u32	bus;
+	u32        target;
+	u32        oslun;
+	u32        fcid;
+	wwn_t           nwwn;
+	wwn_t           pwwn;
+	u64        fcplun;
+	char		luid[256];
+};
+
+/**
+ *              Port RNID info.
+ */
+struct bfa_pport_rnid_s {
+	wwn_t             wwn;
+	u32          unittype;
+	u32          portid;
+	u32          attached_nodes_num;
+	u16          ip_version;
+	u16          udp_port;
+	u8           ipaddr[16];
+	u16          rsvd;
+	u16          topologydiscoveryflags;
+};
+
+/**
+ * 		Link state information
+ */
+struct bfa_pport_link_s {
+	u8         linkstate;	/*  Link state bfa_pport_linkstate */
+	u8         linkstate_rsn;	/*  bfa_pport_linkstate_rsn_t */
+	u8         topology;	/*  P2P/LOOP bfa_pport_topology */
+	u8         speed;		/*  Link speed (1/2/4/8 G) */
+	u32        linkstate_opt;	/*  Linkstate optional data (debug) */
+	u8         trunked;	/*  Trunked or not (1 or 0) */
+	u8         resvd[3];
+	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
+	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
+	union {
+		struct {
+			u8         tmaster;/*  Trunk Master or
+						 *    not (1 or 0) */
+			u8         tlinks;	/*  Trunk links bitmap
+						 *    (linkup) */
+			u8         resv1;	/*  Reserved */
+		} trunk_info;
+
+		struct {
+			u8         myalpa;	   /*  alpa claimed */
+			u8         login_req; /*  Login required or
+						    *    not (1 or 0) */
+			u8         alpabm_val;/*  alpa bitmap valid
+						    *    or not (1 or 0) */
+			struct fc_alpabm_s     alpabm;	   /*  alpa bitmap */
+		} loop_info;
+	} tl;
+};
+
+#endif /* __BFA_DEFS_PPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_qos.h patch/drivers/scsi/bfa/include/defs/bfa_defs_qos.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_qos.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_qos.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,99 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_QOS_H__
+#define __BFA_DEFS_QOS_H__
+
+/**
+ * QoS states
+ */
+enum bfa_qos_state {
+	BFA_QOS_ONLINE = 1,		/*  QoS is online */
+	BFA_QOS_OFFLINE = 2,		/*  QoS is offline */
+};
+
+
+/**
+ * QoS  Priority levels.
+ */
+enum bfa_qos_priority {
+	BFA_QOS_UNKNOWN = 0,
+	BFA_QOS_HIGH  = 1,	/*  QoS Priority Level High */
+	BFA_QOS_MED  =  2,	/*  QoS Priority Level Medium */
+	BFA_QOS_LOW  =  3,	/*  QoS Priority Level Low */
+};
+
+
+/**
+ * QoS  bandwidth allocation for each priority level
+ */
+enum bfa_qos_bw_alloc {
+	BFA_QOS_BW_HIGH  = 60,	/*  bandwidth allocation for High */
+	BFA_QOS_BW_MED  =  30,	/*  bandwidth allocation for Medium */
+	BFA_QOS_BW_LOW  =  10,	/*  bandwidth allocation for Low */
+};
+
+/**
+ * QoS attribute returned in QoS Query
+ */
+struct bfa_qos_attr_s {
+	enum bfa_qos_state state;		/*  QoS current state */
+	u32  total_bb_cr;  	 	/*  Total BB Credits */
+};
+
+/**
+ * These fields should be displayed only from the CLI.
+ * There will be a separate BFAL API (get_qos_vc_attr ?)
+ * to retrieve this.
+ *
+ */
+#define  BFA_QOS_MAX_VC  16
+
+struct bfa_qos_vc_info_s {
+	u8 vc_credit;
+	u8 borrow_credit;
+	u8 priority;
+	u8 resvd;
+};
+
+struct bfa_qos_vc_attr_s {
+	u16  total_vc_count;                    /*  Total VC Count */
+	u16  shared_credit;
+	u32  elp_opmode_flags;
+	struct bfa_qos_vc_info_s vc_info[BFA_QOS_MAX_VC];  /*   as many as
+							    * total_vc_count */
+};
+
+/**
+ * QoS statistics
+ */
+struct bfa_qos_stats_s {
+	u32	flogi_sent; 		/*  QoS Flogi sent */
+	u32	flogi_acc_recvd;	/*  QoS Flogi Acc received */
+	u32	flogi_rjt_recvd; /*  QoS Flogi rejects received */
+	u32	flogi_retries;		/*  QoS Flogi retries */
+
+	u32	elp_recvd; 	   	/*  QoS ELP received */
+	u32	elp_accepted;       /*  QoS ELP Accepted */
+	u32	elp_rejected;       /*  QoS ELP rejected */
+	u32	elp_dropped;        /*  QoS ELP dropped  */
+
+	u32	qos_rscn_recvd;     /*  QoS RSCN received */
+	u32	rsvd; 		/* padding for 64 bit alignment */
+};
+
+#endif /* __BFA_DEFS_QOS_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_rport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_rport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_rport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,199 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_RPORT_H__
+#define __BFA_DEFS_RPORT_H__
+
+#include <bfa_os_inc.h>
+#include <protocol/types.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_qos.h>
+
+/**
+ * FCS remote port states
+ */
+enum bfa_rport_state {
+	BFA_RPORT_UNINIT 	= 0,	/*  PORT is not yet initialized */
+	BFA_RPORT_OFFLINE 	= 1,	/*  rport is offline */
+	BFA_RPORT_PLOGI 	= 2,	/*  PLOGI to rport is in progress */
+	BFA_RPORT_ONLINE 	= 3,	/*  login to rport is complete */
+	BFA_RPORT_PLOGI_RETRY 	= 4,	/*  retrying login to rport */
+	BFA_RPORT_NSQUERY 	= 5,	/*  nameserver query */
+	BFA_RPORT_ADISC 	= 6,	/*  ADISC authentication */
+	BFA_RPORT_LOGO 		= 7,	/*  logging out with rport */
+	BFA_RPORT_LOGORCV 	= 8,	/*  handling LOGO from rport */
+	BFA_RPORT_NSDISC 	= 9,	/*  re-discover rport */
+};
+
+/**
+ *  Rport Scsi Function : Initiator/Target.
+ */
+enum bfa_rport_function {
+	BFA_RPORT_INITIATOR 	= 0x01,	/*  SCSI Initiator	*/
+	BFA_RPORT_TARGET 	= 0x02,	/*  SCSI Target	*/
+};
+
+/**
+ * port/node symbolic names for rport
+ */
+#define BFA_RPORT_SYMNAME_MAXLEN	255
+struct bfa_rport_symname_s {
+	char            symname[BFA_RPORT_SYMNAME_MAXLEN];
+};
+
+struct bfa_rport_hal_stats_s {
+	u32        sm_un_cr;	    /*  uninit: create events      */
+	u32        sm_un_unexp;	    /*  uninit: exception events   */
+	u32        sm_cr_on;	    /*  created: online events     */
+	u32        sm_cr_del;	    /*  created: delete events     */
+	u32        sm_cr_hwf;	    /*  created: IOC down          */
+	u32        sm_cr_unexp;	    /*  created: exception events  */
+	u32        sm_fwc_rsp;	    /*  fw create: f/w responses   */
+	u32        sm_fwc_del;	    /*  fw create: delete events   */
+	u32        sm_fwc_off;	    /*  fw create: offline events  */
+	u32        sm_fwc_hwf;	    /*  fw create: IOC down        */
+	u32        sm_fwc_unexp;	    /*  fw create: exception events*/
+	u32        sm_on_off;	    /*  online: offline events     */
+	u32        sm_on_del;	    /*  online: delete events      */
+	u32        sm_on_hwf;	    /*  online: IOC down events    */
+	u32        sm_on_unexp;	    /*  online: exception events   */
+	u32        sm_fwd_rsp;	    /*  fw delete: fw responses    */
+	u32        sm_fwd_del;	    /*  fw delete: delete events   */
+	u32        sm_fwd_hwf;	    /*  fw delete: IOC down events */
+	u32        sm_fwd_unexp;	    /*  fw delete: exception events*/
+	u32        sm_off_del;	    /*  offline: delete events     */
+	u32        sm_off_on;	    /*  offline: online events     */
+	u32        sm_off_hwf;	    /*  offline: IOC down events   */
+	u32        sm_off_unexp;	    /*  offline: exception events  */
+	u32        sm_del_fwrsp;	    /*  delete: fw responses       */
+	u32        sm_del_hwf;	    /*  delete: IOC down events    */
+	u32        sm_del_unexp;	    /*  delete: exception events   */
+	u32        sm_delp_fwrsp;	    /*  delete pend: fw responses  */
+	u32        sm_delp_hwf;	    /*  delete pend: IOC downs     */
+	u32        sm_delp_unexp;	    /*  delete pend: exceptions    */
+	u32        sm_offp_fwrsp;	    /*  off-pending: fw responses  */
+	u32        sm_offp_del;	    /*  off-pending: deletes       */
+	u32        sm_offp_hwf;	    /*  off-pending: IOC downs     */
+	u32        sm_offp_unexp;	    /*  off-pending: exceptions    */
+	u32        sm_iocd_off;	    /*  IOC down: offline events   */
+	u32        sm_iocd_del;	    /*  IOC down: delete events    */
+	u32        sm_iocd_on;	    /*  IOC down: online events    */
+	u32        sm_iocd_unexp;	    /*  IOC down: exceptions       */
+	u32        rsvd;
+};
+
+/**
+ * FCS remote port statistics
+ */
+struct bfa_rport_stats_s {
+	u32        offlines;           /*  remote port offline count  */
+	u32        onlines;            /*  remote port online count   */
+	u32        rscns;              /*  RSCN affecting rport       */
+	u32        plogis;		    /*  plogis sent                */
+	u32        plogi_accs;	    /*  plogi accepts              */
+	u32        plogi_timeouts;	    /*  plogi timeouts             */
+	u32        plogi_rejects;	    /*  rcvd plogi rejects         */
+	u32        plogi_failed;	    /*  local failure              */
+	u32        plogi_rcvd;	    /*  plogis rcvd                */
+	u32        prli_rcvd;          /*  inbound PRLIs              */
+	u32        adisc_rcvd;         /*  ADISCs received            */
+	u32        adisc_rejects;      /*  recvd  ADISC rejects       */
+	u32        adisc_sent;         /*  ADISC requests sent        */
+	u32        adisc_accs;         /*  ADISC accepted by rport    */
+	u32        adisc_failed;       /*  ADISC failed (no response) */
+	u32        adisc_rejected;     /*  ADISC rejected by us    */
+	u32        logos;              /*  logos sent                 */
+	u32        logo_accs;          /*  LOGO accepts from rport    */
+	u32        logo_failed;        /*  LOGO failures              */
+	u32        logo_rejected;      /*  LOGO rejects from rport    */
+	u32        logo_rcvd;          /*  LOGO from remote port      */
+
+	u32        rpsc_rcvd;         /*  RPSC received            */
+	u32        rpsc_rejects;      /*  recvd  RPSC rejects       */
+	u32        rpsc_sent;         /*  RPSC requests sent        */
+	u32        rpsc_accs;         /*  RPSC accepted by rport    */
+	u32        rpsc_failed;       /*  RPSC failed (no response) */
+	u32        rpsc_rejected;     /*  RPSC rejected by us    */
+
+	u32        rsvd;
+	struct bfa_rport_hal_stats_s	hal_stats;  /*  BFA rport stats    */
+};
+
+/**
+ *  Rport's QoS attributes
+ */
+struct bfa_rport_qos_attr_s {
+	enum bfa_qos_priority qos_priority;  /*  rport's QoS priority   */
+	u32	       qos_flow_id;	  /*  QoS flow Id	 */
+};
+
+/**
+ * FCS remote port attributes returned in queries
+ */
+struct bfa_rport_attr_s {
+	wwn_t           	nwwn;	/*  node wwn */
+	wwn_t           	pwwn;	/*  port wwn */
+	enum fc_cos cos_supported;	/*  supported class of services */
+	u32        	pid;	/*  port ID */
+	u32        	df_sz;	/*  Max payload size */
+	enum bfa_rport_state 	state;	/*  Rport State machine state */
+	enum fc_cos        	fc_cos;	/*  FC classes of services */
+	bfa_boolean_t   	cisc;	/*  CISC capable device */
+	struct bfa_rport_symname_s symname; /*  Symbolic Name */
+	enum bfa_rport_function	scsi_function; /*  Initiator/Target */
+	struct bfa_rport_qos_attr_s qos_attr; /*  qos attributes  */
+	enum bfa_pport_speed curr_speed;   /*  operating speed got from
+					    * RPSC ELS. UNKNOWN, if RPSC
+					    * is not supported */
+	bfa_boolean_t 	trl_enforced;	/*  TRL enforced ? TRUE/FALSE */
+	enum bfa_pport_speed	assigned_speed;	/* Speed assigned by the user.
+						 * will be used if RPSC is not
+						 * supported by the rport */
+};
+
+#define bfa_rport_aen_qos_data_t struct bfa_rport_qos_attr_s
+
+/**
+ * BFA remote port events
+ * Arguments below are in BFAL context from Mgmt
+ * BFA_RPORT_AEN_ONLINE:    [in]: lpwwn	[out]: vf_id, lpwwn, rpwwn
+ * BFA_RPORT_AEN_OFFLINE:   [in]: lpwwn [out]: vf_id, lpwwn, rpwwn
+ * BFA_RPORT_AEN_DISCONNECT:[in]: lpwwn [out]: vf_id, lpwwn, rpwwn
+ * BFA_RPORT_AEN_QOS_PRIO:  [in]: lpwwn [out]: vf_id, lpwwn, rpwwn, prio
+ * BFA_RPORT_AEN_QOS_FLOWID:[in]: lpwwn [out]: vf_id, lpwwn, rpwwn, flow_id
+ */
+enum bfa_rport_aen_event {
+	BFA_RPORT_AEN_ONLINE      = 1,	/*  RPort online event */
+	BFA_RPORT_AEN_OFFLINE     = 2,	/*  RPort offline event */
+	BFA_RPORT_AEN_DISCONNECT  = 3,	/*  RPort disconnect event */
+	BFA_RPORT_AEN_QOS_PRIO    = 4,	/*  QOS priority change event */
+	BFA_RPORT_AEN_QOS_FLOWID  = 5,	/*  QOS flow Id change event */
+};
+
+struct bfa_rport_aen_data_s {
+	u16        vf_id;	/*  vf_id of this logical port */
+	u16        rsvd[3];
+	wwn_t           ppwwn;	/*  WWN of its physical port */
+	wwn_t           lpwwn;	/*  WWN of this logical port */
+	wwn_t           rpwwn;	/*  WWN of this remote port */
+	union {
+		bfa_rport_aen_qos_data_t qos;
+	} priv;
+};
+
+#endif /* __BFA_DEFS_RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_status.h patch/drivers/scsi/bfa/include/defs/bfa_defs_status.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_status.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_status.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,255 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_STATUS_H__
+#define __BFA_DEFS_STATUS_H__
+
+/**
+ * API status return values
+ *
+ * NOTE: The error msgs are auto generated from the comments. Only singe line
+ * comments are supported
+ */
+enum bfa_status {
+	BFA_STATUS_OK 		= 0,	/*  Success */
+	BFA_STATUS_FAILED 	= 1,	/*  Operation failed */
+	BFA_STATUS_EINVAL 	= 2,	/*  Invalid params Check input
+					 * parameters */
+	BFA_STATUS_ENOMEM 	= 3,	/*  Out of resources */
+	BFA_STATUS_ENOSYS 	= 4,	/*  Function not implemented */
+	BFA_STATUS_ETIMER 	= 5,	/*  Timer expired - Retry, if
+					 * persists, contact support */
+	BFA_STATUS_EPROTOCOL 	= 6,	/*  Protocol error */
+	BFA_STATUS_ENOFCPORTS 	= 7,	/*  No FC ports resources */
+	BFA_STATUS_NOFLASH 	= 8,	/*  Flash not present */
+	BFA_STATUS_BADFLASH 	= 9,	/*  Flash is corrupted or bad */
+	BFA_STATUS_SFP_UNSUPP 	= 10,	/*  Unsupported SFP - Replace SFP */
+	BFA_STATUS_UNKNOWN_VFID = 11,	/*  VF_ID not found */
+	BFA_STATUS_DATACORRUPTED = 12,	/*  Diag returned data corrupted
+					 * contact support */
+	BFA_STATUS_DEVBUSY 	= 13,	/*  Device busy - Retry operation */
+	BFA_STATUS_ABORTED 	= 14,	/*  Operation aborted */
+	BFA_STATUS_NODEV 	= 15,	/*  Dev is not present */
+	BFA_STATUS_HDMA_FAILED 	= 16,	/*  Host dma failed contact support */
+	BFA_STATUS_FLASH_BAD_LEN = 17,	/*  Flash bad length */
+	BFA_STATUS_UNKNOWN_LWWN = 18,	/*  LPORT PWWN not found */
+	BFA_STATUS_UNKNOWN_RWWN = 19,	/*  RPORT PWWN not found */
+	BFA_STATUS_FCPT_LS_RJT 	= 20,	/*  Got LS_RJT for FC Pass
+					 * through Req */
+	BFA_STATUS_VPORT_EXISTS = 21,	/*  VPORT already exists */
+	BFA_STATUS_VPORT_MAX 	= 22,	/*  Reached max VPORT supported
+					 * limit */
+	BFA_STATUS_UNSUPP_SPEED = 23,	/*  Invalid Speed Check speed
+					 * setting */
+	BFA_STATUS_INVLD_DFSZ 	= 24,	/*  Invalid Max data field size */
+	BFA_STATUS_CNFG_FAILED 	= 25,	/*  Setting can not be persisted */
+	BFA_STATUS_CMD_NOTSUPP 	= 26,	/*  Command/API not supported */
+	BFA_STATUS_NO_ADAPTER 	= 27,	/*  No Brocade Adapter Found */
+	BFA_STATUS_LINKDOWN 	= 28,	/*  Link is down - Check or replace
+					 * SFP/cable */
+	BFA_STATUS_FABRIC_RJT 	= 29,	/*  Reject from attached fabric */
+	BFA_STATUS_UNKNOWN_VWWN = 30,	/*  VPORT PWWN not found */
+	BFA_STATUS_NSLOGIN_FAILED = 31,	/*  Nameserver login failed */
+	BFA_STATUS_NO_RPORTS 	= 32,	/*  No remote ports found */
+	BFA_STATUS_NSQUERY_FAILED = 33,	/*  Nameserver query failed */
+	BFA_STATUS_PORT_OFFLINE = 34,	/*  Port is not online */
+	BFA_STATUS_RPORT_OFFLINE = 35,	/*  RPORT is not online */
+	BFA_STATUS_TGTOPEN_FAILED = 36,	/*  Remote SCSI target open failed */
+	BFA_STATUS_BAD_LUNS 	= 37,	/*  No valid LUNs found */
+	BFA_STATUS_IO_FAILURE 	= 38,	/*  SCSI target IO failure */
+	BFA_STATUS_NO_FABRIC 	= 39,	/*  No switched fabric present */
+	BFA_STATUS_EBADF 	= 40,	/*  Bad file descriptor */
+	BFA_STATUS_EINTR 	= 41,	/*  A signal was caught during ioctl */
+	BFA_STATUS_EIO 		= 42,	/*  I/O error */
+	BFA_STATUS_ENOTTY 	= 43,	/*  Inappropriate I/O control
+					 * operation */
+	BFA_STATUS_ENXIO 	= 44,	/*  No such device or address */
+	BFA_STATUS_EFOPEN 	= 45,	/*  Failed to open file */
+	BFA_STATUS_VPORT_WWN_BP = 46,	/*  WWN is same as base port's WWN */
+	BFA_STATUS_PORT_NOT_DISABLED = 47, /*  Port not disabled disable port
+					    * first */
+	BFA_STATUS_BADFRMHDR 	= 48,	/*  Bad frame header */
+	BFA_STATUS_BADFRMSZ 	= 49,	/*  Bad frame size check and replace
+					 * SFP/cable */
+	BFA_STATUS_MISSINGFRM 	= 50,	/*  Missing frame check and replace
+					 * SFP/cable */
+	BFA_STATUS_LINKTIMEOUT 	= 51,	/*  Link timeout check and replace
+					 * SFP/cable */
+	BFA_STATUS_NO_FCPIM_NEXUS = 52,	/*  No FCP Nexus exists with the
+					 * rport */
+	BFA_STATUS_CHECKSUM_FAIL = 53,	/*  checksum failure */
+	BFA_STATUS_GZME_FAILED 	= 54,	/*  Get zone member query failed */
+	BFA_STATUS_SCSISTART_REQD = 55,	/*  SCSI disk require START command */
+	BFA_STATUS_IOC_FAILURE 	= 56,	/*  IOC failure - Retry, if persists
+					 * contact support */
+	BFA_STATUS_INVALID_WWN 	= 57,	/*  Invalid WWN */
+	BFA_STATUS_MISMATCH 	= 58,	/*  Version mismatch */
+	BFA_STATUS_IOC_ENABLED 	= 59,	/*  IOC is already enabled */
+	BFA_STATUS_ADAPTER_ENABLED = 60, /*  Adapter is not disabled disable
+					  * adapter first */
+	BFA_STATUS_IOC_NON_OP 	= 61,	/*  IOC is not operational. Enable IOC
+					 * and if it still fails,
+					 * contact support */
+	BFA_STATUS_ADDR_MAP_FAILURE = 62, /*  PCI base address not mapped
+					   * in OS */
+	BFA_STATUS_SAME_NAME 	= 63,	/*  Name exists! use a different
+					 * name */
+	BFA_STATUS_PENDING      = 64,   /*  API completes asynchronously */
+	BFA_STATUS_8G_SPD	= 65,	/*  Speed setting not valid for
+					 * 8G HBA */
+	BFA_STATUS_4G_SPD	= 66,	/*  Speed setting not valid for
+					 * 4G HBA */
+	BFA_STATUS_AD_IS_ENABLE = 67,	/*  Adapter is already enabled */
+	BFA_STATUS_EINVAL_TOV 	= 68,	/*  Invalid path failover TOV */
+	BFA_STATUS_EINVAL_QDEPTH = 69,	/*  Invalid queue depth value */
+	BFA_STATUS_VERSION_FAIL = 70,	/*  Application/Driver version
+					 * mismatch */
+	BFA_STATUS_DIAG_BUSY    = 71,	/*  diag busy */
+	BFA_STATUS_BEACON_ON	= 72,	/*  Port Beacon already on */
+	BFA_STATUS_BEACON_OFF	= 73,	/*  Port Beacon already off */
+	BFA_STATUS_LBEACON_ON   = 74,	/*  Link End-to-End Beacon already
+					 * on */
+	BFA_STATUS_LBEACON_OFF	= 75,	/*  Link End-to-End Beacon already
+					 * off */
+	BFA_STATUS_PORT_NOT_INITED = 76, /*  Port not initialized */
+	BFA_STATUS_RPSC_ENABLED = 77, /*  Target has a valid speed */
+	BFA_STATUS_ENOFSAVE = 78,	/*  No saved firmware trace */
+	BFA_STATUS_BAD_FILE = 79,	/*  Not a valid Brocade Boot Code
+					 * file */
+	BFA_STATUS_RLIM_EN = 80,	/*  Target rate limiting is already
+					 * enabled */
+	BFA_STATUS_RLIM_DIS = 81,  /*  Target rate limiting is already
+				    * disabled */
+	BFA_STATUS_IOC_DISABLED = 82,   /*  IOC is already disabled */
+	BFA_STATUS_ADAPTER_DISABLED = 83,   /*  Adapter is already disabled */
+	BFA_STATUS_BIOS_DISABLED = 84,   /*  Bios is already disabled */
+	BFA_STATUS_AUTH_ENABLED = 85,   /*  Authentication is already
+					 * enabled */
+	BFA_STATUS_AUTH_DISABLED = 86,   /*  Authentication is already
+					 * disabled */
+	BFA_STATUS_ERROR_TRL_ENABLED = 87,   /*  Target rate limiting is
+					      * enabled */
+	BFA_STATUS_ERROR_QOS_ENABLED = 88,   /*  QoS is enabled */
+	BFA_STATUS_NO_SFP_DEV = 89, /*  No SFP device check or replace SFP */
+	BFA_STATUS_MEMTEST_FAILED = 90,	/*  Memory test failed contact
+					 * support */
+	BFA_STATUS_INVALID_DEVID = 91,	/*  Invalid device id provided */
+	BFA_STATUS_QOS_ENABLED = 92, /*  QOS is already enabled */
+	BFA_STATUS_QOS_DISABLED = 93, /*  QOS is already disabled */
+	BFA_STATUS_INCORRECT_DRV_CONFIG = 94, /*  Check configuration
+					       * key/value pair */
+	BFA_STATUS_REG_FAIL = 95, /*  Can't read windows registry */
+	BFA_STATUS_IM_INV_CODE = 96, /*  Invalid IOCTL code */
+	BFA_STATUS_IM_INV_VLAN = 97, /*  Invalid VLAN ID */
+	BFA_STATUS_IM_INV_ADAPT_NAME = 98, /*  Invalid adapter name */
+	BFA_STATUS_IM_LOW_RESOURCES = 99, /*  Memory allocation failure in
+					   * driver */
+	BFA_STATUS_IM_VLANID_IS_PVID = 100, /*  Given VLAN id same as PVID */
+	BFA_STATUS_IM_VLANID_EXISTS = 101, /*  Given VLAN id already exists */
+	BFA_STATUS_IM_FW_UPDATE_FAIL = 102, /*  Updating firmware with new
+					     * VLAN ID failed */
+	BFA_STATUS_PORTLOG_ENABLED = 103, /*  Port Log is already enabled */
+	BFA_STATUS_PORTLOG_DISABLED = 104, /*  Port Log is already disabled */
+	BFA_STATUS_FILE_NOT_FOUND = 105, /*  Specified file could not be
+					  * found */
+	BFA_STATUS_QOS_FC_ONLY = 106, /*  QOS can be enabled for FC mode
+				       * only */
+	BFA_STATUS_RLIM_FC_ONLY = 107, /*  RATELIM can be enabled for FC mode
+					* only */
+	BFA_STATUS_CT_SPD = 108, /*  Invalid speed selection for Catapult. */
+	BFA_STATUS_LEDTEST_OP = 109, /*  LED test is operating */
+	BFA_STATUS_CEE_NOT_DN = 110, /*  eth port is not at down state, please
+				      * bring down first */
+	BFA_STATUS_10G_SPD = 111, /*  Speed setting not valid for 10G HBA */
+	BFA_STATUS_IM_INV_TEAM_NAME = 112, /*  Invalid team name */
+	BFA_STATUS_IM_DUP_TEAM_NAME = 113, /*  Given team name already
+					    * exists */
+	BFA_STATUS_IM_ADAPT_ALREADY_IN_TEAM = 114, /*  Given adapter is part
+						    * of another team */
+	BFA_STATUS_IM_ADAPT_HAS_VLANS = 115, /*  Adapter has VLANs configured.
+					      * Delete all VLANs before
+					      * creating team */
+	BFA_STATUS_IM_PVID_MISMATCH = 116, /*  Mismatching PVIDs configured
+					    * for adapters */
+	BFA_STATUS_IM_LINK_SPEED_MISMATCH = 117, /*  Mismatching link speeds
+						  * configured for adapters */
+	BFA_STATUS_IM_MTU_MISMATCH = 118, /*  Mismatching MTUs configured for
+					   * adapters */
+	BFA_STATUS_IM_RSS_MISMATCH = 119, /*  Mismatching RSS parameters
+					   * configured for adapters */
+	BFA_STATUS_IM_HDS_MISMATCH = 120, /*  Mismatching HDS parameters
+					   * configured for adapters */
+	BFA_STATUS_IM_OFFLOAD_MISMATCH = 121, /*  Mismatching offload
+					       * parameters configured for
+					       * adapters */
+	BFA_STATUS_IM_PORT_PARAMS = 122, /*  Error setting port parameters */
+	BFA_STATUS_IM_PORT_NOT_IN_TEAM = 123, /*  Port is not part of team */
+	BFA_STATUS_IM_CANNOT_REM_PRI = 124, /*  Primary adapter cannot be
+					     * removed. Change primary before
+					     * removing */
+	BFA_STATUS_IM_MAX_PORTS_REACHED = 125, /*  Exceeding maximum ports
+						* per team */
+	BFA_STATUS_IM_LAST_PORT_DELETE = 126, /*  Last port in team being
+					       * deleted */
+	BFA_STATUS_IM_NO_DRIVER = 127, /*  IM driver is not installed */
+	BFA_STATUS_IM_MAX_VLANS_REACHED = 128, /*  Exceeding maximum VLANs
+						* per port */
+	BFA_STATUS_TOMCAT_SPD_NOT_ALLOWED = 129, /* Bios speed config not
+						  * allowed for CNA */
+	BFA_STATUS_NO_MINPORT_DRIVER = 130, /*  Miniport driver is not
+					     * loaded */
+	BFA_STATUS_CARD_TYPE_MISMATCH = 131, /*  Card type mismatch */
+	BFA_STATUS_BAD_ASICBLK = 132, /*  Bad ASIC block */
+	BFA_STATUS_NO_DRIVER = 133, /*  Storage/Ethernet driver not loaded */
+	BFA_STATUS_INVALID_MAC = 134, /*  Invalid mac address */
+	BFA_STATUS_IM_NO_VLAN = 135, /*  No VLANs configured on the adapter */
+	BFA_STATUS_IM_ETH_LB_FAILED = 136, /*  Ethernet loopback test failed */
+	BFA_STATUS_IM_PVID_REMOVE = 137, /*  Cannot remove port vlan (PVID) */
+	BFA_STATUS_IM_PVID_EDIT = 138, /*  Cannot edit port vlan (PVID) */
+	BFA_STATUS_CNA_NO_BOOT = 139, /*  Boot upload not allowed for CNA */
+	BFA_STATUS_IM_PVID_NON_ZERO = 140, /*  Port VLAN ID (PVID) is Set to
+					    * Non-Zero Value */
+	BFA_STATUS_IM_INETCFG_LOCK_FAILED = 141, /*  Acquiring Network
+						  * Subsytem Lock Failed.Please
+						  * try after some time */
+	BFA_STATUS_IM_GET_INETCFG_FAILED = 142, /*  Acquiring Network Subsytem
+						 * handle Failed. Please try
+						 * after some time */
+	BFA_STATUS_IM_NOT_BOUND = 143, /*  Brocade 10G Ethernet Service is not
+					* Enabled on this port */
+	BFA_STATUS_INSUFFICIENT_PERMS = 144, /*  User doesn't have sufficient
+					      * permissions to execute the BCU
+					      * application */
+	BFA_STATUS_IM_INV_VLAN_NAME = 145, /*  Invalid/Reserved Vlan name
+					    * string. The name is not allowed
+					    * for the normal Vlans */
+	BFA_STATUS_CMD_NOTSUPP_CNA = 146, /*  Command not supported for CNA */
+	BFA_STATUS_IM_PASSTHRU_EDIT = 147, /*  Can not edit passthru vlan id */
+	BFA_STATUS_IM_BIND_FAILED = 148, /*! < IM Driver bind operation
+					  * failed */
+	BFA_STATUS_IM_UNBIND_FAILED = 149, /* ! < IM Driver unbind operation
+					    * failed */
+	BFA_STATUS_MAX_VAL		/*  Unknown error code */
+};
+#define bfa_status_t enum bfa_status
+
+enum bfa_eproto_status {
+	BFA_EPROTO_BAD_ACCEPT = 0,
+	BFA_EPROTO_UNKNOWN_RSP = 1
+};
+#define bfa_eproto_status_t enum bfa_eproto_status
+
+#endif /* __BFA_DEFS_STATUS_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_tin.h patch/drivers/scsi/bfa/include/defs/bfa_defs_tin.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_tin.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_tin.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,118 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_TIN_H__
+#define __BFA_DEFS_TIN_H__
+
+#include <protocol/types.h>
+#include <protocol/fc.h>
+
+/**
+ * FCS tin states
+ */
+enum bfa_tin_state_e {
+	BFA_TIN_SM_OFFLINE = 0,		/*  tin is offline */
+	BFA_TIN_SM_WOS_LOGIN = 1,	/*  Waiting PRLI ACC/RJT from ULP */
+	BFA_TIN_SM_WFW_ONLINE = 2,	/*  Waiting ACK to PRLI ACC from FW */
+	BFA_TIN_SM_ONLINE = 3,		/*  tin login is complete */
+	BFA_TIN_SM_WIO_RELOGIN = 4,	/*  tin relogin is in progress */
+	BFA_TIN_SM_WIO_LOGOUT = 5,	/*  Processing of PRLO req from
+					 *   Initiator is in progress
+					 */
+	BFA_TIN_SM_WOS_LOGOUT = 6,	/*  Processing of PRLO req from
+					 *   Initiator is in progress
+					 */
+	BFA_TIN_SM_WIO_CLEAN = 7,	/*  Waiting for IO cleanup before tin
+					 *   is offline. This can be triggered
+					 *   by RPORT LOGO (rcvd/sent) or by
+					 *   PRLO (rcvd/sent)
+					 */
+};
+
+struct bfa_prli_req_s {
+	struct fchs_s fchs;
+	struct fc_prli_s prli_payload;
+};
+
+struct bfa_prlo_req_s {
+	struct fchs_s fchs;
+	struct fc_prlo_s prlo_payload;
+};
+
+void bfa_tin_send_login_rsp(void *bfa_tin, u32 login_rsp,
+				struct fc_ls_rjt_s rjt_payload);
+void bfa_tin_send_logout_rsp(void *bfa_tin, u32 logout_rsp,
+				struct fc_ls_rjt_s rjt_payload);
+/**
+ * FCS target port statistics
+ */
+struct bfa_tin_stats_s {
+	u32 onlines;	/*  ITN nexus onlines (PRLI done) */
+	u32 offlines;	/*  ITN Nexus offlines 	*/
+	u32 prli_req_parse_err;	/*  prli req parsing errors */
+	u32 prli_rsp_rjt;	/*  num prli rsp rejects sent */
+	u32 prli_rsp_acc;	/*  num prli rsp accepts sent */
+	u32 cleanup_comps;	/*  ITN cleanup completions */
+};
+
+/**
+ * FCS tin attributes returned in queries
+ */
+struct bfa_tin_attr_s {
+	enum bfa_tin_state_e state;
+	u8	seq_retry;    /*  Sequence retry supported      */
+	u8	rsvd[3];
+};
+
+/**
+ * BFA TIN async event data structure for BFAL
+ */
+enum bfa_tin_aen_event {
+	BFA_TIN_AEN_ONLINE 	= 1,	/*  Target online */
+	BFA_TIN_AEN_OFFLINE 	= 2,	/*  Target offline */
+	BFA_TIN_AEN_DISCONNECT	= 3,	/*  Target disconnected */
+};
+
+/**
+ * BFA TIN event data structure.
+ */
+struct bfa_tin_aen_data_s {
+	u16 vf_id;	/*  vf_id of the IT nexus */
+	u16 rsvd[3];
+	wwn_t lpwwn;	/*  WWN of logical port */
+	wwn_t rpwwn;	/*  WWN of remote(target) port */
+};
+
+/**
+ * Below APIs are needed from BFA driver
+ * Move these to BFA driver public header file?
+ */
+/*  TIN rcvd new PRLI & gets bfad_tin_t ptr from driver this callback */
+void *bfad_tin_rcvd_login_req(void *bfad_tm_port, void *bfa_tin,
+				wwn_t rp_wwn, u32 rp_fcid,
+				struct bfa_prli_req_s prli_req);
+/*  TIN rcvd new PRLO */
+void bfad_tin_rcvd_logout_req(void *bfad_tin, wwn_t rp_wwn, u32 rp_fcid,
+				struct bfa_prlo_req_s prlo_req);
+/*  TIN is online and ready for IO */
+void bfad_tin_online(void *bfad_tin);
+/*  TIN is offline and BFA driver can shutdown its upper stack */
+void bfad_tin_offline(void *bfad_tin);
+/*  TIN does not need this BFA driver tin tag anymore, so can be freed */
+void bfad_tin_res_free(void *bfad_tin);
+
+#endif /* __BFA_DEFS_TIN_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h patch/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_TSENSOR_H__
+#define __BFA_DEFS_TSENSOR_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_types.h>
+
+/**
+ * Temperature sensor status values
+ */
+enum bfa_tsensor_status {
+	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unkown status */
+	BFA_TSENSOR_STATUS_FAULTY    = 2,   /*  sensor is faulty */
+	BFA_TSENSOR_STATUS_BELOW_MIN = 3,   /*  temperature below mininum */
+	BFA_TSENSOR_STATUS_NOMINAL   = 4,   /*  normal temperature */
+	BFA_TSENSOR_STATUS_ABOVE_MAX = 5,   /*  temperature above maximum */
+};
+
+/**
+ * Temperature sensor attribute
+ */
+struct bfa_tsensor_attr_s {
+	enum bfa_tsensor_status status;	/*  temperature sensor status */
+	u32        	value;	/*  current temperature in celsius */
+};
+
+#endif /* __BFA_DEFS_TSENSOR_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_types.h patch/drivers/scsi/bfa/include/defs/bfa_defs_types.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_types.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_types.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_TYPES_H__
+#define __BFA_DEFS_TYPES_H__
+
+#include <bfa_os_inc.h>
+
+enum bfa_boolean {
+	BFA_FALSE = 0,
+	BFA_TRUE  = 1
+};
+#define bfa_boolean_t enum bfa_boolean
+
+#define BFA_STRING_32	32
+
+#endif /* __BFA_DEFS_TYPES_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_version.h patch/drivers/scsi/bfa/include/defs/bfa_defs_version.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_version.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_version.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_VERSION_H__
+#define __BFA_DEFS_VERSION_H__
+
+#define BFA_VERSION_LEN		64
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_vf.h patch/drivers/scsi/bfa/include/defs/bfa_defs_vf.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_vf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_vf.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,74 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_VF_H__
+#define __BFA_DEFS_VF_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_port.h>
+#include <protocol/types.h>
+
+/**
+ * VF states
+ */
+enum bfa_vf_state {
+	BFA_VF_UNINIT    = 0,	/*  fabric is not yet initialized */
+	BFA_VF_LINK_DOWN = 1,	/*  link is down */
+	BFA_VF_FLOGI     = 2,	/*  flogi is in progress */
+	BFA_VF_AUTH      = 3,	/*  authentication in progress */
+	BFA_VF_NOFABRIC  = 4,	/*  fabric is not present */
+	BFA_VF_ONLINE    = 5,	/*  login to fabric is complete */
+	BFA_VF_EVFP      = 6,	/*  EVFP is in progress */
+	BFA_VF_ISOLATED  = 7,	/*  port isolated due to vf_id mismatch */
+};
+
+/**
+ * VF statistics
+ */
+struct bfa_vf_stats_s {
+	u32        flogi_sent;	/*  Num FLOGIs sent 		*/
+	u32        flogi_rsp_err;	/*  FLOGI response errors 	*/
+	u32        flogi_acc_err;	/*  FLOGI accept errors 	*/
+	u32        flogi_accepts;	/*  FLOGI accepts received 	*/
+	u32        flogi_rejects;	/*  FLOGI rejects received 	*/
+	u32        flogi_unknown_rsp; /*  Unknown responses for FLOGI */
+	u32        flogi_alloc_wait; /*  Allocation waits prior to
+					   * sending FLOGI
+					   */
+	u32        flogi_rcvd;	/*  FLOGIs received */
+	u32        flogi_rejected;	/*  Incoming FLOGIs rejected */
+	u32        fabric_onlines;	/*  Internal fabric online
+					 * notification sent to other
+					 * modules
+					 */
+	u32        fabric_offlines; /*  Internal fabric offline
+					  * notification sent to other
+					  * modules
+					  */
+	u32        resvd;
+};
+
+/**
+ * VF attributes returned in queries
+ */
+struct bfa_vf_attr_s {
+	enum bfa_vf_state  state;		/*  VF state */
+	u32        rsvd;
+	wwn_t           fabric_name;	/*  fabric name */
+};
+
+#endif /* __BFA_DEFS_VF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/defs/bfa_defs_vport.h patch/drivers/scsi/bfa/include/defs/bfa_defs_vport.h
--- orig/drivers/scsi/bfa/include/defs/bfa_defs_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/defs/bfa_defs_vport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,91 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DEFS_VPORT_H__
+#define __BFA_DEFS_VPORT_H__
+
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_port.h>
+#include <protocol/types.h>
+
+/**
+ * VPORT states
+ */
+enum bfa_vport_state {
+	BFA_FCS_VPORT_UNINIT 		= 0,
+	BFA_FCS_VPORT_CREATED 		= 1,
+	BFA_FCS_VPORT_OFFLINE 		= 1,
+	BFA_FCS_VPORT_FDISC_SEND 	= 2,
+	BFA_FCS_VPORT_FDISC 		= 3,
+	BFA_FCS_VPORT_FDISC_RETRY 	= 4,
+	BFA_FCS_VPORT_ONLINE 		= 5,
+	BFA_FCS_VPORT_DELETING 		= 6,
+	BFA_FCS_VPORT_CLEANUP 		= 6,
+	BFA_FCS_VPORT_LOGO_SEND 	= 7,
+	BFA_FCS_VPORT_LOGO 			= 8,
+	BFA_FCS_VPORT_ERROR			= 9,
+	BFA_FCS_VPORT_MAX_STATE,
+};
+
+/**
+ * vport statistics
+ */
+struct bfa_vport_stats_s {
+	struct bfa_port_stats_s port_stats;	/*  base class (port) stats */
+	/*
+	 * TODO - remove
+	 */
+
+	u32        fdisc_sent;	/*  num fdisc sent */
+	u32        fdisc_accepts;	/*  fdisc accepts */
+	u32        fdisc_retries;	/*  fdisc retries */
+	u32        fdisc_timeouts;	/*  fdisc timeouts */
+	u32        fdisc_rsp_err;	/*  fdisc response error */
+	u32        fdisc_acc_bad;	/*  bad fdisc accepts */
+	u32        fdisc_rejects;	/*  fdisc rejects */
+	u32        fdisc_unknown_rsp;
+	/*
+	 *!< fdisc rsp unknown error
+	 */
+	u32        fdisc_alloc_wait;/*  fdisc req (fcxp)alloc wait */
+
+	u32        logo_alloc_wait;/*  logo req (fcxp) alloc wait */
+	u32        logo_sent;	/*  logo sent */
+	u32        logo_accepts;	/*  logo accepts */
+	u32        logo_rejects;	/*  logo rejects */
+	u32        logo_rsp_err;	/*  logo rsp errors */
+	u32        logo_unknown_rsp;
+			/*  logo rsp unknown errors */
+
+	u32        fab_no_npiv;	/*  fabric does not support npiv */
+
+	u32        fab_offline;	/*  offline events from fab SM */
+	u32        fab_online;	/*  online events from fab SM */
+	u32        fab_cleanup;	/*  cleanup request from fab SM */
+	u32        rsvd;
+};
+
+/**
+ * BFA vport attribute returned in queries
+ */
+struct bfa_vport_attr_s {
+	struct bfa_port_attr_s   port_attr; /*  base class (port) attributes */
+	enum bfa_vport_state vport_state; /*  vport state */
+	u32          rsvd;
+};
+
+#endif /* __BFA_DEFS_VPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcb/bfa_fcb.h patch/drivers/scsi/bfa/include/fcb/bfa_fcb.h
--- orig/drivers/scsi/bfa/include/fcb/bfa_fcb.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcb/bfa_fcb.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcb.h BFA FCS callback interfaces
+ */
+
+#ifndef __BFA_FCB_H__
+#define __BFA_FCB_H__
+
+/**
+ *  fcb Main fcs callbacks
+ */
+
+void bfa_fcb_exit(struct bfad_s *bfad);
+
+
+
+#endif /* __BFA_FCB_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h patch/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h
--- orig/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+* : bfad_fcpim.h - BFA FCS initiator mode remote port callbacks
+ */
+
+#ifndef __BFAD_FCB_FCPIM_H__
+#define __BFAD_FCB_FCPIM_H__
+
+struct bfad_itnim_s;
+
+/*
+ * RPIM callbacks
+ */
+
+/**
+ * 	Memory allocation for remote port instance. Called before PRLI is
+ * 	initiated to the remote target port.
+ *
+ * @param[in] bfad		- driver instance
+ * @param[out] itnim		- FCS remote port (IM) instance
+ * @param[out] itnim_drv	- driver remote port (IM) instance
+ *
+ * @return None
+ */
+void bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
+				    struct bfad_itnim_s **itnim_drv);
+
+/**
+ * 		Free remote port (IM) instance.
+ *
+ * @param[in] bfad	- driver instance
+ * @param[in] itnim_drv	- driver remote port instance
+ *
+ * @return None
+ */
+void            bfa_fcb_itnim_free(struct bfad_s *bfad,
+				   struct bfad_itnim_s *itnim_drv);
+
+/**
+ * 	Notification of when login with a remote target device is complete.
+ *
+ * @param[in] itnim_drv	- driver remote port instance
+ *
+ * @return None
+ */
+void            bfa_fcb_itnim_online(struct bfad_itnim_s *itnim_drv);
+
+/**
+ * 	Notification when login with the remote device is severed.
+ *
+ * @param[in] itnim_drv	- driver remote port instance
+ *
+ * @return None
+ */
+void            bfa_fcb_itnim_offline(struct bfad_itnim_s *itnim_drv);
+
+void            bfa_fcb_itnim_tov_begin(struct bfad_itnim_s *itnim_drv);
+void            bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim_drv);
+
+#endif /* __BFAD_FCB_FCPIM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcb/bfa_fcb_port.h patch/drivers/scsi/bfa/include/fcb/bfa_fcb_port.h
--- orig/drivers/scsi/bfa/include/fcb/bfa_fcb_port.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcb/bfa_fcb_port.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcb_port.h BFA FCS virtual port driver interfaces
+ */
+
+#ifndef __BFA_FCB_PORT_H__
+#define __BFA_FCB_PORT_H__
+
+#include <fcb/bfa_fcb_vport.h>
+/**
+ *  fcs_port_fcb FCS port driver interfaces
+ */
+
+/*
+ * Forward declarations
+ */
+struct bfad_port_s;
+
+/*
+ * Callback functions from BFA FCS to driver
+ */
+
+/**
+ * 	Call from FCS to driver module when a port is instantiated. The port
+ * 	can be a base port or a virtual port with in the base fabric or
+ * 	a virtual fabric.
+ *
+ *  On this callback, driver is supposed to create scsi_host, scsi_tgt or
+ *  network interfaces bases on ports personality/roles.
+ *
+ *      base port of base fabric:	vf_drv == NULL && vp_drv == NULL
+ *      vport of base fabric:		vf_drv == NULL && vp_drv != NULL
+ *      base port of VF:		vf_drv != NULL && vp_drv == NULL
+ *      vport of VF:			vf_drv != NULL && vp_drv != NULL
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] port   - FCS port instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+struct bfad_port_s *bfa_fcb_port_new(struct bfad_s *bfad,
+			struct bfa_fcs_port_s *port,
+			enum bfa_port_role roles, struct bfad_vf_s *vf_drv,
+			struct bfad_vport_s *vp_drv);
+
+/**
+ * 	Call from FCS to driver module when a port is deleted. The port
+ * 	can be a base port or a virtual port with in the base fabric or
+ * 	a virtual fabric.
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+void bfa_fcb_port_delete(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv);
+
+/**
+ * 	Notification when port transitions to ONLINE state.
+ *
+ * Online notification is a logical link up for the local port. This
+ * notification is sent after a successfull FLOGI, or a successful
+ * link initialization in proviate-loop or N2N topologies.
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+void bfa_fcb_port_online(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv);
+
+/**
+ * 	Notification when port transitions to OFFLINE state.
+ *
+ * Offline notification is a logical link down for the local port.
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+void bfa_fcb_port_offline(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv);
+
+
+#endif /* __BFA_FCB_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h patch/drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h
--- orig/drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,80 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcb_rport.h BFA FCS rport driver interfaces
+ */
+
+#ifndef __BFA_FCB_RPORT_H__
+#define __BFA_FCB_RPORT_H__
+
+/**
+ *  fcs_rport_fcb Remote port driver interfaces
+ */
+
+
+struct bfad_rport_s;
+
+/*
+ * Callback functions from BFA FCS to driver
+ */
+
+/**
+ * 	Completion callback for bfa_fcs_rport_add().
+ *
+ * @param[in] rport_drv - driver instance of rport
+ *
+ * @return None
+ */
+void bfa_fcb_rport_add(struct bfad_rport_s *rport_drv);
+
+/**
+ * 	Completion callback for bfa_fcs_rport_remove().
+ *
+ * @param[in] rport_drv - driver instance of rport
+ *
+ * @return None
+ */
+void bfa_fcb_rport_remove(struct bfad_rport_s *rport_drv);
+
+/**
+ * 		Call to allocate a rport instance.
+ *
+ * @param[in] bfad - driver instance
+ * @param[out] rport - BFA FCS instance of rport
+ * @param[out] rport_drv - driver instance of rport
+ *
+ * @retval BFA_STATUS_OK - successfully allocated
+ * @retval BFA_STATUS_ENOMEM - cannot allocate
+ */
+bfa_status_t bfa_fcb_rport_alloc(struct bfad_s *bfad,
+			struct bfa_fcs_rport_s **rport,
+			struct bfad_rport_s **rport_drv);
+
+/**
+ * 	Call to free rport memory resources.
+ *
+ * @param[in] bfad - driver instance
+ * @param[in] rport_drv - driver instance of rport
+ *
+ * @return None
+ */
+void bfa_fcb_rport_free(struct bfad_s *bfad, struct bfad_rport_s **rport_drv);
+
+
+
+#endif /* __BFA_FCB_RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h patch/drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h
--- orig/drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcb_vf.h BFA FCS virtual fabric driver interfaces
+ */
+
+#ifndef __BFA_FCB_VF_H__
+#define __BFA_FCB_VF_H__
+
+/**
+ *  fcs_vf_fcb Virtual fabric driver intrefaces
+ */
+
+
+struct bfad_vf_s;
+
+/*
+ * Callback functions from BFA FCS to driver
+ */
+
+/**
+ * 	Completion callback for bfa_fcs_vf_stop().
+ *
+ * @param[in] vf_drv - driver instance of vf
+ *
+ * @return None
+ */
+void            bfa_fcb_vf_stop(struct bfad_vf_s *vf_drv);
+
+
+
+#endif /* __BFA_FCB_VF_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h patch/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h
--- orig/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcb_vport.h BFA FCS virtual port driver interfaces
+ */
+
+#ifndef __BFA_FCB_VPORT_H__
+#define __BFA_FCB_VPORT_H__
+
+/**
+ *  fcs_vport_fcb Virtual port driver interfaces
+ */
+
+
+struct bfad_vport_s;
+
+/*
+ * Callback functions from BFA FCS to driver
+ */
+
+/**
+ * 	Completion callback for bfa_fcs_vport_delete().
+ *
+ * @param[in] vport_drv - driver instance of vport
+ *
+ * @return None
+ */
+void            bfa_fcb_vport_delete(struct bfad_vport_s *vport_drv);
+
+
+
+#endif /* __BFA_FCB_VPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCS_H__
+#define __BFA_FCS_H__
+
+#include <cs/bfa_debug.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_version.h>
+#include <bfa.h>
+#include <fcs/bfa_fcs_fabric.h>
+
+#define BFA_FCS_OS_STR_LEN  		64
+
+struct bfa_fcs_stats_s {
+	struct {
+		u32        untagged; /*  untagged receive frames */
+		u32        tagged;	/*  tagged receive frames */
+		u32        vfid_unknown;	/*  VF id is unknown */
+	} uf;
+};
+
+struct bfa_fcs_driver_info_s {
+	u8  version[BFA_VERSION_LEN];		/*  Driver Version */
+	u8  host_machine_name[BFA_FCS_OS_STR_LEN];
+	u8  host_os_name[BFA_FCS_OS_STR_LEN]; /*  OS name and version */
+	u8  host_os_patch[BFA_FCS_OS_STR_LEN];/*  patch or service pack */
+	u8  os_device_name[BFA_FCS_OS_STR_LEN]; /*  Driver Device Name */
+};
+
+struct bfa_fcs_s {
+	struct bfa_s      *bfa;	/*  corresponding BFA bfa instance */
+	struct bfad_s         *bfad; /*  corresponding BDA driver instance */
+	struct bfa_log_mod_s  *logm;	/*  driver logging module instance */
+	struct bfa_trc_mod_s  *trcmod;	/*  tracing module */
+	struct bfa_aen_s      *aen;	/*  aen component */
+	bfa_boolean_t   vf_enabled;	/*  VF mode is enabled */
+	bfa_boolean_t min_cfg;		/* min cfg enabled/disabled */
+	u16        port_vfid;	/*  port default VF ID */
+	struct bfa_fcs_driver_info_s driver_info;
+	struct bfa_fcs_fabric_s fabric; /*  base fabric state machine */
+	struct bfa_fcs_stats_s	stats;	/*  FCS statistics */
+	struct bfa_wc_s       	wc;	/*  waiting counter */
+};
+
+/*
+ * bfa fcs API functions
+ */
+void bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+			bfa_boolean_t min_cfg);
+void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
+			struct bfa_fcs_driver_info_s *driver_info);
+void bfa_fcs_exit(struct bfa_fcs_s *fcs);
+void bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod);
+void bfa_fcs_log_init(struct bfa_fcs_s *fcs, struct bfa_log_mod_s *logmod);
+void bfa_fcs_aen_init(struct bfa_fcs_s *fcs, struct bfa_aen_s *aen);
+void 	  	bfa_fcs_start(struct bfa_fcs_s *fcs);
+
+#endif /* __BFA_FCS_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCS_AUTH_H__
+#define __BFA_FCS_AUTH_H__
+
+struct bfa_fcs_s;
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_auth.h>
+#include <defs/bfa_defs_vf.h>
+#include <cs/bfa_q.h>
+#include <cs/bfa_sm.h>
+#include <defs/bfa_defs_pport.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <protocol/fc_sp.h>
+
+struct bfa_fcs_fabric_s;
+
+
+
+struct bfa_fcs_auth_s {
+	bfa_sm_t	sm;	/*  state machine */
+	bfa_boolean_t   policy;	/*  authentication enabled/disabled */
+	enum bfa_auth_status status;	/*  authentication status */
+	enum auth_rjt_codes  rjt_code;	/*  auth reject status */
+	enum auth_rjt_code_exps  rjt_code_exp;	/*  auth reject reason */
+	enum bfa_auth_algo algo;	/*  Authentication algorithm */
+	struct bfa_auth_stats_s stats;	/*  Statistics */
+	enum auth_dh_gid   group;	/*  DH(diffie-hellman) Group */
+	enum bfa_auth_secretsource source;	/*  Secret source */
+	char            secret[BFA_AUTH_SECRET_STRING_LEN];
+				/*  secret string */
+	u8         secret_len;
+				/*  secret string length */
+	u8         nretries;
+				/*  number of retries */
+	struct bfa_fcs_fabric_s *fabric;/*  pointer to fabric */
+	u8         sentcode;	/*  pointer to response data */
+	u8        *response;	/*  pointer to response data */
+	struct bfa_timer_s delay_timer; 	/*  delay timer */
+	struct bfa_fcxp_s *fcxp;		/*  pointer to fcxp */
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+};
+
+/**
+ * bfa fcs authentication public functions
+ */
+bfa_status_t    bfa_fcs_auth_get_attr(struct bfa_fcs_s *port,
+				      struct bfa_auth_attr_s *attr);
+bfa_status_t    bfa_fcs_auth_set_policy(struct bfa_fcs_s *port,
+					bfa_boolean_t policy);
+enum bfa_auth_status bfa_fcs_auth_get_status(struct bfa_fcs_s *port);
+bfa_status_t    bfa_fcs_auth_set_algo(struct bfa_fcs_s *port,
+				      enum bfa_auth_algo algo);
+bfa_status_t    bfa_fcs_auth_get_stats(struct bfa_fcs_s *port,
+				       struct bfa_auth_stats_s *stats);
+bfa_status_t    bfa_fcs_auth_set_dh_group(struct bfa_fcs_s *port, int group);
+bfa_status_t    bfa_fcs_auth_set_secretstring(struct bfa_fcs_s *port,
+					      char *secret);
+bfa_status_t    bfa_fcs_auth_set_secretstring_encrypt(struct bfa_fcs_s *port,
+					      u32 secret[], u32 len);
+bfa_status_t    bfa_fcs_auth_set_secretsource(struct bfa_fcs_s *port,
+					      enum bfa_auth_secretsource src);
+bfa_status_t    bfa_fcs_auth_reset_stats(struct bfa_fcs_s *port);
+bfa_status_t    bfa_fcs_auth_reinit(struct bfa_fcs_s *port);
+
+#endif /* __BFA_FCS_AUTH_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCS_FABRIC_H__
+#define __BFA_FCS_FABRIC_H__
+
+struct bfa_fcs_s;
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_vf.h>
+#include <cs/bfa_q.h>
+#include <cs/bfa_sm.h>
+#include <defs/bfa_defs_pport.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <protocol/fc_sp.h>
+#include <fcs/bfa_fcs_auth.h>
+
+/*
+ * forward declaration
+ */
+struct bfad_vf_s;
+
+enum bfa_fcs_fabric_type {
+	BFA_FCS_FABRIC_UNKNOWN = 0,
+	BFA_FCS_FABRIC_SWITCHED = 1,
+	BFA_FCS_FABRIC_PLOOP = 2,
+	BFA_FCS_FABRIC_N2N = 3,
+};
+
+
+struct bfa_fcs_fabric_s {
+	struct list_head   qe;		/*  queue element */
+	bfa_sm_t	 sm;		/*  state machine */
+	struct bfa_fcs_s *fcs;		/*  FCS instance */
+	struct bfa_fcs_port_s  bport;	/*  base logical port */
+	enum bfa_fcs_fabric_type fab_type; /*  fabric type */
+	enum bfa_pport_type oper_type;	/*  current link topology */
+	u8         is_vf;		/*  is virtual fabric? */
+	u8         is_npiv;	/*  is NPIV supported ? */
+	u8         is_auth;	/*  is Security/Auth supported ? */
+	u16        bb_credit;	/*  BB credit from fabric */
+	u16        vf_id;		/*  virtual fabric ID */
+	u16        num_vports;	/*  num vports */
+	u16        rsvd;
+	struct list_head         vport_q;	/*  queue of virtual ports */
+	struct list_head         vf_q;	/*  queue of virtual fabrics */
+	struct bfad_vf_s      *vf_drv;	/*  driver vf structure */
+	struct bfa_timer_s link_timer;	/*  Link Failure timer. Vport */
+	wwn_t           fabric_name;	/*  attached fabric name */
+	bfa_boolean_t   auth_reqd;	/*  authentication required	*/
+	struct bfa_timer_s delay_timer;	/*  delay timer		*/
+	union {
+		u16        swp_vfid;/*  switch port VF id		*/
+	} event_arg;
+	struct bfa_fcs_auth_s  auth;	/*  authentication config	*/
+	struct bfa_wc_s        wc;	/*  wait counter for delete	*/
+	struct bfa_vf_stats_s  stats; 	/*  fabric/vf stats		*/
+	struct bfa_lps_s	*lps;	/*  lport login services	*/
+	u8	fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ];  /*  attached
+							    * fabric's ip addr
+							    */
+};
+
+#define bfa_fcs_fabric_npiv_capable(__f)    (__f)->is_npiv
+#define bfa_fcs_fabric_is_switched(__f)			\
+	((__f)->fab_type == BFA_FCS_FABRIC_SWITCHED)
+
+/**
+ *   The design calls for a single implementation of base fabric and vf.
+ */
+#define bfa_fcs_vf_t struct bfa_fcs_fabric_s
+
+struct bfa_vf_event_s {
+	u32        undefined;
+};
+
+/**
+ * bfa fcs vf public functions
+ */
+bfa_status_t bfa_fcs_vf_mode_enable(struct bfa_fcs_s *fcs, u16 vf_id);
+bfa_status_t bfa_fcs_vf_mode_disable(struct bfa_fcs_s *fcs);
+bfa_status_t bfa_fcs_vf_create(bfa_fcs_vf_t *vf, struct bfa_fcs_s *fcs,
+			       u16 vf_id, struct bfa_port_cfg_s *port_cfg,
+			       struct bfad_vf_s *vf_drv);
+bfa_status_t bfa_fcs_vf_delete(bfa_fcs_vf_t *vf);
+void bfa_fcs_vf_start(bfa_fcs_vf_t *vf);
+bfa_status_t bfa_fcs_vf_stop(bfa_fcs_vf_t *vf);
+void bfa_fcs_vf_list(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs);
+void bfa_fcs_vf_list_all(struct bfa_fcs_s *fcs, u16 *vf_ids, int *nvfs);
+void bfa_fcs_vf_get_attr(bfa_fcs_vf_t *vf, struct bfa_vf_attr_s *vf_attr);
+void bfa_fcs_vf_get_stats(bfa_fcs_vf_t *vf,
+			  struct bfa_vf_stats_s *vf_stats);
+void bfa_fcs_vf_clear_stats(bfa_fcs_vf_t *vf);
+void bfa_fcs_vf_get_ports(bfa_fcs_vf_t *vf, wwn_t vpwwn[], int *nports);
+bfa_fcs_vf_t *bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id);
+struct bfad_vf_s *bfa_fcs_vf_get_drv_vf(bfa_fcs_vf_t *vf);
+
+#endif /* __BFA_FCS_FABRIC_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_fcpim.h BFA FCS FCP Initiator Mode interfaces/defines.
+ */
+
+#ifndef __BFA_FCS_FCPIM_H__
+#define __BFA_FCS_FCPIM_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_itnim.h>
+#include <fcs/bfa_fcs.h>
+#include <fcs/bfa_fcs_rport.h>
+#include <fcs/bfa_fcs_lport.h>
+#include <bfa_fcpim.h>
+
+/*
+ * forward declarations
+ */
+struct bfad_itnim_s;
+
+struct bfa_fcs_itnim_s {
+	bfa_sm_t		sm;		/*  state machine */
+	struct bfa_fcs_rport_s 	*rport;		/*  parent remote rport  */
+	struct bfad_itnim_s   	*itnim_drv;	/*  driver peer instance */
+	struct bfa_fcs_s      	*fcs;		/*  fcs instance         */
+	struct bfa_timer_s 	timer;		/*  timer functions      */
+	struct bfa_itnim_s 	*bfa_itnim;	/*  BFA itnim struct     */
+	bfa_boolean_t	 	seq_rec;	/*  seq recovery support */
+	bfa_boolean_t	 	rec_support;	/*  REC supported        */
+	bfa_boolean_t	 	conf_comp;	/*  FCP_CONF     support */
+	bfa_boolean_t	 	task_retry_id;	/*  task retry id supp   */
+	struct bfa_fcxp_wqe_s 	fcxp_wqe;	/*  wait qelem for fcxp  */
+	struct bfa_fcxp_s *fcxp;		/*  FCXP in use          */
+	struct bfa_itnim_stats_s 	stats;	/*  itn statistics       */
+};
+
+
+static inline struct bfad_port_s *
+bfa_fcs_itnim_get_drvport(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->port->bfad_port;
+}
+
+
+static inline struct bfa_fcs_port_s *
+bfa_fcs_itnim_get_port(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->port;
+}
+
+
+static inline wwn_t
+bfa_fcs_itnim_get_nwwn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->nwwn;
+}
+
+
+static inline wwn_t
+bfa_fcs_itnim_get_pwwn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->pwwn;
+}
+
+
+static inline u32
+bfa_fcs_itnim_get_fcid(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->pid;
+}
+
+
+static inline   u32
+bfa_fcs_itnim_get_maxfrsize(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->maxfrsize;
+}
+
+
+static inline   enum fc_cos
+bfa_fcs_itnim_get_cos(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->rport->fc_cos;
+}
+
+
+static inline struct bfad_itnim_s *
+bfa_fcs_itnim_get_drvitn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->itnim_drv;
+}
+
+
+static inline struct bfa_itnim_s *
+bfa_fcs_itnim_get_halitn(struct bfa_fcs_itnim_s *itnim)
+{
+	return itnim->bfa_itnim;
+}
+
+/**
+ * bfa fcs FCP Initiator mode API functions
+ */
+void bfa_fcs_itnim_get_attr(struct bfa_fcs_itnim_s *itnim,
+			struct bfa_itnim_attr_s *attr);
+void bfa_fcs_itnim_get_stats(struct bfa_fcs_itnim_s *itnim,
+			struct bfa_itnim_stats_s *stats);
+struct bfa_fcs_itnim_s *bfa_fcs_itnim_lookup(struct bfa_fcs_port_s *port,
+			wwn_t rpwwn);
+bfa_status_t bfa_fcs_itnim_attr_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
+			struct bfa_itnim_attr_s *attr);
+bfa_status_t bfa_fcs_itnim_stats_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
+			struct bfa_itnim_stats_s *stats);
+bfa_status_t bfa_fcs_itnim_stats_clear(struct bfa_fcs_port_s *port,
+			wwn_t rpwwn);
+#endif /* __BFA_FCS_FCPIM_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_fdmi.h BFA fcs fdmi module public interface
+ */
+
+#ifndef __BFA_FCS_FDMI_H__
+#define __BFA_FCS_FDMI_H__
+#include <bfa_os_inc.h>
+#include <protocol/fdmi.h>
+
+#define	BFA_FCS_FDMI_SUPORTED_SPEEDS  (FDMI_TRANS_SPEED_1G  | \
+					FDMI_TRANS_SPEED_2G | \
+					FDMI_TRANS_SPEED_4G | \
+					FDMI_TRANS_SPEED_8G)
+
+/*
+* HBA Attribute Block : BFA internal representation. Note : Some variable
+* sizes have been trimmed to suit BFA For Ex : Model will be "Brocade". Based
+ * on this the size has been reduced to 16 bytes from the standard's 64 bytes.
+ */
+struct bfa_fcs_fdmi_hba_attr_s {
+	wwn_t           node_name;
+	u8         manufacturer[64];
+	u8         serial_num[64];
+	u8         model[16];
+	u8         model_desc[256];
+	u8         hw_version[8];
+	u8         driver_version[8];
+	u8         option_rom_ver[BFA_VERSION_LEN];
+	u8         fw_version[8];
+	u8         os_name[256];
+	u32        max_ct_pyld;
+};
+
+/*
+ * Port Attribute Block
+ */
+struct bfa_fcs_fdmi_port_attr_s {
+	u8         supp_fc4_types[32];	/* supported FC4 types */
+	u32        supp_speed;	/* supported speed */
+	u32        curr_speed;	/* current Speed */
+	u32        max_frm_size;	/* max frame size */
+	u8         os_device_name[256];	/* OS device Name */
+	u8         host_name[256];	/* host name */
+};
+
+#endif /* __BFA_FCS_FDMI_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,226 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_port.h BFA fcs port module public interface
+ */
+
+#ifndef __BFA_FCS_PORT_H__
+#define __BFA_FCS_PORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_pport.h>
+#include <defs/bfa_defs_rport.h>
+#include <cs/bfa_q.h>
+#include <bfa_svc.h>
+#include <cs/bfa_wc.h>
+
+struct bfa_fcs_s;
+struct bfa_fcs_fabric_s;
+
+/*
+* @todo : need to move to a global config file.
+ * Maximum Vports supported per physical port or vf.
+ */
+#define BFA_FCS_MAX_VPORTS_SUPP_CB  255
+#define BFA_FCS_MAX_VPORTS_SUPP_CT  191
+
+/*
+* @todo : need to move to a global config file.
+ * Maximum Rports supported per port (physical/logical).
+ */
+#define BFA_FCS_MAX_RPORTS_SUPP  256	/* @todo : tentative value */
+
+
+struct bfa_fcs_port_ns_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_s *port;	/*  parent port */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+};
+
+
+struct bfa_fcs_port_scn_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_s *port;	/*  parent port */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+};
+
+
+struct bfa_fcs_port_fdmi_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_ms_s *ms;	/*  parent ms */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+	u8         retry_cnt;	/*  retry count */
+	u8	 	   rsvd[3];
+};
+
+
+struct bfa_fcs_port_ms_s {
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;
+	struct bfa_fcs_port_s *port;	/*  parent port */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+	struct bfa_fcs_port_fdmi_s fdmi;	/*  FDMI component of MS */
+	u8         retry_cnt;	/*  retry count */
+	u8	 	   rsvd[3];
+};
+
+
+struct bfa_fcs_port_fab_s {
+	struct bfa_fcs_port_ns_s ns;	/*  NS component of port */
+	struct bfa_fcs_port_scn_s scn;	/*  scn component of port */
+	struct bfa_fcs_port_ms_s ms;	/*  MS component of port */
+};
+
+
+
+#define 	MAX_ALPA_COUNT 		127
+
+struct bfa_fcs_port_loop_s {
+	u8         num_alpa;	/*  Num of ALPA entries in the map */
+	u8         alpa_pos_map[MAX_ALPA_COUNT];	/*  ALPA Positional
+							 *Map */
+	struct bfa_fcs_port_s *port;	/*  parent port */
+};
+
+
+
+struct bfa_fcs_port_n2n_s {
+	u32        rsvd;
+	u16        reply_oxid;	/*  ox_id from the req flogi to be
+					 *used in flogi acc */
+	wwn_t           rem_port_wwn;	/*  Attached port's wwn */
+};
+
+
+union bfa_fcs_port_topo_u {
+	struct bfa_fcs_port_fab_s pfab;
+	struct bfa_fcs_port_loop_s ploop;
+	struct bfa_fcs_port_n2n_s pn2n;
+};
+
+
+struct bfa_fcs_port_s {
+	struct list_head         qe;	/*  used by port/vport */
+	bfa_sm_t               sm;	/*  state machine */
+	struct bfa_fcs_fabric_s *fabric;	/*  parent fabric */
+	struct bfa_port_cfg_s  port_cfg;	/*  port configuration */
+	struct bfa_timer_s link_timer;	/*  timer for link offline */
+	u32        pid : 24;	/*  FC address */
+	u8         lp_tag;		/*  lport tag */
+	u16        num_rports;	/*  Num of r-ports */
+	struct list_head rport_q;	/*  queue of discovered r-ports */
+	struct bfa_fcs_s *fcs;	/*  FCS instance */
+	union bfa_fcs_port_topo_u port_topo;	/*  fabric/loop/n2n details */
+	struct bfad_port_s *bfad_port;	/*  driver peer instance */
+	struct bfa_fcs_vport_s *vport;	/*  NULL for base ports */
+	struct bfa_fcxp_s *fcxp;
+	struct bfa_fcxp_wqe_s fcxp_wqe;
+	struct bfa_port_stats_s stats;
+	struct bfa_wc_s        wc;	/*  waiting counter for events */
+};
+
+#define bfa_fcs_lport_t struct bfa_fcs_port_s
+
+/**
+ * Symbolic Name related defines
+ *  Total bytes 255.
+ *  Physical Port's symbolic name 128 bytes.
+ *  For Vports, Vport's symbolic name is appended to the Physical port's
+ *  Symbolic Name.
+ *
+ *  Physical Port's symbolic name Format : (Total 128 bytes)
+ *  Adapter Model number/name : 12 bytes
+ *  Driver Version     : 10 bytes
+ *  Host Machine Name  : 30 bytes
+ * 	Host OS Info	   : 48 bytes
+ * 	Host OS PATCH Info : 16 bytes
+ *  ( remaining 12 bytes reserved to be used for separator)
+ */
+#define BFA_FCS_PORT_SYMBNAME_SEPARATOR 		" | "
+
+#define BFA_FCS_PORT_SYMBNAME_MODEL_SZ			12
+#define BFA_FCS_PORT_SYMBNAME_VERSION_SZ 		10
+#define BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ 	30
+#define BFA_FCS_PORT_SYMBNAME_OSINFO_SZ			48
+#define BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ		16
+
+/**
+ * Get FC port ID for a logical port.
+ */
+#define bfa_fcs_port_get_fcid(_lport)	((_lport)->pid)
+#define bfa_fcs_port_get_pwwn(_lport)	((_lport)->port_cfg.pwwn)
+#define bfa_fcs_port_get_nwwn(_lport)	((_lport)->port_cfg.nwwn)
+#define bfa_fcs_port_get_psym_name(_lport)	((_lport)->port_cfg.sym_name)
+#define bfa_fcs_port_is_initiator(_lport)	\
+			((_lport)->port_cfg.roles & BFA_PORT_ROLE_FCP_IM)
+#define bfa_fcs_port_is_target(_lport)	\
+			((_lport)->port_cfg.roles & BFA_PORT_ROLE_FCP_TM)
+#define bfa_fcs_port_get_nrports(_lport)	\
+			((_lport) ? (_lport)->num_rports : 0)
+
+static inline struct bfad_port_s *
+bfa_fcs_port_get_drvport(struct bfa_fcs_port_s *port)
+{
+	return port->bfad_port;
+}
+
+
+#define bfa_fcs_port_get_opertype(_lport)	(_lport)->fabric->oper_type
+
+
+#define bfa_fcs_port_get_fabric_name(_lport)	(_lport)->fabric->fabric_name
+
+
+#define bfa_fcs_port_get_fabric_ipaddr(_lport)	(_lport)->fabric->fabric_ip_addr
+
+/**
+ * bfa fcs port public functions
+ */
+void bfa_fcs_cfg_base_port(struct bfa_fcs_s *fcs,
+			struct bfa_port_cfg_s *port_cfg);
+struct bfa_fcs_port_s *bfa_fcs_get_base_port(struct bfa_fcs_s *fcs);
+void bfa_fcs_port_get_rports(struct bfa_fcs_port_s *port,
+			wwn_t rport_wwns[], int *nrports);
+
+wwn_t bfa_fcs_port_get_rport(struct bfa_fcs_port_s *port, wwn_t wwn,
+			int index, int nrports, bfa_boolean_t bwwn);
+
+struct bfa_fcs_port_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
+			u16 vf_id, wwn_t lpwwn);
+
+void bfa_fcs_port_get_info(struct bfa_fcs_port_s *port,
+			struct bfa_port_info_s *port_info);
+void bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
+			struct bfa_port_attr_s *port_attr);
+void bfa_fcs_port_get_stats(struct bfa_fcs_port_s *fcs_port,
+			struct bfa_port_stats_s *port_stats);
+void bfa_fcs_port_clear_stats(struct bfa_fcs_port_s *fcs_port);
+enum bfa_pport_speed bfa_fcs_port_get_rport_max_speed(
+			struct bfa_fcs_port_s *port);
+void bfa_fcs_port_enable_ipfc_roles(struct bfa_fcs_port_s *fcs_port);
+void bfa_fcs_port_disable_ipfc_roles(struct bfa_fcs_port_s *fcs_port);
+
+#endif /* __BFA_FCS_PORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCS_RPORT_H__
+#define __BFA_FCS_RPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <cs/bfa_q.h>
+#include <fcs/bfa_fcs.h>
+#include <defs/bfa_defs_rport.h>
+
+#define BFA_FCS_RPORT_DEF_DEL_TIMEOUT 	90 	/* in secs */
+/*
+ * forward declarations
+ */
+struct bfad_rport_s;
+
+struct bfa_fcs_itnim_s;
+struct bfa_fcs_tin_s;
+struct bfa_fcs_iprp_s;
+
+/* Rport Features (RPF) */
+struct bfa_fcs_rpf_s {
+	bfa_sm_t               sm;	/*  state machine */
+	struct bfa_fcs_rport_s *rport;	/*  parent rport */
+	struct bfa_timer_s 	timer;	/*  general purpose timer */
+	struct bfa_fcxp_s 	*fcxp;	/*  FCXP needed for discarding */
+	struct bfa_fcxp_wqe_s 	fcxp_wqe;	/*  fcxp wait queue element */
+	int             	rpsc_retries;	/*  max RPSC retry attempts */
+	enum bfa_pport_speed 	rpsc_speed;	/* Current Speed from RPSC.
+						 * O if RPSC fails */
+	enum bfa_pport_speed	assigned_speed;	/* Speed assigned by the user.
+						 * will be used if RPSC is not
+						 * supported by the rport */
+};
+
+struct bfa_fcs_rport_s {
+	struct list_head         qe;	/*  used by port/vport */
+	struct bfa_fcs_port_s *port;	/*  parent FCS port */
+	struct bfa_fcs_s      *fcs;	/*  fcs instance */
+	struct bfad_rport_s   *rp_drv;	/*  driver peer instance */
+	u32        pid;	/*  port ID of rport */
+	u16        maxfrsize;	/*  maximum frame size */
+	u16        reply_oxid;	/*  OX_ID of inbound requests */
+	enum fc_cos        fc_cos;	/*  FC classes of service supp */
+	bfa_boolean_t   cisc;	/*  CISC capable device */
+	wwn_t           pwwn;	/*  port wwn of rport */
+	wwn_t           nwwn;	/*  node wwn of rport */
+	struct bfa_rport_symname_s psym_name; /*  port symbolic name  */
+	bfa_sm_t        sm;		/*  state machine */
+	struct bfa_timer_s timer;	/*  general purpose timer */
+	struct bfa_fcs_itnim_s *itnim;	/*  ITN initiator mode role */
+	struct bfa_fcs_tin_s *tin;	/*  ITN initiator mode role */
+	struct bfa_fcs_iprp_s *iprp;	/*  IP/FC role */
+	struct bfa_rport_s *bfa_rport;	/*  BFA Rport */
+	struct bfa_fcxp_s *fcxp;	/*  FCXP needed for discarding */
+	int             plogi_retries;	/*  max plogi retry attempts */
+	int             ns_retries;	/*  max NS query retry attempts */
+	struct bfa_fcxp_wqe_s 	fcxp_wqe; /*  fcxp wait queue element */
+	struct bfa_rport_stats_s stats;	/*  rport stats */
+	enum bfa_rport_function	scsi_function;  /*  Initiator/Target */
+	struct bfa_fcs_rpf_s rpf; 	/* Rport features module */
+};
+
+static inline struct bfa_rport_s *
+bfa_fcs_rport_get_halrport(struct bfa_fcs_rport_s *rport)
+{
+	return rport->bfa_rport;
+}
+
+/**
+ * bfa fcs rport API functions
+ */
+bfa_status_t bfa_fcs_rport_add(struct bfa_fcs_port_s *port, wwn_t *pwwn,
+			struct bfa_fcs_rport_s *rport,
+			struct bfad_rport_s *rport_drv);
+bfa_status_t bfa_fcs_rport_remove(struct bfa_fcs_rport_s *rport);
+void bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
+			struct bfa_rport_attr_s *attr);
+void bfa_fcs_rport_get_stats(struct bfa_fcs_rport_s *rport,
+			struct bfa_rport_stats_s *stats);
+void bfa_fcs_rport_clear_stats(struct bfa_fcs_rport_s *rport);
+struct bfa_fcs_rport_s *bfa_fcs_rport_lookup(struct bfa_fcs_port_s *port,
+			wwn_t rpwwn);
+struct bfa_fcs_rport_s *bfa_fcs_rport_lookup_by_nwwn(
+			struct bfa_fcs_port_s *port, wwn_t rnwwn);
+void bfa_fcs_rport_set_del_timeout(u8 rport_tmo);
+void bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport,
+			enum bfa_pport_speed speed);
+#endif /* __BFA_FCS_RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h patch/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
--- orig/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_vport.h BFA fcs vport module public interface
+ */
+
+#ifndef __BFA_FCS_VPORT_H__
+#define __BFA_FCS_VPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_vport.h>
+#include <fcs/bfa_fcs.h>
+#include <fcb/bfa_fcb_vport.h>
+
+struct bfa_fcs_vport_s {
+	struct list_head		qe;		/*  queue elem	 */
+	bfa_sm_t		sm;		/*  state machine	*/
+	bfa_fcs_lport_t		lport;		/*  logical port	*/
+	struct bfa_timer_s	timer;		/*  general purpose timer */
+	struct bfad_vport_s	*vport_drv;	/*  Driver private	*/
+	struct bfa_vport_stats_s vport_stats;	/*  vport statistics	*/
+	struct bfa_lps_s	*lps;		/*  Lport login service */
+	int			fdisc_retries;
+};
+
+#define bfa_fcs_vport_get_port(vport) \
+			((struct bfa_fcs_port_s  *)(&vport->port))
+
+/**
+ * bfa fcs vport public functions
+ */
+bfa_status_t bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport,
+			struct bfa_fcs_s *fcs, u16 vf_id,
+			struct bfa_port_cfg_s *port_cfg,
+			struct bfad_vport_s *vport_drv);
+bfa_status_t bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport);
+bfa_status_t bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport);
+bfa_status_t bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport);
+void bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
+			struct bfa_vport_attr_s *vport_attr);
+void bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
+			struct bfa_vport_stats_s *vport_stats);
+void bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport);
+struct bfa_fcs_vport_s *bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs,
+			u16 vf_id, wwn_t vpwwn);
+
+#endif /* __BFA_FCS_VPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_fcs.h patch/drivers/scsi/bfa/include/log/bfa_log_fcs.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_fcs.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_fcs.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * messages define for FCS Module
+ */
+#ifndef	__BFA_LOG_FCS_H__
+#define	__BFA_LOG_FCS_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_FCS_FABRIC_NOSWITCH 	\
+	(((u32) BFA_LOG_FCS_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_FCS_FABRIC_ISOLATED 	\
+	(((u32) BFA_LOG_FCS_ID << BFA_LOG_MODID_OFFSET) | 2)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_hal.h patch/drivers/scsi/bfa/include/log/bfa_log_hal.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_hal.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_hal.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for HAL Module */
+#ifndef	__BFA_LOG_HAL_H__
+#define	__BFA_LOG_HAL_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_HAL_ASSERT \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_HAL_HEARTBEAT_FAILURE \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 2)
+#define BFA_LOG_HAL_FCPIM_PARM_INVALID \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 3)
+#define BFA_LOG_HAL_SM_ASSERT \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 4)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_linux.h patch/drivers/scsi/bfa/include/log/bfa_log_linux.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_linux.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_linux.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* messages define for LINUX Module */
+#ifndef	__BFA_LOG_LINUX_H__
+#define	__BFA_LOG_LINUX_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_LINUX_DEVICE_CLAIMED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_LINUX_HASH_INIT_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 2)
+#define BFA_LOG_LINUX_SYSFS_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 3)
+#define BFA_LOG_LINUX_MEM_ALLOC_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 4)
+#define BFA_LOG_LINUX_DRIVER_REGISTRATION_FAILED \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 5)
+#define BFA_LOG_LINUX_ITNIM_FREE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 6)
+#define BFA_LOG_LINUX_ITNIM_ONLINE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 7)
+#define BFA_LOG_LINUX_ITNIM_OFFLINE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 8)
+#define BFA_LOG_LINUX_SCSI_HOST_FREE \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 9)
+#define BFA_LOG_LINUX_SCSI_ABORT \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 10)
+#define BFA_LOG_LINUX_SCSI_ABORT_COMP \
+		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 11)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/log/bfa_log_wdrv.h patch/drivers/scsi/bfa/include/log/bfa_log_wdrv.h
--- orig/drivers/scsi/bfa/include/log/bfa_log_wdrv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/log/bfa_log_wdrv.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * messages define for WDRV Module
+ */
+#ifndef	__BFA_LOG_WDRV_H__
+#define	__BFA_LOG_WDRV_H__
+#include  <cs/bfa_log.h>
+#define BFA_LOG_WDRV_IOC_INIT_ERROR 	\
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 1)
+#define BFA_LOG_WDRV_IOC_INTERNAL_ERROR \
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 2)
+#define BFA_LOG_WDRV_IOC_START_ERROR 	\
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 3)
+#define BFA_LOG_WDRV_IOC_STOP_ERROR 	\
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 4)
+#define BFA_LOG_WDRV_INSUFFICIENT_RESOURCES \
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 5)
+#define BFA_LOG_WDRV_BASE_ADDRESS_MAP_ERROR \
+	(((u32) BFA_LOG_WDRV_ID << BFA_LOG_MODID_OFFSET) | 6)
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/ct.h patch/drivers/scsi/bfa/include/protocol/ct.h
--- orig/drivers/scsi/bfa/include/protocol/ct.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/ct.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,492 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __CT_H__
+#define __CT_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+struct ct_hdr_s{
+	u32	rev_id:8;	/* Revision of the CT */
+	u32	in_id:24;	/* Initiator Id */
+	u32	gs_type:8;	/* Generic service Type */
+	u32	gs_sub_type:8;	/* Generic service sub type */
+	u32	options:8;	/* options */
+	u32	rsvrd:8;	/* reserved */
+	u32	cmd_rsp_code:16;/* ct command/response code */
+	u32	max_res_size:16;/* maximum/residual size */
+	u32	frag_id:8;	/* fragment ID */
+	u32	reason_code:8;	/* reason code */
+	u32	exp_code:8;	/* explanation code */
+	u32	vendor_unq:8;	/* vendor unique */
+};
+
+/*
+ * defines for the Revision
+ */
+enum {
+	CT_GS3_REVISION = 0x01,
+};
+
+/*
+ * defines for gs_type
+ */
+enum {
+	CT_GSTYPE_KEYSERVICE	= 0xF7,
+	CT_GSTYPE_ALIASSERVICE	= 0xF8,
+	CT_GSTYPE_MGMTSERVICE	= 0xFA,
+	CT_GSTYPE_TIMESERVICE	= 0xFB,
+	CT_GSTYPE_DIRSERVICE	= 0xFC,
+};
+
+/*
+ * defines for gs_sub_type for gs type directory service
+ */
+enum {
+	CT_GSSUBTYPE_NAMESERVER = 0x02,
+};
+
+/*
+ * defines for gs_sub_type for gs type management service
+ */
+enum {
+	CT_GSSUBTYPE_CFGSERVER	= 0x01,
+	CT_GSSUBTYPE_UNZONED_NS = 0x02,
+	CT_GSSUBTYPE_ZONESERVER = 0x03,
+	CT_GSSUBTYPE_LOCKSERVER = 0x04,
+	CT_GSSUBTYPE_HBA_MGMTSERVER = 0x10,	/* for FDMI */
+};
+
+/*
+ * defines for CT response code field
+ */
+enum {
+	CT_RSP_REJECT = 0x8001,
+	CT_RSP_ACCEPT = 0x8002,
+};
+
+/*
+ * defintions for CT reason code
+ */
+enum {
+	CT_RSN_INV_CMD		= 0x01,
+	CT_RSN_INV_VER		= 0x02,
+	CT_RSN_LOGIC_ERR	= 0x03,
+	CT_RSN_INV_SIZE		= 0x04,
+	CT_RSN_LOGICAL_BUSY	= 0x05,
+	CT_RSN_PROTO_ERR	= 0x07,
+	CT_RSN_UNABLE_TO_PERF	= 0x09,
+	CT_RSN_NOT_SUPP			= 0x0B,
+	CT_RSN_SERVER_NOT_AVBL  = 0x0D,
+	CT_RSN_SESSION_COULD_NOT_BE_ESTBD = 0x0E,
+	CT_RSN_VENDOR_SPECIFIC  = 0xFF,
+
+};
+
+/*
+ * definitions for explanations code for Name server
+ */
+enum {
+	CT_NS_EXP_NOADDITIONAL	= 0x00,
+	CT_NS_EXP_ID_NOT_REG	= 0x01,
+	CT_NS_EXP_PN_NOT_REG	= 0x02,
+	CT_NS_EXP_NN_NOT_REG	= 0x03,
+	CT_NS_EXP_CS_NOT_REG	= 0x04,
+	CT_NS_EXP_IPN_NOT_REG	= 0x05,
+	CT_NS_EXP_IPA_NOT_REG	= 0x06,
+	CT_NS_EXP_FT_NOT_REG	= 0x07,
+	CT_NS_EXP_SPN_NOT_REG	= 0x08,
+	CT_NS_EXP_SNN_NOT_REG	= 0x09,
+	CT_NS_EXP_PT_NOT_REG	= 0x0A,
+	CT_NS_EXP_IPP_NOT_REG	= 0x0B,
+	CT_NS_EXP_FPN_NOT_REG	= 0x0C,
+	CT_NS_EXP_HA_NOT_REG	= 0x0D,
+	CT_NS_EXP_FD_NOT_REG	= 0x0E,
+	CT_NS_EXP_FF_NOT_REG	= 0x0F,
+	CT_NS_EXP_ACCESSDENIED	= 0x10,
+	CT_NS_EXP_UNACCEPTABLE_ID = 0x11,
+	CT_NS_EXP_DATABASEEMPTY			= 0x12,
+	CT_NS_EXP_NOT_REG_IN_SCOPE 		= 0x13,
+	CT_NS_EXP_DOM_ID_NOT_PRESENT 	= 0x14,
+	CT_NS_EXP_PORT_NUM_NOT_PRESENT  = 0x15,
+	CT_NS_EXP_NO_DEVICE_ATTACHED 	= 0x16
+};
+
+/*
+ * defintions for the explanation code for all servers
+ */
+enum {
+	CT_EXP_AUTH_EXCEPTION			= 0xF1,
+	CT_EXP_DB_FULL					= 0xF2,
+	CT_EXP_DB_EMPTY					= 0xF3,
+	CT_EXP_PROCESSING_REQ			= 0xF4,
+	CT_EXP_UNABLE_TO_VERIFY_CONN	= 0xF5,
+	CT_EXP_DEVICES_NOT_IN_CMN_ZONE  = 0xF6
+};
+
+/*
+ * Command codes for Name server
+ */
+enum {
+	GS_GID_PN	= 0x0121,	/* Get Id on port name */
+	GS_GPN_ID	= 0x0112,	/* Get port name on ID */
+	GS_GNN_ID	= 0x0113,	/* Get node name on ID */
+	GS_GID_FT	= 0x0171,	/* Get Id on FC4 type */
+	GS_GSPN_ID	= 0x0118,	/* Get symbolic PN on ID */
+	GS_RFT_ID	= 0x0217,	/* Register fc4type on ID */
+	GS_RSPN_ID	= 0x0218,	/* Register symbolic PN on ID */
+	GS_RPN_ID	= 0x0212,	/* Register port name */
+	GS_RNN_ID	= 0x0213,	/* Register node name */
+	GS_RCS_ID	= 0x0214,	/* Register class of service */
+	GS_RPT_ID	= 0x021A,	/* Register port type */
+	GS_GA_NXT	= 0x0100,	/* Get all next */
+	GS_RFF_ID	= 0x021F,	/* Register FC4 Feature		*/
+};
+
+struct fcgs_id_req_s{
+	u32	rsvd:8;
+	u32	dap:24;	/* port identifier */
+};
+#define fcgs_gpnid_req_t struct fcgs_id_req_s
+#define fcgs_gnnid_req_t struct fcgs_id_req_s
+#define fcgs_gspnid_req_t struct fcgs_id_req_s
+
+struct fcgs_gidpn_req_s{
+	wwn_t	port_name;	/* port wwn */
+};
+
+struct fcgs_gidpn_resp_s{
+	u32	rsvd:8;
+	u32	dap:24;	/* port identifier */
+};
+
+/**
+ * RFT_ID
+ */
+struct fcgs_rftid_req_s {
+	u32	rsvd:8;
+	u32	dap:24;		/* port identifier */
+	u32	fc4_type[8];	/* fc4 types */
+};
+
+/**
+ * RFF_ID : Register FC4 features.
+ */
+
+#define FC_GS_FCP_FC4_FEATURE_INITIATOR  0x02
+#define FC_GS_FCP_FC4_FEATURE_TARGET	 0x01
+
+struct fcgs_rffid_req_s{
+    u32    rsvd          :8;
+    u32    dap        	  :24;		/* port identifier	*/
+    u32    rsvd1         :16;
+    u32    fc4ftr_bits   :8;		/* fc4 feature bits	*/
+    u32    fc4_type      :8;		/* corresponding FC4 Type */
+};
+
+/**
+ * GID_FT Request
+ */
+struct fcgs_gidft_req_s{
+	u8	reserved;
+	u8	domain_id;	/* domain, 0 - all fabric */
+	u8	area_id;	/* area, 0 - whole domain */
+	u8	fc4_type;	/* FC_TYPE_FCP for SCSI devices */
+};				/* GID_FT Request */
+
+/**
+ * GID_FT Response
+ */
+struct fcgs_gidft_resp_s {
+	u8		last:1;	/* last port identifier flag */
+	u8		reserved:7;
+	u32	pid:24;	/* port identifier */
+};				/* GID_FT Response */
+
+/**
+ * RSPN_ID
+ */
+struct fcgs_rspnid_req_s{
+	u32	rsvd:8;
+	u32	dap:24;		/* port identifier */
+	u8		spn_len;	/* symbolic port name length */
+	u8		spn[256];	/* symbolic port name */
+};
+
+/**
+ * RPN_ID
+ */
+struct fcgs_rpnid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	wwn_t		port_name;
+};
+
+/**
+ * RNN_ID
+ */
+struct fcgs_rnnid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	wwn_t		node_name;
+};
+
+/**
+ * RCS_ID
+ */
+struct fcgs_rcsid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	u32	cos;
+};
+
+/**
+ * RPT_ID
+ */
+struct fcgs_rptid_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+	u32	port_type:8;
+	u32	rsvd1:24;
+};
+
+/**
+ * GA_NXT Request
+ */
+struct fcgs_ganxt_req_s{
+	u32	rsvd:8;
+	u32	port_id:24;
+};
+
+/**
+ * GA_NXT Response
+ */
+struct fcgs_ganxt_rsp_s{
+	u32	port_type:8;	/* Port Type */
+	u32	port_id:24;	/* Port Identifier */
+	wwn_t		port_name;	/* Port Name */
+	u8		spn_len;	/* Length of Symbolic Port Name */
+	char		spn[255];	/* Symbolic Port Name */
+	wwn_t		node_name;	/* Node Name */
+	u8		snn_len;	/* Length of Symbolic Node Name */
+	char		snn[255];	/* Symbolic Node Name */
+	u8		ipa[8];		/* Initial Process Associator */
+	u8		ip[16];		/* IP Address */
+	u32	cos;		/* Class of Service */
+	u32	fc4types[8];	/* FC-4 TYPEs */
+	wwn_t		fabric_port_name;
+					/* Fabric Port Name */
+	u32	rsvd:8;		/* Reserved */
+	u32	hard_addr:24;	/* Hard Address */
+};
+
+/*
+ * Fabric Config Server
+ */
+
+/*
+ * Command codes for Fabric Configuration Server
+ */
+enum {
+	GS_FC_GFN_CMD	= 0x0114,	/* GS FC Get Fabric Name  */
+	GS_FC_GMAL_CMD	= 0x0116,	/* GS FC GMAL  */
+	GS_FC_TRACE_CMD	= 0x0400,	/* GS FC Trace Route */
+	GS_FC_PING_CMD	= 0x0401,	/* GS FC Ping */
+};
+
+/*
+ * Source or Destination Port Tags.
+ */
+enum {
+	GS_FTRACE_TAG_NPORT_ID		= 1,
+	GS_FTRACE_TAG_NPORT_NAME	= 2,
+};
+
+/*
+* Port Value : Could be a Port id or wwn
+ */
+union fcgs_port_val_u{
+	u32	nport_id;
+	wwn_t		nport_wwn;
+};
+
+#define GS_FTRACE_MAX_HOP_COUNT	20
+#define GS_FTRACE_REVISION	1
+
+/*
+ * Ftrace Related Structures.
+ */
+
+/*
+ * STR (Switch Trace) Reject Reason Codes. From FC-SW.
+ */
+enum {
+	GS_FTRACE_STR_CMD_COMPLETED_SUCC	= 0,
+	GS_FTRACE_STR_CMD_NOT_SUPP_IN_NEXT_SWITCH,
+	GS_FTRACE_STR_NO_RESP_FROM_NEXT_SWITCH,
+	GS_FTRACE_STR_MAX_HOP_CNT_REACHED,
+	GS_FTRACE_STR_SRC_PORT_NOT_FOUND,
+	GS_FTRACE_STR_DST_PORT_NOT_FOUND,
+	GS_FTRACE_STR_DEVICES_NOT_IN_COMMON_ZONE,
+	GS_FTRACE_STR_NO_ROUTE_BW_PORTS,
+	GS_FTRACE_STR_NO_ADDL_EXPLN,
+	GS_FTRACE_STR_FABRIC_BUSY,
+	GS_FTRACE_STR_FABRIC_BUILD_IN_PROGRESS,
+	GS_FTRACE_STR_VENDOR_SPECIFIC_ERR_START = 0xf0,
+	GS_FTRACE_STR_VENDOR_SPECIFIC_ERR_END = 0xff,
+};
+
+/*
+ * Ftrace Request
+ */
+struct fcgs_ftrace_req_s{
+	u32	revision;
+	u16	src_port_tag;	/* Source Port tag */
+	u16	src_port_len;	/* Source Port len */
+	union fcgs_port_val_u src_port_val;	/* Source Port value */
+	u16	dst_port_tag;	/* Destination Port tag */
+	u16	dst_port_len;	/* Destination Port len */
+	union fcgs_port_val_u dst_port_val;	/* Destination Port value */
+	u32	token;
+	u8		vendor_id[8];	/* T10 Vendor Identifier */
+	u8		vendor_info[8];	/* Vendor specific Info */
+	u32	max_hop_cnt;	/* Max Hop Count */
+};
+
+/*
+ * Path info structure
+ */
+struct fcgs_ftrace_path_info_s{
+	wwn_t		switch_name;		/* Switch WWN */
+	u32	domain_id;
+	wwn_t		ingress_port_name;	/* Ingress ports wwn */
+	u32	ingress_phys_port_num;	/* Ingress ports physical port
+						 * number
+						 */
+	wwn_t		egress_port_name;	/* Ingress ports wwn */
+	u32	egress_phys_port_num;	/* Ingress ports physical port
+						 * number
+						 */
+};
+
+/*
+ * Ftrace Acc Response
+ */
+struct fcgs_ftrace_resp_s{
+	u32	revision;
+	u32	token;
+	u8		vendor_id[8];		/* T10 Vendor Identifier */
+	u8		vendor_info[8];		/* Vendor specific Info */
+	u32	str_rej_reason_code;	/* STR Reject Reason Code */
+	u32	num_path_info_entries;	/* No. of path info entries */
+	/*
+	 * path info entry/entries.
+	 */
+	struct fcgs_ftrace_path_info_s path_info[1];
+
+};
+
+/*
+* Fabric Config Server : FCPing
+ */
+
+/*
+ * FC Ping Request
+ */
+struct fcgs_fcping_req_s{
+	u32	revision;
+	u16	port_tag;
+	u16	port_len;	/* Port len */
+	union fcgs_port_val_u port_val;	/* Port value */
+	u32	token;
+};
+
+/*
+ * FC Ping Response
+ */
+struct fcgs_fcping_resp_s{
+	u32	token;
+};
+
+/*
+ * Command codes for zone server query.
+ */
+enum {
+	ZS_GZME = 0x0124,	/* Get zone member extended */
+};
+
+/*
+ * ZS GZME request
+ */
+#define ZS_GZME_ZNAMELEN	32
+struct zs_gzme_req_s{
+	u8	znamelen;
+	u8	rsvd[3];
+	u8	zname[ZS_GZME_ZNAMELEN];
+};
+
+enum zs_mbr_type{
+	ZS_MBR_TYPE_PWWN	= 1,
+	ZS_MBR_TYPE_DOMPORT	= 2,
+	ZS_MBR_TYPE_PORTID	= 3,
+	ZS_MBR_TYPE_NWWN	= 4,
+};
+
+struct zs_mbr_wwn_s{
+	u8	mbr_type;
+	u8	rsvd[3];
+	wwn_t	wwn;
+};
+
+struct zs_query_resp_s{
+	u32	nmbrs;	/*  number of zone members */
+	struct zs_mbr_wwn_s	mbr[1];
+};
+
+/*
+ * GMAL Command ( Get ( interconnect Element) Management Address List)
+ * To retrieve the IP Address of a Switch.
+ */
+
+#define CT_GMAL_RESP_PREFIX_TELNET	 "telnet://"
+#define CT_GMAL_RESP_PREFIX_HTTP	 "http://"
+
+/*  GMAL/GFN request */
+struct fcgs_req_s {
+	wwn_t    wwn; 	/* PWWN/NWWN */
+};
+
+#define fcgs_gmal_req_t struct fcgs_req_s
+#define fcgs_gfn_req_t struct fcgs_req_s
+
+/* Accept Response to GMAL */
+struct fcgs_gmal_resp_s {
+	u32 		ms_len;   /* Num of entries */
+	u8     	ms_ma[256];
+};
+
+struct fc_gmal_entry_s {
+	u8  len;
+	u8  prefix[7]; /* like "http://" */
+	u8  ip_addr[248];
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/fc.h patch/drivers/scsi/bfa/include/protocol/fc.h
--- orig/drivers/scsi/bfa/include/protocol/fc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fc.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,1105 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FC_H__
+#define __FC_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/*
+ * Fibre Channel Header Structure (FCHS) definition
+ */
+struct fchs_s {
+#ifdef __BIGENDIAN
+	u32        routing:4;	/* routing bits */
+	u32        cat_info:4;	/* category info */
+#else
+	u32        cat_info:4;	/* category info */
+	u32        routing:4;	/* routing bits */
+#endif
+	u32        d_id:24;	/* destination identifier */
+
+	u32        cs_ctl:8;	/* class specific control */
+	u32        s_id:24;	/* source identifier */
+
+	u32        type:8;		/* data structure type */
+	u32        f_ctl:24;	/* initial frame control */
+
+	u8         seq_id;		/* sequence identifier */
+	u8         df_ctl;		/* data field control */
+	u16        seq_cnt;	/* sequence count */
+
+	u16        ox_id;		/* originator exchange ID */
+	u16        rx_id;		/* responder exchange ID */
+
+	u32        ro;		/* relative offset */
+};
+/*
+ * Fibre Channel BB_E Header Structure
+ */
+struct fcbbehs_s {
+	u16	ver_rsvd;
+	u32	rsvd[2];
+	u32	rsvd__sof;
+};
+
+#define FC_SEQ_ID_MAX		256
+
+/*
+ * routing bit definitions
+ */
+enum {
+	FC_RTG_FC4_DEV_DATA	= 0x0,	/* FC-4 Device Data */
+	FC_RTG_EXT_LINK		= 0x2,	/* Extended Link Data */
+	FC_RTG_FC4_LINK_DATA	= 0x3,	/* FC-4 Link Data */
+	FC_RTG_VIDEO_DATA	= 0x4,	/* Video Data */
+	FC_RTG_EXT_HDR		= 0x5,	/* VFT, IFR or Encapsuled */
+	FC_RTG_BASIC_LINK	= 0x8,	/* Basic Link data */
+	FC_RTG_LINK_CTRL	= 0xC,	/* Link Control */
+};
+
+/*
+ * information category for extended link data and FC-4 Link Data
+ */
+enum {
+	FC_CAT_LD_REQUEST	= 0x2,	/* Request */
+	FC_CAT_LD_REPLY		= 0x3,	/* Reply */
+	FC_CAT_LD_DIAG		= 0xF,	/* for DIAG use only */
+};
+
+/*
+ * information category for extended headers (VFT, IFR or encapsulation)
+ */
+enum {
+	FC_CAT_VFT_HDR = 0x0,	/* Virtual fabric tagging header */
+	FC_CAT_IFR_HDR = 0x1,	/* Inter-Fabric routing header */
+	FC_CAT_ENC_HDR = 0x2,	/* Encapsulation header */
+};
+
+/*
+ * information category for FC-4 device data
+ */
+enum {
+	FC_CAT_UNCATEG_INFO	= 0x0,	/* Uncategorized information */
+	FC_CAT_SOLICIT_DATA	= 0x1,	/* Solicited Data */
+	FC_CAT_UNSOLICIT_CTRL	= 0x2,	/* Unsolicited Control */
+	FC_CAT_SOLICIT_CTRL	= 0x3,	/* Solicited Control */
+	FC_CAT_UNSOLICIT_DATA	= 0x4,	/* Unsolicited Data */
+	FC_CAT_DATA_DESC	= 0x5,	/* Data Descriptor */
+	FC_CAT_UNSOLICIT_CMD	= 0x6,	/* Unsolicited Command */
+	FC_CAT_CMD_STATUS	= 0x7,	/* Command Status */
+};
+
+/*
+ * information category for Link Control
+ */
+enum {
+	FC_CAT_ACK_1		= 0x00,
+	FC_CAT_ACK_0_N		= 0x01,
+	FC_CAT_P_RJT		= 0x02,
+	FC_CAT_F_RJT		= 0x03,
+	FC_CAT_P_BSY		= 0x04,
+	FC_CAT_F_BSY_DATA	= 0x05,
+	FC_CAT_F_BSY_LINK_CTL	= 0x06,
+	FC_CAT_F_LCR		= 0x07,
+	FC_CAT_NTY		= 0x08,
+	FC_CAT_END		= 0x09,
+};
+
+/*
+ * Type Field Definitions. FC-PH Section 18.5 pg. 165
+ */
+enum {
+	FC_TYPE_BLS		= 0x0,	/* Basic Link Service */
+	FC_TYPE_ELS		= 0x1,	/* Extended Link Service */
+	FC_TYPE_IP		= 0x5,	/* IP */
+	FC_TYPE_FCP		= 0x8,	/* SCSI-FCP */
+	FC_TYPE_GPP		= 0x9,	/* SCSI_GPP */
+	FC_TYPE_SERVICES	= 0x20,	/* Fibre Channel Services */
+	FC_TYPE_FC_FSS		= 0x22,	/* Fabric Switch Services */
+	FC_TYPE_FC_AL		= 0x23,	/* FC-AL */
+	FC_TYPE_FC_SNMP		= 0x24,	/* FC-SNMP */
+	FC_TYPE_MAX		= 256,	/* 256 FC-4 types */
+};
+
+struct fc_fc4types_s{
+	u8         bits[FC_TYPE_MAX / 8];
+};
+
+/*
+ * Frame Control Definitions. FC-PH Table-45. pg. 168
+ */
+enum {
+	FCTL_EC_ORIG = 0x000000,	/* exchange originator */
+	FCTL_EC_RESP = 0x800000,	/* exchange responder */
+	FCTL_SEQ_INI = 0x000000,	/* sequence initiator */
+	FCTL_SEQ_REC = 0x400000,	/* sequence recipient */
+	FCTL_FS_EXCH = 0x200000,	/* first sequence of xchg */
+	FCTL_LS_EXCH = 0x100000,	/* last sequence of xchg */
+	FCTL_END_SEQ = 0x080000,	/* last frame of sequence */
+	FCTL_SI_XFER = 0x010000,	/* seq initiative transfer */
+	FCTL_RO_PRESENT = 0x000008,	/* relative offset present */
+	FCTL_FILLBYTE_MASK = 0x000003	/* , fill byte mask */
+};
+
+/*
+ * Fabric Well Known Addresses
+ */
+enum {
+	FC_MIN_WELL_KNOWN_ADDR		= 0xFFFFF0,
+	FC_DOMAIN_CONTROLLER_MASK 	= 0xFFFC00,
+	FC_ALIAS_SERVER			= 0xFFFFF8,
+	FC_MGMT_SERVER			= 0xFFFFFA,
+	FC_TIME_SERVER			= 0xFFFFFB,
+	FC_NAME_SERVER			= 0xFFFFFC,
+	FC_FABRIC_CONTROLLER		= 0xFFFFFD,
+	FC_FABRIC_PORT			= 0xFFFFFE,
+	FC_BROADCAST_SERVER		= 0xFFFFFF
+};
+
+/*
+ * domain/area/port defines
+ */
+#define FC_DOMAIN_MASK  0xFF0000
+#define FC_DOMAIN_SHIFT 16
+#define FC_AREA_MASK    0x00FF00
+#define FC_AREA_SHIFT   8
+#define FC_PORT_MASK    0x0000FF
+#define FC_PORT_SHIFT   0
+
+#define FC_GET_DOMAIN(p)	(((p) & FC_DOMAIN_MASK) >> FC_DOMAIN_SHIFT)
+#define FC_GET_AREA(p)		(((p) & FC_AREA_MASK) >> FC_AREA_SHIFT)
+#define FC_GET_PORT(p)		(((p) & FC_PORT_MASK) >> FC_PORT_SHIFT)
+
+#define FC_DOMAIN_CTRLR(p)	(FC_DOMAIN_CONTROLLER_MASK | (FC_GET_DOMAIN(p)))
+
+enum {
+	FC_RXID_ANY = 0xFFFFU,
+};
+
+/*
+ * generic ELS command
+ */
+struct fc_els_cmd_s{
+	u32        els_code:8;	/* ELS Command Code */
+	u32        reserved:24;
+};
+
+/*
+ * ELS Command Codes. FC-PH Table-75. pg. 223
+ */
+enum {
+	FC_ELS_LS_RJT = 0x1,	/* Link Service Reject. */
+	FC_ELS_ACC = 0x02,	/* Accept */
+	FC_ELS_PLOGI = 0x03,	/* N_Port Login. */
+	FC_ELS_FLOGI = 0x04,	/* F_Port Login. */
+	FC_ELS_LOGO = 0x05,	/* Logout. */
+	FC_ELS_ABTX = 0x06,	/* Abort Exchange */
+	FC_ELS_RES = 0x08,	/* Read Exchange status */
+	FC_ELS_RSS = 0x09,	/* Read sequence status block */
+	FC_ELS_RSI = 0x0A,	/* Request Sequence Initiative */
+	FC_ELS_ESTC = 0x0C,	/* Estimate Credit. */
+	FC_ELS_RTV = 0x0E,	/* Read Timeout Value. */
+	FC_ELS_RLS = 0x0F,	/* Read Link Status. */
+	FC_ELS_ECHO = 0x10,	/* Echo */
+	FC_ELS_TEST = 0x11,	/* Test */
+	FC_ELS_RRQ = 0x12,	/* Reinstate Recovery Qualifier. */
+	FC_ELS_REC = 0x13,	/* Add this for TAPE support in FCR */
+	FC_ELS_PRLI = 0x20,	/* Process Login */
+	FC_ELS_PRLO = 0x21,	/* Process Logout. */
+	FC_ELS_SCN = 0x22,	/* State Change Notification. */
+	FC_ELS_TPRLO = 0x24,	/* Third Party Process Logout. */
+	FC_ELS_PDISC = 0x50,	/* Discover N_Port Parameters. */
+	FC_ELS_FDISC = 0x51,	/* Discover F_Port Parameters. */
+	FC_ELS_ADISC = 0x52,	/* Discover Address. */
+	FC_ELS_FAN = 0x60,	/* Fabric Address Notification */
+	FC_ELS_RSCN = 0x61,	/* Reg State Change Notification */
+	FC_ELS_SCR = 0x62,	/* State Change Registration. */
+	FC_ELS_RTIN = 0x77,	/* Mangement server request */
+	FC_ELS_RNID = 0x78,	/* Mangement server request */
+	FC_ELS_RLIR = 0x79,	/* Registered Link Incident Record */
+
+	FC_ELS_RPSC = 0x7D,	/* Report Port Speed Capabilities */
+	FC_ELS_QSA = 0x7E,	/* Query Security Attributes. Ref FC-SP */
+	FC_ELS_E2E_LBEACON = 0x81,
+				/* End-to-End Link Beacon */
+	FC_ELS_AUTH = 0x90,	/* Authentication. Ref FC-SP */
+	FC_ELS_RFCN = 0x97,	/* Request Fabric Change Notification. Ref
+				 *FC-SP */
+
+};
+
+/*
+ *  Version numbers for FC-PH standards,
+ *  used in login to indicate what port
+ *  supports. See FC-PH-X table 158.
+ */
+enum {
+	FC_PH_VER_4_3 = 0x09,
+	FC_PH_VER_PH_3 = 0x20,
+};
+
+/*
+ * PDU size defines
+ */
+enum {
+	FC_MIN_PDUSZ = 512,
+	FC_MAX_PDUSZ = 2112,
+};
+
+/*
+ * N_Port PLOGI Common Service Parameters.
+ * FC-PH-x. Figure-76. pg. 308.
+ */
+struct fc_plogi_csp_s{
+	u8         verhi;	/* FC-PH high version */
+	u8         verlo;	/* FC-PH low version */
+	u16        bbcred;	/* BB_Credit */
+
+#ifdef __BIGENDIAN
+	u8         ciro:1,		/* continuously increasing RO */
+			rro:1,		/* random relative offset */
+			npiv_supp:1,	/* NPIV supported */
+			port_type:1,	/* N_Port/F_port */
+			altbbcred:1,	/* alternate BB_Credit */
+			resolution:1,	/* ms/ns ED_TOV resolution */
+			vvl_info:1,	/* VVL Info included */
+			reserved1:1;
+
+	u8         hg_supp:1,
+			query_dbc:1,
+			security:1,
+			sync_cap:1,
+			r_t_tov:1,
+			dh_dup_supp:1,
+			cisc:1,		/* continuously increasing seq count */
+			payload:1;
+#else
+	u8         reserved2:2,
+			resolution:1,	/* ms/ns ED_TOV resolution */
+			altbbcred:1,	/* alternate BB_Credit */
+			port_type:1,	/* N_Port/F_port */
+			npiv_supp:1,	/* NPIV supported */
+			rro:1,		/* random relative offset */
+			ciro:1;		/* continuously increasing RO */
+
+	u8         payload:1,
+			cisc:1,		/* continuously increasing seq count */
+			dh_dup_supp:1,
+			r_t_tov:1,
+			sync_cap:1,
+			security:1,
+			query_dbc:1,
+			hg_supp:1;
+#endif
+
+	u16        rxsz;		/* recieve data_field size */
+
+	u16        conseq;
+	u16        ro_bitmap;
+
+	u32        e_d_tov;
+};
+
+/*
+ * N_Port PLOGI Class Specific Parameters.
+ * FC-PH-x. Figure 78. pg. 318.
+ */
+struct fc_plogi_clp_s{
+#ifdef __BIGENDIAN
+	u32        class_valid:1;
+	u32        intermix:1;	/* class intermix supported if set =1.
+					 * valid only for class1. Reserved for
+					 * class2 & class3
+					 */
+	u32        reserved1:2;
+	u32        sequential:1;
+	u32        reserved2:3;
+#else
+	u32        reserved2:3;
+	u32        sequential:1;
+	u32        reserved1:2;
+	u32        intermix:1;	/* class intermix supported if set =1.
+					 * valid only for class1. Reserved for
+					 * class2 & class3
+					 */
+	u32        class_valid:1;
+#endif
+
+	u32        reserved3:24;
+
+	u32        reserved4:16;
+	u32        rxsz:16;	/* Receive data_field size */
+
+	u32        reserved5:8;
+	u32        conseq:8;
+	u32        e2e_credit:16;	/* end to end credit */
+
+	u32        reserved7:8;
+	u32        ospx:8;
+	u32        reserved8:16;
+};
+
+#define FLOGI_VVL_BRCD    0x42524344 /* ASCII value for each character in
+				      * string "BRCD" */
+
+/*
+ * PLOGI els command and reply payload
+ */
+struct fc_logi_s{
+	struct fc_els_cmd_s els_cmd;	/* ELS command code */
+	struct fc_plogi_csp_s  csp;		/* common service params */
+	wwn_t           port_name;
+	wwn_t           node_name;
+	struct fc_plogi_clp_s  class1;		/* class 1 service parameters */
+	struct fc_plogi_clp_s  class2;		/* class 2 service parameters */
+	struct fc_plogi_clp_s  class3;		/* class 3 service parameters */
+	struct fc_plogi_clp_s  class4;		/* class 4 service parameters */
+	u8         vvl[16];	/* vendor version level */
+};
+
+/*
+ * LOGO els command payload
+ */
+struct fc_logo_s{
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        nport_id:24;	/* N_Port identifier of source */
+	wwn_t           orig_port_name;	/* Port name of the LOGO originator */
+};
+
+/*
+ * ADISC els command payload
+ */
+struct fc_adisc_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        orig_HA:24;	/* originator hard address */
+	wwn_t           orig_port_name;	/* originator port name */
+	wwn_t           orig_node_name;	/* originator node name */
+	u32        res2:8;
+	u32        nport_id:24;	/* originator NPortID */
+};
+
+/*
+ * Exchange status block
+ */
+struct fc_exch_status_blk_s{
+	u32        oxid:16;
+	u32        rxid:16;
+	u32        res1:8;
+	u32        orig_np:24;	/* originator NPortID */
+	u32        res2:8;
+	u32        resp_np:24;	/* responder NPortID */
+	u32        es_bits;
+	u32        res3;
+	/*
+	 * un modified section of the fields
+	 */
+};
+
+/*
+ * RES els command payload
+ */
+struct fc_res_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        nport_id:24;	/* N_Port identifier of source */
+	u32        oxid:16;
+	u32        rxid:16;
+	u8         assoc_hdr[32];
+};
+
+/*
+ * RES els accept payload
+ */
+struct fc_res_acc_s{
+	struct fc_els_cmd_s els_cmd;	/* ELS command code */
+	struct fc_exch_status_blk_s fc_exch_blk; /* Exchange status block */
+};
+
+/*
+ * REC els command payload
+ */
+struct fc_rec_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        nport_id:24;	/* N_Port identifier of source */
+	u32        oxid:16;
+	u32        rxid:16;
+};
+
+#define FC_REC_ESB_OWN_RSP	0x80000000	/* responder owns */
+#define FC_REC_ESB_SI		0x40000000	/* SI is owned 	*/
+#define FC_REC_ESB_COMP		0x20000000	/* exchange is complete	*/
+#define FC_REC_ESB_ENDCOND_ABN	0x10000000	/* abnormal ending 	*/
+#define FC_REC_ESB_RQACT	0x04000000	/* recovery qual active	*/
+#define FC_REC_ESB_ERRP_MSK	0x03000000
+#define FC_REC_ESB_OXID_INV	0x00800000	/* invalid OXID		*/
+#define FC_REC_ESB_RXID_INV	0x00400000	/* invalid RXID		*/
+#define FC_REC_ESB_PRIO_INUSE	0x00200000
+
+/*
+ * REC els accept payload
+ */
+struct fc_rec_acc_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        oxid:16;
+	u32        rxid:16;
+	u32        res1:8;
+	u32        orig_id:24;	/* N_Port id of exchange originator */
+	u32        res2:8;
+	u32        resp_id:24;	/* N_Port id of exchange responder */
+	u32        count;		/* data transfer count */
+	u32        e_stat;		/* exchange status */
+};
+
+/*
+ * RSI els payload
+ */
+struct fc_rsi_s {
+	struct fc_els_cmd_s    els_cmd;
+	u32        res1:8;
+	u32        orig_sid:24;
+	u32        oxid:16;
+	u32        rxid:16;
+};
+
+/*
+ * structure for PRLI paramater pages, both request & response
+ * see FC-PH-X table 113 & 115 for explanation also FCP table 8
+ */
+struct fc_prli_params_s{
+	u32        reserved: 16;
+#ifdef __BIGENDIAN
+	u32        reserved1: 5;
+	u32        rec_support : 1;
+	u32        task_retry_id : 1;
+	u32        retry : 1;
+
+	u32        confirm : 1;
+	u32        doverlay:1;
+	u32        initiator:1;
+	u32        target:1;
+	u32        cdmix:1;
+	u32        drmix:1;
+	u32        rxrdisab:1;
+	u32        wxrdisab:1;
+#else
+	u32        retry : 1;
+	u32        task_retry_id : 1;
+	u32        rec_support : 1;
+	u32        reserved1: 5;
+
+	u32        wxrdisab:1;
+	u32        rxrdisab:1;
+	u32        drmix:1;
+	u32        cdmix:1;
+	u32        target:1;
+	u32        initiator:1;
+	u32        doverlay:1;
+	u32        confirm : 1;
+#endif
+};
+
+/*
+ * valid values for rspcode in PRLI ACC payload
+ */
+enum {
+	FC_PRLI_ACC_XQTD = 0x1,		/* request executed */
+	FC_PRLI_ACC_PREDEF_IMG = 0x5,	/* predefined image - no prli needed */
+};
+
+struct fc_prli_params_page_s{
+	u32        type:8;
+	u32        codext:8;
+#ifdef __BIGENDIAN
+	u32        origprocasv:1;
+	u32        rsppav:1;
+	u32        imagepair:1;
+	u32        reserved1:1;
+	u32        rspcode:4;
+#else
+	u32        rspcode:4;
+	u32        reserved1:1;
+	u32        imagepair:1;
+	u32        rsppav:1;
+	u32        origprocasv:1;
+#endif
+	u32        reserved2:8;
+
+	u32        origprocas;
+	u32        rspprocas;
+	struct fc_prli_params_s  servparams;
+};
+
+/*
+ * PRLI request and accept payload, FC-PH-X tables 112 & 114
+ */
+struct fc_prli_s{
+	u32        command:8;
+	u32        pglen:8;
+	u32        pagebytes:16;
+	struct fc_prli_params_page_s parampage;
+};
+
+/*
+ * PRLO logout params page
+ */
+struct fc_prlo_params_page_s{
+	u32        type:8;
+	u32        type_ext:8;
+#ifdef __BIGENDIAN
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        res1:14;
+#else
+	u32        res1:14;
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+#endif
+	u32        orig_process_assc;
+	u32        resp_process_assc;
+
+	u32        res2;
+};
+
+/*
+ * PRLO els command payload
+ */
+struct fc_prlo_s{
+	u32        	command:8;
+	u32        	page_len:8;
+	u32        	payload_len:16;
+	struct fc_prlo_params_page_s 	prlo_params[1];
+};
+
+/*
+ * PRLO Logout response parameter page
+ */
+struct fc_prlo_acc_params_page_s{
+	u32        type:8;
+	u32        type_ext:8;
+
+#ifdef __BIGENDIAN
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        res1:14;
+#else
+	u32        res1:14;
+	u32        rpa_valid:1;	/* responder process associator valid */
+	u32        opa_valid:1;	/* originator process associator
+					 * valid
+					 */
+#endif
+	u32        orig_process_assc;
+	u32        resp_process_assc;
+
+	u32        fc4type_csp;
+};
+
+/*
+ * PRLO els command ACC payload
+ */
+struct fc_prlo_acc_s{
+	u32        command:8;
+	u32        page_len:8;
+	u32        payload_len:16;
+	struct fc_prlo_acc_params_page_s prlo_acc_params[1];
+};
+
+/*
+ * SCR els command payload
+ */
+enum {
+	FC_SCR_REG_FUNC_FABRIC_DETECTED = 0x01,
+	FC_SCR_REG_FUNC_N_PORT_DETECTED = 0x02,
+	FC_SCR_REG_FUNC_FULL = 0x03,
+	FC_SCR_REG_FUNC_CLEAR_REG = 0xFF,
+};
+
+/* SCR VU registrations */
+enum {
+	FC_VU_SCR_REG_FUNC_FABRIC_NAME_CHANGE = 0x01
+};
+
+struct fc_scr_s{
+	u32 command:8;
+	u32 res:24;
+	u32 vu_reg_func:8; /* Vendor Unique Registrations */
+	u32 res1:16;
+	u32 reg_func:8;
+};
+
+/*
+ * Information category for Basic link data
+ */
+enum {
+	FC_CAT_NOP	= 0x0,
+	FC_CAT_ABTS	= 0x1,
+	FC_CAT_RMC	= 0x2,
+	FC_CAT_BA_ACC	= 0x4,
+	FC_CAT_BA_RJT	= 0x5,
+	FC_CAT_PRMT	= 0x6,
+};
+
+/*
+ * LS_RJT els reply payload
+ */
+struct fc_ls_rjt_s {
+	struct fc_els_cmd_s    els_cmd;		/* ELS command code */
+	u32        res1:8;
+	u32        reason_code:8;		/* Reason code for reject */
+	u32        reason_code_expl:8;	/* Reason code explanation */
+	u32        vendor_unique:8;	/* Vendor specific */
+};
+
+/*
+ * LS_RJT reason codes
+ */
+enum {
+	FC_LS_RJT_RSN_INV_CMD_CODE	= 0x01,
+	FC_LS_RJT_RSN_LOGICAL_ERROR	= 0x03,
+	FC_LS_RJT_RSN_LOGICAL_BUSY	= 0x05,
+	FC_LS_RJT_RSN_PROTOCOL_ERROR	= 0x07,
+	FC_LS_RJT_RSN_UNABLE_TO_PERF_CMD = 0x09,
+	FC_LS_RJT_RSN_CMD_NOT_SUPP	= 0x0B,
+};
+
+/*
+ * LS_RJT reason code explanation
+ */
+enum {
+	FC_LS_RJT_EXP_NO_ADDL_INFO		= 0x00,
+	FC_LS_RJT_EXP_SPARMS_ERR_OPTIONS	= 0x01,
+	FC_LS_RJT_EXP_SPARMS_ERR_INI_CTL	= 0x03,
+	FC_LS_RJT_EXP_SPARMS_ERR_REC_CTL	= 0x05,
+	FC_LS_RJT_EXP_SPARMS_ERR_RXSZ		= 0x07,
+	FC_LS_RJT_EXP_SPARMS_ERR_CONSEQ		= 0x09,
+	FC_LS_RJT_EXP_SPARMS_ERR_CREDIT		= 0x0B,
+	FC_LS_RJT_EXP_INV_PORT_NAME		= 0x0D,
+	FC_LS_RJT_EXP_INV_NODE_FABRIC_NAME	= 0x0E,
+	FC_LS_RJT_EXP_INV_CSP			= 0x0F,
+	FC_LS_RJT_EXP_INV_ASSOC_HDR		= 0x11,
+	FC_LS_RJT_EXP_ASSOC_HDR_REQD		= 0x13,
+	FC_LS_RJT_EXP_INV_ORIG_S_ID		= 0x15,
+	FC_LS_RJT_EXP_INV_OXID_RXID_COMB	= 0x17,
+	FC_LS_RJT_EXP_CMD_ALREADY_IN_PROG	= 0x19,
+	FC_LS_RJT_EXP_LOGIN_REQUIRED		= 0x1E,
+	FC_LS_RJT_EXP_INVALID_NPORT_ID		= 0x1F,
+	FC_LS_RJT_EXP_INSUFF_RES		= 0x29,
+	FC_LS_RJT_EXP_CMD_NOT_SUPP		= 0x2C,
+	FC_LS_RJT_EXP_INV_PAYLOAD_LEN		= 0x2D,
+};
+
+/*
+ * RRQ els command payload
+ */
+struct fc_rrq_s{
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
+	u32        res1:8;
+	u32        s_id:24;	/* exchange originator S_ID */
+
+	u32        ox_id:16;	/* originator exchange ID */
+	u32        rx_id:16;	/* responder exchange ID */
+
+	u32        res2[8];	/* optional association header */
+};
+
+/*
+ * ABTS BA_ACC reply payload
+ */
+struct fc_ba_acc_s{
+	u32        seq_id_valid:8;	/* set to 0x00 for Abort Exchange */
+	u32        seq_id:8;	/* invalid for Abort Exchange */
+	u32        res2:16;
+	u32        ox_id:16;	/* OX_ID from ABTS frame */
+	u32        rx_id:16;	/* RX_ID from ABTS frame */
+	u32        low_seq_cnt:16;	/* set to 0x0000 for Abort Exchange */
+	u32        high_seq_cnt:16;/* set to 0xFFFF for Abort Exchange */
+};
+
+/*
+ * ABTS BA_RJT reject payload
+ */
+struct fc_ba_rjt_s{
+	u32        res1:8;		/* Reserved */
+	u32        reason_code:8;	/* reason code for reject */
+	u32        reason_expl:8;	/* reason code explanation */
+	u32        vendor_unique:8;/* vendor unique reason code,set to 0 */
+};
+
+/*
+ * TPRLO logout parameter page
+ */
+struct fc_tprlo_params_page_s{
+	u32        type:8;
+	u32        type_ext:8;
+
+#ifdef __BIGENDIAN
+	u32        opa_valid:1;
+	u32        rpa_valid:1;
+	u32        tpo_nport_valid:1;
+	u32        global_process_logout:1;
+	u32        res1:12;
+#else
+	u32        res1:12;
+	u32        global_process_logout:1;
+	u32        tpo_nport_valid:1;
+	u32        rpa_valid:1;
+	u32        opa_valid:1;
+#endif
+
+	u32        orig_process_assc;
+	u32        resp_process_assc;
+
+	u32        res2:8;
+	u32        tpo_nport_id;
+};
+
+/*
+ * TPRLO ELS command payload
+ */
+struct fc_tprlo_s{
+	u32        command:8;
+	u32        page_len:8;
+	u32        payload_len:16;
+
+	struct fc_tprlo_params_page_s tprlo_params[1];
+};
+
+enum fc_tprlo_type{
+	FC_GLOBAL_LOGO = 1,
+	FC_TPR_LOGO
+};
+
+/*
+ * TPRLO els command ACC payload
+ */
+struct fc_tprlo_acc_s{
+	u32	command:8;
+	u32	page_len:8;
+	u32	payload_len:16;
+	struct fc_prlo_acc_params_page_s tprlo_acc_params[1];
+};
+
+/*
+ * RSCN els command req payload
+ */
+#define FC_RSCN_PGLEN	0x4
+
+enum fc_rscn_format{
+	FC_RSCN_FORMAT_PORTID	= 0x0,
+	FC_RSCN_FORMAT_AREA	= 0x1,
+	FC_RSCN_FORMAT_DOMAIN	= 0x2,
+	FC_RSCN_FORMAT_FABRIC	= 0x3,
+};
+
+struct fc_rscn_event_s{
+	u32        format:2;
+	u32        qualifier:4;
+	u32        resvd:2;
+	u32        portid:24;
+};
+
+struct fc_rscn_pl_s{
+	u8         command;
+	u8         pagelen;
+	u16        payldlen;
+	struct fc_rscn_event_s event[1];
+};
+
+/*
+ * ECHO els command req payload
+ */
+struct fc_echo_s {
+	struct fc_els_cmd_s    els_cmd;
+};
+
+/*
+ * RNID els command
+ */
+
+#define RNID_NODEID_DATA_FORMAT_COMMON    		 0x00
+#define RNID_NODEID_DATA_FORMAT_FCP3        		 0x08
+#define RNID_NODEID_DATA_FORMAT_DISCOVERY     		0xDF
+
+#define RNID_ASSOCIATED_TYPE_UNKNOWN                    0x00000001
+#define RNID_ASSOCIATED_TYPE_OTHER                      0x00000002
+#define RNID_ASSOCIATED_TYPE_HUB                        0x00000003
+#define RNID_ASSOCIATED_TYPE_SWITCH                     0x00000004
+#define RNID_ASSOCIATED_TYPE_GATEWAY                    0x00000005
+#define RNID_ASSOCIATED_TYPE_STORAGE_DEVICE             0x00000009
+#define RNID_ASSOCIATED_TYPE_HOST                       0x0000000A
+#define RNID_ASSOCIATED_TYPE_STORAGE_SUBSYSTEM          0x0000000B
+#define RNID_ASSOCIATED_TYPE_STORAGE_ACCESS_DEVICE      0x0000000E
+#define RNID_ASSOCIATED_TYPE_NAS_SERVER                 0x00000011
+#define RNID_ASSOCIATED_TYPE_BRIDGE                     0x00000002
+#define RNID_ASSOCIATED_TYPE_VIRTUALIZATION_DEVICE      0x00000003
+#define RNID_ASSOCIATED_TYPE_MULTI_FUNCTION_DEVICE      0x000000FF
+
+/*
+ * RNID els command payload
+ */
+struct fc_rnid_cmd_s{
+	struct fc_els_cmd_s    els_cmd;
+	u32        node_id_data_format:8;
+	u32        reserved:24;
+};
+
+/*
+ * RNID els response payload
+ */
+
+struct fc_rnid_common_id_data_s{
+	wwn_t           port_name;
+	wwn_t           node_name;
+};
+
+struct fc_rnid_general_topology_data_s{
+	u32        vendor_unique[4];
+	u32        asso_type;
+	u32        phy_port_num;
+	u32        num_attached_nodes;
+	u32        node_mgmt:8;
+	u32        ip_version:8;
+	u32        udp_tcp_port_num:16;
+	u32        ip_address[4];
+	u32        reserved:16;
+	u32        vendor_specific:16;
+};
+
+struct fc_rnid_acc_s{
+	struct fc_els_cmd_s    els_cmd;
+	u32        node_id_data_format:8;
+	u32        common_id_data_length:8;
+	u32        reserved:8;
+	u32        specific_id_data_length:8;
+	struct fc_rnid_common_id_data_s common_id_data;
+	struct fc_rnid_general_topology_data_s gen_topology_data;
+};
+
+#define RNID_ASSOCIATED_TYPE_UNKNOWN                    0x00000001
+#define RNID_ASSOCIATED_TYPE_OTHER                      0x00000002
+#define RNID_ASSOCIATED_TYPE_HUB                        0x00000003
+#define RNID_ASSOCIATED_TYPE_SWITCH                     0x00000004
+#define RNID_ASSOCIATED_TYPE_GATEWAY                    0x00000005
+#define RNID_ASSOCIATED_TYPE_STORAGE_DEVICE             0x00000009
+#define RNID_ASSOCIATED_TYPE_HOST                       0x0000000A
+#define RNID_ASSOCIATED_TYPE_STORAGE_SUBSYSTEM          0x0000000B
+#define RNID_ASSOCIATED_TYPE_STORAGE_ACCESS_DEVICE      0x0000000E
+#define RNID_ASSOCIATED_TYPE_NAS_SERVER                 0x00000011
+#define RNID_ASSOCIATED_TYPE_BRIDGE                     0x00000002
+#define RNID_ASSOCIATED_TYPE_VIRTUALIZATION_DEVICE      0x00000003
+#define RNID_ASSOCIATED_TYPE_MULTI_FUNCTION_DEVICE      0x000000FF
+
+enum fc_rpsc_speed_cap{
+	RPSC_SPEED_CAP_1G = 0x8000,
+	RPSC_SPEED_CAP_2G = 0x4000,
+	RPSC_SPEED_CAP_4G = 0x2000,
+	RPSC_SPEED_CAP_10G = 0x1000,
+	RPSC_SPEED_CAP_8G = 0x0800,
+	RPSC_SPEED_CAP_16G = 0x0400,
+
+	RPSC_SPEED_CAP_UNKNOWN = 0x0001,
+};
+
+enum fc_rpsc_op_speed_s{
+	RPSC_OP_SPEED_1G = 0x8000,
+	RPSC_OP_SPEED_2G = 0x4000,
+	RPSC_OP_SPEED_4G = 0x2000,
+	RPSC_OP_SPEED_10G = 0x1000,
+	RPSC_OP_SPEED_8G = 0x0800,
+	RPSC_OP_SPEED_16G = 0x0400,
+
+	RPSC_OP_SPEED_NOT_EST = 0x0001,	/*! speed not established */
+};
+
+struct fc_rpsc_speed_info_s{
+	u16        port_speed_cap;	/*! see fc_rpsc_speed_cap_t */
+	u16        port_op_speed;	/*! see fc_rpsc_op_speed_t */
+};
+
+enum link_e2e_beacon_subcmd{
+	LINK_E2E_BEACON_ON = 1,
+	LINK_E2E_BEACON_OFF = 2
+};
+
+enum beacon_type{
+	BEACON_TYPE_NORMAL	= 1,	/*! Normal Beaconing. Green */
+	BEACON_TYPE_WARN	= 2,	/*! Warning Beaconing. Yellow/Amber */
+	BEACON_TYPE_CRITICAL	= 3	/*! Critical Beaconing. Red */
+};
+
+struct link_e2e_beacon_param_s {
+	u8         beacon_type;	/* Beacon Type. See beacon_type_t */
+	u8         beacon_frequency;
+					/* Beacon frequency. Number of blinks
+					 * per 10 seconds
+					 */
+	u16        beacon_duration;/* Beacon duration (in Seconds). The
+					 * command operation should be
+					 * terminated at the end of this
+					 * timeout value.
+					 *
+					 * Ignored if diag_sub_cmd is
+					 * LINK_E2E_BEACON_OFF.
+					 *
+					 * If 0, beaconing will continue till a
+					 * BEACON OFF request is received
+					 */
+};
+
+/*
+ * Link E2E beacon request/good response format. For LS_RJTs use fc_ls_rjt_t
+ */
+struct link_e2e_beacon_req_s{
+	u32        ls_code;	/*! FC_ELS_E2E_LBEACON in requests *
+					 *or FC_ELS_ACC in good replies */
+	u32        ls_sub_cmd;	/*! See link_e2e_beacon_subcmd_t */
+	struct link_e2e_beacon_param_s beacon_parm;
+};
+
+/**
+ * If RPSC request is sent to the Domain Controller, the request is for
+ * all the ports within that domain (TODO - I don't think FOS implements
+ * this...).
+ */
+struct fc_rpsc_cmd_s{
+	struct fc_els_cmd_s    els_cmd;
+};
+
+/*
+ * RPSC Acc
+ */
+struct fc_rpsc_acc_s{
+	u32        command:8;
+	u32        rsvd:8;
+	u32        num_entries:16;
+
+	struct fc_rpsc_speed_info_s speed_info[1];
+};
+
+/**
+ * If RPSC2 request is sent to the Domain Controller,
+ */
+#define FC_BRCD_TOKEN    0x42524344
+
+struct fc_rpsc2_cmd_s{
+	struct fc_els_cmd_s    els_cmd;
+	u32       	token;
+	u16     	resvd;
+	u16     	num_pids;       /* Number of pids in the request */
+	struct  {
+		u32	rsvd1:8;
+		u32	pid:24;	/* port identifier */
+	} pid_list[1];
+};
+
+enum fc_rpsc2_port_type{
+	RPSC2_PORT_TYPE_UNKNOWN = 0,
+	RPSC2_PORT_TYPE_NPORT   = 1,
+	RPSC2_PORT_TYPE_NLPORT  = 2,
+	RPSC2_PORT_TYPE_NPIV_PORT  = 0x5f,
+	RPSC2_PORT_TYPE_NPORT_TRUNK  = 0x6f,
+};
+
+/*
+ * RPSC2 portInfo entry structure
+ */
+struct fc_rpsc2_port_info_s{
+    u32    pid;        /* PID */
+    u16    resvd1;
+    u16    index;      /* port number / index */
+    u8     resvd2;
+    u8    	type;        /* port type N/NL/... */
+    u16    speed;      /* port Operating Speed */
+};
+
+/*
+ * RPSC2 Accept payload
+ */
+struct fc_rpsc2_acc_s{
+	u8        els_cmd;
+	u8        resvd;
+	u16       num_pids;  /* Number of pids in the request */
+	struct fc_rpsc2_port_info_s  port_info[1];    /* port information */
+};
+
+/**
+ * bit fields so that multiple classes can be specified
+ */
+enum fc_cos{
+	FC_CLASS_2	= 0x04,
+	FC_CLASS_3	= 0x08,
+	FC_CLASS_2_3	= 0x0C,
+};
+
+/*
+ * symbolic name
+ */
+struct fc_symname_s{
+	u8         symname[FC_SYMNAME_MAX];
+};
+
+struct fc_alpabm_s{
+	u8         alpa_bm[FC_ALPA_MAX / 8];
+};
+
+/*
+ * protocol default timeout values
+ */
+#define FC_ED_TOV		2
+#define FC_REC_TOV		(FC_ED_TOV + 1)
+#define FC_RA_TOV		10
+#define FC_ELS_TOV		(2 * FC_RA_TOV)
+
+/*
+ * virtual fabric related defines
+ */
+#define FC_VF_ID_NULL    0	/*  must not be used as VF_ID */
+#define FC_VF_ID_MIN     1
+#define FC_VF_ID_MAX     0xEFF
+#define FC_VF_ID_CTL     0xFEF	/*  control VF_ID */
+
+/**
+ * Virtual Fabric Tagging header format
+ * @caution This is defined only in BIG ENDIAN format.
+ */
+struct fc_vft_s{
+	u32        r_ctl:8;
+	u32        ver:2;
+	u32        type:4;
+	u32        res_a:2;
+	u32        priority:3;
+	u32        vf_id:12;
+	u32        res_b:1;
+	u32        hopct:8;
+	u32        res_c:24;
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/fc_sp.h patch/drivers/scsi/bfa/include/protocol/fc_sp.h
--- orig/drivers/scsi/bfa/include/protocol/fc_sp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fc_sp.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,224 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FC_SP_H__
+#define __FC_SP_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+enum auth_els_flags{
+	FC_AUTH_ELS_MORE_FRAGS_FLAG 	= 0x80,	/*! bit-7. More Fragments
+						 * Follow
+						 */
+	FC_AUTH_ELS_CONCAT_FLAG 	= 0x40,	/*! bit-6. Concatenation Flag */
+	FC_AUTH_ELS_SEQ_NUM_FLAG 	= 0x01 	/*! bit-0. Sequence Number */
+};
+
+enum auth_msg_codes{
+	FC_AUTH_MC_AUTH_RJT		= 0x0A,	/*! Auth Reject */
+	FC_AUTH_MC_AUTH_NEG 		= 0x0B, /*! Auth Negotiate */
+	FC_AUTH_MC_AUTH_DONE 		= 0x0C, /*! Auth Done */
+
+	FC_AUTH_MC_DHCHAP_CHAL 		= 0x10, /*! DHCHAP Challenge */
+	FC_AUTH_MC_DHCHAP_REPLY 	= 0x11, /*! DHCHAP Reply */
+	FC_AUTH_MC_DHCHAP_SUCC 		= 0x12, /*! DHCHAP Success */
+
+	FC_AUTH_MC_FCAP_REQ 		= 0x13, /*! FCAP Request */
+	FC_AUTH_MC_FCAP_ACK 		= 0x14, /*! FCAP Acknowledge */
+	FC_AUTH_MC_FCAP_CONF 		= 0x15, /*! FCAP Confirm */
+
+	FC_AUTH_MC_FCPAP_INIT 		= 0x16, /*! FCPAP Init */
+	FC_AUTH_MC_FCPAP_ACC 		= 0x17, /*! FCPAP Accept */
+	FC_AUTH_MC_FCPAP_COMP 		= 0x18, /*! FCPAP Complete */
+
+	FC_AUTH_MC_IKE_SA_INIT 		= 0x22, /*! IKE SA INIT */
+	FC_AUTH_MC_IKE_SA_AUTH 		= 0x23, /*! IKE SA Auth */
+	FC_AUTH_MC_IKE_CREATE_CHILD_SA	= 0x24, /*! IKE Create Child SA */
+	FC_AUTH_MC_IKE_INFO 		= 0x25, /*! IKE informational */
+};
+
+enum auth_proto_version{
+	FC_AUTH_PROTO_VER_1 	= 1,	/*! Protocol Version 1 */
+};
+
+enum {
+	FC_AUTH_ELS_COMMAND_CODE = 0x90,/*! Authentication ELS Command code  */
+	FC_AUTH_PROTO_PARAM_LEN_SZ = 4,	/*! Size of Proto Parameter Len Field */
+	FC_AUTH_PROTO_PARAM_VAL_SZ = 4,	/*! Size of Proto Parameter Val Field */
+	FC_MAX_AUTH_SECRET_LEN     = 256,
+					/*! Maximum secret string length */
+	FC_AUTH_NUM_USABLE_PROTO_LEN_SZ = 4,
+					/*! Size of usable protocols field */
+	FC_AUTH_RESP_VALUE_LEN_SZ	= 4,
+					/*! Size of response value length */
+	FC_MAX_CHAP_KEY_LEN	= 256,	/*! Maximum md5 digest length */
+	FC_MAX_AUTH_RETRIES     = 3,	/*! Maximum number of retries */
+	FC_MD5_DIGEST_LEN       = 16,	/*! MD5 digest length */
+	FC_SHA1_DIGEST_LEN      = 20,	/*! SHA1 digest length */
+	FC_MAX_DHG_SUPPORTED    = 1,	/*! Maximum DH Groups supported */
+	FC_MAX_ALG_SUPPORTED    = 1,	/*! Maximum algorithms supported */
+	FC_MAX_PROTO_SUPPORTED  = 1,	/*! Maximum protocols supported */
+	FC_START_TXN_ID         = 2,	/*! Starting transaction ID */
+};
+
+enum auth_proto_id{
+	FC_AUTH_PROTO_DHCHAP		= 0x00000001,
+	FC_AUTH_PROTO_FCAP 		= 0x00000002,
+	FC_AUTH_PROTO_FCPAP 		= 0x00000003,
+	FC_AUTH_PROTO_IKEv2 		= 0x00000004,
+	FC_AUTH_PROTO_IKEv2_AUTH 	= 0x00000005,
+};
+
+struct auth_name_s{
+	u16	name_tag;	/*! Name Tag = 1 for Authentication */
+	u16	name_len;	/*! Name Length = 8 for Authentication
+					 */
+	wwn_t		name;  		/*! Name. TODO - is this PWWN */
+};
+
+
+enum auth_hash_func{
+	FC_AUTH_HASH_FUNC_MD5 		= 0x00000005,
+	FC_AUTH_HASH_FUNC_SHA_1 	= 0x00000006,
+};
+
+enum auth_dh_gid{
+	FC_AUTH_DH_GID_0_DHG_NULL	= 0x00000000,
+	FC_AUTH_DH_GID_1_DHG_1024	= 0x00000001,
+	FC_AUTH_DH_GID_2_DHG_1280	= 0x00000002,
+	FC_AUTH_DH_GID_3_DHG_1536	= 0x00000003,
+	FC_AUTH_DH_GID_4_DHG_2048	= 0x00000004,
+	FC_AUTH_DH_GID_6_DHG_3072	= 0x00000006,
+	FC_AUTH_DH_GID_7_DHG_4096	= 0x00000007,
+	FC_AUTH_DH_GID_8_DHG_6144	= 0x00000008,
+	FC_AUTH_DH_GID_9_DHG_8192	= 0x00000009,
+};
+
+struct auth_els_msg_s {
+	u8		auth_els_code;	/*  Authentication ELS Code (0x90) */
+	u8 	auth_els_flag; 	/*  Authentication ELS Flags */
+	u8 	auth_msg_code; 	/*  Authentication Message Code */
+	u8 	proto_version; 	/*  Protocol Version */
+	u32	msg_len; 	/*  Message Length */
+	u32	trans_id; 	/*  Transaction Identifier (T_ID) */
+
+	/* Msg payload follows... */
+};
+
+
+enum auth_neg_param_tags {
+	FC_AUTH_NEG_DHCHAP_HASHLIST 	= 0x0001,
+	FC_AUTH_NEG_DHCHAP_DHG_ID_LIST 	= 0x0002,
+};
+
+
+struct dhchap_param_format_s {
+	u16	tag;		/*! Parameter Tag. See
+					 * auth_neg_param_tags_t
+					 */
+	u16	word_cnt;
+
+	/* followed by variable length parameter value... */
+};
+
+struct auth_proto_params_s {
+	u32	proto_param_len;
+	u32	proto_id;
+
+	/*
+	 * Followed by variable length Protocol specific parameters. DH-CHAP
+	 * uses dhchap_param_format_t
+	 */
+};
+
+struct auth_neg_msg_s {
+	struct auth_name_s	auth_ini_name;
+	u32		usable_auth_protos;
+	struct auth_proto_params_s proto_params[1]; /*! (1..usable_auth_proto)
+						     * protocol params
+						     */
+};
+
+struct auth_dh_val_s {
+	u32 dh_val_len;
+	u32 dh_val[1];
+};
+
+struct auth_dhchap_chal_msg_s {
+	struct auth_els_msg_s	hdr;
+	struct auth_name_s auth_responder_name;	/* TODO VRK - is auth_name_t
+						 * type OK?
+						 */
+	u32 	hash_id;
+	u32 	dh_grp_id;
+	u32 	chal_val_len;
+	char		chal_val[1];
+
+	/* ...followed by variable Challenge length/value and DH length/value */
+};
+
+
+enum auth_rjt_codes {
+	FC_AUTH_RJT_CODE_AUTH_FAILURE 	= 0x01,
+	FC_AUTH_RJT_CODE_LOGICAL_ERR	= 0x02,
+};
+
+enum auth_rjt_code_exps {
+	FC_AUTH_CEXP_AUTH_MECH_NOT_USABLE	= 0x01,
+	FC_AUTH_CEXP_DH_GROUP_NOT_USABLE 	= 0x02,
+	FC_AUTH_CEXP_HASH_FUNC_NOT_USABLE 	= 0x03,
+	FC_AUTH_CEXP_AUTH_XACT_STARTED		= 0x04,
+	FC_AUTH_CEXP_AUTH_FAILED 		= 0x05,
+	FC_AUTH_CEXP_INCORRECT_PLD 		= 0x06,
+	FC_AUTH_CEXP_INCORRECT_PROTO_MSG 	= 0x07,
+	FC_AUTH_CEXP_RESTART_AUTH_PROTO 	= 0x08,
+	FC_AUTH_CEXP_AUTH_CONCAT_NOT_SUPP 	= 0x09,
+	FC_AUTH_CEXP_PROTO_VER_NOT_SUPP 	= 0x0A,
+};
+
+enum auth_status {
+	FC_AUTH_STATE_INPROGRESS = 0, 	/*! authentication in progress 	*/
+	FC_AUTH_STATE_FAILED	= 1, 	/*! authentication failed */
+	FC_AUTH_STATE_SUCCESS	= 2 	/*! authentication successful	*/
+};
+
+struct auth_rjt_msg_s {
+	struct auth_els_msg_s	hdr;
+	u8		reason_code;
+	u8		reason_code_exp;
+	u8		rsvd[2];
+};
+
+
+struct auth_dhchap_neg_msg_s {
+	struct auth_els_msg_s hdr;
+	struct auth_neg_msg_s nego;
+};
+
+struct auth_dhchap_reply_msg_s {
+	struct auth_els_msg_s	hdr;
+
+	/*
+	 * followed by response value length & Value + DH Value Length & Value
+	 */
+};
+
+#pragma pack()
+
+#endif /* __FC_SP_H__ */
diff -urpN orig/drivers/scsi/bfa/include/protocol/fcp.h patch/drivers/scsi/bfa/include/protocol/fcp.h
--- orig/drivers/scsi/bfa/include/protocol/fcp.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fcp.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,186 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FCPPROTO_H__
+#define __FCPPROTO_H__
+
+#include <protocol/scsi.h>
+
+#pragma pack(1)
+
+enum {
+	FCP_RJT		= 0x01000000,	/* SRR reject */
+	FCP_SRR_ACCEPT	= 0x02000000,	/* SRR accept */
+	FCP_SRR		= 0x14000000,	/* Sequence Retransmission Request */
+};
+
+/*
+ * SRR FC-4 LS payload
+ */
+struct fc_srr_s{
+	u32	ls_cmd;
+	u32        ox_id:16;	/* ox-id */
+	u32        rx_id:16;	/* rx-id */
+	u32        ro;		/* relative offset */
+	u32        r_ctl:8;		/* R_CTL for I.U. */
+	u32        res:24;
+};
+
+
+/*
+ * FCP_CMND definitions
+ */
+#define FCP_CMND_CDB_LEN    16
+#define FCP_CMND_LUN_LEN    8
+
+struct fcp_cmnd_s{
+	lun_t           lun;		/* 64-bit LU number */
+	u8         crn;		/* command reference number */
+#ifdef __BIGENDIAN
+	u8         resvd:1,
+			priority:4,	/* FCP-3: SAM-3 priority */
+			taskattr:3;	/* scsi task attribute */
+#else
+	u8         taskattr:3,	/* scsi task attribute */
+			priority:4,	/* FCP-3: SAM-3 priority */
+			resvd:1;
+#endif
+	u8         tm_flags;	/* task management flags */
+#ifdef __BIGENDIAN
+	u8         addl_cdb_len:6,	/* additional CDB length words */
+			iodir:2;	/* read/write FCP_DATA IUs */
+#else
+	u8         iodir:2,	/* read/write FCP_DATA IUs */
+			addl_cdb_len:6;	/* additional CDB length */
+#endif
+	struct scsi_cdb_s      cdb;
+
+	/*
+	 * !!! additional cdb bytes follows here!!!
+	 */
+	u32        fcp_dl;	/* bytes to be transferred */
+};
+
+#define fcp_cmnd_cdb_len(_cmnd) ((_cmnd)->addl_cdb_len * 4 + FCP_CMND_CDB_LEN)
+#define fcp_cmnd_fcpdl(_cmnd)	((&(_cmnd)->fcp_dl)[(_cmnd)->addl_cdb_len])
+
+/*
+ * fcp_cmnd_t.iodir field values
+ */
+enum fcp_iodir{
+	FCP_IODIR_NONE	= 0,
+	FCP_IODIR_WRITE = 1,
+	FCP_IODIR_READ	= 2,
+	FCP_IODIR_RW	= 3,
+};
+
+/*
+ * Task attribute field
+ */
+enum {
+	FCP_TASK_ATTR_SIMPLE	= 0,
+	FCP_TASK_ATTR_HOQ	= 1,
+	FCP_TASK_ATTR_ORDERED	= 2,
+	FCP_TASK_ATTR_ACA	= 4,
+	FCP_TASK_ATTR_UNTAGGED	= 5,	/* obsolete in FCP-3 */
+};
+
+/*
+ * Task management flags field - only one bit shall be set
+ */
+#ifndef BIT
+#define BIT(_x)	(1 << (_x))
+#endif
+enum fcp_tm_cmnd{
+	FCP_TM_ABORT_TASK_SET	= BIT(1),
+	FCP_TM_CLEAR_TASK_SET	= BIT(2),
+	FCP_TM_LUN_RESET	= BIT(4),
+	FCP_TM_TARGET_RESET	= BIT(5),	/* obsolete in FCP-3 */
+	FCP_TM_CLEAR_ACA	= BIT(6),
+};
+
+/*
+ * FCP_XFER_RDY IU defines
+ */
+struct fcp_xfer_rdy_s{
+	u32        data_ro;
+	u32        burst_len;
+	u32        reserved;
+};
+
+/*
+ * FCP_RSP residue flags
+ */
+enum fcp_residue{
+	FCP_NO_RESIDUE = 0,	/* no residue */
+	FCP_RESID_OVER = 1,	/* more data left that was not sent */
+	FCP_RESID_UNDER = 2,	/* less data than requested */
+};
+
+enum {
+	FCP_RSPINFO_GOOD = 0,
+	FCP_RSPINFO_DATALEN_MISMATCH = 1,
+	FCP_RSPINFO_CMND_INVALID = 2,
+	FCP_RSPINFO_ROLEN_MISMATCH = 3,
+	FCP_RSPINFO_TM_NOT_SUPP = 4,
+	FCP_RSPINFO_TM_FAILED = 5,
+};
+
+struct fcp_rspinfo_s{
+	u32        res0:24;
+	u32        rsp_code:8;	/* response code (as above) */
+	u32        res1;
+};
+
+struct fcp_resp_s{
+	u32        reserved[2];	/* 2 words reserved */
+	u16        reserved2;
+#ifdef __BIGENDIAN
+	u8         reserved3:3;
+	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
+	u8         resid_flags:2;	/* underflow/overflow */
+	u8         sns_len_valid:1;/* sense len is valid */
+	u8         rsp_len_valid:1;/* response len is valid */
+#else
+	u8         rsp_len_valid:1;/* response len is valid */
+	u8         sns_len_valid:1;/* sense len is valid */
+	u8         resid_flags:2;	/* underflow/overflow */
+	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
+	u8         reserved3:3;
+#endif
+	u8         scsi_status;	/* one byte SCSI status */
+	u32        residue;	/* residual data bytes */
+	u32        sns_len;	/* length od sense info */
+	u32        rsp_len;	/* length of response info */
+};
+
+#define fcp_snslen(__fcprsp)	((__fcprsp)->sns_len_valid ? 		\
+					(__fcprsp)->sns_len : 0)
+#define fcp_rsplen(__fcprsp)	((__fcprsp)->rsp_len_valid ? 		\
+					(__fcprsp)->rsp_len : 0)
+#define fcp_rspinfo(__fcprsp)	((struct fcp_rspinfo_s *)((__fcprsp) + 1))
+#define fcp_snsinfo(__fcprsp)	(((u8 *)fcp_rspinfo(__fcprsp)) + 	\
+						fcp_rsplen(__fcprsp))
+
+struct fcp_cmnd_fr_s{
+	struct fchs_s          fchs;
+	struct fcp_cmnd_s      fcp;
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/fdmi.h patch/drivers/scsi/bfa/include/protocol/fdmi.h
--- orig/drivers/scsi/bfa/include/protocol/fdmi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/fdmi.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __FDMI_H__
+#define __FDMI_H__
+
+#include <protocol/types.h>
+#include <protocol/fc.h>
+#include <protocol/ct.h>
+
+#pragma pack(1)
+
+/*
+ * FDMI Command Codes
+ */
+#define	FDMI_GRHL		0x0100
+#define	FDMI_GHAT		0x0101
+#define	FDMI_GRPL		0x0102
+#define	FDMI_GPAT		0x0110
+#define	FDMI_RHBA		0x0200
+#define	FDMI_RHAT		0x0201
+#define	FDMI_RPRT		0x0210
+#define	FDMI_RPA		0x0211
+#define	FDMI_DHBA		0x0300
+#define	FDMI_DPRT		0x0310
+
+/*
+ * FDMI reason codes
+ */
+#define	FDMI_NO_ADDITIONAL_EXP		0x00
+#define	FDMI_HBA_ALREADY_REG		0x10
+#define	FDMI_HBA_ATTRIB_NOT_REG		0x11
+#define	FDMI_HBA_ATTRIB_MULTIPLE	0x12
+#define	FDMI_HBA_ATTRIB_LENGTH_INVALID	0x13
+#define	FDMI_HBA_ATTRIB_NOT_PRESENT	0x14
+#define	FDMI_PORT_ORIG_NOT_IN_LIST	0x15
+#define	FDMI_PORT_HBA_NOT_IN_LIST	0x16
+#define	FDMI_PORT_ATTRIB_NOT_REG	0x20
+#define	FDMI_PORT_NOT_REG		0x21
+#define	FDMI_PORT_ATTRIB_MULTIPLE	0x22
+#define	FDMI_PORT_ATTRIB_LENGTH_INVALID	0x23
+#define	FDMI_PORT_ALREADY_REGISTEREED	0x24
+
+/*
+ * FDMI Transmission Speed Mask values
+ */
+#define	FDMI_TRANS_SPEED_1G		0x00000001
+#define	FDMI_TRANS_SPEED_2G		0x00000002
+#define	FDMI_TRANS_SPEED_10G		0x00000004
+#define	FDMI_TRANS_SPEED_4G		0x00000008
+#define	FDMI_TRANS_SPEED_8G		0x00000010
+#define	FDMI_TRANS_SPEED_16G		0x00000020
+#define	FDMI_TRANS_SPEED_UNKNOWN	0x00008000
+
+/*
+ * FDMI HBA attribute types
+ */
+enum fdmi_hba_attribute_type {
+	FDMI_HBA_ATTRIB_NODENAME = 1,	/* 0x0001 */
+	FDMI_HBA_ATTRIB_MANUFACTURER,	/* 0x0002 */
+	FDMI_HBA_ATTRIB_SERIALNUM,	/* 0x0003 */
+	FDMI_HBA_ATTRIB_MODEL,		/* 0x0004 */
+	FDMI_HBA_ATTRIB_MODEL_DESC,	/* 0x0005 */
+	FDMI_HBA_ATTRIB_HW_VERSION,	/* 0x0006 */
+	FDMI_HBA_ATTRIB_DRIVER_VERSION,	/* 0x0007 */
+	FDMI_HBA_ATTRIB_ROM_VERSION,	/* 0x0008 */
+	FDMI_HBA_ATTRIB_FW_VERSION,	/* 0x0009 */
+	FDMI_HBA_ATTRIB_OS_NAME,	/* 0x000A */
+	FDMI_HBA_ATTRIB_MAX_CT,		/* 0x000B */
+
+	FDMI_HBA_ATTRIB_MAX_TYPE
+};
+
+/*
+ * FDMI Port attribute types
+ */
+enum fdmi_port_attribute_type {
+	FDMI_PORT_ATTRIB_FC4_TYPES = 1,	/* 0x0001 */
+	FDMI_PORT_ATTRIB_SUPP_SPEED,	/* 0x0002 */
+	FDMI_PORT_ATTRIB_PORT_SPEED,	/* 0x0003 */
+	FDMI_PORT_ATTRIB_FRAME_SIZE,	/* 0x0004 */
+	FDMI_PORT_ATTRIB_DEV_NAME,	/* 0x0005 */
+	FDMI_PORT_ATTRIB_HOST_NAME,	/* 0x0006 */
+
+	FDMI_PORT_ATTR_MAX_TYPE
+};
+
+/*
+ * FDMI attribute
+ */
+struct fdmi_attr_s {
+	u16        type;
+	u16        len;
+	u8         value[1];
+};
+
+/*
+ * HBA Attribute Block
+ */
+struct fdmi_hba_attr_s {
+	u32        attr_count;	/* # of attributes */
+	struct fdmi_attr_s     hba_attr;	/* n attributes */
+};
+
+/*
+ * Registered Port List
+ */
+struct fdmi_port_list_s {
+	u32        num_ports;	/* number Of Port Entries */
+	wwn_t           port_entry;	/* one or more */
+};
+
+/*
+ * Port Attribute Block
+ */
+struct fdmi_port_attr_s {
+	u32        attr_count;	/* # of attributes */
+	struct fdmi_attr_s     port_attr;	/* n attributes */
+};
+
+/*
+ * FDMI Register HBA Attributes
+ */
+struct fdmi_rhba_s {
+	wwn_t           hba_id;		/* HBA Identifier */
+	struct fdmi_port_list_s port_list;	/* Registered Port List */
+	struct fdmi_hba_attr_s hba_attr_blk;	/* HBA attribute block */
+};
+
+/*
+ * FDMI Register Port
+ */
+struct fdmi_rprt_s {
+	wwn_t           hba_id;		/* HBA Identifier */
+	wwn_t           port_name;	/* Port wwn */
+	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
+};
+
+/*
+ * FDMI Register Port Attributes
+ */
+struct fdmi_rpa_s {
+	wwn_t           port_name;	/* port wwn */
+	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/pcifw.h patch/drivers/scsi/bfa/include/protocol/pcifw.h
--- orig/drivers/scsi/bfa/include/protocol/pcifw.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/pcifw.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  pcifw.h PCI FW related headers
+ */
+
+#ifndef __PCIFW_H__
+#define __PCIFW_H__
+
+#pragma pack(1)
+
+struct pnp_hdr_s{
+  u32	signature;	/* "$PnP" */
+  u8	rev;		/* Struct revision */
+  u8 	len;		/* Header structure len in multiples
+				 * of 16 bytes */
+  u16  off;		/* Offset to next header 00 if none */
+  u8	rsvd;		/* Reserved byte */
+  u8	cksum;		/* 8-bit checksum for this header */
+  u32	pnp_dev_id;	/* PnP Device Id */
+  u16  mfstr;		/* Pointer to manufacturer string */
+  u16	prstr;		/* Pointer to product string */
+  u8	devtype[3];	/* Device Type Code */
+  u8	devind;		/* Device Indicator */
+  u16	bcventr;	/* Bootstrap entry vector */
+  u16	rsvd2;		/* Reserved */
+  u16  sriv;		/* Static resource information vector */
+};
+
+struct pci_3_0_ds_s{
+ u32	sig;   		/* Signature "PCIR" */
+ u16	vendid;		/* Vendor ID */
+ u16	devid;		/* Device ID */
+ u16	devlistoff;	/* Device List Offset */
+ u16	len;		/* PCI Data Structure Length */
+ u8	rev;		/* PCI Data Structure Revision */
+ u8	clcode[3];	/* Class Code */
+ u16	imglen;		/* Code image length in multiples of
+				 * 512 bytes */
+ u16	coderev;	/* Revision level of code/data */
+ u8	codetype;	/* Code type 0x00 - BIOS */
+ u8	indr;		/* Last image indicator */
+ u16	mrtimglen;	/* Max Run Time Image Length */
+ u16	cuoff;		/* Config Utility Code Header Offset */
+ u16	dmtfclp;	/* DMTF CLP entry point offset */
+};
+
+struct pci_optrom_hdr_s{
+ u16	sig;		/* Signature 0x55AA */
+ u8	len;		/* Option ROM length in units of 512 bytes */
+ u8	inivec[3];	/* Initialization vector */
+ u8	rsvd[16];	/* Reserved field */
+ u16	verptr;		/* Pointer to version string - private */
+ u16	pcids;		/* Pointer to PCI data structure */
+ u16	pnphdr;		/* Pointer to PnP expansion header */
+};
+
+#pragma pack()
+
+#endif
diff -urpN orig/drivers/scsi/bfa/include/protocol/scsi.h patch/drivers/scsi/bfa/include/protocol/scsi.h
--- orig/drivers/scsi/bfa/include/protocol/scsi.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/scsi.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,1648 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __SCSI_H__
+#define __SCSI_H__
+
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/*
+ * generic SCSI cdb definition
+ */
+#define SCSI_MAX_CDBLEN     16
+struct scsi_cdb_s{
+	u8         scsi_cdb[SCSI_MAX_CDBLEN];
+};
+
+/*
+ * scsi lun serial number definition
+ */
+#define SCSI_LUN_SN_LEN     32
+struct scsi_lun_sn_s{
+	u8         lun_sn[SCSI_LUN_SN_LEN];
+};
+
+/*
+ * SCSI Direct Access Commands
+ */
+enum {
+	SCSI_OP_TEST_UNIT_READY		= 0x00,
+	SCSI_OP_REQUEST_SENSE		= 0x03,
+	SCSI_OP_FORMAT_UNIT		= 0x04,
+	SCSI_OP_READ6			= 0x08,
+	SCSI_OP_WRITE6			= 0x0A,
+	SCSI_OP_WRITE_FILEMARKS		= 0x10,
+	SCSI_OP_INQUIRY			= 0x12,
+	SCSI_OP_MODE_SELECT6		= 0x15,
+	SCSI_OP_RESERVE6		= 0x16,
+	SCSI_OP_RELEASE6		= 0x17,
+	SCSI_OP_MODE_SENSE6		= 0x1A,
+	SCSI_OP_START_STOP_UNIT		= 0x1B,
+	SCSI_OP_SEND_DIAGNOSTIC		= 0x1D,
+	SCSI_OP_READ_CAPACITY		= 0x25,
+	SCSI_OP_READ10			= 0x28,
+	SCSI_OP_WRITE10			= 0x2A,
+	SCSI_OP_VERIFY10		= 0x2F,
+	SCSI_OP_READ_DEFECT_DATA	= 0x37,
+	SCSI_OP_LOG_SELECT		= 0x4C,
+	SCSI_OP_LOG_SENSE		= 0x4D,
+	SCSI_OP_MODE_SELECT10		= 0x55,
+	SCSI_OP_RESERVE10		= 0x56,
+	SCSI_OP_RELEASE10		= 0x57,
+	SCSI_OP_MODE_SENSE10		= 0x5A,
+	SCSI_OP_PER_RESERVE_IN		= 0x5E,
+	SCSI_OP_PER_RESERVE_OUR		= 0x5E,
+	SCSI_OP_READ16			= 0x88,
+	SCSI_OP_WRITE16			= 0x8A,
+	SCSI_OP_VERIFY16		= 0x8F,
+	SCSI_OP_READ_CAPACITY16		= 0x9E,
+	SCSI_OP_REPORT_LUNS		= 0xA0,
+	SCSI_OP_READ12			= 0xA8,
+	SCSI_OP_WRITE12			= 0xAA,
+	SCSI_OP_UNDEF			= 0xFF,
+};
+
+/*
+ * SCSI START_STOP_UNIT command
+ */
+struct scsi_start_stop_unit_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved1:4;
+	u8         immed:1;
+#else
+	u8         immed:1;
+	u8         reserved1:4;
+	u8         lun:3;
+#endif
+	u8         reserved2;
+	u8         reserved3;
+#ifdef __BIGENDIAN
+	u8         power_conditions:4;
+	u8         reserved4:2;
+	u8         loEj:1;
+	u8         start:1;
+#else
+	u8         start:1;
+	u8         loEj:1;
+	u8         reserved4:2;
+	u8         power_conditions:4;
+#endif
+	u8         control;
+};
+
+/*
+ * SCSI SEND_DIAGNOSTIC command
+ */
+struct scsi_send_diagnostic_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         self_test_code:3;
+	u8         pf:1;
+	u8         reserved1:1;
+	u8         self_test:1;
+	u8         dev_offl:1;
+	u8         unit_offl:1;
+#else
+	u8         unit_offl:1;
+	u8         dev_offl:1;
+	u8         self_test:1;
+	u8         reserved1:1;
+	u8         pf:1;
+	u8         self_test_code:3;
+#endif
+	u8         reserved2;
+
+	u8         param_list_length[2];	/* MSB first */
+	u8         control;
+
+};
+
+/*
+ * SCSI READ10/WRITE10 commands
+ */
+struct scsi_rw10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         dpo:1;	/* Disable Page Out */
+	u8         fua:1;	/* Force Unit Access */
+	u8         reserved1:2;
+	u8         rel_adr:1;	/* relative address */
+#else
+	u8         rel_adr:1;
+	u8         reserved1:2;
+	u8         fua:1;
+	u8         dpo:1;
+	u8         lun:3;
+#endif
+	u8         lba0;	/* logical block address - MSB */
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;	/* LSB */
+	u8         reserved3;
+	u8         xfer_length0;	/* transfer length in blocks - MSB */
+	u8         xfer_length1;	/* LSB */
+	u8         control;
+};
+
+#define SCSI_CDB10_GET_LBA(cdb)                     \
+    (((cdb)->lba0 << 24) | ((cdb)->lba1 << 16) |    \
+     ((cdb)->lba2 << 8) | (cdb)->lba3)
+
+#define SCSI_CDB10_SET_LBA(cdb, lba) {      \
+    (cdb)->lba0 = lba >> 24;            \
+    (cdb)->lba1 = (lba >> 16) & 0xFF;   \
+    (cdb)->lba2 = (lba >> 8) & 0xFF;    \
+    (cdb)->lba3 = lba & 0xFF;           \
+}
+
+#define SCSI_CDB10_GET_TL(cdb)  \
+    ((cdb)->xfer_length0 << 8 | (cdb)->xfer_length1)
+#define SCSI_CDB10_SET_TL(cdb, tl) {      \
+    (cdb)->xfer_length0 = tl >> 8;       \
+    (cdb)->xfer_length1 = tl & 0xFF;     \
+}
+
+/*
+ * SCSI READ6/WRITE6 commands
+ */
+struct scsi_rw6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         lba0:5;		/* MSb */
+#else
+	u8         lba0:5;		/* MSb */
+	u8         lun:3;
+#endif
+	u8         lba1;
+	u8         lba2;		/* LSB */
+	u8         xfer_length;
+	u8         control;
+};
+
+#define SCSI_TAPE_CDB6_GET_TL(cdb)              \
+    (((cdb)->tl0 << 16) | ((cdb)->tl1 << 8) | (cdb)->tl2)
+
+#define SCSI_TAPE_CDB6_SET_TL(cdb, tl) {      \
+    (cdb)->tl0 = tl >> 16;            \
+    (cdb)->tl1 = (tl >> 8) & 0xFF;    \
+    (cdb)->tl2 = tl & 0xFF;           \
+}
+
+/*
+ * SCSI sequential (TAPE) wrtie command
+ */
+struct scsi_tape_wr_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         rsvd:7;
+	u8         fixed:1;	/* MSb */
+#else
+	u8         fixed:1;	/* MSb */
+	u8         rsvd:7;
+#endif
+	u8         tl0;		/* Msb */
+	u8         tl1;
+	u8         tl2;		/* Lsb */
+
+	u8         control;
+};
+
+#define SCSI_CDB6_GET_LBA(cdb)              \
+    (((cdb)->lba0 << 16) | ((cdb)->lba1 << 8) | (cdb)->lba2)
+
+#define SCSI_CDB6_SET_LBA(cdb, lba) {      \
+    (cdb)->lba0 = lba >> 16;            \
+    (cdb)->lba1 = (lba >> 8) & 0xFF;    \
+    (cdb)->lba2 = lba & 0xFF;           \
+}
+
+#define SCSI_CDB6_GET_TL(cdb) ((cdb)->xfer_length)
+#define SCSI_CDB6_SET_TL(cdb, tl) {      \
+    (cdb)->xfer_length = tl;         \
+}
+
+/*
+ * SCSI sense data format
+ */
+struct scsi_sense_s{
+#ifdef __BIGENDIAN
+	u8         valid:1;
+	u8         rsp_code:7;
+#else
+	u8         rsp_code:7;
+	u8         valid:1;
+#endif
+	u8         seg_num;
+#ifdef __BIGENDIAN
+	u8         file_mark:1;
+	u8         eom:1;		/* end of media */
+	u8         ili:1;		/* incorrect length indicator */
+	u8         reserved:1;
+	u8         sense_key:4;
+#else
+	u8         sense_key:4;
+	u8         reserved:1;
+	u8         ili:1;		/* incorrect length indicator */
+	u8         eom:1;		/* end of media */
+	u8         file_mark:1;
+#endif
+	u8         information[4];	/* device-type or command specific info
+					 */
+	u8         add_sense_length;
+					/* additional sense length */
+	u8         command_info[4];/* command specific information
+						 */
+	u8         asc;		/* additional sense code */
+	u8         ascq;		/* additional sense code qualifier */
+	u8         fru_code;	/* field replaceable unit code */
+#ifdef __BIGENDIAN
+	u8         sksv:1;		/* sense key specific valid */
+	u8         c_d:1;		/* command/data bit */
+	u8         res1:2;
+	u8         bpv:1;		/* bit pointer valid */
+	u8         bpointer:3;	/* bit pointer */
+#else
+	u8         bpointer:3;	/* bit pointer */
+	u8         bpv:1;		/* bit pointer valid */
+	u8         res1:2;
+	u8         c_d:1;		/* command/data bit */
+	u8         sksv:1;		/* sense key specific valid */
+#endif
+	u8         fpointer[2];	/* field pointer */
+};
+
+#define SCSI_SENSE_CUR_ERR          0x70
+#define SCSI_SENSE_DEF_ERR          0x71
+
+/*
+ * SCSI sense key values
+ */
+#define SCSI_SK_NO_SENSE        0x0
+#define SCSI_SK_REC_ERR         0x1	/* recovered error */
+#define SCSI_SK_NOT_READY       0x2
+#define SCSI_SK_MED_ERR         0x3	/* medium error */
+#define SCSI_SK_HW_ERR          0x4	/* hardware error */
+#define SCSI_SK_ILLEGAL_REQ     0x5
+#define SCSI_SK_UNIT_ATT        0x6	/* unit attention */
+#define SCSI_SK_DATA_PROTECT    0x7
+#define SCSI_SK_BLANK_CHECK     0x8
+#define SCSI_SK_VENDOR_SPEC     0x9
+#define SCSI_SK_COPY_ABORTED    0xA
+#define SCSI_SK_ABORTED_CMND    0xB
+#define SCSI_SK_VOL_OVERFLOW    0xD
+#define SCSI_SK_MISCOMPARE      0xE
+
+/*
+ * SCSI additional sense codes
+ */
+#define SCSI_ASC_NO_ADD_SENSE           0x00
+#define SCSI_ASC_LUN_NOT_READY          0x04
+#define SCSI_ASC_LUN_COMMUNICATION      0x08
+#define SCSI_ASC_WRITE_ERROR            0x0C
+#define SCSI_ASC_INVALID_CMND_CODE      0x20
+#define SCSI_ASC_BAD_LBA                0x21
+#define SCSI_ASC_INVALID_FIELD_IN_CDB   0x24
+#define SCSI_ASC_LUN_NOT_SUPPORTED      0x25
+#define SCSI_ASC_LUN_WRITE_PROTECT      0x27
+#define SCSI_ASC_POWERON_BDR            0x29	/* power on reset, bus reset,
+						 * bus device reset
+						 */
+#define SCSI_ASC_PARAMS_CHANGED         0x2A
+#define SCSI_ASC_CMND_CLEARED_BY_A_I    0x2F
+#define SCSI_ASC_SAVING_PARAM_NOTSUPP   0x39
+#define SCSI_ASC_TOCC                   0x3F	/* target operating condtions
+						 * changed
+						 */
+#define SCSI_ASC_PARITY_ERROR           0x47
+#define SCSI_ASC_CMND_PHASE_ERROR       0x4A
+#define SCSI_ASC_DATA_PHASE_ERROR       0x4B
+#define SCSI_ASC_VENDOR_SPEC            0x7F
+
+/*
+ * SCSI additional sense code qualifiers
+ */
+#define SCSI_ASCQ_CAUSE_NOT_REPORT      0x00
+#define SCSI_ASCQ_BECOMING_READY        0x01
+#define SCSI_ASCQ_INIT_CMD_REQ          0x02
+#define SCSI_ASCQ_FORMAT_IN_PROGRESS    0x04
+#define SCSI_ASCQ_OPERATION_IN_PROGRESS 0x07
+#define SCSI_ASCQ_SELF_TEST_IN_PROGRESS 0x09
+#define SCSI_ASCQ_WR_UNEXP_UNSOL_DATA   0x0C
+#define SCSI_ASCQ_WR_NOTENG_UNSOL_DATA  0x0D
+
+#define SCSI_ASCQ_LBA_OUT_OF_RANGE      0x00
+#define SCSI_ASCQ_INVALID_ELEMENT_ADDR  0x01
+
+#define SCSI_ASCQ_LUN_WRITE_PROTECTED       0x00
+#define SCSI_ASCQ_LUN_HW_WRITE_PROTECTED    0x01
+#define SCSI_ASCQ_LUN_SW_WRITE_PROTECTED    0x02
+
+#define SCSI_ASCQ_POR   0x01	/* power on reset */
+#define SCSI_ASCQ_SBR   0x02	/* scsi bus reset */
+#define SCSI_ASCQ_BDR   0x03	/* bus device reset */
+#define SCSI_ASCQ_DIR   0x04	/* device internal reset */
+
+#define SCSI_ASCQ_MODE_PARAMS_CHANGED       0x01
+#define SCSI_ASCQ_LOG_PARAMS_CHANGED        0x02
+#define SCSI_ASCQ_RESERVATIONS_PREEMPTED    0x03
+#define SCSI_ASCQ_RESERVATIONS_RELEASED     0x04
+#define SCSI_ASCQ_REGISTRATIONS_PREEMPTED   0x05
+
+#define SCSI_ASCQ_MICROCODE_CHANGED 0x01
+#define SCSI_ASCQ_CHANGED_OPER_COND 0x02
+#define SCSI_ASCQ_INQ_CHANGED       0x03	/* inquiry data changed */
+#define SCSI_ASCQ_DI_CHANGED        0x05	/* device id changed */
+#define SCSI_ASCQ_RL_DATA_CHANGED   0x0E	/* report luns data changed */
+
+#define SCSI_ASCQ_DP_CRC_ERR            0x01	/* data phase crc error */
+#define SCSI_ASCQ_DP_SCSI_PARITY_ERR    0x02	/* data phase scsi parity error
+						 */
+#define SCSI_ASCQ_IU_CRC_ERR            0x03	/* information unit crc error */
+#define SCSI_ASCQ_PROTO_SERV_CRC_ERR    0x05
+
+#define SCSI_ASCQ_LUN_TIME_OUT          0x01
+
+/* ------------------------------------------------------------
+ * SCSI INQUIRY
+ * ------------------------------------------------------------*/
+
+struct scsi_inquiry_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved1:3;
+	u8         cmd_dt:1;
+	u8         evpd:1;
+#else
+	u8         evpd:1;
+	u8         cmd_dt:1;
+	u8         reserved1:3;
+	u8         lun:3;
+#endif
+	u8         page_code;
+	u8         reserved2;
+	u8         alloc_length;
+	u8         control;
+};
+
+struct scsi_inquiry_vendor_s{
+	u8         vendor_id[8];
+};
+
+struct scsi_inquiry_prodid_s{
+	u8         product_id[16];
+};
+
+struct scsi_inquiry_prodrev_s{
+	u8         product_rev[4];
+};
+
+struct scsi_inquiry_data_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;	/* peripheral qualifier */
+	u8         device_type:5;		/* peripheral device type */
+
+	u8         rmb:1;			/* removable medium bit */
+	u8         device_type_mod:7;	/* device type modifier */
+
+	u8         version;
+
+	u8         aenc:1;		/* async event notification capability
+					 */
+	u8         trm_iop:1;	/* terminate I/O process */
+	u8         norm_aca:1;	/* normal ACA supported */
+	u8         hi_support:1;	/* SCSI-3: supports REPORT LUNS */
+	u8         rsp_data_format:4;
+
+	u8         additional_len;
+	u8         sccs:1;
+	u8         reserved1:7;
+
+	u8         reserved2:1;
+	u8         enc_serv:1;	/* enclosure service component */
+	u8         reserved3:1;
+	u8         multi_port:1;	/* multi-port device */
+	u8         m_chngr:1;	/* device in medium transport element */
+	u8         ack_req_q:1;	/* SIP specific bit */
+	u8         addr32:1;	/* SIP specific bit */
+	u8         addr16:1;	/* SIP specific bit */
+
+	u8         rel_adr:1;	/* relative address */
+	u8         w_bus32:1;
+	u8         w_bus16:1;
+	u8         synchronous:1;
+	u8         linked_commands:1;
+	u8         trans_dis:1;
+	u8         cmd_queue:1;	/* command queueing supported */
+	u8         soft_reset:1;	/* soft reset alternative (VS) */
+#else
+	u8         device_type:5;	/* peripheral device type */
+	u8         peripheral_qual:3;
+					/* peripheral qualifier */
+
+	u8         device_type_mod:7;
+					/* device type modifier */
+	u8         rmb:1;		/* removable medium bit */
+
+	u8         version;
+
+	u8         rsp_data_format:4;
+	u8         hi_support:1;	/* SCSI-3: supports REPORT LUNS */
+	u8         norm_aca:1;	/* normal ACA supported */
+	u8         terminate_iop:1;/* terminate I/O process */
+	u8         aenc:1;		/* async event notification capability
+					 */
+
+	u8         additional_len;
+	u8         reserved1:7;
+	u8         sccs:1;
+
+	u8         addr16:1;	/* SIP specific bit */
+	u8         addr32:1;	/* SIP specific bit */
+	u8         ack_req_q:1;	/* SIP specific bit */
+	u8         m_chngr:1;	/* device in medium transport element */
+	u8         multi_port:1;	/* multi-port device */
+	u8         reserved3:1;	/* TBD - Vendor Specific */
+	u8         enc_serv:1;	/* enclosure service component */
+	u8         reserved2:1;
+
+	u8         soft_seset:1;	/* soft reset alternative (VS) */
+	u8         cmd_queue:1;	/* command queueing supported */
+	u8         trans_dis:1;
+	u8         linked_commands:1;
+	u8         synchronous:1;
+	u8         w_bus16:1;
+	u8         w_bus32:1;
+	u8         rel_adr:1;	/* relative address */
+#endif
+	struct scsi_inquiry_vendor_s vendor_id;
+	struct scsi_inquiry_prodid_s product_id;
+	struct scsi_inquiry_prodrev_s product_rev;
+	u8         vendor_specific[20];
+	u8         reserved4[40];
+};
+
+/*
+ * inquiry.peripheral_qual field values
+ */
+#define SCSI_DEVQUAL_DEFAULT        0
+#define SCSI_DEVQUAL_NOT_CONNECTED  1
+#define SCSI_DEVQUAL_NOT_SUPPORTED  3
+
+/*
+ * inquiry.device_type field values
+ */
+#define SCSI_DEVICE_DIRECT_ACCESS       0x00
+#define SCSI_DEVICE_SEQ_ACCESS          0x01
+#define SCSI_DEVICE_ARRAY_CONTROLLER    0x0C
+#define SCSI_DEVICE_UNKNOWN             0x1F
+
+/*
+ * inquiry.version
+ */
+#define SCSI_VERSION_ANSI_X3131     2	/* ANSI X3.131 SCSI-2 */
+#define SCSI_VERSION_SPC            3	/* SPC (SCSI-3), ANSI X3.301:1997 */
+#define SCSI_VERSION_SPC_2          4	/* SPC-2 */
+
+/*
+ * response data format
+ */
+#define SCSI_RSP_DATA_FORMAT        2	/* SCSI-2 & SPC */
+
+/*
+ * SCSI inquiry page codes
+ */
+#define SCSI_INQ_PAGE_VPD_PAGES     0x00	/* supported vpd pages */
+#define SCSI_INQ_PAGE_USN_PAGE      0x80	/* unit serial number page */
+#define SCSI_INQ_PAGE_DEV_IDENT     0x83	/* device indentification page
+						 */
+#define SCSI_INQ_PAGES_MAX          3
+
+/*
+ * supported vital product data pages
+ */
+struct scsi_inq_page_vpd_pages_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;
+	u8         device_type:5;
+#else
+	u8         device_type:5;
+	u8         peripheral_qual:3;
+#endif
+	u8         page_code;
+	u8         reserved;
+	u8         page_length;
+	u8         pages[SCSI_INQ_PAGES_MAX];
+};
+
+/*
+ * Unit serial number page
+ */
+#define SCSI_INQ_USN_LEN 32
+
+struct scsi_inq_usn_s{
+	char            usn[SCSI_INQ_USN_LEN];
+};
+
+struct scsi_inq_page_usn_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;
+	u8         device_type:5;
+#else
+	u8         device_type:5;
+	u8         peripheral_qual:3;
+#endif
+	u8         page_code;
+	u8         reserved1;
+	u8         page_length;
+	struct scsi_inq_usn_s  usn;
+};
+
+enum {
+	SCSI_INQ_DIP_CODE_BINARY = 1,	/* identifier has binary value */
+	SCSI_INQ_DIP_CODE_ASCII = 2,	/* identifier has ascii value */
+};
+
+enum {
+	SCSI_INQ_DIP_ASSOC_LUN = 0,	/* id is associated with device */
+	SCSI_INQ_DIP_ASSOC_PORT = 1,	/* id is associated with port that
+					 * received the request
+					 */
+};
+
+enum {
+	SCSI_INQ_ID_TYPE_VENDOR = 1,
+	SCSI_INQ_ID_TYPE_IEEE = 2,
+	SCSI_INQ_ID_TYPE_FC_FS = 3,
+	SCSI_INQ_ID_TYPE_OTHER = 4,
+};
+
+struct scsi_inq_dip_desc_s{
+#ifdef __BIGENDIAN
+	u8         res0:4;
+	u8         code_set:4;
+	u8         res1:2;
+	u8         association:2;
+	u8         id_type:4;
+#else
+	u8         code_set:4;
+	u8         res0:4;
+	u8         id_type:4;
+	u8         association:2;
+	u8         res1:2;
+#endif
+	u8         res2;
+	u8         id_len;
+	struct scsi_lun_sn_s   id;
+};
+
+/*
+ * Device indentification page
+ */
+struct scsi_inq_page_dev_ident_s{
+#ifdef __BIGENDIAN
+	u8         peripheral_qual:3;
+	u8         device_type:5;
+#else
+	u8         device_type:5;
+	u8         peripheral_qual:3;
+#endif
+	u8         page_code;
+	u8         reserved1;
+	u8         page_length;
+	struct scsi_inq_dip_desc_s desc;
+};
+
+/* ------------------------------------------------------------
+ * READ CAPACITY
+ * ------------------------------------------------------------
+ */
+
+struct scsi_read_capacity_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved1:4;
+	u8         rel_adr:1;
+#else
+	u8         rel_adr:1;
+	u8         reserved1:4;
+	u8         lun:3;
+#endif
+	u8         lba0;	/* MSB */
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;	/* LSB */
+	u8         reserved2;
+	u8         reserved3;
+#ifdef __BIGENDIAN
+	u8         reserved4:7;
+	u8         pmi:1;	/* partial medium indicator */
+#else
+	u8         pmi:1;	/* partial medium indicator */
+	u8         reserved4:7;
+#endif
+	u8         control;
+};
+
+struct scsi_read_capacity_data_s{
+	u32        max_lba;	/* maximum LBA available */
+	u32        block_length;	/* in bytes */
+};
+
+struct scsi_read_capacity16_data_s{
+	u64        lba;	/* maximum LBA available */
+	u32        block_length;	/* in bytes */
+#ifdef __BIGENDIAN
+	u8         reserved1:4,
+			p_type:3,
+			prot_en:1;
+	u8		reserved2:4,
+			lb_pbe:4;	/* logical blocks per physical block
+					 * exponent */
+	u16	reserved3:2,
+			lba_align:14;	/* lowest aligned logical block
+					 * address */
+#else
+	u16	lba_align:14,	/* lowest aligned logical block
+					 * address */
+			reserved3:2;
+	u8		lb_pbe:4,	/* logical blocks per physical block
+					 * exponent */
+			reserved2:4;
+	u8		prot_en:1,
+			p_type:3,
+			reserved1:4;
+#endif
+	u64	reserved4;
+	u64	reserved5;
+};
+
+/* ------------------------------------------------------------
+ * REPORT LUNS command
+ * ------------------------------------------------------------
+ */
+
+struct scsi_report_luns_s{
+	u8         opcode;		/* A0h - REPORT LUNS opCode */
+	u8         reserved1[5];
+	u8         alloc_length[4];/* allocation length MSB first */
+	u8         reserved2;
+	u8         control;
+};
+
+#define SCSI_REPORT_LUN_ALLOC_LENGTH(rl)                		\
+    ((rl->alloc_length[0] << 24) | (rl->alloc_length[1] << 16) | 	\
+     (rl->alloc_length[2] << 8) | (rl->alloc_length[3]))
+
+#define SCSI_REPORT_LUNS_SET_ALLOCLEN(rl, alloc_len) {      \
+    (rl)->alloc_length[0] = (alloc_len) >> 24;      			\
+    (rl)->alloc_length[1] = ((alloc_len) >> 16) & 0xFF; 		\
+    (rl)->alloc_length[2] = ((alloc_len) >> 8) & 0xFF;  		\
+    (rl)->alloc_length[3] = (alloc_len) & 0xFF;     			\
+}
+
+struct scsi_report_luns_data_s{
+	u32        lun_list_length;	/* length of LUN list length */
+	u32        reserved;
+	lun_t           lun[1];			/* first LUN in lun list */
+};
+
+/* -------------------------------------------------------------
+ * SCSI mode  parameters
+ * -----------------------------------------------------------
+ */
+enum {
+	SCSI_DA_MEDIUM_DEF = 0,	/* direct access default medium type */
+	SCSI_DA_MEDIUM_SS = 1,	/* direct access single sided */
+	SCSI_DA_MEDIUM_DS = 2,	/* direct access double sided */
+};
+
+/*
+ * SCSI Mode Select(6) cdb
+ */
+struct scsi_mode_select6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         pf:1;		/* page format */
+	u8         reserved2:3;
+	u8         sp:1;		/* save pages if set to 1 */
+#else
+	u8         sp:1;	/* save pages if set to 1 */
+	u8         reserved2:3;
+	u8         pf:1;	/* page format */
+	u8         reserved1:3;
+#endif
+	u8         reserved3[2];
+	u8         alloc_len;
+	u8         control;
+};
+
+/*
+ * SCSI Mode Select(10) cdb
+ */
+struct scsi_mode_select10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         pf:1;	/* page format */
+	u8         reserved2:3;
+	u8         sp:1;	/* save pages if set to 1 */
+#else
+	u8         sp:1;	/* save pages if set to 1 */
+	u8         reserved2:3;
+	u8         pf:1;	/* page format */
+	u8         reserved1:3;
+#endif
+	u8         reserved3[5];
+	u8         alloc_len_msb;
+	u8         alloc_len_lsb;
+	u8         control;
+};
+
+/*
+ * SCSI Mode Sense(6) cdb
+ */
+struct scsi_mode_sense6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:4;
+	u8         dbd:1;	/* disable block discriptors if set to 1 */
+	u8         reserved2:3;
+
+	u8         pc:2;	/* page control */
+	u8         page_code:6;
+#else
+	u8         reserved2:3;
+	u8         dbd:1;	/* disable block descriptors if set to 1 */
+	u8         reserved1:4;
+
+	u8         page_code:6;
+	u8         pc:2;	/* page control */
+#endif
+	u8         reserved3;
+	u8         alloc_len;
+	u8         control;
+};
+
+/*
+ * SCSI Mode Sense(10) cdb
+ */
+struct scsi_mode_sense10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         LLBAA:1;	/* long LBA accepted if set to 1 */
+	u8         dbd:1;		/* disable block descriptors if set
+					 * to 1
+					 */
+	u8         reserved2:3;
+
+	u8         pc:2;		/* page control */
+	u8         page_code:6;
+#else
+	u8         reserved2:3;
+	u8         dbd:1;		/* disable block descriptors if set to
+					 * 1
+					 */
+	u8         LLBAA:1;	/* long LBA accepted if set to 1 */
+	u8         reserved1:3;
+
+	u8         page_code:6;
+	u8         pc:2;		/* page control */
+#endif
+	u8         reserved3[4];
+	u8         alloc_len_msb;
+	u8         alloc_len_lsb;
+	u8         control;
+};
+
+#define SCSI_CDB10_GET_AL(cdb)  					\
+    ((cdb)->alloc_len_msb << 8 | (cdb)->alloc_len_lsb)
+
+#define SCSI_CDB10_SET_AL(cdb, al) {      \
+    (cdb)->alloc_len_msb = al >> 8;       				\
+    (cdb)->alloc_len_lsb = al & 0xFF;     				\
+}
+
+#define SCSI_CDB6_GET_AL(cdb) ((cdb)->alloc_len)
+
+#define SCSI_CDB6_SET_AL(cdb, al) {      \
+    (cdb)->alloc_len = al;         					\
+}
+
+/*
+ * page control field values
+ */
+#define SCSI_PC_CURRENT_VALUES       0x0
+#define SCSI_PC_CHANGEABLE_VALUES    0x1
+#define SCSI_PC_DEFAULT_VALUES       0x2
+#define SCSI_PC_SAVED_VALUES         0x3
+
+/*
+ * SCSI mode page codes
+ */
+#define SCSI_MP_VENDOR_SPEC     0x00
+#define SCSI_MP_DISC_RECN       0x02	/* disconnect-reconnect page */
+#define SCSI_MP_FORMAT_DEVICE   0x03
+#define SCSI_MP_RDG             0x04	/* rigid disk geometry page */
+#define SCSI_MP_FDP             0x05	/* flexible disk page */
+#define SCSI_MP_CACHING         0x08	/* caching page */
+#define SCSI_MP_CONTROL         0x0A	/* control mode page */
+#define SCSI_MP_MED_TYPES_SUP   0x0B	/* medium types supported page */
+#define SCSI_MP_INFO_EXCP_CNTL  0x1C	/* informational exception control */
+#define SCSI_MP_ALL             0x3F	/* return all pages - mode sense only */
+
+/*
+ * mode parameter header
+ */
+struct scsi_mode_param_header6_s{
+	u8         mode_datalen;
+	u8         medium_type;
+
+	/*
+	 * device specific parameters expanded for direct access devices
+	 */
+#ifdef __BIGENDIAN
+	u32        wp:1;		/* write protected */
+	u32        reserved1:2;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved2:4;
+#else
+	u32        reserved2:4;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved1:2;
+	u32        wp:1;		/* write protected */
+#endif
+
+	u8         block_desclen;
+};
+
+struct scsi_mode_param_header10_s{
+	u32        mode_datalen:16;
+	u32        medium_type:8;
+
+	/*
+	 * device specific parameters expanded for direct access devices
+	 */
+#ifdef __BIGENDIAN
+	u32        wp:1;		/* write protected */
+	u32        reserved1:2;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved2:4;
+#else
+	u32        reserved2:4;
+	u32        dpofua:1;	/* disable page out + force unit access
+					 */
+	u32        reserved1:2;
+	u32        wp:1;		/* write protected */
+#endif
+
+#ifdef __BIGENDIAN
+	u32        reserved3:7;
+	u32        longlba:1;
+#else
+	u32        longlba:1;
+	u32        reserved3:7;
+#endif
+	u32        reserved4:8;
+	u32        block_desclen:16;
+};
+
+/*
+ * mode parameter block descriptor
+ */
+struct scsi_mode_param_desc_s{
+	u32        nblks;
+	u32        density_code:8;
+	u32        block_length:24;
+};
+
+/*
+ * Disconnect-reconnect mode page format
+ */
+struct scsi_mp_disc_recn_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+	u8         buf_full_ratio;
+	u8         buf_empty_ratio;
+
+	u8         bil_msb;	/* bus inactivity limit -MSB */
+	u8         bil_lsb;	/* bus inactivity limit -LSB */
+
+	u8         dtl_msb;	/* disconnect time limit - MSB */
+	u8         dtl_lsb;	/* disconnect time limit - LSB */
+
+	u8         ctl_msb;	/* connect time limit - MSB */
+	u8         ctl_lsb;	/* connect time limit - LSB */
+
+	u8         max_burst_len_msb;
+	u8         max_burst_len_lsb;
+#ifdef __BIGENDIAN
+	u8         emdp:1;	/* enable modify data pointers */
+	u8         fa:3;	/* fair arbitration */
+	u8         dimm:1;	/* disconnect immediate */
+	u8         dtdc:3;	/* data transfer disconnect control */
+#else
+	u8         dtdc:3;	/* data transfer disconnect control */
+	u8         dimm:1;	/* disconnect immediate */
+	u8         fa:3;	/* fair arbitration */
+	u8         emdp:1;	/* enable modify data pointers */
+#endif
+
+	u8         reserved3;
+
+	u8         first_burst_len_msb;
+	u8         first_burst_len_lsb;
+};
+
+/*
+ * SCSI format device mode page
+ */
+struct scsi_mp_format_device_s{
+#ifdef __BIGENDIAN
+	u32        ps:1;
+	u32        reserved1:1;
+	u32        page_code:6;
+#else
+	u32        page_code:6;
+	u32        reserved1:1;
+	u32        ps:1;
+#endif
+	u32        page_len:8;
+	u32        tracks_per_zone:16;
+
+	u32        a_sec_per_zone:16;
+	u32        a_tracks_per_zone:16;
+
+	u32        a_tracks_per_lun:16;	/* alternate tracks/lun-MSB */
+	u32        sec_per_track:16;	/* sectors/track-MSB */
+
+	u32        bytes_per_sector:16;
+	u32        interleave:16;
+
+	u32        tsf:16;			/* track skew factor-MSB */
+	u32        csf:16;			/* cylinder skew factor-MSB */
+
+#ifdef __BIGENDIAN
+	u32        ssec:1;	/* soft sector formatting */
+	u32        hsec:1;	/* hard sector formatting */
+	u32        rmb:1;	/* removable media */
+	u32        surf:1;	/* surface */
+	u32        reserved2:4;
+#else
+	u32        reserved2:4;
+	u32        surf:1;	/* surface */
+	u32        rmb:1;	/* removable media */
+	u32        hsec:1;	/* hard sector formatting */
+	u32        ssec:1;	/* soft sector formatting */
+#endif
+	u32        reserved3:24;
+};
+
+/*
+ * SCSI rigid disk device geometry page
+ */
+struct scsi_mp_rigid_device_geometry_s{
+#ifdef __BIGENDIAN
+	u32        ps:1;
+	u32        reserved1:1;
+	u32        page_code:6;
+#else
+	u32        page_code:6;
+	u32        reserved1:1;
+	u32        ps:1;
+#endif
+	u32        page_len:8;
+	u32        num_cylinders0:8;
+	u32        num_cylinders1:8;
+
+	u32        num_cylinders2:8;
+	u32        num_heads:8;
+	u32        scwp0:8;
+	u32        scwp1:8;
+
+	u32        scwp2:8;
+	u32        scrwc0:8;
+	u32        scrwc1:8;
+	u32        scrwc2:8;
+
+	u32        dsr:16;
+	u32        lscyl0:8;
+	u32        lscyl1:8;
+
+	u32        lscyl2:8;
+#ifdef __BIGENDIAN
+	u32        reserved2:6;
+	u32        rpl:2;	/* rotational position locking */
+#else
+	u32        rpl:2;	/* rotational position locking */
+	u32        reserved2:6;
+#endif
+	u32        rot_off:8;
+	u32        reserved3:8;
+
+	u32        med_rot_rate:16;
+	u32        reserved4:16;
+};
+
+/*
+ * SCSI caching mode page
+ */
+struct scsi_mp_caching_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         res1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         res1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+#ifdef __BIGENDIAN
+	u8         ic:1;	/* initiator control */
+	u8         abpf:1;	/* abort pre-fetch */
+	u8         cap:1;	/* caching analysis permitted */
+	u8         disc:1;	/* discontinuity */
+	u8         size:1;	/* size enable */
+	u8         wce:1;	/* write cache enable */
+	u8         mf:1;	/* multiplication factor */
+	u8         rcd:1;	/* read cache disable */
+
+	u8         drrp:4;	/* demand read retention priority */
+	u8         wrp:4;	/* write retention priority */
+#else
+	u8         rcd:1;	/* read cache disable */
+	u8         mf:1;	/* multiplication factor */
+	u8         wce:1;	/* write cache enable */
+	u8         size:1;	/* size enable */
+	u8         disc:1;	/* discontinuity */
+	u8         cap:1;	/* caching analysis permitted */
+	u8         abpf:1;	/* abort pre-fetch */
+	u8         ic:1;	/* initiator control */
+
+	u8         wrp:4;	/* write retention priority */
+	u8         drrp:4;	/* demand read retention priority */
+#endif
+	u8         dptl[2];/* disable pre-fetch transfer length */
+	u8         min_prefetch[2];
+	u8         max_prefetch[2];
+	u8         max_prefetch_limit[2];
+#ifdef __BIGENDIAN
+	u8         fsw:1;	/* force sequential write */
+	u8         lbcss:1;/* logical block cache segment size */
+	u8         dra:1;	/* disable read ahead */
+	u8         vs:2;	/* vendor specific */
+	u8         res2:3;
+#else
+	u8         res2:3;
+	u8         vs:2;	/* vendor specific */
+	u8         dra:1;	/* disable read ahead */
+	u8         lbcss:1;/* logical block cache segment size */
+	u8         fsw:1;	/* force sequential write */
+#endif
+	u8         num_cache_segs;
+
+	u8         cache_seg_size[2];
+	u8         res3;
+	u8         non_cache_seg_size[3];
+};
+
+/*
+ * SCSI control mode page
+ */
+struct scsi_mp_control_page_s{
+#ifdef __BIGENDIAN
+u8         ps:1;
+u8         reserved1:1;
+u8         page_code:6;
+#else
+u8         page_code:6;
+u8         reserved1:1;
+u8         ps:1;
+#endif
+	u8         page_len;
+#ifdef __BIGENDIAN
+	u8         tst:3;		/* task set type */
+	u8         reserved3:3;
+	u8         gltsd:1;	/* global logging target save disable */
+	u8         rlec:1;		/* report log exception condition */
+
+	u8         qalgo_mod:4;	/* queue alogorithm modifier */
+	u8         reserved4:1;
+	u8         qerr:2;		/* queue error management */
+	u8         dque:1;		/* disable queuing */
+
+	u8         reserved5:1;
+	u8         rac:1;		/* report a check */
+	u8         reserved6:2;
+	u8         swp:1;		/* software write protect */
+	u8         raerp:1;	/* ready AER permission */
+	u8         uaaerp:1;	/* unit attenstion AER permission */
+	u8         eaerp:1;	/* error AER permission */
+
+	u8         reserved7:5;
+	u8         autoload_mod:3;
+#else
+	u8         rlec:1;		/* report log exception condition */
+	u8         gltsd:1;	/* global logging target save disable */
+	u8         reserved3:3;
+	u8         tst:3;		/* task set type */
+
+	u8         dque:1;		/* disable queuing */
+	u8         qerr:2;		/* queue error management */
+	u8         reserved4:1;
+	u8         qalgo_mod:4;	/* queue alogorithm modifier */
+
+	u8         eaerp:1;	/* error AER permission */
+	u8         uaaerp:1;	/* unit attenstion AER permission */
+	u8         raerp:1;	/* ready AER permission */
+	u8         swp:1;		/* software write protect */
+	u8         reserved6:2;
+	u8         rac:1;		/* report a check */
+	u8         reserved5:1;
+
+	u8         autoload_mod:3;
+	u8         reserved7:5;
+#endif
+	u8         rahp_msb;	/* ready AER holdoff period - MSB */
+	u8         rahp_lsb;	/* ready AER holdoff period - LSB */
+
+	u8         busy_timeout_period_msb;
+	u8         busy_timeout_period_lsb;
+
+	u8         ext_selftest_compl_time_msb;
+	u8         ext_selftest_compl_time_lsb;
+};
+
+/*
+ * SCSI medium types supported mode page
+ */
+struct scsi_mp_medium_types_sup_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+
+	u8         reserved3[2];
+	u8         med_type1_sup;	/* medium type one supported */
+	u8         med_type2_sup;	/* medium type two supported */
+	u8         med_type3_sup;	/* medium type three supported */
+	u8         med_type4_sup;	/* medium type four supported */
+};
+
+/*
+ * SCSI informational exception control mode page
+ */
+struct scsi_mp_info_excpt_cntl_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+#ifdef __BIGENDIAN
+	u8         perf:1;		/* performance */
+	u8         reserved3:1;
+	u8         ebf:1;		/* enable background fucntion */
+	u8         ewasc:1;	/* enable warning */
+	u8         dexcpt:1;	/* disable exception control */
+	u8         test:1;		/* enable test device failure
+					 * notification
+					 */
+	u8         reserved4:1;
+	u8         log_error:1;
+
+	u8         reserved5:4;
+	u8         mrie:4;		/* method of reporting info
+					 * exceptions
+					 */
+#else
+	u8         log_error:1;
+	u8         reserved4:1;
+	u8         test:1;		/* enable test device failure
+					 * notification
+					 */
+	u8         dexcpt:1;	/* disable exception control */
+	u8         ewasc:1;	/* enable warning */
+	u8         ebf:1;		/* enable background fucntion */
+	u8         reserved3:1;
+	u8         perf:1;		/* performance */
+
+	u8         mrie:4;		/* method of reporting info
+					 * exceptions
+					 */
+	u8         reserved5:4;
+#endif
+	u8         interval_timer_msb;
+	u8         interval_timer_lsb;
+
+	u8         report_count_msb;
+	u8         report_count_lsb;
+};
+
+/*
+ * Methods of reporting informational exceptions
+ */
+#define SCSI_MP_IEC_NO_REPORT       0x0	/* no reporting of exceptions */
+#define SCSI_MP_IEC_AER             0x1	/* async event reporting */
+#define SCSI_MP_IEC_UNIT_ATTN       0x2	/* generate unit attenstion */
+#define SCSI_MO_IEC_COND_REC_ERR    0x3	/* conditionally generate recovered
+					 * error
+					 */
+#define SCSI_MP_IEC_UNCOND_REC_ERR  0x4	/* unconditionally generate recovered
+					 * error
+					 */
+#define SCSI_MP_IEC_NO_SENSE        0x5	/* generate no sense */
+#define SCSI_MP_IEC_ON_REQUEST      0x6	/* only report exceptions on request */
+
+/*
+ * SCSI flexible disk page
+ */
+struct scsi_mp_flexible_disk_s{
+#ifdef __BIGENDIAN
+	u8         ps:1;
+	u8         reserved1:1;
+	u8         page_code:6;
+#else
+	u8         page_code:6;
+	u8         reserved1:1;
+	u8         ps:1;
+#endif
+	u8         page_len;
+
+	u8         transfer_rate_msb;
+	u8         transfer_rate_lsb;
+
+	u8         num_heads;
+	u8         num_sectors;
+
+	u8         bytes_per_sector_msb;
+	u8         bytes_per_sector_lsb;
+
+	u8         num_cylinders_msb;
+	u8         num_cylinders_lsb;
+
+	u8         sc_wpc_msb;	/* starting cylinder-write
+					 * precompensation msb
+					 */
+	u8         sc_wpc_lsb;	/* starting cylinder-write
+					 * precompensation lsb
+					 */
+	u8         sc_rwc_msb;	/* starting cylinder-reduced write
+					 * current msb
+					 */
+	u8         sc_rwc_lsb;	/* starting cylinder-reduced write
+					 * current lsb
+					 */
+
+	u8         dev_step_rate_msb;
+	u8         dev_step_rate_lsb;
+
+	u8         dev_step_pulse_width;
+
+	u8         head_sd_msb;	/* head settle delay msb */
+	u8         head_sd_lsb;	/* head settle delay lsb */
+
+	u8         motor_on_delay;
+	u8         motor_off_delay;
+#ifdef __BIGENDIAN
+	u8         trdy:1;		/* true ready bit */
+	u8         ssn:1;		/* start sector number bit */
+	u8         mo:1;		/* motor on bit */
+	u8         reserved3:5;
+
+	u8         reserved4:4;
+	u8         spc:4;		/* step pulse per cylinder */
+#else
+	u8         reserved3:5;
+	u8         mo:1;		/* motor on bit */
+	u8         ssn:1;		/* start sector number bit */
+	u8         trdy:1;		/* true ready bit */
+
+	u8         spc:4;		/* step pulse per cylinder */
+	u8         reserved4:4;
+#endif
+	u8         write_comp;
+	u8         head_load_delay;
+	u8         head_unload_delay;
+#ifdef __BIGENDIAN
+	u8         pin34:4;	/* pin34 usage */
+	u8         pin2:4;		/* pin2 usage */
+
+	u8         pin4:4;		/* pin4 usage */
+	u8         pin1:4;		/* pin1 usage */
+#else
+	u8         pin2:4;		/* pin2 usage */
+	u8         pin34:4;	/* pin34 usage */
+
+	u8         pin1:4;		/* pin1 usage */
+	u8         pin4:4;		/* pin4 usage */
+#endif
+	u8         med_rot_rate_msb;
+	u8         med_rot_rate_lsb;
+
+	u8         reserved5[2];
+};
+
+struct scsi_mode_page_format_data6_s{
+	struct scsi_mode_param_header6_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_format_device_s format;	/* format device data */
+};
+
+struct scsi_mode_page_format_data10_s{
+	struct scsi_mode_param_header10_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_format_device_s format;	/* format device data */
+};
+
+struct scsi_mode_page_rdg_data6_s{
+	struct scsi_mode_param_header6_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_rigid_device_geometry_s rdg;
+					/* rigid geometry data */
+};
+
+struct scsi_mode_page_rdg_data10_s{
+	struct scsi_mode_param_header10_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_rigid_device_geometry_s rdg;
+					/* rigid geometry data */
+};
+
+struct scsi_mode_page_cache6_s{
+	struct scsi_mode_param_header6_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_caching_s cache;	/* cache page data */
+};
+
+struct scsi_mode_page_cache10_s{
+	struct scsi_mode_param_header10_s mph;	/* mode page header */
+	struct scsi_mode_param_desc_s desc;	/* block descriptor */
+	struct scsi_mp_caching_s cache;	/* cache page data */
+};
+
+/* --------------------------------------------------------------
+ * Format Unit command
+ * ------------------------------------------------------------
+ */
+
+/*
+ * Format Unit CDB
+ */
+struct scsi_format_unit_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         res1:3;
+	u8         fmtdata:1;	/* if set, data out phase has format
+					 * data
+					 */
+	u8         cmplst:1;	/* if set, defect list is complete */
+	u8         def_list:3;	/* format of defect descriptor is
+					 * fmtdata =1
+					 */
+#else
+	u8         def_list:3;	/* format of defect descriptor is
+					 * fmtdata = 1
+					 */
+	u8         cmplst:1;	/* if set, defect list is complete */
+	u8         fmtdata:1;	/* if set, data out phase has format
+					 * data
+					 */
+	u8         res1:3;
+#endif
+	u8         interleave_msb;
+	u8         interleave_lsb;
+	u8         vendor_spec;
+	u8         control;
+};
+
+/*
+ * h
+ */
+struct scsi_reserve6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved:3;
+	u8         obsolete:4;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         obsolete:4;
+	u8         reserved:3;
+#endif
+	u8         reservation_id;
+	u16        param_list_len;
+	u8         control;
+};
+
+/*
+ * h
+ */
+struct scsi_release6_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         obsolete:4;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         obsolete:4;
+	u8         reserved1:3;
+#endif
+	u8         reservation_id;
+	u16        reserved2;
+	u8         control;
+};
+
+/*
+ * h
+ */
+struct scsi_reserve10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         third_party:1;
+	u8         reserved2:2;
+	u8         long_id:1;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         long_id:1;
+	u8         reserved2:2;
+	u8         third_party:1;
+	u8         reserved1:3;
+#endif
+	u8         reservation_id;
+	u8         third_pty_dev_id;
+	u8         reserved3;
+	u8         reserved4;
+	u8         reserved5;
+	u16        param_list_len;
+	u8         control;
+};
+
+struct scsi_release10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         third_party:1;
+	u8         reserved2:2;
+	u8         long_id:1;
+	u8         extent:1;
+#else
+	u8         extent:1;
+	u8         long_id:1;
+	u8         reserved2:2;
+	u8         third_party:1;
+	u8         reserved1:3;
+#endif
+	u8         reservation_id;
+	u8         third_pty_dev_id;
+	u8         reserved3;
+	u8         reserved4;
+	u8         reserved5;
+	u16        param_list_len;
+	u8         control;
+};
+
+struct scsi_verify10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         dpo:1;
+	u8         reserved:2;
+	u8         bytchk:1;
+	u8         reladdr:1;
+#else
+	u8         reladdr:1;
+	u8         bytchk:1;
+	u8         reserved:2;
+	u8         dpo:1;
+	u8         lun:3;
+#endif
+	u8         lba0;
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;
+	u8         reserved1;
+	u8         verification_len0;
+	u8         verification_len1;
+	u8         control_byte;
+};
+
+struct scsi_request_sense_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         lun:3;
+	u8         reserved:5;
+#else
+	u8         reserved:5;
+	u8         lun:3;
+#endif
+	u8         reserved0;
+	u8         reserved1;
+	u8         alloc_len;
+	u8         control_byte;
+};
+
+/* ------------------------------------------------------------
+ * SCSI status byte values
+ * ------------------------------------------------------------
+ */
+#define SCSI_STATUS_GOOD                   0x00
+#define SCSI_STATUS_CHECK_CONDITION        0x02
+#define SCSI_STATUS_CONDITION_MET          0x04
+#define SCSI_STATUS_BUSY                   0x08
+#define SCSI_STATUS_INTERMEDIATE           0x10
+#define SCSI_STATUS_ICM                    0x14	/* intermediate condition met */
+#define SCSI_STATUS_RESERVATION_CONFLICT   0x18
+#define SCSI_STATUS_COMMAND_TERMINATED     0x22
+#define SCSI_STATUS_QUEUE_FULL             0x28
+#define SCSI_STATUS_ACA_ACTIVE             0x30
+
+#define SCSI_MAX_ALLOC_LEN		0xFF	/* maximum allocarion length
+						 * in CDBs
+						 */
+
+#define SCSI_OP_WRITE_VERIFY10      0x2E
+#define SCSI_OP_WRITE_VERIFY12      0xAE
+#define SCSI_OP_UNDEF               0xFF
+
+/*
+ * SCSI WRITE-VERIFY(10) command
+ */
+struct scsi_write_verify10_s{
+	u8         opcode;
+#ifdef __BIGENDIAN
+	u8         reserved1:3;
+	u8         dpo:1;		/* Disable Page Out */
+	u8         reserved2:1;
+	u8         ebp:1;		/* erse by-pass */
+	u8         bytchk:1;	/* byte check */
+	u8         rel_adr:1;	/* relative address */
+#else
+	u8         rel_adr:1;	/* relative address */
+	u8         bytchk:1;	/* byte check */
+	u8         ebp:1;		/* erse by-pass */
+	u8         reserved2:1;
+	u8         dpo:1;		/* Disable Page Out */
+	u8         reserved1:3;
+#endif
+	u8         lba0;		/* logical block address - MSB */
+	u8         lba1;
+	u8         lba2;
+	u8         lba3;		/* LSB */
+	u8         reserved3;
+	u8         xfer_length0;	/* transfer length in blocks - MSB */
+	u8         xfer_length1;	/* LSB */
+	u8         control;
+};
+
+#pragma pack()
+
+#endif /* __SCSI_H__ */
diff -urpN orig/drivers/scsi/bfa/include/protocol/types.h patch/drivers/scsi/bfa/include/protocol/types.h
--- orig/drivers/scsi/bfa/include/protocol/types.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/include/protocol/types.h	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  types.h Protocol defined base types
+ */
+
+#ifndef __TYPES_H__
+#define __TYPES_H__
+
+#include <bfa_os_inc.h>
+
+#define wwn_t u64
+#define lun_t u64
+
+#define WWN_NULL	(0)
+#define FC_SYMNAME_MAX	256	/*  max name server symbolic name size */
+#define FC_ALPA_MAX	128
+
+#pragma pack(1)
+
+#define MAC_ADDRLEN	(6)
+struct mac_s { u8 mac[MAC_ADDRLEN]; };
+#define mac_t struct mac_s
+
+#pragma pack()
+
+#endif
