Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878426;
	b=C+oYs6VK7/039l53q76nP2/6+t0tC7zOL/FY0/CtmuLC2zX/vHVSSuHUt1vr3lKHS8Qz
	 Dqsruk8xQVnK+WdHCfKhkKUuKsBegcKDa26gZc3u/0uxV2Kz+GkZORNBOCA9nZ/kb4FRl
	 6bCxu83xG8YWLYx8dd6UGYlaso0z5wS24NzI3KNVWqkqp+o8cexmlVvXttwf6CZv8ehtN
	 qU5oB1KkwD6Yj1r69MBPklTJVA5f2m6g+4SsMbsS+2P3EAZruVQjR3Cd3dnBcNuV6B8w/
	 RhDfmBOuymDd2XS5WS+ANJWvBmeMET+pS7bl52kaoeKkgj+aWQydASvZ7kZCwwkkFnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878426;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=ElhWel9pOcK8HQlE3E2zy76oyL70AyW8jfB4DEXiQ+s=;
	b=OTm919RL1pSIbr+QpQVnh2POb0gQx21a8RhPkahPq7uG4vrbi3iJB80/wwwlCCVIj22J
	 u2oX0x0bHv5z5k+1OiHneDjhJDyWayzQ39HDSHydvqRLMHZBX4jlg5NrBywUmQv4ghDwP
	 fnp817BEyfcECfJA7IoSfo7UB9QUZkiC7JfzPy51hbpTQ3P830HBDpUv5xWzSJZrP5NIL
	 Inx5Zif2JtD2L79M7y3ZMsV7CDo2H5LiHxq12JAuCB+6n0Hf3GUtpaelmoXT995DkStBT
	 QgXTF6dmLYrUfizH9P6cDR0koHj8bLpcmZF80/GlPprxVsi8DB8BegYDe1CMtUH33zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A2A606A32F;
	Thu,  5 Nov 2026 11:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0A2A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jL0Z048ZGz5B0rj;
	Thu, 05 Nov 2026 19:33:44 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXaiV068173;
	Thu, 5 Nov 2026 19:33:36 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:39 +0800 (CST)
X-Zmail-TransId: 2afb6aec6993c5a-1546b
X-Mailer: Zmail v1.0
Message-ID: <20261105193339565ydLHLai73bbBko0TtjrtV@zte.com.cn>
In-Reply-To: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
References: 20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:39 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <loberman@redhat.com>, <jmeneghi@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDUvNV0gc2NzaTogc3Q6IGZhY3RvciBvdXQgdGhlIGVuZC1vZi1tZWRpdW0gY29tcGxldGlvbiB0ZXN0?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXaiV068173
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:44 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC6998.001/4jL0Z048ZGz5B0rj

From: Shao Mingyin <shao.mingyin@zte.com.cn>

The same six-condition EOM test appears twice, once when deciding that
a write-behind finished early and once for the WRITE FILEMARKS path.
Factor it into a helper.  The related test in write_behind_check() is
intentionally left alone: it has a different remainder handling and
only uses EOM to turn -EIO into -ENOSPC.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e9d41e3cc2dd..e0ed6b487a20 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -354,6 +354,15 @@ static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
 }
 
 
+static bool st_eom_ok(struct st_cmdstatus *cmdstatp)
+{
+	return cmdstatp->have_sense && !cmdstatp->deferred &&
+	       (cmdstatp->flags & SENSE_EOM) &&
+	       (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+		cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
+	       (!cmdstatp->remainder_valid || cmdstatp->uremainder64 == 0);
+}
+
 /* Convert the result to success code */
 static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 {
@@ -815,12 +824,7 @@ static int st_flush_write_buffer(struct scsi_tape * STp)
 		if ((STp->buffer)->syscall_result != 0) {
 			struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-			if (cmdstatp->have_sense && !cmdstatp->deferred &&
-			    (cmdstatp->flags & SENSE_EOM) &&
-			    (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
-			     cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
-			    (!cmdstatp->remainder_valid ||
-			     cmdstatp->uremainder64 == 0)) { /* All written at EOM early warning */
+			if (st_eom_ok(cmdstatp)) { /* All written at EOM early warning */
 				STp->dirty = 0;
 				(STp->buffer)->buffer_bytes = 0;
 				if (STps->drv_block >= 0)
@@ -1426,11 +1430,7 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		}
 
 		if (STp->buffer->syscall_result == 0 ||
-		    (cmdstatp->have_sense && !cmdstatp->deferred &&
-		     (cmdstatp->flags & SENSE_EOM) &&
-		     (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
-		      cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
-		     (!cmdstatp->remainder_valid || cmdstatp->uremainder64 == 0))) {
+		    st_eom_ok(cmdstatp)) {
 			/* Write successful at EOM */
 			st_release_request(SRpnt);
 			SRpnt = NULL;
