Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182918;
	b=oZ8dQjnNNogk+LBTQv86+SYD8SR/FrfSu4vSUCCfOQpEfhNe0vj/lVbhXXV7Dvwh++hh
	 BGvfNc8/8QVx9pLZ1pizfQ7QJS1UCUew0D0dX5MR+auflzK5TfBAlq7zuRmT98I6x3uAT
	 bIAAKDh5q7LEB3cU1YV+S+i5yURRT/xssrJFeTW5jmFYajsF/A/sQ+5t0kN73ll3SSif1
	 PBiomZj5VA+LK/t60UIOOgLGeM+XqBx+E46u6j4dVcWDVzuPWr62MaL7nF5+hASKidyDB
	 09l10qwdssImh/rEGOaZCqaMP0umz0KMX70WDsYniYs8Oy215qv8Uv2jc7C2IHfP3xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=FH7Ei2gpGYo/m3TodoKUi5ug60pqHLusd8JZhBhloIA=;
	b=ovcUrCUYv3gEdxTQ0VKz/h36n/aUU1AWrywBex5ajW3KvdzOQvL3FDLKnUdB57teN2p1
	 ZFO9XMw7WOlDKx7ssLc+a0yzoHUlBhQSzE46GqBhzZWvGWAXNUd8MBGhH1UNVkMU27dSE
	 mq0UPkdYuMpuzQGVeiqsqaVawV2r1lHczo7odlWTsfGKtqkNyZcZsYZN4u4phZWFIDGZM
	 kh0/k0NYlu5uDXppADZsWhwt+dFdcS+TJZXyrWlSJhDtfVcxwWv3U+bTxW2NzSLBpm1fD
	 XN8XOTR8GNKBOhSYm6f0QrwhJmupNhCVPvY4fn8/aP+w4HwzAN+QI21EMkYAnxifLtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kbMn+RgE;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C64606A321
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:08:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67C64606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kbMn+RgE
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48dc1508191so8448f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794182916; x=1794787716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FH7Ei2gpGYo/m3TodoKUi5ug60pqHLusd8JZhBhloIA=;
        b=kbMn+RgErprAqYnr1G1P+cdJ0h57aUAXRfwqvhmLlJlcDTR5m+xPrRUEDY8CUtatnI
         9nK1xUbMGanhD4xik3DI6An5otcLWFMeSdQ4etR5m1a4dL2dwBxlrdOp1GHMkkFuIkmL
         ESZUbeFPlK62/4x9UO5G0SWHX3ihD6V9/W1wTUrY3tJ8KGv5hKxkVDoEBPWkEy6t+Wcu
         330Sg1jGtjgynM/FmNfecG87qAMl6/DPler/XEmBgK0HmdfMHovE+gTHeQE4xl87H8TS
         XjkSNC3jbH1eRy+wGpnc0Umrtu5zUWQP5sY627TR21U7bfjJYDUgeQ7CbsYIM+b/0DvA
         dMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794182916; x=1794787716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FH7Ei2gpGYo/m3TodoKUi5ug60pqHLusd8JZhBhloIA=;
        b=BSQ6cntmogra+ubXAI5sgzy652tTiL2CbboJdMYhcr3YE3wKlCDoTVJmuJrWtTJ+14
         5V5GlR0hOR94W6aNhzJJBlla0meP/6nRZXNCdacCbNA9wDlBaZlnDfyM756GVQAecpXD
         NjNOK1eIKqPpDIG3yaWn+DqsasVRlp4Por0NOtL8cjnhs1gw3EJwY9GhGNrzfqGHZBy9
         GuIyXU9PJxysMAzkGFvVDMZMhxXNWXXqVfYSu98q3pKB2s1prcZ49ctilRlV1ZKSQy9p
         Hd3N5r1Oqg8gRkmCjU7IotHIo0D8z5+FtFrcz8+UYbe2JzpEP26OeuXyVJXmdclFE2Ht
         3Nag==
X-Forwarded-Encrypted: i=1; AL+hErGuuB9Lt9Tjccw951iI9yr6QoeKncZzHmUU4eZNAT7YC188izsnyXPJv13pygsLth45lEgH8mH/rMKx@vger.kernel.org
X-Gm-Message-State: APuU4Z/cuHfaHi4d/TBzb8dInIL5Es3lOmdJHdeBHe18eukmwRjVfxGD
	c4Knl6xIHs8j4HWaPR7yI85O3jCcoiLpecpzBBKTMSitpvQh1Txn/8g=
