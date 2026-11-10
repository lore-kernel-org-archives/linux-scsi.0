Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794298504;
	b=GLBy+fhfnb+hGRq6UEU3eKNRNrRijb0OahsL5GjPKr7X+RoIA/HF7PIqV+H5dvo8R4EH
	 SSU+p1ZFzcS8Xa2XvsuHmmjIclMcs2jyKZqlHqWSo+TjWQMX3n8eW6cSsweMFG6+/3kon
	 29FpOeOHGVFGn9QSZFmOLB8VyP9CvoeRzZn9V5qjtoDzKxp7SamY4qpKZuU/6HpEuqo+1
	 PygxbfpQFFFug4zrbNsHfKzzIubv6wpGiBPrOsbz0J+zGmo2n7VS+rIW3KsGMaqc01DXw
	 FTdX2SNDYjgJqvQYMQmHPiDUc6Wyq7u1I2phPre4wTunZRcuSpfyLFRXO7I4r76VLig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794298504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=pBaKP3tUEefVher8LLDxuQTEDE1HY5Rtx0YQVRsDCbE=;
	b=FXVtGoA5xr2mtC4C6rCRHQZslPKvZOj/4HmJAXQ16B4u1dpcFPkOM6D0FI61avd/ittl
	 zIsg57exdZ4baYQEaalWlzjvTP5P1beD1dNyJANchHeaYLkQlphBNCN+vd07AzHsWycVU
	 ozAPImljvZabWFjiDhzMgpAL8WA3JB1vBwUQmfMQweIwV+knmdDm02ey1TubSyvdgs+df
	 VxNQf+RQlF4gQGRMfFazCTiaWAc0SMmduSEdfhAtnp5pPzrPwqv4nOmqghDAJOa1Vm4Iz
	 Kyy54VlVSs71mOf+aepr/C8GFUD0eZNluVySycyUlKZSvRwdo4uNQKLQkiWDBol0XhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=areca.com.tw;
	spf=pass smtp.mailfrom=areca.com.tw;
	dkim=pass header.d=areca-com-tw.20260707.gappssmtp.com header.i=@areca-com-tw.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iRu5Rt3q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07721606A335
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 08:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07721606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=areca.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=areca.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20260707.gappssmtp.com header.i=@areca-com-tw.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iRu5Rt3q
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4395d31228so230262966b.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 00:15:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794298500; cv=none;
        d=google.com; s=arc-20260327;
        b=LX+bQ6bBRMTn/5zZytYjgu5QSUJhVi7fLOjYkyQnQm8PQl+8KKEKw7bJgCmpvKlSSj
         s0JOkbTLrACcVGdeoJxTwgoo+ks9Q70ehTBVWLz8oNMgRZPvZtvv97nRUSkyd8FWL82E
         +nM415SWM/hT/Fgl+/LSeGqq8jRbQvxnwqhIf0QXEn1jypjWieLhHdCO0Fdr2C8a4doj
         JgdT0aXgiNwD89v3HRHRpJr7mTdiQxKZ0181451mYqyNNLkvZmye/MsW22JN97TLlevu
         BuxZqYiQ7YfmePy3a9MFCJ2eG88xnM/ALdPnn7knQdkjopmfH0H2qBxwHyXYR2ZOmdOP
         X1bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=pBaKP3tUEefVher8LLDxuQTEDE1HY5Rtx0YQVRsDCbE=;
        fh=NE4VvwrwWgyzT/kfPXkbor4nrGXnPdDHgH1DB6d7U5Q=;
        b=BEDOozAgd8BXFfKH2xiBmvGiuC0veHxP2OKL3da8O2erhrk0rQVhSaYQ6IPvQnQzRh
         UmNMBI7xhntR3H9yZDrP5YdVuX1azadrqY/RArQGZXuBTo7OD/33NAKRXmTILMZQ45ij
         MHFB3+7nK8bVHjT21iMfwjdPVt8PW72FPeYWKcQsPkiiiJc97dBH55SZxBvzoN85uAmf
         A+QHe8V+xK6TR+ULgqwBKF27d/4nf0Bnj34H3x++UjKfcHKav5cg9ttwKMZyC5+cBWN7
         dFI5WnYnNVM2mLl0of6FEWpbOEcixvSmyFPjXJOsSxtQP8MT3OfvgHmy7CbH+Dd8WbiI
         VayA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20260707.gappssmtp.com; s=20260707; t=1794298500; x=1794903300; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pBaKP3tUEefVher8LLDxuQTEDE1HY5Rtx0YQVRsDCbE=;
        b=iRu5Rt3q1vFoV7DMX+hEC80r25Osbirzhs/tEgk+7F7WIlYm60V1MZyGhQqcnxiMhz
         m8kIzt3CciHwrtR96JOQmSXRkJ08EwLIn1X+gyudY2TZg5zWVHBiD+ahXv70rq3wlx2H
         5GHGjHY4jPSP5TbMISfL4jnGsVZcLVeIYn3t2BkN4kYQna7q+S9zY/ywfF6mWMLo8lcs
         U3mFKffXiQy+cvlhaZDLnl9o1ZJfhbt2iL7mJzDLmS1BestvEJDwfcY7nRGvvInUwfBo
         Pr+NN2HFRXOV8q12GaED8orjP0BxjcCfZhVfWgQcTSWkDgLY73nRBRMG60p0gZhkb8gk
         TREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794298500; x=1794903300;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pBaKP3tUEefVher8LLDxuQTEDE1HY5Rtx0YQVRsDCbE=;
        b=G3lEXsnneZ2FOq1T6s8DuWqUbwDtM3VDByPbuASfd1H9c9N3lS8fw/Wt46ZL8FL9NN
         VL/4UKTL7xycafpEKRu4+46gOfjZh7NjyVbrAhdi8p5oluEwocdKSXIr71pQteE6Tb9Z
         h2qDYxOVxbeRl+pc5pfAAQ/n0mAIo/LPprPcctmQFLOUbmITxlOvgCqrC/t7u7jWHE1W
         cMOu65FZLP8071WSjPeeZV1WuOcYN8vkDaefscP5t0dxjHnmy1IDbRTBgveWAT4baC/G
         tV9u72NDU6HCwMgAbgyzmFfeuEDMiAipcH9NN3k7ZInCyHNDFc1PGy+hhm14ZGf3Ksxd
         EWzQ==
X-Forwarded-Encrypted: i=1; AL+hErEVu4X8bD/rraKdKaIsJggOdh6+/AM1mZOcL+Z646UuGbYGuj9uinEWryu8WD8d3J5MhXfwKK48EB05@vger.kernel.org
X-Gm-Message-State: APuU4Z9QnBJ6fWft/VlTARp3TEntbm59awoX2sVD1qqEPGg/s0FfoG23
	I12hB4Hf/LVFEGZ/rfJoWatzGELWViJDFk7l/CImJr860bn7V8R5k6+74aca23V0lEOzRZDmRHk
	zp2mr+naK3LnIpkD9RQOp0tYdnSPvim74x5JXdgHzc2H8aD3RsfMZp9unqaDd
X-Gm-Gg: AYBFou1frGCeLTo4f1XB2XmfYdFQchv102YUAVUiEG0F6hxQOtAvsktx4frZHiHQFHs
	KX1Ord3J0dnZxnmDbmwuowrbdHdG5fQ7oTJ8pXVYROEdaEx+NzI6dCQpJWK81l49iksG06sZPgL
	Vu1xSeuiQPwP1Lgxeam0kkibXhCvQaPI1KP/iLG9Hr2Gq7Wqnx1fD/8jUmSD4otuSlPPEUZr+78
	53OHIGl7Iy9Zp/JEgpM183zxU03/R622XK2P/yqaZsk0pXfJ2KFRIf7qVfWOmQGMe0/yRGjCoUD
	lBK9cF4e0mCnfDSsMxJDVGXNDCZuC6k1AOU9ScBhqaSWJTH/THK4AjQBfauB1Y/xlLSyczg60gr
	iRFtzQ0WNAu74evtXMtINC/CTZHGDTmDpBAC2
X-Received: by 2002:a17:907:3d0d:b0:c50:52b5:e17 with SMTP id
 a640c23a62f3a-c5052b51cb7mr71270866b.13.1794298499381; Tue, 10 Nov 2026
 00:14:59 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?6Zmz6Iux6Lyd?= <erich@areca.com.tw>
Date: Tue, 10 Nov 2026 16:14:44 +0800
X-Gm-Features: AclHuK9ZZYhYwUuCEEvEuMMNINgO37e_i3JUPQdqU9R082yOuKVO0T7c8ALvmL8
Message-ID: <CAJLrZMWK=hMYsQucDA1RGk+6oPm44Nmo63q_VHnLH6KKx0d=UA@mail.gmail.com>
Subject: [PATCH] drivers: scsi: arcmsr: add path of direct io command for SMR
 Hard Disk and Tape Drive
To: Subsystem Maintainer <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Erich Chen <erich@areca.com.tw>
---
Changes in this version:
- Add direct I/O command paths for certain special SCSI devices that
do not require cache memory..
-
diff -Naurp a/drivers/scsi/arcmsr/arcmsr_attr.c
b/drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c 2026-10-30 20:09:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2026-11-09 16:32:45.424662257 +0800
@@ -2,10 +2,10 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_attr.c
-**        BY    : Nick Cheng
+**   Maintainer : Erich Chen
 **   Description: attributes exported to sysfs and device host
 *******************************************************************************
-** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
+** Copyright (C) 2002 - 2026, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -66,7 +66,8 @@ static ssize_t arcmsr_sysfs_iop_message_
 {
  struct device *dev = container_of(kobj,struct device,kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
+ host->hostdata;
  uint8_t *ptmpQbuffer;
  int32_t allxfer_len = 0;
  unsigned long flags;
@@ -80,7 +81,8 @@ static ssize_t arcmsr_sysfs_iop_message_
  if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
  unsigned int tail = acb->rqbuf_getIndex;
  unsigned int head = acb->rqbuf_putIndex;
- unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail, ARCMSR_MAX_QBUFFER);
+ unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail,
+  ARCMSR_MAX_QBUFFER);

  allxfer_len = CIRC_CNT(head, tail, ARCMSR_MAX_QBUFFER);
  if (allxfer_len > ARCMSR_API_DATA_BUFLEN)
@@ -90,9 +92,11 @@ static ssize_t arcmsr_sysfs_iop_message_
  memcpy(ptmpQbuffer, acb->rqbuffer + tail, allxfer_len);
  else {
  memcpy(ptmpQbuffer, acb->rqbuffer + tail, cnt_to_end);
- memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer, allxfer_len - cnt_to_end);
+ memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer,
+   allxfer_len - cnt_to_end);
  }
- acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len) %
ARCMSR_MAX_QBUFFER;
+ acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len)
+ % ARCMSR_MAX_QBUFFER;
  }
  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
  struct QBUFFER __iomem *prbuffer;
@@ -113,7 +117,8 @@ static ssize_t arcmsr_sysfs_iop_message_
 {
  struct device *dev = container_of(kobj,struct device,kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
+ host->hostdata;
  int32_t user_len, cnt2end;
  uint8_t *pQbuffer, *ptmpuserbuffer;
  unsigned long flags;
@@ -161,7 +166,8 @@ static ssize_t arcmsr_sysfs_iop_message_
 {
  struct device *dev = container_of(kobj,struct device,kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
+ host->hostdata;
  uint8_t *pQbuffer;
  unsigned long flags;

@@ -220,26 +226,31 @@ int arcmsr_alloc_sysfs_attr(struct Adapt
  struct Scsi_Host *host = acb->host;
  int error;

- error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_read_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_read_attr);
  if (error) {
  printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");
  goto error_bin_file_message_read;
  }
- error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_write_attr);
  if (error) {
  printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");
  goto error_bin_file_message_write;
  }
- error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_clear_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_clear_attr);
  if (error) {
  printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");
  goto error_bin_file_message_clear;
  }
  return 0;
 error_bin_file_message_clear:
- sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_write_attr);
 error_bin_file_message_write:
- sysfs_remove_bin_file(&host->shost_dev.kobj, &arcmsr_sysfs_message_read_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_read_attr);
 error_bin_file_message_read:
  return error;
 }
@@ -248,9 +259,12 @@ void arcmsr_free_sysfs_attr(struct Adapt
 {
  struct Scsi_Host *host = acb->host;

- sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_clear_attr);
- sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
- sysfs_remove_bin_file(&host->shost_dev.kobj, &arcmsr_sysfs_message_read_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_clear_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_write_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_read_attr);
 }


@@ -376,16 +390,26 @@ arcmsr_attr_host_fw_hd_channels(struct d
  acb->firm_hd_channels);
 }

-static DEVICE_ATTR(host_driver_version, S_IRUGO,
arcmsr_attr_host_driver_version, NULL);
-static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO,
arcmsr_attr_host_driver_posted_cmd, NULL);
-static DEVICE_ATTR(host_driver_reset, S_IRUGO,
arcmsr_attr_host_driver_reset, NULL);
-static DEVICE_ATTR(host_driver_abort, S_IRUGO,
arcmsr_attr_host_driver_abort, NULL);
-static DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, NULL);
-static DEVICE_ATTR(host_fw_version, S_IRUGO,
arcmsr_attr_host_fw_version, NULL);
-static DEVICE_ATTR(host_fw_request_len, S_IRUGO,
arcmsr_attr_host_fw_request_len, NULL);
-static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO,
arcmsr_attr_host_fw_numbers_queue, NULL);
-static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO,
arcmsr_attr_host_fw_sdram_size, NULL);
-static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO,
arcmsr_attr_host_fw_hd_channels, NULL);
+static DEVICE_ATTR(host_driver_version, S_IRUGO,
+   arcmsr_attr_host_driver_version, NULL);
+static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO,
+   arcmsr_attr_host_driver_posted_cmd, NULL);
+static DEVICE_ATTR(host_driver_reset, S_IRUGO,
+   arcmsr_attr_host_driver_reset, NULL);
+static DEVICE_ATTR(host_driver_abort, S_IRUGO,
+   arcmsr_attr_host_driver_abort, NULL);
+static DEVICE_ATTR(host_fw_model, S_IRUGO,
+   arcmsr_attr_host_fw_model, NULL);
+static DEVICE_ATTR(host_fw_version, S_IRUGO,
+   arcmsr_attr_host_fw_version, NULL);
+static DEVICE_ATTR(host_fw_request_len, S_IRUGO,
+   arcmsr_attr_host_fw_request_len, NULL);
+static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO,
+   arcmsr_attr_host_fw_numbers_queue, NULL);
+static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO,
+   arcmsr_attr_host_fw_sdram_size, NULL);
+static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO,
+   arcmsr_attr_host_fw_hd_channels, NULL);

 static struct attribute *arcmsr_host_attrs[] = {
  &dev_attr_host_driver_version.attr,
diff -Naurp a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h 2026-10-30 20:09:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h 2026-11-09 16:31:18.044628048 +0800
@@ -2,11 +2,10 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr.h
-**        BY    : Nick Cheng
-**   Description: SCSI RAID Device Driver for
-**                ARECA RAID Host adapter
+**   Maintainer : Erich Chen
+**   Description: SCSI RAID Device Driver for Areca RAID Controller
 *******************************************************************************
-** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved.
+** Copyright (C) 2002 - 2026, Areca Technology Corporation All rights reserved.
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -50,13 +49,16 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD 1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD 128
 #define ARCMSR_MIN_OUTSTANDING_CMD 32
-#define ARCMSR_DRIVER_VERSION "v1.51.00.14-20230915"
+#define ARCMSR_DRIVER_VERSION "v1.53.00.00-20261115"
 #define ARCMSR_SCSI_INITIATOR_ID 255
 #define ARCMSR_MAX_XFER_SECTORS 512
 #define ARCMSR_MAX_XFER_SECTORS_B 4096
 #define ARCMSR_MAX_XFER_SECTORS_C 304
-#define ARCMSR_MAX_TARGETID 17
+#define ARCMSR_MAX_TARGETID 129
+#define ARCMSR_VIRTUAL_DEVICE_ID (ARCMSR_MAX_TARGETID - 1)
 #define ARCMSR_MAX_TARGETLUN 8
+#define ARCMSR_TARGETID_MAP ((ARCMSR_MAX_TARGETID >> 3) + 1)
+#define ARCMSR_TARGETLUN_MAP (ARCMSR_MAX_TARGETLUN << 3)
 #define ARCMSR_MAX_CMD_PERLUN 128
 #define ARCMSR_DEFAULT_CMD_PERLUN 32
 #define ARCMSR_MIN_CMD_PERLUN 1
@@ -90,9 +92,9 @@ struct device_attribute;
 #define ARCMSR_MINUTES (1000 * 60 * 60)
 #define ARCMSR_DEFAULT_TIMEOUT 90
 /*
-**********************************************************************************
+*******************************************************************************
 **
-**********************************************************************************
+*******************************************************************************
 */
 #define ARC_SUCCESS 0
 #define ARC_FAILURE 1
@@ -212,7 +214,7 @@ struct FIRMWARE_INFO
  char model[8]; /*15, 60-67*/
  char firmware_ver[16];     /*17, 68-83*/
  char device_map[16]; /*21, 84-99*/
- uint32_t cfgVersion; /*25,100-103 Added for checking of new firmware
capability*/
+ uint32_t cfgVersion;
  uint8_t cfgSerial[16]; /*26,104-119*/
  uint32_t cfgPicStatus; /*30,120-123*/
 };
