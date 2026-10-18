Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE539CCF6;
	Sun, 18 Oct 2026 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338069; cv=fail; b=JZLGE6pBEKJaDjFJIHWLQaCuZnCEJolHI1GtekB95CyhsZuINw+ilNpB3yi75M7uV6O+fUQtN+RYWRgnK3eb+H92eeG/r8yf/4mZPEY+mvDjMdhJbZMLhyFI6m43gA+yVwrycOpzZ4Rm564n9m3LgwuFU4IUTy+wfQa5u7tiiFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338069; c=relaxed/simple;
	bh=gpTZJZGsOc84YdFnabqnZHkJdTQSY7PLqTRoc/vw4JM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AfEXQKjojQrM8A5hW/Ii9QdnA2hzGJVKoJyYiI0LujOGmUWaylbEgJKv8U1dKdqM6rNlpJzcKgubzzkTx0ytwE9yT+zlOQ1nybykEa+rrgFzKTHJzgFAEZU8PtAEYh6K+c8bcNUnyRCW82j9NnjjcJWfthPf/fV4SO8UWh3Gh2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=c2rfCDac; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="c2rfCDac"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBvkIQBHmYJGpRpD3DBtuq9SyRzkZMppohodfdRdl+QYimeFz5wofqdPDDyOMYprjapHlrpSfl21CH6PwCsZJAoOKpHQgxUZsIpzuJu2szsLqxCujTU4BTjOCTW1nvDSi28BwhJCHvAOFnGtmq8o2DkAzBbKq3Y0rzXcSImbpM2pfWI1VIbBjkBJTgOI68PLuK9uR/lFGRgZlbBwdP0JmxdmDiX3JXGuw+J5WQvW6O7ZfUxl46MahSZbGDfjRGCfuldJ59BLIgHkhohD5o0RVAS5tWM6P+rGI1Hdok3g+/zJyMSkbwXY6yrNGk8syynvKIl+yyouBiY9Bjm12IpCzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=yFPkcImvkRXS5LX3CVmmYNBJmTQk9jl4nV6OuH6qux4=;
 b=jd87yMJuzkH8MPZMsxYvZ1aPODlnVSRAyMGkdwVsk1yleDu/wkQNGEhezQjecp8RmQgZe1T2qNjXqdcLAvhWNH9wPCOqpMleujL6X/6ODspVRsro6mwf+d1bBmiPdtsV97y8HFpAGiYHJltdmvmBTYp5DyolX8ndrRkdF5N3n99759sQMmugpNVAOuiyuSGylORhzhQZSih7NIMBCFMqzTiaNfhr9IQ4o8uXc9abZOCqw4OXjrlU0I6r/vG4djYaIgSiI1MXH/G2yBA3EMcdmdcSB1AA5aKtg94Xf+BpgJdqOl6FCRDCJLVr70aGPlip1Iph6H8Dqm4MytcaxFguiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFPkcImvkRXS5LX3CVmmYNBJmTQk9jl4nV6OuH6qux4=;
 b=c2rfCDacF6/mLupojYs10DPF3KA0Cy5JHvuy6Pi+MTVHWsQAL7y2bNmQbNKwVMmyKjraiQlxXxzHYCSToOrfg/byLGRLIHdmQrdJ+OXOCWK4UPp6t6GF0oqwFZ7tRzmrXBnOD/oVdtxNWXaxNslbtjU6Lzzt4xR0xqJ3e4qyjAAf2iTdU5BuocEXVQf/8nTBdtSi09F/P8PWvKmZoD3AioOeBFS2IMLATCFnUmeP7lT8FiblS/TkDWxXx3OrVHIV1HROCHl5ecMtMUbh9p5p6XHkVLL930LxBbufHAEYCOUruOPjBxdNwt22jZtEQfIZFTKoskZ5HAPAD85gUem9fA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:06 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:05 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/6] scsi: core: release SG_IO request before copying to
 userspace
Thread-Topic: [PATCH 1/6] scsi: core: release SG_IO request before copying to
 userspace
Thread-Index: AQHdXxcW2eZJt2KY30ajxgwlzfvRMg==
Date: Sun, 18 Oct 2026 15:41:05 +0000
Message-ID:
 <2b799d1886eb415c85a6a41641acb6ce49798ec4.1792237341.git.x-professor@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: c0f8438c-72a0-4195-886e-08df2d2e3915
