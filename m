Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793456577;
	b=v1gdLWaMVepabxB1bCh+Yb+KZkWZ1w4/gLhQ6Y3f4VKjZGzOXkLJZxY68gxnksp4N54k
	 LFFaztCcllTzbGaZ14fR7KpcIYxGTEdFhcIR+Antfu1CdahcDk6CkotYCHmyRNBljsQMy
	 jWtFXq6hAuaSoebGIWCiI7B4GL6LoNS/0bD7sfmyUPaFuqQeFsZMNVl/rCgrzKBemrbjb
	 tQM8I+9Kx67uCf+t6IxoM3FsMT+Sa6LpAwvey2NqdfheaxKRnK9S4OT/EYdrAIHxI2aAH
	 h4WFKZ8Had9jEVvcaHuGCo8jhvG0plUcgz1GQAINVGeOaqc+N0SlRByvDp+GdGXTlRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793456577;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=evtWtDQ9nM1pnSBzr2VzKv9/6zOtSDSMwin2Z6hfDDU=;
	b=1NMeEMuRak0kBVO4Hn2iYeGv/fNUDvzvATQWOfF0NDH9ypGd+gECzatwdUbHhPyRRKKA
	 gEsYXCav2ADrmRiI8+hik6zk/uwzxvxPwzPXlC3NrPjSs0A8P1vBkHvmMYg4OBTIQcvVd
	 WYLVfk//8eM3l1V8j0HMx27XyHfQ4FNIaaZF9Za4S+dj7M6RH/8TTL9pwXsuLR0uBZGFD
	 CYeo6aHbted9Ks2fwJLlUgaiEeF8XSgvQ1EcGFYPT+QwFohLSBEVsnlTpUcCpedqNJxB2
	 7edzYoKhUQ81DXds0kxL0OmMledT6N8crFyRtFKli5zLJ0qrh9ElBoxNG/WI4oZv8gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622C606A31C;
	Sat, 31 Oct 2026 14:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7622C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jH0YP3ZvGz8XrrJ;
	Sat, 31 Oct 2026 22:22:49 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 69VEMgOV055909;
	Sat, 31 Oct 2026 22:22:42 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 31 Oct 2026 22:22:43 +0800 (CST)
X-Zmail-TransId: 2afb6ae5f9b32ca-0ccc3
X-Mailer: Zmail v1.0
Message-ID: <20261031222243820vSs-SXTIpNSHpWeC2dJ38@zte.com.cn>
Date: Sat, 31 Oct 2026 22:22:43 +0800 (CST)
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
To: <mkp@kernel.org>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiBzY3NpX3RyYW5zcG9ydF9mYzogcmVqZWN0IHRydW5jYXRlZCBGUElOIHBheWxvYWRz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 69VEMgOV055909
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 31 Oct 2026 22:22:49 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE5F9B9.000/4jH0YP3ZvGz8XrrJ

From: Shao Mingyin <shao.mingyin@zte.com.cn>

fc_host_fpin_rcv() computes the length of the TLV area as

	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);

without checking that the payload is at least as large as the fixed
FC-ELS header.  For fpin_len smaller than the header size the subtraction
underflows to a huge u32, and the min_t() on the next line also reads
fpin->desc_len at offset 4, which is outside the payload when fpin_len is
4 or less.  The TLV walker then parses memory that is not part of the FPIN.

Reject payloads that cannot hold the header: there is no descriptor list
to parse and no statistics to update.  This is not only defensive:
qla2xxx forwards the firmware-provided frame size minus the 24-byte PURX
ELS header, so a frame of exactly that size reaches this helper with a
zero length.  fpin_len is supplied by the LLDD and the helper is exported,
so it should not assume a minimum.

Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index bec6ca38375b..a935e0c723c2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -904,8 +904,11 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
 	u32 dtag;
 	enum fc_host_event_code event_code =
 		event_acknowledge ? FCH_EVT_LINK_FPIN_ACK : FCH_EVT_LINK_FPIN;

+	if (fpin_len < offsetof(struct fc_els_fpin, fpin_desc))
+		return;
+
 	/* Update Statistics */
 	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
 	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
 	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
