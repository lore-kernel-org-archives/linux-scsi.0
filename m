Received: from SEVP216CU002.outbound.protection.outlook.com (mail-koreacentralazon11022137.outbound.protection.outlook.com [40.107.43.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA91C6A3;
	Fri,  1 Nov 2024 00:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.43.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420886; cv=fail; b=S7rZX66fhJDVX07p3RMJ0Uy6yEFiY0R+rLG8Q6N92X14f/lDVaFALaAeiKqFmGMVxsD704rJazwY0YUX4mzSZwiPniwQv0BM9IPUsM6Eyr5kut8D3YiZ6nHbYaPmLhVKEGcwx7d25/4t9OuQoS+XXvY0K+U+/jxImMq6oH5JNjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420886; c=relaxed/simple;
	bh=c+JS1mlnx4+MbGkg0am97YrfTp0+JS2YJSpBuQsLT0I=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jEDbfMXMD4nIxuIbEwpoclttu2uBU1QlBxg+i8vkAo3XDXvZn/GXgSRlMUyETbNfVKM5rAzXIYy7iT9t8ngWQ0so43mXyaKfDo2FO9fK+gWPhj4TgAGi85khf+XaaxF9ueHdtURM4aWXOYvD8H2sJwh3lcvRG6AzJ0u7xAONJ4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr; spf=pass smtp.mailfrom=unist.ac.kr; dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b=dzt0hhTU; arc=fail smtp.client-ip=40.107.43.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b="dzt0hhTU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4OXfb6l37sA9eTiDv5dl6bbDPQrKo+w2z0G/QP3LqOCFrA8JHaoScp6mDGmKRX7Zzol2XTU+mEbMyVRfSj27n3d7NfHAPQ7MeqG9LLGjJ7LfdfRfJvn7UY24fCITf3wRqTmiNCAFQ4q+cBxm6/wfE0irazyPXkvrYgT+d/TwVhQ9ovTEKl5JimqB2nYTGzTvKo5lb+JaImsw2gOYHR8bFi1ZQuje+GgrvbTRpMgKC7DnGNVEmYzOmsJB0sklM7+Po05LzNKxs4bG8oJEcqlPLYzLZxcEysUiBv2lNFYU9KzUd6QKdiZ/R76N2eNCwk9iOD8UI4nzAkd9jnTQphbvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+JS1mlnx4+MbGkg0am97YrfTp0+JS2YJSpBuQsLT0I=;
 b=wZhRZ6pG6VZiZl/AGzTdlY2fnppqEqiI+rzYHKvZZQUiTyakiw/jOUTpp5MmmxF4qK0q6hii2XOJ2llsdDLQUoEEaW86F2b3oG9Pzy1CrT2X65Pv/iTQ0elCZHuz/VXuG4bJWy3eNHxCIjFkB13q6NvtrrUsTWyYBWcSTKz/oIYRzc1e072bxgcmF/MIk7EIVDDJgZJH6mMHp+cIC31GTbnHvCTxpEb7tm68dHlAcglvf8+Afn0QGM2dm+ieE/j3iRdctFuFjOxQ6saJOCPVnEaGvTU9B8QYOIUbePfPS36RorXxJybbC8ivH6A29TV+Z3erirRem+f/PtrMzJ/aXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=unist.ac.kr; dmarc=pass action=none header.from=unist.ac.kr;
 dkim=pass header.d=unist.ac.kr; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unist.ac.kr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+JS1mlnx4+MbGkg0am97YrfTp0+JS2YJSpBuQsLT0I=;
 b=dzt0hhTUgpk9ISMCZOKYnIstHgc0JwQGTCihW10Gp1kyaAR3SD5fKLlk0NloMmi3DhcHFTVJlyLMOabkJCktG6zEZmvmVHs8BNGligYnidTUOwrRX6VXjIcGu2LANaSS0DwhyHQuokksm0TztqJxlbZCBcf4D8lkSMMSb1jWbnU=
Received: from PU4P216MB2281.KORP216.PROD.OUTLOOK.COM (2603:1096:301:12b::12)
 by SL2P216MB2109.KORP216.PROD.OUTLOOK.COM (2603:1096:101:155::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.25; Fri, 1 Nov
 2024 00:27:56 +0000
Received: from PU4P216MB2281.KORP216.PROD.OUTLOOK.COM
 ([fe80::40c8:79b6:9574:33f0]) by PU4P216MB2281.KORP216.PROD.OUTLOOK.COM
 ([fe80::40c8:79b6:9574:33f0%4]) with mapi id 15.20.8114.023; Fri, 1 Nov 2024
 00:27:56 +0000
From: =?ks_c_5601-1987?B?KMfQu/0pIMDlwM6x1CAoxMTHu8XNsPjH0LD6KQ==?=
	<ingyujang25@unist.ac.kr>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "njavali@marvell.com" <njavali@marvell.com>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] qla2xxx: Fix  START_SP_W_RETRIES checks _rval with positive
 EAGAIN
Thread-Topic: [PATCH] qla2xxx: Fix  START_SP_W_RETRIES checks _rval with
 positive EAGAIN
Thread-Index: Adsr9L81tsSQ65OtRyaJlDxp16PgvQ==
Date: Fri, 1 Nov 2024 00:27:56 +0000
Message-ID:
 <PU4P216MB2281AC76382B9FCC96105070FD562@PU4P216MB2281.KORP216.PROD.OUTLOOK.COM>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=unist.ac.kr;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PU4P216MB2281:EE_|SL2P216MB2109:EE_
x-ms-office365-filtering-correlation-id: 40594038-2dba-4eae-998e-08dcfa0c0813
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|41320700013|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?ks_c_5601-1987?B?UnZkUjVkNmY2MFJjUGF0ZlJ0WGZuYkJadEdnNjg1dUVKekpIMWNO?=
 =?ks_c_5601-1987?B?RldEVUpEWFNRNlgvcGxrTDl6M2cxM3h5cWQ4S2lJT1hyeFpSbkpT?=
 =?ks_c_5601-1987?B?REN1c0EzWVJrck5xVFRlL2pxNWN5NlE2c0JSV2NMaWtqMVE5bG05?=
 =?ks_c_5601-1987?B?d0RTS3JRSlhRVUhlVWVWc2tleHFpQWlNb3ZjVFZobkh2T212OXgv?=
 =?ks_c_5601-1987?B?TXRqYmhKL1B5REx5dHBjQXYwdEU1dTJVSVRMdXlYcmFZSVIyRG5D?=
 =?ks_c_5601-1987?B?Q1ZDQUFQclRqOCt3bWlJNjFrRjBkM0gwRmhscGRCMjhJMm1XYUww?=
 =?ks_c_5601-1987?B?MWlGVXQ5bS81TFRhc1NLdTBBdWd2Ky9MS2dMMExTd05JaUUvcE9v?=
 =?ks_c_5601-1987?B?U0hucCs2V2lHKzZLeTZMQ1ZsQlplMTdnQmtMQ0dPUjhNcTRDSXAy?=
 =?ks_c_5601-1987?B?RzRHSGk1RkwzRnpxUU5sODZDSWc1cjFtaFhpOG0yQUcxL0pHanA1?=
 =?ks_c_5601-1987?B?b0dQQ3ppSmhHOEVkckYzL3ZHT3d6N3dHbWNOTlZ3ajFYSnR3aG0z?=
 =?ks_c_5601-1987?B?ZlZYYkVjbDB6NHNlRWozZFJsNGwzQ2hSMkNpWkFaMjhXSGFtaWNE?=
 =?ks_c_5601-1987?B?Q1NEMHJwNHFLUERmYnNMdTdCN20rRzBhNTBZUzdwQ2pGOWFmMENx?=
 =?ks_c_5601-1987?B?MG5wUDFJejFScVFxSEhyaHNBMnFQTTZHR2JSTFVacHNYckRUdGJk?=
 =?ks_c_5601-1987?B?TS85cXdsUitXMEM0ZEFpZHM0VkRra016SGRuaVZ6SjNmbnF2MWZj?=
 =?ks_c_5601-1987?B?YXJHUTUybzZMUjlLaGdqNC83YVlIWFM5aFlLOC81SEdBcDcxMTZs?=
 =?ks_c_5601-1987?B?c21PUDdLOUFpdW10UkVZeCtYQXJBQTEzL3ZnZmc3Wk9uWTQ4QmY0?=
 =?ks_c_5601-1987?B?NlFaVlZKZjFlUjlqUXJtTDhLdEV5YWRvZUpmM2djeG9ZcExCeWti?=
 =?ks_c_5601-1987?B?UmliZVR1LzJubkV5NlhtaUtob09OT3Y4UnBQWVcrZVpsS2FuRVVS?=
 =?ks_c_5601-1987?B?dThKYm9pNXF4U2RYaTY3ME5nRFlNN1VsZE9sblZPdlNwSFB1VWlN?=
 =?ks_c_5601-1987?B?dlI1dHFNZlJUUGFZWDIxSk5zWU1tQVBxU0RZQTI1WjhqTUVJb1FV?=
 =?ks_c_5601-1987?B?MkFselNJNWZER2lkTlRVOXdER3FDVGRScEx1VkNuZk1ueFN3cS93?=
 =?ks_c_5601-1987?B?a3drbWR0RGE0VXFlKzZEV0lCVWFmemc2YVVMWG9Kdm5NSG8zNGE0?=
 =?ks_c_5601-1987?B?ZkFqYVRYWmVxYllVazAxOVR1VFh5TExOSzhhSlhUNjRWV1JQTHN1?=
 =?ks_c_5601-1987?B?RkJBcktCNGxPVEluY2QyYjM4a1hHMDV1ZGNITTRLclFHeE9Sa3pB?=
 =?ks_c_5601-1987?B?TENSbWlGbVlxcE82dTZ1ajNmNTFZellidHk2cDV0ckdoRUo5LzBH?=
 =?ks_c_5601-1987?B?aG5TZ0MzTDNmM2h4SG0yMGZJa0J6Uy8yeUE3YmdOWXFuQzBjNjha?=
 =?ks_c_5601-1987?B?c2o1Njl6YXlPRUV5bHBLeVU2cW9NK2o5SG9ITnZjbS9JVnRBa1ZL?=
 =?ks_c_5601-1987?B?UVhvNWlTck5vSjJURjRaL2I0NGlnOWpCaG9MMlA2enRjNks1Yi9p?=
 =?ks_c_5601-1987?B?enVMdWpxaURJSWI4d3hueTNmZGlIckJldHJGMEMySDg0b1NlejQ2?=
 =?ks_c_5601-1987?B?K25ZN0RLaDU5NVJocm1FOE9RT1JhaUo4c3paZmpCQ1J6QTE3bFJO?=
 =?ks_c_5601-1987?B?MC9ZdXU1OG1hd05XQS9KSk9ldlVWYituWVZibEZyNDB3b044V3JW?=
 =?ks_c_5601-1987?B?Z3JvWXdyL0wreEc2M1ZEU3ZOVGxGUFhqcVlyeGJXaXArRkV6bFFR?=
 =?ks_c_5601-1987?B?NkZLTWlhd3BCM2dqeDFtNEpWQiswVmVzTmc2QnB4clZFd3JialVn?=
 =?ks_c_5601-1987?B?VStsbXZ6OGhiSE92MGZ6OTBQWWVQcVFIeXNzT0ovOVE1cVBpUTZQ?=
 =?ks_c_5601-1987?B?V1lLYUNqbmFuM1YwSmh6NGZaT3gxRFNTdG8rNzZlc0xKb2x2RHdP?=
 =?ks_c_5601-1987?Q?hk8ucr0qM2VgQsrAi+GlNQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PU4P216MB2281.KORP216.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(41320700013)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?ks_c_5601-1987?B?cWNNYnlqcCtsaUxhNXF0V2t6T2gvKzRHaksyQ0FDRkU1cFRvc0pD?=
 =?ks_c_5601-1987?B?aEJiZmNDNlh2aFphNDF1VXUzbFBrS25vbzNnM2FTeVVkaS9jZ2tv?=
 =?ks_c_5601-1987?B?YVJMdFdUNVJFWFBoQUNBdDAxT1UwSmhpT1RLY2JZZFRkeTJKL3B6?=
 =?ks_c_5601-1987?B?N1JBZ2s2elZQNWJpeFBNSUh1R0dFenVIUnJOM3B6Y2tSKzhReXJK?=
 =?ks_c_5601-1987?B?VUJ0a1ZoNDJMZjZLQm04M25MbmZweVpCNjNaRStwdExEeVBNTjE1?=
 =?ks_c_5601-1987?B?VE4zb0lHanh1RVRGOGF0NmsrUHo1R2xtM3kvYS9tYVBaZlFrOXdi?=
 =?ks_c_5601-1987?B?WXc1RWhOSTArODA2dHpDVjZSWDgvNU5MbVkzcTlIOFQzcVh0YU1q?=
 =?ks_c_5601-1987?B?d2w1L3pGbDFTQ2Uvc1ZVdGNQRXhxL2x2M0NDY2RzRFNHQmlHYk55?=
 =?ks_c_5601-1987?B?VGF3ZEJMOTVOLzgrLyt1WXJyaHhablpwd2owVlk2cFhCZlh3cVR2?=
 =?ks_c_5601-1987?B?RjhRV2hHRmwzeERUYytlbWV4clp5aW1OVlJvVVNadWgyRmFveHhE?=
 =?ks_c_5601-1987?B?bllGKzlBdUNLS3VNTVNHemhCYktZb3dFcnc1YnVjT0h2cnZTSWpZ?=
 =?ks_c_5601-1987?B?N3ZHN3RvdjJ1L1VaQndtekZQMkM5MWxDSnRndDFKcnorOS9rTVhR?=
 =?ks_c_5601-1987?B?cjFCU1RHMlJwK0JFR1FiL1paZDMwR2IvWGgxdVBwY2Vzd2RPY3Bo?=
 =?ks_c_5601-1987?B?T2QxSHo1TC9FSzQwdjI0T1BiYUZxNy84TC9OUTVSS1dRdjJMSlAz?=
 =?ks_c_5601-1987?B?VTlwTWZIQURCNHp0RTV6SmQ4TWtIWVpuRG5QRGpWWGVVOHQvTmk0?=
 =?ks_c_5601-1987?B?eGtIYStQdjJ2SzlMeEhvdzBxaUM0azI4SVliOHlHaStjZ3VBL2tV?=
 =?ks_c_5601-1987?B?ZGxEbTJBNkRWd2FZOUl2UGg5bmJWTnNBVjRNYjJtQTdjdjRSMjIv?=
 =?ks_c_5601-1987?B?RzcxT2ZGNUJKbWhsM2hFbzVBa2JreHFkYmdrUElidEt2SzdxYTBl?=
 =?ks_c_5601-1987?B?cDJEKzNYV3BiS0NYS1BsT3lyc0ZrOTJNdGdhSXAxNUd2dnBqdkRH?=
 =?ks_c_5601-1987?B?eUMvSmkrR2hnNUNwQ28rNnMxOWxZSEpUOG4zcVZMUHRMcHdYMVU2?=
 =?ks_c_5601-1987?B?VkFKdXphNUQ2Ni9uc0hQUEF4TFRZMktOQlJqWkpteitkRVMzYzY4?=
 =?ks_c_5601-1987?B?SDViS0RZRWNVRXhzcTRzZUpySUx2UUdMb1laMDJXRlJvQk1xTlFI?=
 =?ks_c_5601-1987?B?aSt1cVFoNEU1dkJEWXYwYjJmTzZPa1k4bSsvMURLL0U2eFVKcU13?=
 =?ks_c_5601-1987?B?ZVQzV1ZiV3doOEoweDlIL3p5bXR6dGRMTEpkUUJtOTQyMWxkUnU3?=
 =?ks_c_5601-1987?B?Vk0zd0o1eVJHK0w1SUdJTnQ2VFJZeUZ3cXFaRm12bldhMFljRTlo?=
 =?ks_c_5601-1987?B?SFpmNUh5S3EyUktDa1R5anZzZ1VWTXNITDA2c2tFcjZuOFB1TVNJ?=
 =?ks_c_5601-1987?B?WEk0OUlNRDNlNG5xVDNkTDJOUTUrNjR0U1ZvZXRmdGV4YldqemlW?=
 =?ks_c_5601-1987?B?SklEWVZwOEVwU2pxWXB3NXdub0VlSzNXZlpvN2IxSkpxL2xGUHYz?=
 =?ks_c_5601-1987?B?L0VqTnkzdW13OE1SOGlVK3NJQXJ2Z0t4SSs3S3FyaDVvL0kwMDFy?=
 =?ks_c_5601-1987?B?UlB6R0pFQ3hFTU12V200THBRdzN0blNiK2tlN21sOVN3eUMrYnlt?=
 =?ks_c_5601-1987?B?UU5JTkZpeFNycTR3MlBXaWl5a1ZWTXdJTVZDcTYxcGJiNWVGTTNl?=
 =?ks_c_5601-1987?B?aDhLQzQ2TnhZd2N3UUN4TXpsSks0c1lYbmVLa3NJMnZKaUZSMTBO?=
 =?ks_c_5601-1987?B?Q0lGeS9LNHVlQy9XOHBFaUN5Y2VJcFJMNU9iUC92WDN4d2hWaFJZ?=
 =?ks_c_5601-1987?B?YnFCTnlaZCtSQmNuaVZ5L2ZPN2RqNHh1WWNnN3JBa0lHcW4vZFIv?=
 =?ks_c_5601-1987?B?OWVYZCt2QjNjRDBrWkR6TkV4UzFYMjg1cWdxTlh3QnVKQ0dhNjRa?=
 =?ks_c_5601-1987?B?R1JRb1lsd2d2L3BhMkI3SW9HN3JOdHk5cDhnUC9ReDlhM3VWcU1X?=
 =?ks_c_5601-1987?B?anR4NDhoL1l0WjRkV04zVklWdHNaRlVGMmZnY0QwWHNxTnBhYVI4?=
 =?ks_c_5601-1987?B?dTkyRVNqUm0xY01KbGZ1bkVzTGhDODBOR01RWkpYeDNQelB2b2kz?=
 =?ks_c_5601-1987?B?MnJpTzhPQUF4QVpNdUxQaTBGQXE3QkVCdnBva0hIQjNWVkFJaytv?=
 =?ks_c_5601-1987?B?NC80aGtJQWFsNC9lWmNQdVpsTnhuTTY1dDZkcFZlQUdEZjFZNWVU?=
 =?ks_c_5601-1987?Q?Krxzow0Z0fTt1Z1/V1yZEkJkv9i8o1UN5vppcK0k?=
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: unist.ac.kr
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PU4P216MB2281.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 40594038-2dba-4eae-998e-08dcfa0c0813
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 00:27:56.1393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8715ec0-6179-432a-a864-54ea4008adc2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ABCEHFdmm6P0hIy4G+Kof6OGb8oNh0Ec7Iu6qc1+wul+bDi9CEw8DJRhPLfGTQPyGTWm920YMdV5Lm/xRhYZNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2P216MB2109

RnJvbSA2ZjQ1MGUyMGQ0MmMyOWM2MjM2NTQ1NTM4MzFiY2JhNzRhNTY2ZGE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSW5neXUgSmFuZyA8aW5neXVqYW5nMjVAdW5pc3QuYWMua3I+
DQpEYXRlOiBGcmksIDEgTm92IDIwMjQgMDk6MTc6MTAgKzA5MDANClN1YmplY3Q6IFtQQVRDSF0g
cWxhMnh4eDogRml4ICBTVEFSVF9TUF9XX1JFVFJJRVMgY2hlY2tzIF9ydmFsIHdpdGggcG9zaXRp
dmUNCiBFQUdBSU4NCg0KVGhlIFNUQVJUX1NQX1dfUkVUUklFUyBtYWNybyBpbmNvcnJlY3RseSBj
aGVja2VkIF9ydmFsIHdpdGggYSBwb3NpdGl2ZQ0KRUFHQUlOLCBkZXNwaXRlIHFsYTJ4MDBfc3Rh
cnRfc3AgY29uc2lzdGVudGx5IHJldHVybmluZyAtRUFHQUlOIGZvcg0KcmV0cmlhYmxlIGNvbmRp
dGlvbnMuIFRoaXMgbWlzbWF0Y2ggY291bGQgY2F1c2UgaW1wcm9wZXIgbG9vcGluZw0KYmVoYXZp
b3IsIGZhaWxpbmcgdG8gcmV0cnkgYXMgaW50ZW5kZWQgYW5kIHBvdGVudGlhbGx5IGxlYWRpbmcg
dG8NCnVuaW50ZW5kZWQgcmVzdWx0cyBpbiB0aGUgc3lzdGVtLg0KDQpUaGlzIHBhdGNoIGZpeGVz
IHRoZSBtYWNybyB0byBoYW5kbGUgRUFHQUlOIGFzIC1FQUdBSU4sIGVuc3VyaW5nDQpjb25zaXN0
ZW50IGVycm9yIGhhbmRsaW5nLg0KVGhpcyBjaGFuZ2UgcHJldmVudHMgYW55IHBvdGVudGlhbCBt
aXNpbnRlcnByZXRhdGlvbiB0aGF0IGNvdWxkDQppbnRyb2R1Y2UgdW5leHBlY3RlZCBiZWhhdmlv
ci4NCg0KU2lnbmVkLW9mZi1ieTogSW5neXUgSmFuZyA8aW5neXVqYW5nMjVAdW5pc3QuYWMua3I+
DQotLS0NCiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIHwgMiArLQ0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9p
bml0LmMNCmluZGV4IDMxZmM2YTBlY2EzZS4uNzYzYmRjYzQ3NTY3IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2luaXQuYw0KQEAgLTIwNjMsNyArMjA2Myw3IEBAIHN0YXRpYyB2b2lkIHFsYV9tYXJrZXJf
c3BfZG9uZShzcmJfdCAqc3AsIGludCByZXMpDQogCQkJYnJlYWs7IFwNCiAJCX0gXA0KIAkJX3J2
YWwgPSBxbGEyeDAwX3N0YXJ0X3NwKF9zcCk7IFwNCi0JCWlmIChfcnZhbCA9PSBFQUdBSU4pIFwN
CisJCWlmIChfcnZhbCA9PSAtRUFHQUlOKSBcDQogCQkJbXNsZWVwKDEpOyBcDQogCQllbHNlIFwN
CiAJCQlicmVhazsgXA0KLS0gDQoyLjM0LjENCg0K
