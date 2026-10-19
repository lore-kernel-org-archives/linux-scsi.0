Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F2C4FFA57;
	Mon, 19 Oct 2026 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419520; cv=fail; b=liqnq6P7I8hKl3XqEgDSe1K518oiJbfLxBQORjGcXdTMhsCoLjJsAJwnDCL7+xF0xxaIKYdRw2bRyGPBySxzN8JrXZc3UqP14sQCo4YztT6rsP1WzdV4DzZUXHWUbR2lt5tKw56gEDP44KHGHrvEELIZa9lPLnT9RHoBIZE9Yec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419520; c=relaxed/simple;
	bh=dJhOAyvFj5y+TUnmVkqtpvwudFD6H47qkz0QrzBizTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S7+dZLRCJ/B/5oHoAurMiTkTUoE7RS2h3wMulFLngy0qwV77JmgRRU7fsONbhinGAWaXd1cy+dCqbDv6xQYXNEld5YIecnGboYOEs1UMY/btm2AgrK9VF2AG7ICYNOVs5jL39zQr2jvWKf7vBFkob5GQo/HQ1koo7lk5Xn3gVIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZPBNiyBx; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZPBNiyBx"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JE0O93874226;
	Mon, 19 Oct 2026 07:18:25 -0700
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022103.outbound.protection.outlook.com [52.101.48.103])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hcw98kdmj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 07:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lIvAzjOomJh1m5tk1z39UBrOhIRz+BsApa+L/zlEnJ4z6Vy5fnGZ00l3NBJ8n6HZo35jz+LOjXPdEaoryG7osDGQFelT1WLSjoCLtchUMBa+U8FkLBcEt3fuGnznb6t6RIUJBiv0GCVUWxAaP/eQwh9YJSBgAE5SuMeCjyNQgZ0WoOLkLxG2bPclCAnjceLqKbIpza1b0xF/OKA7GNY5plcr5+kFdENnU6CN3hlUXs4v9EsIFg8iRMVtszxF7ApK9MKQ2exQZePBTbq4ZE4m+TQ3Z4mYl4GfrDhtpWIAcFbgbIyEl+IhVeb5vdY0VwoUQeFy1jnOknjXsgmA2h0FhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF2g6/RyCp6Q7GdSbip3UXW9JPuhCwcn9CxydjrdmCU=;
 b=fZxAfDgqzJlI+FCcBxmJmJR4MBfLU8s970g8jiDToM2mcVzJWoH2QWpYfgQLq7VHYS00BlSHbNChYkyKJzOO74aqNSbrkxKa8dv3aCgRI+s2XApiP/ZuyiUezem4tlbcpf9hJmf6xvkOPVOHz8WHvG9Y9c97UCsPe7l6d1LVbpVnGihEzEQJTjvuKw7P76UEE+0NcoYIo1J1ZqA27BSXUEE1uo5QXVEWqCNOCJJDZGcJ3FnL/2bg7ctrDVMyc3Tr2u53Y1ztZ/nec436ArVSZDqvE4OuLYZS7QiO9lbQCDZMwz+7exXiQQruZNKsGFaqDmpGoTGB/6tmk1ep5K/IUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SF2g6/RyCp6Q7GdSbip3UXW9JPuhCwcn9CxydjrdmCU=;
 b=ZPBNiyBxEiZkVxe3eP2Vdf1YYH9hBZxFBBuuZ5lRSwq8TDpnm9SMHQ9xE8EhfOKbUQE3HZIAZae2F2u6G1Meh7WN5Ed+b3fT0E5j2ukFOY3Hws8qe3bc2594qJtm3DRT/FsiOOmhuU6psijFNi6/HmFDheVFQxVvUCvA2ydyHvY=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DS0PR18MB820098.namprd18.prod.outlook.com (2603:10b6:8:4e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 14:18:21 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%2]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 14:18:21 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Zizhi Wo <wozizhi@huawei.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "mkp@kernel.org" <mkp@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "chengzhihao1@huawei.com"
	<chengzhihao1@huawei.com>