X-Gm-Gg: AYBFou1adn72J+/SriGZz8/cp30T85rcI9R0udulKLTM9pRJfGDg9M+uoUyBlAjxZhw
	cRcbrUmxVAxDH08ihMhvaThRzHqc6CmFglJPWvz3c2YL4s+fZNatRcO7alnbReIVAqBDwSyZCKQ
	0tNbrKMzW/tnz/N95yKOnimvpbPXOzKf4mIx3oL4sagVosyvVJAF6tN9LlT6CEQ8rc9sAYOLEAF
	1tmzbeT4AEYH/XcGnGsCY7Drp0Vb31ZCZ+fAfnCtk7XDcO3inZiqI2TbCpgqvujh1cXSpUuoyS3
	tzOPcqadHxaQP1LLhe6b4IIdHQYXYioPGl3Y/RaZfyFlavLABisXoYNBvvsLCds0N4kDhVUwu+T
	jp26ID+VCV2wcHMaxwo9U2WNRq2hFc+bAaMSbmkiakyN8u355dj0Hc99dBwGeHlaUAAzhNh+ZSd
	5WUKsNzEZ5JiUQuVO0z6o2Le85QklbAenxsdYtU37915OP/Sw205IOh52EiF8ZmQyEoR2cgNl4t
	wZOjbBGcY/g6f+WZubUQ//5knFWw+dbxm2ASUBoxgOoe0quoIlqCb5kwqLhtULjBstdG9CeiI0W
	HE4AkHNWVDan4NBW6cUhbD+JNkp4LBf5prTTnHt/ptcoXRF2POatzxdCSUKdEj/l3Q==
X-Received: by 2002:a05:6000:2888:b0:48a:f5c5:d077 with SMTP id ffacd0b85a97d-49580eea5b6mr6921767f8f.2.1794182915678;
        Sun, 08 Nov 2026 16:08:35 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-495974660cfsm6755903f8f.38.2026.11.08.16.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:08:35 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	John Garry <john.garry@linux.dev>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Martin George <marting@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Randy Jennings <randyj@purestorage.com>,
	Jyoti Rani <jrani@purestorage.com>,
	Brian Bunker <brian@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Marco Patalano <mpatalan@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] nvme-cli: nvmf-autoconnect: Consolidate vendor-specific NVMe-oF udev rules into a single file
Date: Mon,  9 Nov 2026 01:08:33 +0100
Message-ID: <20261109000834.513230-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Replace individual vendor udev rules (HPE, NetApp, and VAST Data) with
a unified 80-nvmf-storage_arrays.rules file, leaving the rules untouched.

This shifts execution to the 80 range for a logical sequence after base
discovery and autoconnect, while simplifying maintenance and packaging.

Cc: John Garry <john.garry@linux.dev>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Guixin Liu <kanie@linux.alibaba.com>
Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin George <marting@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Randy Jennings <randyj@purestorage.com>
Cc: Jyoti Rani <jrani@purestorage.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marco Patalano <mpatalan@redhat.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: John Meneghini <jmeneghi@redhat.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
BTW, there are two new I/O policies in development:
https://lore.kernel.org/linux-nvme/20260815173502.1185929-1-nilay@linux.ibm.com/
https://lore.kernel.org/linux-nvme/20261026111019.3724465-1-kanie@linux.alibaba.com/
---
 meson.build                                   |  4 +---
 nvme.spec.in                                  |  4 +---
 .../udev-rules/71-nvmf-hpe.rules.in           |  5 ----
 .../udev-rules/71-nvmf-netapp.rules.in        |  6 -----
 .../udev-rules/71-nvmf-vastdata.rules.in      |  5 ----
 .../80-nvmf-storage_arrays.rules.in           | 23 +++++++++++++++++++
 6 files changed, 25 insertions(+), 22 deletions(-)
 delete mode 100644 nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in
 delete mode 100644 nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
 delete mode 100644 nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in
 create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in

diff --git a/meson.build b/meson.build
index 90356ad94..00e9ad1be 100644
--- a/meson.build
+++ b/meson.build
@@ -894,9 +894,7 @@ if want_nvme
     udev_files = {
         '65-persistent-net-nbft.rules': 'nvmf',
         '70-nvmf-keys.rules':           'nvmf-autoconnect',
-        '71-nvmf-hpe.rules':            'nvmf',
-        '71-nvmf-netapp.rules':         'nvmf',
-        '71-nvmf-vastdata.rules':       'nvmf',
+        '80-nvmf-storage_arrays.rules': 'nvmf',
     }
     if want_nvmf_autoconnect
         udev_files += {'70-nvmf-autoconnect.rules': 'nvmf-autoconnect'}
