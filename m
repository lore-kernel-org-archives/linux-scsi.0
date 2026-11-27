Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795762084;
	b=sXtdaRyZFuj4cwzrsKBJ3DVqDwPtRedVDAMvRDZ7bicD5Q2mtiuFyeAULOZ/FH6ZRtx+
	 9PCoapWaT+Hm1OHlZAONYh4V+JqAGXr+gaB432FrfJc5Vj5Gl8do4yB1tns0QkNV7dhZH
	 wnZCbCNB4TlmCNQpiM4lxOfzLEdakQ2gSNiQk7J0Jprg75W2ZOXeAMrIMTnKwwNtpJO78
	 89QvERQUESfYLH/6Rr81gn0RL25rxcIAcTU4+ZYS369Djtj93dAtSld8UKKJvq6NI2uX/
	 Ej6LDTtb5LVIg1obTMhPDTdNULnfW8gYqsIfwPQqqWNjyxeMa/DWvLqeSCxrCv0ZHsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762084;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=PV6Y8JKnkqnpS1bBH7JpIi0ELz5RHOcA0o9CAVIi+MM=;
	b=q7CB2D58sztusKf+TvMhEMxhHp3Lhq6dW50mMcZ3dQ9yeAtLDt46VXmm3pLZRum92EL/
	 z85DPqNYDkT9BQpJocHOH2AygBB5hwnJ2SgMkGdUFOB9xFeGwM/gMQ0APofgwr4qHZac/
	 Wv0LTo04ukH6jOWi0lXhfqRRgVC3iZe3cavYqn4tdBw1D08O3C0bekIrDvr3kOjgYZz8s
	 zJSAVyYFctPaul2PaInLqWbiEcr7cp80qeKS/WfsU0IoNVJ48tGtAUHt83nY0hswCQ8SE
	 ctSPzCXVAmv8YVihswI2jduv8p1+bQCoJTV5AEvraTxUVRICeRNFdftQTG4k+enHjaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbfDWcqx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17AB606A32A;
	Fri, 27 Nov 2026 06:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbfDWcqx
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795762084;
	b=vGpl2ooK0TnFgxbr4XG1aBmF1ssJXMbpz5oa88RYh7cSuVD5meRTcnOS9n4YnWrp32G1
	 JiAgxYItEv4hJY/5v8TB2QdhL8qNtE7q9U+vRZlEiSrxhUiLOr+XcreAaldXmTH9EBBYc
	 L4hyCZkGYJQNtK0LnSGVrKbcz1T3meADzLBi1HlVu/Fm2nADgTGa7zPG/XoLAdHk+7Icg
	 uIozKzBZO64DktM9CkAHyHRXH2ync1keNQj1+NS201Q+UgZvyhqErMURGCwqR5whc+hLe
	 UcQ8Xx6Ue8uAYTXpSK5OXcYyHellaCyMTjBFysa1pne8dhffOiSW2bTQxgZzD1vFRUQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795762084;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=PV6Y8JKnkqnpS1bBH7JpIi0ELz5RHOcA0o9CAVIi+MM=;
	b=1L9I9E0w5r3APIvn7A6SUHXKh7J2DIUQ/xF53rY/4cNJXHgDWUuWyNjD7l/3nkJCrNZP
	 zO1Q8YQo2uxymoKL2Z0JebVKynIhRAFmmEJ87vFP3lKkj9OyytOifJ+0GLPks2BHVsYag
	 wN04YLAZ6P9jL9aVbV6L4GaFXF0TvgsO61ZEemCN+HMin0Vtx0xl79XktQbc+kR/ttbrT
	 /GhgfOn37/aVpVpBS/wd9FqkXhUWGpm+kGPEyrcWYqHDRip0ogKPdV9CyxRxw+NaReHBz
	 QEucMNEifWTI3xVPovztxMZBmaZIf/WapKqwR7EGBRQGGcGKaTj8R+gBmovVBpw5HJg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2DF431F00919;
	Fri, 27 Nov 2026 06:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795762084;
	bh=PV6Y8JKnkqnpS1bBH7JpIi0ELz5RHOcA0o9CAVIi+MM=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=kbfDWcqxiZtw8NLZJEF29tYOrZEv5HHis/2QA+JtytI/WRQ8HsSpSBVZXzUz5y3Lx
	 mecLGOaP33AymDzdiXX6dP0zy21321/tH0SkH2vifa9QlWzUzj8VHJPEDrmu9o1bUC
	 HSMVpOsIOfYzOBxt6jxoY8ctsyxsYDbQNHopXyh/M+pvcihxDucndeysC0Ve5Iato6
	 1bJDRXVgsx0SgHSDd5NlZZJ/+jpdDUz0++iwA3CXfBQOAM6RGTM8mCEmwiYGaLfU85
	 g6SmIKvs5EdBS5hoZFe9bC8WOMPlmqOCDTdQ395xvx73nxlfgfpuh/GOM8J68gOVyH
	 cM35ph7u23h/Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 557B84B5F1;
	Fri, 27 Nov 2026 06:47:48 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 06:39:32 +0000
