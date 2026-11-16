Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863224;
	b=22hTr958mvsKK9RLHM26AF5/ceUH+8WHaZCm5ygzDo8yWLAqXTCMVde4+36J8zApgmET
	 RNuEFYtwdB+3BmOureN6gWQhDRvJQWF6uozjEYw7dhj6mMqKom8st8IZe9ofnqsIeJX/V
	 SjswHD7h4MgWmQ7WBtPYOkNbMhLjD+ku/3VjrCvuAPiY9dBPgrg05w4068PyseBOvi2Rt
	 wUoqelPNUGCBn/5swMLMRxlwOz0OQyLTfyU+WGUlWs1zcI6JCPCLbqsb4qMnJ6DqJOmXH
	 tKmnb9oR0Ad4OZt0dR77RhnDptoEMx/ICabDDttmSzz8KY6pExbNcxYZahHsV9N/VZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863224;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=DT1ufeQsAevOk3DQXQJt5dE6SaZ7iAae0vDIpuED82Y=;
	b=dHQNi/tnTImi1Ro4UqOglEC5JC/rM7fXYbhJil8pZg2yeFm6CGB9JcRk1wmqaY+B6X+7
	 xUJ0a2t2krOcij38sAm/IgQryeKPhatyZCEf8XOtBlUy7fXdi2ryTGp5ziVdWb8AQvKIV
	 2OF5fb1LJ4+bqr0XV9ecNo5qq0KKdQS4mjhgakwzJe9Cw5pPmT5g6/s+iMZa0zhsgZiVS
	 /ZlaSXxBwh64a4FU1VzmyaooBNSYvN9dSYC76WGRqmrDazN6aGWJQDz8ZlPub0k/1//Nd
	 F7n9DHC3jX3HreGliP+h+G4B+GurpshdPBd6O+FThGXFRZWkqDc39o6smnImQG5Lp0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=E20e1oxO;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=P+G+QLZg;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77591606A336
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77591606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=E20e1oxO;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=P+G+QLZg
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXFPa3229835
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=DT1u
	feQsAevOk3DQXQJt5dE6SaZ7iAae0vDIpuED82Y=; b=E20e1oxOcUGA/Lkq7iDk
	Gi2ODucnqS4RxMTSId23sNsZeuRznWzlGcJ9oUe6ojjA+lshZAoKJy8sYO0k14oA
	/eRinlu/FnmPv/9W+tfjGvon0Qn+y8fBU3RaBOKiTQMl0G0fTenbEnP/VUq9uEIQ
	PIjcpsYMWhb+rITtPyi5dpVq0F1VGGblm3mCFs6nehJddHAxdHVN9MAu8CFytLwN
	u8uWu6uKxe4OM8gcldLNvEnbNLZ457I2RPmqQ+CHJJHeUNSCwInk51EHAoR2uOQg
	zMmNZa1JBb3XJ9STJqTu/N3kHBSF7y92o7NgDDL1ku6b3lbLoBlNxd7IjBYAB8rz
	Vw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j059yaqf8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:07:02 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f2c0e6653so367259885a.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794863222; x=1795468022; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DT1ufeQsAevOk3DQXQJt5dE6SaZ7iAae0vDIpuED82Y=;
        b=P+G+QLZgE2mplGXKzp1KWFvP7eKv56KW9pFi6nC8ya2IOYHAirRzkvMrVmQomcvScz
         gFOWx9qDaRrS+jMx3IL2rpUY5q443rnf6Mw7GU9JXM6YIjY3FCYVNaKHu1Ye9oMUXtN/
         JljhzxkKkMOWqi1Zk3UWv/VWV1blI6fJd6vcxnlSNWuqey+O2sGtRZts6OvDJQS2w25P
         Ux3LirZCcqR0tUhWb100umM+ZV1YKGlMrq8cY3u1yXtqylSSHuH6bd5Z8HuSCXSzthQG
         dWMa6qz22UNF2ac1v0y1/tJqASFydxYbf2UyYkWaMQlMiOE51FoDGUrBxj+vyDdd/0kb
         Jgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794863222; x=1795468022;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DT1ufeQsAevOk3DQXQJt5dE6SaZ7iAae0vDIpuED82Y=;
        b=hnUGVYsVwQJaFj0WdTDSCP6xyCd1ti9Gb+d+XRqrSMYlD+GKLKtEZnVWjEtP5X9eXm
         gaL9KKNPb3iefOwq19XvmmZ0uwCX3af0FURMdZ9o0YEC2HLw6ICnd3BCkWOoLKsnm6Mk
         mI4r/bWizidsE/+7SNr+tGwG5ppNSwG9ra5aeuzlav8+BdgwOqXegp3fnrJV2DwfO9pJ
         03dL3Qrt747PAcWm30xLm1+IcMSWpJD2HlhB7E2deeL8MboKU+t9R/sj58xHvw1if2ay
         GLe+S9u45kDXsOZ8Gc7HeydkBJsdud/ahpkwCLzkG6xkUQS8Rlzgrhb+FZPHVB1SyTo2
         2g0A==
X-Gm-Message-State: APuU4Z9k5vAC9REX5yyDJSxE/Aeb4yGDxEBcxOJAdbG4EU6l8AHWjBWI
	jvhoal5iKt0HqFw6rkzWyHGxfCMOtarQyq8nek+DsQnw+ytIr12UFWRZujmY40eUyM4S/q4qXUT
	Xi3+lPVbmCc6Pi86vrUW9cUl7pP0b8sZaPaovHXabWXotQuX+bx3wFE5aEj8=