diff --git a/nvme.spec.in b/nvme.spec.in
index 23d3d3268..a37c1a08d 100644
--- a/nvme.spec.in
+++ b/nvme.spec.in
@@ -36,9 +36,7 @@ touch %{buildroot}@SYSCONFDIR@/nvme/hostid
 @UDEVRULESDIR@/65-persistent-net-nbft.rules
 @UDEVRULESDIR@/70-nvmf-autoconnect.rules
 @UDEVRULESDIR@/70-nvmf-keys.rules
-@UDEVRULESDIR@/71-nvmf-hpe.rules
-@UDEVRULESDIR@/71-nvmf-netapp.rules
-@UDEVRULESDIR@/71-nvmf-vastdata.rules
+@UDEVRULESDIR@/80-nvmf-storage_arrays.rules
 @DRACUTRULESDIR@/70-nvmf-autoconnect.conf
 @SYSTEMDDIR@/nvmf-connect@.service
 @SYSTEMDDIR@/nvmefc-boot-connections.service
diff --git a/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in b/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in
deleted file mode 100644
index b050dd502..000000000
--- a/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in
+++ /dev/null
@@ -1,5 +0,0 @@
-# Set appropriate iopolicy for HPE Alletra Storage MP
-ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="HPE Alletra", ATTR{iopolicy}="round-robin"
-
-# Set ctrl_loss_tmo to -1 for HPE Alletra Storage MP NVMe/TCP
-ACTION!="remove", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{transport}=="tcp", ATTR{model}=="HPE Alletra", ATTR{ctrl_loss_tmo}="-1"
diff --git a/nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in b/nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
deleted file mode 100644
index c76a3c434..000000000
--- a/nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
+++ /dev/null
@@ -1,6 +0,0 @@
-# Set appropriate iopolicy for NetApp ONTAP and NetApp E-Series
-ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="NetApp ONTAP Controller", ATTR{iopolicy}="queue-depth"
-ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="NetApp E-Series", ATTR{iopolicy}="round-robin"
-
-# Set ctrl_loss_tmo to -1 for NetApp ONTAP NVMe/TCP
-ACTION!="remove", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{transport}=="tcp", ATTR{model}=="NetApp ONTAP Controller", ATTR{ctrl_loss_tmo}="-1"
diff --git a/nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in b/nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in
deleted file mode 100644
index dcd6146d8..000000000
--- a/nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in
+++ /dev/null
@@ -1,5 +0,0 @@
-# Enable round-robin for Vast Data Block Subsystem
-ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="VASTData", ATTR{iopolicy}="round-robin"
-
-# Set ctrl_loss_tmo to -1 for Vast Data Block Controller
-ACTION!="remove", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{model}=="VASTData", ATTR{ctrl_loss_tmo}="-1"
diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
new file mode 100644
index 000000000..1cd6c0c0b
--- /dev/null
+++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
@@ -0,0 +1,23 @@
+##### Storage arrays
+
+#### Set iopolicy for NVMe-oF
+### iopolicy: numa (default), round-robin (>=5.1), or queue-depth (>=6.11)
+
+## HPE
+# Alletra 9000 / Alletra Storage MP / GreenLake Block Storage MP
+ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="HPE Alletra", ATTR{iopolicy}="round-robin"
+ACTION!="remove", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{transport}=="tcp", ATTR{model}=="HPE Alletra", ATTR{ctrl_loss_tmo}="-1"
+
+## NetApp
+# ONTAP AFF/ASA Series
+ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="NetApp ONTAP Controller", ATTR{iopolicy}="queue-depth"
+ACTION!="remove", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{transport}=="tcp", ATTR{model}=="NetApp ONTAP Controller", ATTR{ctrl_loss_tmo}="-1"
+# E/EF-Series
+ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="NetApp E-Series", ATTR{iopolicy}="round-robin"
+
+## VAST Data
+# Block Subsystem
+ACTION=="add", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{model}=="VASTData", ATTR{iopolicy}="round-robin"
+ACTION!="remove", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{model}=="VASTData", ATTR{ctrl_loss_tmo}="-1"
+
+##### EOF
-- 
2.56.0

