Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795010262;
	b=qE49Ds2AWFQnPLZ/7lesAss0wxgOgB2OB82tfzPyQj/c443Oz1tusBVG5Uryw10PZbJr
	 oe1PpZ1DIZgFtEC+6oq+5MuHly7Dhzqu/Df++jVx70fzf2lTtYDVJHYcmYmoBPcGMQt2E
	 E58Yg5opB8cD6onXRJiMSt0R8tlSxXq6kkecpyvgivCrbvTYJn2/C2TkV+ZGZ2VaMT8+m
	 NllB01KNmImBPr4Bv5pzXyGUkVHWJ+MbDNs6OEdmC6EAz6w0WFCZtvIiIilOTW5ZzbjyU
	 E5UqVAfYnC6hH7/L56pl08W2+JZoeq8n5FOYRS5CYpCta4S/zk+kGoJ5nFH5nS5DliA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010262;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=9k6xkSgoU4/ycdA73IPAUpz2zxduvWOoGVm9HO78QCk=;
	b=KZbl4M3PGzRtlI3BRluU3TXaJWCizp5pXuC7jHXN98fhfHtuqE+cWbjR12mHXEy3F+Jz
	 rpJXsxYzuSThYU/we77GvJq+hulsQggfSL4LuNHGBLwtpa9aD0MUFocS9G+hdDNR6UngF
	 ALIB5IpY1rYFJ917kptAt7b08TgFWzBRHsBVCDZsG+fSS6g0m5xFwqanVUTTVbwMVzdq0
	 uIfUBnmel1+AB46T7juqt4SrVzoABe6T+7l83WrJLG/WrkGSDhDU03UQymn2VwKD8UzS4
	 fpascg7Q1G1vy3GxyrxGXabtFwULT7vTWIUsXbON4BKgvST3dlBLC140qZW9qAQKpkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpKN4xwd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4819606A32A;
	Wed, 18 Nov 2026 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpKN4xwd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795010262;
	b=wC3Eumy5vUzYEP/VaAEcCYXT3+aXje/fyymTBdOWstG3ZU8qqZODVcmYwQ7mr+5Rtd//
	 Yhqmx6qe0tt3n+4UyS0ugI3z8vlOmZC0xjLmmUxhBjkiPo5DVrazBejVhyfk25pP6PvPh
	 m0qJTUVId0QbnlMTi/bKGN9KaZjJWfnKRGgWfPcUZFhCvaBgqd5db6VNP1vRehPINVKmj
	 n/LOAuJ6TxqCSAGUoElsVGyiQxOlYA+rBVFgh2agAwD5iXpTEHxGPmzSM53QP5oIsNF2o
	 91actz0Rd8OEYvr8TPjlrXgciq4G72LAS163PszzW+SwuTjtdtMEb7wCuZIFIGWapTA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795010262;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=9k6xkSgoU4/ycdA73IPAUpz2zxduvWOoGVm9HO78QCk=;
	b=NfAUb8JHhzha+q4ZbEzKmEFIKEcIwC62iPAS/ca6o1cxQwf9TXulJmNbHDQ/9YgFCekm
	 BvwjykVJmS64rl6qBFV6LjIz2kcsDyzmNGGU/626J+OtfUNSiPl6pQbza+VurK1KtJj4v
	 ekbecQU0i8VSX4kb3SDRCKnKxYpoWpbvxzAqSjsPuY3CiKahDwjs2Gq9RFMqbToRnPxeu
	 S6fG3hkqssLEx0kWOgRUK+LerHeTTHF3a6Qi5YuKYClXBb8+TU1QOBjib+gpsfJTG28r8
	 NKBMJWotSqTDUXrt53DbYvE0QZLy3cvTF08M/w9hBx8AGYyjQOqpNVgNh4QSTvZsaCQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ED4121F000C5;
	Wed, 18 Nov 2026 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010262;
	bh=9k6xkSgoU4/ycdA73IPAUpz2zxduvWOoGVm9HO78QCk=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=FpKN4xwdcjqxMJpZCwWr5aPFqtlgYWe8ZwIpl8mL7/d6S1cJWgxdzw0jTsiNEvYnc
	 Ix5HJV7le25bBF1NAoP7yOqaJdQ/R9psBslIyZ0HUQDJbREnQ8fL/vpdkPmhqcoJKH
	 Hnmnpt3D1nyRet7AdjbRZrEfxHaO+daYTDEcq91nOKCAhOX91FOLcsJZGk+EHaZY0d
	 lFUMNPowM/XeaxW6lELexH0ek3RRuQXHI/asThfxrweuodNGzWKUe3XKirO2Z05pIo
	 84dQa1VkDdGT658EqVWUq3gs/Ot9CeaAgiCCkcPUFw2Iyoyd7XjW+8CMyhqgHQ/txt
	 lBbW08DGUikww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4B4D44ADC0;
	Wed, 18 Nov 2026 13:57:41 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Wed, 18 Nov 2026 13:57:41 +0000
Subject: [PATCH] scsi: ibmvfc: Unmap scatterlists before completing BSG
 jobs
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
Message-Id: <20261118-ibmvfc-v1-1-3115f5901130@gmail.com>
X-B4-Tracking: v=1; b=H4sIANSu/WoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0ML3cyk3LK0ZF1TU9OkRItk4+Sk5DQloOKCotS0zAqwQdGxEH5xaVJ
 WanIJSLdSbS0Ax0wl/2oAAAA=
X-Change-ID: 20261118-ibmvfc-555ba8c3cbcf
To: tyreld@linux.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795010260; l=2020;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=N0Tx4tKvk+IGw2iXqqTkUq8ZEOCSQRNuciGKIswz/Gg=;
 b=gfulJ5sTCNkCHuEG89KYs141VHVOJihg1jGg25SYidOMf4HKeizUjAnBk4ijAwqXuQBi+EnWy
 EG8irAzLWPhAgwj5bHaoFp5FuwKcgOpmAAtUB5Qtne6wavXO8KaJRNI
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

ibmvfc_bsg_request() calls bsg_job_done() before unmapping the request
and reply scatterlists.

bsg_job_done() starts block request completion, which can run
bsg_teardown_job() and free both scatterlists before the following
dma_unmap_sg() calls. The unmaps can then read freed memory.

Complete the job after the common DMA cleanup instead. The completion
path has already saved the operation result in bsg_reply and set rc to
zero; paths that return an error keep their existing cleanup and leave
completion to the FC transport. passthru_mutex stays held until after
the completion call.

Found with a static analysis tool and checked by hand.

Fixes: d31429e1517c ("[SCSI] ibmvfc: Add FC Passthru support")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
Compile tested on powerpc with clang (W=1, no new warnings). I don't
have IBM Power virtual FC hardware.
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index aa7ae81df41b..6dce72cb80b5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -2392,14 +2392,15 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
-	bsg_job_done(job, bsg_reply->result,
-		       bsg_reply->reply_payload_rcv_len);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
 		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	dma_unmap_sg(vhost->dev, job->reply_payload.sg_list,
 		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 	mutex_unlock(&vhost->passthru_mutex);
 	LEAVE;
 	return rc;




