Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878422;
	b=je3khL0gg6Wcrihv54JS4EjxOO1ywIAlNYq72oph8QotwoWjzZtWJfRl73rHUvR+nhir
	 2v9q/EUkvTHdohC7T0sx3IG+JHmtbhl97sYXr1Dmigvaa22F14Vm4ZNGIuGwZ9GBdHMxx
	 U4NGT5M3e8PXMHn2b1MHTr5Yh7iIT5burWDleqFTkxPi9OOEdyn1bXK3KOUT70sTo07Md
	 2fJTrP6HyjHWLlDV6fTKkCZVGxH0LOu+F2orv9F1++Xu9McQ/G+Q6gSFMLfwM/thDU9xC
	 9XkfTJKQGO/mE9csJCxN1oGf7jXGv18zoBonAtYexbK4GvkpuEDvaWVIhTg+R1+ryrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878422;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=IpkYLRkecZNx+vhUGjdVMXl+GnO5qwKagABPI144p28=;
	b=mE8oQD8/fWffvZki5tqfYeSLYbM6Nh9suWFdRWAziZ8TKbLawwEnGvTfSUUmYKEYQz7c
	 yZOX5789OSN88Y8JPoXqSMJfFFPkFHtnlYK08E6cCGj1TFV2UGCh3OL1YILsAJSeA8ucj
	 JtuiC6Xb2DZxz0+9py9ng0DZEhjrj4p6Xg3tqaOVNUiGd+evfvDvceGSNWhGwNVkcX2xC
	 HeUvpVVzJEi3zR1viU1vnyddyV8lupom4GGx24uw3+TsaIriIb00Va33pfa5GPq/5Vili
	 Od+/YBtFgiLcWTGjeZAnci2BUMAkSbMZoo/0VQRWL/0UqEsXofPF5tfGTUkYrUCQ1Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA81606A331;
	Thu,  5 Nov 2026 11:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DA81606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jL0Yv6JyRz5B0rb;
	Thu, 05 Nov 2026 19:33:39 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXY9Y068129;
	Thu, 5 Nov 2026 19:33:34 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:36 +0800 (CST)
X-Zmail-TransId: 2afb6aec6990b28-15339
X-Mailer: Zmail v1.0
Message-ID: <20261105193336763FrusSP_FRcDQkxzc7F7kS@zte.com.cn>
In-Reply-To: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
References: 20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:36 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDMvNV0gc2NzaTogc2Q6IGRyb3AgdGhlIGRlYWQgbnJfYmxvY2tzIHN0b3Jl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXY9Y068129
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:39 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC6993.001/4jL0Yv6JyRz5B0rb

From: Shao Mingyin <shao.mingyin@zte.com.cn>

sd_setup_atomic_cmnd() writes nr_blocks to cmnd[12] and then writes it
again a few lines later, after the boundary field.  The first store is
dead; remove it.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..6028f9e6cf7d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1408,7 +1408,6 @@ static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
 	cmd->cmnd[0]  = WRITE_ATOMIC_16;
 	cmd->cmnd[1]  = flags;
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
-	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
 	if (boundary)
 		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
 	else
