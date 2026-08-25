Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E23939A6;
	Tue, 25 Aug 2026 09:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649910; cv=none; b=rA3xdJP3mKghHMwXsoyfZo0Wj69Jfgm7w5GzDg7lQjhxCE6kn4S7C5lVgG7Uhk2MyzLDab8FHDPt4rARwa3vJ25JykMLDuEDyklEfFhDIKSnUpkzEQVuweDekVMGHzWEQpq+LHvyb3MwjU9+j07gRdxvNTG0+LqWjKCym8iwOaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649910; c=relaxed/simple;
	bh=obHdAStsjgQmHq+Ul2pCG+c1IZtNocYaXatSOFMUKW8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PwhWMtEVByIkb7JUVk6AroOJkTImr7j1CMiiMOpPSTUHf+EB2LW5jW3AlJwz9+Dlz1bD6+/3zliokL+lUWvtytPssTTIFhOOKMg8B0TCTv6nZ9dq38YZ+y7YX4XN7yO3qkTLsqn/7FUsZaitrByyokTd6KQb6jPJxgDd0RPYvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=DDJqg3HI; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="DDJqg3HI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787649903; bh=obHdAStsjgQmHq+Ul2pCG+c1IZtNocYaXatSOFMUKW8=;
	h=Date:To:Cc:From:Subject;
	b=DDJqg3HIr8j1BUJA5GNEEmf1mSQCRS0V9RW3y5ZirL3P0y0wE30QNwzQtj7nbvaOU
	 DdZSlQE02POChPAD2fLl1SSQFdNDagtp1nT5ksc+7dspgtmC81hFtEulR3xPxADKBf
	 Ir/qcJRP3nPfsQGPZUzRk9BW+QJNmomyiiwLocNU=
Received: from [192.168.255.10] ([111.206.96.146])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 6419BCEA; Tue, 25 Aug 2026 17:25:01 +0800
X-QQ-mid: xmsmtpt1787649901tyxrp4iao
Message-ID: <tencent_F38F19C2D497EC19AF3331BC5030EFEF3307@qq.com>
X-QQ-XMAILINFO: NaMvLgwjnAy7PLC0WL7/JOAN53qt8heco/ddc66s+yZwRtdJ3nFiEunOBRA0MF
	 oJvfcwQFND25LN2NfqDWPwnIxsaRs4c0TfMEHZsSpAcH5tgjUAZXvnT/oxd8M1E7IXGEZtU1/hUs
	 xgpNNKalNdidb0kyhaxnGtLiDWTIpOyNEgRsf2PgqnjS0dlAhxnlEpipCKR7Hh9HK1BdULyj9VgE
	 yOKrJDiREznYiJ4Zd9AtD5h5vkQVD9XG+gVjwCf+sf8tJhA8D/1349L9KSLsl+sgzzJ6TlW0JOpQ
	 s0S/DWj1rOztGlgwnKXtAqhFjEyZ/fD5zXYbt+yi+pFlDBMIJLhlblM8IhZ6qHoLr7vjn8RgDYic
	 z7xhvJYaaSv3LqAxe14i6rdY1mulfmcqtWMid441Z+jnzB8LK+y9bWWIGENu2ubSP3midg5NYDHf
	 cMhaDn+1MRXPKXDNmBZHy6IrpkoU0uGja2joa1QTgohoav3BKpSD4tzVRFcZjzMvNy/6s+/+HsGq
	 GLC3g48jamjXEAg+2J89KU4Q1TtWo/i7eVDjXWBPPGNzUldKAdKna68B8h8+62Q9gvWEHNHlX0IR
	 +IA+pH+VnGOaWx98QjGX+q1IQdygQZZ2E0WT6V9xiceVYfX14pCCxQg2YkvMqqiB7dyWO1XU6SvL
	 ipEw4Uts+xfTWXpaYQNKrNhD+bn1APn0uefNp9LIKJvGUtng/ftl9ocEjE4Vvd79MqHRgjlJH/sR
	 ClLwtbsXUxo9u0U6kK1LN6I71kTw902a5SwFjG/YXQI/cnmbHCS2Rw6GHbYTvjinBOoT7DjCfkCp
	 auE6gfhVUgEKCv5TK9XgsehZrWICCVstFUCQ4Sll817V7K9ye3MwSHPkV7XiBhXFTdvwegVnKaD4
	 ak0XFowmi2WmJB2exh1saThNC8oMhsXHnOQzPK8vrKlok+047ElMMNEslcQNsjf0mkpL88qfsluj
	 PtlEzGJbQ/mwKaCaRl80mmcVCerO6TBMvhHIvMJOsOeI4cFDHJYQ6/i/1ftARc06bOrr7WK+w6RR
	 BipMueI/UPE1ISfuCnw95bVnY9V+bUjsqrkDX1JzjzyjW8wEzBhoLim9FuAtYMmbBoZ9gXIMWEKR
	 A3OWw9jZM3lLRED4khVuNlP1pKeA==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-OQ-MSGID: <b29b0d5a-4081-4ca7-9b37-c245c60a3393@qq.com>
Date: Tue, 25 Aug 2026 17:25:00 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: aacraid@microsemi.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
From: Yang Zi <2959243019@qq.com>
Subject: [PATCH] scsi: ips: Fix NULL pointer dereference in ips_release()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When ips_insert_device() fails before calling pci_set_drvdata(), the
PCI device's drvdata is NULL.  The .remove callback ips_remove_device()
then calls ips_release(NULL), which immediately calls
scsi_remove_host(NULL).  That dereferences shost->scan_mutex at a fixed
offset of the NULL pointer, triggering a NULL pointer dereference.

KASAN report:

    BUG: KASAN: null-ptr-deref in __mutex_lock_common kernel/locking/mutex.c:625 [inline]
    BUG: KASAN: null-ptr-deref in __mutex_lock+0x8b/0x1010 kernel/locking/mutex.c:820
    Read of size 8 at addr 00000000000000d0 by task syz.0.671/5574

    __mutex_lock+0x8b/0x1010  kernel/locking/mutex.c:820
    scsi_remove_host+0x24/0x300  drivers/scsi/hosts.c:169
    ips_release  drivers/scsi/ips.c:654 [inline] [ips]
    ips_remove_device+0x155/0x2840  drivers/scsi/ips.c:6701 [ips]

Make ips_release() handle a NULL Scsi_Host by returning early, so the
remove path is safe when probe never established drvdata.

Signed-off-by: Yang Zi <2959243019@qq.com>
---
 drivers/scsi/ips.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 41ed73966a48..39568a7effb3 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -649,6 +649,9 @@ static void ips_release(struct Scsi_Host *sh)
     ips_ha_t *ha;
     int i;
 
+    if (!sh)
+        return;
+
     METHOD_TRACE("ips_release", 1);
 
     scsi_remove_host(sh);

