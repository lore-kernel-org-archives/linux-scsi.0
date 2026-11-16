Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863223;
	b=kfm6rwfyyZGkM4xeegvDiNGOsa8sTTSya9KgSRZpuPHE3TaF6C09P6ezxiWFrFOxfMHl
	 J6/OaWnH/fiyzbUjF+BPtoMdGDDEWD2xExOVGL2YIwtDCmaJvjJFoeQCg8AFGWb+uooy7
	 E7M/G5O4JHYiG5rOB+JMd+cgMuLLmxTx08xvxCETZEAPJ+kzw6JnMpwdggtK2IcO/JavC
	 UDCafqc/DPsfhTj/WVWb55KUzXiJrWlPegwSTTbMuOtfo7yBE4J7gekbIQ3F3HIl5cYlD
	 Xm1SAnKDZZWsRN67Ml3RgJMtbnV6fPA5hHa74YbS1uxbXJW9wDYSU+YvTpX8mPROKtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863223;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=+Bwry8MZl5R14LQosrqzQMFmw8qn8xRl1VSmzEMpdJA=;
	b=150JAQzfcT/19C69Yc7f64F3yYGLuN+i8BLug322ohvlqy7Ov6y+RCLb7VGlC1i2SH6o
	 LpO5dQSfpCMDYNWDjsO8e9tn7dvqpqLbEtxmPhtjaYKoA25mi2M6LGSoYX7iiSe6wUHJv
	 C6WI0WBWN8rqYq1a+64bkNp8/enVsC+0lx8H2jMfeamPC+wNUEuTM1ufN2+q0Z5vNF4AV
	 Z2fGqPQKoYcjI9BcDtKqpiJrytR3i7G5azdx6d0rrWnv2ruzeYRaIcNJov9kTNU5G6HDV
	 jPLgBRBAlForC8yyI+YTbxaHapofDqi/Whaa98nJSXj6IDF0EjUD7hygQWfJea8NIUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=o8EcXSJu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=SvLCal7u;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50D0606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B50D0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=o8EcXSJu;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=SvLCal7u
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXHt83801926
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+Bwr
	y8MZl5R14LQosrqzQMFmw8qn8xRl1VSmzEMpdJA=; b=o8EcXSJuULFvME5G3FdM
	XdXnZWwnWcFUo1CeeyDiKPonjl3WfPqt50DTosx28iZAgHyWMmpEXVYraUkItQXC
	hgyvNcSWlGCf/WXWK7+2j5RRWGs4cMnt2e0aZryvRrG3dwfpTi/7Ar1x97g7CAao
	DOKaYkZ81XGXHS+zke5aSUDO6vc3P50Q9h/+hRYCdNZ2P/2OUgiK0s2QmBEqkGfN
	4Kd7RLzkFLZIkAbAOcAjLWcGOyDlfB2UeYlKbTuZFbzcnkY+Y8H0nLvyNc6kzZwX
	cYJYp3Exxp5xsehnMZGE4glr0ae3mL0ZxRMofmYO/wb/FNzaSIj+s+QPdT0D/0LY
	4Q==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0598tsbu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:07:01 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f2373e9b4so434381185a.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794863221; x=1795468021; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Bwry8MZl5R14LQosrqzQMFmw8qn8xRl1VSmzEMpdJA=;
        b=SvLCal7uC/WDihOr5x30f9Z2CcSZEoxSI6+9JsJbdSyJ39bM5/D31JrIg8e+Vsl6i0
         H/wsLj1bCbMVywByvgC4jk1Lxmsubln1cFZqXg6zY0uY+/PV7zq7uJ60nDP17FG3dHCg
         EQos+kApCotkb+/lP7WT7m4uXPYazJnGIw5ADVJqgK8TSqjz85nRckuIdpcrmeGVdwfJ
         yV2bnJZnWDLZnxJtwwl0TANNDAYxsksTK7JNzaUNGlSxJ8jnUROjEHI1JogXJRCLNMUN
         B0UCgLpPJGC1bF0ckxwU+TW2SKqahPdM8v0FK/Q+QStTyy8nXLEtzfHsLdj9lbsNk6Jx
         VulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794863221; x=1795468021;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Bwry8MZl5R14LQosrqzQMFmw8qn8xRl1VSmzEMpdJA=;
        b=1pvsFnBTjYztGY48IACtbPpVbW3oSRyI0j8WdtFnLPsDcMdiuSiuIzIBhwWgIxJHe9
         pxo3eAThwvF8F9zRL2Vq+dlUvxF/SFrkGjtH136SAs9GiRobn0D9cgYze/bgl9czGYTX
         TVRDnDjbVJ+V4q4ncl5xbi8JuTiy70m4+OzOxjh54ayYs/z9818U9joRR+2xtYmX0cZ2
         82ADQ3OoH0jq9EV3RSuVTXXufrh3gKp/HeW0ZU2DowmDTfFI6QV5lGlGC2tlFOVQ5otk
         F8Edn1pRFh3XLnLWUfNSR/PjrsyOSvI5A14L/ZrqPH4gUzHcBc4k5PJX5AzkZJ2d5Q9z
         sWtQ==
