Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E964689;
	Fri,  2 May 2025 01:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746150705; cv=none; b=pqEcUzk61OerNjREDdSHeWqJ028LOm41Nxsf6xg+fj3eYzH189Nv3qEGM2WL8cL/Wuxwt5Ig96+PA+iubfJNPbcAyxiwPoPzmdubhXS9+OblLNnIkbwxU4xpEt5uNdlFtAYKOAhKoP7bf4zSrIUMRpOXvlnTvIYkHgGFqu7VJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746150705; c=relaxed/simple;
	bh=j7rsRkpEAW/hAbacUXDnhqUHnh+/fomqp9HA9gnFeQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q+XEW6IBYdH6bBVzJHArPLxdfk3TD8Mx61CcILumk/Qff20RdkSIUbjMdpMUoGItoK9COwKDhOiIoqtB7lNYya9RHoxq73g1vVFESVjLkhqfBLJexwEzNgaHE29Bz19bfF7fzlSqrTZYXc1lx9U7SB25Gqx0Q9OH9gDswgEk6DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y5qhGvU4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y5qhGvU4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WsZF3C0AbGMDgG/Mjl/rjZFe3PGIbsswPliTR+PjTAc=; b=Y5qhGvU4/nq+AVmY9l4QLbk+ni
	6rr3oL/jwx1xUuix4dwj/7tgY6R97HbSBaQl/FHYY4y234oNCoaNwW4WxGo0Ox6wQdEI2FNzGR68Q
	GCGBHUdN89qPg8TWgLiqRqWm2fJEztLPTNAHO7lUoBsqHBJAHZsNfjgqWqH0RSlHOS/lIidpCWR5G
	aGtTAhceYrm94nPHoBC30791omuicBCAWJD6+dyOoMzyCkID5KGqflPUoRhOzqwbUkKtxUPyulTue
	oy/Tbie+5p/1/pD/Lxyhlv/REBAyIOAeuzbnJurj6E7pAicsFYEPFp8xo6A/wC5rRcph1Dn0Rnfkp
	2AB+yaAg==;
Received: from [50.39.124.201] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAfYv-00000000X63-1LGr;
	Fri, 02 May 2025 01:51:37 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH] scsi: docs: clean up some style in scsi_mid_low_api
Date: Thu,  1 May 2025 18:51:36 -0700
Message-ID: <20250502015136.683691-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Capitalize Linux but not "kernel."
Spell out Linux instead of using "lk".
Hyphenate "system-wide."
Hyphenate "32-bit".
End a sentence with a period (full stop).
Change "double linked" to "doubly linked" list.
Use SCSI or scsi but not Scsi.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/scsi/scsi_mid_low_api.rst |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-next-20250501.orig/Documentation/scsi/scsi_mid_low_api.rst
+++ linux-next-20250501/Documentation/scsi/scsi_mid_low_api.rst
@@ -37,7 +37,7 @@ ISA adapters).]
 The SCSI mid level isolates an LLD from other layers such as the SCSI
 upper layer drivers and the block layer.
 
-This version of the document roughly matches linux kernel version 2.6.8 .
+This version of the document roughly matches Linux kernel version 2.6.8 .
 
 Documentation
 =============
@@ -48,7 +48,7 @@ found in that directory. A more recent c
 at https://docs.kernel.org/scsi/scsi_mid_low_api.html. Many LLDs are
 documented in Documentation/scsi (e.g. aic7xxx.rst). The SCSI mid-level is
 briefly described in scsi.rst which contains a URL to a document describing
-the SCSI subsystem in the Linux Kernel 2.4 series. Two upper level
+the SCSI subsystem in the Linux kernel 2.4 series. Two upper level
 drivers have documents in that directory: st.rst (SCSI tape driver) and
 scsi-generic.rst (for the sg driver).
 
@@ -75,7 +75,7 @@ It is probably best to study how existin
 As the 2.5 series development kernels evolve into the 2.6 series
 production series, changes are being introduced into this interface. An
 example of this is driver initialization code where there are now 2 models
-available. The older one, similar to what was found in the lk 2.4 series,
+available. The older one, similar to what was found in the Linux 2.4 series,
 is based on hosts that are detected at HBA driver load time. This will be
 referred to the "passive" initialization model. The newer model allows HBAs
 to be hot plugged (and unplugged) during the lifetime of the LLD and will
@@ -1026,7 +1026,7 @@ initialized from the driver's struct scs
 of interest:
 
     host_no
-		 - system wide unique number that is used for identifying
+		 - system-wide unique number that is used for identifying
                    this host. Issued in ascending order from 0.
     can_queue
 		 - must be greater than 0; do not send more than can_queue
@@ -1053,7 +1053,7 @@ of interest:
 		 - pointer to driver's struct scsi_host_template from which
                    this struct Scsi_Host instance was spawned
     hostt->proc_name
-		 - name of LLD. This is the driver name that sysfs uses
+		 - name of LLD. This is the driver name that sysfs uses.
     transportt
 		 - pointer to driver's struct scsi_transport_template instance
                    (if any). FC and SPI transports currently supported.
@@ -1067,7 +1067,7 @@ The scsi_host structure is defined in in
 struct scsi_device
 ------------------
 Generally, there is one instance of this structure for each SCSI logical unit
-on a host. Scsi devices connected to a host are uniquely identified by a
+on a host. SCSI devices connected to a host are uniquely identified by a
 channel number, target id and logical unit number (lun).
 The structure is defined in include/scsi/scsi_device.h
 
@@ -1091,7 +1091,7 @@ Members of interest:
 		 - should be set by LLD prior to calling 'done'. A value
                    of 0 implies a successfully completed command (and all
                    data (if any) has been transferred to or from the SCSI
-                   target device). 'result' is a 32 bit unsigned integer that
+                   target device). 'result' is a 32-bit unsigned integer that
                    can be viewed as 2 related bytes. The SCSI status value is
                    in the LSB. See include/scsi/scsi.h status_byte() and
                    host_byte() macros and related constants.
@@ -1180,8 +1180,8 @@ may get out of synchronization. This is
 to perform autosense.
 
 
-Changes since lk 2.4 series
-===========================
+Changes since Linux kernel 2.4 series
+=====================================
 io_request_lock has been replaced by several finer grained locks. The lock
 relevant to LLDs is struct Scsi_Host::host_lock and there is
 one per SCSI host.
