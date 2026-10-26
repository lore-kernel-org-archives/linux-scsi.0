Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003384;
	b=VaWNF/obmrOA2yPS591P8JSnrve04DcEBuNWFYI8J9jdwfeonotGnV3F530AQx4tzr+6
	 f2FpvpsG+dpMydxlErPZqNivax/xMiQO/tbdU0Jvvd/rYUs1Fl76mxBmhaJ1+wosmoplV
	 GdlTDFAJp/baAC/XQXVjsJnim1Zz8y5JMPMTSDID3rygSrGGy7KVIlwte51CWx+EQI/7d
	 tJpBVlEWZRq/z1Xhfgl6I/MPvL5Cqb6vovgDg5JkjIQKjTHUpiJPgONa1eY+oZgAtT5jy
	 HZkfRwlH+KdC+KDp7R8MrzlsvECdsQBigfrieqzn5Tjc/ibmyV8ni++SKO/7y5JlDKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003384;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DUodekpOyPjjjGhk+dhiUqAve6MT0kLd+rkU4t7IN9M=;
	b=qVmaE0WoHCPwh2CpIDeoh/m8QM0rM+KauwWulf1Br+l5ZG10YCEbk6/gTqd+EjECjOrT
	 9a8hO2wYeHNHQZS1+Gzzl5y/UKur8wgMYpdgoC4pgqa1vxzMcKMXtJsYNEBiHrs3aMWQd
	 7I2AX+t1TJx+7Qi+ZMCwMVGW5P8dbdIgnncVoXMQ3OlEs3ss2ubeMDQU86/W+9vzIu9FU
	 iYDUbVTfJ8pcJkvYC6RafGeTAGltqw/QJ5fNGidS5XceIBXQ01+2xzwqvdPQ1Qx1K/b5n
	 ZZC7qgMKCY6+cIUz4E1zuVx6cFnptucCbw6QevZvWOOBr/PBRm4JydRZ/xVRjouWcAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=DYaNTHw7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E233960A260E;
	Mon, 26 Oct 2026 08:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E233960A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=DYaNTHw7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b88gcCk/rUnEJ5MF3kjINkd3H4x/iBPPokVpi7u+kBjqESyeBfexZEe/AUgZ8/qsJl+lSwjSGFaNQAQ9I2T+2uFBTMES/JSh4G8vRp9eA7e8FYkvknnyberDBNudv2raNqsStGBvLNzAc0s3PHJh6zTLgm+TaFdTXfwbnTiBEni+4M7mICnonfTLl/XDVz1xGGNMJFOZLG2z8BG+hUrlGRTMiAsNU9zNX5kS51YMc5G+7IDG4KMiTrIiTjJbX50oEgHwNPosDXLQALTMSpelhof8iL+jRenb8QDx/nyUMJrMm+zuOJlYhJiWwB48ybWDoZkoF1UZjo8yvqNbs/43nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=DUodekpOyPjjjGhk+dhiUqAve6MT0kLd+rkU4t7IN9M=;
 b=gpZ0MHgdHeEeT7S42wW4Rpewm5sba8IQZKBSPNLRkHMELWHm77TfhobyQAatb53cv9TKS4noGKLOqCh3gSiUT1a55+rC+OM4xK6+wmsUrL2zoZNyl2E1anLGjzJE4sr6OcQegknQ71mpxO+DzsENLT/KVL2OWcapLx5KMRIN64RidjJO2KBA06rRNyoHfy8xDPE0vmC10NEW48aOEkzpQKjppNF102Hwkc3euIuAn1gaaNb3u8JfJq3g0MTB1AfkG7Tl675N5s5HuFBWwmNLWp6bOl5GYbg05meUQr8AsGyzfCV0enTZMbxx5aklXQ7WReW2y+osTxz8abKIJm6yXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUodekpOyPjjjGhk+dhiUqAve6MT0kLd+rkU4t7IN9M=;
 b=DYaNTHw7qUW6ECdHXHrWCTNlqEuF4FejhC4JNBuosy537gdOgHO+YVmLjyxQcxsZgBt6WV0PxQZT+RC537UePOhNFCM4564+aacm5s/z0/GI/muiYij3fgPzFb25UtV3GbNn8LgSphV9Hjkluc66yRRfSVR7wU7jbPEHxwCmeRpRr+PkkkI2gJIM1/Yos/08Ue2ctTizzTc0MH0WLqxzs93RonVDiPT2b2RtP7AuhpJGBEvqdkH8O6miZR2lWS/FB2YugSmnxIPeAXFZwcoijdhqxNDb1iX9VULE1mVH/85G4dC/61TaSyBqraQNXnqXCRAFhNY7LsCFy2Y+49ww/g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:39 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:39 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/6] scsi: bsg: clear io_uring sense length on copy failure
Thread-Topic: [PATCH v2 5/6] scsi: bsg: clear io_uring sense length on copy
 failure