x-microsoft-antispam:
 BCL:0;ARA:14566002|8022599003|24021099003|15080799012|12121999013|22091999003|41001999006|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|25010399006|102099032|3412199025|440099028|12091999003|3071699003|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?RXY0hxOZhlsedrCKNDHjgFhmxe45MSdDXS48N+AkrQwBND6D9NqlsxseLm?=
 =?iso-8859-1?Q?+JDa8Zp1oGvh5CiUZp5l7XAE82pK5CEG+ewh3U+yvF0g+nBcbC/+Tlv4Xc?=
 =?iso-8859-1?Q?Qb7Wi5pxY9021W7iD5fo8YM4R1U3c+0ahgKLemxxlxBLj+qyNPv6BQTxAB?=
 =?iso-8859-1?Q?9BFP6hnCjBQO6FqBl+GmmkmFlxPNJixl9QmX1ahQS3vhbexQ728BQwrt9y?=
 =?iso-8859-1?Q?eUMRe7v9lXWoXmAhBPBj/nK4tYImoBhIOVw45+bFmg2IlsrEneZYOq1xfn?=
 =?iso-8859-1?Q?OPP3x+t52ur1HwyvsTFgL8DJgsRe2AWnCsw0fEvhjjsOPot5CF9dp9pois?=
 =?iso-8859-1?Q?Cg3jW6bQVrYXmDR3QYjgJhwqzMX9gGiyh6yDLB8eVo/ruvNLl9arwKQbR5?=
 =?iso-8859-1?Q?pD7kiBSpN9ENJ2DRV79gnVjniGJOjXbnVASXe3rf5oe6fHTzbGwism5rUp?=
 =?iso-8859-1?Q?No9JDHEsI+r0ob7buiJd2mjfzU9FsB1dvsBcv5KsKnUdUK2iukksN7sz5+?=
 =?iso-8859-1?Q?k9Ho9cVI4AmapLUVDR0/58W14hYz3JWcI7adxWIFIfyN3+6C5/OUEiVKt4?=
 =?iso-8859-1?Q?k5hTgf+CoCo0xpcQii/EJqKHXVkX2BCTNEpHC057pI2yxOWmC+W7zJ4STP?=
 =?iso-8859-1?Q?TLK2iVg0sIs9/lR3k0FApJKp1HQ3Kv9oIp00uGF6LXBhgN74wj7I2k264A?=
 =?iso-8859-1?Q?ApNdXt28oFRTRwvxv/qmgYYdHSkj62mwbcih1+ti+lmF/WZ9b0I59JL/ZM?=
 =?iso-8859-1?Q?Oq+Vq8DhEAfkGEN01pJKwGzVCcnaKjG1pNu4omCiqxC0is27fId8R0mwWp?=
 =?iso-8859-1?Q?AEzbVCxxRJdw1Avem90Iku0eRIzASHW5gogM/QcRRSQDSAoJgubA/OO5I4?=
 =?iso-8859-1?Q?hs3JOdyHTmsLj/xxPxqqVU971Poj1ROggQiSabge0WwEleX7pJHi9SuU13?=
 =?iso-8859-1?Q?OHB3G9Egp+yhp5EkYqys59mRIPVQ9i7fHxLOEGyU+p2sgCz5fRLawpdnGA?=
 =?iso-8859-1?Q?q4bTEdGon3Fv+iUTRTcwOB7WJk7c9jrPLliTun+wGwJTIBzNOKOhAojsvB?=
 =?iso-8859-1?Q?wIU+/ToVunXMMAzI7vm4zQMWhEiLtSpNSmtE5/TomK4DnwAy6Vys6s/F69?=
 =?iso-8859-1?Q?vlvL+vz2hjXfP0C0NthVak6/WDg/qwoYMRUn0BSGvG58mYA00TMdInWskQ?=
 =?iso-8859-1?Q?V5CiOL30ojdIHrzZoswGP1MBMc2P0dVuWrmPxv5Mh5zf3hc7BEVURzK4?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?J3okTkjeewL1J7kP5ctytwYA6e99HuvexGgHqjV5NghFFk3682rmuNHIlM?=
 =?iso-8859-1?Q?5GU1YX2CO1qZB9hQppFnNHWZIg3zg64OX9+X+e0CPluGpbqMvqYeLZr9Pi?=
 =?iso-8859-1?Q?cUtfB7P/6V1yl6yUj9K+FdE7weG3PguLleotpRxXu0sgOs+4v23I0/BZj8?=
 =?iso-8859-1?Q?jcrhQtLD4LPKUKiVSrptzj4LWEHe7PObC/lC4Zl+udtNLpsqkhD28Cay4l?=
 =?iso-8859-1?Q?qbbhlH14NxtHhh7vpkzMhKBEceuAyF6WYFclWlUM0TE+0OsQ+7EY4szBtG?=
 =?iso-8859-1?Q?creLmfmwiYgx2X/9YznsJip4arGJx6vXmxY44QOuU5r8NmrJWmT96FETOF?=
 =?iso-8859-1?Q?WIft5KhLoKmxRQJkCLGKfcYQxyvce27sYxX1K+WryBFMZsciIQ2iH+voez?=
 =?iso-8859-1?Q?wzEu1HJpZWgeAFnq+0hDY83EkLPlHOYhO9av2fErzQtXEyp28CxkNSltgF?=
 =?iso-8859-1?Q?MWfx4CHHKBhTWsC8SVWUyIeqcFmdBknK0RCSkZ38GjYrN3B9O2dDZ6n7uP?=
 =?iso-8859-1?Q?tIRsxvqIVD07JyOxVlWE8Zuck8zpVixnFLpgwlttngv9uEF7nUXR7gq3qL?=
 =?iso-8859-1?Q?mcjn0TgLIoT796sr3P2LmUwKPrv4sgrSThU1BsQtmjIx5ntTo04KDlOzPE?=
 =?iso-8859-1?Q?6cdIgGFVAX64hKpWOCyrXdOi+uxnJH7UxNF/L+iEz2AKdiPzvyo9OeQ82r?=
 =?iso-8859-1?Q?i078xr9dfejc46rU2TKZ/Obq7VA0RKPmL1EFgSFS/s3P48ko67BWUZsz0G?=
 =?iso-8859-1?Q?FJZQvhVnkxkOV4z60lVxSO39Wc79xaHAez5WfKIroWRSFNDW19FDGN4bCl?=
 =?iso-8859-1?Q?1MEvzN2V36B1Sn2yaqmvGYy1gcYj9gcT5jydGBFr5Xg17KCoUYsjZ2PYiA?=
 =?iso-8859-1?Q?PKKcbmZ9p2fRPWmMHzMyNC9Ak1cywXZwxqG76XTIQIhbef9Q5pKrp59oJj?=
 =?iso-8859-1?Q?MNk/pU8WsPCWbE5fJ3pNcsv4KaStaxlyEgEWjvLFuTpv8rsK+Qut6RyY1F?=
 =?iso-8859-1?Q?abE1T3lyGfpTZnlTvmWj6fyt13VgEb50VV/UdHg4ivDKgXX3gebqJ3czEK?=
 =?iso-8859-1?Q?vbMBMyg5g3AHdVy3u4OtkXZpREra7459JIknGLlmc/GUJvW7RwaGNlgrPp?=
 =?iso-8859-1?Q?er7KiX+iSrko/PhxsfG8JzfhKBEkJ2WJ7atBaA/+wW5YG2ejsX+YqO4oZy?=
 =?iso-8859-1?Q?aK0thqNiDaxIi+1W2PFTFMcp6+cW9nU5jqzW519UTIjG2x3Wc7yK4TFy8T?=
 =?iso-8859-1?Q?skVgnrMZCu8CV3prEYKxz65fUtvkhKPtOXI7e4rMEtrQj24erSZ1ixHIh5?=
 =?iso-8859-1?Q?KfYMP/u80KOtJukUl4orLZvMANAgINMWEkWqfk4hkMLnnUTLbspol4paHE?=
 =?iso-8859-1?Q?o1KHS4xwC8Rjq2vE+cAUt5SIwsIrWb/yQ/cmjhzeeiQ07/jnZ0seCDUXdJ?=
 =?iso-8859-1?Q?L+UkNBUy0V0HgfQ1?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f8438c-72a0-4195-886e-08df2d2e3915
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:05.8771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
The block-device SG_IO path copies sense and READ bounce data to=0A=
userspace while the completed request still owns its queue tag.  Either=0A=
copy can fault.  If the fault reads from the same one-tag device, the=0A=
nested I/O cannot obtain a tag and the ioctl remains stuck in=0A=
uninterruptible sleep.=0A=
=0A=
Snapshot all request-backed status, residual, and sense data, then free=0A=
the request before either userspace copy.  Preserve the existing error=0A=
precedence between sense copy and data copyback.=0A=
=0A=
A same-device INQUIRY on a one-tag /dev/sr0 queue hung beyond 10 seconds=0A=
before this change, with sg_io -> blk_rq_unmap_user -> filemap_fault in=0A=
the stack.  The fixed case completed without a stuck task or hung-task=0A=
warning.=0A=
=0A=
Fixes: 31151ba2cef1 ("fix mismerge in ll_rw_blk.c")=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_ioctl.c | 45 +++++++++++++++++++++++++--------------=0A=
 1 file changed, 29 insertions(+), 16 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index c14f81403a09..0d1f8eb22dfb 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -388,41 +388,38 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sde=
