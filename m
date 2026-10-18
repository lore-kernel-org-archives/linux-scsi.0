Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3603AEF37;
	Sun, 18 Oct 2026 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338075; cv=fail; b=i/9X8XeN58M+qGqe02D/cqpf5mLCzwNxBHvY3lDxWuOO2OFl+b7eBQ2e7A2dM5Eoe3pR9A+uzucahUKTRqL0dVSaAdCmsIBy4/8YsVlH5MfkfLyxBTcaw3lSXDf6A8qQkwKzAuG3ughXjq5UuK3Ka3JsdrwDQq+2vzw6NiKua5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338075; c=relaxed/simple;
	bh=KdAffkDSIgbTjWQyr5vJfp9ryR5tLT2VX+zgyqJPzqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PnPtOYnqUxFeB8kNvd1sjhO8H0VXzEzgmkw7reO4JhMOucgxjd+aZdEwrRHeVYtg5bQyHGTWhWX8gAaChdpXKGDuq8LpuCwKHoBlN2/9okX1BnsE9jRyrXgzSWMLdmAZYxgOOH/jhiq/SfF3Y7d4ATDFBLzFMUXAkzRBjh66rVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=bxnSGg22; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="bxnSGg22"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vD+Hq3D181tu/7zGPLenMxB3NE/GxNZwJ/DT+Y5/6ZEX8xx9j1zuTCqJKD0e9WMySZSsyubnwE574wvJqkbprZgfgNObn+SvGpuBzLlsmOofYo+o3AVWYUB0iKefb4ugfJdI86yp6AdH5SA/8loQMBGBFoLqpmF8XplVKJRLiGUenUVClhheaRweSbYwXNvW0kddYHyhaqmXXjrB36Ng18p81jjDhEIuGyi36FUwFtbQ2mlAjTtEWBBRSKa1Mpfx9kouei0qEtDM9Pw36HX5mwB8UQjtN2R09NJBiBjLNc/ifPhbbAVpJ8OUFj9IpXUPi2l5Zc/1FcyYcnJPPqFetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=vVMYiet7Uyl7fF+lDBuL+DCcYnTiWwa/0Dv7Z1JvjN8=;
 b=bLOazzATkqydB+J4huxMFKkKNsUauE7LyfRyALAD2huNoNXaiST8KXd8Qm4x0PbW3xBj1E2kvPRilO0TeTiwOZ5r4f03acIko6+gccnqWW9AxXiR5mzTcFOYEQ53q2l2VRqamPnsTAe1ymrkYZqYy2Hz8IiEzhC9+5s56hKmqz11nrKJ76fPvMYeX2lzmh91AOlZwvWoduQ4FUcTfAz0I219sATrEaTX9ywsRow+r4EV9zla+FO0NFMKaEsHDlKbcOYtfvYiWNEu/HTKT4oEjSO6HAKpSMDWv6xzWdQMj5JZWR354o9FIIuKEU8Q/vj0pl4+px083mMny6biSOc8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVMYiet7Uyl7fF+lDBuL+DCcYnTiWwa/0Dv7Z1JvjN8=;
 b=bxnSGg22KGu4wN+JEXmRCqXc51BjyLDBz0w7VlvMSKI8KkdoxvRU3yXKaMakkLaF5pJseTb5uL6FuwbXFYgdpnoxX/wWnNp7I36MqhSeoUzCNVx1JlswN7KEgAxQceeL4SsOqIHo9NppRIA2wg7cwRoE9o8IRBVWefHTZnU/7b/CBIDrkJPMnsu8i6VKqlW1dNvTULfL4ixe+x1rbC2ui5h+LcL8iIrAE8rOosT1Jz6vCg0vC7nqlwh7g4tytMSpMBkj4V78CgEkigpWXiFNQEvGwPDvduO+Ul942NMls4mkaBtI4ArfnWIoZTTx3avl470Qp/WWBY/I585Ut5YeRg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:12 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:12 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 5/6] scsi: bsg: release io_uring request before user copyback
Thread-Topic: [PATCH 5/6] scsi: bsg: release io_uring request before user
 copyback
Thread-Index: AQHdXxca3KtomOGKKkuQYYB6q35LMQ==
Date: Sun, 18 Oct 2026 15:41:12 +0000
Message-ID:
 <81b5a30fed70a558e997f09f9ec9868bd8ac97c2.1792237341.git.x-professor@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: d80aa9f0-ce8e-4ab1-4d98-08df2d2e3cdf
