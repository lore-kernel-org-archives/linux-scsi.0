Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335352;
	b=tRh0aQFwuOsu9asHM+C7gAaxtf28+4OEubxgmNJ/w85PsV5GXVRqaTztLgtnunLVJKzW
	 9Q7eemilJJRO01/riZMvhmcSoifIjoSnREu/zChIG9S2QT3XX6vynjbWtJVx/SVIch6xP
	 H2prLYdEQxx4tzlLOtn2yw8DPBVSus040SkK/6Ys1F6askAsAJwTkkCQFOlqYcXUF7ik/
	 dOs9OxZtxwr9xI9bAU6x/6rOekoZ4SKumYw3cj8qDdb+5361FU3GI/eWczSJCGth9X6nH
	 el8LcJZkfSZFQa6nHJ9oiesFs7aPzTUc5tA8q2j10MciZknkCreVc940yK9kKaqCwow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335352;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nOvo/M04E2I6xkzAUOHPFcPB0rs6jwLGU2nA3+JtmUc=;
	b=gcDkNMewZ+NOFBXgJy1wG/t7hEseqAaYybFHFLLkCGKKUExgHq2NEcJaJ3bwhXi4jGsM
	 YFWnC8WiHSr4itoVreeAYXYdurGhF/xVIOMEan3ruxsAZJtCHPdtMMq3iEOtF35AlmzCB
	 uZJAto9HabmmZGNEGRyJrnKKK/5f2HIYCUVSMkgNmZmIRH9s1/P785pt2a3q1urYr70C6
	 rUY27oi5omH7TRu6wXgkAC+w4bj6uu+rOBxtT6guhMzGFCf+zCkeAd+CCOCumTX9NXk/w
	 EyP0XGQ0K1+Mw3BcVyFqUc9EzHkEJKWdPAfZSBFHWi1HCEDxmgWt0crzpgPocGrabHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=ilehM0CG;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=C96d0oEA;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD5860A2636
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 18:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DD5860A2636
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=ilehM0CG;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=C96d0oEA
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAHYkvV1907256
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=nOvo
	/M04E2I6xkzAUOHPFcPB0rs6jwLGU2nA3+JtmUc=; b=ilehM0CGRfTOU9vGCzjQ
	m95IRNQXDmJnGlFjejrk1u2gRirLYm2cY7dy61M/hgWlaibYTORfQN5XvtnbwN3J
	kvMl5nTDPiClv3bMAC9c/dqv7ol+0KWVW4p9uNqSF3Wu0OSOBT/+ijFC8ZUYkscy
	nUE7HdhEaDufVt5a9qRQpLClhx9ervurGywYEyJJf4oCY6Kcg35tj0M3RMraPKoE
	y4dVv6b6i7crkI/NXMJIiDxuWAgkvV9hrdVUaC+Y+WyXBRv9Chpr902CV+L7v/Gj
	mrn0HSx30uf+6HsZjjPbItEg6KmItpF4qtVzvRTUM0HAvxicG+PgJsGpEDyWNURX
	IA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hv7nyrjn3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:29:04 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-542fc61841eso51326761cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 10:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794335344; x=1794940144; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nOvo/M04E2I6xkzAUOHPFcPB0rs6jwLGU2nA3+JtmUc=;
        b=C96d0oEAnMkE8Hw0jhWqyZP70E4jI47QGWY4+pA6K/iHQOpMgaFcLyg+9Pld2pITX2
         MOil4C+Yp9GPAchUT8752g/3Jp+yz+PnRDH+tTZ5DeVgvvOsc5Ub4D68bBUlbTizfsYw
         u0deJHiUYzA7bxEBJ4rlAyNoN9hRqpMaBzxWGfofU7NRlKlcFrvl8kejqdCdHz9dCutJ
         NU+EnookF/N8JDbxNB8yHFXTRb3Hgcz6tMlP1wRKA5+5mMUkfnoyg8fbXSPNwKHF4OrA
         hwdO+P5/USWwVrErdiSwBcWIR5R4O83JnJqJGBvuV0jVsbMtbbz2uvUHRqPgWvoam7fR
         4tFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335344; x=1794940144;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nOvo/M04E2I6xkzAUOHPFcPB0rs6jwLGU2nA3+JtmUc=;
        b=HuNVWkCr3qYi+5S72WbL/OmZR+fgkksWEWpxo3DW7QfAwGqYu+TAvGGL13eOnj1shN
         rMHnYPPXSm/PCIuz0iSPuD+FQ/WKAce2z5aKmIAxPjaV6x0D7eVPd7kIf8hr1DQnDkS7
         h9O8InPT6pmXXMS2/9pHLFVwMFcRC43dadnG09isimPETr1e/wrNO87cRexjVlw0Hcns
         3cVl72JSwuAHgkFTfFn0eJz4uDW2vAvpq1j6woG2AKFWmrtPg4IqgU+EU0nqDyqlEydg
         NnDAUKyCeKKIAea12jvt8Et+rPaj4OrzCEQdkTn4V6IwzQcyTMrcmtBkoXcWNFayhqno
         9Ygw==
