Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB2A184D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 02:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544872; cv=none; b=A4KA7gnCO7kIbMvwB5mOqLqyfkaTiD7aR+HqLEeEOnHtxTP0To11hSV6UPp+q6+SmbvqnT1iq8ZOXOV84DoclEOciFJ+iQamDyFvHLPdASVMplEH+WSg/scfSbWFJSWJAkiwrD/YTWIPQQVMJJP3K7dOQ1x7VvSLWiJeDF+Pi6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544872; c=relaxed/simple;
	bh=pJLITAG0DGxLch/58v9ERkPQWB5PUdWf4MKw4QTg7OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsRHKm6gx2pnv2Z6M7kir5xwOgdtzgMAoIhrzb/EfQdpXEl54GRlpacvdE1YXFZfBm9pflACLOzXLXgdorVUx3bSg6AYyBaixwgycfdHWTvGBMfRHMPNuCVipDfu86Dq7hHz1G2D2jSRoZ9L8fGtGVzMG4loGssk7uC6tG9Ab24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iJGW/HKa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iJGW/HKa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UVaoJyzLKt5P+feXrghAVBqnSV1yfyfLnRFeqcQxUw8=; b=iJGW/HKan+eFzLWPIl5Imnn7L9
	CuiDOQM/afZLYtxqgEvMKSqyVnavOuOGDJDOO3VJBsk4ou7K2YHlQHapFHrz6fZMZv02MCHYSaEsC
	TzxpR5aJQrS34i/zjFXb9qBD7/qOUb68i081tdEOshGIwDiSRr4zSyl9oa8FaSmauAEjmQJ3Cfq7n
	ku7m24RlOXq2m3S/k3GcGv3a1raO82vZepTsV71zZx0XKIDHDTjYBwcRXI9st0gMnPTp7Wj/cLUiI
	nt9mEJWCwR1AWIXvmC35L2mwIWdmeLdxQqKNcPdxE6fR53vRDafmDSjVl1g+eaSKR/kSU9bM5cQc4
	U1i7h4Gg==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9S-0000000E7aj-21Lh;
	Mon, 08 Apr 2024 02:54:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/8] scsi: libfcoe: fix a slew of kernel-doc warnings
Date: Sun,  7 Apr 2024 19:54:22 -0700
Message-ID: <20240408025425.18778-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408025425.18778-1-rdunlap@infradead.org>
References: <20240408025425.18778-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix all kernel-doc warnings in <scsi/libfcoe.h>:

libfcoe.h:163: warning: Function parameter or struct member 'ctlr' not described in 'fcoe_ctlr_priv'
libfcoe.h:163: warning: Excess function parameter 'cltr' description in 'fcoe_ctlr_priv'
libfcoe.h:163: warning: No description found for return value of 'fcoe_ctlr_priv'
libfcoe.h:218: warning: Function parameter or struct member 'fd_flags' not described in 'fcoe_fcf'
libfcoe.h:218: warning: Excess struct member 'event' description in 'fcoe_fcf'
libfcoe.h:240: warning: Function parameter or struct member 'rdata' not described in 'fcoe_rport'
libfcoe.h:273: warning: No description found for return value of 'is_fip_mode'
libfcoe.h:332: warning: Function parameter or struct member 'crc_eof_page' not described in 'fcoe_percpu_s'
libfcoe.h:332: warning: Function parameter or struct member 'lock' not described in 'fcoe_percpu_s'
libfcoe.h:332: warning: Excess struct member 'page' description in 'fcoe_percpu_s'
libfcoe.h:362: warning: Function parameter or struct member 'data_src_addr' not described in 'fcoe_port'
libfcoe.h:362: warning: Function parameter or struct member 'get_netdev' not described in 'fcoe_port'
libfcoe.h:362: warning: Excess struct member 'data_srt_addr' description in 'fcoe_port'
libfcoe.h:369: warning: No description found for return value of 'fcoe_get_netdev'
libfcoe.h:386: warning: missing initial short description on line:
 * struct netdev_list