X-Gm-Gg: AYBFou2hA6OwwHqDr1tW8DSu6MMet14+2E4y2PoHW3u2Bn0y18VdPvkzsHDWta8urGJ
	QvvL26fW9ZgS56ToRF96czyChDnlfouPX4NY8qfWbtl5SiWAPjkzSqUA4bCAhzOaR9Z2nlIDYI7
	WzquSDxTCzoshiXmfpfClWQQ7KW0Hcvm7A/huod/gTxwyrDN4WqgsEQq3BHj5SgKcUa/akSumrM
	L+R3r6+NAPYZnrydo/BLpv11Vmfqfprd4UoArECQ2vFofRWJ9H2ni/wtu7dbzlOJjeyZNPb7n7I
	AnZAbCDVgWtbO85g2kfeVAu6xSqJWJgabk3yubIv3p6DN7NnDOyTDE4y0GOaL9BkYUV5lD2SHpk
	LTB0TVV7zk6nCVupnk7K6KMcuPNSQZO3g8NpzuoS2z0qLcRRO4zTQj2ynMxW6hmr5yrzv7Y02hG
	FvxAC0NI8RUyzQ4JaujBos
X-Received: by 2002:a05:620a:1b92:b0:949:7118:47e3 with SMTP id af79cd13be357-94971184b3amr970941385a.58.1794863221889;
        Mon, 16 Nov 2026 13:07:01 -0800 (PST)
X-Received: by 2002:a05:620a:1b92:b0:949:7118:47e3 with SMTP id af79cd13be357-94971184b3amr970938285a.58.1794863221484;
        Mon, 16 Nov 2026 13:07:01 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949689e4e9bsm629661685a.17.2026.11.16.13.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:07:00 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 16:06:54 -0500
Subject: [PATCH v2 2/2] scsi: scsi_debug: reset protection information on
 zone reset
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
Message-Id: <20261116-scsi-debug-zone-reset-v2-2-83c8a9841f4c@columbia.edu>
References: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
In-Reply-To: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794863218; l=2647;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gyTsY9Ans1Zyp0v03km6FNUqSrsH5rHUX5H/Nhuc17Q=;
 b=WxHDEJfcWeeuffiGRfzHUdlb+C9dUYfZFF/fjqR3HkB/hSEO9RdyZGFmODPmKW97VZruK36KK
 q/9diRVpjvJAmNvfnSWV3DEY1qQgkWVV2SikUHl1GWC14pCo/t3bFEF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MyBTYWx0ZWRfX1me1D30tnaq9
 7vTv4RSYBj46VSiNVyvvGk0JjrQgeB1hkUfb0wmPIe3cuck+tyFUkJmecB9p3Ly9k+ZTWMNU5YY
 XEcQUDmW7EwOkYhVhonw466J9lNYOhdchDXlBlPDZP8QGnwHqTF8dKxaQO/cnbEjyax6E7UefhJ
 0AXeu5MenXxVMKyedEbeGAeWASQuImBkTs6b54Gq7Awn+TKigaDzRaNLlZaAd/pX8lfUwwGBWwy
 uAgXPKS12Rt6H1+qpcPYENDoWEkXJD86cd+0sdR+AvDsP/dCZdDbDVcSfoTWh1FfDd+XvPsLwcE
 8h5iUiKw/zbmEK1MkmBU+K5o02/BheeE5MzSccECG+t4q4iER+K2uP7Hroxthld0x9//xqWGtUA
 b0nN1VL/M65knPD3pI3Jt2Cwg1YYbtmPfJf0Y8CgDrQG4EaFO7BhNI7t1a6pBvgszbTGFQ7VNDs
 7/Lijw1eGFq8JE0Ud8g==
X-Proofpoint-ORIG-GUID: RDlUH0YLGOY2kkIcsJKyZhL_xdgI0Q5L
X-Authority-Analysis: v=2.4 cv=MOv1C8Zl c=1 sm=1 tr=0 ts=6afb7076 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=gsrXvgLnp_Dz9B9LDF0A:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: RDlUH0YLGOY2kkIcsJKyZhL_xdgI0Q5L
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MyBTYWx0ZWRfX7duFdnd6Q7I8
 WPM3J75MKd1eB5468uHsStjn99omb5aIujwrmBvDaLMZ78EZhv9Ngn2upcxXfAZhKOet8KM2gq/
 k84Ijto1FZRX6Cbb3PuvtaIEh82fs1fgCCQjYA4v4iIFvu7qC90M
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 lowpriorityscore=10
 bulkscore=10 adultscore=0 impostorscore=10 clxscore=1015 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160083

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

Fixes: 2d62253eb1b6 ("scsi: scsi_debug: Zero clear zones at reset write pointer")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/scsi/scsi_debug.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7e78c158f736..f64cd701d64b 100644
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
@@ -6632,6 +6633,14 @@ static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
 	       (num - rest) * sdebug_sector_size);
 	if (rest)
 		memset(sip->storep, 0, rest * sdebug_sector_size);
+
+	if (!sip->dif_storep)
+		return;
+
+	memset(sip->dif_storep + block, 0xff,
+	       (num - rest) * sizeof(*sip->dif_storep));
+	if (rest)
+		memset(sip->dif_storep, 0xff, rest * sizeof(*sip->dif_storep));
 }
 
 static void zbc_rwp_zone(struct sdebug_dev_info *devip,

-- 
2.39.5