x-ms-exchange-slblob-mailprops:
 EgT5Wr3QDKyfJ5ctroE+AnoJKQNH7uyZHrcqCMgL0+jEzG3kuIRQ4aY2aYoGu5j+ulOZJ9nLRWsTnG+RXh52WMqz4whIy/NLCQNH37HlyGqia6FYrkix2S1lF4MazlUHfrHsgvDUftNHhmJ3SACW75D3Gr+EEXi1Yt1IhiNAqZNuGyTQEuOCPs3Jyzj9YhETrXJgSiR8zXyz01mh/jYy+v/gD3JMKYX2/wlC6qe+z9AizkNgLoZfkDznavljSxUgF8pPG/mdFH3IJVGWfC3nBz4R487+cUbTVJpwVAcYAEWsgmOEl0PdZpMK/I1vIlvBun5QVnLej+Ax+n5AX56/3d3Pk77GiCPsFOwROzqU9SZ4R4mXFRPvomf0PTj7BFHG5MXQNqniz3nn8dCBEo0COK8m6MURfojK0qyDF0YODKHZ1NEe/r3KgkI2rzamWrakSR/ZeB9ok1r2xctAOszPhzT18f03MdlovCXjGFPOvAcTZYGJlDwN3BgTHsrlTfzDHTckvF1FNwyn842vD/hhEB20vULoYIrFLNRQqbSXfTQWgwbBqzTdOP+cjKBuVEokDv2cIDOydCKuSGD4UCT3p4E0UwGFe8leoMbWOrkNX7ufbtDXBf+YglAVu1BtqQriXdcLIYDkI8zfzgGiC0SOJc2WWus/KDQf6DKonQ7QOEypRBg9WJ9v/FP9pUhBlK+h/5PJJ+RVKyBZj8ubXbjmXbUy+3aTltNtQEFsQbJOwIc=
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|15080799012|39105399006|12121999013|22091999003|22121099003|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|4040399003|4140399003|102099032|3412199025|440099028|53005399003|40105399003|12091999003|26121999007|3430499035|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?n++v+v8JbnhdaM5mPij9AeizCX+kMxIGNOkg07v7e4aBO75br9z90pUAZO?=
 =?iso-8859-1?Q?NLEc5dgxf1zI3g61TuDttY9yqHhqD4hgm3Fo+EWrzyJujZ20cMYC/mvZFx?=
 =?iso-8859-1?Q?4bsaM3IhUKYYaigRPpZwiM71G4LcrwZvB3PLsXyeGP4tCqAPKVKSbSpYss?=
 =?iso-8859-1?Q?h/utXNgnYiHoEq5C2QHnI72F3J7PZhrrajx+YXs4n82IQ05ELYAR81DRdX?=
 =?iso-8859-1?Q?E4QMzyNJNk14fO+DpUGFC2PJe/Mx8xVeRBIt1x8n7crQhVrY+HOcNCsD01?=
 =?iso-8859-1?Q?k6jOfJ03Gm4ngL3HaWS0ugzuFWEQHYKJWAS2vswN92mNRCXzio6pInsjim?=
 =?iso-8859-1?Q?2xYiRN8bogvU5sz7kYiz1IzICs1ZhaZ3dG3tjGulYziR++0dmpanKzaKGn?=
 =?iso-8859-1?Q?loOvGcVMMgKB0nTRwiafvZ5OzMwo9485MidlAnpzyfl0xsEeOsOBS+Qj5i?=
 =?iso-8859-1?Q?vCRNieOnt/0Z7cIjHMAXFRllA7P6PV/dqwI9vitgD7mcDxNBzY19InGfnu?=
 =?iso-8859-1?Q?3iX5bDqAWa9H1oSzC9MTffZfgauBDw57FIKxBdCRVAIuHeDEEfC1wF+U5h?=
 =?iso-8859-1?Q?lSxy+FsB6E5p+1OMrefgy18G9r4InYNJLSC0FINI7iBJakiSqau+/4b6LZ?=
 =?iso-8859-1?Q?b5KB4Zwwq5w/LLUpf3xZ6Yjr8n1BAglDYmscZXwV6VFew+uPBWWoE5T2Pl?=
 =?iso-8859-1?Q?r8QJBtvsDbP8BdUDnrzdsvqoKh5ka1I75eLh/rw5j+5zyFxYdBGHU21mEP?=
 =?iso-8859-1?Q?UULrnBLxecg+MBvTPNNj5o6cBLzsQWDc/zBF/9wVpZ+Z92li6clFDZ9Vlm?=
 =?iso-8859-1?Q?S3b1JHiDWu2b1bzNtkmdCfzCo2bJyygNv4pAzCN9DOJAf+9itD4ToQf0rA?=
 =?iso-8859-1?Q?Q3+Kmc5TqiPenRYxGqYb+rr9s9wZLfW8ri4b+TD3ljhTyL22JdvTe6k8X2?=
 =?iso-8859-1?Q?j9Fz16e0flXRZRl3VRSdy+lfS0fvNDXMUfTrc9nJev2WYsw5DwUuab5Nwb?=
 =?iso-8859-1?Q?iTO8elgKLxEovNzzNEMg5OCU5UtaVhlR5culGiB0CqipR0qlCY2S4CoTfQ?=
 =?iso-8859-1?Q?3a05rlRj8dA9vz0vXUPzp2mIx+u15ZgCmli7LMqeWR0syC9Q79m5+u6pwo?=
 =?iso-8859-1?Q?BnIx6JFXJGwuSt2Z5sBqN9bd09FY1lS6jkqLChcC3T+2Q9chPPbeJ/kY8s?=
 =?iso-8859-1?Q?btcVzQrPny7sq1fnEVXV0ULESUTXIKI6ro7VimMnQWgcrBpxAt/j+d7OLJ?=
 =?iso-8859-1?Q?m/9LEms6c+lWY4zxcVxA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?fWmvAH3rebZaYn9JPJh9TySdSyH1RdUdTfodK/ILOuD7/695Nlx6RJD5el?=
 =?iso-8859-1?Q?x+ijAmvOItTOWEOQGcX7U/re6IwDhZZaLB+ga9t+8YU5uZvujcl2uKbNWh?=
 =?iso-8859-1?Q?ZHwKH59xjbZiPe/26H3RimqfuUPyoC1E1eE+HtENOCkehUC1fiJuaylqe/?=
 =?iso-8859-1?Q?a26nO3Z4oHXSTWYr/khvTb/d8vt2KbIXiXIeQCbkKCxrM7ljYTuvKkUVEP?=
 =?iso-8859-1?Q?hplL4jPJCUYTba09h+sF+1uOtLmMzTcWWo0e61BdvSiI/HquQ/r5P68HRo?=
 =?iso-8859-1?Q?k8H9HPj+Dycks2GgYOTlA8T1Aqqq4A8yxFOZRTYUvWHpQmE1Voklym7AXg?=
 =?iso-8859-1?Q?ZebPRYCbCj00NWcsps9NSDMZlgrgNIQB/vfjBVHy8veYP+1mypqLGjL6Z5?=
 =?iso-8859-1?Q?fk3ESaeQ/xqWBFDqSuhrK3kviriMq+bBe5ClDCat5g5tGPBRzrbUnCvBCO?=
 =?iso-8859-1?Q?dFvXF4ynTZG4tjCD7PyS3hGO/WKNLfv2EsHsPt0rrXLX5qKbMMQEha2eVo?=
 =?iso-8859-1?Q?GaIagzwpbrUN3y55Xg8NTFSzQew8i+IRrZvm0iuRpaYynuAdIZxSnP4yJC?=
 =?iso-8859-1?Q?1LA7Hkr9YLhSc1NLd73qRjnjUPf+PQo9YS7GqZtSej+oF7JnZZn/17BnEh?=
 =?iso-8859-1?Q?v5iqb9xN/kMyoPpLR/AaMqsF3zf2pg5RlWqemYvD1D1EjRgo997HUT8meS?=
 =?iso-8859-1?Q?RpPj5/9o0xLka6F3/082S1ifPQ79/9Na09RvqsxAKkmMkbe9hP4GBmue4u?=
 =?iso-8859-1?Q?KHvR+FKZedaytaNWf0+5JrFCsX19Y93zjmQLBg77pbON17hha40X7eBI6C?=
 =?iso-8859-1?Q?2IsUx8PtjXC19FLqg8ZJq06wW68dHhINr+zDiGK/OHOsd46ipmAFgSrHkf?=
 =?iso-8859-1?Q?sVXM8BLHF7BggHHIF/AUcqAAu1GEHjQ4vsCwIux5g81gfJkVntDYInBnfT?=
 =?iso-8859-1?Q?x/0osvdxrjMGsEB6/HTrdYf7N9T66ZPM9/iYjXDWU6573LnoMgUCBY+vep?=
 =?iso-8859-1?Q?blDmuVH5JE6PX7OA8wi6VLgyyUipKRhu+Y7lddVVEAVlTY7kkt1/SiSZTC?=
 =?iso-8859-1?Q?N8msCQyTZNg5W3mRAw4xo9ymsiYTJ/Cam55CwVy0H10mmSsm4PX/YU2lnq?=
 =?iso-8859-1?Q?bQyhHn6+03ZuG82R7VljKfmKCx7JCtJV7X8Y6Tw4t3pHRfQberAAR0JRvn?=
 =?iso-8859-1?Q?qeM8eTwrTMhujoHa4ddbRjKC+Zw25/CWqJTUpiehX7T8jGUOLw5v9QqrH3?=
 =?iso-8859-1?Q?zMmiSTL/LDBMmx5Nc8iJgp+u8tPcSqrJBKSK/ILQbIWiy4p2rK+9AAgMV8?=
 =?iso-8859-1?Q?1eM9qrbNBqHMxtdjYuiFmarfYYULo5AqgZ+v+Inw5IYoth1jQe2yDduZMA?=
 =?iso-8859-1?Q?9N0BPTcrdre33fOUrYZVr+e1a7wpWB67pH2r0TNtkY8+09+fokOmoYCR67?=
 =?iso-8859-1?Q?wdfvlwgQJ6zbunPi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d80aa9f0-ce8e-4ab1-4d98-08df2d2e3cdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:12.2414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
