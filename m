Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792901150;
	b=w2X+S0K9cozlVvQzeLFlYBnLKQiHH+EjGRV+vmd3UW/ZKxDR1CNJRHgWTAOgixU0k1+Y
	 mO3DanKp6qYCYCyiKaQ6ZPrDCi5km+WOF7HEXbenth2aICp+sCbj9eLmwibM+O4d09e5Z
	 LbBiMNDg5KxJpj7pse/S2ddUpAQsusAwOpuNHEgGMTop3zQLXc7QK/Cb5txwCsBg13hZf
	 iOxrqXhWxIJrUf5N6yME1ch8tT1qbGCdI+cAz0M5gb/ZKGK2Z+EahkEPIRPOpaPTpfjXZ
	 MMgkROqZWHT9Z9m/cBbwUwLdxaq/aPPLuN5UKkhSM3YpBDqPUZAKchvcxlTNbBaEhFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792901150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=0cuMz1MDHOti95RZ27fXrtLxizKDrAyOId+Yv71GfZw=;
	b=WqnhhasGH9C/l+mIaUH8e4gE0LLAZ/6++qa2OwwhcEmRpaRkB1qwNaBMOL91hSko5gMi
	 BKCaT45uAEdK3kDWT3epgq28YpGK+OMuwPJuRhUPRoUn9jbLgMd9rxKu3tqSYxn2ut6Eq
	 3VjHTbqT86n9OdeHvC6kFhGwu3T7TXYEPvCLReKx6J7gQTDAgxl6FmrlQ7cx2l3WGYc8c
	 aiYm+WLG8PB5YCg+NzlxFzi8Rb7zBIi/YaDwd1QnX1vwts7nHggB/2ajonGFyMoE4BYja
	 m5TY9nq3ysbhoL2Qo4x5ztHGehahlheus/mwPJTG/MDraru6EVVD1yOfS0V5UXUhKTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ULirjY6O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25B6606A31A
	for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 04:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25B6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ULirjY6O
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c423b145922so265310666b.3
        for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 21:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792901148; cv=none;
        d=google.com; s=arc-20260327;
        b=aY/Ps2PaQxbPmtSe1PQpQYzpHAJetjstKuJpqEvzrsVL9FB0nCaWkZcWj2eFzBLEt1
         CCzPL2OXWHTVhWorZ32vdee5ZHYmz3TxGwKRD4lEYeH6gbVgyJHTsE+Pffa1iFO7m6t9
         Z4MO2Pna0wp918Kv+FvPpgC5oOOe+EtoA+EDYO7GzQVg0qRGgZ403401qbGNcb3t17SK
         Wao4F8n+sQqZfW6jY776IfLQXpw6dbdhO6Gos2CZZ1CjkDrAJyRdyjtzPKaMH6wEwYI9
         54lfhMt00xzbOnN5No1krClPYzRpbQdkeVEF7XTzb+Kr/w5VygT1sIYItX6DFo+bZIAm
         jRaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=0cuMz1MDHOti95RZ27fXrtLxizKDrAyOId+Yv71GfZw=;
        fh=+AcXWNxfjLoTuj8nvmevsWcRCdpqy6Sp3EHwLVsU19E=;
        b=X3Q+8OcMo5AQGZhwkWHmr+9xyty3Q5uYpotyxpMqoONWCI4pwTrq5n2AIqdKcDzOzF
         4328k1zlamF0TFMC/r/fbKqKYcbM10JdfmiLpXkzPG788l2ilAjsxMA/jMF/qTcCaPIA
         6chv4FiI1kD4TyRB2aQ8Dv6DBITfJQpUpboFMtKYDFL3pZ+PMVuVQBhGPiKAVnp3kb/N
         5Wo/CEmHw5yBGt0XVt7uURXzwbPrevr0d4ANQ0wX1VTy5txKZ9SauOOApcBHJ0VK3nHk
         0Ffgtpz7qy4o8P8xJMe8LSQoQs+/Hf3YQCMxFT2MtZuuZr47NAygjPkjykQdrZdxQ26G
         0ccQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792901148; x=1793505948; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0cuMz1MDHOti95RZ27fXrtLxizKDrAyOId+Yv71GfZw=;
        b=ULirjY6OZEb/K+9PPk4fpoLeQ/4S0Va+20SbQDWI+fFYbwfq1HZLpcixjmx9BgUeb6
         usL5E16qD4ECaLFZHPb2TTcend4mGVH8w4vdYildQSN6cIKbHk/eTnOYvVE+LVChbJeR
         OzAtyJAXo8ynFTFLjgjFVKjJHHeMFWpSsT2ijw0X69a/v1fz1bIv7/WoQ901sb7Vn8kZ
         +xMz48jvPMiBYL6lXOLYmXfIrOPMrscrQnb/wUX6/fI2YP9eGfDmVUSvvHjoH/tvYVno
         efF2QEhMckA5DipHDIceC1DYAZKDu+XCt1jESomlTGkLLCZhcRuYQu5eZ7Vrrel/nCI5
         dKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792901148; x=1793505948;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0cuMz1MDHOti95RZ27fXrtLxizKDrAyOId+Yv71GfZw=;
        b=hJqWckWdc6Qefa2DC3QOIQ/V7kx+2cvCezqQ+EjgJDov79a9Ai25BGiKQcxwHNUmiV
         XQcgi22P4V1x2caEPmn+5eDiQ1sk2IT5s4Mg5IbOTwZf5GcEQWWsmBaS79k+E5lKZFea
         HdCHLSbpB3Ve8/2K04E3eCyzvGY1R4CD3P3gzFT+i8sBMmzlllkqIEajFfpZnIslMlQu
         /DIivQDHx25QsR7fqfQyxVxiUmfAH+myQA1wP5k0/PsSD8+BeMiYwaaSHN83urmjZjN0
         eO8nmEc+OOGamw2gf+TbS1SUGidYxd/MaEo2p6Tjj3T0cyQp3eTNJUQx5SZhWwZ2yTnh
         4/bg==