v, struct request *rq,=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hd=
r,=0A=
-		struct bio *bio)=0A=
+static int scsi_complete_sghdr_rq(struct sg_io_hdr *hdr, int result,=0A=
+				  unsigned int resid_len,=0A=
+				  const u8 *sense_buffer,=0A=
+				  unsigned int sense_len)=0A=
 {=0A=
-	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);=0A=
-	int r, ret =3D 0;=0A=
+	int ret =3D 0;=0A=
 =0A=
 	/*=0A=
 	 * fill in all the output members=0A=
 	 */=0A=
-	hdr->status =3D scmd->result & 0xff;=0A=
-	hdr->masked_status =3D sg_status_byte(scmd->result);=0A=
+	hdr->status =3D result & 0xff;=0A=
+	hdr->masked_status =3D sg_status_byte(result);=0A=
 	hdr->msg_status =3D COMMAND_COMPLETE;=0A=
-	hdr->host_status =3D host_byte(scmd->result);=0A=
+	hdr->host_status =3D host_byte(result);=0A=
 	hdr->driver_status =3D 0;=0A=
 	if (scsi_status_is_check_condition(hdr->status))=0A=
 		hdr->driver_status =3D DRIVER_SENSE;=0A=
 	hdr->info =3D 0;=0A=
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)=0A=
 		hdr->info |=3D SG_INFO_CHECK;=0A=