libfcoe.h:393: warning: expecting prototype for struct netdev_list. Prototype was for struct fcoe_netdev_mapping instead

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>

 include/scsi/libfcoe.h |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -- a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -157,7 +157,9 @@ struct fcoe_ctlr {
 
 /**
  * fcoe_ctlr_priv() - Return the private data from a fcoe_ctlr
- * @cltr: The fcoe_ctlr whose private data will be returned
+ * @ctlr: The fcoe_ctlr whose private data will be returned
+ *
+ * Returns: pointer to the private data
  */
 static inline void *fcoe_ctlr_priv(const struct fcoe_ctlr *ctlr)
 {
@@ -174,7 +176,6 @@ static inline void *fcoe_ctlr_priv(const
  * struct fcoe_fcf - Fibre-Channel Forwarder
  * @list:	 list linkage
  * @event_work:  Work for FC Transport actions queue
- * @event:       The event to be processed
  * @fip:         The controller that the FCF was discovered on
  * @fcf_dev:     The associated fcoe_fcf_device instance
  * @time:	 system time (jiffies) when an advertisement was last received
@@ -188,6 +189,7 @@ static inline void *fcoe_ctlr_priv(const
  * @flogi_sent:	 current FLOGI sent to this FCF
  * @flags:	 flags received from advertisement
  * @fka_period:	 keep-alive period, in jiffies
+ * @fd_flags:	 no need for FKA from ENode
  *
  * A Fibre-Channel Forwarder (FCF) is the entity on the Ethernet that
  * passes FCoE frames on to an FC fabric.  This structure represents
@@ -222,6 +224,7 @@ struct fcoe_fcf {
 
 /**
  * struct fcoe_rport - VN2VN remote port
+ * @rdata:	libfc remote port private data
  * @time:	time of create or last beacon packet received from node
  * @fcoe_len:	max FCoE frame size, not including VLAN or Ethernet headers
  * @flags:	flags from probe or claim
@@ -266,8 +269,10 @@ void fcoe_get_lesb(struct fc_lport *, st
 void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev);
 
 /**
- * is_fip_mode() - returns true if FIP mode selected.
+ * is_fip_mode() - test if FIP mode selected.
  * @fip:	FCoE controller.
+ *
+ * Returns: %true if FIP mode is selected
  */
 static inline bool is_fip_mode(struct fcoe_ctlr *fip)
 {
@@ -318,9 +323,10 @@ struct fcoe_transport {
  * @kthread:	    The thread context (used by bnx2fc)
  * @work:	    The work item (used by fcoe)
  * @fcoe_rx_list:   The queue of pending packets to process
- * @page:	    The memory page for calculating frame trailer CRCs
+ * @crc_eof_page:   The memory page for calculating frame trailer CRCs
  * @crc_eof_offset: The offset into the CRC page pointing to available
  *		    memory for a new trailer
+ * @lock:	    local lock for members of this struct
  */
 struct fcoe_percpu_s {
 	struct task_struct *kthread;
@@ -343,7 +349,8 @@ struct fcoe_percpu_s {
  * @timer:		       The queue timer
  * @destroy_work:	       Handle for work context
  *			       (to prevent RTNL deadlocks)
- * @data_srt_addr:	       Source address for data
+ * @data_src_addr:	       Source address for data
+ * @get_netdev:                function that returns a &net_device from @lport
  *
  * An instance of this structure is to be allocated along with the
  * Scsi_Host and libfc fc_lport structures.
@@ -364,6 +371,8 @@ struct fcoe_port {
 /**
  * fcoe_get_netdev() - Return the net device associated with a local port
  * @lport: The local port to get the net device from
+ *
+ * Returns: the &net_device associated with this @lport
  */
 static inline struct net_device *fcoe_get_netdev(const struct fc_lport *lport)
 {
@@ -383,8 +392,10 @@ void fcoe_fcf_get_selected(struct fcoe_f
 void fcoe_ctlr_set_fip_mode(struct fcoe_ctlr_device *);
 
 /**
- * struct netdev_list
- * A mapping from netdevice to fcoe_transport
+ * struct fcoe_netdev_mapping - A mapping from &net_device to &fcoe_transport
+ * @list: list linkage of the mappings
+ * @netdev: the &net_device
+ * @ft: the fcoe_transport associated with @netdev
  */
 struct fcoe_netdev_mapping {
 	struct list_head list;