Subject: RE: [EXTERNAL] [PATCH] scsi: qla2xxx: Fix BSG vendor overlays missed
 by request_len validation
Thread-Topic: [EXTERNAL] [PATCH] scsi: qla2xxx: Fix BSG vendor overlays missed
 by request_len validation
Thread-Index: AQHdX8k8QMgrXf6pPki+gPa3OrAfTbcE6ZFQ
Date: Mon, 19 Oct 2026 14:18:20 +0000
Message-ID:
 <CO6PR18MB45006D49254FAE3BB1B84666AF982@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20261019124856.1495867-1-wozizhi@huawei.com>
In-Reply-To: <20261019124856.1495867-1-wozizhi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|DS0PR18MB820098:EE_
x-ms-office365-filtering-correlation-id: 45ab68ce-4ee7-4bd4-361e-08df2debd42c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|1800799024|23010399003|366016|38070700021|56012099006|5023799004|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 ikRexMH/KKbnkge2NkGVIDXLqXhYuHFRd5/8rwiL0Jr8NWilo2Ll8P9HGytlvy+TGgXLPRutmx2l5ObhpUm12RETy+PiHTqJgqSkDw2xL+Hi6pt0QkuzchbJU2CWyL9BvBpxwk6Yzj/lcj1hxqB90CXG+5Nkg6ajvgjDmrvokTQTKu0O1Lf7C0sQqHQrPoVCzw1oc0gVrqb9qOuLQePSpi/saeriiqf+N0SttK3NnNjs/sIeP9tfpcXknGStSlBV1yllD7jIKyRL2ndvAVeHnWXVZXL3RQHj/799/3WLkUpKS3LAtzYI+xr4CgBdGQSYcAtgVcClHX5STgdMErASg3xp7ohvMKK5zylpCS21t0GLzzyt6wE4tWP4WQUIwfipBw5PROKKueCTRIrhRW8ebdMvTAL0JHaO7wQ8BxO4BP5hlsaypbs+HRBPx883xLPA4e/2GbMTbebPw6OA1eNOIU4t9UgISwMdkk3cHkKY0wp6R4fSfQDgNsFmxAqgiTda7FuVrGFEeViW16VAD6cftLLcAnwd+DM7FurzKCXgOTnYrI5EQd2Ew0bMFe5+UNXVrCGk5mYX1Cp/RXwifKaLoN4ZKZWxrTvMgkK5AxOzXyZejbrHD2mxGn6FMWE4IK+wrqpatwEv4xy5SJlYk7oK9BEu8/c8MH9gELqv3+A9Ij7lDQqjL22WoX01IGz9oP9MhvczZtiTkFt8cw2qWsg7PTe0I+d3tpG3fVEm3HEseGc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(23010399003)(366016)(38070700021)(56012099006)(5023799004)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?windows-1256?Q?AglfCGuPyWFgkCG5C+WZSYIvz/Of20YE0ZzAc1sczvXKOut9IzxKkcaQ?=
 =?windows-1256?Q?o2fDnV8s2MsYHjrUTIJPB5gBvlYq4gGAfmlBsBQBlTG33zLBlzpqv1OQ?=
 =?windows-1256?Q?gyWyTMD8dd3VRUSom61ajlDEySfTDHE4eJg3frQCOW+z9N92OkdYdMLA?=
 =?windows-1256?Q?xarkV/gdeglv1Hul6DEJgq78tIjVQKN8esrcvCsyKDfm6uUjCheibl7w?=
 =?windows-1256?Q?5ZyI2ypB5aQbflQT5fynvd4yEd49DZ19bbU4lIdReAqtq/4/+5OaV25A?=
 =?windows-1256?Q?hVdnU4PErj3Em0YPAqhmg83H7Fjh+5OfbR+OAQpvNbRKFheKkIOMgCQS?=
 =?windows-1256?Q?gN4pZUETkPK+0Z7QrE8QVuWT+d2H80AwLyMaRl/u3FLLWYLHQXxPi/sn?=
 =?windows-1256?Q?mvJIQ/QJYcga8RQ4YMzmkPg1XJInA8put+9qr8GqX8DZStYq4ke3vz01?=
 =?windows-1256?Q?Xv7p7lARj8joDIEFDTgglYnghoVoLCS78sFwrqyOJur3Nz6N2HgJuuIZ?=
 =?windows-1256?Q?5+2BYB0owGb1YZg6w+icPhG6fC6rIluRHZtNq3BPuU/L+R8zexGb8Uy1?=
 =?windows-1256?Q?M/RMcqqvo280gaGQyDEDKWjT0BFzN38Minw9RapbdlwB9JPPhWXrJ3Rg?=
 =?windows-1256?Q?P7u8reirqhpMDcTrLEV1NQ9fPpBzPUcCAoEnGKzmFDIfhjXVwj6AuaKx?=
 =?windows-1256?Q?rstujCFmuqm3597dNQQRNNTwllhfO2y2oMbb3xRq6Hnl1OAcG5NcaAQ4?=
 =?windows-1256?Q?Qu6mGbUvBovA+M8wd0+ShTjnF1qo1ESgxuL5Y8knsBOTnWgRHTx3fyVY?=
 =?windows-1256?Q?qAxledaYwG5aoFU4MxXhL8U59FJwguAXU/2pw/Os030S1xlVzibh08Pz?=
 =?windows-1256?Q?iP2Vfc4BoZv81+6SVHMwSgL3hoQ0G0aLAMZy5ngIbKYwj73FtHgN8vCG?=
 =?windows-1256?Q?ndLYHyFIIF1K+S+yxWBlzWrczshGWdxeG6bJf4X0S3bqjoQgzZ5q0C0/?=
 =?windows-1256?Q?OIEqv9okhbIwrGcUYjOImnlC++fDXdnDkqHCsnFvEfYYcN8kf0XZOLMf?=
 =?windows-1256?Q?Wzz/YuTGsVnyt9dVF+MI/KXhhBLSpMZqMTiJEZPvs4OaI1MUwHMeSCLw?=
 =?windows-1256?Q?VjiU/q1QGimEd1UVisyS+Nrrh9kyRvg57GHeWVYWaQ2Fup7jJI+hEbD/?=
 =?windows-1256?Q?NqSJ04MWIUf//BE8LNRMgMQz7jWH4o/Klb31hkVb47CeQwIaphxda5xq?=
 =?windows-1256?Q?Rl+CmsGGgNxz2yX7B0j4Eud0sm5ixPfga4CL0GrAYuH1pfW5KG8X4X3K?=
 =?windows-1256?Q?c8ywiJKIfeeKkfOhDieYnArKR+yTSEOMPeOVF4WguP6DnI98eKvOEzdO?=
 =?windows-1256?Q?BYpsFrNEwK3QvwsyXcwdECdzPrHiTUxvNQltMTRubpb2Ej2kFs8z8KT+?=
 =?windows-1256?Q?B6oUdTp1PF/g6HK88yx9roa+X9VNQ7lxa6za1gwqPzsCwFf68qj4KRlK?=
 =?windows-1256?Q?GRZ68sLgJWaAUpsLwZ/EaxuE9x8NW8C8DbDPulVLz2O22TzAhRG4sIrl?=
 =?windows-1256?Q?bBvz47ogI9OSCKLecO5ck3OvcYDUThRmWQbm5/YWmUwc5F+eR4QRSeKn?=
 =?windows-1256?Q?87XRt9gFau6bOFYb4gWYIYVZcfhTFJ9gAQh+PXmYgK0uSdHsVeN+1dhL?=
 =?windows-1256?Q?/FwPxxYmSaxROpp6wEGdXEsZmT25xM9/asVmzFWPX8R7Foa+jiWg+8nk?=
 =?windows-1256?Q?n9kqomq8+2Vg6ifOmZ15KxY0BRh8341D7rPfDKmeN0Q663mtN7F1KmqA?=
 =?windows-1256?Q?jxhX3SAs6hfQqL4yN7U3HdbX8MMplxkXUSQ8As2SmHqM1y5l/3EblgVm?=
 =?windows-1256?Q?VzdN6m9bZ1aNFG0O0+xfKZrWzxxZZ+jPdguMlAoj7t5kbyse0zYKP7J/?=
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	OlsOVJ/BSQIDR/4e5p7ookI2nvjXTAW+X6YvsS6jVwFeuagXA74ItdTSeG2EDVsrBacIfBRNC5zIwjrxg/pd/K50CvJIN/fTxbIlJj6OG+aX5Thb1JXoSkWLG0oWT8e8UHKBN4NYbSqy2elZDnue3lw+YyjhCM7virr5IXipAXob0g20ey3j0BTA8VE8/Z7YMR8tFvL5jzzr27wxxgOPnYapairVPB+L2RMMdMSBwHxquggj8uFmco9ksMxVPx2ZJaVtXnKx4+88K2Q1SEqyCd+fYX3u37wxkR8PZAfkVZxEFEKpJj8/Jzz0l+A67IL5oD1NntCe3692KLnTcJFJMg==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ab68ce-4ee7-4bd4-361e-08df2debd42c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 14:18:20.9475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JRNfFn4WTUHAmIL0xy9MSm+/rzJBohUi4P/3korx57jGuJm0Ph3vT1G8TiqyetkkuFES7Wu/Odn00WYSH3eXfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB820098
X-Proofpoint-GUID: 0jwbD-KvtFh0uAhsehoXe3wZo82tJopR
X-Proofpoint-ORIG-GUID: 0jwbD-KvtFh0uAhsehoXe3wZo82tJopR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1NiBTYWx0ZWRfX3b4C6LtQuLKW
 re6d+B+3K23QuEqA5FiElhUnr8NPEoACqq2fPjIbY30FQ2im6Y90cHnU18e4PEUvJ2/IM0d2H8f
 HyLR/7B5w531C8V4Rm58Mk9PHbgUzcs=
