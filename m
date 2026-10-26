Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015662;
	b=wdNox3qrr1HQvApTnN4B6PekYUgzI8s9nmyAmyGdpKCTQRml1+NeL6J++LGijzgxkVtZ
	 CwDchzc8O4sj357m8C4+g3oXsAVKtf6OJXLL3vSs1ynOpxBJQxSUXX51gDR30RsJ+sOeP
	 tWbvXBImm2iH9m/akcKGvEiFjdelTY7JaJLY2XC/XnOv1MZ+6cIoNtqXkFPk1XlIwBR5N
	 lS+MRTH8j5quiCMNSSueYGYNEFycJ0wEEfezKQrxuU5kHRm8GFb9X1QZA8Mj8JFrIyq7e
	 MNYJlSBylGnHJhwi0usOaKI6Hw3qk9B3qEspCwymFSK6j2BWxizEDycouv6c8cpsAAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015662;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=djskXxgNWnAmCtiOuvCkzlitVGSLhklWx7+6NFYmau0=;
	b=OWhsIjHw5kRhu10y5tP8wRYqcLGqiJVjd60RGLbVGadnofWyDE/T5mPKE09xsEPpyYMz
	 OU4gq2AQblueSOzNSXY3WmT1iX/iFLC5yr36oAFHaEI/IMtpOqHLAyMK2VrQkD7woGfm6
	 TzUgJiJjYMiH3t1tGTyUKDkEHD6T61YzSOZpa9d2HKo1dxu6NDFZbfbibjjQvKvMVSxVF
	 T55fEwhsMO/2dJhjN/uSOwhFEjziJyAulj18uaP40FeHV7ak/s5yJOwgNnP/1ny/Vd9Rk
	 tMPPzsBQnfL2ATYPQK6CFMXp/0xWvg8LeSz827Ut9DHSZfqgyy8aoWtNPFHUG0vVRcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7683606A324;
	Mon, 26 Oct 2026 11:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7683606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jCsVM1nJ3z57DCf;
	Mon, 26 Oct 2026 19:54:19 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 69QBs6mR090995;
	Mon, 26 Oct 2026 19:54:06 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 26 Oct 2026 19:54:09 +0800 (CST)
X-Zmail-TransId: 2af96adf3f61fe9-f977f
X-Mailer: Zmail v1.0
Message-ID: <20261026195409354OWEI2b6HO7swSphvv1FOc@zte.com.cn>
Date: Mon, 26 Oct 2026 19:54:09 +0800 (CST)
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
Cc: <bvanassche@acm.org>, <hare@suse.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiByZGFjOiBLZWVwIHRoZSBlcnJvciBzdGF0dXMgd2hlbiBjb250cm9sbGVyIGxvb2t1cCBmYWlscw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 69QBs6mR090995
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 26 Oct 2026 19:54:19 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADF3F6B.001/4jCsVM1nJ3z57DCf

From: Shao Mingyin <shao.mingyin@zte.com.cn>

initialize_controller() records SCSI_DH_RES_TEMP_UNAVAIL when
get_controller() fails, but then overwrites it with SCSI_DH_OK
unconditionally. It therefore reports success with h->ctlr == NULL and
rdac_bus_attach() continues with check_ownership(), which dereferences
h->ctlr:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  ...
  check_ownership
  rdac_bus_attach

get_controller() only fails when its GFP_ATOMIC allocation fails, so the
crash happens exactly when memory is already scarce.

Only report success after the controller was found and the device was
added to its list.

Fixes: 327825574132 ("scsi_dh_rdac: switch to scsi_execute_req_flags()")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
---
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 742534c99386..0986a6e2a6ae 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -450,14 +450,14 @@ static int initialize_controller(struct scsi_device *sdev,

 		spin_lock(&list_lock);
 		h->ctlr = get_controller(index, array_name, array_id, sdev);
-		if (!h->ctlr)
+		if (!h->ctlr) {
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
-		else {
+		} else {
 			h->sdev = sdev;
 			list_add_rcu(&h->node, &h->ctlr->dh_list);
+			err = SCSI_DH_OK;
 		}
 		spin_unlock(&list_lock);
-		err = SCSI_DH_OK;
 	}
 	return err;
 }
