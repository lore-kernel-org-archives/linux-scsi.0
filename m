Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878421;
	b=Zj+yNWeYsgdqMAw45eCj5nQrQzV3wT1iGdCX8oaAl3+x8+5FAagWPMFD49ig09vHZgOF
	 MJhAEBGM4eeBYgikOTGDGGy2fil8GtzPMn38InYZZzcdF5aC0FbsPYwlC63sTRDKi+U5h
	 dtWc6JhFEgKQ60BPBv0QDYajtYvZkNPL7F5Jw3n9IUp7M3tY6tPXx3Toga0P7j/7Aob4h
	 nJVKomXfYRPPyT+/EXfo9vw0zkLnAR8bqfxwxcHtLY7L58qbXnDWDamtz7XpGr0GX5j6A
	 pKRwOImSCmquANEDx5731TIulM5MVQom6s9BvYfzRbgTaUcclv2l14kLERlNMdgxLMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878421;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=RPMqxkipOxYkESVnKdtHt0CqeQ8C1S9Y+Y8T7HhpEyo=;
	b=DA2VhX0kagU/qUQVAAzdEaKqJ3/qrw7iy592Zn5z7Y9MlxRJJ+KzJNl4bEsUO0WqCD4q
	 6StoefzPfkuX3HrIAMA5hTPtfvrvOVYLdOmBEL1eV7NZnO0fKYbumRzwjpmrO2Pu25EzZ
	 0u5KkfwKxvJx0itpbp8si00S60o5/0zqBKKHwV1iHlydxauBLr0LMhHQrXHu7fl5VzxFW
	 0pbwyY0gPHt39+/ueQBr1tw/oXylxN/CtSUVaIBtTgdSi6XrFSrNIBkNGhEHqa6cBWCLt
	 BpKWhkJ9xuaeY8jzR8nCV0eBOfmyQIchzbHasEL3xquH1bxvbxJeMIJ3YfqdDt+8yUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA66606A32D;
	Thu,  5 Nov 2026 11:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CA66606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jL0Yk4fJWz5B13Y;
	Thu, 05 Nov 2026 19:33:30 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXPU9068064;
	Thu, 5 Nov 2026 19:33:25 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:28 +0800 (CST)
X-Zmail-TransId: 2afb6aec69887dd-14fee
X-Mailer: Zmail v1.0
Message-ID: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
Date: Thu, 5 Nov 2026 19:33:28 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDAvNV0gc2NzaTogcmVtb3ZlIGRlYWQgY29kZSBhbmQgcmVkdW5kYW50IGNoZWNrcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXPU9068064
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC698A.000/4jL0Yk4fJWz5B13Y

This series removes checks that the surrounding code already guarantees and
one store that is overwritten a few lines later.  It was found while reading
the SCSI midlayer and the UFS, sd and st drivers.  There is no functional
change intended; every patch is independent and can be applied on its own or
as any subset.

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

Patch 5 factors the duplicated end-of-medium test in st.c into a helper.
The similar test in write_behind_check() is intentionally left alone: it has
different remainder handling and only uses EOM to turn -EIO into -ENOSPC.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
