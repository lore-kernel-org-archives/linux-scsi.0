Received: from mail-m15591.qiye.163.com (mail-m15591.qiye.163.com [101.71.155.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A22370D52
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 07:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782114999; cv=none; b=RdiDVWvphI3oPai9ZHkgbpjBNSl/ACe/Wl/YDNirVpxJmNAHjUovkbC3aWYIqVNhfqu6wkkGCXCRoaBaGvEYwnwSZywXa5GO0FZFikVQ6T7bRLNNXey2Hqz4ksD/66TxZhzDSa6tDvcZtCVgJbn+SeLCjVQlZS4xBGIaqCl2muA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782114999; c=relaxed/simple;
	bh=ZXJHE4sJRng0rENR93vBPKHp6oAmyDncHSo6Jyket3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uo38MPU2A1hpLhRaApRnuEpOYTtfgWULb2XesPmS3nNWPnxcpGPE7RHRw70n4CMQM2Tc/Gtstt0npFz4acvzj5U6ytDytXzAx4nQDnqSqW4kIH/P/iN+Bux8PEFNfubXPQ+3bvJbvu2IxMfI68NB+N+RrieRrNLVyWGHCEJpRHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=osgLaP0U; arc=none smtp.client-ip=101.71.155.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="osgLaP0U"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 433ea5be5;
	Mon, 22 Jun 2026 15:51:18 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	qtian@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 2/2] scsi: leapraid: Add driver documentation
Date: Mon, 22 Jun 2026 15:51:15 +0800
Message-Id: <56c38936ac64a3d37f04c85956008ea7c220fe8e.1782110784.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1782110784.git.doubled@leap-io-kernel.com>
References: <cover.1782110784.git.doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9eee4ff6ef03aekunm2c2703fa8228c1
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDT0MeVk8YHRoaHktOSR8dGVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=osgLaP0UiMom9bHwSrBdxVOEcp4cv4H8rJo+UVLLqhTaPaGHeKDSwNvHLWNxlU8HtGr4pMWvsXafuOb7I0hR3Oqltg5U3b5ISsm1MYfQRdG53Xv2XPGbQrYAQrieD/ks1vCcwmZ+ASbU3PNxTD8PER13/uOpZ5ckKwM0Xzd6/L8xmSy1tDm2QCVzkbSUAuqQTutsRsqh6A8exdBwutNFqto51G/NvfehzjLmwtLJbD64SZYqHYo4coJPjX0jsWKZFAHYul6TINY241xEcx+IwxCHWRWGsC3D0LjQsoHYMk0n1iPWVNmmUtQAADzLkrh+j9Vb7gtzYVHzIDtPxr6PnQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=+5OlSxaSWly/Vyk7/T6VAmU1Sogqr75kRi23IIFi8BQ=;
	h=date:mime-version:subject:message-id:from;

This patch adds the necessary documentation for the LeapRAID SCSI driver
to the kernel's documentation tree.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
---
 Documentation/scsi/index.rst    |   1 +
 Documentation/scsi/leapraid.rst | 139 ++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)
 create mode 100644 Documentation/scsi/leapraid.rst

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index f15a0f348ae4..52970f0159ca 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -56,6 +56,7 @@ SCSI host adapter drivers
    g_NCR5380
    hpsa
    hptiop
+   leapraid
    libsas
    lpfc
    megaraid