X-Forwarded-Encrypted: i=1; AL+hErHLzWAWGe7eDkY+Kt+fQ9Chq0zEBD9Mol20RrQcRx7EMHT0a+6Unn+3IYmJ4Wm3JRqp3uRZObnRpLDj@vger.kernel.org
X-Gm-Message-State: APuU4Z+lYPYp5cxGX6FKC0IjD931vsIlIJEgiCCC8x00tp1I23aL9lJY
	YmgQcZnv4d6SZlF0fTMX5mgZsgE8tbf1BOa3bhliei8yT1u5TiXJ9m7JHQhtxFnKX5G0wXS7YNI
	xr4IPx/CZO0lugl88/Zo/BC8PreiM8bAcza1MFhNZk/Tpu6I7iWkyjlxn7Xk=
X-Gm-Gg: AYBFou1pcOC3PP5lMw2OqmcSNJ5TyVsNntfC/FtQadQwncdYYek1O7J5eyILfKHkCQo
	dkTeQi4tL6EA4hkBliVNssP9lCSca5Q2ZZM4cMtmkOPlnNhGLVTOTiHKZx+rUviV6bpBV+nDQyB
	S2ohwUs/1D1UZNzhUx/DaKl+qxvZBJtWa0XM7CDtGjBZ62YqfxFg3v9Pftklju2LC3Tpx8Imut4
	3bp8EqE19obD1xXLfofs8LA/UhBa7mxw6Z6fgfn4Y6ASk/pSMTnA/ndhNI+UycJyYCytI9aaHq2
	AonMjEW5r2AaTRUnPUZQ9zHAZ27V0JjwjwhEdRA+x1auNnbIokKlcH6u8Lywtp1NFex3uItTLv6
	KQa2o21d/d2kXjiCHYGQ6Dl+2ncewn8UsC/UUxhKkFc+Ld4vB97ViWgc0CKqIO2xbEX25iuNDl5
	p81lqyTea3bb17u1GwSlYM
X-Received: by 2002:a05:622a:5e0d:b0:536:719d:7974 with SMTP id d75a77b69052e-555283f3c18mr53051991cf.55.1794335343911;
        Tue, 10 Nov 2026 10:29:03 -0800 (PST)