Thread-Index: AQHdZSQkXyBg5NUQlESRoC1Ss/F7XA==
Date: Mon, 26 Oct 2026 08:29:39 +0000
Message-ID:
 <43ee84525e456f95cc0efbb6b65c2074cc874e1e.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
In-Reply-To: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: b802a170-91f1-4a06-4cda-08df333b46f2
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|39105399006|22121099003|22091999003|24121999003|31061999003|38102599003|8062599012|19110799012|8060799015|25010399006|102099032|440099028|3412199025|4302099013|1602099012|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?fBf8Aqapl4LHe845n+Kh6j9alVKTiVbmZVfGpGsMqfS6NS3gfaokVMY4Yc?=
 =?iso-8859-1?Q?xAKrnAoxfM6la710aJypE/tTGnYCTOkQkeZao/grGDiPM8O4UWRYPyyX7Q?=
 =?iso-8859-1?Q?zxuJQ8CPYINuKTggbAxiWMm0eH869LP3u+hV7ckhuWcwA4ED8Ol1tFf+/q?=
 =?iso-8859-1?Q?NtJW4gRHO4b8/tzDwaaX4K+3+duFsmym0o2eViIwSPYeLO2/I3Vg5wBcew?=
 =?iso-8859-1?Q?C738LaQwczbzIIQZ026mB7vPBKvBGEgJq3Y3DIm7WAwmKjna9hS7EkQHlL?=
 =?iso-8859-1?Q?CjBzYMZF2u70JkhEThkz95lWTPp4QSXF2oBpL8eGw89YeAf0sfLWkFoWGo?=
 =?iso-8859-1?Q?zk5O4AhDQwmGx1OIdmq73o+/oF3C1x0ZD16n9pun+SGocXEmARyF1/8mtw?=
 =?iso-8859-1?Q?TbO3Ghxt0AcY14kmQ3eoXqiXak77KwrchigSaxdNsXu1tve8kSLZzncZUv?=
 =?iso-8859-1?Q?scYYSJPdyOaS2rYBm156NwFT97m1UA7yPapdlh4p7GoxAao7wqwDgpHM+j?=
 =?iso-8859-1?Q?jO5AMKWn3MT4MxZS0UumKXLmYa3LXqA/M+5S1rxuefXyn1d/EPMypEvnF9?=
 =?iso-8859-1?Q?UynWR1gshPncOLuuLc5YuVVm1SroF+Pzdk/i2VO6+w545MCNxGQkklg9O5?=
 =?iso-8859-1?Q?YOlMzwoODoSsbINZWbUFIiMyRpaXRj/mP4t/q8fO6f4o84+LFEC6Hv41ea?=
 =?iso-8859-1?Q?sblqYILwGNTVybf9CiHF2Y8w4A46O7+tsNORyJW22h0fUjznsDjizg5jzm?=
 =?iso-8859-1?Q?/sOxHZ+AWIdI2ljekaNnx7Vc+OKqRSWuphEri83Q/vV4zx4LjOH+fo1Lfo?=
 =?iso-8859-1?Q?uX/5fjNZ/rKfqypUr306Zrr4/d+vtGCwM+YWsNocWF7W6evhRfBcFHUSv/?=
 =?iso-8859-1?Q?Aa9nn7Idr3OEtG800Hk1wptc8lyKPPES2ffKDBdEDrz0IlYTMAqk1Kv56h?=
 =?iso-8859-1?Q?HCiOCqp7mONJcHiUt8sfFwBInIk2HW71z+2lber7xHosK7j7CFv4Seum2+?=
 =?iso-8859-1?Q?xYNEEpDD/VWPj/DQUBjDwFf8Ug2D0XL8w8YFGZ7Xen4NgBm1JAin4YAd9A?=
 =?iso-8859-1?Q?DWy1O7PGwSVKdGqWGuCb8MCcLUoXW/aSZiMRCS6/jViKyYGLVkg9MAJWJ8?=
 =?iso-8859-1?Q?DRMfiv7AWbjuY+8TLjwv354o/0i+49fBJFmkCok0w9xU1/BdLOm6HjO2jZ?=
 =?iso-8859-1?Q?zeOKPgn7e0e7oA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?2dv2VjOSnOX2wLNFHbujacHfx5UycPoOEpS46qjhlDFbPA4yc/57hmwTwK?=
 =?iso-8859-1?Q?r5mmCTB3v06wifLmOvDk7s9rm4RpQxnno3cf1gCOiZaQ6OKekuQZFQnBDJ?=
 =?iso-8859-1?Q?FwKYUDz90itf+mP61smQ56yoY2OctyqdreV2Yz/DYG54mn/zrJRgm+sAgK?=
 =?iso-8859-1?Q?T58x4uJ2tchaGC8SB3wu2bNPsskhuOvi7mE6PEjytTuyI/znbfkhQVh1vf?=
 =?iso-8859-1?Q?J9VQcg7PcNtHW5BMUZZCIh3HMIpmcnc0ZKlmDjRRmJI7JqPaDGZRpmffBB?=
 =?iso-8859-1?Q?5xQ0hNzpbXGucmhWghOw6xIkJWbKqi7CcIJLv1XGeoDLXRR9aglEt8SmZQ?=
 =?iso-8859-1?Q?mr1FA1Zpt8dPpslwccyryTb1sPxPe80F4AfLupiRnarL2I69Z8hykq0A9E?=
 =?iso-8859-1?Q?MT6dvAjlyBhV8IMwfv0UIFgw9RhjwDjlStvs50ATErDwNca3iKRazDGZZ1?=
 =?iso-8859-1?Q?LMYwyHn7AHtbGf835oSO2DJBJkzzBOOFThekHnUm+QufHKHtw9gv/N+ViP?=
 =?iso-8859-1?Q?s8H4sebOkJAPc7jxjZj1sJYzYP9QHcGzARtEffWFUBOQ8dLsnIdeRTiQrl?=
 =?iso-8859-1?Q?MmeM33pRceSDAfV5J19Xhp3cDrYtWKmZ3RU5CgGVzmyPeKMIxdzH0rmOmm?=
 =?iso-8859-1?Q?63Fhe2J3NhYrsCs3Rujk+kmv1x/IBWOn+WnYxXSO5YVOVl9GfuTPnqu70W?=
 =?iso-8859-1?Q?j3f1jnrkYz5CT5KBz75T7SsVFmFT1kV4Y3C5YsdSpN+9agkf/Nzz1+UxKH?=
 =?iso-8859-1?Q?jUUbEM9YZyN49v6wNj/UJE3o+wdJi4uEcsPxGRIh4X9rAXkT8WPZufc8Jd?=
 =?iso-8859-1?Q?9F8oxI3dYvBHAFH8zX+mYLdwCsaxhLHB2BI5863H5ULllfwmPSD8nG2JgJ?=
 =?iso-8859-1?Q?i0aplHyuGEPcrpTrGPVZD95H0C8HhJWGLO7J8bSiGO9paGqUOWfk6mmHf6?=
 =?iso-8859-1?Q?Uc1kPW5xiNhnd2js1FPFwUfMz+6Swohq2YmBlaJ4RRg/uewtH9nUWxozre?=
 =?iso-8859-1?Q?DXsoMWEq7+HV6axGeSs4Zg9ypJVVdi7WKaTsK8MIbPeHl4s+bVYadqLhh9?=
 =?iso-8859-1?Q?/9GZ9jO+FPihVKTyOFHPlwYjY0L52ONPoMYw7cqPc8AWorqYRYE98zUoY2?=
 =?iso-8859-1?Q?U0lgTS6h0Pc7lRRWtT6o3+9p10CQicvdQAMhVdW5B28p8L7j1XitkcHjUp?=
 =?iso-8859-1?Q?AXCUBWFi9ofWDEQUakQBGMIX5Yf8zX7Xj6RrL8qosSVbjyOIUN9yDmqhuy?=
 =?iso-8859-1?Q?ixjmE5Ul53z8VNhdj+d7YR7VyzObaURS8wKnJBjUu2oTzlX0Shhl8XUS9P?=
 =?iso-8859-1?Q?7YUIFo71F2nJsRL6OIbcy88vPrJmDDO5IGRbQ0K6XORdeIPVlgu0IQNx9A?=
 =?iso-8859-1?Q?lnGnxURuyNYQ4GdoSq6pM1u6A4c+LRTyG+2AJNfsmZ5atAedIWWj+8q866?=
 =?iso-8859-1?Q?MWTQo27jfFUdShXc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b802a170-91f1-4a06-4cda-08df333b46f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:39.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
The SCSI BSG io_uring completion reports sense_len_wr in res2 as the=0A=
number of sense bytes written to the response buffer. If copy_to_user()=0A=
fails, the callback returns -EFAULT but leaves that field nonzero.=0A=
=0A=
Clear the reported sense length on a failed copy, matching the=0A=
synchronous BSG and SG_IO interfaces. This reporting error predates the=0A=
request-lifetime changes and can be fixed independently.=0A=
=0A=
Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 4 +++-=0A=
 1 file changed, 3 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index 650facb16ed23..98c9db1cae653 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -52,8 +52,10 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_r=
eq, io_tw_token_t tw)=0A=
 =0A=
 	if (sense_len_wr) {=0A=
 		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,=0A=
-				 sense_len_wr))=0A=
+				 sense_len_wr)) {=0A=
 			ret =3D -EFAULT;=0A=
+			sense_len_wr =3D 0;=0A=
+		}=0A=
 	}=0A=
 =0A=
 	res2 =3D bsg_scsi_res2_build(status_byte(scmd->result), driver_status,=0A=
-- =0A=
2.43.0=0A=
=0A=
