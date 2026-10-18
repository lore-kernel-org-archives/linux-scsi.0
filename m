Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639AF3A9629;
	Sun, 18 Oct 2026 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338072; cv=fail; b=rTM/mmALk3rLXp3dZL1cnXcIf3ALj76bjP8QHAci3LKt9OrWvZaYikKssYKVD8s1jXvcHr4MbiHjEcdxyh9igBHvWiiWIcijKQ/yXu04nMWjsKBmLQKFCTY5eb2OEGMzAUG/yTuhqUicpYSvj1QCSqyWrZiaLxosDbo7F8p1aDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338072; c=relaxed/simple;
	bh=VIHeK8b/UFnGOM65p8188RmAllrYcuu70qVqPFU6Zsc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dmCtOcSMzMQNBPFkALw5z7bu/ptVfYYJI1oGIke1coydqnsOvMX47iy3JZ1+pbNdN2ZCVWu0EQ7ydHgD3ROEA1u4Yj58VopZpNheewFocK3coS7tu+BDw/a3rbEJ+2ogJRjuS9goo/EEolXA6dUfkzIHfau7NCFp2i9jlFZt728=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=A8c71aUi; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="A8c71aUi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssKnZT+V2tXRPyWRCissPlAQzZ55FGBWsi+bXWJCif5tDIqPlG327X0ckmNnTpG49o2J/WTXCxkeyDgEPJWTtCano9Duw49w5juuidW9FhE1KddHVzDeHgY4srvsvBaLhdez7PM/KTu/om1kXEiuak34f+cHk693q6ely62J4tzUybPUqrOfuX7pxqljEBCoULhbGmuR0dBcHqIoTw9XNJByhnG9Z+olEiCMWHUF2NTd2q4wDLVltdYndPnFrUPwMEy1ZDY+pgBMppeOOmXTCH56cW+hg9Rbqm46ClXtEi8NNcSVA0t7Eya5lOugQB487ZD6Ra0fG9zg30fW2Bl6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=JKpO6x5gS8fmcKUU1b6xMGuE3DZltCPEfjzIXX71U10=;
 b=VR46YMFVNqiHN89TglEzaIrUP5WTxAQrpz7kQ98jepes0yeBB63ZXL+7UxPcxwyjGCAz7n7czJQb3GHaPqAJh7OmhFO7cXSf9Ujjyxvu+ELgC4N/2qT9tsV6XttdSDKhszeB0D7exvy0DnWy5dGn6skUnZNN/S9HrgP+CapzQKhbYfNmlUAmkAqTHXDjOuZAjLAD+ezceL3g8OhrbB6pQh8Fi719Md6SmwTRwGb9sCMJd0pdXWt9bdLzutiT6T5sEsvI6ciueIJZGCCXQDLRcgPSWvw/Uc/48KtPof03WOr6kOuHi1PtbogoWgDhblROICe8xWRajhRGu08lx1Ap2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKpO6x5gS8fmcKUU1b6xMGuE3DZltCPEfjzIXX71U10=;
 b=A8c71aUiWdNgM5Zt87fQYZ4KGFPZcXMkdMR+b/XyuT0hbAnN47w1ppH+fit/ZZP3Q6LcpMdlSStp4kVHpn8/ttcxo/JoA5nni8JqOrheYy0GPiNc6/9GtuI2UpuwYcgMQ0BgJ94qsbJIQAb8IVUlZjOt1VrKUXolyomRUKhT7V9pk+YXCmSDQ+yAh3Y2iB6z7SyPwyfMtH9Jyh+aV0BszZhz6vQrvs2/vauVpH5G8IG/fFfS3mriGVeZRV2QF7ytXwX0USERtNRJZWk/VAoYvtRp/Lx4FuAe5mzDYxVNJiHFoAPq8LqpOdxraUoFA2hWkSnn3kXJLvRWeeKeADB7lw==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:09 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:09 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 3/6] scsi: bsg: release synchronous request before user
 copyback
Thread-Topic: [PATCH 3/6] scsi: bsg: release synchronous request before user
 copyback
Thread-Index: AQHdXxcY43E0sOeev0i/Rflx46gR6w==
Date: Sun, 18 Oct 2026 15:41:09 +0000
Message-ID:
 <2595ea8f051a137740c93ffde0d3d7e5a863d8e9.1792237341.git.x-professor@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: dee7fa59-e5e6-4d6b-9fb2-08df2d2e3b2e
