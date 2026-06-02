Received: from mail-m49212.qiye.163.com (mail-m49212.qiye.163.com [45.254.49.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA883AFD1D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 07:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780386352; cv=none; b=EC8Ih2ZvWJZrQ4XOzWWHJ2zhjq4iiAeAg7cr13KA90BCT5ESlvTttBnJ/76GUNw714ktfqPGNeZB+Ni7T7uWWW4+6QJVto/nZz6u8cSbCYt/yGk6ElDGECt1hkqNVhu5d+i92eI1f1hYP09k/NjTT+HAWwrNljy4NOin+BecVGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780386352; c=relaxed/simple;
	bh=deChYCD5mReTSk78nHO1ZBTNRy1/qYgjAAUqvLzJ2r0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j6YdfY0iBMbXPrD2CCM/d2BrardEKgREwsCCd3Kpxo4sb4vqmSuvMnOrGWVzkCZcbpOfqqBnDRgeIiJfQcD0gGMbcC4ivlorv8FfhTSdAnplG1bXdJIb8WzjHVD577GIlXUkpL4kCRCQ0wxcGnFggTatsCkMeq0gq7lqyX1X3uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=bV13+Vpc; arc=none smtp.client-ip=45.254.49.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="bV13+Vpc"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 40b8bc0ff;
	Tue, 2 Jun 2026 15:10:20 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: leapraid: Add driver documentation
Date: Tue,  2 Jun 2026 15:10:18 +0800
Message-Id: <4b50269b0f423ca3ea36077ac1e8645e1d2fc698.1780383814.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1780383814.git.doubled@leap-io-kernel.com>
References: <cover.1780383814.git.doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e872b468003aekunma6f7b930705523
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaS00fVkJJS0NJHkpIHxkfH1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tISk9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=bV13+Vpc0GJGLesVB9NkzGZusTDNeDX96LJEufeVtK1BFn+mNiuEO3RslG9+vhFWM/bhjwVdlhOV9ZaB3V9WaIi3cNs2KgrUeQV/kU+kYTZntjG5hm5lf6XYtQZQ8OTetZZIhViATC0jhxBuAatpT1g0lxBTGUrlXC07EAfvhfABLUJ3Q4RHqGQ9htoP+TUephjGsBrEI24Ip1MjJQzQeIbGE1IV/KZipV0JvDV2NVAv41DXiTRUKlMyvMR/g10jNdqv+szkZT6hFez48RzP8AW6ozSlE0P2yIAEAVPW1ynT9L3663mlycfitO6tuVO31ZctLUG1FH0pNacvWOViGQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=xKw9dKNgblSPDaIpktelwecokIf1F2uhDQgRnI/A2VU=;
	h=date:mime-version:subject:message-id:from;

This patch adds the necessary documentation for the LeapRAID SCSI driver
to the kernel's documentation tree.

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