The BSG io_uring end-I/O callback returns RQ_END_IO_NONE, so task work=0A=
still owns the completed request and its tag.  Task work then copies=0A=
READ bounce data and optional sense data to userspace.  A fault on the=0A=
same one-tag device deadlocks nested I/O behind the retained request.=0A=
=0A=
Snapshot the result, residual, and sense bytes into local storage, then=0A=
free the request before either userspace copy.=0A=
=0A=
A current-mainline BSG INQUIRY into a nonresident mapping of the same=0A=
/dev/sr0 queue previously stuck in scsi_bsg_uring_task_cb ->=0A=
blk_rq_unmap_user -> filemap_fault.  The fixed kernel completed 20/20=0A=
repetitions and left no blocked I/O or hung-task report.=0A=
=0A=
Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 23 ++++++++++++++---------=0A=
 1 file changed, 14 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index f95dc5da7480..341142dda71d 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -35,32 +35,37 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_=
req, io_tw_token_t tw)=0A=
 	struct scsi_bsg_uring_cmd_pdu *pdu =3D scsi_bsg_uring_cmd_pdu(ioucmd);=0A=
 	struct request *rq =3D pdu->req;=0A=
 	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	u32 scsi_result =3D scmd->result;=0A=
+	u32 resid_len =3D scmd->resid_len;=0A=
 	u64 res2;=0A=
 	int ret =3D 0;=0A=
 	u8 driver_status =3D 0;=0A=
 	u8 sense_len_wr =3D 0;=0A=
 =0A=
