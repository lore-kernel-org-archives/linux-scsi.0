Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240419;
	b=1aB+frXDFCUqc3M1A7VVXx5qfZJQ/T0CTORo5kzynalU0Mg6iTJcYO4aZgRazE9M19hJ
	 ZKkWVxH3ItdKzlgmKk4crVVtDkAlwKdep8tSD0oFPM5SmC02ozaoGwjRTDtlzuND0AzXC
	 XqCA2N3JSxlWvqk+cfn7Hl0KufYtKXhizrhaV6sZ1EUL2mcuA8fED8QX4nkJ0DD/eWAxd
	 MMfVTxPRQOrJpHtv/HNKLC1tDLwzJs3oyl3CXrsRl1mP8Wwu+xxAAhWiZTbL5/1Wq/xrK
	 eRWxYY0F0fzVGKMGxJv1TtvC6Kdv0x+VQT7X6KqeelSWw92L6YPGTqOwS1Ixu2b7ARQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240419;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hI5l4bj6TcV+Vd3lWVQWsAgDn5n3YxniOdSZG9zMnJw=;
	b=ubPNwdEvDIYntMxw9j3jochiEJmXXUyY3Gi9KjmTHgMUGXB89+KW7tLe+s2BhXdu4toQ
	 6Fckatg5Wt9ogHOcZ130DYdi/cUvkGWnowSk4xrCeAs2xR1z2LG8lSrYsm8xX4ijMcJbj
	 93M2OPM1hawDB2CyiSeWWVamo5nOPeWUw0L13nwMw1Fwx3N4hIziEpKv1AuDLBUgvR4MB
	 luhepkDiiALXeA0uobBJqZoCe+YklUfyW1C4351tuILkeSROkeWeD7W8y3v3nYkbO+pQ5
	 I/VwGQyp8PHDewR4V76rs6lIPZN5QPfUO4EALT3uu3RXSAUkWK5wDOHiU7SocCgrKWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rdzRGRPM;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C1606A330
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 16:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E91C1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rdzRGRPM
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53c4b82919fso14094191cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 08:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794240418; x=1794845218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hI5l4bj6TcV+Vd3lWVQWsAgDn5n3YxniOdSZG9zMnJw=;
        b=rdzRGRPMR1idrJRKQ3PnfTN8tJ04fwid2deV4Grs8wbhxYaxSg767fJeiuLdJtLtet
         Qol6UoI72Gb3CTqedOh5tkjdq9xECUh0xBdUcAXQRB90bLNH2Mrmgd1ElpfcwKkC5AZF
         G9xdFvRo8tVWNelcO6nsEaKOuk8nkl81WuaqcF9f8NQKsTY46vGo4dR5f8YInCvdQ4A2
         42tUjsjA/CjXW8eycZyMT3vS4r0S8KMwUdR7yp27IwmY/c2W7fW7T1GtOt2TOgoqn1XU
         E56zFv2yta+BM2yDDy+MPI2TY11+m3g3uXKDgnwezFPPfda0knui/rk4y0b0k9dkDJhD
         q56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794240418; x=1794845218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hI5l4bj6TcV+Vd3lWVQWsAgDn5n3YxniOdSZG9zMnJw=;
        b=0VysQWkqLUxmWhH+ttDObnNPKIknvMeuOzePdmtUqiDqe6Hy/v0jTGDptZgZL07iIM
         Kwfvcz30KXayQBHBhSJDoC/a0shDGVcQEhLsXMsKAqXWDR9+Ry0ZNVDOi/dqMNqcoBPB
         bOBYmQ4H1a3qcqCSzQnOpmkxaeqZyabHFs4m1NycvQzZ0oy/3WMTT6K1G+kH3BFoEPd9
         A3Zs0+bj2XXzlD5N2xEK1Br/OIsuQ65aKVfn+eeNOu9ep2kr7e4y9Zll9W4B4AWlsx0p
         WuXXPdYlY4FEgFQAlA7pFk5Ds+wH77l0G4e5puvpIb5DupaXGdcar4yrUUU8Vgp9Wz/m
         62eg==