X-Gm-Message-State: APuU4Z9FxFDpUFriuELJvnG+IpjquP+MPgp59OXakUSRwPrT8cxcrwBV
	5dDsmKmEltqqJ+T29Uxpg0IW2i+VijAOXbt7nyvTFxQFxxrPK818nVLUCpZL2gTJBi6T3RYgo8d
	ookLECFJ/Awn7uyzHZH5o+mO7RVX3tmWbvs1w0Sgied10EAy/HyAte1Ky1QRUOsI8/hg=
X-Gm-Gg: AYBFou18zMRW6aQwKFRGu2r2Df2oOwvgdSaqsSsv5Cfje/XqhqPUoL2Kfk8cnz5nU8q
	ktkpeH9JdIjrOOt9eIzjl8vfIpe0qIMSK4O5mnInn0DaBNCEgRSYoK1WsiSaj82Ihn9BJ0zdCM1
	5O1qD1MBWOSmrbLY7zcO9eoCEf/ETlKMOcz9Vwu1RTt4yyVB/6XWdZMIneGVPpc6OwA6mqfhlha
	zsiMhbm4ziokMORSx2EsoPVssLwC1HpYaXKZJoCgJ7aUYG7eRPnpf8HnLBuWSR63RvH6RDz65je
	gUo+9afnaMOl1g+3yXLBaJTIZ2o7G8CUDieO58kQ5BHyJUMxj6oeNEJClGklRuvp2loKwsimXuD
	nBO3tD+93r78WZGOI95oEfrV/3wN3yLD0WlgSU7eDMBKT089ymuKqQzcVsESHWrcNWyfWhRZUme
	APVOjMICEQ5ueAh9aKGxCY
X-Received: by 2002:a05:620a:7087:b0:93b:d7a2:dd2b with SMTP id af79cd13be357-9494bc4b2d4mr2001190385a.59.1794863221049;
        Mon, 16 Nov 2026 13:07:01 -0800 (PST)
X-Received: by 2002:a05:620a:7087:b0:93b:d7a2:dd2b with SMTP id af79cd13be357-9494bc4b2d4mr2001186585a.59.1794863220517;
        Mon, 16 Nov 2026 13:07:00 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949689e4e9bsm629661685a.17.2026.11.16.13.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:07:00 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 16:06:53 -0500
Subject: [PATCH v2 1/2] scsi: scsi_debug: wrap around the store when
 zeroing a reset zone
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
Message-Id: <20261116-scsi-debug-zone-reset-v2-1-83c8a9841f4c@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794863218; l=3333;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=TbLi4/Xv+w93OsY03Vub9so48btyfOleHNfGL6DqQEU=;
 b=aVZ0ndjIuX4Bgfiggh/WhLWRqgRzbnllSEzwRd4BdgokVx/s0A1EtoJzB3ARijZZNFaqc48AR
 3Dz5ftkkI5uAm5iMQtowa6TYFfGIzhtd+qJOIGCPCixo1e2H6h1kTzu
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: SkfVgH8-te1Nje8QcXPIv_HxY6bQrOP9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MyBTYWx0ZWRfX0IObpgfVJiPp
 a8z6fM6b+kWBRMyWjqiKZNng+ewZtZI+JsLYMpJDbVp4agIy70SHJKqb29P5BC1GTGNqhMcWe43
 efdPRl7v/PiLl2e8j14DhPwidVMIEAe2P9G5zz8B9DWeOLtcHlee
