Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E084EEDF;
	Mon,  8 Apr 2024 02:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544872; cv=none; b=Mf7RwY7JX0xuWTpMRKFjsPV3XdYGxVPVZOh83spblqXCYR7Y58SM2ajc+qfGm3eLfIu+kJo1sz/7+MuPtLifdkcfrs1rp4z4vF1C3PuMuiYUD6zGXQZy+mnMLiPpkAFpLFC+5cfIrfP40rQ0T+XynTq6vuPxHWNpiX0lB79H984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544872; c=relaxed/simple;
	bh=hFGbtCl5brY3Pt2GD/u4g+tYb5eNQfC/ETHUn/YzcuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CX6q5vagSTrfSY3UBYNMmxlBx2holXZTqxv8urzJp0pjl58jCiAixi4xHMKxspKsorS+fYqJ+9K9a2sPu9h4nLFaDfxtQDG3qdG1J0FUifV513s5dxiNSMIadbxfgMDTodXyIqsjK3rRDlTObO/DZIhRi1z+ASlPq47fVteKvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3WyuTGNQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3WyuTGNQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gZjLvVyMMsmvznBcaR8J+pLQcmv/hNULLwXCOwRGZD4=; b=3WyuTGNQTpwtfemC1KGC97Shze
	Zak67SdWihVWJAjq4ctWxqCQhcJFsQEr3xtyqSmiBTk+HT3P5d1dZ/r5mq93S0vqVN066vjqVDkM1
	Rnxb2SWhy8EIj4SgyH0IK4n+VC+EQgmKpEx5iRhy8UWE+07iYvMIBBbVGT+s1ATTfAwEfr6zJ3ji/
	mN1BmXhuUHo3Z/jgjYH1E9w5bZuEvTZhoKOs/eJv+XYARwhbhI5zLXZC70lVOsWGyYpU28VXXMSfD
	m1mQobe1jDzefJpM+mXUTtMqlH3DTMOD5gg8BmypDzrMAPVjWcOWExCSUejwKzzyZuhtwdcTIvbmK
	R0RWNZ5g==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9R-0000000E7aj-0F1U;
	Mon, 08 Apr 2024 02:54:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/8] scsi: documentation: clean up scsi_mid_low_api.rst
Date: Sun,  7 Apr 2024 19:54:18 -0700
Message-ID: <20240408025425.18778-2-rdunlap@infradead.org>
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

- update the format (txt to rst) and location of this document
  (archive.org to docs.kernel.org)
- change url to URL
- spell out "lk" (Linux Kernel)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org

 Documentation/scsi/scsi_mid_low_api.rst |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -- a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -42,18 +42,18 @@ This version of the document roughly mat
 Documentation
 =============
 There is a SCSI documentation directory within the kernel source tree,
-typically Documentation/scsi . Most documents are in plain
-(i.e. ASCII) text. This file is named scsi_mid_low_api.txt and can be
+typically Documentation/scsi . Most documents are in reStructuredText
+format. This file is named scsi_mid_low_api.rst and can be
 found in that directory. A more recent copy of this document may be found
-at http://web.archive.org/web/20070107183357rn_1/sg.torque.net/scsi/.
-Many LLDs are documented there (e.g. aic7xxx.txt). The SCSI mid-level is
-briefly described in scsi.txt which contains a url to a document
-describing the SCSI subsystem in the lk 2.4 series. Two upper level
-drivers have documents in that directory: st.txt (SCSI tape driver) and
-scsi-generic.txt (for the sg driver).
+at https://docs.kernel.org/scsi/scsi_mid_low_api.html. Many LLDs are
+documented in Documentation/scsi (e.g. aic7xxx.rst). The SCSI mid-level is
+briefly described in scsi.rst which contains a URL to a document describing
+the SCSI subsystem in the Linux Kernel 2.4 series. Two upper level
+drivers have documents in that directory: st.rst (SCSI tape driver) and
+scsi-generic.rst (for the sg driver).
 
-Some documentation (or urls) for LLDs may be found in the C source code
-or in the same directory as the C source code. For example to find a url
+Some documentation (or URLs) for LLDs may be found in the C source code
+or in the same directory as the C source code. For example to find a URL
 about the USB mass storage driver see the
 /usr/src/linux/drivers/usb/storage directory.
 
