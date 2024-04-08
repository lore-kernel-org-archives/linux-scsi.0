Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F28317F6;
	Mon,  8 Apr 2024 02:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544873; cv=none; b=h0TGWsH9TQJw3KKVfPxUxozURdxdQ2P/+KBjzMg4+4nnYXeF0gN9d1J9CZDDc1NXTi4lv/XWW179JTSvWde7+AjOEsQyXdgSPJuLVZSjDIxEPsnx6kC/dkKCifIhE2ZZJaQ3nMU4rNSjLb6cTQeMkgDJ18xyOixCmAnLQX6fMi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544873; c=relaxed/simple;
	bh=CjHQSAs/mh7KvwpLNKOZpFwtDpyxl9qT46MrLzqQFHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBIS4+9hHNjVgXpoeIE2xc2bS1z9OCgIluKQ3qg5ie7nU7eXS7WU5rNXUkj6+mwEq9v4v2ksnS9h9DT81jTR7OOL2Sqzxq9TfDT7pZiPkMlNgedr2D8NRUWME5KuXRcT5Vf3PKNUSmnXxP/ym7uO1lmXQtPgRNt0gteu7IDmceo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J/EuGFQd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J/EuGFQd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZEHTsV/PPFpp5gLF3uDiZnD/ZI3q71c8eoDn6DumcMg=; b=J/EuGFQdPi0LFd//iPFHI4e9eG
	O4cPs70ywr6Qn9vJ6BwBs4kHUGaa/OrcJBSpwkJn1jbFmf0dJ4NAk1mTw669Ax9ti9YBB1TD7hlj8
	5VLCaDzUCJFEB5n4dxNswaYb5+vjzMV6jVraA8zo4wKeN2Hcytpnij52wTqg7bi4+S/z7nIT61Or7
	1RjbL0kjDGU2n//QeCy4WSEnzFJXuZcyQaWPFOwlme5H8IuXpaO95942AxIUprWf7gs2D2neMZA0q
	7C8OlCUVxUdfx5CXADEe4i3uN01ix2T3WK+NkfETElFlNgfYFvGeAEV8bEO0yu71Hhv1pmlGqaxl8
	zkmOG8BQ==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9R-0000000E7aj-2AkK;
	Mon, 08 Apr 2024 02:54:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/8] scsi: documentation: clean up overview
Date: Sun,  7 Apr 2024 19:54:19 -0700
Message-ID: <20240408025425.18778-3-rdunlap@infradead.org>
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

- change http to https where the latter works
- drop references to I2O (Intelligent I/O)
- use lore.kernel.org instead of marc.info for email links
- update the location of the scsi_debug documentation

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org

 Documentation/driver-api/scsi.rst |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -- a/Documentation/driver-api/scsi.rst b/Documentation/driver-api/scsi.rst
--- a/Documentation/driver-api/scsi.rst
+++ b/Documentation/driver-api/scsi.rst
@@ -20,7 +20,7 @@ Although the old parallel (fast/wide/ult
 out of use, the SCSI command set is more widely used than ever to
 communicate with devices over a number of different busses.
 
-The `SCSI protocol <http://www.t10.org/scsi-3.htm>`__ is a big-endian
+The `SCSI protocol <https://www.t10.org/scsi-3.htm>`__ is a big-endian
 peer-to-peer packet based protocol. SCSI commands are 6, 10, 12, or 16
 bytes long, often followed by an associated data payload.
 
@@ -28,8 +28,7 @@ SCSI commands can be transported over ju
 are the default protocol for storage devices attached to USB, SATA, SAS,
 Fibre Channel, FireWire, and ATAPI devices. SCSI packets are also
 commonly exchanged over Infiniband,
-`I2O <http://i2o.shadowconnect.com/faq.php>`__, TCP/IP
-(`iSCSI <https://en.wikipedia.org/wiki/ISCSI>`__), even `Parallel
+TCP/IP (`iSCSI <https://en.wikipedia.org/wiki/ISCSI>`__), even `Parallel
 ports <http://cyberelk.net/tim/parport/parscsi.html>`__.
 
 Design of the Linux SCSI subsystem
@@ -170,9 +169,9 @@ drivers/scsi/scsi_netlink.c
 
 Infrastructure to provide async events from transports to userspace via
 netlink, using a single NETLINK_SCSITRANSPORT protocol for all
-transports. See `the original patch
-submission <http://marc.info/?l=linux-scsi&m=115507374832500&w=2>`__ for
-more details.
+transports. See `the original patch submission
+<https://lore.kernel.org/linux-scsi/1155070439.6275.5.camel@localhost.localdomain/>`__
+for more details.
 
 .. kernel-doc:: drivers/scsi/scsi_netlink.c
    :internal:
@@ -328,11 +327,11 @@ the ordinary is seen.
 To be more realistic, the simulated devices have the transport
 attributes of SAS disks.
 
-For documentation see http://sg.danny.cz/sg/sdebug26.html
+For documentation see http://sg.danny.cz/sg/scsi_debug.html
 
 todo
 ~~~~
 
 Parallel (fast/wide/ultra) SCSI, USB, SATA, SAS, Fibre Channel,
-FireWire, ATAPI devices, Infiniband, I2O, Parallel ports,
+FireWire, ATAPI devices, Infiniband, Parallel ports,
 netlink...