-	if (pdu->bio)=0A=
-		blk_rq_unmap_user(pdu->bio);=0A=
-=0A=
-	if (scsi_status_is_check_condition(scmd->result)) {=0A=
+	if (scsi_status_is_check_condition(scsi_result)) {=0A=
 		driver_status =3D DRIVER_SENSE;=0A=
 		if (pdu->response_addr)=0A=
 			sense_len_wr =3D min_t(unsigned int, pdu->max_response_len,=0A=
 					     scmd->sense_len);=0A=
 	}=0A=
+	if (sense_len_wr)=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len_wr);=0A=
+=0A=
+	blk_mq_free_request(rq);=0A=
+	if (pdu->bio)=0A=
+		blk_rq_unmap_user(pdu->bio);=0A=
 =0A=
 	if (sense_len_wr) {=0A=
-		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,=0A=
+		if (copy_to_user(uptr64(pdu->response_addr), sense_buffer,=0A=
 				 sense_len_wr))=0A=
 			ret =3D -EFAULT;=0A=
 	}=0A=
 =0A=
-	res2 =3D bsg_scsi_res2_build(status_byte(scmd->result), driver_status,=0A=
-				  host_byte(scmd->result), sense_len_wr,=0A=
-				  scmd->resid_len);=0A=
+	res2 =3D bsg_scsi_res2_build(status_byte(scsi_result),=0A=
+				   driver_status, host_byte(scsi_result),=0A=
+				   sense_len_wr, resid_len);=0A=
 =0A=
-	blk_mq_free_request(rq);=0A=
 	io_uring_cmd_done32(ioucmd, ret, res2,=0A=
 			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);=0A=
 }=0A=
-- =0A=
2.43.0=0A=
=0A=