x-microsoft-antispam:
 BCL:0;ARA:14566002|8022599003|24021099003|15080799012|12121999013|22091999003|41001999006|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|25010399006|102099032|3412199025|440099028|12091999003|3071699003|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Zmc6KGdAlQlbiMX3UfjeM4UcGV715ly5g5XyZjd1RWRQfMp58Gbonf0Vra?=
 =?iso-8859-1?Q?pxpLn7pQTxxDgtEEy4bIRlyxsOJRiXXlmVMhW2SrTgGuXM4Ywqf50Kb+WE?=
 =?iso-8859-1?Q?xGyPkzXVFd7AAYPD0HAm5R16YEIeGVkU/i5o9azy023FFM21/lV9i6jr6g?=
 =?iso-8859-1?Q?JD6wtXfjd6yPiWPpVXG59itx0byYHntslqhKR6LLVXoWiUJGRzZK4G7/ns?=
 =?iso-8859-1?Q?efyZD43CwqndjVfWAODmQg2KCnvADSHlY3yaG9YdBoZTpfVX8kTneKYK0l?=
 =?iso-8859-1?Q?+D0b88ABpBOXS80LmIG2FN6KYOQVIlb8O1NWwUVmpl5CaxtLswVPNc2ypK?=
 =?iso-8859-1?Q?uHMQc21srMZ49hJm0FmPKyapsyU849h7sdOaHj/GJZldyhVGQQvovCZiVF?=
 =?iso-8859-1?Q?7dpRYcGRBl+PXqgl0dxsTqCgzJi5CSdEcxHpIsTl/YyQyfjzZXW+JL6a9y?=
 =?iso-8859-1?Q?xnO9eaRdzj4kbN32X52Q+/OBNgb+wmYT/1i6RxdMm/AXIrTiAoEdIM/0pz?=
 =?iso-8859-1?Q?w+tRKyL5QSaFw7LHOIIIyxBYEQ5qFBHD5tq3f+THj4NqkrdSzf28Qaqvno?=
 =?iso-8859-1?Q?dvSz96Vopxp8RgIENu3i3qGd8WNQTpxvDSvylPc++2fxBCp6bx5LSelh3R?=
 =?iso-8859-1?Q?J6iI52a1PcHZNurP4A8+btrcPrTdmZpDviaSqocp42tkhTj2io3cwwnkJz?=
 =?iso-8859-1?Q?Q9Lcd4psa04cRxnoiW9TtPzL0dU0BRQCW6V7l7e7IhWSNgKYmGCSGmKs0/?=
 =?iso-8859-1?Q?cShVwSfD6/tMRJG4VKRhcveoGI5ZKGSM7ia/4diz14suI0yKdVNExsPUHN?=
 =?iso-8859-1?Q?ULofffnTD2wSCqZNGe8kylKPqEdOaxSMSydzKwOx/PyO3vVFIMYDYNnEj1?=
 =?iso-8859-1?Q?ehZWQWCUFRsjCbAD2tsPK0jiPFz2FkQjB1rE257cFk/ULZG9RE1isssZR0?=
 =?iso-8859-1?Q?rgi+h5CjeBPxsoAFV+HKnIpA0N9EJ9Y5k5vuVg8rNZrHD3vvrJTSQTRqST?=
 =?iso-8859-1?Q?11evgOfM9jPI5lnetNAtZq+M6HUoJ9qnJ5C2tXfmPiv8m0Ynm+OUHLs1qU?=
 =?iso-8859-1?Q?1MWK3PQj1EE2gMquI0NPujbhkUIIZER5B0KkJPO2uXirqQ81fGtVo07mG2?=
 =?iso-8859-1?Q?WrCzphIiFif6GH/2aMURK53lkPaa/EtqTNEopxQJ8fjVwtWcRPCtiyZM6A?=
 =?iso-8859-1?Q?1NPeZz2yVEi198Aj2/HgWk3GW2c+m+gVZGX3oG991IHIZva/3NINSpVe?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?fZ9SyrwAhU72Gk8ctvQLAVFAqIXdZKvQtTaf58IVTYHNxcjF51rWAGRu1R?=
 =?iso-8859-1?Q?/tpKWavAHI9mtMcnnVbHYGJrtFLHgdADjQksEIfwei4IdvPSJPQCA+gftO?=
 =?iso-8859-1?Q?uUNSif5jnxyikzhYbgbye8YmzxgheyqHbPiONRPrgqte8eLYnL0mREe6/e?=
 =?iso-8859-1?Q?Rk6X/Bsr8Xsy6F+lcZpl9rOlIZM5dDAVZEuDuPmIaYDCRdZgz2ADfeiigZ?=
 =?iso-8859-1?Q?uGnkpnmakUjdnZYNjSCioS05z+Hx421V7CxtgUqbPOrxWUtmVVKlA8GntL?=
 =?iso-8859-1?Q?To8wqQXjm40Y6tUsWHw+X8I10G84i4xywYY3QVqJfFyENGB7Vtjn/4FMjP?=
 =?iso-8859-1?Q?UBiLLxs/xPjJgQ1rjPC3P+eVJ1Jp9mYzJEDcMjkIb/T1y5rb2UtFVh/UAe?=
 =?iso-8859-1?Q?Lk4VvZUn5NtodYX7C9s76U68LIpC0gJE/OTuFeu4JAiJWI42RdeDlHEbI8?=
 =?iso-8859-1?Q?ENBlxkFVfhLlHN+m6F2vO9YayoYiG034TxD74qREEAkAnGwXejO4ltp/DG?=
 =?iso-8859-1?Q?K5+7FDAFEHRFYoZo31QLyGRcaQ1B/Vd+S2SbA/UG98iFrz63CbsQE+LZ/H?=
 =?iso-8859-1?Q?VR7ciEowd0X01rjCDGdT+NsBNZmcekDpX1AN7j5I8LU2YD/b44aUCbusE6?=
 =?iso-8859-1?Q?w+2t4+HngTUPi34Wr7Sf1J598hF0rIeBhReV/S5N6q4CQgzwr+J7odwMsb?=
 =?iso-8859-1?Q?3IeMhli1hcsH/qdZHIaUIfSdrnU9+W2h1LkiiKeQbTQC58IF9iIi4JxJtl?=
 =?iso-8859-1?Q?mXCXywY+iOETKRd40T4SUk5S+tP+rkKwOH+d0K+c32GSyaZ1wyRAwstLd9?=
 =?iso-8859-1?Q?Xv2W0aZkAu+A92r/6jZEYK/riwLAY5gufKYn5ApdQEO4xz24r6Y02JvCLe?=
 =?iso-8859-1?Q?cBIPX5cc1A+igu+cUO1EsN0ZMmpCNknBn5MaN0fwwDFwVKu32PPVg86ZKA?=
 =?iso-8859-1?Q?miQuTho6ZxdwZOEt/dQafdk4qRN66TlVvlp7mSwNHJ3zYNw0fZ5alvIhJj?=
 =?iso-8859-1?Q?zRLVAZE6/of8fgG6EDaU3yWWEVQophBbwEpqk+VVe9bB1khMYBNzZTQPDX?=
 =?iso-8859-1?Q?E2aE1kGh7ypU117QN1wYzVhhGmzT5lYug9YUIJENlSHM6yfhA+PXbXZgjA?=
 =?iso-8859-1?Q?Q4Sfccsk6mA+VEXdXzQQtOyLsIGT1jN/aHHnP4MGL2z8+8EJx1DKdYnMVx?=
 =?iso-8859-1?Q?F8iT5KVwYZIQ7fzph3vqDj7hG37WR8lbbWFuBWjBC6H3yVy00ORskpoZXP?=
 =?iso-8859-1?Q?9/x498t7YP8Gh5E8TfgQdwRQ/wCQRTbZZXxbXOqkX73ceRJNdx9/JAiy8E?=
 =?iso-8859-1?Q?IfnllpTd1ugqnnOzE2AAac8H0fkZPs8bUhTQS+fStqZGTk9g2XURtHUNmC?=
 =?iso-8859-1?Q?O2Wa31/AZ+BqwAa922mBjNGBaQr4MIDKKZ8Od8MunwVuFpvjwXhbt78Byz?=
 =?iso-8859-1?Q?hhEx5NycCEsStVNd?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dee7fa59-e5e6-4d6b-9fb2-08df2d2e3b2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:09.4459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