@@ -321,16 +323,13 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBC_ISR_THROTTLING_LEVEL 12
 #define ARCMSR_HBC_ISR_MAX_DONE_QUEUE 20
 /* Host Interrupt Mask */
-#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK 0x00000001 /* When clear, the
Utility_A interrupt routes to the host.*/
-#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK 0x00000004 /* When
clear, the General Outbound Doorbell interrupt routes to the host.*/
-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK 0x00000008 /* When
clear, the Outbound Post List FIFO Not Empty interrupt routes to the
host.*/
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK 0x00000001
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK 0x00000004
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK 0x00000008
 #define ARCMSR_HBCMU_ALL_INTMASKENABLE 0x0000000D /* disable all ISR */
 /* Host Interrupt Status */
 #define ARCMSR_HBCMU_UTILITY_A_ISR 0x00000001
- /*
- ** Set when the Utility_A Interrupt bit is set in the Outbound
Doorbell Register.
- ** It clears by writing a 1 to the Utility_A bit in the Outbound
Doorbell Clear Register or through automatic clearing (if enabled).
- */
+
 #define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR 0x00000004
  /*
  ** Set if Outbound Doorbell register bits 30:1 have a non-zero
@@ -457,7 +456,427 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBFMU_DOORBELL_SYNC1 0x300
 #define ARCMSR_HBFMU_MESSAGE_FIRMWARE_OK 0x80000000
 #define ARCMSR_HBFMU_MESSAGE_NO_VOLUME_CHANGE 0x20000000
+#define ARCMSR_CDB_INQUIRY_EVPD        1
+#define SCSI_DASD 0x00   /* Direct-access Device */
+#define SCSI_SEQACESS 0x01   /* Sequential-access device */
+#define SCSI_PRINTER 0x02   /* Printer device */
+#define SCSI_PROCESSOR 0x03   /* Processor device */
+#define SCSI_WRITEONCE 0x04   /* Write-once device */
+#define SCSI_CDROM 0x05   /* CD-ROM device */
+#define SCSI_SCANNER 0x06   /* Scanner device */
+#define SCSI_OPTICAL 0x07   /* Optical memory device */
+#define SCSI_MEDCHGR 0x08   /* Medium changer device */
+#define SCSI_COMM 0x09   /* Communications device */
+#define SCSI_NODEV 0x1F   /* Unknown or no device type */
+#define SCSI_EXPANDER 0x20
+#define SCSI_PM 0x21
+#define SCSI_SES_DEVICE 0x22
+#define SCSI_UNKNOWN_DEV 0x7F   /* Unknown or no device type */
+#define ARCMSR_IOC_SCSI_RI_INVALID_FRAME             (0x00000002)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_GOOD     (0x00)
+#define ARCMSR_DIRECT_IO_SCSI_RI_MASK_REASONCODE     (0x000000FF)
+
+#define ARCMSR_DIRECT_IO_SCSI_STATE_AUTOSENSE_VALID          (0x01)
+#define ARCMSR_DIRECT_IO_SCSI_STATE_AUTOSENSE_FAILED         (0x02)
+#define ARCMSR_DIRECT_IO_SCSI_STATE_NO_SCSI_STATUS           (0x04)
+#define ARCMSR_DIRECT_IO_SCSI_STATE_TERMINATED               (0x08)
+#define ARCMSR_DIRECT_IO_SCSI_STATE_RESPONSE_INFO_VALID      (0x10)
+#define ARCMSR_DIRECT_IO_SCSI_STATE_QUEUE_TAG_REJECTED       (0x20)
+
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_SENSE_MASK              (0x03)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_SENSE_VALID             (0x00)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_SENSE_FAILED            (0x01)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_SENSE_BUFF_Q_EMPTY      (0x02)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_SENSE_NOT_AVAILABLE     (0x03)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_NO_SCSI_STATUS          (0x04)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_TERMINATED              (0x08)
+#define ARCMSR3_DIRECT_IO_SCSI_STATE_RESPONSE_DATA_VALID     (0x10)
+
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_SUCCESS                 (0x00)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_CHECK_CONDITION         (0x02)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_CONDITION_MET           (0x04)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_BUSY                    (0x08)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_INTERMEDIATE            (0x10)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_INTERMEDIATE_CONDMET    (0x14)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_RESERVATION_CONFLICT    (0x18)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_COMMAND_TERMINATED      (0x22)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_TASK_SET_FULL           (0x28)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_ACA_ACTIVE              (0x30)
+#define ARCMSR_DIRECT_IO_SCSI_STATUS_TASK_ABORTED     (0x40)
+
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_GOOD                   (0x00)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_CHECK_CONDITION        (0x02)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_CONDITION_MET          (0x04)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_BUSY                   (0x08)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_INTERMEDIATE           (0x10)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_INTERMEDIATE_CONDMET   (0x14)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_RESERVATION_CONFLICT   (0x18)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_COMMAND_TERMINATED     (0x22)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_TASK_SET_FULL          (0x28)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_ACA_ACTIVE             (0x30)
+#define ARCMSR3_DIRECT_IO_SCSI_STATUS_TASK_ABORTED           (0x40)
+
+/*
+***************************************************************************
+**  Common IOCStatus values for all replies
+***************************************************************************
+*/
+#define ARCMSR_DIRECT_IO_IOC_STATUS_MASK     (0x7FFF)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SUCCESS     (0x0000)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INVALID_FUNCTION     (0x0001)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_BUSY     (0x0002)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INVALID_SGL     (0x0003)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INTERNAL_ERROR     (0x0004)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INVALID_VPID     (0x0005)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INSUFFICIENT_RESOURCES   (0x0006)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INVALID_FIELD     (0x0007)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INVALID_STATE     (0x0008)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_OP_STATE_NOT_SUPPORTED   (0x0009)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_INSUFFICIENT_POWER     (0x000A)
+/*
+***************************************************************************
+*  Config IOCStatus values
+***************************************************************************
+*/
+#define ARCMSR_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_ACTION    (0x0020)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_TYPE     (0x0021)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_PAGE     (0x0022)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_DATA     (0x0023)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_CONFIG_NO_DEFAULTS     (0x0024)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_CONFIG_CANT_COMMIT     (0x0025)
+/*
+***************************************************************************
+*  SCSI IO Reply
+***************************************************************************
+*/
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_RECOVERED_ERROR (0x0040)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_INVALID_DEVHANDLE (0x0042)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DEVICE_NOT_THERE (0x0043)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DATA_OVERRUN         (0x0044)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DATA_UNDERRUN         (0x0045)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_IO_DATA_ERROR         (0x0046)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_PROTOCOL_ERROR         (0x0047)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_TASK_TERMINATED (0x0048)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_RESIDUAL_MISMATCH (0x0049)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_TASK_MGMT_FAILED (0x004A)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_IOC_TERMINATED         (0x004B)
+#define ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_EXT_TERMINATED         (0x004C)
+
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_LOG_INFO_AVAIL_MASK          (0x8000)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_LOG_INFO_AVAILABLE           (0x8000)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_STATUS_MASK                  (0x7fff)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SUCCESS                      (0x0000)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_FUNCTION             (0x0001)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_BUSY                         (0x0002)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_SGL                  (0x0003)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INTERNAL_ERROR               (0x0004)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INSUFFICIENT_RESOURCES       (0x0006)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_FIELD                (0x0007)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_STATE                (0x0008)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INSUFFICIENT_POWER           (0x000a)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_CHANGE_COUNT         (0x000b)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_FAILURE                      (0x001f)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_ACTION        (0x0020)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_TYPE          (0x0021)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_PAGE          (0x0022)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CONFIG_INVALID_DATA          (0x0023)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CONFIG_NO_DEFAULTS           (0x0024)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CONFIG_CANT_COMMIT           (0x0025)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_RECOVERED_ERROR         (0x0040)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_TM_NOT_SUPPORTED        (0x0041)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_INVALID_DEVHANDLE       (0x0042)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_DEVICE_NOT_THERE        (0x0043)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_DATA_OVERRUN            (0x0044)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_DATA_UNDERRUN           (0x0045)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_IO_DATA_ERROR           (0x0046)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_PROTOCOL_ERROR          (0x0047)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_TASK_TERMINATED         (0x0048)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_RESIDUAL_MISMATCH       (0x0049)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_TASK_MGMT_FAILED        (0x004a)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_IOC_TERMINATED          (0x004b)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SCSI_EXT_TERMINATED          (0x004c)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_EEDP_GUARD_ERROR             (0x004d)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_EEDP_REF_TAG_ERROR           (0x004e)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_EEDP_APP_TAG_ERROR           (0x004f)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_INVALID_IO_INDEX      (0x0062)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_ABORTED               (0x0063)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_NO_CONN_RETRYABLE     (0x0064)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_NO_CONNECTION         (0x0065)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_XFER_COUNT_MISMATCH   (0x006a)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_DATA_OFFSET_ERROR     (0x006d)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_TOO_MUCH_WRITE_DATA   (0x006e)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_IU_TOO_SHORT          (0x006f)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_ACK_NAK_TIMEOUT       (0x0070)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_TARGET_NAK_RECEIVED          (0x0071)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SAS_SMP_REQUEST_FAILED       (0x0090)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SAS_SMP_DATA_OVERRUN         (0x0091)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_DIAGNOSTIC_RELEASED          (0x00a0)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CI_UNSUPPORTED               (0x00b0)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CI_UPDATE_SEQUENCE           (0x00b1)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CI_VALIDATION_FAILED         (0x00b2)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_CI_UPDATE_PENDING            (0x00b3)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_SECURITY_KEY_REQUIRED        (0x00c0)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_QUEUE_ID             (0x0f00)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_QUEUE_SIZE           (0x0f01)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_MSIX_VECTOR          (0x0f02)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_REPLY_QUEUE_ID       (0x0f03)
+#define ARCMSR3_DIRECT_IO_IOC_STATUS_INVALID_QUEUE_DELETION       (0x0f04)
+
+struct REQUESTSENSES
+{
+ uint8_t ResponseCode;   /* 00 Response code 0x7A */
+ uint8_t SCSIStatus;   /* 01 scsi status        */
+ uint16_t IOCStatus;   /* 02                    */
+ uint32_t IOCLogInfo;   /* 04                    */
+ uint32_t TransferCount;   /* 08                    */
+ uint8_t SCSIState;   /* 0C scsi state         */
+ uint8_t MsgFlags;   /* 0D                    */
+ uint16_t StatusQualifier;   /* 0E                    */
+};           /* total 0x10            */
+typedef struct REQUESTSENSES   REQUESTSENSE_SAS;
+
+struct REQUESTSENSEN
+{
+ uint8_t ResponseCode;   /* 00 Response code 0x7B */
+ uint8_t Res00;   /* 01 scsi status        */
+ uint16_t IOCStatus;   /* 02                    */
+ uint32_t IOCLogInfo;   /* 04                    */
+ uint32_t nvmeRespDW0;   /* 08                    */
+ uint16_t nvmeRespStatus;   /* 0C                    */
+};           /* total 0x0E            */
+typedef struct REQUESTSENSEN   REQUESTSENSE_NVME;

