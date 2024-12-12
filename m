Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E498C1ABECF
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036744; cv=none; b=E9to+vImDhTbQYyKnjJGGM3GiWRXvMxXc25Hd8nxQ4kAy1UkQO02F1HeAT59I/it86fuMC84eL9W7kbMs9vUeB6reku4iGj4v7x2UD4mZ7wmrhp1HFg6N8UTOFa7ml/qGRWQpFLekvahBkIdfSYC36Y/EWn8dHCYZH3Pn4dom9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036744; c=relaxed/simple;
	bh=/ndaERqmRgwGQ9r6zP/NB3YKf/JSGMmm+65eWWD2sIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjZzrtjND87fLPkLhwCYxnNH2ifZFTqn/Hmz1wye6+Cp/IO15TIUq+uyRdFSik0HhwuI0SrrRzNCNrJrWZMlJnlMrHKtafQKRTYQ4zwfHxwlQ/CLipdP5Uygd/D6JI3msTPmy+S769RVQazW3H1U/ejCxCL2tedMprnI30R4ntw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=To9FaaDM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="To9FaaDM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vx5PlpxbwZpb2opqxy2k3FqmU4u+duEDP1k6keYODu4=; b=To9FaaDMGqYlda+8V5ciAUaqnY
	+OSNaO+g8kY49/q1urg2Z7wYWFzgY8fgtWYIFlWabfh0rU6UevW4DMZ139+GRlmoAC/eLNFVgIzpe
	bcuPWw5siWscQMmTKCEaxXfO1y0RT3h0aDB6ACoWFEey5KWw2wugsTV47hheQ8/L50dvB4/a08ZW4
	m/4tdjgl2AyHkJcHiqQGh4k8x2UfUBRy4l9OFzM9+SnqJTHJ9a6oLuFxdjE9iNWhrzhHw5efNGpO2
	Uq9VIpt70Ozpe/4Sj9gyr6vkJMnoRkAzMmvNwF2i6yqAWUt5IKCANj14F3XGnowHk57wzVZXiEEjm
	Bn9osUSg==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLqAY-00000001rO5-27Bf;
	Thu, 12 Dec 2024 20:52:22 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/5] scsi: transports: fix kernel-doc for exported functions
Date: Thu, 12 Dec 2024 12:52:17 -0800
Message-ID: <20241212205217.597844-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212205217.597844-1-rdunlap@infradead.org>
References: <20241212205217.597844-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix kernel-doc for sas_port_alloc(), sas_port_alloc_num(), and
spi_dv_device().
This allows them to be part of the SCSI driver-api docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_transport_sas.c |   10 ++++++----
 drivers/scsi/scsi_transport_spi.c |    3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

--- linux-next-20241212.orig/drivers/scsi/scsi_transport_sas.c
+++ linux-next-20241212/drivers/scsi/scsi_transport_sas.c
@@ -888,7 +888,8 @@ static void sas_port_delete_link(struct
 	sysfs_remove_link(&phy->dev.kobj, "port");
 }
 
-/** sas_port_alloc - allocate and initialize a SAS port structure
+/**
+ * sas_port_alloc - allocate and initialize a SAS port structure
  *
  * @parent:	parent device
  * @port_id:	port number
@@ -897,7 +898,7 @@ static void sas_port_delete_link(struct
  * below the device specified by @parent which must be either a Scsi_Host
  * or a sas_expander_device.
  *
- * Returns %NULL on error
+ * Returns: %NULL on error
  */
 struct sas_port *sas_port_alloc(struct device *parent, int port_id)
 {
@@ -932,7 +933,8 @@ struct sas_port *sas_port_alloc(struct d
 }
 EXPORT_SYMBOL(sas_port_alloc);
 
-/** sas_port_alloc_num - allocate and initialize a SAS port structure
+/**
+ * sas_port_alloc_num - allocate and initialize a SAS port structure
  *
  * @parent:	parent device
  *
@@ -942,7 +944,7 @@ EXPORT_SYMBOL(sas_port_alloc);
  * the device tree below the device specified by @parent which must be
  * either a Scsi_Host or a sas_expander_device.
  *
- * Returns %NULL on error
+ * Returns: %NULL on error
  */
 struct sas_port *sas_port_alloc_num(struct device *parent)
 {
--- linux-next-20241212.orig/drivers/scsi/scsi_transport_spi.c
+++ linux-next-20241212/drivers/scsi/scsi_transport_spi.c
@@ -985,7 +985,8 @@ spi_dv_device_internal(struct scsi_devic
 }
 
 
-/**	spi_dv_device - Do Domain Validation on the device
+/**
+ *	spi_dv_device - Do Domain Validation on the device
  *	@sdev:		scsi device to validate
  *
  *	Performs the domain validation on the given device in the