X-Authority-Analysis: v=2.4 cv=aKRlOr9m c=1 sm=1 tr=0 ts=6ad626b0 cx=c_pps
 a=i8qEvMrBxaw5Z1xwZgH5pQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=eoNxP8pz9j0A:10
 a=660iZSQnnn4A:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=RpNjiQI2AAAA:8
 a=i0EeH86SAAAA:8 a=M5GUcnROAAAA:8 a=bLk-5xynAAAA:8 a=VwQbUJbxAAAA:8
 a=xmsGQxIg3Z6tn0yPl1EA:9 a=lqcHg5cX4UMA:10 a=PRpDppDLrCsA:10
 a=RFXaeJp-pwgA:10 a=OBjm3rFKGHvpk9ecZwUJ:22 a=zSyb8xVVt2t83sZkrLMb:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1NiBTYWx0ZWRfX0aU98A50qetL
 P2B8dijjlTVPVFfSZh6pQPAlve8J7EVmUhuHNPIB+oDo9DX4rWuZXgHW/IOHselmrU0mHAmDK0A
 k6iCGpNKCVAfa6oWPw5Q7cp1+nQchDVvmYZXN7Y3IAjGhhEMG6MLBbtiIzjVSy13TSsXjW719ai
 MQh6qfOrowXG3mGrueLnzcMDrabMk5ilw6CwpLBSaFM7EnMhtRxUQSK/77Tn6onvlCiEUa0DFzc
 kFencYfOxkApG7I9gKyi0qq/HqYLNG6KaHDtKSpt9GsIa0pAdNySkPmMZLHgzzLcyqc76GWrG17
 cmR5CMO4Cm+I4MfFYIZ26VH6+8dRylD0pWC/4gszdGAvWikYQikyzlD0PQiJkRXRju24aO4bWGU
 ojJuIx0fAgkHMiV6qshWUbgI00OjiscKiHJBu1Sm2tpsUhfffX7VLe2DRpfCOzNUAx5wnppgJN/
 vsP8cGV9eAQMa2gTqeg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_04,2026-10-14_01,2025-10-01_01