+union _ARCMSR_U64
+{
+ struct {
+ u32 low;
+ u32 high;
+ } parts;
+ u64 value;
+};
+typedef union _ARCMSR_U64 ARCMSR_U64, *PARCMSR_U64;
+struct _ARCMSR_DIRECT_IO_IEEE_SGE_SIMPLE64
+{
+ ARCMSR_U64 Address;
+ uint32_t Length;
+ uint16_t Reserved1;
+ uint8_t Reserved2;
+ uint8_t Flags;
+};
+typedef  struct  _ARCMSR_DIRECT_IO_IEEE_SGE_SIMPLE64 \
+ARCMSR_DIRECT_IO_IEEE_SGE_SIMPLE64,*PARCMSR_DIRECT_IO_IEEE_SGE_SIMPLE64;
+struct _ARCMSR_DIRECT_IO_SCSI_IO_CDB_EEDP32
+{
+ uint8_t CDB[20];                        /* 0x00 */
+ uint32_t PrimaryReferenceTag;            /* 0x14 */
+ uint16_t PrimaryApplicationTag;          /* 0x18 */
+ uint16_t PrimaryApplicationTagMask;      /* 0x1A */
+ uint32_t TransferLength;                 /* 0x1C */
+};
+typedef  struct  _ARCMSR_DIRECT_IO_SCSI_IO_CDB_EEDP32 \
+ARCMSR_DIRECT_IO_SCSI_IO_CDB_EEDP32,*PARCMSR_DIRECT_IO_SCSI_IO_CDB_EEDP32;
+/*
+****************************************************************************
+**   ARCMSR_DIRECT_IO v2.5 CDB field
+****************************************************************************
+*/
+union _ARCMSR25_DIRECT_IO_SCSI_IO_CDB_UNION
+{
+ uint8_t CDB32[32];
+ ARCMSR_DIRECT_IO_SCSI_IO_CDB_EEDP32 EEDP32;
+ ARCMSR_DIRECT_IO_IEEE_SGE_SIMPLE64 SGE;
+};
+typedef  union   _ARCMSR25_DIRECT_IO_SCSI_IO_CDB_UNION \
+ARCMSR25_DIRECT_IO_SCSI_IO_CDB_UNION,*PARCMSR25_DIRECT_IO_SCSI_IO_CDB_UNION;
+/*
+***************************************************************************
+**  CHAIN SGE union for IO SGL's
+***************************************************************************
+*/
+union _ARCMSR25_DIRECT_IO_SGE_IO_UNION
+{
+ struct
+ {
+ ARCMSR_U64 Address;
+ uint32_t Length;
+ uint16_t Reserved1;
+ uint8_t Reserved2;
+ uint8_t Flags;
+ } IeeeSimple;
+ struct
+ {
+ ARCMSR_U64 Address;
+ uint32_t Length;
+ uint16_t Reserved1;
+ uint8_t NextChainOffset;
+ uint8_t Flags;
+ } IeeeChain;
+};
+typedef  union   _ARCMSR25_DIRECT_IO_SGE_IO_UNION \
+ARCMSR25_DIRECT_IO_SGE_IO_UNION,*PARCMSR25_DIRECT_IO_SGE_IO_UNION;
+/*
+****************************************************************************
+** ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64 is for ARCMSR_DIRECT_IO v2.5 and later
+****************************************************************************
+*/
+struct _ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64      /* 16 byte sg */
+{
+ ARCMSR_U64 Address;           /*00,01,02,03,04,05,06,07*/
+ uint32_t Length;            /*08,09,0A,0B*/
+ uint16_t Reserved1;         /*0C,0D*/
+ uint8_t NextChainOffset;   /*0E*/
+ uint8_t Flags;             /*0F*/
+};
+typedef  struct  _ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64 \
+ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64,*PARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64;
+
+#define ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_SIMPLE_ELEMENT (0x00)
+#define ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_CHAIN_ELEMENT (0x80)
+#define ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_SYSTEM_ADDR (0x00)
+#define ARCMSR25_DIRECT_IO_IEEE_SGE_FLAGS_END_OF_LIST (0x40)
+#define SIMPLE_SGL_FLAGS \
+(ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_SIMPLE_ELEMENT | \
+ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_SYSTEM_ADDR)
+#define SIMPLE_SGL_FLAGS_LAST \
+(SIMPLE_SGL_FLAGS | ARCMSR25_DIRECT_IO_IEEE_SGE_FLAGS_END_OF_LIST)
+#define CHAIN_SGL_FLAGS \
+(ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_CHAIN_ELEMENT | \
+ARCMSR_DIRECT_IO_IEEE_SGE_FLAGS_SYSTEM_ADDR)
+/*
+****************************************************************************
+**
+****************************************************************************
+*/
+struct _ARCMSR_DIRECT_IO
+{
+ uint8_t Bus; /* 0x00  should be 0 */
+ uint8_t TargetID; /* 0x01  should be 0--15 */
+ uint8_t LunID; /* 0x02  should be 0--07 */
+ uint8_t Function; /* 0x03 */
+#define DIRECT_IO_TAPE 0x80
+#define DIRECT_IO_DEVICE DIRECT_IO_TAPE
+
+ uint16_t Reserved1; /* 0x04 0x05 */
+ uint8_t Reserved2; /* 0x06 */
+ uint8_t MsgFlags; /* 0x07 */
+
+#define ARCMSR_DIRECT_IO_SCSIIO_MSGFLAGS_MASK_SENSE_ADDR (0x0C)
+#define ARCMSR_DIRECT_IO_SCSIIO_MSGFLAGS_SYSTEM_SENSE_ADDR (0x00)
+#define ARCMSR_DIRECT_IO_SCSIIO_MSGFLAGS_IOCDDR_SENSE_ADDR (0x04)
+#define ARCMSR_DIRECT_IO_SCSIIO_MSGFLAGS_IOCPLB_SENSE_ADDR (0x08)
+#define ARCMSR_DIRECT_IO_SCSIIO_MSGFLAGS_IOCPLBNTA_SENSE_ADDR (0x0C)
+#define ARCMSR26_DIRECT_IO_SCSIIO_MSGFLAGS_IOCCTL_SENSE_ADDR (0x08)
+
+ uint8_t VP_ID; /* 0x08 */
+ uint8_t VF_ID; /* 0x09 */
+
+ uint8_t ChainOffset;
+ uint8_t msgLen;
+ uint32_t SenseBufferPhyLowAddr;
+ uint8_t DMAFlags;
+
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_MASK (0x0F)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_D_D_D (0x00)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_D_D_C (0x01)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_D_D_I (0x02)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_D_C_C (0x03)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_D_C_I (0x04)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_D_I_I (0x05)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_C_C_C (0x06)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_C_C_I (0x07)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_C_I_I (0x08)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_I_I_I (0x09)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_H_D_D (0x0A)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_H_D_C (0x0B)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_H_D_I (0x0C)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_H_C_C (0x0D)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_H_C_I (0x0E)
+#define ARCMSR25_DIRECT_IO_SCSIIO_DMAFLAGS_OP_D_H_I_I (0x0F)
+
+ uint8_t Reserved5; /* 0x11 */
+
+ uint8_t SenseBufferLength;/* 0x12 */
+ uint8_t Reserved4; /* 0x13 */
+ uint8_t SGLOffset0; /* 0x14 */
+ uint8_t SGLOffset1; /* 0x15 */
+ uint8_t SGLOffset2; /* 0x16 */
+ uint8_t SGLOffset3; /* 0x17 */
+ /* number of SGLOffset fields */
+#define ARCMSR25_DIRECT_IO_SCSIIO_NUM_SGLOFFSETS         (4)
+
+ uint32_t SkipCount; /* 0x18 */
+ uint32_t DataLength; /* 0x1C */
+ uint32_t BidirectionalDataLength;/* 0x20 */
+ uint16_t IoFlags; /* 0x24 */
+ /* defines for the IoFlags field */
+#define ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_IO_PATH_MASK               (0xC000)
+#define ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_NORMAL_PATH               (0x0000)
+#define ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_FAST_PATH       (0x4000)
+#define ARCMSR26_DIRECT_IO_SCSIIO_IOFLAGS_ESCAPE_PASSTHROUGH       (0x2000)
+#define ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_LARGE_CDB       (0x1000)
+#define ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_BIDIRECTIONAL               (0x0800)
+#define ARCMSR26_DIRECT_IO_SCSIIO_IOFLAGS_PORT_REQUEST               (0x0400)
+#define ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_CDBLENGTH_MASK       (0x01FF)
+
+ uint16_t EEDPFlags; /* 0x26 */
+
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_ESCAPE_MODE_MASK       (0x00C0)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_COMPATIBLE_MODE       (0x0000)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_DO_NOT_DISABLE_MODE       (0x0040)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_APPTAG_DISABLE_MODE       (0x0080)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_APPTAG_REFTAG_DISABLE_MODE (0x00C0)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_HOST_GUARD_METHOD_MASK     (0x0030)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_T10_CRC_HOST_GUARD       (0x0000)
+#define ARCMSR25_DIRECT_IO_SCSIIO_EEDPFLAGS_IP_CHKSUM_HOST_GUARD       (0x0010)
+
+ uint16_t EEDPBlockSize; /* 0x28 */
+ uint16_t Reserved6; /* 0x2A */
+
+ uint32_t SecondaryReferenceTag; /* 0x2C */
+ uint16_t SecondaryApplicationTag; /* 0x30 */
+ uint16_t ApplicationTagTranslationMask; /* 0x32 */
+ uint8_t LUN[8]; /* 0x34 */
+#define ARCMSR_DIRECT_IO_LUN_FIRST_LEVEL_ADDRESSING (0x0000FFFF)
+#define ARCMSR_DIRECT_IO_LUN_SECOND_LEVEL_ADDRESSING (0xFFFF0000)
+#define ARCMSR_DIRECT_IO_LUN_THIRD_LEVEL_ADDRESSING (0x0000FFFF)
+#define ARCMSR_DIRECT_IO_LUN_FOURTH_LEVEL_ADDRESSING (0xFFFF0000)
+#define ARCMSR_DIRECT_IO_LUN_LEVEL_1_WORD (0xFF00)
+#define ARCMSR_DIRECT_IO_LUN_LEVEL_1_DWORD (0x0000FF00)
+
+ uint32_t Control; /* 0x3C */
+
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_ADDCDBLEN_MASK (0xFC000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_ADDCDBLEN_SHIFT (26)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_DATADIRECTION_MASK (0x03000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_SHIFT_DATADIRECTION (24)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_NODATATRANSFER (0x00000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_WRITE        (0x01000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_READ (0x02000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_BIDIRECTIONAL (0x03000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TASKPRI_MASK (0x00007800)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TASKPRI_SHIFT (11)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_CMDPRI_MASK (0x00007800)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_CMDPRI_SHIFT (11)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TASKATTRIBUTE_MASK (0x00000700)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_SIMPLEQ        (0x00000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_HEADOFQ        (0x00000100)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_ORDEREDQ (0x00000200)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_ACAQ (0x00000400)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TLR_MASK (0x000000C0)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_NO_TLR        (0x00000000)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TLR_ON (0x00000040)
+#define ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TLR_OFF (0x00000080)
+
+ ARCMSR25_DIRECT_IO_SCSI_IO_CDB_UNION CDB; /* 0x40 */
+
+#ifdef ARCMSR25_DIRECT_IO_SCSI_IO_VENDOR_UNIQUE_REGION
+ ARCMSR25_DIRECT_IO_SCSI_IO_VENDOR_UNIQUE VendorRegion;
+#endif
+
+ ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64 SGL0; /* 0x60 16bytes */
+ ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64 SGL1; /* 0x70 16bytes */
+};
+typedef  struct _ARCMSR_DIRECT_IO ARCMSR_DIRECT_IO,*PARCMSR_DIRECT_IO;
 /*
 *******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -483,13 +902,26 @@ struct ARCMSR_CDB
  uint32_t msgContext;
  uint32_t DataLength;
  uint8_t Cdb[16];
- uint8_t DeviceStatus;
-#define ARCMSR_DEV_CHECK_CONDITION    0x02
-#define ARCMSR_DEV_SELECT_TIMEOUT    0xF0
-#define ARCMSR_DEV_ABORTED    0xF1
-#define ARCMSR_DEV_INIT_FAIL    0xF2
-
- uint8_t SenseData[15];
+ union
+ {
+ struct
+ {
+ uint8_t DeviceStatus; /* 20h   if error */
+#define ARCMSR_DEV_CHECK_CONDITION       0x02
+#define ARCMSR_DEV_SAS_DIRECT_IO_ERROR   0x7A
+#define ARCMSR_DEV_NVME_DIRECT_IO_ERROR   0x7B
+#define ARCMSR_DEV_SELECT_TIMEOUT       0xF0
+#define ARCMSR_DEV_ABORTED           0xF1
+#define ARCMSR_DEV_INIT_FAIL       0xF2
+ uint8_t SenseData[15]; /* 21h   output    */
+ } status;
+ struct
+ {
+ uint8_t msgResEx[2]; /* 20h/21h reserved */
+ uint16_t sgcount; /* 22h/23h          */
+ uint32_t DataLength; /* 24h/25h/26h/27h  */
+ } cmd;
+ } u1;
  union
  {
  struct SG32ENTRY sg32entry[1];
@@ -498,7 +930,7 @@ struct ARCMSR_CDB
 };
 /*
 *******************************************************************************
-**     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A)
and Type B processor
+**
 *******************************************************************************
 */
 struct MessageUnit_A
@@ -935,7 +1367,7 @@ struct AdapterControlBlock
  /* first of write buffer */
  int32_t wqbuf_putIndex;
  /* last of write buffer  */
- uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
+ uint8_t devstate[ARCMSR_TARGETID_MAP][ARCMSR_TARGETLUN_MAP];
  /* id0 ..... id15, lun0...lun7 */
 #define ARECA_RAID_GONE 0x55
 #define ARECA_RAID_GOOD 0xaa
@@ -950,6 +1382,8 @@ struct AdapterControlBlock
  char firm_model[12];
  char firm_version[20];
  char device_map[20]; /*21,84-99*/
+ char direct_io_dev_map[20];
+ char tlr_dev_map[20];
  uint32_t firm_PicStatus;
  struct work_struct arcmsr_do_message_isr_bh;
  struct timer_list eternal_timer;
@@ -971,6 +1405,7 @@ struct AdapterControlBlock
  uint32_t completeQ_size;
  void *xorVirt;
  dma_addr_t xorPhys;
+ unsigned int sense_size;
  unsigned int init2cfg_size;
  unsigned int xorVirtOffset;
 };/* HW_DEVICE_EXTENSION */
@@ -981,33 +1416,44 @@ struct AdapterControlBlock
 *******************************************************************************
 */
 struct CommandControlBlock{
- /*x32:sizeof struct_CCB=(64+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
- struct list_head list; /*x32: 8byte, x64: 16byte*/
- struct scsi_cmnd *pcmd; /*8 bytes pointer of linux scsi command */
- struct AdapterControlBlock *acb; /*x32: 4byte, x64: 8byte*/
- unsigned long cdb_phyaddr; /*x32: 4byte, x64: 8byte*/
- uint32_t arc_cdb_size; /*x32:4byte,x64:4byte*/
- uint16_t ccb_flags; /*x32: 2byte, x64: 2byte*/
+ struct list_head list;
+ struct scsi_cmnd *pcmd;
+ struct AdapterControlBlock *acb;
+ unsigned long cdb_phyaddr;
+ uint32_t arc_cdb_size;
+ uint32_t ccb_flags;
 #define CCB_FLAG_READ 0x0000
 #define CCB_FLAG_WRITE 0x0001
 #define CCB_FLAG_ERROR 0x0002
 #define CCB_FLAG_FLUSHCACHE 0x0004
 #define CCB_FLAG_MASTER_ABORTED 0x0008
- uint16_t                        startdone; /*x32:2byte,x32:2byte*/
+#define CCB_FLAG_DIRECT_IO 0x0010
+#define CCB_FLAG_USE_SG 0x0020
+
+ uint32_t            startdone;
 #define ARCMSR_CCB_DONE 0x0000
 #define ARCMSR_CCB_START 0x55AA
 #define ARCMSR_CCB_ABORTED 0xAA55
 #define ARCMSR_CCB_ILLEGAL 0xFFFF
- uint32_t smid;
+ uint32_t smid;
+ uint8_t       *senseBuffer;
+ uint32_t        sensePhyAddr;
+ uint32_t        reserve0;
+ dma_addr_t        dma_handle;
 #if BITS_PER_LONG == 64
- /*  ======================512+64 bytes========================  */
- uint32_t reserved[3]; /*12 byte*/
+ /*  ====================== 72+24 bytes========================  */
+ uint32_t reserved[4]; /*16 byte*/
 #else
- /*  ======================512+32 bytes========================  */
- uint32_t reserved[8]; /*32  byte*/
+ /*  ====================== 48+16 bytes========================  */
+ uint32_t reserved[3]; /*12  byte*/
 #endif
- /*  =======================================================   */
- struct ARCMSR_CDB arcmsr_cdb;
+ /*  ==========================================================  */
+ /* This request address must be at 32 bytes boundary */
+ union
+ {
+ struct ARCMSR_CDB arcmsr_cdb;
+ ARCMSR_DIRECT_IO arcmsr_dio_cdb;
+ } iorb;
 };
 /*
 *******************************************************************************
@@ -1068,7 +1514,8 @@ extern void arcmsr_write_ioctldata2iop(s
 extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
  struct QBUFFER __iomem *);
 extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
-extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct
AdapterControlBlock *);
+extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer
+(struct AdapterControlBlock *);
 extern const struct attribute_group *arcmsr_host_groups[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
diff -Naurp a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c 2026-10-30 20:09:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c 2026-11-09 16:42:32.668912856 +0800
@@ -2,10 +2,10 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Nick Cheng, C.L. Huang
+**   Maintainer : Erich Chen
 **   Description: SCSI RAID Device Driver for Areca RAID Controller
 *******************************************************************************
-** Copyright (C) 2002 - 2014, Areca Technology Corporation All rights reserved
+** Copyright (C) 2002 - 2026, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -69,22 +69,25 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-MODULE_AUTHOR("Nick Cheng, C.L. Huang <support@areca.com.tw>");
-MODULE_DESCRIPTION("Areca ARC11xx/12xx/16xx/188x SAS/SATA RAID
Controller Driver");
+MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
+MODULE_DESCRIPTION("Areca SAS/SATA/NVMe(Tri-Mode) RAID Controller Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);

 static int msix_enable = 1;
 module_param(msix_enable, int, S_IRUGO);
-MODULE_PARM_DESC(msix_enable, "Enable MSI-X interrupt(0 ~ 1),
msix_enable=1(enable), =0(disable)");
+MODULE_PARM_DESC(msix_enable, "Enable MSI-X interrupt(0 ~ 1), \
+msix_enable=1(enable), =0(disable)");

 static int msi_enable = 1;
 module_param(msi_enable, int, S_IRUGO);
-MODULE_PARM_DESC(msi_enable, "Enable MSI interrupt(0 ~ 1),
msi_enable=1(enable), =0(disable)");
+MODULE_PARM_DESC(msi_enable, "Enable MSI interrupt(0 ~ 1), \
+msi_enable=1(enable), =0(disable)");

 static int host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
 module_param(host_can_queue, int, S_IRUGO);
-MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024),
default is 128");
+MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), \
+default is 128");

 static int cmd_per_lun = ARCMSR_DEFAULT_CMD_PERLUN;
 module_param(cmd_per_lun, int, S_IRUGO);
@@ -92,15 +95,18 @@ MODULE_PARM_DESC(cmd_per_lun, " device q

 static int dma_mask_64 = 0;
 module_param(dma_mask_64, int, S_IRUGO);
-MODULE_PARM_DESC(dma_mask_64, " set DMA mask to 64 bits(0 ~ 1),
dma_mask_64=1(64 bits), =0(32 bits)");
+MODULE_PARM_DESC(dma_mask_64, " set DMA mask to 64 bits(0 ~ 1), \
+dma_mask_64=1(64 bits), =0(32 bits)");

 static int set_date_time = 0;
 module_param(set_date_time, int, S_IRUGO);
-MODULE_PARM_DESC(set_date_time, " send date, time to iop(0 ~ 1),
set_date_time=1(enable), default(=0) is disable");
+MODULE_PARM_DESC(set_date_time, " send date, time to iop(0 ~ 1), \
+set_date_time=1(enable), default(=0) is disable");

 static int cmd_timeout = ARCMSR_DEFAULT_TIMEOUT;
 module_param(cmd_timeout, int, S_IRUGO);
-MODULE_PARM_DESC(cmd_timeout, " scsi cmd timeout(0 ~ 120 sec.),
default is 90");
+MODULE_PARM_DESC(cmd_timeout, " scsi cmd timeout(0 ~ 120 sec.), \
+default is 90");

 #define ARCMSR_SLEEPTIME 10
 #define ARCMSR_RETRYCOUNT 12
@@ -146,7 +152,8 @@ static void arcmsr_wait_firmware_ready(s
 static void arcmsr_set_iop_datetime(struct timer_list *);
 static int arcmsr_sdev_configure(struct scsi_device *sdev,
  struct queue_limits *lim);
-static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
int queue_depth)
+static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
+  int queue_depth)
 {
  if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
  queue_depth = ARCMSR_MAX_CMD_PERLUN;
@@ -156,7 +163,7 @@ static int arcmsr_adjust_disk_queue_dept
 static const struct scsi_host_template arcmsr_scsi_host_template = {
  .module = THIS_MODULE,
  .proc_name = ARCMSR_NAME,
- .name = "Areca SAS/SATA RAID driver",
+ .name = "Areca SAS/SATA/NVMe(Tri-Mode) RAID driver",
  .info = arcmsr_info,
  .queuecommand = arcmsr_queue_command,
  .eh_abort_handler = arcmsr_abort,
@@ -261,24 +268,30 @@ static bool arcmsr_remap_pciregion(struc
  struct pci_dev *pdev = acb->pdev;
  switch (acb->adapter_type){
  case ACB_ADAPTER_TYPE_A:{
- acb->pmuA = ioremap(pci_resource_start(pdev,0), pci_resource_len(pdev,0));
+ acb->pmuA = ioremap(pci_resource_start(pdev,0),
+ pci_resource_len(pdev,0));
  if (!acb->pmuA) {
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: memory "
+            "mapping region fail \n", acb->host->host_no);
  return false;
  }
  break;
  }
  case ACB_ADAPTER_TYPE_B:{
  void __iomem *mem_base0, *mem_base1;
- mem_base0 = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+ mem_base0 = ioremap(pci_resource_start(pdev, 0),
+ pci_resource_len(pdev, 0));
  if (!mem_base0) {
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: memory "
+            "mapping region fail \n", acb->host->host_no);
  return false;
  }
- mem_base1 = ioremap(pci_resource_start(pdev, 2), pci_resource_len(pdev, 2));
+ mem_base1 = ioremap(pci_resource_start(pdev, 2),
+ pci_resource_len(pdev, 2));
  if (!mem_base1) {
  iounmap(mem_base0);
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: memory mapping "
+            "region fail \n", acb->host->host_no);
  return false;
  }
  acb->mem_base0 = mem_base0;
@@ -286,13 +299,17 @@ static bool arcmsr_remap_pciregion(struc
  break;
  }
  case ACB_ADAPTER_TYPE_C:{
- acb->pmuC = ioremap(pci_resource_start(pdev, 1), pci_resource_len(pdev, 1));
+ acb->pmuC = ioremap(pci_resource_start(pdev, 1),
+ pci_resource_len(pdev, 1));
  if (!acb->pmuC) {
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: memory mapping "
+            "region fail \n", acb->host->host_no);
  return false;
  }
- if (readl(&acb->pmuC->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
- writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/
+ if (readl(&acb->pmuC->outbound_doorbell) &
+ ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+ writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+   &acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/
  return true;
  }
  break;
@@ -321,13 +338,14 @@ static bool arcmsr_remap_pciregion(struc
  return false;
  }
  writel(0, &acb->pmuE->host_int_status); /*clear interrupt*/
- writel(ARCMSR_HBEMU_DOORBELL_SYNC, &acb->pmuE->iobound_doorbell); /*
synchronize doorbell to 0 */
+ writel(ARCMSR_HBEMU_DOORBELL_SYNC, &acb->pmuE->iobound_doorbell);
  acb->in_doorbell = 0;
  acb->out_doorbell = 0;
  break;
  }
  case ACB_ADAPTER_TYPE_F: {
- acb->pmuF = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+ acb->pmuF = ioremap(pci_resource_start(pdev, 0),
+ pci_resource_len(pdev, 0));
  if (!acb->pmuF) {
  pr_notice("arcmsr%d: memory mapping region fail\n",
  acb->host->host_no);
@@ -447,7 +465,7 @@ static uint8_t arcmsr_hbaC_wait_msgint_r
  if (readl(&phbcmu->outbound_doorbell)
  & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
  writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
- &phbcmu->outbound_doorbell_clear); /*clear interrupt*/
+ &phbcmu->outbound_doorbell_clear); /*clear interrupt*/
  return true;
  }
  msleep(10);
@@ -481,7 +499,8 @@ static bool arcmsr_hbaE_wait_msgint_read

  for (i = 0; i < 2000; i++) {
  read_doorbell = readl(&phbcmu->iobound_doorbell);
- if ((read_doorbell ^ pACB->in_doorbell) &
ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE) {
+ if ((read_doorbell ^ pACB->in_doorbell) &
+ ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE) {
  writel(0, &phbcmu->host_int_status); /*clear interrupt*/
  pACB->in_doorbell = read_doorbell;
  return true;
@@ -501,8 +520,9 @@ static void arcmsr_hbaA_flush_cache(stru
  break;
  else {
  retry_count--;
- printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
- timeout, retry count down = %d \n", acb->host->host_no, retry_count);
+ printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' "
+ "timeout, retry count down = %d \n",
+   acb->host->host_no, retry_count);
  }
  } while (retry_count != 0);
 }
@@ -517,8 +537,9 @@ static void arcmsr_hbaB_flush_cache(stru
  break;
  else {
  retry_count--;
- printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
- timeout,retry count down = %d \n", acb->host->host_no, retry_count);
+ printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' "
+ "timeout,retry count down = %d \n",
+   acb->host->host_no, retry_count);
  }
  } while (retry_count != 0);
 }
@@ -534,8 +555,9 @@ static void arcmsr_hbaC_flush_cache(stru
  break;
  } else {
  retry_count--;
- printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
- timeout,retry count down = %d \n", pACB->host->host_no, retry_count);
+ printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' "
+ "timeout, retry count down = %d \n",
+   pACB->host->host_no, retry_count);
  }
  } while (retry_count != 0);
  return;
