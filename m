Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.3.219.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124111;
	b=eiIDxELXG3ibWUkMGth/is+8yY2DDjEvbwVgEQskKlli9jMSYxSgBtWdYmnrbCFbtDv6
	 Lre/V6AsWjB8nxq4C4bgkFmCMdY8WsDT5rMUKzMIgq3Zyl1P46/cOKgDHzQsHLCs/xV1i
	 6qBr4ZxDmi+5aCQWXB7FbZovBh/dJan3NOK4s8RrClQYaswKSEMvVA+LUuhnNBGkqn9/i
	 hmw7uupJfJvApQPXLjx879fR4V6KLQovq3CeQw0Gj/eDF/15pVlTeEi/bC9Trz/QHQMkh
	 Pjo8Dk9rg1P2dIkJGIbe+95rmpbN14ieU6KOsP9nkU/FGslFXAcx6lC52HAstBbgN9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124111;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy:X-KSMG-AntiPhishing:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:X-KSMG-KATA-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=49uE+nPMQ26/ZqWVeSBjBPTudg0al439h0nnVz+XZz4=;
	b=nOsrU0P1dyqxL2TchJKBlLUtPHWOR9DksGw9SqLBroww53pmmehfVBlPALoT284xo11F
	 3nwHCCC5uTmMsGmY0/MIAIss9mY1Xo4PQ9EVYpFGiGthrsLALlvROegG1PSv4WFtFF1oJ
	 k/rXx7zZ0oxg+dNABIYvasL3lPwowI+izs/MsGilyfOBdlX3G0Apdpl1oHQBRJEKvCsOz
	 J66Zfk5UZw+nuxRu8Ld1LUpg7WVxI9PoqMzsuftF7FrxGW8dvurY39AwHDSD9LQRPVoFV
	 Wv+I7XmCKWXKT/TyGyhQ1phayzPyR5ikozqS5DWA2VXIxXUWlatRfZc8of5kQxp8yjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yadro.com;
	spf=pass smtp.mailfrom=yadro.com;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=lUXQsRiN;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=HO4BLeba;
	arc=none smtp.remote-ip=195.3.219.148
Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C7606A31D;
	Tue, 27 Oct 2026 18:01:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 976C7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=lUXQsRiN;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=HO4BLeba
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 90A1220028;
	Tue, 27 Oct 2026 21:01:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 90A1220028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1793124099; bh=49uE+nPMQ26/ZqWVeSBjBPTudg0al439h0nnVz+XZz4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=lUXQsRiN9iEVInHx2TDm3b+IU6BiYszXeIVIFEmmR1qFdX/BadRGeMHppUQOgL+9h
	 oO9r7zeIG+aF0BsvkobyGzrhDc6IZOstWrdWQx7jgNDkImGna6CbBtPtqioPppeJ3X
	 MiO0P2LA0lPvSageR5m3MYz2nlrJNJoInsWinNL6XNI/VOh0CGiF5VXauN5ICCYgPc
	 zis+Mp+acJTETkQ9dql6GJ26dPsFWhnpqsDfppQrn+877nJASGsv1ICGwn2iDGi+nF
	 vkXhEjAzWRxD7E9Wbill8Xu+RCOE5aWcEcPEhG3OQFbbqPtPRVwt2yQEzqKIJD63wS
	 jA4cghKCTgdAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1793124099; bh=49uE+nPMQ26/ZqWVeSBjBPTudg0al439h0nnVz+XZz4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=HO4BLebaryo++LLBM0l38eXH6FufiQXUg+Ky2XCN60EPOspJIDOh0PRFX2UjDBKGt
	 7drSa6kTuiBQ8v8bIcnuy2wJ/XZnaT52B/saMjlec8tKLtvs20ICgTkDFHY0xlZGte
	 4DkfcmA7oaXQ8mbC2G/xO9zSkwwXm6rfkZkU8ZrHdLbaMNx+iWIMOrmw3yW0jp7FTi
	 4kvtd9+0/98XRSnfQgZuI8vWPd9vvKy6zn12cX17ZOZ4GaQsPR3q0n0qLF2nGcYR22
	 +dhEBusyYzg279t2dMFUQ2jKX1eCIFUUUL5t2GjK0J+lRpGN5q5hXWlMlz29pN9hNa
	 Ml0bMSiEWJU+Q==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Tue, 27 Oct 2026 21:01:39 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.34.9.247) by
 RTM-EXCH-06.corp.yadro.com (10.34.9.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 21:01:41 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	<mlombard@redhat.com>, Laurence Oberman <loberman@redhat.com>,
	<target-devel@vger.kernel.org>
CC: <michael.christie@oracle.com>, <linux-scsi@vger.kernel.org>,
	<linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 1/2] Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands"
Date: Tue, 27 Oct 2026 21:01:22 +0300
Message-ID: <20261027180123.13163-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261027180123.13163-1-d.bogdanov@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/10/27 10:49:00 #28748526
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

This reverts commit d5869dae5080e976d4b03cc33eb7ceb527f242bf as it
introduces double completion of the command and other issues.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e75..62ada3a52210e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1533,10 +1533,8 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1) {
+			    --cmd->outstanding_r2ts < 1)
 				iscsit_stop_dataout_timer(cmd);
-				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
-			}
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
-- 
2.25.1

