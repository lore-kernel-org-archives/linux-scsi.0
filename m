Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195491;
	b=ibDKna4yiTzQIrGKIHfiPWbFXP+y70Z6oBlvuXp1xB1pNZC2iBsNyhAKXNQ6Ny0A3UxJ
	 ugsigRmPwvwLRCr6sAh3pFVDZxin/vv6h0z5hDtLSngnn1ThAyxG3LUzB6CRvFl7xl4Lf
	 5lxNLBDKAgZSxL/IYmWGR+ggKWRyLK+AAcNqv0k/tcUt279EsELlpaLiBkBhLnEqaW5ls
	 cD3phcrq7Ilu7ORkbPH3l7X1qs+wG8eC3L1jnTVZxIMOanvoQscA86vpP1kuGZq4APT4m
	 jCxI05D99xtrVgQA6Wd828LSNYc4Gzejmb/rBRczsjAMcFAihHlxoyslcuLaPw39ARw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195491;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:In-Reply-To:References:Date:
	 Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:X-TLS:
	 X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:X-Fangmail-Anti-Spam-Filtered:
	 X-Fangmail-MID-QID;
	bh=MXl/e6qu+ioZEUhOUf6hmu+sVC8NFvdMILnBlkoNtSk=;
	b=h6h4hfF4UauLp2/9phU3P7OHIA7Y77mAr4vZ2NEgN+a+ncK41EOsIMnu50N0VxwgHrUS
	 5VxTqqqoOehyM3+cSaOvCdZXs+8HYR7jFN+yZS7duHRW0RW9+N/lFOwUf+Yz875uzL/fJ
	 OgWRahRmSegjaK8QaDNq6wWaXzk86xUvxo9OmgMjnht1vfzqhtOnt/gSK4hmLS/4iaFDn
	 eluFSbx/Q88B5u+MPET1rFWEHMuyTq5MSl0KstaG7VG9i6TykjLZEi8q8WCaSt0lsZB0w
	 oyKSihKfaeJqllg2eL+aZ0NM2DCd+1G/xbNtYjcbGDgImOSTTJXpAIAFsLZCY480CkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=AXazOBAC;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C277606A321;
	Mon,  9 Nov 2026 03:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C277606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=AXazOBAC
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jNFqP1HHHz8Xs6w;
	Mon, 09 Nov 2026 11:38:09 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794195489;
	bh=Rk8E2o0iNbGzSlwNucxYoTGYEFkZ7TvQ5Ke2MeoVabw=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=AXazOBACFVNWJt0qO8YaVn1cUqmSs8utj8mwkwguksAWyQ0d7GQ0Z82+780qYpgYF
	 hlrxuaShg0b+ceFcW4dXD8hgeJ6Ngb7jjWhoIYTdlHdkB0DtL6YumHnCHzjtVtlYIQ
	 Jwq2rO09texYI3+OwqMm+8MtDaV9qDuZRe3fBk+aTuhtuB0/XW/Wpl/2K+aJy9URm5
	 NM1Ci5TabC9bqEoSE0xNAI4RSciQYKidvk0cTq6YLLbqgb/ewMR3oO2UmIeC2nDC/S
	 LE5gB6ATb72kzyxeV9OG6E2KIbcdemvGDqrIVj7uMGFpquBdo2TAG56jwWRboIiI5d
	 OhzT/+YpSN3iw==
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6A93bvBp063731;
	Mon, 9 Nov 2026 11:37:58 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 11:37:59 +0800 (CST)
X-Zmail-TransId: 2af96af14017f10-4110a
X-Mailer: Zmail v1.0
Message-ID: <20261109113759172RbqS1gfR9Q_8vyZ4_GdUB@zte.com.cn>
In-Reply-To: <20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn>
References: 20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn
Date: Mon, 9 Nov 2026 11:37:59 +0800 (CST)
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
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDEvM10gdGFyZ2V0OiBjb25maWdmczogcHJlc2VydmUgdGhlIGVycm9yIGZyb20gZmFicmljX21ha2VfbnAoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A93bvBp063731
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 09 Nov 2026 11:38:09 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF14021.003/4jNFqP1HHHz8Xs6w

From: Shao Mingyin <shao.mingyin@zte.com.cn>

target_fabric_make_np() replaces every error pointer returned by the
fabric callback with -EINVAL.  Return the original error.

Fixes: c66ac9db8d4ad ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ab8f81650710..5bd2a042aac9 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -479,7 +479,9 @@ static struct config_group *target_fabric_make_np(
 	}
 
 	se_tpg_np = tf->tf_ops->fabric_make_np(se_tpg, group, name);
-	if (!se_tpg_np || IS_ERR(se_tpg_np))
+	if (IS_ERR(se_tpg_np))
+		return ERR_PTR(PTR_ERR(se_tpg_np));
+	if (!se_tpg_np)
 		return ERR_PTR(-EINVAL);
 
 	se_tpg_np->tpg_np_parent = se_tpg;