@@ -605,9 +627,11 @@ static void arcmsr_hbaB_assign_regAddr(s

  if (acb->pdev->device == PCI_DEVICE_ID_ARECA_1203) {
  reg->drv2iop_doorbell = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
- reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
+ reg->drv2iop_doorbell_mask =
+ MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
  reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
- reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
+ reg->iop2drv_doorbell_mask =
+ MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
  } else {
  reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
  reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
@@ -625,27 +649,39 @@ static void arcmsr_hbaD_assign_regAddr(s

  reg->chip_id = MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
  reg->cpu_mem_config = MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
- reg->i2o_host_interrupt_mask =
MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+ reg->i2o_host_interrupt_mask =
+ MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
  reg->sample_at_reset = MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
  reg->reset_request = MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
  reg->host_int_status = MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
- reg->pcief0_int_enable = MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+ reg->pcief0_int_enable =
+ MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
  reg->inbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0);
  reg->inbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1);
  reg->outbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
  reg->outbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
  reg->inbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL);
  reg->outbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
- reg->outbound_doorbell_enable =
MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
- reg->inboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
- reg->inboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
- reg->inboundlist_write_pointer =
MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
- reg->outboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
- reg->outboundlist_base_high =
MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
- reg->outboundlist_copy_pointer =
MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
- reg->outboundlist_read_pointer =
MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
- reg->outboundlist_interrupt_cause =
MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
- reg->outboundlist_interrupt_enable =
MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+ reg->outbound_doorbell_enable =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+ reg->inboundlist_base_low =
+ MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+ reg->inboundlist_base_high =
+ MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+ reg->inboundlist_write_pointer =
+ MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+ reg->outboundlist_base_low =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+ reg->outboundlist_base_high =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+ reg->outboundlist_copy_pointer =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+ reg->outboundlist_read_pointer =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+ reg->outboundlist_interrupt_cause =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+ reg->outboundlist_interrupt_enable =
+ MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
  reg->message_wbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
  reg->message_rbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
  reg->msgcode_rwbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
@@ -657,12 +693,14 @@ static void arcmsr_hbaF_assign_regAddr(s
  struct MessageUnit_F __iomem *pmuF;

  memset(acb->dma_coherent2, 0xff, acb->completeQ_size);
- acb->message_wbuffer = (uint32_t *)round_up((unsigned
long)acb->dma_coherent2 +
- acb->completeQ_size, 4);
+ acb->message_wbuffer = (uint32_t *)
+ round_up((unsigned long)acb->dma_coherent2
+ + acb->completeQ_size, 4);
  acb->message_rbuffer = ((void *)acb->message_wbuffer) + 0x100;
  acb->msgcode_rwbuffer = ((void *)acb->message_wbuffer) + 0x200;
  memset((void *)acb->message_wbuffer, 0, MESG_RW_BUFFER_SIZE);
- host_buffer_dma = round_up(acb->dma_coherent_handle2 +
acb->completeQ_size, 4);
+ host_buffer_dma = round_up(acb->dma_coherent_handle2
+ + acb->completeQ_size, 4);
  pmuF = acb->pmuF;
  /* host buffer low address, bit0:1 all buffer active */
  writel(lower_32_bits(host_buffer_dma | 1), &pmuF->inbound_msgaddr0);
@@ -685,7 +723,8 @@ static bool arcmsr_alloc_io_queue(struct
  dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
  &dma_coherent_handle, GFP_KERNEL);
  if (!dma_coherent) {
- pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+ pr_notice("arcmsr%d: DMA allocation failed\n",
+ acb->host->host_no);
  return false;
  }
  acb->dma_coherent_handle2 = dma_coherent_handle;
@@ -699,7 +738,8 @@ static bool arcmsr_alloc_io_queue(struct
  dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
  &dma_coherent_handle, GFP_KERNEL);
  if (!dma_coherent) {
- pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+ pr_notice("arcmsr%d: DMA allocation failed\n",
+ acb->host->host_no);
  return false;
  }
  acb->dma_coherent_handle2 = dma_coherent_handle;
@@ -710,18 +750,22 @@ static bool arcmsr_alloc_io_queue(struct
  break;
  case ACB_ADAPTER_TYPE_E: {
  uint32_t completeQ_size;
- completeQ_size = sizeof(struct deliver_completeQ) *
ARCMSR_MAX_HBE_DONEQUEUE + 128;
+ completeQ_size = sizeof(struct deliver_completeQ)
+ * ARCMSR_MAX_HBE_DONEQUEUE + 128;
  acb->ioqueue_size = roundup(completeQ_size, 32);
- dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
+ dma_coherent = dma_alloc_coherent(&pdev->dev
+  , acb->ioqueue_size,
  &dma_coherent_handle, GFP_KERNEL);
- if (!dma_coherent){
- pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+ if (!dma_coherent) {
+ pr_notice("arcmsr%d: DMA allocation failed\n"
+  , acb->host->host_no);
  return false;
  }
  acb->dma_coherent_handle2 = dma_coherent_handle;
  acb->dma_coherent2 = dma_coherent;
  acb->pCompletionQ = dma_coherent;
- acb->completionQ_entry = acb->ioqueue_size / sizeof(struct deliver_completeQ);
+ acb->completionQ_entry = acb->ioqueue_size
+ / sizeof(struct deliver_completeQ);
  acb->doneq_index = 0;
  }
  break;
@@ -731,18 +775,22 @@ static bool arcmsr_alloc_io_queue(struct

  arcmsr_wait_firmware_ready(acb);
  QueueDepth = depthTbl[readl(&acb->pmuF->outbound_msgaddr1) & 7];
- acb->completeQ_size = sizeof(struct deliver_completeQ) * QueueDepth + 128;
- acb->ioqueue_size = roundup(acb->completeQ_size + MESG_RW_BUFFER_SIZE, 32);
+ acb->completeQ_size = sizeof(struct deliver_completeQ)
+ * QueueDepth + 128;
+ acb->ioqueue_size = roundup(acb->completeQ_size
+ + MESG_RW_BUFFER_SIZE, 32);
  dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
  &dma_coherent_handle, GFP_KERNEL);
  if (!dma_coherent) {
- pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+ pr_notice("arcmsr%d: DMA allocation failed\n",
+ acb->host->host_no);
  return false;
  }
  acb->dma_coherent_handle2 = dma_coherent_handle;
  acb->dma_coherent2 = dma_coherent;
  acb->pCompletionQ = dma_coherent;
- acb->completionQ_entry = acb->completeQ_size / sizeof(struct
deliver_completeQ);
+ acb->completionQ_entry = acb->completeQ_size
+ / sizeof(struct deliver_completeQ);
  acb->doneq_index = 0;
  arcmsr_hbaF_assign_regAddr(acb);
  }
@@ -807,8 +855,8 @@ static int arcmsr_alloc_xor_buffer(struc
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
  struct pci_dev *pdev = acb->pdev;
- void *dma_coherent;
- dma_addr_t dma_coherent_handle;
+ void *dma_coherent, *sense_coherent;
+ dma_addr_t dma_coherent_handle, sense_coherent_handle;
  struct CommandControlBlock *ccb_tmp;
  int i = 0, j = 0;
  unsigned long cdb_phyaddr, next_ccb_phy;
@@ -817,37 +865,45 @@ static int arcmsr_alloc_ccb_pool(struct
  unsigned long max_sg_entrys;
  uint32_t  firm_config_version, curr_phy_upper32;

- for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
- for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
- acb->devstate[i][j] = ARECA_RAID_GONE;
-
  max_xfer_len = ARCMSR_MAX_XFER_LEN;
  max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;
  firm_config_version = acb->firm_cfg_version;
- if((firm_config_version & 0xFF) >= 3){
- max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version
>> 8) & 0xFF)) * 1024;/* max 4M byte */
+ if((firm_config_version & 0xFF) >= 3) {
+ max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
+ ((firm_config_version >> 8) & 0xFF)) * 1024;
  max_sg_entrys = (max_xfer_len/4096);
  }
  acb->host->max_sectors = max_xfer_len/512;
  acb->host->sg_tablesize = max_sg_entrys;
- roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+ roundup_ccbsize = roundup(sizeof(struct CommandControlBlock)
+ + max_sg_entrys * max(sizeof(struct SG64ENTRY),
+ sizeof(struct _ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64)), 32);
  acb->uncache_size = roundup_ccbsize * acb->maxFreeCCB;
- if (acb->adapter_type != ACB_ADAPTER_TYPE_F)
+ if (acb->adapter_type != ACB_ADAPTER_TYPE_F) {
  acb->uncache_size += acb->ioqueue_size;
- dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
&dma_coherent_handle, GFP_KERNEL);
- if(!dma_coherent){
- printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n",
acb->host->host_no);
+ }
+ acb->sense_size = SCSI_SENSE_BUFFERSIZE * acb->maxFreeCCB;
+ dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size
+ + acb->sense_size, &dma_coherent_handle, GFP_KERNEL);
+ if(!dma_coherent) {
+ printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n"
+   , acb->host->host_no);
  return -ENOMEM;
  }
  acb->dma_coherent = dma_coherent;
  acb->dma_coherent_handle = dma_coherent_handle;
- memset(dma_coherent, 0, acb->uncache_size);
+ memset(dma_coherent, 0, acb->uncache_size + acb->sense_size);
  acb->ccbsize = roundup_ccbsize;
+ sense_coherent = dma_coherent + acb->uncache_size;
+ sense_coherent_handle = (unsigned long)dma_coherent_handle
+ + acb->uncache_size;
  ccb_tmp = dma_coherent;
  curr_phy_upper32 = upper_32_bits(dma_coherent_handle);
- acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
long)dma_coherent_handle;
+ acb->vir2phy_offset = (unsigned long)dma_coherent
+ - (unsigned long)dma_coherent_handle;
  for(i = 0; i < acb->maxFreeCCB; i++){
- cdb_phyaddr = (unsigned long)dma_coherent_handle + offsetof(struct
CommandControlBlock, arcmsr_cdb);
+ cdb_phyaddr = (unsigned long)dma_coherent_handle
+ + offsetof(struct CommandControlBlock, iorb);
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A:
  case ACB_ADAPTER_TYPE_B:
@@ -863,16 +919,20 @@ static int arcmsr_alloc_ccb_pool(struct
  acb->pccb_pool[i] = ccb_tmp;
  ccb_tmp->acb = acb;
  ccb_tmp->smid = (u32)i << 16;
+ ccb_tmp->senseBuffer = sense_coherent + SCSI_SENSE_BUFFERSIZE * i;
+ ccb_tmp->sensePhyAddr = (u32)sense_coherent_handle
+ + SCSI_SENSE_BUFFERSIZE * i;
  INIT_LIST_HEAD(&ccb_tmp->list);
  next_ccb_phy = dma_coherent_handle + roundup_ccbsize;
  if (upper_32_bits(next_ccb_phy) != curr_phy_upper32) {
  acb->maxFreeCCB = i;
  acb->host->can_queue = i;
  break;
- }
- else
+ } else {
  list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
- ccb_tmp = (struct CommandControlBlock *)((unsigned long)ccb_tmp +
roundup_ccbsize);
+ }
+ ccb_tmp = (struct CommandControlBlock *)
+ ((unsigned long)ccb_tmp + roundup_ccbsize);
  dma_coherent_handle = next_ccb_phy;
  }
  if (acb->adapter_type != ACB_ADAPTER_TYPE_F) {
@@ -890,13 +950,20 @@ static int arcmsr_alloc_ccb_pool(struct
  break;
  case ACB_ADAPTER_TYPE_E:
  acb->pCompletionQ = acb->dma_coherent2;
- acb->completionQ_entry = acb->ioqueue_size / sizeof(struct deliver_completeQ);
+ acb->completionQ_entry = acb->ioqueue_size
+ / sizeof(struct deliver_completeQ);
  acb->doneq_index = 0;
  break;
  }
+ for (i = 0; i < ARCMSR_TARGETID_MAP; i++) {
+ for (j = 0; j < ARCMSR_TARGETLUN_MAP; j++) {
+ acb->devstate[i][j] = ARECA_RAID_GONE;
+ }
+ }
  if ((acb->firm_PicStatus >> 24) & 0x0f) {
- if (arcmsr_alloc_xor_buffer(acb))
+ if (arcmsr_alloc_xor_buffer(acb)) {
  return -ENOMEM;
+ }
  }
  return 0;
 }
