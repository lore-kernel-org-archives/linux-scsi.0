From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] scsi/qla2xxx/qla_rscn.c: remove unused functions
Date: Fri, 29 Oct 2004 02:27:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041029002716.GA29142@stusta.de>
References: <20041028232101.GH3207@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263205AbUJ2Ac7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041028232101.GH3207@stusta.de>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[ this time without the problems due to a digital signature... ]

The patch below removes two unused functions from 
drivers/scsi/qla2xxx/qla_rscn.c


diffstat output:
 drivers/scsi/qla2xxx/qla_rscn.c |   26 --------------------------
 1 files changed, 26 deletions(-)


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm1-full/drivers/scsi/qla2xxx/qla_rscn.c.old	2004-10-28 23:26:04.000000000 +0200
+++ linux-2.6.10-rc1-mm1-full/drivers/scsi/qla2xxx/qla_rscn.c	2004-10-28 23:26:32.000000000 +0200
@@ -47,8 +47,6 @@
 /* Local Prototypes. */
 static inline uint32_t qla2x00_to_handle(uint16_t, uint16_t, uint16_t);
 static inline uint16_t qla2x00_handle_to_idx(uint32_t);
-static inline uint16_t qla2x00_handle_to_iter(uint32_t);
-static inline uint16_t qla2x00_handle_to_type(uint32_t);
 static inline uint32_t qla2x00_iodesc_to_handle(struct io_descriptor *);
 static inline struct io_descriptor *qla2x00_handle_to_iodesc(scsi_qla_host_t *,
     uint32_t);
@@ -130,30 +128,6 @@
 }
 
 /**
- * qla2x00_handle_to_type() - Retrive the descriptor type for a given handle.
- * @handle: descriptor handle
- *
- * Returns the descriptor type specified by the @handle.
- */
-static inline uint16_t
-qla2x00_handle_to_type(uint32_t handle)
-{
-	return ((uint16_t)(((handle) >> HDL_TYPE_SHIFT) & HDL_TYPE_MASK));
-}
-
-/**
- * qla2x00_handle_to_iter() - Retrive the rolling signature for a given handle.
- * @handle: descriptor handle
- *
- * Returns the signature specified by the @handle.
- */
-static inline uint16_t
-qla2x00_handle_to_iter(uint32_t handle)
-{
-	return ((uint16_t)(((handle) >> HDL_ITER_SHIFT) & HDL_ITER_MASK));
-}
-
-/**
  * qla2x00_iodesc_to_handle() - Convert an IO descriptor to a unique handle.
  * @iodesc: io descriptor
  *