X-Forwarded-Encrypted: i=1; AL+hErFCIYyXCe45dkMZ/YWGTt7OuhLVtTX4yaUx2fL7NGNRKpwXnfqa6XKwdFFU7PPrzgOEpCjSopAIbhUw@vger.kernel.org
X-Gm-Message-State: APuU4Z8kzLhp2ab52+UREO+zetM/b5W8jZcH14/bK0K0guTgfjk1opWD
	Wb/rO6BcXwEBc6Nh5ENRKSubqeerqaa3LZKQ71Knw0hh15pH/o4rM5r9JC4lUKmV
X-Gm-Gg: AYBFou21i3KFo6C7hNjRka3TOAn841hnEq6RUxwzZbwBn6+o1zrMj8P2y5191bh0ule
	cnLCrmHesJ4lBHAKW4+BM5NYCEIN5r6pktJUXsTILMl1Ja3BMX0k84v4c6pSXM1NjthqzLmjJ/W
	FU3cKFOAoUTbcoAPAJZwRkNp/9YlFW+tyIgm6yJzT1V1e8MtdGuRnexVg2qqcmyh/ZQsYyVB+7R
	jhbCBQpf1Xl/s2yQ2jdNaArF+MYRVUYV1uNgzr2eEHv6BJzzB1KEWZoYLdEx7efwWE2uJIYRt3J
	syZ+t8rRXZE//wOEg9XsJqPAWVJ2na66UhijR1njSRTUoIHaMdir4vTuIbDTnTwIcLvkGpdObDY
	GDwmfQtkxi8lUJtfyGy141gAZZDUnxzMdf903niIiFgUMAhG/jPNeQjCP4I2PV+H525yzDO4wZ5
	o+AZwARw4WIrK94ve0I6nlVgFk2OLKsyMwqKBH+EAsUyrqkOx4jWl8Q6tZMExcVH2onXFoAX/h5
	eNYxLV442IfTGZDaJT3vPL4XoeqUEl3YWS+JRWEqRdoqC0Xfbqk0a+ytqadMekpZmnqGBlBX31e
	ypS+uvV0qyh8DxwzLio=
X-Received: by 2002:ac8:5d92:0:b0:536:645f:c901 with SMTP id d75a77b69052e-552a6634d05mr69872741cf.67.1794240417643;
        Mon, 09 Nov 2026 08:06:57 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550be2e22esm438061cf.23.2026.11.09.08.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:06:57 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH] scsi: ch: Remove the minor from ch_index_idr after device_destroy()
Date: Mon,  9 Nov 2026 11:06:51 -0500
Message-ID: <20261109160651.986356-1-lcy8047@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ch_remove() removes the minor from ch_index_idr before device_destroy()
removes the "sch<N>" device. A changer probed in between can get the
same minor, and its device_create() fails:

  sysfs: cannot create duplicate filename '/class/scsi_changer/sch0'
  ...
  ch 1:0:0:0: ch0: device_create failed

The new changer is then not attached.

Replace the IDR entry with NULL instead, so that ch_open() still fails
with -ENXIO for the changer being removed, and remove the minor after
device_destroy().

Fixes: da707c54c342 ("[SCSI] ch: fix device minor number management bug")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Reproduced in QEMU (x86_64) with scsi_debug (ptype=8, add_host=2),
which gives two changers on two hosts. Two threads, one per host,
delete the changer through sysfs and rescan the host in a loop for 20
seconds. Without this patch, device_create() failed 992 to 1151 times
per run in three runs. With it, it never failed in two runs, and
/dev/sch0 can still be opened before and after a delete and rescan.

 drivers/scsi/ch.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index b2c9fb71c9e0..390425671a3a 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -952,11 +952,15 @@ static void ch_remove(struct scsi_device *sd)
 	scsi_changer *ch = dev_get_drvdata(dev);
 
 	spin_lock(&ch_index_lock);
-	idr_remove(&ch_index_idr, ch->minor);
+	idr_replace(&ch_index_idr, NULL, ch->minor);
 	dev_set_drvdata(dev, NULL);
 	spin_unlock(&ch_index_lock);
 
 	device_destroy(&ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR, ch->minor));
+
+	spin_lock(&ch_index_lock);
+	idr_remove(&ch_index_idr, ch->minor);
+	spin_unlock(&ch_index_lock);
 	scsi_device_put(ch->device);
 	kref_put(&ch->ref, ch_destroy);
 }

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