@@ -956,23 +1023,25 @@ static void arcmsr_message_isr_bh_fn(str
  }
  if (readl(signature) != ARCMSR_SIGNATURE_GET_CONFIG)
  return;
- for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
+ for (target = 0; target < ARCMSR_TARGETID_MAP - 1;
  target++) {
  temp = readb(devicemap);
  diff = (*acb_dev_map) ^ temp;
  if (diff != 0) {
  *acb_dev_map = temp;
- for (lun = 0; lun < ARCMSR_MAX_TARGETLUN;
+ for (lun = 0; lun < ARCMSR_TARGETLUN_MAP;
  lun++) {
  if ((diff & 0x01) == 1 &&
  (temp & 0x01) == 1) {
  scsi_add_device(acb->host,
- 0, target, lun);
+ 0, ((target << 3) + lun), 0);
  } else if ((diff & 0x01) == 1
  && (temp & 0x01) == 0) {
  psdev = scsi_device_lookup(acb->host,
- 0, target, lun);
+ 0, ((target << 3) + lun), 0);
  if (psdev != NULL) {
+ acb->direct_io_dev_map[target] &= ~(1 << lun);
+ acb->tlr_dev_map[target] &= ~(1 << lun);
  scsi_remove_device(psdev);
  scsi_device_put(psdev);
  }
@@ -1087,7 +1156,8 @@ static int arcmsr_probe(struct pci_dev *
  if(error){
  return -ENODEV;
  }
- host = scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct
AdapterControlBlock));
+ host = scsi_host_alloc(&arcmsr_scsi_host_template,
+   sizeof(struct AdapterControlBlock));
  if(!host){
      goto pci_disable_dev;
  }
@@ -1101,13 +1171,15 @@ static int arcmsr_probe(struct pci_dev *
  if (arcmsr_set_dma_mask(acb))
  goto scsi_host_release;
  acb->host = host;
- host->max_lun = ARCMSR_MAX_TARGETLUN;
- host->max_id = ARCMSR_MAX_TARGETID; /*16:8*/
- host->max_cmd_len = 16; /*this is issue of 64bit LBA ,over 2T byte*/
- if ((host_can_queue < ARCMSR_MIN_OUTSTANDING_CMD) || (host_can_queue
> ARCMSR_MAX_OUTSTANDING_CMD))
+ host->max_lun = ARCMSR_MAX_TARGETLUN;   /*  8*/
+ host->max_id = ARCMSR_MAX_TARGETID; /*129*/
+ host->max_cmd_len = 16;
+ if ((host_can_queue < ARCMSR_MIN_OUTSTANDING_CMD)
+ || (host_can_queue > ARCMSR_MAX_OUTSTANDING_CMD))
  host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
  host->can_queue = host_can_queue; /* max simultaneous cmds */
- if ((cmd_per_lun < ARCMSR_MIN_CMD_PERLUN) || (cmd_per_lun >
ARCMSR_MAX_CMD_PERLUN))
+ if ((cmd_per_lun < ARCMSR_MIN_CMD_PERLUN)
+ || (cmd_per_lun > ARCMSR_MAX_CMD_PERLUN))
  cmd_per_lun = ARCMSR_DEFAULT_CMD_PERLUN;
  host->cmd_per_lun = cmd_per_lun;
  host->this_id = ARCMSR_SCSI_INITIATOR_ID;
@@ -1368,8 +1440,14 @@ static void arcmsr_ccb_complete(struct C
  struct AdapterControlBlock *acb = ccb->acb;
  struct scsi_cmnd *pcmd = ccb->pcmd;
  unsigned long flags;
+
  atomic_dec(&acb->ccboutstandingcount);
- scsi_dma_unmap(ccb->pcmd);
+ if (ccb->ccb_flags & CCB_FLAG_USE_SG) {
+ scsi_dma_unmap(pcmd);
+ } else if (scsi_bufflen(pcmd)) {
+ dma_unmap_single(&(acb->pdev->dev), ccb->dma_handle,
+ scsi_bufflen(pcmd), pcmd->sc_data_direction);
+ }
  ccb->startdone = ARCMSR_CCB_DONE;
  spin_lock_irqsave(&acb->ccblist_lock, flags);
  list_add_tail(&ccb->list, &acb->ccb_free_list);
@@ -1380,18 +1458,23 @@ static void arcmsr_ccb_complete(struct C
 static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 {
  struct scsi_cmnd *pcmd = ccb->pcmd;
+ struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;

  pcmd->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
- if (pcmd->sense_buffer) {
- struct SENSE_DATA *sensebuffer;
-
- memcpy_and_pad(pcmd->sense_buffer,
+ if (sensebuffer) {
+ if (ccb->ccb_flags & CCB_FLAG_DIRECT_IO) {
+ memcpy_and_pad(pcmd->sense_buffer,
+       SCSI_SENSE_BUFFERSIZE,
+       (void *)ccb->senseBuffer,
        SCSI_SENSE_BUFFERSIZE,
-       ccb->arcmsr_cdb.SenseData,
-       sizeof(ccb->arcmsr_cdb.SenseData),
        0);
-
- sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
+ } else {
+    memcpy_and_pad(pcmd->sense_buffer,
+       SCSI_SENSE_BUFFERSIZE,
+       ccb->iorb.arcmsr_cdb.u1.status.SenseData,
+       sizeof(ccb->iorb.arcmsr_cdb.u1.status.SenseData),
+       0);
+ }
  sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
  sensebuffer->Valid = 1;
  }
@@ -1404,8 +1487,8 @@ static u32 arcmsr_disable_outbound_ints(
  case ACB_ADAPTER_TYPE_A : {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  orig_mask = readl(&reg->outbound_intmask);
- writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
- &reg->outbound_intmask);
+ writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
+   &reg->outbound_intmask);
  }
  break;
  case ACB_ADAPTER_TYPE_B : {
@@ -1416,14 +1499,12 @@ static u32 arcmsr_disable_outbound_ints(
  break;
  case ACB_ADAPTER_TYPE_C:{
  struct MessageUnit_C __iomem *reg = acb->pmuC;
- /* disable all outbound interrupt */
- orig_mask = readl(&reg->host_int_mask); /* disable outbound message0 int */
+ orig_mask = readl(&reg->host_int_mask);
  writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
  }
  break;
  case ACB_ADAPTER_TYPE_D: {
  struct MessageUnit_D *reg = acb->pmuD;
- /* disable all outbound interrupt */
  writel(ARCMSR_ARC1214_ALL_INT_DISABLE, reg->pcief0_int_enable);
  }
  break;
@@ -1431,7 +1512,8 @@ static u32 arcmsr_disable_outbound_ints(
  case ACB_ADAPTER_TYPE_F: {
  struct MessageUnit_E __iomem *reg = acb->pmuE;
  orig_mask = readl(&reg->host_int_mask);
- writel(orig_mask | ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR |
ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR, &reg->host_int_mask);
+ writel(orig_mask | ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR
+   | ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR, &reg->host_int_mask);
  readl(&reg->host_int_mask); /* Dummy readl to force pci flush */
  }
  break;
@@ -1439,59 +1521,254 @@ static u32 arcmsr_disable_outbound_ints(
  return orig_mask;
 }

+static void arcmsr_sas_direct_io_parsing_sense_data(
+ struct AdapterControlBlock *acb, struct CommandControlBlock *ccb)
+{
+ struct scsi_cmnd *pcmd = ccb->pcmd;
+ uint8_t id = pcmd->device->id >> 3;
+ uint8_t lun = pcmd->device->id & 7;
+ REQUESTSENSE_SAS *ptr = (REQUESTSENSE_SAS *)ccb->senseBuffer;
+ uint32_t TransferCount = ptr->TransferCount;
+ uint32_t IOCLogInfo = ptr->IOCLogInfo;
+ uint8_t SCSIStatus = ptr->SCSIStatus;
+ uint8_t SCSIState = ptr->SCSIState;
+ uint16_t IOCStatus = ptr->IOCStatus;
+
+ if (IOCStatus == ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DATA_UNDERRUN &&
+    TransferCount == 0 &&
+ (SCSIStatus == ARCMSR_DIRECT_IO_SCSI_STATUS_BUSY ||
+    SCSIStatus == ARCMSR_DIRECT_IO_SCSI_STATUS_RESERVATION_CONFLICT ||
+    SCSIStatus == ARCMSR_DIRECT_IO_SCSI_STATUS_TASK_SET_FULL)) {
+ IOCStatus = ARCMSR_DIRECT_IO_IOC_STATUS_SUCCESS;
+ }
+ switch (IOCStatus) {
+ case ARCMSR_DIRECT_IO_IOC_STATUS_BUSY:
+ case ARCMSR_DIRECT_IO_IOC_STATUS_INSUFFICIENT_RESOURCES:
+ pcmd->result = SAM_STAT_BUSY;
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DEVICE_NOT_THERE:
+ acb->devstate[id][lun] = ARECA_RAID_GONE;
+ acb->direct_io_dev_map[id] &= ~(1 << lun);
+ acb->tlr_dev_map[id] &= ~(1 << lun);
+ pcmd->result = DID_NO_CONNECT << 16;
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_IOC_TERMINATED:
+ pcmd->result = DID_SOFT_ERROR << 16;
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_TASK_TERMINATED:
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_EXT_TERMINATED:
+ pcmd->result = DID_RESET << 16;
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_RESIDUAL_MISMATCH:
+ if ((TransferCount == 0) || (pcmd->underflow > TransferCount)) {
+ pcmd->result = DID_SOFT_ERROR << 16;
+ } else {
+ pcmd->result = (DID_OK << 16) | SCSIStatus;
+ }
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DATA_UNDERRUN:
+ pcmd->result = (DID_OK << 16) | SCSIStatus;
+ scsi_set_resid(pcmd, scsi_bufflen(pcmd) - TransferCount);
+ if (SCSIStatus == ARCMSR_DIRECT_IO_SCSI_STATUS_GOOD) {
+ if (pcmd->cmnd[0] == INQUIRY) {
+ char inquiry_data[0x60];
+ uint16_t i, len;
+ len = min(0x60, ((pcmd->cmnd[3] << 8) + pcmd->cmnd[4]));
+ sg_copy_to_buffer(scsi_sglist(pcmd), 1,
+ (void *)&inquiry_data[0], len);
+ if (pcmd->cmnd[1] == ARCMSR_CDB_INQUIRY_EVPD) {
+ if (acb->direct_io_dev_map[id] & (1 << lun)) {
+ if (pcmd->cmnd[2] == 0) {
+ len = inquiry_data[3];
+ for (i = 0; i < len; i++) {
+ if (inquiry_data[4+i] == 0x90) {
+ acb->tlr_dev_map[id] |= (1 << lun);
+ }
+ }
+ }
+ }
+ }
+ }
+ }
+ break;
+ if (TransferCount < pcmd->underflow) {
+ if (SCSIStatus == SAM_STAT_BUSY) {
+ pcmd->result = SAM_STAT_BUSY;
+ } else {
+ pcmd->result = DID_SOFT_ERROR << 16;
+ }
+ } else if (SCSIState & ARCMSR_DIRECT_IO_SCSI_STATE_NO_SCSI_STATUS) {
+ pcmd->result = DID_SOFT_ERROR << 16;
+ } else if (SCSIState & ARCMSR_DIRECT_IO_SCSI_STATE_TERMINATED) {
+ pcmd->result = DID_RESET << 16;
+ }
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_DATA_OVERRUN:
+ scsi_set_resid(pcmd, 0);
+ goto success;
+ break;
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SUCCESS:
+ case ARCMSR_DIRECT_IO_IOC_STATUS_SCSI_RECOVERED_ERROR:
+success:
+ pcmd->result = (DID_OK << 16) | SCSIStatus;
+ if ((SCSIState & ARCMSR_DIRECT_IO_SCSI_STATE_RESPONSE_INFO_VALID) &&
+ ((le32_to_cpu(IOCLogInfo) &
+ ARCMSR_DIRECT_IO_SCSI_RI_MASK_REASONCODE) ==
+ ARCMSR_IOC_SCSI_RI_INVALID_FRAME)) {
+ if (acb->tlr_dev_map[id] & (1 << lun)) {
+ acb->tlr_dev_map[id] &= ~(1 << lun);
+ }
+ }
+ if (SCSIState & ARCMSR_DIRECT_IO_SCSI_STATE_NO_SCSI_STATUS) {
+ pcmd->result = DID_SOFT_ERROR << 16;
+ } else if (SCSIState &  ARCMSR_DIRECT_IO_SCSI_STATE_TERMINATED) {
+ pcmd->result = DID_RESET << 16;
+ }
+ break;
+ default:
+ pcmd->result = DID_SOFT_ERROR << 16;
+ break;
+ }
+}
+
+static void arcmsr_nvme_direct_io_parsing_sense_data(
+ struct AdapterControlBlock *acb, struct CommandControlBlock *ccb)
+{
+ return;/* not yet implemented */
+}
+
 static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
- struct CommandControlBlock *ccb, bool error)
+ struct CommandControlBlock *ccb, bool error, uint16_t cmdLMID)
 {
  uint8_t id, lun;
- id = ccb->pcmd->device->id;
- lun = ccb->pcmd->device->lun;
+ struct scsi_cmnd *pcmd = ccb->pcmd;
+
+ id = pcmd->device->id >> 3;
+ lun = pcmd->device->id & 7;
  if (!error) {
- if (acb->devstate[id][lun] == ARECA_RAID_GONE)
+ uint16_t len, i;
+
+ if (acb->devstate[id][lun] == ARECA_RAID_GONE) {
  acb->devstate[id][lun] = ARECA_RAID_GOOD;
- ccb->pcmd->result = DID_OK << 16;
- arcmsr_ccb_complete(ccb);
- }else{
- switch (ccb->arcmsr_cdb.DeviceStatus) {
- case ARCMSR_DEV_SELECT_TIMEOUT: {
- acb->devstate[id][lun] = ARECA_RAID_GONE;
- ccb->pcmd->result = DID_NO_CONNECT << 16;
+ }
+ if (ccb->ccb_flags & CCB_FLAG_DIRECT_IO) {
+ pcmd->result = DID_OK << 16;
  arcmsr_ccb_complete(ccb);
- }
- break;
-
- case ARCMSR_DEV_ABORTED:
+ return;
+ }
+ if (pcmd->cmnd[0] == INQUIRY) {
+ uint8_t inquiry_data[0x60];

- case ARCMSR_DEV_INIT_FAIL: {
- acb->devstate[id][lun] = ARECA_RAID_GONE;
- ccb->pcmd->result = DID_BAD_TARGET << 16;
- arcmsr_ccb_complete(ccb);
+ len = min(0x60, ((pcmd->cmnd[3] << 8) + pcmd->cmnd[4]));
+ sg_copy_to_buffer(scsi_sglist(pcmd), 1,
+ (void *)&inquiry_data[0], len);
+ if (pcmd->cmnd[1] == ARCMSR_CDB_INQUIRY_EVPD) {
+ if (acb->direct_io_dev_map[id] & (1 << lun)) {
+ if (ccb->pcmd->cmnd[2] == 0) {
+ len = inquiry_data[3];
+ for (i = 0; i < len; i++) {
+ if (inquiry_data[4+i] == 0x90) {
+ acb->tlr_dev_map[id] |= (1 << lun);
+ }
+ }
+ }
+ }
+ } else {
+ if ((inquiry_data[0] & 0x7F) != SCSI_UNKNOWN_DEV) {
+ if((inquiry_data[7] & 1) ||
+ ((inquiry_data[0] & 0x7f) == SCSI_SEQACESS) ||
+ ((inquiry_data[0] & 0x7f) == SCSI_MEDCHGR)) {
+ acb->direct_io_dev_map[id] |= 1 << lun;
+ if((inquiry_data[0] & 0x7f) == SCSI_SEQACESS) {
+ if(inquiry_data[7] & 0x40) { /* bit6 */
+ acb->tlr_dev_map[id] |= 1 << lun;
+ }
+ }
+ }
+ }
  }
- break;
+ }
+ if (pcmd->cmnd[0] == REPORT_LUNS) {
+ uint8_t report_lun_data[16];

- case ARCMSR_DEV_CHECK_CONDITION: {
- acb->devstate[id][lun] = ARECA_RAID_GOOD;
- arcmsr_report_sense_info(ccb);
- arcmsr_ccb_complete(ccb);
+ memset(report_lun_data, 0, 16);
+ report_lun_data[3] = 8;
+ sg_copy_from_buffer(scsi_sglist(pcmd), 1,
+ (void *)&report_lun_data[0], 16);
+ scsi_set_resid(pcmd, scsi_bufflen(pcmd) - 16);
+ }
+ pcmd->result = DID_OK << 16;
+ arcmsr_ccb_complete(ccb);
+ return;
+ } else {
+ if(ccb->ccb_flags & CCB_FLAG_DIRECT_IO) {
+ switch(cmdLMID) {
+ case ARCMSR_DEV_CHECK_CONDITION:
+ acb->devstate[id][lun] = ARECA_RAID_GOOD;
+ arcmsr_report_sense_info(ccb);
+ arcmsr_ccb_complete(ccb);
+ break;
+ case ARCMSR_DEV_SAS_DIRECT_IO_ERROR:
+ arcmsr_sas_direct_io_parsing_sense_data(acb, ccb);
+ arcmsr_ccb_complete(ccb);
+ break;
+ case ARCMSR_DEV_NVME_DIRECT_IO_ERROR:
+ arcmsr_nvme_direct_io_parsing_sense_data(acb, ccb);
+ arcmsr_ccb_complete(ccb);
+ break;
+ default:
+ acb->devstate[id][lun] = ARECA_RAID_GONE;
+ acb->direct_io_dev_map[id] &= ~(1 << lun);
+ acb->tlr_dev_map[id] &= ~(1 << lun);
+ ccb->pcmd->result = DID_BAD_TARGET << 16;
+ arcmsr_ccb_complete(ccb);
+ break;
  }
- break;
-
- default:
- printk(KERN_NOTICE
- "arcmsr%d: scsi id = %d lun = %d isr get command error done, \
- but got unknown DeviceStatus = 0x%x \n"
- , acb->host->host_no
- , id
- , lun
- , ccb->arcmsr_cdb.DeviceStatus);
+ } else {
+ switch (ccb->iorb.arcmsr_cdb.u1.status.DeviceStatus) {
+ case ARCMSR_DEV_SELECT_TIMEOUT: {
  acb->devstate[id][lun] = ARECA_RAID_GONE;
  ccb->pcmd->result = DID_NO_CONNECT << 16;
  arcmsr_ccb_complete(ccb);
- break;
+ }
+ break;
+
+ case ARCMSR_DEV_ABORTED:
+
+ case ARCMSR_DEV_INIT_FAIL: {
+ acb->devstate[id][lun] = ARECA_RAID_GONE;
+ ccb->pcmd->result = DID_BAD_TARGET << 16;
+ arcmsr_ccb_complete(ccb);
+ }
+ break;
+
+ case ARCMSR_DEV_CHECK_CONDITION: {
+ acb->devstate[id][lun] = ARECA_RAID_GOOD;
+ arcmsr_report_sense_info(ccb);
+ arcmsr_ccb_complete(ccb);
+ }
+ break;
+
+ default:
+ printk(KERN_NOTICE
+ "arcmsr%d: scsi id = %d lun = %d isr get command error done,"
+                    " but got unknown DeviceStatus = 0x%x \n"
+ , acb->host->host_no
+ , ccb->pcmd->device->id
+ , (u32)ccb->pcmd->device->lun
+ , ccb->iorb.arcmsr_cdb.u1.status.DeviceStatus);
+ acb->devstate[id][lun] = ARECA_RAID_GONE;
+ ccb->pcmd->result = DID_NO_CONNECT << 16;
+ arcmsr_ccb_complete(ccb);
+ break;
+ }
  }
  }
+ return;
 }

-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb,
struct CommandControlBlock *pCCB, bool error)
+static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *pCCB, bool error, uint16_t cmdLMID)
 {
  if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
  if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
@@ -1504,9 +1781,9 @@ static void arcmsr_drain_donequeue(struc
  }
  return;
  }
- printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
- done acb = '0x%p'"
- "ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
+ printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command"
+ " done acb = '0x%p'"
+ " ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
  " ccboutstandingcount = %d \n"
  , acb->host->host_no
  , acb
@@ -1516,7 +1793,7 @@ static void arcmsr_drain_donequeue(struc
  , atomic_read(&acb->ccboutstandingcount));
  return;
  }
- arcmsr_report_ccb_state(acb, pCCB, error);
+ arcmsr_report_ccb_state(acb, pCCB, error, cmdLMID);
 }

 static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
@@ -1536,16 +1813,19 @@ static void arcmsr_done4abort_postqueue(
  outbound_intstatus = readl(&reg->outbound_intstatus) &
  acb->outbound_int_enable;
  /*clear and abort all outbound posted Q*/
- writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
+ writel(outbound_intstatus, &reg->outbound_intstatus);
  while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
  && (i++ < acb->maxOutstanding)) {
  ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
  if (acb->cdb_phyadd_hipart)
  ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
- arcmsr_drain_donequeue(acb, pCCB, error);
+ pARCMSR_CDB = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + ccb_cdb_phy);
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, iorb.arcmsr_cdb);
+ error = (flag_ccb &
+ ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ arcmsr_drain_donequeue(acb, pCCB, error, 0);
  }
  }
  break;
@@ -1553,7 +1833,8 @@ static void arcmsr_done4abort_postqueue(
  case ACB_ADAPTER_TYPE_B: {
  struct MessageUnit_B *reg = acb->pmuB;
  /*clear all outbound posted Q*/
- writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /*
clear doorbell interrupt */
+ writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+   reg->iop2drv_doorbell); /* clear doorbell interrupt */
  for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
  flag_ccb = reg->done_qbuffer[i];
  if (flag_ccb != 0) {
@@ -1561,10 +1842,13 @@ static void arcmsr_done4abort_postqueue(
  ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
  if (acb->cdb_phyadd_hipart)
  ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
- arcmsr_drain_donequeue(acb, pCCB, error);
+ pARCMSR_CDB = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + ccb_cdb_phy);
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, iorb.arcmsr_cdb);
+ error = (flag_ccb &
+ ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ arcmsr_drain_donequeue(acb, pCCB, error, 0);
  }
  reg->post_qbuffer[i] = 0;
  }
@@ -1574,16 +1858,21 @@ static void arcmsr_done4abort_postqueue(
  break;
  case ACB_ADAPTER_TYPE_C: {
  struct MessageUnit_C __iomem *reg = acb->pmuC;
- while ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < acb->maxOutstanding)) {
+ while ((readl(&reg->host_int_status) &
+   ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) &&
+   (i++ < acb->maxOutstanding)) {
  /*need to do*/
  flag_ccb = readl(&reg->outbound_queueport_low);
  ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
  if (acb->cdb_phyadd_hipart)
  ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
- pARCMSR_CDB = (struct  ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
- arcmsr_drain_donequeue(acb, pCCB, error);
+ pARCMSR_CDB = (struct  ARCMSR_CDB *)
+ (acb->vir2phy_offset + ccb_cdb_phy);
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, iorb.arcmsr_cdb);
+ error = (flag_ccb &
+ ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+ arcmsr_drain_donequeue(acb, pCCB, error, 0);
  }
  }
  break;
@@ -1616,11 +1905,11 @@ static void arcmsr_done4abort_postqueue(
  pARCMSR_CDB = (struct  ARCMSR_CDB *)
  (acb->vir2phy_offset + ccb_cdb_phy);
  pCCB = container_of(pARCMSR_CDB,
- struct CommandControlBlock, arcmsr_cdb);
+ struct CommandControlBlock, iorb.arcmsr_cdb);
  error = (addressLow &
  ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ?
  true : false;
- arcmsr_drain_donequeue(acb, pCCB, error);
+ arcmsr_drain_donequeue(acb, pCCB, error, 0);
  writel(doneq_index,
  pmu->outboundlist_read_pointer);
  } else {
@@ -1657,17 +1946,19 @@ static void arcmsr_remove_scsi_devices(s
  scsi_done(ccb->pcmd);
  }
  }
- for (target = 0; target < ARCMSR_MAX_TARGETID; target++) {
+ for (target = 0; target < ARCMSR_TARGETID_MAP; target++) {
  temp = *acb_dev_map;
  if (temp) {
- for (lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
+ for (lun = 0; lun < ARCMSR_TARGETLUN_MAP; lun++) {
  if (temp & 1) {
  psdev = scsi_device_lookup(acb->host,
- 0, target, lun);
+ 0, ((target << 3) + lun), 0);
  if (psdev != NULL) {
  scsi_remove_device(psdev);
  scsi_device_put(psdev);
  }
+ acb->direct_io_dev_map[target] &= ~(1 << lun);
+ acb->tlr_dev_map[target] &= ~(1 << lun);
  }
  temp >>= 1;
  }
@@ -1818,7 +2109,9 @@ static void arcmsr_enable_outbound_ints(
  break;
  case ACB_ADAPTER_TYPE_C: {
  struct MessageUnit_C __iomem *reg = acb->pmuC;
- mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
+ mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
+ ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
  writel(intmask_org & mask, &reg->host_int_mask);
  acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;
  }
@@ -1834,7 +2127,8 @@ static void arcmsr_enable_outbound_ints(
  case ACB_ADAPTER_TYPE_F: {
  struct MessageUnit_E __iomem *reg = acb->pmuE;

- mask = ~(ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR |
ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR);
+ mask = ~(ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR |
+ ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR);
  writel(intmask_org & mask, &reg->host_int_mask);
  break;
  }
@@ -1844,73 +2138,188 @@ static void arcmsr_enable_outbound_ints(
 static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
  struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)
 {
- struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
- int8_t *psge = (int8_t *)&arcmsr_cdb->u;
- __le32 address_lo, address_hi;
- int arccdbsize = 0x30;
+ unsigned request_bufflen;
+ unsigned short use_sg;
+ uint8_t target, lun;
  __le32 length = 0;
- int i;
  struct scatterlist *sg;
- int nseg;
+ int i, sgcount = 0;
+
+ request_bufflen = scsi_bufflen(pcmd);
+ use_sg = scsi_sg_count(pcmd);
+ if (use_sg) {
+ ccb->ccb_flags = CCB_FLAG_USE_SG;
+ }
  ccb->pcmd = pcmd;
- memset(arcmsr_cdb, 0, sizeof(struct ARCMSR_CDB));
- arcmsr_cdb->TargetID = pcmd->device->id;
- arcmsr_cdb->LUN = pcmd->device->lun;
- arcmsr_cdb->Function = 1;
- arcmsr_cdb->msgContext = 0;
- memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
-
- nseg = scsi_dma_map(pcmd);
- if (unlikely(nseg > acb->host->sg_tablesize || nseg < 0))
- return FAILED;
- scsi_for_each_sg(pcmd, sg, nseg, i) {
- /* Get the physical address of the current data pointer */
- length = cpu_to_le32(sg_dma_len(sg));
- address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));
- address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
- if (address_hi == 0) {
- struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
-
- pdma_sg->address = address_lo;
- pdma_sg->length = length;
- psge += sizeof (struct SG32ENTRY);
- arccdbsize += sizeof (struct SG32ENTRY);
+ target = pcmd->device->id >> 3;
+ lun = pcmd->device->id & 7;
+ if (acb->direct_io_dev_map[target] & (1 << lun)) {
+ PARCMSR_DIRECT_IO pDio_cdb = &ccb->iorb.arcmsr_dio_cdb;
+ uint32_t mpi_control = 0;
+
+ ccb->ccb_flags |= CCB_FLAG_DIRECT_IO;
+ memset(pDio_cdb, 0, sizeof(ARCMSR_DIRECT_IO));
+ memset(ccb->senseBuffer, 0, SCSI_SENSE_BUFFERSIZE);
+ if (pcmd->sc_data_direction == DMA_TO_DEVICE) {
+ mpi_control |= ARCMSR_DIRECT_IO_SCSIIO_CONTROL_WRITE;
+ } else {
+ mpi_control |= ARCMSR_DIRECT_IO_SCSIIO_CONTROL_READ;
+ }
+ mpi_control |= ARCMSR_DIRECT_IO_SCSIIO_CONTROL_SIMPLEQ;
+ if (acb->tlr_dev_map[target] & (1 << lun)) {
+ mpi_control |= ARCMSR_DIRECT_IO_SCSIIO_CONTROL_TLR_ON;
+ }
+ pDio_cdb->Bus = 0;
+ pDio_cdb->TargetID = target;
+ pDio_cdb->LunID = lun;
+ pDio_cdb->Function = DIRECT_IO_DEVICE;
+ pDio_cdb->MsgFlags =
+ ARCMSR_DIRECT_IO_SCSIIO_MSGFLAGS_SYSTEM_SENSE_ADDR;
+ pDio_cdb->ChainOffset = 0;
+ pDio_cdb->SenseBufferPhyLowAddr = ccb->sensePhyAddr;
+ pDio_cdb->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
+ pDio_cdb->SGLOffset0 = 24;
+ pDio_cdb->SGLOffset1 = 0;
+ pDio_cdb->SGLOffset2 = 0;
+ pDio_cdb->SGLOffset3 = 0;
+ pDio_cdb->SkipCount = 0;
+ pDio_cdb->DataLength = request_bufflen;
+ pDio_cdb->BidirectionalDataLength = 0;
+ pDio_cdb->IoFlags = pcmd->cmd_len |
+ ARCMSR25_DIRECT_IO_SCSIIO_IOFLAGS_FAST_PATH;
+ pDio_cdb->EEDPFlags = 0;
+ pDio_cdb->Control = mpi_control;
+ memcpy(&pDio_cdb->CDB.CDB32[0], pcmd->cmnd, pcmd->cmd_len);
+ if (request_bufflen == 0) {
+ memset(&pDio_cdb->SGL0, 0,
+   sizeof(ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64));
+ memset(&pDio_cdb->SGL1, 0,
+   sizeof(ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64));
+ pDio_cdb->msgLen = 0x1C;
  } else {
- struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
+ PARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64 pdma_sg = &pDio_cdb->SGL0;
+ PARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64 pdma_sg1 = &pDio_cdb->SGL1;
+ uint32_t residue = (uint32_t)request_bufflen;
+ if (use_sg) {
+ sgcount = scsi_dma_map(pcmd);
+ scsi_for_each_sg(pcmd, sg, sgcount, i) {
+ length = cpu_to_le32(sg_dma_len(sg));
+ residue -= length;
+ if ((pdma_sg == pdma_sg1) && residue) {
+ pdma_sg++;
+ }
+ pdma_sg->Address.value = cpu_to_le64(sg_dma_address(sg));
+ pdma_sg->Length = length;
+ pdma_sg->NextChainOffset = 0;
+ pdma_sg->Flags = SIMPLE_SGL_FLAGS;
+ if (residue == 0) {
+ pdma_sg->Flags |=
+ ARCMSR25_DIRECT_IO_IEEE_SGE_FLAGS_END_OF_LIST;
+ }
+ pdma_sg++;
+ }
+ } else if (request_bufflen) {
+ dma_addr_t dma_addr;
+ dma_addr = dma_map_single(&(acb->pdev->dev),
+  scsi_sglist(pcmd), request_bufflen,
+  pcmd->sc_data_direction);
+ ccb->dma_handle = dma_addr;
+ pdma_sg->Address.value = cpu_to_le64(dma_addr);
+ pdma_sg->Length = cpu_to_le32(request_bufflen);
+ pdma_sg->NextChainOffset = 0;
+ pdma_sg->Flags = SIMPLE_SGL_FLAGS_LAST;
+ sgcount = 1;
+ }
+ if (sgcount > 2) {
+ pdma_sg1->Address.value = cpu_to_le64(
+ ccb->cdb_phyaddr + sizeof(ARCMSR_DIRECT_IO));
+ pdma_sg1->Length = cpu_to_le32(
+ (sgcount - 1) *
+ sizeof(ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64));
+ pdma_sg1->NextChainOffset = 0;
+ pdma_sg1->Flags = CHAIN_SGL_FLAGS;
+ pDio_cdb->ChainOffset = (uint8_t)
+ (offsetof(ARCMSR_DIRECT_IO, SGL1)
+ / sizeof(ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64));
+ }
+ if (sgcount > 1) {
+ pDio_cdb->msgLen = sizeof(ARCMSR_DIRECT_IO) >> 2;
+ } else {
+ memset(&pDio_cdb->SGL1, 0,
+   sizeof(ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64));
+ pDio_cdb->msgLen = (sizeof(ARCMSR_DIRECT_IO)
+ - sizeof(ARCMSR25_DIRECT_IO_IEEE_SGE_CHAIN64)) >> 2;
+ }
+ }
+ ccb->arc_cdb_size = sizeof(ARCMSR_DIRECT_IO);
+ } else {
+ struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)
+ &ccb->iorb.arcmsr_cdb;
+    int8_t *psge = (int8_t *)&arcmsr_cdb->u;
+    __le32 address_lo, address_hi;
+    int arccdbsize = 0x30;
+
+ memset(arcmsr_cdb, 0, sizeof(struct ARCMSR_CDB));
+ arcmsr_cdb->TargetID = target;
+ arcmsr_cdb->LUN = lun;
+ arcmsr_cdb->Function = 1;
+ arcmsr_cdb->msgContext = 0;
+ memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
+
+ sgcount = scsi_dma_map(pcmd);
+ if (unlikely(sgcount > acb->host->sg_tablesize || sgcount < 0))
+ return FAILED;
+ scsi_for_each_sg(pcmd, sg, sgcount, i) {
+ /* Get the physical address of the current data pointer */
+ length = cpu_to_le32(sg_dma_len(sg));
+ address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));
+ address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
+ if (address_hi == 0) {
+ struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
+
+ pdma_sg->address = address_lo;
+ pdma_sg->length = length;
+ psge += sizeof (struct SG32ENTRY);
+ arccdbsize += sizeof (struct SG32ENTRY);
+ } else {
+ struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;

- pdma_sg->addresshigh = address_hi;
- pdma_sg->address = address_lo;
- pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
- psge += sizeof (struct SG64ENTRY);
- arccdbsize += sizeof (struct SG64ENTRY);
- }
- }
- arcmsr_cdb->sgcount = (uint8_t)nseg;
- arcmsr_cdb->DataLength = scsi_bufflen(pcmd);
- arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
- if ( arccdbsize > 256)
- arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
- if (pcmd->sc_data_direction == DMA_TO_DEVICE)
- arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
- ccb->arc_cdb_size = arccdbsize;
+ pdma_sg->addresshigh = address_hi;
+ pdma_sg->address = address_lo;
+ pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
+ psge += sizeof (struct SG64ENTRY);
+ arccdbsize += sizeof (struct SG64ENTRY);
+ }
+ }
+ arcmsr_cdb->sgcount = (uint8_t)sgcount;
+ arcmsr_cdb->DataLength = request_bufflen;
+ arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
+ if ( arccdbsize > 256)
+ arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
+ if (pcmd->sc_data_direction == DMA_TO_DEVICE)
+ arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
+ ccb->arc_cdb_size = arccdbsize;
+ }
  return SUCCESS;
 }

-static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
+static void arcmsr_post_ccb(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *ccb)
 {
  uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
- struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+ struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->iorb.arcmsr_cdb;
  atomic_inc(&acb->ccboutstandingcount);
  ccb->startdone = ARCMSR_CCB_START;
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
  struct MessageUnit_A __iomem *reg = acb->pmuA;

- if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
+ if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
  writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
  &reg->inbound_queueport);
- else
+ } else {
  writel(cdb_phyaddr, &reg->inbound_queueport);
+ }
  break;
  }

@@ -1938,7 +2347,8 @@ static void arcmsr_post_ccb(struct Adapt

  arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;
  ccb_post_stamp = (cdb_phyaddr | ((arc_cdb_size - 1) >> 6) | 1);
- writel(upper_32_bits(ccb->cdb_phyaddr), &phbcmu->inbound_queueport_high);
+ writel(upper_32_bits(ccb->cdb_phyaddr),
+   &phbcmu->inbound_queueport_high);
  writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
  }
  break;
@@ -1951,7 +2361,8 @@ static void arcmsr_post_ccb(struct Adapt

  spin_lock_irqsave(&acb->postq_lock, flags);
  postq_index = pmu->postq_index;
- pinbound_srb = (struct InBound_SRB *)&(pmu->post_qbuffer[postq_index & 0xFF]);
+ pinbound_srb = (struct InBound_SRB *)
+ &(pmu->post_qbuffer[postq_index & 0xFF]);
  pinbound_srb->addressHigh = upper_32_bits(ccb->cdb_phyaddr);
  pinbound_srb->addressLow = cdb_phyaddr;
  pinbound_srb->length = ccb->arc_cdb_size >> 2;
@@ -1979,9 +2390,9 @@ static void arcmsr_post_ccb(struct Adapt
  struct MessageUnit_F __iomem *pmu = acb->pmuF;
  u32 ccb_post_stamp, arc_cdb_size;

- if (ccb->arc_cdb_size <= 0x300)
+ if (ccb->arc_cdb_size <= 0x300) {
  arc_cdb_size = (ccb->arc_cdb_size - 1) >> 6 | 1;
- else {
+ } else {
  arc_cdb_size = ((ccb->arc_cdb_size + 0xff) >> 8) + 2;
  if (arc_cdb_size > 0xF)
  arc_cdb_size = 0xF;
@@ -2106,7 +2517,8 @@ static void arcmsr_free_ccb_pool(struct
  dma_free_coherent(&acb->pdev->dev, acb->init2cfg_size,
  acb->xorVirt, acb->xorPhys);
  }
- dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
+ dma_free_coherent(&acb->pdev->dev, acb->uncache_size + acb->sense_size,
+  acb->dma_coherent, acb->dma_coherent_handle);
 }

 static void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
@@ -2229,7 +2641,8 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
  return qbuffer;
 }

-static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct
AdapterControlBlock *acb)
+static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(
+ struct AdapterControlBlock *acb)
 {
  struct QBUFFER __iomem *pqbuffer = NULL;
  switch (acb->adapter_type) {
@@ -2352,7 +2765,8 @@ static void arcmsr_iop2drv_data_wrote_ha
  spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 }

-static void arcmsr_write_ioctldata2iop_in_DWORD(struct
AdapterControlBlock *acb)
+static void arcmsr_write_ioctldata2iop_in_DWORD(
+ struct AdapterControlBlock *acb)
 {
  uint8_t *pQbuffer;
  struct QBUFFER __iomem *pwbuffer;
@@ -2548,10 +2962,12 @@ static void arcmsr_hbaA_postqueue_isr(st
  cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
  if (acb->cdb_phyadd_hipart)
  cdb_phy_addr = cdb_phy_addr | acb->cdb_phyadd_hipart;
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + cdb_phy_addr);
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
+ pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+ cdb_phy_addr);
+ pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock,
+ iorb.arcmsr_cdb);
  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
- arcmsr_drain_donequeue(acb, pCCB, error);
+ arcmsr_drain_donequeue(acb, pCCB, error, 0);
  }
 }
 static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
@@ -2569,10 +2985,13 @@ static void arcmsr_hbaB_postqueue_isr(st
  cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
  if (acb->cdb_phyadd_hipart)
  cdb_phy_addr = cdb_phy_addr | acb->cdb_phyadd_hipart;
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + cdb_phy_addr);
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
- arcmsr_drain_donequeue(acb, pCCB, error);
+ pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+ cdb_phy_addr);
+ pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock,
+ iorb.arcmsr_cdb);
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+ ? true : false;
+ arcmsr_drain_donequeue(acb, pCCB, error, 0);
  reg->done_qbuffer[index] = 0;
  index++;
  index %= ARCMSR_MAX_HBB_POSTQUEUE;
@@ -2601,11 +3020,11 @@ static void arcmsr_hbaC_postqueue_isr(st
  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
  + ccb_cdb_phy);
  ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
- arcmsr_cdb);
+ iorb.arcmsr_cdb);
  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
  ? true : false;
  /* check if command done with no error */