-	hdr->resid =3D scmd->resid_len;=0A=
+	hdr->resid =3D resid_len;=0A=
 	hdr->sb_len_wr =3D 0;=0A=
 =0A=
-	if (scmd->sense_len && hdr->sbp) {=0A=
-		int len =3D min((unsigned int) hdr->mx_sb_len, scmd->sense_len);=0A=
+	if (sense_len && hdr->sbp) {=0A=
+		int len =3D min_t(unsigned int, hdr->mx_sb_len, sense_len);=0A=
 =0A=
-		if (!copy_to_user(hdr->sbp, scmd->sense_buffer, len))=0A=
+		if (!copy_to_user(hdr->sbp, sense_buffer, len))=0A=
 			hdr->sb_len_wr =3D len;=0A=
 		else=0A=
 			ret =3D -EFAULT;=0A=
 	}=0A=
 =0A=
-	r =3D blk_rq_unmap_user(bio);=0A=
-	if (!ret)=0A=
-		ret =3D r;=0A=
-=0A=
 	return ret;=0A=
 }=0A=
 =0A=
@@ -436,6 +433,9 @@ static int sg_io(struct scsi_device *sdev, struct sg_io=
_hdr *hdr,=0A=
 	struct request *rq;=0A=
 	struct scsi_cmnd *scmd;=0A=
 	struct bio *bio;=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	unsigned int sense_len, resid_len;=0A=
+	int result, unmap_ret;=0A=
 =0A=
 	if (hdr->interface_id !=3D 'S')=0A=
 		return -EINVAL;=0A=
@@ -487,7 +487,20 @@ static int sg_io(struct scsi_device *sdev, struct sg_i=
o_hdr *hdr,=0A=
 =0A=
 	hdr->duration =3D jiffies_to_msecs(jiffies - start_time);=0A=
 =0A=
-	ret =3D scsi_complete_sghdr_rq(rq, hdr, bio);=0A=
+	result =3D scmd->result;=0A=
+	resid_len =3D scmd->resid_len;=0A=
+	sense_len =3D min_t(unsigned int, scmd->sense_len,=0A=
+			  sizeof(sense_buffer));=0A=
+	if (sense_len)=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
+=0A=
+	blk_mq_free_request(rq);=0A=
+	ret =3D scsi_complete_sghdr_rq(hdr, result, resid_len, sense_buffer,=0A=
+				     sense_len);=0A=
+	unmap_ret =3D blk_rq_unmap_user(bio);=0A=
+	if (!ret)=0A=
+		ret =3D unmap_ret;=0A=
+	return ret;=0A=
 =0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