X-Received: by 2002:a05:622a:5e0d:b0:536:719d:7974 with SMTP id d75a77b69052e-555283f3c18mr53051681cf.55.1794335343498;
        Tue, 10 Nov 2026 10:29:03 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-177-200.net.columbia.edu. [128.59.177.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef05493desm26986666d6.45.2026.11.10.10.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:29:02 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 10 Nov 2026 13:28:55 -0500
Subject: [PATCH 2/2] scsi: scsi_debug: generate protection information for
 writes without it
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-scsi-debug-pi-v1-2-539829902b3a@columbia.edu>
References: <20261110-scsi-debug-pi-v1-0-539829902b3a@columbia.edu>
In-Reply-To: <20261110-scsi-debug-pi-v1-0-539829902b3a@columbia.edu>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        John Garry <john.garry@linux.dev>,
        Luis Chamberlain <mcgrof@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794335340; l=5749;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VgRQqft2zbITDi2ZsgnRKYYve9Lrz8zjT/nqRz1KLos=;
 b=njvoi41HfYrlp7Ui/zKsZ12J/XPShGBhooy2lqbImM53+QcyI85oyztIBStwTFX+reZvxSOC3
 Q+aF2hmbSp8D5qoR4hG9TpTxGm727wDFpsP7XOmO3rGO0lHy+/d4ZdB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA3MyBTYWx0ZWRfXyMd0ntNp0tWl
 GfIXxcnXfw78suEqJtpl4os9C8sGJzruVeNGhwqKfHZ7fJu004NIH82XcSv6KDOyUC0lGrN+oeV
 MMIuwyornQT1A+pcTi/HukSGDfWLNDwXCZ8GTKPLBE3eyh4GEhKP
X-Proofpoint-ORIG-GUID: sViZQu-c_VKgUkxYorRc3uyNgvfmbtyP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA3MyBTYWx0ZWRfX5nHkgDNeY3kh
 iV3ux/AHh7OhDyqg3tY+2Qtej1xK4a1qJClYX/eQrwzVBh9QB9gsZW3w79sCIeLlEYgTFHk2IcQ
 rzGFLFCfacw1y2fc1Y7uyDkJBh/dt+0J00JBM8fx1yDW76r6b/z3tBlaE+rNHzdEuBJNCMtnonZ
 Ggoob+/jKudgWUkzVozq6o74xJBxQ8aQLry3FJErxJNm9zoNzdGn6vV8jIP73YbWYv5SWCCOjx+
 nLJxLUNqJFYsEE42VXRe0kZtwiLx/fGxoaxEeJXHcdvImrVO8fF0WVS/3+3DcwI4KL41Uq5HEVE
 LjOJ/x4WDxYFbCmF7T9R/YKwq5jnxEmGEyf3E/mxWjHx/fpV94OGMOmjSzrlQB5sOFiHScHtsQU
 +74Xllk04w5MSBtdStwXEqb8j+uawTx5vfGmUnR5mOMBfIu03SjotuESUjlJILtQZjR5Jkv9tQc
 vHCjGrmC1XmokVZiR0Q==
X-Authority-Analysis: v=2.4 cv=Vc5ir1p9 c=1 sm=1 tr=0 ts=6af36270 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=OksKZPe/0gFw8ujXGPm25g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VFRM4yhJdAcL9415qCAA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: sViZQu-c_VKgUkxYorRc3uyNgvfmbtyP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 impostorscore=10 lowpriorityscore=10
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=10 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611100073

With DIX enabled, scsi_debug only updates the protection information of
blocks written by a command that carries it. Any other write leaves the
tags of the blocks' previous contents in place, so reading them back
fails the guard check. A real device formatted with protection
information generates it for such writes.

sd never sends protection information with WRITE SAME, so a BLKZEROOUT
over previously written blocks makes them unreadable. mkfs.xfs zeroes
the log this way, so formatting a device a second time leaves a
filesystem that can't be mounted:

  # modprobe scsi_debug sector_size=4096 dev_size_mb=1024 dif=1 dix=1
  # mkfs.xfs -f /dev/sda && mount /dev/sda /mnt && umount /mnt
  # mkfs.xfs -f /dev/sda && mount /dev/sda /mnt
  mount: /mnt: mount(2) system call failed: Invalid or incomplete multibyte or wide character.

The guard tag is still that of the log the first filesystem wrote,
while the block now holds zeroes:

scsi_debug:dif_verify: GUARD check failed on sector 131593 rcvd 0xe313, data 0x0000
XFS (sda): log recovery read I/O error at daddr 0xff8 len 8 error -84
XFS (sda): log mount failed

COMPARE AND WRITE has the same problem, as do WRITE, WRITE SCATTERED
and WRITE ATOMIC(16) when they are sent without protection
information.

Generate the protection information for these writes: the guard tag
from the data, the LBA as the reference tag and an application tag of
FFFFh. scsi_debug does not check a block with that application tag when
it is read back.

WRITE SAME writes the same data to every block, so compute its guard
tag only once. Take the meta write lock whenever DIX is enabled, so
generating the tags is serialized with the reads that verify and return
them.

Fixes: c6a44287417d ("[SCSI] scsi_debug: DIF/DIX support")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/scsi/scsi_debug.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7d5065039637..2c7afdd2846b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4434,6 +4434,32 @@ static __be16 dif_compute_csum(const void *buf, int len)
 	return csum;
 }
 
