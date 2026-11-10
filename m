Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794345823;
	b=ClNTXNkkNh6LaD3Gt0aJaMIbRu2bpUBRG/42tuhBiNlO2K6o2R/ushr/iws+tmpcTza1
	 TWF6dvj+LPRUjQLexTSOugrt/5/a9xReH6HYlBbOHBT319qwQ7wYSPNM2CvVwOyDtk9vc
	 1s8vilKN3WsoJ3aLM7wqRnqGRcASdWZWVWXUjAjlmQysCgaDXg9NmnUDWLn8eEoddNPet
	 D3bqecDuCqJk9A5BVmu1zQ5Pc8i/Lff3CqSMmx6ZdbCphAHdZzkHMWIL9D6ImLoQGZqdb
	 AfEjikby4OjcT2HRho5nSBw0pZ6tNiGfouGVg23VAltq9r2JvCpS/ueY2ShTNOdWMQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345823;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=UqMCwshqZ0AC16p/py906dxrHXg0HhkhkoAyOE0pbJg=;
	b=BcNi0v2olwbYSKZ8xRj/nslJx5MttHPRCb4PngAR0CIChHwnISMrWjxbTdT9hRgEQ53R
	 77D0+OfkOlG7sx4PkKQpda+3dTn/I+eLnuJDQ2sNz4Mj3QkVzCF4Bu7JBOSbIPvOKY0q0
	 A4e9IvvSMslFg+3RTYlJZspRO9+btvjuk/h1dNvaHfwbaYuc8rI5UvtGWAiyNVekq3h3G
	 YuD2+hFJqeyk1TPlkZjrtXWUcCTS0KYc6miA2ZBtX6TMsLxFVfRhT06RWcWg+6xVUVerV
	 n5VXJIJkbz8THJ0w8Y7Q7EbfvasSichKT7r2zVA4tyqvZM3piTWC919cLi0AMbY23NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b="JkQg+/q/";
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=wno2rYlK;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD93C606A326
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 21:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD93C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=JkQg+/q/;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=wno2rYlK
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAKS0xd1127659
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 16:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=UqMC
	wshqZ0AC16p/py906dxrHXg0HhkhkoAyOE0pbJg=; b=JkQg+/q//eAizRed3iyI
	3R9Ao+cFbGzDw7QDNrDmlVRK3E58riHZAvsAe9YXZdOdmMzoPYnStwwXDT03TVyT
	3lFkAFSU9qZlzZfX4IhzclItvBsahMy5BS8GRO3vsOoMedTn62hwX9c+MIQQfQEz
	gF89TLh+eUSJfchcN0lCAuleryRLK8/jdqKr1E6HGDRQs7YymRVhRQFcCFSLRTtv
	04KFrWDDHXAQEWlXsRr8afOmN8ke6g3UOj2Fr5iTFE9Oybow7w2p+Jgu884Ezrh9
	Pgsy2BpTN//LJxeLEh9wOjQa87DFHAKdV50nHA6D92Q34cnYwlixO+wvrTLTUiD2
	2g==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hv7612m0r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 16:23:42 -0500 (EST)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91ef0fe2914so24439026d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794345821; x=1794950621; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UqMCwshqZ0AC16p/py906dxrHXg0HhkhkoAyOE0pbJg=;
        b=wno2rYlKE/PNyCVrqV5/QETWerOyBWKxg7KkH3y+50ZsDZpjMThHY2OU4I6uEJhpbl
         Z+Yj+MYrPo0wLdass3gzvpRlHWi+3G/DlF1CXgSMPROYFItpwcai2FS8DJFNW7rlHoid
         By/tF3/ZDVPnd1Ru/Y+UtMTrGosvf84CEYdzJPj0Tk86GsFttlS2gN48k8NsVT5S0RKf
         gbHnNAYQ5he9qmX0qA0AA1C+fmXME/D6OrhH0dX5vQAV/obzErmrX3Ct1TH5zQbIu9ud
         mOemFwLRojozHVCnLr5hmn9cUFKfbcFiDpnNZ39qXQWPM1lW6gAGKgcMPlNW82hfF6CD
         HKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794345821; x=1794950621;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UqMCwshqZ0AC16p/py906dxrHXg0HhkhkoAyOE0pbJg=;
        b=2GceGY0bY2LxS5LLcy7sNNDX1NyhC5Ba8yX0/CJs0T/PdeLIIMl0kriO5KDtR9HLz3
         jhn0rppugjRTdwPPW4IqKAULvxXYmHxhn6NvOeYGA57xo7GFo4Ori3t8x/ZKOdUHKbZh
         gIRCQTC1vuKXZNOdbtcGiDjysuIrapC1qYW7re8I2hwv+7vWBt685v9wGdSz+sDDlXkm
         1dkyOCcBFimHNQjp8Rzhkev1mq8RFV0FiYeI96T6RgxeuammRPAYDwfIgouU8q3i7zxY
         INHPhJ7Dw3HxgXmBDZ8XpMY+fqACWYrbDiIwN9oMK7rEAuWbdMMWdafSSjH9Vu2XJz25
         w3Yg==
X-Gm-Message-State: APuU4Z+j7BS2AjGUbdaafTuO8mSuDs4sp2bJskEJHDSoF/gYv8Ikx4YU
	4S+KNq/HHKmvVle2FKNU9TQvV9VF8W+jviNoErm3P6V2ejlAqySV00YbBgycFi4gwmAYARqCrsO
	fVKj5l53dTgjMKE79LRfcBQ0/Xn/+JL2RkryAwoMtHahyxu188478Rexc6tdefwp2vAA=
