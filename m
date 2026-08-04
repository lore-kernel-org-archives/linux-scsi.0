Received: from mail-m3296.qiye.163.com (mail-m3296.qiye.163.com [220.197.32.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA843B0AC6
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 09:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835514; cv=none; b=Y4K2r/9Z964uKD/KMSUqDVkRAy/BsXWi+v9mZ3TFebhxwlCTtOVMcgB3awrolGTOLubAI9DdgmOUAxIJEkCjsTnu/bhfCnbq+03LpwLPEJnvLnEZNSRmQeDJ8q2iMbAMBdSWuKCJCDVZ+USPuqajUVHo9tP/gmHHW6rqJeZ0L7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835514; c=relaxed/simple;
	bh=82ZP/0gRdhUYjbQTSypKlqx8jlqmzepVE8UZz2dOPH0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NGspz8K+JR+rFK1Qoe046QBV/xO/3rzBjvN4w/CUDSUi2xwfHJ/rJGRxuPu8vP7PoIqlbGNCFAKdxvnMFbqNfEcq36B182q9s3MIKBuQ9tJ0gNqshQgok87lzy1zzanZ4MFmOebsMYv5VQHyc97xK0z2pjDXeDbxocQSy+vWey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=M5rsx35n; arc=none smtp.client-ip=220.197.32.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="M5rsx35n"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 48b1dbe74;
	Tue, 4 Aug 2026 15:02:31 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v5 2/2] scsi: leapraid: Add driver documentation
Date: Tue,  4 Aug 2026 15:02:26 +0800
Message-Id: <6dc9239844dc00cd053ea0649cc9fe05cad1d98a.1785823793.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1785823793.git.doubled@leap-io-kernel.com>
References: <cover.1785823793.git.doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fcb94c26203aekunme796edef9bcdc9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSUofVkxDHh4YGkgYS0pJGVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=M5rsx35n/cQTyXLOOaifxMTI9msPK93ygG4V7mqlTQB5FFnG0Ezty5If0xIWgP9uDPomRFd0uuM8Zu2d82GhDuk4tigKyWuYnxu6mTpYT1MCMsWYAV/E/WDZW0NNGh2/3ixTp+Bhd35Jd8Zp9ZEv1BMGD0YSCUjd1Maa0g0D8OAr5ujck2ewiMaBpDDwVEqML2CVLhF2GFr7mffIZsnnec+fhdIU4cx6W+8LklrjhcjM3FeRFQ78+QEpDs2mAqnVFerGghxUa53cHPAj8LemCPcgp+KncNYrJW/h1W40PIoJwfm3wHEadEn/ygFj7e6Z65eSWQz38TfAaw+goREe4Q==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=6kpouXimNpD1VTkhBYuHe0dzSs2OhKKLzGZo5L1hVnw=;
	h=date:mime-version:subject:message-id:from;

This patch adds the necessary documentation for the LeapRAID SCSI driver
to the kernel's documentation tree.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
---
 Documentation/scsi/index.rst    |   1 +
 Documentation/scsi/leapraid.rst | 110 ++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)
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
index 000000000000..99930ce2b8d0
--- /dev/null
+++ b/Documentation/scsi/leapraid.rst
@@ -0,0 +1,110 @@
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
+   /sys/class/scsi_disk/host:bus:target:lun/device/sas_device_handle
+   /sys/class/scsi_disk/host:bus:target:lun/device/ncq_cmd_prio_enable
+
+The read-only attribute "sas_device_handle" represents the disk's device
+handle, which is a unique identifier maintained by the firmware.
+
+This attribute "ncq_cmd_prio_enable" controls NCQ command priority. A value
+of 0 disables NCQ priority handling for RT-priority I/O. Writing 1 enables
+NCQ priority handling when the device reports support for the feature through
+VPD page 0x89. Unsupported devices keep the effective state at 0.
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
+3. max_msix_vectors
+-------------------
+
+This parameter sets the upper limit on the number of MSI-X interrupt
+vectors that the driver will request during initialization. The default
+value of -1 allows the driver to use all available vectors as provided
+by the device. Setting a positive integer restricts the number of vectors.
+
+4. poll_queues
+--------------
+
+This parameter specifies the number of I/O queues to be used when operating
+in io_uring poll mode. The default value is 0.
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

