Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010016.outbound.protection.outlook.com [52.101.61.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40A7344D8C;
	Mon, 22 Jun 2026 18:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782152808; cv=fail; b=d4XgZURjs13SGQBlqf5LLPzSaV2RpIxEBuY143M8Y5dfGVSMXm/of5+FZmD568YguclKXZnlokunPoU/kZZnknRr2QpMw+19nuvbucVbH3BhMEVIM03qvo03oa11pFRhNC0iX66WCjSxFE3EOxfOQHwYpQm/QqroZQTfArstmGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782152808; c=relaxed/simple;
	bh=zYlhF8ENYkTw9kFPKkUFeG/X3ft3TYkN2hS/1hKkWoA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CGNi0WdX0gtg3x06l/yOVLmUcCL46w3pnosXgMzVQfrqqRCrWZPmHEOwUU6er/5GE9BxIXcy+nihH69K6r1jwgaE7tuen7GciDZYl08MUDbDyrY5kxBcDvf9p6QPGSKhWCkjj5C4YcaULgT1Sd3UuKY+hmGLBcGYCGHokkK0+oE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=UQevV+Nf; arc=fail smtp.client-ip=52.101.61.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="UQevV+Nf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lfFiC/BjJHMNrGTL916ma0i+UT0qJOnSPJnBiu+ibpJKsC+EB30bL2vohLUhTwgHtV/4fz6gvqmCphfOuWDgIRAGRQOxgKmZTdk5xnd0A/yRocP9GpTrRKJhaEe5TBsg4qc26DXBgGUK/R4EN85cuSUiTS/DNIhKiHvU0ckpJzpCWzwTO4a1j9SR/lUBtsoSqsvIp9Tf4JQPAW+mVcAWpfkyopzN6Pgo8wIsjBFgGdxcr+SqHuPez2ItoF+EWeUmLwM42mIOs0msnSud4mZ8pEMmiDuRtDiUbyle8zWOnAGSZvIB6L/Kd1bc8FbGJwTdumAWu7OC/VqpYyOvMVIjUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYlhF8ENYkTw9kFPKkUFeG/X3ft3TYkN2hS/1hKkWoA=;
 b=q3JMbDrchXesq92i/EkrCNVhQZAvQY8jNUcjvVNVru3/n33UJ6+vzOVnZsYHAudLv9yCE5TG8xFtZk6y2c6gO9iibsIM5Wle94+/thJSt0KFiZpD/F7ImgZeGPa1cZco3RGktdnklBPZ4Kigj7qAoGf4QsGlNK3Rz8DSIZaTmonSTiMT2CtF1DnuPwuQnbH+ZjBMTFTjFYztIMu94rVQBogOrFhnfvlF9xehYbx6UokWaC8JJJ9f+lVG9QqTimw50wa2T/cuODfdp8Gs9UutKx/qYcFch3YMnHMkEx378JYo1XWF8nhqr09A78XWZ+e73yKFCMtHGux8LTcbCT+EAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYlhF8ENYkTw9kFPKkUFeG/X3ft3TYkN2hS/1hKkWoA=;
 b=UQevV+Nf2vROd1UW5gRnymc5It5sbAJacC2tq4pqtCTTLyoMQYxcoNgaPfZpYWItwPPcE54FXnq1OpBKsXNtNnEZtvdGo1XkgvfkY8UbumtZ+bkLxG99avRNyhu9UpKuSLhcY7Qk98/Wy4rNtk7oY6c1psM9r7+Ru2T0Wn+eBgKXrYj725TbMQioaplzMy0Uo+bOjhR40BzNFg3fZ1dOiXEic5wdsdX13ujzztzx5BkSypYoPFb5Lgq6+3/wyLV8GoI7Pz33Ac+Gp2LqyZ9a72nKYntMNwI+7v0JWf3gAcH/XFiT8T10XztsqWMjdfPBNcjBA1Xn1+VITK/c6D8MkA==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DS0PR11MB7215.namprd11.prod.outlook.com (2603:10b6:8:13a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 18:26:43 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%4]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 18:26:42 +0000
From: <Don.Brace@microchip.com>
To: <haoxiang_li2024@163.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <david.carroll@microsemi.com>,
	<justin.lindley@microsemi.com>, <scott.teel@microsemi.com>
CC: <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path
Thread-Topic: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path
Thread-Index: AQHdAmBjE9j71K4IqkGWSUInwrj2jbZK4SsR
Date: Mon, 22 Jun 2026 18:26:42 +0000
Message-ID:
 <SJ2PR11MB8369CC3A2E487829E96057BAE1EF2@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260622160028.1240496-1-haoxiang_li2024@163.com>
In-Reply-To: <20260622160028.1240496-1-haoxiang_li2024@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DS0PR11MB7215:EE_
x-ms-office365-filtering-correlation-id: bebc2d13-c5a1-4767-5b30-08ded08bcf28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|56012099006|11063799006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 FRuo4napftk7k1A592WkWFGUMBuRFLS1xsyQ2H1EvWC6gBzOqV/kueL6JIHSZsKTS2+KavsaltnGRWGrY3jAwEI+rgLm7uF9eVl69ikHyzqzt6wXILHYM2hGoI9fI3JEjHsubWCt/VKh8uMns2LH2ndWrGOemGOR3tQ7hKzDg+LIXDh9amf0/ha9Bh7Naznrfl+SLZA+KzOPVjc+VgFe/+qI5Cwg2vGjwqcFgD9YLtru/wi0atBl+y9i5mliwD471ly6H6gpmyg7uPWL29zV5CDBARvSGyLoHPRDheTlHIHvXcbBclVF96/WA2qNLjHtNxC5y3EyYTvwXfcvlGt/hNFWC4/Z67lFbgtAiyqc6UMFjyK5107qmTGTZUTfUyAjSMtOEZsgHjj6dPRraGtaHDw6dSiXYdI7Y2PkIhTsyOx6NDRCqPGY/KV0sJnDRm6vXf/6tpzHvqwMF8DJxEQZLAstG3DmQE+eL3l6YDONgj9PUpG5xpNzoZnR05jtE28DXRKStRg8Ig/PENTZ41/QcJQUQj5mxCC315Ig5ebvP+BhkEf4sb2+vbWivjsNSknH3QxfgHln9xnnmYXo2lHyk/b7rTjaqA0ClJQ7Hho5Zu6a82qyFEG0jMEzq9yC+iJoVJ6Z+WmV+i7Wfk+admmV3twRqX2P9LgwY2fWnszuV0LioMmQQmbEqSo7fK1plg6+NnhbkFfcVKNBuiNIwtIiO/IXMmuD8JmZzRxni7n0ag0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(56012099006)(11063799006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?RiOSVo/Q3QM2Y/XVZ7o1x6z9GBEXa8Zy/WMeBKVDpW4u/ur47nn3JNvhJK?=
 =?iso-8859-1?Q?DOwsDkMQES4NteaR0T794KAkEd2NGtDZo6r3ijGdD+S0tooOxcAD87OD6n?=
 =?iso-8859-1?Q?eJUlilQPgH8DxnQhE439oYO5RjHBpuBkPI/lYV6xjt7FdVyXmklUWfx65C?=
 =?iso-8859-1?Q?94CCRXO7ZjDnYeyAw0PCsGsHzInq563Zor/NkXRNBGkZZa8z93+F5Dw1wG?=
 =?iso-8859-1?Q?Y8LXgPJcbknO/SyFBJY/xWZ0rFz+jnS976u+4fFUdkGrcHTNhR6PpKb7dK?=
 =?iso-8859-1?Q?ga2rxH279H5etV5icg3DCAWMm4BttCz6jN95nS/PAdYMa0s2mj9gWHoOUo?=
 =?iso-8859-1?Q?qsbL+RFg9WZAftVErJ7Eo/rJF99HOvacy2FT9DxyyYNa3RWWt/rdKymHXe?=
 =?iso-8859-1?Q?qz+/CfCQSTz4n0ciABQX6bQzXyOAeMr1TkEI8w6Bh4CYwAhPxBh7FyK3Fh?=
 =?iso-8859-1?Q?K9lJSg9ILP0eL057rc6dk/wrkyMOnY7t4MERBHxPqANgq8I9tZ/uskb6hk?=
 =?iso-8859-1?Q?a+UR06bWBPw2YK0FhjFwy+nJWA2X6jQAaLAzIWQRG3O512VOUZAcvZ8Quv?=
 =?iso-8859-1?Q?ZHlv6C86bkk966ECxzIqelv0NFEo3Wa0YUuAD63svRzf0mLXlfXDQbLNTk?=
 =?iso-8859-1?Q?ztYC430mXIkyqcQdC8sq5cWVLp0xv5YJ2KUWKh4dbSy/gvIVeHwFmA7uMO?=
 =?iso-8859-1?Q?EwE34J4/npf3xlS52uFm/tyA2nud46b/0GIjwVM741979QPEpAxMS8tUVt?=
 =?iso-8859-1?Q?P6qtTfFi2Y3QgHkQvGCei+ZJqv3MlivJ4Xj3YXwABCMRdNKjOaa9rbDhMY?=
 =?iso-8859-1?Q?RliE1CsacS6O/G3bRqz6IkbKtChWtoi0WaWDqDgYWZvd7Wy9fTO2yQQF8K?=
 =?iso-8859-1?Q?TxPJtKrZv9XMQaFiYbBzSmQHRdErGqsP0bWfRZW/H2RVrC+uPh3Xh198Zb?=
 =?iso-8859-1?Q?Oq+6grBldCBZRO8izhCcwzEXLZFYn0h3NLQ2shQOKE0zerl+cHckTLMiVH?=
 =?iso-8859-1?Q?pchMngk/u/KxBiWob3whZnv8gPaCL7TjravjKrm+1bwBMDzX1C3E7Y27iL?=
 =?iso-8859-1?Q?G1AOchvYbvp/AqWTrMawv2VwFkZqi8OekROO0iPKAQ5mR1Pob5XrSdRNLY?=
 =?iso-8859-1?Q?HA/XmN77SQs5/+TYID4SJf8chhBCiVJ4/PG/kwTrIEm4M1+K9jLbONmqEp?=
 =?iso-8859-1?Q?px1cltJjbbfCIaRfL734fzjrZS/4lUN5ZHqF3IGZflU/rTkmfcj2xrI8cs?=
 =?iso-8859-1?Q?yRLNqTDY4eSsDNXD0ueVwIpZ+8B/BDzI/3QkHcoD8sY/XzqZBZDA6FW4Fg?=
 =?iso-8859-1?Q?KnI8UdW/bP8HjA1ynMvwqpkkec0vSs0F/cOcHOytOH1AbsTiry0k0uBiyO?=
 =?iso-8859-1?Q?aGgOYmbuIMvIMWBrpfarEbnNl0NOwQhI7dH+KuEHp+RMw9ZC6BhajB39Ij?=
 =?iso-8859-1?Q?aAiYLg1IfelPWDnEvEsMIjhnklcOOBeEIm2KtSalQTO+qHjcyFFETGC4C6?=
 =?iso-8859-1?Q?9BVWh+TOF4MjbljD3RfynctjfavgXBKBqb/OBG95h5DNlW6/PbeWh0bOHd?=
 =?iso-8859-1?Q?xaVSQ5KVOX7Pl9Pj6D9/YoszgTgiA8AU0X8TQCRgNLdh51XKxkWQmy268p?=
 =?iso-8859-1?Q?6dOrh7yFRqtk/zNVYygTb1cLhJZwRYCJ+r9YYq6eRjykFyOBkn927FMGiB?=
 =?iso-8859-1?Q?BxvGaxtOWRydhut5oyAnMzn1HGNI0pRU3ry6fpKAojyibOjWh7blK38KgW?=
 =?iso-8859-1?Q?h4gD5xU9vb5nshLFx9ZIyGshDwA7ZmJn+q91o1JACLb62Zikvx5CbpuJ+J?=
 =?iso-8859-1?Q?OqbPkBORPg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bebc2d13-c5a1-4767-5b30-08ded08bcf28
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2026 18:26:42.7565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EsCJWZ9YPUvm9gR2ZomgKoY4qI88zoXGvcC7z2JXHwsXARxfVpND7hxlH9pQONSBwsOhcFcC2MdwSoVM+Ze2Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7215

________________________________________=0A=
From:=A0Haoxiang Li <haoxiang_li2024@163.com>=0A=
Sent:=A0Monday, June 22, 2026 11:00 AM=0A=
To:=A0James.Bottomley@HansenPartnership.com <James.Bottomley@HansenPartners=
hip.com>; martin.petersen@oracle.com <martin.petersen@oracle.com>; david.ca=
rroll@microsemi.com <david.carroll@microsemi.com>; justin.lindley@microsemi=
.com <justin.lindley@microsemi.com>; scott.teel@microsemi.com <scott.teel@m=
icrosemi.com>=0A=
Cc:=A0storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.org <li=
nux-scsi@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.=
kernel.org>; Haoxiang Li <haoxiang_li2024@163.com>; stable@vger.kernel.org =
<stable@vger.kernel.org>=0A=
Subject:=A0[PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path=
=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
If phys_disk->in_reset is set, the function returns directly without=0A=
undoing the resources acquired for the command. Add the missing error=0A=
cleanup by unmapping the IOACCEL2 SG chain block when needed, unmapping=0A=
the SCSI command, and dropping the outstanding IOACCEL command count=0A=
before returning.=0A=
=0A=
Fixes: c5dfd106414f ("scsi: hpsa: correct device resets")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com=0A=
Thanks for your patch. Can fix potential performance issues with devices un=
dergoing resets.=0A=
What about another patch for when call to hpsa_map_ioaccel2_sg_chain_block(=
) fails?=0A=
=0A=
=0A=
---=0A=
=A0drivers/scsi/hpsa.c | 4 ++++=0A=
=A01 file changed, 4 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c=0A=
index a1b116cd4723..8edad1830abe 100644=0A=
--- a/drivers/scsi/hpsa.c=0A=
+++ b/drivers/scsi/hpsa.c=0A=
@@ -5017,6 +5017,10 @@ static int hpsa_scsi_ioaccel2_queue_command(struct c=
tlr_info *h,=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 if (phys_disk->in_reset) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd->result =3D DID_RESET << =
16;=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 atomic_dec(&phys_disk->ioaccel_=
cmds_out);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_dma_unmap(cmd);=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (use_sg > h->ioaccel_maxsg)=
=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hpsa_un=
map_ioaccel2_sg_chain_block(h, cp);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -1;=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
--=0A=
2.25.1=0A=