X-Gm-Message-State: AFq9FYLZxJtThJhk7K9/dH+x49kZOq8Try5EtX0UfUxrb9xnDXbjyTUT
	oMiC9jQ7OoY8OXoRGFJEXjem12FoG7Abkgz9pFUQLS/9HnBg6uOm8czhzBuv1apTiQ2oT+J9DZz
	Gy1mTw4g0Gzg/80lhzRusC0qXfMqOMtyRCD4L
X-Gm-Gg: AYBFou3nWLYntRGyZLCsfKmYYVyWJUIyzu5d0cUwtBs2u9o3Xlu/5I347nj6U2uM7V1
	Rk3cnBNZAbbDveiboxubAvwcI1vUabq/RBNh+M6UBnIlz7jFGuGuvtTRQAuO5ijaECoFBz261aL
	HnOgBTeUbhnx/UYdID/Z0lu0bVGBzN/51knIIaZt1A/0j6VG34pSQHoJEYmeDc2cPB7QaAJZFzE
	Z/vwwZ/ieEKmykfvfEmBnnPzcpcisjOagdmQp0/ygmBLX5joLDU9isDjy3W0CEu3kJbSVOSo3jY
	Maq9CfD5GiVRVL7TXz/wuIb8tsTcAJ79ROE4Qo9DOrzhfW22BTbu7nFCz6fDlWboB9J0/Pla7z1
	1knbBQMsR1kugvEpxbQKqwW6PYwPU931eTw8iFaURxs39g3kHG7e+Gj1EUWPdIXgvAhntaNI=
X-Received: by 2002:a17:907:930a:b0:c46:645f:cee1 with SMTP id
 a640c23a62f3a-c46bde93b2fmr391028066b.42.1792901148102; Sat, 24 Oct 2026
 21:05:48 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Maholi Tumanggor <maholitumanggor@gmail.com>
Date: Sun, 25 Oct 2026 11:05:38 +0700
X-Gm-Features: AclHuK989yYmf6N8c6uAn2VMIZOYtDLWLEyaPmK2FkC2tN38Bkk8v4i6hElRkRY
Message-ID: <CAELScTbAp2ERF9d_dc9GsPmjH_Y4VqN6VJzb3jTwskH7nzv_XA@mail.gmail.com>
Subject: [BUG] drivers/message/fusion/mptctl: heap buffer overflow in kbuf_alloc_2_sgl
To: linux-scsi@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

Reported-by: Maholi Tumanggor [maholitumanggor@gmail.com]