Subject: [PATCH 5.15.y] scsi: qla2xxx: Completely fix fcport double free
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-so5-qla-515-v1-1-fc31e58ffd78@certik.com>
X-B4-Tracking: v=1; b=H4sIAKMlCWsC/02NSw7CMAxEr1J5jUsSYZC4CmKRj0uDqgTigkBV7
 04CG5bzNPNmAeESWeDYLVD4GSXmVIPedOBHmy6MMdQMRpm91uaAkgnvk0XShE6TUd6rXVAD1MW
 t8BBfX9sJqNfUv+H84/JwV/ZzU7Wms8Loik1+bEg4hTnnCRvf/l3Aun4A8fPAd6MAAAA=
X-Change-ID: 20261127-so5-qla-515-b1520cc04d0f
To: stable@vger.kernel.org
Cc: Vladimir Riabchun <ferr.lambarginio@gmail.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795761571; l=2352;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=5PFq0t+9kyJ3bNqaWKXqN6KsLjWHosGjNZwrSng1BcI=;
 b=t81OAqjPnvuQC/yzrIuJo2vhHiIKCcAVPY/P8neWlpn4bBBH/XV03XQD0SPIHjwY4h1OfO49l
 wJGliHubiwnBDwNHJakqtP5jdaDneDOMwgaGXarIUxokRkShICiB+Ws
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

commit c0b7da13a04bd70ef6070bfb9ea85f582294560a upstream.

In qla24xx_els_dcmd_iocb() sp->free is set to qla2x00_els_dcmd_sp_free().
When an error happens, this function is called by qla2x00_sp_release(),
when kref_put() releases the first and the last reference.

qla2x00_els_dcmd_sp_free() frees fcport by calling qla2x00_free_fcport().
Doing it one more time after kref_put() is a bad idea.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Fixes: 4895009c4bb7 ("scsi: qla2xxx: Prevent command send on chip reset")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Farhat Abbas <fabbas@cloudlinux.com>
Link: https://patch.msgid.link/aYsDln9NFQQsPDgg@vova-pc
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
6.1.y and newer already have this fix.

Tested on v5.15.226:
- x86_64 allmodconfig W=1 build of the qla2xxx driver and target objects,
  base vs patched, no new warnings
- booted the patched kernel under QEMU/KVM. I don't have QLogic Fibre
  Channel hardware, so the ELS error paths weren't exercised.

The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.

drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index f080e1952927..3984b42fe0dd 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2754,7 +2754,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2779,7 +2778,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 

---
base-commit: 4f2df9a01754521fbba3493e8ad91ef65515e68c
change-id: 20261127-so5-qla-515-b1520cc04d0f

Best regards,
--  
Dickson Wu <dickson.wu@certik.com>


