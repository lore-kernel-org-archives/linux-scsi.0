Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794345824;
	b=OHcIdOCvUofp+uhgnF4vrxe5WilIldpt2zW+JiUXJzKGW7qWyAMHZddRrSbt82adJJ6F
	 1lDZa54eQDHkRbQTkiXZxo8yCX4UQ/zQfr217lmN1SAPAYQq1P1BP/xgeSoievVlR9up1
	 jSftxLeMELa5Zn5DgrDfBx1/zLQUZRC2EJe+DkJRopovtMEpr0vt5HHBLen9v83arD92p
	 B3HH3JT7px62Mv59r5b5Ex6Dz6PpKGBT7WeyDxtKsVOYhh6vsmrmNmH4d0TKve7PiWkQU
	 uzJbkWO2Z1SpsouB9xbEBrdpv+pYQJSTw4kf4uC5zzPv2Rj6dYlNDGxR4PoTGbAdaEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345824;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=HLb61peR27MkY2qCBFOd5z+gHtFg3eAJpgTGyWlH/SI=;
	b=BduGj4guEXPjjFMZrYtAYzotiTZMRTz8yA+q+htIvLpJh3IzPhnjmJFf2fbXF29qY2s3
	 xeWnQjLPDMY1f0JpmJ1/drYbKJ9FENtVhjTB8kqDrXOWE3ye5rW1pKLmoaUp2dRmmrngW
	 v+Yduycahf4cb4NmgQg6htCALc/9Os3uH6LLQe1AvzusknEmCk4K7V8pU5KMgbGqvkmJe
	 HPNW2aUE6jVujEjwGmuUvqPjnQlETax9OPLlu1GC2RbZ+9VOYr29/4EFv6x61YwdXI06L
	 uR8IC+RS6/4AKIrvBhsVBfd8onbPTnc9pi8ZTPTK0WekROuDUluz2V83WhtecbsKm2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=qEHHdNGm;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=s5GkUM5k;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAE6606A325
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 21:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FAE6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=qEHHdNGm;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=s5GkUM5k
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAKRqLJ2312954
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 16:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HLb6
	1peR27MkY2qCBFOd5z+gHtFg3eAJpgTGyWlH/SI=; b=qEHHdNGmVxzJYizHcgl+
	OBICv6oBfreg1xs1v5biIqk+cRY5uyai1cGwUVuPkFqFSJbIutQPGJFs6bE/C1Y1
	8MT+i1LdOcLo1vo3CxtPurZYZDuMi1nf+PvdjFlAKMmv+Q9K1NEp8mkupU8JLfoB
	JL4gvdYtGn70NAhpvE3graaPoWQPSuyF6x08kvU74I2hbiRQ1PjoweNv4hYHqXRk
	lsFKVP1Q0wcZMB3znHBLnNelAHwCV19fVlRWVwopigNYZBosqrjIEkFca/f/xEFC
	y7VLk2mJ5GZYMPavFIwzS2Dg62OCgsrcME2cYX4qnU6HDvONdO3QJzXCjpCrKHJc
	4w==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hv7nyt8ju-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 16:23:42 -0500 (EST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91eb3a63064so53844316d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794345821; x=1794950621; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HLb61peR27MkY2qCBFOd5z+gHtFg3eAJpgTGyWlH/SI=;
        b=s5GkUM5kEcfFAaUlsbiD73WymEBwT9HNzdOpWO57+5rqbAzbOfFj9EhgNlY+ziZ7vw
         ZTrXaXzeZdBmuaDHkcjacb6Y/jC6LARBm1zTSUT87EHS3IminDYHBdO0C9TeoaOtKVbt
         vwXEQoO2uvL+BNhQkIZqgleg7OTK79DthM0gmwivLD1oFORa34C4l0K3Uah3zL6uGFg3
         I705nmK/CvfaweNAV90wVbYQ+KlzM3SgCgrJwehlXQBa4fF/edUPuDffO0ZB2Argw+tu
         T3XujMXV5mJjwbhYPp0rtlBn8rfwgwT8teWVX1RQ3s849cr+ShFg2DNP8uI+ykFkINdc
         rkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794345821; x=1794950621;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HLb61peR27MkY2qCBFOd5z+gHtFg3eAJpgTGyWlH/SI=;
        b=25CaTIr32M6gre2b/T4GA1l2anU5jyYOJsTQLHi/95rqhKuOS+QU1gnNVpTNWQLt+U
         rvyowKU7f/Q4iwSUnTNqAgONQo9QWdbkOURodwZf0OqB26codM3FP3bxRVFZYeRch6GZ
         Ish8Bt4Si1pBaiJl7+l9meMn8PqTfDnMvnchmA5fpvGCDsVJQjbQLcXREpUDNLFdeP+m
         5fPDhCAtxfD5vejatFUYZvwTlYqngfj/yX0FxuygPKdzF23OuXYylqgXfpHWZwLkwWqO
         mncweRQh4b2AkXyQxy1ara7mGZ5hm/DSjDTNRfrSqzsLCp1dwJHAqwGUtVTo+U+qkn/l
         N3Nw==
X-Gm-Message-State: APuU4Z+2nCMD9Ir3bLkMQkcp2qnU8t+uwEOBRJa3MZrQQO/ZqjPhrxV9
	EVMICs843ey8pPYSxRfgThT8XeUPOVkBdizFJMmJRC/kE9OWu4pc6vSrg6R2phSLtwlZBcDF6w9
	MxDlYuEbq1c3FbsyXtl5mvo1tgL+SIL0btrJ026Rx2kyMaVqEH7W0ismyCih4umu06Ps=
X-Gm-Gg: AYBFou18cY4gEXhvHr/OZ10kxk8mTjY/TJrtzILhc5qJzjCwMDl3h/to9yc7Soq3e36
	zDQdBiQq73nE2pgKVtBLgaDFg/d85I0u8mZjWSWW2L2TYMwwyRjOA5UTOBrMK3gwL/i+i0LerQY
	TsWojrQboVI/ghaWCtHf1SwcQucus2461wpYRFliNNHdXcIHlwiYVqL4XzLu4NTHGEeDahfclb9
	eFaFnFrojm8E0gOygJWfsxU7q35q+qTA4Z+UaNeXTPvLn1CxvJOeO2+Bx5/i6wKEWXFEb+rQUqG
	X41CwV036jbCue9Se4ZEqNJM9V3EPgMdOpRxkxKbKKSjune80mmpqFV1Ha43rNKD+aTTQZ5qnvN
	2TR1oV+HQYFWPr/aukMTGCAmGU2R9S0JtuGg53zDAZTGRvvXvIXdK0rufuHE=
X-Received: by 2002:a05:6214:411e:b0:91e:972b:ad99 with SMTP id 6a1803df08f44-91ef027a678mr59494746d6.25.1794345821712;
        Tue, 10 Nov 2026 13:23:41 -0800 (PST)
X-Received: by 2002:a05:6214:411e:b0:91e:972b:ad99 with SMTP id 6a1803df08f44-91ef027a678mr59494376d6.25.1794345821302;
        Tue, 10 Nov 2026 13:23:41 -0800 (PST)
Received: from [127.0.1.1] ([129.236.231.168])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f00f6eb88sm10024766d6.39.2026.11.10.13.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 13:23:40 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 10 Nov 2026 16:23:31 -0500
Subject: [PATCH 2/2] scsi: scsi_debug: reset protection information on zone
 reset
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
Message-Id: <20261110-scsi-debug-zone-reset-v1-2-28cb9184b5ea@columbia.edu>
References: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
In-Reply-To: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794345818; l=2529;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=fmP65CUlyZGB3m4UhIjwsXB6SABvsQU/J6EW3xnTXUQ=;
 b=Kya6PTUYQvqO0V7q31L4vBI1/QyWKy/Hm1eSUFBhGu6gd3clU6R/bDSyUR8sR66tvQSamWhue
 sB+5NRL7/47D1lj5bE5bURDkUSXUkoiqk9RQmHN87IoMctRnk1CsXOQ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA4NSBTYWx0ZWRfX3fMgmYItOdaM
 MhdaWzTURDLmoJTVXHc/ELWhUMrafvhnU1EKOVB/ARSy9vf7nbBpKhf6dWeXa5L28KZfAGSgD+m
 kznxrSU+qY4gckZ3CGuHLiKM0xhxSDM0wovjwyw6hcv1L9Y3tZP/
X-Proofpoint-ORIG-GUID: jG3VFj5opcYCx3EpKFMa7vUX8S9ORRjo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA4NSBTYWx0ZWRfX80mheFk+EVvo
 wkakO/q5OEAdVEU6WklzKWHQH7hnN5xRox3CCuvquzdgRY22z29lCsaYbaVxghx4nrVFLldb9dd
 ggWRcpKHtOAE54dh/ad3ysli3LuFPDVrnH4yzQGlJATzElonXhy2sjnprNyY6nwakKv7b29JvDz
 E7pOvj3hlmRfUJZ7ynpU1MpszVwQfbNxa82OJY5h3Uf2IoDkiFCp2+QCiFEcCIyNPswMIiqVBJ/
 vMrtuZXR8SWB0icNGwx/T2sgHUJU/tCwm3J/d4zU3tUroWd29eEat9J67f2g8pQYN02UyBBaKJp
 TlVucx2QE7xD0rLWREq2KB3EuOR1mYDbjBiUNYavh2z/D7VfsccrJn+QF2tXO/n3DcHe3/UrkoE
 K4QNKpnkd5CwkH6cxr1EXRgjQjWH6iCZYuttkwOJVVRVpi4lrhapD0LWhIVuQ2pnbaU79UBLvy3
 A3QHydrRp0DDnRqD6ZA==
X-Authority-Analysis: v=2.4 cv=Vc5ir1p9 c=1 sm=1 tr=0 ts=6af38b5e cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=lHGGv15rhlN7Yv6qcqrt9g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=t5kXCcw8_YMdeodUEPQA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-GUID: jG3VFj5opcYCx3EpKFMa7vUX8S9ORRjo
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=10 lowpriorityscore=10
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=10 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611100085

zbc_rwp_zone() zeroes the data of a zone that is reset, but leaves the
protection information of its previous contents in place. Reads of a
zoned device are not limited to the blocks below the write pointer, so
with DIX enabled reading those blocks back fails the guard check.

Write to a zone, reset it and read it back:

  # modprobe scsi_debug zbc=managed sector_size=4096 dev_size_mb=64 \
        zone_size_mb=4 dif=1 dix=1
  # dd if=/dev/urandom of=/dev/sda bs=1M count=1 seek=8 oflag=direct
  # blkzone reset -o 16384 -c 1 /dev/sda
  # dd if=/dev/sda of=/dev/null bs=1M count=1 skip=8 iflag=direct
  dd: error reading '/dev/sda': Invalid or incomplete multibyte or wide character

The read fails with EILSEQ, and the guard tag that the device reports
is still that of the data that was written, while the block now holds
zeroes:

scsi_debug:dif_verify: GUARD check failed on sector 2048 rcvd 0x288f, data 0x0000
protection error, dev sda, sector 16384 op 0x0:(READ) flags 0x10800 phys_seg 256 prio class 2

Reset the protection information of the zeroed blocks to 0xff, as
unmap_region() does, so that they are not checked until they are
written again.

Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/scsi/scsi_debug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1c27ea0f9b69..9eb64caebdf9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6613,8 +6613,9 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 }
 
 /*
- * Zero the blocks of a zone that is being reset. The store can be smaller
- * than the device, so wrap around at its end like do_device_access() does.
+ * Zero the blocks of a zone that is being reset, and reset their protection
+ * information. The store can be smaller than the device, so wrap around at
+ * its end like do_device_access() does.
  */
 static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
 			    sector_t num)
@@ -6630,6 +6631,9 @@ static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
 		n = min_t(sector_t, num, sdebug_store_sectors - block);
 		memset(sip->storep + block * sdebug_sector_size, 0,
 		       (size_t)n * sdebug_sector_size);
+		if (sip->dif_storep)
+			memset(sip->dif_storep + block, 0xff,
+			       n * sizeof(*sip->dif_storep));
 		lba += n;
 		num -= n;
 	}

-- 
2.39.5

