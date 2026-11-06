Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975777;
	b=xzL1grtyTujJV5y+0wTAwyYOgyUrwyDYuMANa/pcGh2wKMrY+PM7c8EO+v+OKlCVuYdF
	 r1KXKv8G2hs4hf4odWaFmgkIhGBuyVLZ28huFeYOulZzm8a2TwTjiPeDkIkP1CrWYBwMA
	 Za6/L6U/tBnOxks/5n7ek72pFk27z2aEWSqoVVwimncZxteYK4IVBftDKodyxsARrVqIn
	 1iKQDUW+3rgu1iOTohTxfoLHxsdCrPmhGP1rzVaqWv4HkMr8064j+0OdwtJKZwbFhDil8
	 UnZErPkbOss10ldKkNft94mtZ4SgJ82UY24c6n9aUhpheZM5TNyeUYMdXTRXUjPfT7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975777;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=juZ3G+gadEgxDT4f4Tw6uAIwSaNKfGswZzfMTWJOYSs=;
	b=VPnAhuoTDuylRotx5QUMXZ9uEDiyp6+zqa5g6ejLv5pQEf8ZkZzVMOLomsH0QJWfkOsW
	 PWhzScUCwYpdLa9ye1xKC4at5FBN2WL6y+26ePg0HPG03pZ04Vv3tadLi4iK5sZQ0rDl3
	 cCHRYZAc8m/mINQ1RpaAKcpSRWGGHikXWFxU874ecAO4dVYefRS8tRJdCyVw2YnMkG8+M
	 PPFy7azxrhPsy8LI7ZHbkasHpNIvKbiqz++THvSEc0J/UrzhbFrIV/sAA9VEtLC9e84Uc
	 Ji7OmYS2AjEcNjdY4BxZZATr25chL+rsEbOPgb/9bvAyKHWmOii2M+86kY8UzFZPBHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C794606A32C;
	Fri,  6 Nov 2026 14:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C794606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLhZ1445Tz4yjjB;
	Fri, 06 Nov 2026 22:36:09 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6A6Ea16j022937;
	Fri, 6 Nov 2026 22:36:01 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 22:36:04 +0800 (CST)
X-Zmail-TransId: 2afb6aede5d43b4-50391
X-Mailer: Zmail v1.0
Message-ID: <20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn>
Date: Fri, 6 Nov 2026 22:36:04 +0800 (CST)
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
        <jmeneghi@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvNF0gc2NzaTogcmVtb3ZlIGRlYWQgY29kZSBhbmQgcmVkdW5kYW50IGNoZWNrcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A6Ea16j022937
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Nov 2026 22:36:09 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEDE5D9.000/4jLhZ1445Tz4yjjB

This series removes checks that the surrounding code already guarantees and
one store that is overwritten a few lines later.  It was found while
reading the SCSI midlayer and the UFS and sd drivers.  There is no
functional change intended; every patch is independent and can be applied
on its own or as any subset.

Patch 1 removes a repeated offset check in ufshcd_read_desc_param().  The
function already rejects param_offset >= buff_len before it reaches the
is_kmalloc block, so the inner test can never be true.

Patch 2 drops the "result < SCSI_VPD_HEADER_SIZE" branch in
scsi_get_vpd_size().  scsi_vpd_inquiry() returns the page length plus the
four-byte header, and returns -EIO when the length is zero, so the value is
always at least 5.

Patch 3 removes the first of two identical nr_blocks stores in
sd_setup_atomic_cmnd().  The second store, after the boundary field, wins.

Patch 4 drops two -EOVERFLOW branches in sd_read_capacity().  Neither
read_capacity_10() nor read_capacity_16() returns that value any more.

Changes in v2:
 - The st end-of-medium refactor from v1 is dropped: it is a refactor
   without a functional need, and the existing EOM handling is better
   left untouched.
 - Patch 4: name the commit that removed the last -EOVERFLOW returns.
 - Add the Reviewed-by tags received for patches 1 and 2.
 - Drop the Signed-off-by from the cover.

Link: https://lore.kernel.org/all/20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn/

Shao Mingyin (4):
  scsi: ufs: drop the unreachable offset check
  scsi: core: drop the dead VPD size check
  scsi: sd: drop the dead nr_blocks store
  scsi: sd: drop the dead -EOVERFLOW branches

 drivers/scsi/scsi.c       |  7 -------
 drivers/scsi/sd.c         |  5 -----
 drivers/ufs/core/ufshcd.c | 11 +++--------
 3 files changed, 3 insertions(+), 20 deletions(-)

---
base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
