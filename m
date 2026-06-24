Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B95B175A66;
	Wed, 24 Jun 2026 04:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276323; cv=none; b=gIIw0HuJPYBB8XeKJW939HHB48Dgg3rrTetYEmpV+spTY1BeegaZc4yK31ZoIKIoV5PBOS+6GskzPmooin+v3UroWlW+o3/o/ilKBmH4Uusx5Z5R8YNqX6yN5ATmxHgtpgcEz8k4Lbvtx7wJJKRE9z1fjqXj1NPXi9eVLtZj6Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276323; c=relaxed/simple;
	bh=MqfsJf+1OEMmO9q7T7+jnWt5YT9gOjSmP2N52PTvYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyzSENl6Cx3MQieCRUOH2sRuSSOzHAKkCQlHxeSMqckRv18cMshfkr3uchDGOB1ClFllIvzJdSb5CAk3w8tXJGa3yxsPQfJ5idI9AZIUKASAiUWj5BNf3B7f3Gf1INjUVq/Apj6TJNI11kJbDGMX3HelJUlEcOZgREpcOJnLotY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=iGLdtyJQ; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="iGLdtyJQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2380; q=dns/txt;
  s=iport01; t=1782276322; x=1783485922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7El7txWnVBYS0oAqoczxMxdcpNQB4t7ZrPZxLFg+7Q4=;
  b=iGLdtyJQiMjncOCztMg0ygrXkQDXAqyjesvQh6aYMwIU2kJt8VuBS0fn
   EMQAQ6xliMxJnJ58CyalRDHrjWrZjOIaBHuljxPIBzH3AiRwraiuyVfSm
   DMKzJLSe+NVpANSSqJPEtrIluqPDUFnHrh3/+vytFGxRP2LEsyOYQqQ0s
   +x9f/zrpgWsH4zlAmkV8aO5kQFZdtSZT8Ht/EUuPDeHxrX4oLHfhdbAME
   jOG7tU1EGhhAxJUKjKhk7J8ybsxWjgLN1sY8bRFsuNG1i3p9px5ITfAOn
   22lWP4S+azmbdsj4zC4/sKiMYMWJR5Xk4EApZ87COYNlDB3NTepfaaDSL
   A==;
X-CSE-ConnectionGUID: YNN0eZ/9SCmvaZJ4t4gBAA==
X-CSE-MsgGUID: 61fP40RTTMm096aWFPc6NQ==
X-IPAS-Result: =?us-ascii?q?A0BCAgDmXjtq/4//Ja1aglmCV4FSQxkwlCqgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjUoCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7I5gXkzgQHeQ4FmAQsUAYE4jV50hHwnF?=
 =?us-ascii?q?QaBSUSBFYNpgVKDPoV4BIMuhRuLZ0iBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBDBsHBYEdgW6BBIUCIx8DOX+BP4EkZGYVMDWBAQERHwqBNQMLGA1IE?=
 =?us-ascii?q?Sw3FBsEPm4HjF0XD4I9gQ+CPx2TRJItoQ+EJ6FbGjOqbJkIo3KFUIFoPIFZM?=
 =?us-ascii?q?xoIGxWDIlMZD+B9JzI9AgcCBw4DC5NlAQE?=
IronPort-Data: A9a23:Fe9qwaDUEISf0hVW/9jiw5YqxClBgxIJ4kV8jS/XYbTApD8kgWZRz
 TEYWWvVOvaPNzP2etxyOoTnoUsEsMKEndViOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jX2thh
 fuo+5eBYAH/gGYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE8tNIVEwEetwj0eNpCFNsq
 eBEJxokR0XW7w626OrTpuhEnM8vKozveYgYoHwllW+fBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGY0BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FAggeO0aIWKK7RmQ+0Lx0ig+
 jr8w1jcB0lLatWg5wKOrFSV07qncSTTHdh6+KeD3v5jmlC7xWEJDhASE1yhrpGRiEO8UfpbK
 koJ6mwvp610/0uuJvH4VgekoXjCphMAVsBLHusS7xuEwa7ZpQ2eAwAsRzJIa9s+s9IeXzEm1
 laV2djuAFRHsriYT3+S9ra8tz6+OSEJa2QFYEcsVwYb7sP4iJs+ghLGUpBoF6vdptn5BDf7y
 jaitzUlivMYistj/6G6+03XxjGhvJ7ESiYr6QjNGGGo9AV0YMiifYPAwVza6+tQaZ2SVVipo
 ncJgY6d4foIAJXLkzaCKNjhB5mz7PqDdTmZill1Etx5qXKm+mWoesZb5zQWyFpVD/vosATBO
 Cf70T69LrcKVJd2Rcebu76MNvk=
IronPort-HdrOrdr: A9a23:/1j5dK8NaQ1j2X7NdhRuk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: 9a23:Bl5TB2/47dlsvfcw0puVv38yPJgoQDqM91zVPUaKKzp1FLK/YHbFrQ==
X-Talos-MUID: 9a23:lIvlsQr2YFgp4UrUCmUez287Ov80u56SNGUIycRYsvaqDScuHQ7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499310779"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:45:21 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id D788F180003A8;
	Wed, 24 Jun 2026 04:45:19 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v5 04/13] scsi: fnic: Advertise NVMe initiator service parameters
Date: Tue, 23 Jun 2026 21:43:25 -0700
Message-ID: <20260624044334.3079-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260624044334.3079-1-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.122.232];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.122.232, [10.188.122.232]
X-Outbound-Node: rcdn-l-core-06.cisco.com

Set FC service parameters according to the selected initiator role.

Keep FCP retry and confirmation bits for FCP initiators, and advertise
NVMe initiator and SLER bits for NVMe initiators.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fdls_fc.h   |  3 +++
 drivers/scsi/fnic/fnic_main.c | 15 ++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
index 012f43afd083..e33c829545fb 100644
--- a/drivers/scsi/fnic/fdls_fc.h
+++ b/drivers/scsi/fnic/fdls_fc.h
@@ -39,6 +39,9 @@
 #define FNIC_FCP_SP_CONF_CMPL   0x00000080
 #define FNIC_FCP_SP_RETRY       0x00000100
 
+#define FNIC_NVME_SP_INITIATOR   0x00000020
+#define FNIC_NVME_SP_SLER        0x00000100
+
 #define FNIC_FC_CONCUR_SEQS    (0xFF)
 #define FNIC_FC_RO_INFO        (0x1F)
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 3a365ea455b1..5850d51b0e8f 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1016,11 +1016,16 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iport->max_flogi_retries = fnic->config.flogi_retries;
 	iport->max_plogi_retries = fnic->config.plogi_retries;
 	iport->plogi_timeout = fnic->config.plogi_timeout;
-	iport->service_params =
-		(FNIC_FCP_SP_INITIATOR | FNIC_FCP_SP_RD_XRDY_DIS |
-		 FNIC_FCP_SP_CONF_CMPL);
-	if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
-		iport->service_params |= FNIC_FCP_SP_RETRY;
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		iport->service_params = (FNIC_FCP_SP_INITIATOR |
+				FNIC_FCP_SP_RD_XRDY_DIS | FNIC_FCP_SP_CONF_CMPL);
+		if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
+			iport->service_params |= FNIC_FCP_SP_RETRY;
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		iport->service_params = (FNIC_NVME_SP_INITIATOR);
+		if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
+			iport->service_params |= FNIC_NVME_SP_SLER;
+	}
 
 	iport->boot_time = jiffies;
 	iport->e_d_tov = fnic->config.ed_tov;
-- 
2.47.1