AFFECTED FILE
=============
drivers/message/fusion/mptctl.c
Verified identical in mainline (84738 bytes):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/drivers/message/fusion/mptctl.c

Tested on: Linux 6.12.38+kali-amd64, mptctl driver version 3.04.20
Hardware:  LSI 53c1030 PCI-X Fusion-MPT (VirtualBox emulated)


DESCRIPTION
===========
Function kbuf_alloc_2_sgl() in mptctl.c allocates a buflist array of
74 bytes via kzalloc(MAX_SGL_BYTES / 8), then writes struct buflist
entries (16 bytes each on 64-bit: u8 pointer + int + padding) into it
without any bounds check on the index buflist_ent.

This gives a maximum of 4 safe entries (74 / 16 = 4). Each entry
corresponds to one 128KB DMA chunk (MAX_KMALLOC_SZ). When the
MPTFWDOWNLOAD ioctl is called with fwlen greater than 524288 bytes
(4 x 128KB), buflist_ent reaches 4 and subsequent iterations write
past the end of the heap allocation.

Relevant code (around line 1031):

    i = MAX_SGL_BYTES / 8;           /* = 74 bytes */
    buflist = kzalloc(i, GFP_USER);  /* max 4 entries on 64-bit */
    ...
    while (bytes_allocd < bytes) {
        buflist[buflist_ent].len  = this_alloc;        /* NO BOUNDS CHECK */
        buflist[buflist_ent].kptr = dma_alloc_coherent(...);
        buflist_ent++;
    }


REPRODUCER
==========
Trigger condition:
- Root privileges required
- /dev/mptctl accessible (mknod /dev/mptctl c 10 220)
- CONFIG_FUSION_CTL enabled
- MPTFWDOWNLOAD ioctl with fwlen = 524289 (512KB + 1 byte)

Minimal C reproducer (available on maintainer request per guidelines):

    struct mpt_fw_xfer {
        unsigned int iocnum;
        unsigned int fwlen;
        void *bufp;
    };
    #define MPTFWDOWNLOAD _IOWR('m', 15, struct mpt_fw_xfer)

    char *buf = calloc(1, 524289);
    struct mpt_fw_xfer req = { .iocnum=0, .fwlen=524289, .bufp=buf };
    int fd = open("/dev/mptctl", O_RDWR);
    ioctl(fd, MPTFWDOWNLOAD, &req);


OBSERVED BEHAVIOR (dmesg on live system)
=========================================
    mptctl: ioc0: WARNING - -SG: No can do - Chain required!
    mptctl: WARNING - (freeing 11 frags)

11 iterations confirm 7 out-of-bounds writes past the 74-byte
buflist allocation. No kernel crash was observed, indicating silent
heap corruption. Each OOB write places a DMA address (8 bytes) and
buffer length (4 bytes) into adjacent kernel heap memory.


PROPOSED FIX
============
Add a bounds check before each buflist[] access in kbuf_alloc_2_sgl():

--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1028,6 +1028,7 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset,
        int              sg_spill = MAX_FRAGS_SPILL1;
        int              dir;
+       int              max_buflist_ent = (MAX_SGL_BYTES / 8) /
+                                          sizeof(struct buflist);

        if (bytes < 0)
                return NULL;
@@ -1063,6 +1063,10 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset,
        while (bytes_allocd < bytes) {
                this_alloc = min(alloc_sz, bytes-bytes_allocd);
+               if (buflist_ent >= max_buflist_ent) {
+                       printk(KERN_ERR "mptctl: buflist overflow\n");
+                       goto free_and_fail;
+               }
                buflist[buflist_ent].len = this_alloc;
                buflist[buflist_ent].kptr = dma_alloc_coherent(
                        &ioc->pcidev->dev,


CONDITIONS
==========
- Root access to /dev/mptctl required
- LSI Fusion MPT hardware or compatible emulation
- CONFIG_FUSION_CTL=y or =m
- 64-bit kernel (32-bit has different struct buflist size,
  threshold is higher but same bug exists)


IMPACT
======
Silent kernel heap corruption. The corrupted region receives DMA
addresses and lengths from dma_alloc_coherent(). No crash observed
on tested system, meaning corruption goes undetected and may affect
adjacent heap objects depending on kernel heap layout.
