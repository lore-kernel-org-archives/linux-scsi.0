Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561BC224AE9
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 06:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750402593; cv=none; b=fmV3sv8kVi890W+AsV19VtZ2E77Kqwp59WAxOHgHnWUldtEeBte78Ulf2h1vZDn4IQJpZxM9zQIZBQqJ2Dv7u624bvaAzD8qj7M8HXRyFz3aQYzHQzJcCp0R2FU8V6bXX5LW6MKuDuYbOwya6GocztlBdARG+JxQsRuFydSHrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750402593; c=relaxed/simple;
	bh=MxjgUD6vtOn1eTpjM9UILhHqehMVoxUe3XPtEJk7hcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sxWH/eK/0CgxbnalMeC8FQaKNJsUJiM0t4jka+yrORQewgLB5cZ5eKN2zArtVr1Yru79DRh5uExcl5tIxRKPC41nYOaiHrvyzQ/3WyEPfT0KnnAQOxgusvrk+hdzvOvRJjVq8ccaSwXLTSH6XdwPMpSF8cyUssZLWkF+wI9qLKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0KTARvrC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0KTARvrC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5rmPNlIIFHTYm/csblB8yzgOVCOLAI0yLfQsPm+nrco=; b=0KTARvrC5uywacdJG2y7dRiUXx
	u+dAdfsSZUEDy89iGV2RkCDcK9jf4xhV4BRDYaCWvukLkWBcuOXAlR+DEsR9zghs8SQ7vMwbnQ7DF
	+8SahD/TfoXYcI7mML8PgdAPcBvA4B1m8OU+uWW46TQm+GAJO4BammyZBOYazazLsitVrT/VloT7t
	XRna1Uzyk+rFfxVP7Qv5n1RVAPhI825pgcA7rGunwbkh7HKNBbKz5qexfn36r3iSHOwPFZcxT4dku
	5hDreLP1i5mPdQdLZvg5rzDbd2BzasgbLU86Se0MFHlF5UTQTf0Yhxbnfsi7qQEyzcocquRsEunvX
	JFVNuVSw==;
Received: from [50.53.25.54] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uSVfq-0000000EuA4-2z0d;
	Fri, 20 Jun 2025 06:56:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
Date: Thu, 19 Jun 2025 23:56:28 -0700
Message-ID: <20250620065628.3348589-1-rdunlap@infradead.org>
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

Fixes: scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers ("X")
Fixes: d8d08d1638ce ("scsi: mpi3mr: Trigger support")
Fixes: 90e6f08915ec ("scsi: mpi3mr: Fix ATA NCQ priority support")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
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
