Received: from mail-m49208.qiye.163.com (mail-m49208.qiye.163.com [45.254.49.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE943F99E9
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781788412; cv=none; b=VAOYl6whz9B+c1KrL2jPnS8Dt0GsijFbRJC03bwiMeqPWWy8rIU+VJUczzaN1eu8S7R7Zm7n+ewjbKpqupQoBmPGQM9s04YucKFrHSYBnXRn+6AGDVDLX6fcnEaPzAAIjK7a+DMc8xatPgM2cHuaMYolYfBTisiJETi57RufWmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781788412; c=relaxed/simple;
	bh=sJ8NURg6XOJaa63ahlOUPEEV0sfqRWqvruMb0Hb9pe4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwMOt4s3KG1iFRTI5pyB0oRyJ+16p7Ewqh7YmgOBfhOFEsyXHxL/8x15E6D+Or/hWOUAwoJURUl5S0AQgwy5Q9Kg/jaUU8gtjKGRtGdohG1mYq/IBYuUbrod0Q3lgb+Mz+on4PFPYUN7J/USUIuo3UcfbnR54zoYRxCFIGJ3UFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=aAqL5vao; arc=none smtp.client-ip=45.254.49.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="aAqL5vao"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 42e50143f;
	Thu, 18 Jun 2026 16:37:16 +0800 (GMT+08:00)
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
Subject: [PATCH v3 2/2] scsi: leapraid: Add driver documentation
Date: Thu, 18 Jun 2026 16:37:13 +0800
Message-Id: <bab9637bf1646c6d0c5d82c22328f120e02cc4c6.1781767278.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1781767278.git.doubled@leap-io-kernel.com>
References: <cover.1781767278.git.doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed9e09ce803aekunmd3a9a65045f4b2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGU5DVhpKTk9CQ0lLGUsdH1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=aAqL5vao2h6xLYYTGZGMbVGbQku+dYDPVWE0vYHnQonM9iETIlY7i2miep4H7sPBq/nh8ycc2b9HKayCWz2bHDgsn0a+ueyFfbs0GIQ7WOQ3MzelggVLqv0S/P54RhrQOyDFX5TK25vngdh5May3LNCV0TGhi41wO8aWEGlo6oBEdmDOOqfbP/ipGUmd/z9qJ/SZubgX1LVJ9vfgerKreA+I2qxE2aDe7BIxqkDUHAUFqLHqnneRR391jlfjvUgHD4tITXd19kbSC37lee+THWCc0qJQyyCnV5pc7rKM0ARro6t7+hS3N6tEEKzRucxXlTCdeMMHZx4oZBvrfMDJWA==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=aARmVfQHIWR9+2E2caeqYx4SjemaowsMrnFwmAblFt4=;
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
index 000000000000..e4a6a61c13f8
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
+LeapRAID is a storage RAID controller driver developed by LeapIO Tech. The
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
+2. enable_mpio
+--------------
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
+to fall back to Legacy INTx interrupts.
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
+value 0 disables SMART polling
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

