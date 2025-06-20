Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE6F19A297
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750436522; cv=none; b=TmXGtJAVE5VbG26nO+VLp3aI3T6FZ3e854wQs67JZ96nDBqlKP0D8I7vao9gMln6NFiMLMv210W0kF9I0H63lomYawXRh3lHMZR0Qou1ibxoS53jkUT6dNquF80onAfdoAyikDjrjNT9ATX59VcRLqj8jUVJpIXDOz6pbmw3gj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750436522; c=relaxed/simple;
	bh=wIalp0K5lDh1SC+aT0fCj65fzAdczsIBn+TQWYGfX+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UbE6r18P1EN1xdD5FWCt2t7psEnHjaC60xLGR1Xcbrkji4cMaI/37VXWoBS9prGANaVSlKIlURQVchWHs2+rvmrIX1hac8ePmvA2vQ3o8noYeaUPQKvRWKp/ckBLP02QItwcqN4ZeZVhL6oiNQi3ZpVGZJ+HgEhsVM7RSxHzdwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jp+FDRRW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jp+FDRRW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+Owjp4RW3aPWEtjN8MU+sOOAKCVCYk/ml1DkGMTgojw=; b=Jp+FDRRWk0sdKujArZMs78XtQ+
	U0rtmmD4z8s79Ft+R4otSk8FupRvATjo/7+UqWJnMR3/f3WoQP0F1FdWUDx83SeGJV+N75iYiistn
	GkwM4t6eqmLTY5vLc0OcmU0jypJUk44Mod/FdLEvCH5zNa+YkJqxtuGL9u49e9s9YiuJpqJnVazSg
	8hjFjVDsXvuakxK3SudGnhcB8bhGfvMx/1cvSV+rYg5GnY2reFjBzU/nWXHS6PIjr7kdhSNb8udTf
	TE2LxvOB6LdY0m9LFpb5lhlt/QCJzfuVystspkmd/2BJHt2/mZOvzpJ/gkI8X6nGZiCc82P+GGW+7
	rNh49uQw==;
Received: from [50.53.25.54] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uSeV5-0000000G7t0-2dLk;
	Fri, 20 Jun 2025 16:21:59 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
Date: Fri, 20 Jun 2025 09:21:58 -0700
Message-ID: <20250620162158.776795-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix all kernel-doc problems in mpi3mr_app.c:

mpi3mr_app.c:809: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_hdb'
mpi3mr_app.c:836: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_all_hdb'
mpi3mr_app.c:3395: warning: No description found for return value of 'sas_ncq_prio_supported_show'
mpi3mr_app.c:3413: warning: No description found for return value of 'sas_ncq_prio_enable_show'

Fixes: fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers")
Fixes: d8d08d1638ce ("scsi: mpi3mr: Trigger support")
Fixes: 90e6f08915ec ("scsi: mpi3mr: Fix ATA NCQ priority support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
v2: add hash and enclose commit title in ("...") for fc4444941140.
    add Damien's Reviewed-by: tag.
    (Thanks, Damien.)

 drivers/scsi/mpi3mr/mpi3mr_app.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- lnx-616-rc2.orig/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ lnx-616-rc2/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -795,9 +795,8 @@ void mpi3mr_release_diag_bufs(struct mpi
  *
  * @hdb: HDB pointer
  * @type: Trigger type
- * @data: Trigger data
- * @force: Trigger overwrite flag
  * @trigger_data: Pointer to trigger data information
+ * @force: Trigger overwrite flag
  *
  * Updates trigger type and trigger data based on parameter
  * passed to this function
@@ -822,9 +821,8 @@ void mpi3mr_set_trigger_data_in_hdb(stru
  *
  * @mrioc: Adapter instance reference
  * @type: Trigger type
- * @data: Trigger data
- * @force: Trigger overwrite flag
  * @trigger_data: Pointer to trigger data information
+ * @force: Trigger overwrite flag
  *
  * Updates trigger type and trigger data based on parameter
  * passed to this function
@@ -3388,6 +3386,8 @@ static DEVICE_ATTR_RO(persistent_id);
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' sdev attribute, only works with SATA devices
+ *
+ * Returns: the number of characters written to @buf
  */
 static ssize_t
 sas_ncq_prio_supported_show(struct device *dev,
@@ -3406,6 +3406,8 @@ static DEVICE_ATTR_RO(sas_ncq_prio_suppo
  * @buf: the buffer returned
  *
  * A sysfs 'read/write' sdev attribute, only works with SATA devices
+ *
+ * Returns: the number of characters written to @buf
  */
 static ssize_t
 sas_ncq_prio_enable_show(struct device *dev,