- arcmsr_drain_donequeue(acb, ccb, error);
+ arcmsr_drain_donequeue(acb, ccb, error, 0);
  throttling++;
  if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
  writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
@@ -2645,10 +3064,10 @@ static void arcmsr_hbaD_postqueue_isr(st
  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
  + ccb_cdb_phy);
  ccb = container_of(arcmsr_cdb,
- struct CommandControlBlock, arcmsr_cdb);
+ struct CommandControlBlock, iorb.arcmsr_cdb);
  error = (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
  ? true : false;
- arcmsr_drain_donequeue(acb, ccb, error);
+ arcmsr_drain_donequeue(acb, ccb, error, 0);
  writel(doneq_index, pmu->outboundlist_read_pointer);
  } while ((doneq_index & 0xFFF) !=
  (outbound_write_pointer & 0xFFF));
@@ -2676,7 +3095,7 @@ static void arcmsr_hbaE_postqueue_isr(st
  ccb = acb->pccb_pool[cmdSMID];
  error = (acb->pCompletionQ[doneq_index].cmdFlag
  & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
- arcmsr_drain_donequeue(acb, ccb, error);
+ arcmsr_drain_donequeue(acb, ccb, error, 0);
  doneq_index++;
  if (doneq_index >= acb->completionQ_entry)
  doneq_index = 0;
@@ -2689,7 +3108,7 @@ static void arcmsr_hbaE_postqueue_isr(st
 static void arcmsr_hbaF_postqueue_isr(struct AdapterControlBlock *acb)
 {
  uint32_t doneq_index;
- uint16_t cmdSMID;
+ uint16_t cmdSMID, cmdLMID;
  int error;
  struct MessageUnit_F __iomem *phbcmu;
  struct CommandControlBlock *ccb;
@@ -2702,11 +3121,13 @@ static void arcmsr_hbaF_postqueue_isr(st
  cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
  if (cmdSMID == 0xffff)
  break;
+ cmdLMID = acb->pCompletionQ[doneq_index].cmdLMID;
  ccb = acb->pccb_pool[cmdSMID];
  error = (acb->pCompletionQ[doneq_index].cmdFlag &
  ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
- arcmsr_drain_donequeue(acb, ccb, error);
+ arcmsr_drain_donequeue(acb, ccb, error, cmdLMID);
  acb->pCompletionQ[doneq_index].cmdSMID = 0xffff;
+ acb->pCompletionQ[doneq_index].cmdLMID = 0;
  doneq_index++;
  if (doneq_index >= acb->completionQ_entry)
  doneq_index = 0;
@@ -2716,14 +3137,6 @@ static void arcmsr_hbaF_postqueue_isr(st
  spin_unlock_irqrestore(&acb->doneq_lock, flags);
 }

-/*
-**********************************************************************************
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for
the current adapter config.
-** We want this in order to compare the drivemap so that we can
detect newly-attached drives.
-**********************************************************************************
-*/
 static void arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg  = acb->pmuA;
@@ -2732,6 +3145,7 @@ static void arcmsr_hbaA_message_isr(stru
  if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
  schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
+
 static void arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_B *reg  = acb->pmuB;
@@ -2741,20 +3155,13 @@ static void arcmsr_hbaB_message_isr(stru
  if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
  schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-/*
-**********************************************************************************
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for the
-** current adapter config.
-** We want this in order to compare the drivemap so that we can
detect newly-attached drives.
-**********************************************************************************
-*/
+
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_C __iomem *reg  = acb->pmuC;
  /*clear interrupt and message state*/
- writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);
+ writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+   &reg->outbound_doorbell_clear);
  if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
  schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
@@ -2966,7 +3373,6 @@ static void arcmsr_iop_parking(struct Ad
  }
 }

-
 void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb)
 {
  uint32_t i;
@@ -3034,7 +3440,8 @@ static int arcmsr_iop_message_xfer(struc
  if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
  unsigned int tail = acb->rqbuf_getIndex;
  unsigned int head = acb->rqbuf_putIndex;
- unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail, ARCMSR_MAX_QBUFFER);
+ unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail,
+  ARCMSR_MAX_QBUFFER);

  allxfer_len = CIRC_CNT(head, tail, ARCMSR_MAX_QBUFFER);
  if (allxfer_len > ARCMSR_API_DATA_BUFLEN)
@@ -3044,9 +3451,11 @@ static int arcmsr_iop_message_xfer(struc
  memcpy(ptmpQbuffer, acb->rqbuffer + tail, allxfer_len);
  else {
  memcpy(ptmpQbuffer, acb->rqbuffer + tail, cnt_to_end);
- memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer, allxfer_len - cnt_to_end);
+ memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer,
+   allxfer_len - cnt_to_end);
  }
- acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len) %
ARCMSR_MAX_QBUFFER;
+ acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len)
+ % ARCMSR_MAX_QBUFFER;
  }
  memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
  allxfer_len);