X-Gm-Gg: AYBFou2Ze8/agdBZhhXpjBysd0ND7iLeF8xzkuquEtR1QHDd0I0kIsPb/brUZbd/+pB
	s8uEeRGwgZL35icOljZ/sDWBOgXE/BaHqmn578KRfFlOjMOImhjg4ACCCyL6LFO8LX6uvSkGBLv
	Yc3pSxit62g0LX8r/vUqYBQlHGX7N5MQM4CEAbynf31LWnC9kcRF0UiNWgiGUxbDigW2OA2vtjr
	MFMvUXrTuRgGAmOKu4+XKqqHWJfti/P1aFOztiIbR5/1bYwGms5s7Gjg/jFxb6MMOsJDjFfMStp
	s1/GgKD9/tcxbFq5f5Z2CIQ6nzV71jgjCwkOtlZlQsGvwOu/2OSVP//3rnkALrrhcta4yIYdBpG
	h98GsDyOdbt6NBubx09M6v32FmFCtnWFmsJqgw4r9JkQYETGCHK6+RftGcwg=
X-Received: by 2002:a05:6214:2c10:b0:91e:b360:1b11 with SMTP id 6a1803df08f44-91f0402319fmr9636906d6.13.1794345820985;
        Tue, 10 Nov 2026 13:23:40 -0800 (PST)
X-Received: by 2002:a05:6214:2c10:b0:91e:b360:1b11 with SMTP id 6a1803df08f44-91f0402319fmr9636566d6.13.1794345820506;
        Tue, 10 Nov 2026 13:23:40 -0800 (PST)
Received: from [127.0.1.1] ([129.236.231.168])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f00f6eb88sm10024766d6.39.2026.11.10.13.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 13:23:40 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 10 Nov 2026 16:23:30 -0500
Subject: [PATCH 1/2] scsi: scsi_debug: wrap around the store when zeroing a
 reset zone
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
Message-Id: <20261110-scsi-debug-zone-reset-v1-1-28cb9184b5ea@columbia.edu>
References: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
In-Reply-To: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794345818; l=3280;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZV3u5z5TV2jDpiHsg1XVxc6l7ohlFCN7yss5BY4N0Lg=;
 b=gvRR9CdVlsgtJtSlFTYA8Y4JnxWyeJU+hOwE1upjGKMZoJjmmlOM4MvbdWI5gpiYmY75JeeAD
 ht4FNsJw+2RDly925plZtVFSAFQk9Erv9zac1sDZ6o/7P0LmZIxWEkR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: Y-MdBxddcpw7tFoLk0-j7CT_j8jaVC2d
X-Proofpoint-GUID: Y-MdBxddcpw7tFoLk0-j7CT_j8jaVC2d
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA4NSBTYWx0ZWRfXxQL43p4z0Tpd
 i/eqXjgW/EA7seO2E7weqTX9OpjlI2F+v8G3uRHt2MS6NIw+Evzkso6ltkIkKzVPa4HAjb4ziHw
 h43CumnNObr7B1291stjZOp1IloPWLS4JPexYu4bhrKynMRNjRSM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA4NSBTYWx0ZWRfX++FF44ZDCv8f
 3ib6QxrTAUT31BTh2N/+Z1h2Te6H0IXzEFzKZ6Z4j7RdD6VMT0xai/Ushci4Ur7+8lyclxQG547
 7BfEB2QoxzE2KCn8G9yyUY1GyKtVZHts51TGPe7R/QaDMW8Lq8a4osLGvnsxQ7U2Mwi4vkRTRF9
 iC/CNN7ytRNQwIOioeXURB/oaggo/jj/PtcyFq+ZGZGzE/uwNmyAORx02ecrtCf0dBvqk9ZqOCI
 v2dgLapaiUiMxK5hn1cYoRA3CCb60wbG7v7DslgG/6GdCvhC4IHKcdgKlQnksKEYvzRWOAYcopD
 SbDhG0mBY6iw2MFuaRbvWKCve98fnWC526nqn9Rsfxrnz+XWMp6sjp/qJbLXwRNJom+cC9RJT8u
 qZLnIJ1VYHajmNPAzJFGEI8DQWppcoEUxYXriLT2WTQdQtd9OSVbidf8rJj525nVQ4EqLHbGlbG
 aLpdfWTDAOljPbz4r/w==
X-Authority-Analysis: v=2.4 cv=W8OtxhWk c=1 sm=1 tr=0 ts=6af38b5e cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=lHGGv15rhlN7Yv6qcqrt9g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=9cs-aK8SJTO5rNEwzvoA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=10 bulkscore=10 spamscore=0
 lowpriorityscore=10 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611100085

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

Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/scsi/scsi_debug.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a922c8318a2f..1c27ea0f9b69 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6612,6 +6612,29 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 	return res;
 }
 
+/*
+ * Zero the blocks of a zone that is being reset. The store can be smaller
+ * than the device, so wrap around at its end like do_device_access() does.
+ */
+static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
+			    sector_t num)
+{
+	/* One pass over the store zeroes all of it */
+	num = min_t(sector_t, num, sdebug_store_sectors);
+
+	while (num) {
+		sector_t block = lba;
+		u32 n;
+
+		block = sector_div(block, sdebug_store_sectors);
+		n = min_t(sector_t, num, sdebug_store_sectors - block);
+		memset(sip->storep + block * sdebug_sector_size, 0,
+		       (size_t)n * sdebug_sector_size);
+		lba += n;
+		num -= n;
+	}
+}
+
 static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
@@ -6629,8 +6652,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 		devip->nr_closed--;
 
 	if (zsp->z_wp > zsp->z_start)
-		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
-		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
+		zbc_zero_blocks(sip, zsp->z_start, zsp->z_wp - zsp->z_start);
 
 	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;

-- 
2.39.5

