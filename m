Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA531851
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 02:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544872; cv=none; b=gtEA81ngxJD1taJZHT/Df7oYuW1WH13/cG/ZUPWinR4AvvwrOLAsHcnmhU7/Peww+p+EX64JGGKbHAJx4JoBc5C+yXYW1GhdTX6kFCtL3ciSEPnpKiN4X0wIJJZ+FFO+kb1bzq7aTrfUJesm+8H65C+1FCPIhm7Re/NPRvzhPrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544872; c=relaxed/simple;
	bh=VSyo0pB3X9BLneWOTlh2jgboHkV7iglD354DSaJZFVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb1JiMoHSfkEWbwIBfNvU9BivPf+DfcU5Qj/VrOzXAENA2aKWl7LeJhDheh7FzCAgeDW6OLY37eJrFq/mT+LHsAQsrU6gdxdUQIzr2oQPOBETAVQJvyZW0YI5wEsCNN9duEdNSGNvN5xN13+uwaGC/WL2nvMwFr5G69gih4gXfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Td0YRQTa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Td0YRQTa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GU7fnRDSD1+YKZpJx5qe/WUhhFcKN3vni7bJr8SxaJM=; b=Td0YRQTah/qnPigNKkuoyqedu9
	ALVQm/qyY7OU7tsAOKvlodgGtk+8MvyHljn8nMHRSY4GHTRGnIrkRjfldfrc0WoC5H1gZqfTErnKQ
	Ri7WQnbtnHadZty1arugzymXJgE3CqVia0WtWu5nnOFhI7tibQrmDVaFrLJvnKR15OlU5va2ooh+Y
	/uy2W0yLBhFjgGu18adhMXaBYHF+8dnoPVjlx7GEnOixW4w44nirm4wfgZTTh11xEhZT62ImS+ajt
	/LcvuqqlrjAqyCRTa5iZdGz2l8mQTkzQLwRIWbnkID1VBueb7yeJWqUXp62Sej7yABGRqqkxNAqrH
	76Ezj9IQ==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9S-0000000E7aj-2zx2;
	Mon, 08 Apr 2024 02:54:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6/8] scsi: core: add function return kernel-doc for 2 functions
Date: Sun,  7 Apr 2024 19:54:23 -0700
Message-ID: <20240408025425.18778-7-rdunlap@infradead.org>
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

Add missing function return values to prevent kernel-doc warnings:

scsi.h:75: warning: No description found for return value of 'scsi_status_is_check_condition'
scsi.h:202: warning: No description found for return value of 'scsi_status_is_good'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

 include/scsi/scsi.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -- a/include/scsi/scsi.h b/include/scsi/scsi.h
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -69,7 +69,7 @@ static inline int scsi_is_wlun(u64 lun)
  * @status: the status passed up from the driver (including host and
  *          driver components)
  *
- * This returns true if the status code is SAM_STAT_CHECK_CONDITION.
+ * Returns: %true if the status code is SAM_STAT_CHECK_CONDITION.
  */
 static inline int scsi_status_is_check_condition(int status)
 {
@@ -189,12 +189,13 @@ enum scsi_disposition {
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/** scsi_status_is_good - check the status return.
+/**
+ * scsi_status_is_good - check the status return.
  *
  * @status: the status passed up from the driver (including host and
  *          driver components)
  *
- * This returns true for known good conditions that may be treated as
+ * Returns: %true for known good conditions that may be treated as
  * command completed normally
  */
 static inline bool scsi_status_is_good(int status)