scsi_bsg_sg_io_fn() retains a completed request while copying both sense=0A=
data and READ bounce data to userspace.  A fault on a mapping of the=0A=
same one-tag SCSI device starts nested I/O that cannot acquire the=0A=
retained tag.=0A=
=0A=
Snapshot the request-backed completion fields and sense data, save the=0A=
transfer direction, and free the request before either userspace copy.=0A=
The retained bio can then be unmapped safely.=0A=
=0A=
A BSG INQUIRY into a nonresident mapping of the same /dev/sr0 queue=0A=
previously remained in D state in blk_rq_unmap_user -> filemap_fault.=0A=
The fixed trigger returned in 0.06 seconds and produced no hung-task=0A=
report.=0A=
=0A=
Fixes: 10e8855b9451 ("bsg: add SG_IO to SG v4")=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 31 ++++++++++++++++++++++---------=0A=
 1 file changed, 22 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index 5eec248a77a6..4937bc494f79 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -199,6 +199,10 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, =
struct sg_io_v4 *hdr,=0A=
 	struct scsi_cmnd *scmd;=0A=
 	struct request *rq;=0A=
 	struct bio *bio;=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	u32 scsi_result, resid_len;=0A=
+	u8 sense_len;=0A=
+	bool is_read;=0A=
 	int ret;=0A=
 =0A=
 	if (hdr->protocol !=3D BSG_PROTOCOL_SCSI  ||=0A=
@@ -243,37 +247,46 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q,=
 struct sg_io_v4 *hdr,=0A=
 =0A=
 	bio =3D rq->bio;=0A=
 	blk_execute_rq(rq, !(hdr->flags & BSG_FLAG_Q_AT_TAIL));=0A=
+	scsi_result =3D scmd->result;=0A=
+	resid_len =3D scmd->resid_len;=0A=
+	sense_len =3D min_t(unsigned int, scmd->sense_len,=0A=
+			  sizeof(sense_buffer));=0A=
+	if (sense_len)=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
+	is_read =3D rq_data_dir(rq) =3D=3D READ;=0A=
+	blk_mq_free_request(rq);=0A=
 =0A=
 	/*=0A=
 	 * fill in all the output members=0A=
 	 */=0A=
-	hdr->device_status =3D scmd->result & 0xff;=0A=
-	hdr->transport_status =3D host_byte(scmd->result);=0A=
+	hdr->device_status =3D scsi_result & 0xff;=0A=
+	hdr->transport_status =3D host_byte(scsi_result);=0A=
 	hdr->driver_status =3D 0;=0A=
-	if (scsi_status_is_check_condition(scmd->result))=0A=
+	if (scsi_status_is_check_condition(scsi_result))=0A=
 		hdr->driver_status =3D DRIVER_SENSE;=0A=
 	hdr->info =3D 0;=0A=
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)=0A=
 		hdr->info |=3D SG_INFO_CHECK;=0A=
 	hdr->response_len =3D 0;=0A=
 =0A=
-	if (scmd->sense_len && hdr->response) {=0A=
+	if (sense_len && hdr->response) {=0A=
 		int len =3D min_t(unsigned int, hdr->max_response_len,=0A=
-				scmd->sense_len);=0A=
+				sense_len);=0A=
 =0A=
-		if (copy_to_user(uptr64(hdr->response), scmd->sense_buffer,=0A=
+		if (copy_to_user(uptr64(hdr->response), sense_buffer,=0A=
 				 len))=0A=
 			ret =3D -EFAULT;=0A=
 		else=0A=
 			hdr->response_len =3D len;=0A=
 	}=0A=
 =0A=
-	if (rq_data_dir(rq) =3D=3D READ)=0A=
-		hdr->din_resid =3D scmd->resid_len;=0A=
+	if (is_read)=0A=
+		hdr->din_resid =3D resid_len;=0A=
 	else=0A=
-		hdr->dout_resid =3D scmd->resid_len;=0A=
+		hdr->dout_resid =3D resid_len;=0A=
 =0A=
 	blk_rq_unmap_user(bio);=0A=
+	return ret;=0A=
 =0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
