Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E5A261B70;
	Tue, 17 Feb 2026 20:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361299; cv=none; b=YuIx8MTZUxW+mtAwoy90FlYel/JPzOiDBEBHo6mA7q4iMgMk/1q6WkNWJRmGabwEGEq20qGi5MGmdNrzj7ygFDWhk+qSkRLHHWtjMBICn6q8giw3MKTkshMM/SSYHqIdjNkewcwdXsw4PHMkgMCVUlp3zJNX4OX5j3GuHzAvIEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361299; c=relaxed/simple;
	bh=1Qsc2GnR4TNlDbcZlnp4J5N2z72q6WUxJKD7HnzR020=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EpbfjjIB+NzweKVRMMH/X4YSsmOFMV5LjrupIlO6ZCM/9nlPCn7mdXWFboR4QmMgpyf1ii5ijPhXQYknt0oSU4ywkmgdCsgtv8pc9ru7ZJCpLH5gaqs1K3DJueEo/KE/rIPVnQeNgql8DFUBuoW61XrIE/iOZ+bu0rrG8BFdQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=BavPAm71; arc=none smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="BavPAm71"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=522; q=dns/txt;
  s=iport01; t=1771361297; x=1772570897;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H+fCwVN9/D1wEssQptd1+z73SSLCG3toUfclBWq5po4=;
  b=BavPAm71eff/5MLfi3em7vI9jneQjfJqdZb4yhwKSasmmxQGwXEgSMwc
   M1tsWJ6SW7XVZD2VU8ZBbKqNfZXztWhX9VqMw9i22YZ1xcRFzKLvu8w+V
   ERFEhxGFNAHD3+00U+dWy7zP5hs9T8HUXDBjXkGKExOxrw/IDTKfbUAtx
   W1MfjkqBWjuwZnVUAJ8vnOc1L9/U+vKuGA0ubp/8OrPiDylUmHn1yb4gP
   pybIJYtCCEyvVfWHuAG19TGX7zoevXMb7UFudnMo2UrvmLQoU1kgg25q4
   KchJg/lpJPi8n/4xG4l8xjSsxttxRd9pmEnmruaDb1t4FD17zVvfKraJ+
   g==;
X-CSE-ConnectionGUID: BldpIWCPRmaxBfKPO6VrMw==
X-CSE-MsgGUID: a7trtNooTaOs8xtgBFEHhA==
X-IPAS-Result: =?us-ascii?q?A0AxBgBd0pRp/4r/Ja1aglmCSA+BT0NJtGiBfw8BAQEPU?=
 =?us-ascii?q?QQBAYUHjSECJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQEKAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4Zchl02AUaBPhKDAoJ0A609giyBAd4+gWQBCxQBgTiNVWuFAycVBoFJR?=
 =?us-ascii?q?IR9hRCFdwSCIoEOk1xIgR4DWSwBVRMNCgsHBYEzMwMgCgsSEhgVAhQdEg8EF?=
 =?us-ascii?q?jIdcAwnEiwXgQsbBwWCaIRwGw+JBXgVWYEfgQYDCxgNSBEsNwYOGwQ+bgeON?=
 =?us-ascii?q?0GCM4EOqEyLd5UXhCahWBozg3ETpmYBmQYigjaiAYRogWg8gVkzGggbFYMiU?=
 =?us-ascii?q?hkP0wclMjwCBwsBAQMJk2cBAQ?=
IronPort-Data: A9a23:t93yhqNEMirEFg7vrR2OlsFynXyQoLVcMsEvi/4bfWQNrUpx02dWn
 DYaWG+DOvyIamCmL413a9i3oxsOusXczt42S3M5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeap1yFjmH+0bF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WVrlV
 e/a+ZWFZgf/gmEsawr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQrl58R7PSq
 07rldlVz0uBl/sfIorNfoXTLiXmdoXv0T2m0RK6bUQNbi9q/UTe2o5jXBYVhNw+Zz+hx7idw
 /0V3XC8pJtA0qDkwIwgvxdk/y5WF6lK4J74CkCFtMWD5UPlS1yy/e9LExRjVWEY0r4f7WBm7
 /cULnUJKxuEne/zmOv9Qeh3jcNlJ87uVG8dkig/lneCUrB8HM2FGv6ajTNb9G9YasRmHv/Ee
 8sdYDlHZxXbaBoJMVASYH47tLn42yamLWEJ+Tp5o4I+vHTJ0Cp214TkF8GFasCFb+t4vkax8
 zeuE2PRR0ty2Mak4TSC72iti/WJgSP8XYsJPLK9//9uxlaUwwQ7KhQTWED9i/6llkm7X99OA
 0wd/DEjq7A77lCtQ8PmXxyg5nWDu3Y0XtNKD+w8rhmA1qfO+AufLm8eRzVFZZots8pebTgr0
 EKZ2tDkHzpitJWLRn+HsLSZtzW/PW4SN2BqTSsFSxYVpsLou4AbkB3CVJBgHbSzg9mzHiv/q
 w1mtwAkjLkVyMpO3KKh8BWf2nSnp4PCSUg+4QC/sn+Z0z6VrbWNP+SAgWU3J94ZRGpFZjFtZ
 EQ5pvU=
IronPort-HdrOrdr: A9a23:vIPoAq/3uVp1VVOUXghuk+DrI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HNoB1173HJYVoqMk3I+urwW5VoI0m8yXcd2+B4VotKNzOIhILHFuxfxLqn6yH8GiH46+5W3b
 ptfuxDEtHqZGIK6PoSmDPZLz7lq+P3l5xBQozlvhNQcT0=
X-Talos-CUID: =?us-ascii?q?9a23=3ATQw1Dmo3EpCZKnn8rEXgnBTmUeohfmX881zoGUq?=
 =?us-ascii?q?xGUxna4WyF2GK3bwxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AHlMVtgx4A6cU0NaggJmAIP5DsvSaqK3xFFoRt5I?=
 =?us-ascii?q?Bh8CjLnxgJzi3ohmXQqZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.21,296,1763424000"; 
   d="scan'208";a="685716499"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 20:47:08 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.109.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id E5394180001DF;
	Tue, 17 Feb 2026 20:47:07 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nmusini@cisco.com,
	fourier.thomas@gmail.com
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] snic: MAINTAINERS: Update snic maintainers
Date: Tue, 17 Feb 2026 12:46:58 -0800
Message-ID: <20260217204658.5465-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.109.174, [10.188.109.174]
X-Outbound-Node: rcdn-l-core-01.cisco.com

Update snic maintainers.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b11839cba9d..04d3169b8d38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6115,6 +6115,7 @@ F:	drivers/scsi/fnic/
 
 CISCO SCSI HBA DRIVER
 M:	Karan Tilak Kumar <kartilak@cisco.com>
+M:	Narsimhulu Musini <nmusini@cisco.com>
 M:	Sesidhar Baddela <sebaddel@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-- 
2.47.1

