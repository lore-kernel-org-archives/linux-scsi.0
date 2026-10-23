Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.130.202.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792730375;
	b=YKBtDiiQWkrQcgLIMbT7NuY6QEr0uUIMw8LPdA+XvYahefjT7dIjn0bANex+BszRtBUb
	 zZKRuOlJ3zX6yqaF2VWZ57GN4pvLdfRiOx6ZuKTuhF+Y+z8LxioG14l19zvPwt5LaFb9s
	 kUWhIVpRbrH4Fft+BzXB0MxhbgKldPgPATaHtlbrTExl3N5tNPn7KJyBW9R8xo9SnvXcX
	 UcWG0AMCyKBTB4/2UeYfO6uAS57xHnm/tfzzdxGo+PHis98aDUGAKqzA+p+sxnUj4Yndg
	 Rjy7TUVtuJwCeuC5lIKJHtbEbVy/H1Fl1236WFIj6ouDdAClOqHvPyRryyhzi4dbUSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792730375;
	h=DMARC-Filter:DKIM-Signature:Received:X-Iguazu-Qid:X-Iguazu-QSIG:
	 Received:From:To:Cc:Subject:Date:X-TSB-HOP2:Message-Id:X-Mailer;
	bh=z1tYfu3ZKaPJUTpHE1RDxt7MpiCNNy7MOBzkxY5/95s=;
	b=j0j35tCGn3+AvEfNG8+kMkT9Je8OUYO94kQCLext6eKwvHvMN8Qa7jGNju1Z7N/pOV1P
	 ZtIeQUvbq0y3BdoAXC2skDZf/EVra/XDT5Sj+dXxuO6ENSbv1hoksF/0Y7TB4JW2NjQwv
	 5/jCk4d1Fzs9LYuc/ZzVQP5UXiOkwy8lLm2jL6nt0nmVYANkyVJv/jnoUPIE61vqXa6YJ
	 JFcWSDMWA+45999/RiKFUt6k85GN1D3Jwixr+5wGCZwzw6gf9tRbS/CM2RvKWKKsd1nnk
	 BbaC2rss3BCtuo7MtHgUurGfl05fvuEdf3L8ZWy329Ph9RyyC+pc0kMY2jG9SYjjFaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.toshiba;
	spf=pass smtp.mailfrom=mail.toshiba;
	dkim=pass header.d=mail.toshiba header.i=nobuhiro.iwamatsu.x90@mail.toshiba header.a=rsa-sha256 header.s=key2.smx header.b=bG0UQf9A;
	arc=none smtp.remote-ip=210.130.202.131
Received: from mo-csw.securemx.jp (mo-csw1120.securemx.jp [210.130.202.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802CF606A319;
	Fri, 23 Oct 2026 04:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 802CF606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mail.toshiba
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.toshiba
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mail.toshiba header.i=nobuhiro.iwamatsu.x90@mail.toshiba header.a=rsa-sha256 header.s=key2.smx header.b=bG0UQf9A
DKIM-Signature: v=1;a=rsa-sha256;c=relaxed/simple;d=mail.toshiba;h=From:To:Cc:
	Subject:Date:Message-Id;i=nobuhiro.iwamatsu.x90@mail.toshiba;s=key2.smx;t=
	1792730304;x=1793939904;bh=inuWj1O+TmzBSNZIxOCWiXPTEyygPVgpo7DzFNfmKss=;b=bG0
	UQf9A2/bFXEVoS/Ylj1KBgM4BEzd9mr9PvvEliZKr19gko7cfWmqW7fP0V8fbfVPZDzliZdauPWO6
	hGMdJ4TQ4byHauSJTGEmNgqNWdyGKwD/rLdZ4NYiuPB0AqItlHrAenkacabRo7s83u71Kx95Su57W
	PLa1Y1oh7uTucRLdDTQ7fEzLGN535yb/VR+ThLAk21qD51glRRbIE7XR1V5R31CbJq9ngspeR2TWD
	WzpnGB007bRFRJoq++4m05s6mSmdfL0QHbUHm3z+mWOLhzjaxN+kUAC2cJ0FOOwhwHjJfuvlNCqUS
	4c70lbW2ieyFbYOx3b1VrYT3crDyIeg==;
Received: by mo-csw.securemx.jp (mx-mo-csw1120) id 69N4cNad3468980; Fri, 23 Oct 2026 13:38:24 +0900
X-Iguazu-Qid: 2rWg7mGwshatov73wI
X-Iguazu-QSIG: v=2; s=1; t=1792730303; q=2rWg7mGwshatov73wI; m=VsWGoRGGV4/oZ+rcYh55YTbX1XTesilBy2UGdYAMXp0=
Received: from imx12-a.toshiba.co.jp (unknown [38.106.60.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	 id 4j9qyk6DCcz1xng; Fri, 23 Oct 2026 13:38:22 +0900 (JST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sashal@kernel.org,
        Daniil Stas <daniil.stas@posteo.net>,
        Guenter Roeck <linux@roeck-us.net>, Chris Healy <cphealy@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-hwmon@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Subject: [PATCH 5.10, 5.15, 6.1] hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur
Date: Fri, 23 Oct 2026 13:38:19 +0900
X-TSB-HOP2: ON
Message-Id: <1792730299-21490-1-git-send-email-nobuhiro.iwamatsu.x90@mail.toshiba>
X-Mailer: git-send-email 2.7.4
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

From: Daniil Stas <daniil.stas@posteo.net>

commit 82163d63ae7a4c36142cd252388737205bb7e4b9 upstream.

scsi_execute_cmd() function can return both negative (linux codes) and
positive (scsi_cmnd result field) error codes.

Currently the driver just passes error codes of scsi_execute_cmd() to
hwmon core, which is incorrect because hwmon only checks for negative
error codes. This leads to hwmon reporting uninitialized data to
userspace in case of SCSI errors (for example if the disk drive was
disconnected).

This patch checks scsi_execute_cmd() output and returns -EIO if it's
error code is positive.

Fixes: 5b46903d8bf37 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Signed-off-by: Daniil Stas <daniil.stas@posteo.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: linux-hwmon@vger.kernel.org
Link: https://lore.kernel.org/r/20250105213618.531691-1-daniil.stas@posteo.net
[groeck: Avoid inline variable declaration for portability]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
---
 drivers/hwmon/drivetemp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb6a..b3de637a3a1f29 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -165,6 +165,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 {
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	int data_dir;
+	int err;
 
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0] = ATA_16;
@@ -192,9 +193,12 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	err = scsi_execute_req(st->sdev, scsi_cmd, data_dir,
+			       st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
+			       NULL);
+	if (err > 0)
+		err = -EIO;
+	return err;
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.55.0