X-Proofpoint-GUID: SkfVgH8-te1Nje8QcXPIv_HxY6bQrOP9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MyBTYWx0ZWRfX6Rb7XmI89vus
 /N8tWJeD63Vyh/8rBvOEgezkZtRS8V+1XnYWhHo7CbQFj5zok7YibOFfkM+E5d9AW0hFRjb2gun
 fsNy7fG9nAL0u01DDT/Wa9Tly8fYWCb2XF3K3MSGLuAcU1bMhA/6k7hmvPUk7IjNbua5EiGYNez
 Q+uyCfVbKzKEZumJsfesESNn5J0trQI69L/nYmSzJqaVNq+JH+TMqyR/0MGzAwnGQsqDbSQdJWU
 n+txdy0wRQiivJKfXP5KJUfW3XjT5dCL3l+h7uZm2qj89uamNBzFulgX3A2Theob8Tqzn576VX3
 DrERfshDpblE18EQcrVKKPkeb//W8dnzr41rdR+lQlCsgJXXYvT40qNVQgJiZl0ZOpgfTYTWhQZ
 RSFoRMOGez4/A5dqoyv3KlRldsTflJaGybgnzgfVooCKjOnzYpwdxLk49fedbXh73Q4zmyU/kNH
 /kmdEf9I7LohT/YYL0g==
X-Authority-Analysis: v=2.4 cv=ZOpCCn7b c=1 sm=1 tr=0 ts=6afb7076 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=9cs-aK8SJTO5rNEwzvoA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 bulkscore=10 impostorscore=10 spamscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160083

zbc_rwp_zone() zeroes the blocks of a zone that is reset, using the
start of the zone as an offset into the store. With virtual_gb set, the
device and its zones can extend past the end of the store, which is
only dev_size_mb in size. Writes wrap around in do_device_access(), but
the memset() doesn't, so resetting a zone that has been written to can
write past the end of the store.

On a device whose fifth zone starts exactly at the end of the store,
write to that zone and reset it:

  # modprobe scsi_debug zbc=managed sector_size=4096 dev_size_mb=16 \
        virtual_gb=1 zone_size_mb=4
  # dd if=/dev/urandom of=/dev/sda bs=1M count=1 seek=16 oflag=direct
  # blkzone reset -o 32768 -c 1 /dev/sda

The memset() starts at the first byte past the store, in the guard page
after the vmalloc'ed area, for the 1 MiB that was written:

BUG: unable to handle page fault for address: ffffc90002c00000
Oops: Oops: 0002 [#1] SMP KASAN NOPTI
RIP: 0010:memset_orig+0x33/0xb0
RDX: 0000000000100000 RSI: 0000000000000000 RDI: ffffc90002c00000
Call Trace:
 zbc_rwp_zone+0x1a7/0x2a0 [scsi_debug]
 resp_rwp_zone+0x19c/0x450 [scsi_debug]
 schedule_resp+0x2dd/0xbc0 [scsi_debug]
 scsi_debug_queuecommand+0x1286/0x2950 [scsi_debug]
 scsi_queue_rq+0x1d74/0x3200
 blk_mq_dispatch_rq_list+0x3ad/0x23c0

The command never completes, so the reset returns EIO to userspace and
the device is unusable afterwards.

Zero the blocks in a helper that wraps around at the end of the store,
and that stops after one pass over it for a zone that is larger than
the store.

Fixes: 2d62253eb1b6 ("scsi: scsi_debug: Zero clear zones at reset write pointer")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/scsi/scsi_debug.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a922c8318a2f..7e78c158f736 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6612,6 +6612,28 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 	return res;
 }
 
+/*
+ * Zero the blocks of a zone that is being reset. The store can be smaller
+ * than the device, so wrap around at its end like do_device_access() does.
+ */
+static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
+			    sector_t num)
+{
+	u64 block, rest = 0;
+
+	/* One pass over the store zeroes all of it */
+	num = min_t(sector_t, num, sdebug_store_sectors);
+
+	block = sector_div(lba, sdebug_store_sectors);
+	if (block + num > sdebug_store_sectors)
+		rest = block + num - sdebug_store_sectors;
+
+	memset(sip->storep + block * sdebug_sector_size, 0,
+	       (num - rest) * sdebug_sector_size);
+	if (rest)
+		memset(sip->storep, 0, rest * sdebug_sector_size);
+}
+
 static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
@@ -6629,8 +6651,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 		devip->nr_closed--;
 
 	if (zsp->z_wp > zsp->z_start)
-		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
-		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
+		zbc_zero_blocks(sip, zsp->z_start, zsp->z_wp - zsp->z_start);
 
 	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;

-- 
2.39.5