@@ -3244,7 +3653,8 @@ message_out:
  return retvalue;
 }

-static struct CommandControlBlock *arcmsr_get_freeccb(struct
AdapterControlBlock *acb)
+static struct CommandControlBlock *arcmsr_get_freeccb(
+ struct AdapterControlBlock *acb)
 {
  struct list_head *head;
  struct CommandControlBlock *ccb = NULL;
@@ -3316,7 +3726,8 @@ static void arcmsr_handle_virtual_comman
 static enum scsi_qc_status arcmsr_queue_command_lck(struct scsi_cmnd *cmd)
 {
  struct Scsi_Host *host = cmd->device->host;
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
+ host->hostdata;
  struct CommandControlBlock *ccb;
  int target = cmd->device->id;

@@ -3325,16 +3736,23 @@ static enum scsi_qc_status arcmsr_queue_
  scsi_done(cmd);
  return 0;
  }
+ if (acb->acb_flags & (ACB_F_BUS_RESET | ACB_F_ABORT)) {
+ return SCSI_MLQUEUE_HOST_BUSY;
+ }
  cmd->host_scribble = NULL;
  cmd->result = 0;
- if (target == 16) {
+ if (target == ARCMSR_VIRTUAL_DEVICE_ID) {
  /* virtual device for iop message transfer */
  arcmsr_handle_virtual_command(acb, cmd);
  return 0;
  }
+ if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding) {
+ return SCSI_MLQUEUE_HOST_BUSY;
+ }
  ccb = arcmsr_get_freeccb(acb);
- if (!ccb)
+ if (!ccb) {
  return SCSI_MLQUEUE_HOST_BUSY;
+ }
  if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
  cmd->result = (DID_ERROR << 16) | SAM_STAT_RESERVATION_CONFLICT;
  scsi_done(cmd);
@@ -3357,7 +3775,8 @@ static int arcmsr_sdev_configure(struct
  return 0;
 }

-static void arcmsr_get_adapter_config(struct AdapterControlBlock
*pACB, uint32_t *rwbuffer)
+static void arcmsr_get_adapter_config(struct AdapterControlBlock *pACB,
+  uint32_t *rwbuffer)
 {
  int count;
  uint32_t *acb_firm_model = (uint32_t *)pACB->firm_model;
@@ -3411,8 +3830,8 @@ static bool arcmsr_hbaA_get_config(struc
  arcmsr_wait_firmware_ready(acb);
  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
  if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
- miscellaneous data' timeout \n", acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+ "miscellaneous data' timeout \n", acb->host->host_no);
  return false;
  }
  arcmsr_get_adapter_config(acb, reg->message_rwbuffer);
@@ -3425,13 +3844,14 @@ static bool arcmsr_hbaB_get_config(struc
  arcmsr_wait_firmware_ready(acb);
  writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
- printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb->host->host_no);
+ printk(KERN_ERR "arcmsr%d: can't set driver mode.\n",
+   acb->host->host_no);
  return false;
  }
  writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
- miscellaneous data' timeout \n", acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+ "miscellaneous data' timeout \n", acb->host->host_no);
  return false;
  }
  arcmsr_get_adapter_config(acb, reg->message_rwbuffer);