Hi Zizhi Wo,

In our internal testing we observed that the commit 4cf38dd94657 ("scsi: ql=
a2xxx: Validate BSG request_len before
reading vendor_cmd[]") causes the application to take longer time to start.=
 I would be reverting this commit
in my next patch set. Thank you for your patch.

Thanks,
Nilesh




From: Zizhi Wo <wozizhi@huawei.com>=20
Sent: Monday, October 19, 2026 6:19 PM
To: Nilesh Javali <njavali@marvell.com>; GR-QLogic-Storage-Upstream@marvell=
.com; James.Bottomley@HansenPartnership.com; mkp@kernel.org; linux-scsi@vge=
r.kernel.org
Cc: linux-kernel@vger.kernel.org; yangerkun@huawei.com; chengzhihao1@huawei=
.com; wozizhi@huawei.com
Subject: [EXTERNAL] [PATCH] scsi: qla2xxx: Fix BSG vendor overlays missed b=
y request_len validation

Commit 4cf38dd94657 ("scsi: qla2xxx: Validate BSG request_len before readin=
g vendor_cmd[]") added a central check in qla2x00_process_vendor_specific()=
 and per-handler checks for the vendor_cmd[] accesses, but it missed two ha=
ndlers that compute
ZjQcmQRYFpfptBannerStart
Prioritize security for external emails:=20
Confirm sender and content safety before clicking links or opening attachme=
nts=20
=A0=A0https://us-phishalarm-ewt.proofpoint.com/EWT/v1/CRVmXkqW!tY3Z1f8UYlXa=
1S-c-Vxazp44dpyDcFqDyzlya7BttdK_BPDvc-jp3gGlKmn9UFXGc18ON_sP1B5YHA_ya4qu98P=
2uEsU$=A0=A0=9D=20


ZjQcmQRYFpfptBannerEnd
Commit 4cf38dd94657 ("scsi: qla2xxx: Validate BSG request_len before
reading vendor_cmd[]") added a central check in
qla2x00_process_vendor_specific() and per-handler checks for the
vendor_cmd[] accesses, but it missed two handlers that compute the same
request offset with pointer arithmetic:

	ql84_mgmt  =3D (void *)bsg_request + sizeof(struct fc_bsg_request);
	port_param =3D (void *)bsg_request + sizeof(struct fc_bsg_request);

qla84xx_mgmt_cmd() overlays struct qla_bsg_a84_mgmt at offset 20 and reads
mgmt.mgmtp at offset 24 and mgmt.len at offset 36. The structure is 20
bytes long, so the handler needs request_len >=3D 40, while the central che=
ck
only guarantees 24 bytes (sizeof(struct fc_bsg_request) + sizeof(u32)).
qla24xx_iidma() has the same problem with struct qla_port_param.

Validate the full overlay structure in both handlers.

Fixes: 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and fc_bsg_job::r=
eply directly")
Signed-off-by: Zizhi Wo <mailto:wozizhi@huawei.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.=
c
index ab559048dbb8..e86ab83300b5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1159,10 +1159,14 @@ qla84xx_mgmt_cmd(struct bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x703a,
 		    "Not 84xx, exiting.\n");
 		return -EINVAL;
 	}
=20
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct qla_bsg_a84_mgmt))
+		return -EINVAL;
+
 	mn =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (!mn) {
 		ql_log(ql_log_warn, vha, 0x703c,
 		    "DMA alloc failed for fw buffer.\n");
 		return -ENOMEM;
@@ -1351,10 +1355,14 @@ qla24xx_iidma(struct bsg_job *bsg_job)
 	if (!IS_IIDMA_CAPABLE(vha->hw)) {
 		ql_log(ql_log_info, vha, 0x7046, "iiDMA not supported.\n");
 		return -EINVAL;
 	}
=20
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct qla_port_param))
+		return -EINVAL;
+
 	port_param =3D (void *)bsg_request + sizeof(struct fc_bsg_request);
 	if (port_param->fc_scsi_addr.dest_type !=3D EXT_DEF_TYPE_WWPN) {
 		ql_log(ql_log_warn, vha, 0x7048,
 		    "Invalid destination type.\n");
 		return -EINVAL;
--=20
2.52.0