diff --git a/Documentation/scsi/leapraid.rst b/Documentation/scsi/leapraid.rst
new file mode 100644
index 000000000000..4067f07e6428
--- /dev/null
+++ b/Documentation/scsi/leapraid.rst
@@ -0,0 +1,139 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+LeapRAID Driver for Linux
+=========================
+
+Introduction
+============
+
+LeapRAID is a storage RAID controller driver developed by LeapIO Tech Inc. The
+controller targets enterprise storage, cloud infrastructure, high performance
+computing (HPC), and AI workloads.
+
+It provides high-performance storage virtualization over PCI Express Gen4
+and supports both SAS and SATA HDDs and SSDs. It offers both Host Bus Adapter
+and RAID modes to meet diverse deployment requirements.
+
+Supported devices
+=================
+
+- LeapHBA-8200C
+
+Features
+========
+- PCIe Gen4 x8 host interface
+- Support for SAS and SATA devices
+- RAID levels: 0, 1, 10, 5, 50, 6, 60
+- Advanced error handling and end-to-end data integrity
+
+LeapRAID specific host attributes
+=================================
+
+::
+
+   /sys/class/scsi_host/host*/fw_queue_depth
+   /sys/class/scsi_host/host*/host_sas_address
+   /sys/class/scsi_host/host*/board_name
+
+The host "fw_queue_depth" read-only attribute shows the firmware queue
+depth of the host.
+
+The host "host_sas_address" read-only attribute shows the SAS address
+of the host.
+
+The host "board_name" read-only attribute shows the board name reported
+by manufacturing page 0.
+
+LeapRAID specific disk attributes
+=================================
+
+::
+
+   /sys/class/scsi_disk/host:bus:target:lun/device/sas_address
+   /sys/class/scsi_disk/host:bus:target:lun/device/sas_device_handle
+   /sys/class/scsi_disk/host:bus:target:lun/device/sas_ncq
+
+The disk "sas_address" read-only attribute shows the SAS address of the
+disk.
+
+The read-only attribute "sas_device_handle" represents the disk's device
+handle, which is a unique identifier maintained by the firmware.
+
+This attribute "sas_ncq" controls the Native Command Queuing (NCQ) feature
+for SATA devices. A value of 0 indicates that NCQ is currently disabled or
+not supported. Writing 1 attempts to enable NCQ on the device. If the
+operation succeeds, the value remains 1, indicating that NCQ has been
+successfully enabled.
+
+LeapRAID module parameters
+==========================
+
+The following module parameters can be configured at driver load time to
+control driver behavior and tuning options.
+
+1. open_pcie_trace
+------------------
+
+This parameter controls whether PCIe transaction tracing is enabled in the
+driver. When set to 1, PCIe trace collection is enabled by default, allowing
+detailed tracing of PCIe operations for debugging and performance analysis.
+Setting it to 0 disables the trace functionality to reduce overhead in
+production environments.
+
+2. enable_mp
+------------
+
+This parameter enables or disables multipath support for target devices.
+When set to 1, multipath functionality is enabled (default), allowing
+multiple paths to be established. Setting it to 0 disables multipath
+handling.
+
+3. msix_disable
+---------------
+
+This parameter specifies whether MSI-X interrupts should be disabled. By
+default, 0 keeps MSI-X enabled, providing high-performance interrupt
+handling. Setting this parameter to 1 disables MSI-X, causing the driver
+to fall back to legacy INTx interrupts.
+
+4. max_msix_vectors
+-------------------
+
+This parameter sets the upper limit on the number of MSI-X interrupt
+vectors that the driver will request during initialization. The default
+value of -1 allows the driver to use all available vectors as provided
+by the device. Setting a positive integer restricts the number of vectors.
+
+5. interrupt_mode
+-----------------
+
+This parameter defines which interrupt delivery mechanism is used by the
+driver. A value of 0 selects MSI-X mode (default), providing the highest
+performance and scalability. A value of 1 switches to MSI mode, while 2
+forces the driver to use legacy INTx interrupts.
+
+6. poll_queues
+--------------
+
+This parameter specifies the number of I/O queues to be used when operating
+in io_uring poll mode. The default value is 0.
+
+7. smart_poll
+-------------
+
+This parameter controls the SMART polling mechanism for SATA drives. When
+enabled (1), the driver periodically checks the health of connected SATA
+devices, allowing early detection of potential drive failures. The default
+value is 0, which disables SMART polling.
+
+File Location
+=============
+The driver source is located at:
+
+``drivers/scsi/leapraid/``
+
+.. note::
+
+   This document is intended for kernel developers and system
+   integrators who need to build, test, and deploy the LeapRAID driver.
-- 
2.25.1