+/*
+ * Generate the protection information for blocks written without any, as a
+ * device formatted with protection information does. The guard tag is only
+ * computed once if @same says that the blocks all hold the same data.
+ */
+static void dif_generate(struct sdeb_store_info *sip, u64 lba, u32 num,
+			 bool same)
+{
+	__be16 guard = 0;
+	u32 i;
+
+	if (!sip->dif_storep)
+		return;
+
+	for (i = 0; i < num; i++) {
+		struct t10_pi_tuple *sdt = dif_store(sip, lba + i);
+
+		if (!same || !i)
+			guard = dif_compute_csum(lba2fake_store(sip, lba + i),
+						 sdebug_sector_size);
+		sdt->guard_tag = guard;
+		sdt->app_tag = T10_PI_APP_ESCAPE;
+		sdt->ref_tag = cpu_to_be32(lower_32_bits(lba + i));
+	}
+}
+
 static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
 		      sector_t sector, u32 ei_lba)
 {
@@ -5195,6 +5221,9 @@ static int __resp_write_dt0(struct scsi_cmnd *scp,
 	ret = do_device_access(sip, scp, 0, lba, num, group, true, atomic);
 	if (ret < 0)
 		*scsi_status = DID_ERROR << 16;
+	else if (!scsi_prot_sg_count(scp))
+		dif_generate(sip, lba, DIV_ROUND_UP(ret, sdebug_sector_size),
+			     false);
 
 	if (unlikely(lbp))
 		map_region(sip, lba, num);
@@ -5283,8 +5312,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				    "to DIF device\n");
 	}
 
-	if (sdebug_dev_is_zoned(devip) ||
-	    (sdebug_dix && scsi_prot_sg_count(scp)) || lbp) {
+	if (sdebug_dev_is_zoned(devip) || sdebug_dix || lbp) {
 		sdeb_meta_write_lock(sip);
 		ret = __resp_write_dt0(scp, devip, sip, lba, num, ei_lba, group,
 				       lbp, false, &scsi_status);
@@ -5473,6 +5501,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			sdev_printk(KERN_INFO, scp->device,
 			    "%s: write: cdb indicated=%llu, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
+		if (!scsi_prot_sg_count(scp))
+			dif_generate(sip, lba,
+				     DIV_ROUND_UP(ret, sdebug_sector_size),
+				     false);
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
 			     atomic_read(&sdeb_inject_pending))) {
@@ -5564,6 +5596,7 @@ static int __resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		block = do_div(lbaa, sdebug_store_sectors);
 		memmove(fsp + (block * lb_size), fs1p, lb_size);
 	}
+	dif_generate(sip, lba, num, true);
 	if (lbp)
 		map_region(sip, lba, num);
 	/* If ZBC zone then bump its write pointer */
@@ -5584,7 +5617,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 ei_lba,
 	const bool lbp = scsi_debug_lbp();
 	int ret;
 
-	if (sdebug_dev_is_zoned(devip) || lbp) {
+	if (sdebug_dev_is_zoned(devip) || sdebug_dix || lbp) {
 		sdeb_meta_write_lock(sip);
 		ret = __resp_write_same(scp, lba, num, ei_lba, unmap, ndob,
 					lbp);
@@ -5753,6 +5786,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		retval = check_condition_result;
 		goto cleanup_unlock;
 	}
+	dif_generate(sip, lba, num, false);
 
 	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
@@ -6386,7 +6420,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
 
-	if ((sdebug_dix && scsi_prot_sg_count(scp)) || lbp) {
+	if (sdebug_dix || lbp) {
 		sdeb_meta_write_lock(sip);
 		ret = __resp_write_dt0(scp, devip, sip, lba, len, 0, 0, lbp,
 				       true, &scsi_status);

-- 
2.39.5