@@ -3444,7 +3864,7 @@ static bool arcmsr_hbaC_get_config(struc
  struct MessageUnit_C __iomem *reg = pACB->pmuC;

  /* disable all outbound interrupt */
- intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
+ intmask_org = readl(&reg->host_int_mask);
  writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
  /* wait firmware ready */
  arcmsr_wait_firmware_ready(pACB);
@@ -3453,8 +3873,8 @@ static bool arcmsr_hbaC_get_config(struc
  writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
  /* wait message ready */
  if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
- miscellaneous data' timeout \n", pACB->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+ "miscellaneous data' timeout \n", pACB->host->host_no);
  return false;
  }
  arcmsr_get_adapter_config(pACB, reg->msgcode_rwbuffer);
@@ -3489,7 +3909,7 @@ static bool arcmsr_hbaE_get_config(struc
  uint32_t intmask_org;

  /* disable all outbound interrupt */
- intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
+ intmask_org = readl(&reg->host_int_mask);
  writel(intmask_org | ARCMSR_HBEMU_ALL_INTMASKENABLE, &reg->host_int_mask);
  /* wait firmware ready */
  arcmsr_wait_firmware_ready(pACB);
@@ -3515,7 +3935,7 @@ static bool arcmsr_hbaF_get_config(struc
  uint32_t intmask_org;

  /* disable all outbound interrupt */
- intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
+ intmask_org = readl(&reg->host_int_mask);
  writel(intmask_org | ARCMSR_HBEMU_ALL_INTMASKENABLE, &reg->host_int_mask);
  /* wait firmware ready */
  arcmsr_wait_firmware_ready(pACB);
@@ -3526,7 +3946,8 @@ static bool arcmsr_hbaF_get_config(struc
  writel(pACB->out_doorbell, &reg->iobound_doorbell);
  /* wait message ready */
  if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
- pr_notice("arcmsr%d: wait get adapter firmware miscellaneous data timeout\n",
+ pr_notice("arcmsr%d: wait get adapter firmware "
+              "miscellaneous data timeout\n",
   pACB->host->host_no);
  return false;
  }
@@ -3584,7 +4005,8 @@ static int arcmsr_hbaA_polling_ccbdone(s

 polling_hba_ccb_retry:
  poll_count++;
- outbound_intstatus = readl(&reg->outbound_intstatus) &
acb->outbound_int_enable;
+ outbound_intstatus = readl(&reg->outbound_intstatus) &
+ acb->outbound_int_enable;
  writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
  while (1) {
  if ((flag_ccb = readl(&reg->outbound_queueport)) == 0xFFFFFFFF) {
@@ -3604,11 +4026,13 @@ polling_hba_ccb_retry:
  if (acb->cdb_phyadd_hipart)
  ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
+ ccb = container_of(arcmsr_cdb,
+   struct CommandControlBlock, iorb.arcmsr_cdb);
  poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
  if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
  if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
- printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
+ printk(KERN_NOTICE "arcmsr%d: scsi id = %d"
+                    " lun = %d ccb = '0x%p'"
  " poll command abort successfully \n"
  , acb->host->host_no
  , ccb->pcmd->device->id
@@ -3620,14 +4044,14 @@ polling_hba_ccb_retry:
  }
  printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
  " command done ccb = '0x%p'"
- "ccboutstandingcount = %d \n"
+ " ccboutstandingcount = %d \n"
  , acb->host->host_no
  , ccb
  , atomic_read(&acb->ccboutstandingcount));
  continue;
  }
  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
- arcmsr_report_ccb_state(acb, ccb, error);
+ arcmsr_report_ccb_state(acb, ccb, error, 0);
  }
  return rtn;
 }
@@ -3673,11 +4097,13 @@ polling_hbb_ccb_retry:
  if (acb->cdb_phyadd_hipart)
  ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
+ ccb = container_of(arcmsr_cdb,
+   struct CommandControlBlock, iorb.arcmsr_cdb);
  poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
  if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
  if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
- printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
+ printk(KERN_NOTICE "arcmsr%d: scsi id = %d"
+                    " lun = %d ccb = '0x%p'"
  " poll command abort successfully \n"
  ,acb->host->host_no
  ,ccb->pcmd->device->id
@@ -3689,14 +4115,14 @@ polling_hbb_ccb_retry:
  }
  printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
  " command done ccb = '0x%p'"
- "ccboutstandingcount = %d \n"
+ " ccboutstandingcount = %d \n"
  , acb->host->host_no
  , ccb
  , atomic_read(&acb->ccboutstandingcount));
  continue;
  }
  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
- arcmsr_report_ccb_state(acb, ccb, error);
+ arcmsr_report_ccb_state(acb, ccb, error, 0);
  }
  return rtn;
 }
@@ -3716,7 +4142,8 @@ static int arcmsr_hbaC_polling_ccbdone(s
 polling_hbc_ccb_retry:
  poll_count++;
  while (1) {
- if ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
+ if ((readl(&reg->host_int_status) &
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
  if (poll_ccb_done) {
  rtn = SUCCESS;
  break;
@@ -3734,12 +4161,14 @@ polling_hbc_ccb_retry:
  if (acb->cdb_phyadd_hipart)
  ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
+ pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
+ iorb.arcmsr_cdb);
  poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
  /* check ifcommand done with no error*/
  if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
  if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
- printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
+ printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d"
+                    " ccb = '0x%p'"
  " poll command abort successfully \n"
  , acb->host->host_no
  , pCCB->pcmd->device->id
@@ -3751,14 +4180,14 @@ polling_hbc_ccb_retry:
  }
  printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
  " command done ccb = '0x%p'"
- "ccboutstandingcount = %d \n"
+ " ccboutstandingcount = %d \n"
  , acb->host->host_no
  , pCCB
  , atomic_read(&acb->ccboutstandingcount));
  continue;
  }
  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
- arcmsr_report_ccb_state(acb, pCCB, error);
+ arcmsr_report_ccb_state(acb, pCCB, error, 0);
  }
  return rtn;
 }
@@ -3808,7 +4237,7 @@ polling_hbaD_ccb_retry:
  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
  ccb_cdb_phy);
  pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
- arcmsr_cdb);
+ iorb.arcmsr_cdb);
  poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
  if ((pCCB->acb != acb) ||
  (pCCB->startdone != ARCMSR_CCB_START)) {
@@ -3834,7 +4263,7 @@ polling_hbaD_ccb_retry:
  }
  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
  ? true : false;
- arcmsr_report_ccb_state(acb, pCCB, error);
+ arcmsr_report_ccb_state(acb, pCCB, error, 0);
  }
  return rtn;
 }
@@ -3902,7 +4331,73 @@ static int arcmsr_hbaE_polling_ccbdone(s
  }
  error = (acb->pCompletionQ[doneq_index].cmdFlag &
  ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
- arcmsr_report_ccb_state(acb, pCCB, error);
+ arcmsr_report_ccb_state(acb, pCCB, error, cmdSMID);
+ }
+ writel(doneq_index, &reg->reply_post_consumer_index);
+ return rtn;
+}
+
+static int arcmsr_hbaF_polling_ccbdone(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *poll_ccb)
+{
+ bool error;
+ uint32_t poll_ccb_done = 0, poll_count = 0, doneq_index;
+ uint16_t cmdSMID, cmdLMID;
+ unsigned long flags;
+ int rtn;
+ struct CommandControlBlock *pCCB;
+ struct MessageUnit_F __iomem *reg = acb->pmuF;
+
+ while (poll_ccb_done == 0) {
+ spin_lock_irqsave(&acb->doneq_lock, flags);
+ doneq_index = acb->doneq_index;
+ cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
+ if (cmdSMID == 0xffff) {
+ spin_unlock_irqrestore(&acb->doneq_lock, flags);
+ msleep(25);
+ if (++poll_count > 40) {
+ rtn = FAILED;
+ break;
+ }
+ continue;
+ }
+ cmdLMID = acb->pCompletionQ[doneq_index].cmdLMID;
+ pCCB = acb->pccb_pool[cmdSMID];
+ acb->pCompletionQ[doneq_index].cmdSMID = 0xFFFF;
+ acb->pCompletionQ[doneq_index].cmdLMID = 0;
+ error = (acb->pCompletionQ[doneq_index].cmdFlag &
+ ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+ doneq_index++;
+ if (doneq_index >= acb->completionQ_entry)
+ doneq_index = 0;
+ acb->doneq_index = doneq_index;
+ spin_unlock_irqrestore(&acb->doneq_lock, flags);
+ poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
+ if (poll_ccb_done)
+ rtn = SUCCESS;
+ /* check if command done with no error*/
+ if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
+ if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
+ printk(KERN_NOTICE "arcmsr%d: scsi id = %d "
+ "lun = %d ccb = '0x%p' polling a done "
+ "ccb, abort successfully\n"
+ , acb->host->host_no
+ , pCCB->pcmd->device->id
+ , (u32)pCCB->pcmd->device->lun
+ , pCCB);
+ pCCB->pcmd->result = DID_ABORT << 16;
+ arcmsr_ccb_complete(pCCB);
+ continue;
+ }
+ printk(KERN_NOTICE "arcmsr%d: polling an aborted and "
+ "free ccb, just back ccb = '0x%p' "
+ "ccboutstandingcount = %d \n"
+ , acb->host->host_no
+ , pCCB
+ , atomic_read(&acb->ccboutstandingcount));
+ continue;
+ }
+ arcmsr_report_ccb_state(acb, pCCB, error, cmdLMID);
  }
  writel(doneq_index, &reg->reply_post_consumer_index);
  return rtn;
@@ -3927,9 +4422,11 @@ static int arcmsr_polling_ccbdone(struct
  rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
  break;
  case ACB_ADAPTER_TYPE_E:
- case ACB_ADAPTER_TYPE_F:
  rtn = arcmsr_hbaE_polling_ccbdone(acb, poll_ccb);
  break;
+ case ACB_ADAPTER_TYPE_F:
+ rtn = arcmsr_hbaF_polling_ccbdone(acb, poll_ccb);
+ break;
  }
  return rtn;
 }
@@ -3988,7 +4485,8 @@ static void arcmsr_set_iop_datetime(stru
  writel(datetime.b.msg_time[0], &reg->msgcode_rwbuffer[0]);
  writel(datetime.b.msg_time[1], &reg->msgcode_rwbuffer[1]);
  writel(ARCMSR_INBOUND_MESG0_SYNC_TIMER, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+   &reg->inbound_doorbell);
  break;
  }
  case ACB_ADAPTER_TYPE_D: {
@@ -4046,7 +4544,7 @@ static int arcmsr_iop_confirm(struct Ada
  case ACB_ADAPTER_TYPE_E:
  case ACB_ADAPTER_TYPE_F:
  dma_coherent_handle = acb->dma_coherent_handle +
- offsetof(struct CommandControlBlock, arcmsr_cdb);
+ offsetof(struct CommandControlBlock, iorb);
  break;
  default:
  dma_coherent_handle = acb->dma_coherent_handle;
@@ -4066,14 +4564,14 @@ static int arcmsr_iop_confirm(struct Ada
  case ACB_ADAPTER_TYPE_A: {
  if (cdb_phyaddr_hi32 != 0) {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- writel(ARCMSR_SIGNATURE_SET_CONFIG, \
+ writel(ARCMSR_SIGNATURE_SET_CONFIG,
  &reg->message_rwbuffer[0]);
  writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
- writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
+ writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
  &reg->inbound_msgaddr0);
  if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
- part physical address timeout\n",
+ printk(KERN_NOTICE "arcmsr%d: set ccb high"
+ " part physical address timeout\n",
  acb->host->host_no);
  return 1;
  }
@@ -4089,7 +4587,7 @@ static int arcmsr_iop_confirm(struct Ada
  reg->doneq_index = 0;
  writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: cannot set driver mode\n", \
+ printk(KERN_NOTICE "arcmsr%d: cannot set driver mode\n",
  acb->host->host_no);
  return 1;
  }
@@ -4107,8 +4605,8 @@ static int arcmsr_iop_confirm(struct Ada

  writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
- timeout \n",acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: 'set command Q window' "
+ "timeout \n",acb->host->host_no);
  return 1;
  }
  writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
@@ -4127,10 +4625,11 @@ static int arcmsr_iop_confirm(struct Ada
  writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);
  writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
  writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+   &reg->inbound_doorbell);
  if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
- timeout \n", acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: 'set command Q window' "
+ "timeout \n", acb->host->host_no);
  return 1;
  }
  }
@@ -4162,8 +4661,10 @@ static int arcmsr_iop_confirm(struct Ada
  writel(cdb_phyaddr, &reg->msgcode_rwbuffer[2]);
  writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[3]);
  writel(acb->ccbsize, &reg->msgcode_rwbuffer[4]);
- writel(lower_32_bits(acb->dma_coherent_handle2), &reg->msgcode_rwbuffer[5]);
- writel(upper_32_bits(acb->dma_coherent_handle2), &reg->msgcode_rwbuffer[6]);
+ writel(lower_32_bits(acb->dma_coherent_handle2),
+   &reg->msgcode_rwbuffer[5]);
+ writel(upper_32_bits(acb->dma_coherent_handle2),
+   &reg->msgcode_rwbuffer[6]);
  writel(acb->ioqueue_size, &reg->msgcode_rwbuffer[7]);
  writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
  acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
@@ -4267,7 +4768,8 @@ static void arcmsr_request_device_map(st
 {
  struct AdapterControlBlock *acb = timer_container_of(acb, t,
      eternal_timer);
- if (acb->acb_flags & (ACB_F_MSG_GET_CONFIG | ACB_F_BUS_RESET | ACB_F_ABORT)) {
+ if (acb->acb_flags & (ACB_F_MSG_GET_CONFIG |
+ ACB_F_BUS_RESET | ACB_F_ABORT)) {
  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
  } else {
  acb->fw_flag = FW_NORMAL;
@@ -4285,7 +4787,8 @@ static void arcmsr_request_device_map(st
  case ACB_ADAPTER_TYPE_C: {
  struct MessageUnit_C __iomem *reg = acb->pmuC;
  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+   &reg->inbound_doorbell);
  break;
  }
  case ACB_ADAPTER_TYPE_D: {
@@ -4327,8 +4830,8 @@ static void arcmsr_hbaA_start_bgrb(struc
  acb->acb_flags |= ACB_F_MSG_START_BGRB;
  writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
  if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
- rebuild' timeout \n", acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background "
+ "rebuild' timeout \n", acb->host->host_no);
  }
 }

@@ -4338,8 +4841,8 @@ static void arcmsr_hbaB_start_bgrb(struc
  acb->acb_flags |= ACB_F_MSG_START_BGRB;
  writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
- rebuild' timeout \n",acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background "
+ "rebuild' timeout \n",acb->host->host_no);
  }
 }

@@ -4350,8 +4853,8 @@ static void arcmsr_hbaC_start_bgrb(struc
  writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
  writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &phbcmu->inbound_doorbell);
  if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
- rebuild' timeout \n", pACB->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background "
+ "rebuild' timeout \n", pACB->host->host_no);
  }
  return;
 }
@@ -4428,7 +4931,8 @@ static void arcmsr_clear_doorbell_queue_
  msleep(20);
  outbound_doorbell = readl(reg->iop2drv_doorbell);
  if( outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
- writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+ writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+   reg->iop2drv_doorbell);
  writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
  } else
  break;
@@ -4533,7 +5037,8 @@ static void arcmsr_hardware_reset(struct
  struct MessageUnit_D *pmuD = acb->pmuD;

  /* backup pci config data */
- printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",
acb->host->host_no);
+ printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",
+   acb->host->host_no);
  for (i = 0; i < 64; i++) {
  pci_read_config_byte(acb->pdev, i, &value[i]);
  }
@@ -4549,7 +5054,8 @@ static void arcmsr_hardware_reset(struct
  writel(0x2, &pmuC->write_sequence);
  writel(0x7, &pmuC->write_sequence);
  writel(0xD, &pmuC->write_sequence);
- } while (((readl(&pmuC->host_diagnostic) &
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
+ } while (((readl(&pmuC->host_diagnostic) &
+ ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
  writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
  } else if (acb->dev_id == 0x1884) {
  struct MessageUnit_E __iomem *pmuE = acb->pmuE;
@@ -4809,7 +5315,7 @@ static const char *arcmsr_info(struct Sc
  break;
  case PCI_DEVICE_ID_ARECA_1886_0:
  case PCI_DEVICE_ID_ARECA_1886:
- type = "NVMe/SAS/SATA";
+ type = "SAS/SATA/NVMe(Tri-Mode)";
  break;
  default:
  type = "unknown";
diff -Naurp a/drivers/scsi/arcmsr/Makefile b/drivers/scsi/arcmsr/Makefile
--- a/drivers/scsi/arcmsr/Makefile 2026-10-30 20:09:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/Makefile 2026-11-09 11:27:16.850592000 +0800
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # File: drivers/arcmsr/Makefile
-# Makefile for the ARECA PCI-X PCI-EXPRESS SATA RAID controllers SCSI driver.
+# Makefile for the ARECA PCI-X PCI-E SATA/SAS/NVMe(Tri-Mode) RAID
Controllers SCSI driver.

 arcmsr-objs := arcmsr_attr.o arcmsr_hba.o

--- a/drivers/scsi/Kconfig 2026-10-30 20:09:52.000000000 +0800
+++ b/drivers/scsi/Kconfig 2026-11-09 16:13:51.209789109 +0800
@@ -483,10 +483,10 @@ config SCSI_ADVANSYS
   module will be called advansys.

 config SCSI_ARCMSR
- tristate "ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Adapter"
+ tristate "ARECA SAS/SATA/NVMe(Tri-Mode) RAID Controller support"
  depends on PCI && SCSI
  help
-  This driver supports all of ARECA's SATA/SAS RAID controller cards.
+  This driver supports all of ARECA's SATA/SAS/NVMe RAID controller cards.
   This is an ARECA-maintained driver by Erich Chen.
   If you have any problems, please mail to: <erich@areca.com.tw>.
   Areca supports Linux RAID config tools.
