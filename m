Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0252DCBEC;
	Fri, 31 Jul 2026 07:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484228; cv=fail; b=PDACevUImPaQSRoxBbVV0ugMDClDcxIZH3Ogqm0EyebspeHqANPGSFOf77R8+bX/I+TJ9u1T18nN9ddm4d8up+lbcXltlXvdnnEml79m5z6jqDPnK4muh/zcFWLOhZ9USmwGRh696estvCLl6B497PhqIf1J7pey/DtnZNLIKcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484228; c=relaxed/simple;
	bh=L4wuGt068VTH/yYXj6IjLXFiMEtTW3pODVnYyWA3tx4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XSK55dnr8NXnJyBdtx/IfVGzx/49LxzZYx8ay+M971mCcIgqgc2fYx+8DOraxQ8+qFeOoO5L/ZY3HiUbEKDxNnmkqoUEUtINuGdIpGDvTGnVI4FNjyUR4EZSdgnU8AuqtlyAhqL6qQP9kM36V7wyXWSI9z9Y4Z1UjzK1Rsphxb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=lM6ceg1O; arc=fail smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="lM6ceg1O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1363; q=dns/txt;
  s=iport01; t=1785484227; x=1786693827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A4LPtISToMLWHYAe+PkMvCzOS6BlPGK0Y5RNDNSbzp8=;
  b=lM6ceg1OMAjCPRkuB3EZB+bHl+NxC92eymmufs9oaTleiqHTxz7QfYR9
   S7L7LMlXvhHjHauzR0cj45/WPGUAmyju4Rk0QBQQxWrUOo6mm+ulkD1YQ
   8lmKnBLR5IqRnRLrj19H+TNaXVL1nB4RGu8c7Jz6J/KJQaJcRAjFJB+KZ
   DbKPXgwUnhdB2FaTToDMM/VzHZCIKoqMGfUtEGZ9mUsfDOUp5yqQyDDTN
   izaiv8/gFFJLJkzPb2E33r1fcUQSI9qkxd5Pt0K5+7MnW2KmZQNuLG+Wp
   owkFBRR1vyTfmJtBVZ8o3MdZxOoc3d5YVPxjn15ROHLBNjfIx72q/JXsI
   g==;
X-CSE-ConnectionGUID: j3lQF2YdQJ6ZA7W9sRS20A==
X-CSE-MsgGUID: J78GdOUkQRKU7+H1FGXGxw==
X-IPAS-Result: =?us-ascii?q?A0BoAwCZUmxq/4wQJK1aHgEBCxIMZYEgC4FuU4IrSYgjA?=
 =?us-ascii?q?4UrhliCIQOeG4F+DwEBAQ0CUQQBAYUFAo1mAiY0CQ4BAgQDAgMBAQEBAQEBA?=
 =?us-ascii?q?QEBAQsBAQUBAQECAQcFgQ4ThlyGWgEBAQEDEhUTPxACAQgYHhAxJQIEAQ0FC?=
 =?us-ascii?q?BqFVQMBAq9pAYE9AooqeIEBM4EB4DcUAYE4iFwBhXeEfCcbgg2BV4JpPoQKO?=
 =?us-ascii?q?4QTgjAEgiKBDJI1UngcA1ksAVUTFwsHBYEjEDMDKi8tFg0iKQUtHXAMJxIPH?=
 =?us-ascii?q?RcXHlgbBwUSICpBRCMDQSQLQwWBVQKBdT8jGTZ8gS91SnUtaQECEBdKOBiDM?=
 =?us-ascii?q?QKCXwMLbT03Bg4ZAwSBNQWNXyCCPgGBDhwngQl0KZZSsCIKhB2iEReqbC6YW?=
 =?us-ascii?q?iOkAIR1AgQCBAUCEAEBBoFoPIFZcBWDIlMZD44tFtIaeT0CBwIHDgMLkWiBf?=
 =?us-ascii?q?gEB?=
IronPort-PHdr: A9a23:AUxsnR2had5qNlq/smDPmlBlVkEcU/3cNwoR7N8gk71RN/7l9JX5N
 0uZ7vJo3xfFXoTevupNkPGe87vhVmoJ/YubvTgcfYZNWR4IhYRenwEpDMOfT0yuBPXrdCc9W
 s9FUTdY
IronPort-Data: A9a23:bHEhKKwRKx9FZqACFKt6t+c3xyrEfRIJ4+MujC+fZmUNrF6WrkUHz
 TNMDzrQa6mKNGL3KYt1a4m18x9XsJDczYU2QQptqVhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 46aT/H3Ygf/hWYraTtMsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJENtObQ2oNd7OEMQx
 9VHF2EWVCvZ38vjldpXSsE07igiBMDvOIVavjRryivUSK59B5vCWK7No9Rf2V/chOgXQq2YP
 JRfMGQpNUiYC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+Oe8bIeEJIzQG625mG66+
 TLp80PEASggF+HAihrc3F2cqf/QyHaTtIU6UefQGuRRqFmSwHEDTR4bT122pdGnhUOkHdFSM
 UoZ/mwpt6da3EiqSMTtGgazu3+soBERQZxTHvc85QXLzbDbiy6CGmEOSjNpdtMrrok1SCYs2
 1vPmMnmbQGDq5WcTXabs7PRpjSoNG1NdikJZDQPSk0O5NyLTJwPsy8jh+1LScadptb0Ajr3h
 TuNqUADa38716bnC43TEYj7vg+R
IronPort-HdrOrdr: A9a23:XRD5zq5TPm/dQwSoaAPXwceCI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICPoqTMaftW7dySSVxeBZnMffKlLbalfDH4JmpM
 Ndmu1FeaLN5DtB/IjHCWuDYqsdKbC8mcjC65a9vhJQpENRGt1dBmxCe3+m+zhNNXJ77O0CZe
 KhD6R81l2dUEVSRP6WQlMCWO/OrcDKkpXJXT4qbiRM1CC+yRmTxPrfCRa34jcyOgkj/Z4StU
 TVmQ3w4auu98q81gLd0GHr6ZFXksvKy9dIBsCA4/JlawkEjDzGWK1RH5m5+BwlquCm71gn1P
 PWpQ07Ash143TNOkmovBrEwWDboXUTwk6n7WXdrWrooMT/Sj5/IdFGn5hlfhzQ7FdllM1g0Z
 hMw3mSu/NsfFH9dWXGlp31viNR5w2JSEkZ4KguZrtkINIjgYpq3MgiFYVuYc899WzBmdsa+a
 JVfbHhDb5tACCnhjbizylS6e3peGgvFRGbRUVHkMmU3z9K2E1d9SIjtZYidrNqzuNgd3GCjN
 60b5hAhfVASNQbYrl6A/pEScyrCnbVSRaJK26KJ0/7fZt3cE4lhqSHqYnd3tvaMKAg3d83gt
 DMQVlYvWk9dwbnDtCPxoRC9lTITH+mVTrgx8lC79wh04eMCYbDIGmGUhQjgsGgq/IQDonSXO
 uyIotfB7vmIXH1EYhE0gXiU91ZKGUYUscSptEnMmj+6P7jO8nvrKjWYfzTLL3iHXItXX7+GG
 IKWHzpKMBJ/imQKwnFadjqKgTQk2DEjOZN+fLhjpouIaA2R/hxjjQ=
X-Talos-CUID: 9a23:kLJtomwAhpsXZJ3/i39QBgUWQcQcXCfswE7yfX2RVlk4U4euEwe5rfY=
X-Talos-MUID: 9a23:GXzDngpaJK3W2tHLxgIezxM9ZOhkxJmtMXourMpFm5CqGhxfKyjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-03.cisco.com ([173.36.16.140])
  by alln-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 31 Jul 2026 07:50:20 +0000
Received: from alln-opgw-2.cisco.com (alln-opgw-2.cisco.com [173.37.147.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-03.cisco.com (Postfix) with ESMTPS id 41779180001F9;
	Fri, 31 Jul 2026 07:50:20 +0000 (GMT)
X-CSE-ConnectionGUID: kAP5M6UnQrmUFu1b+bnDxA==
X-CSE-MsgGUID: q/vlIorETzurb7MsGvxDsw==
Authentication-Results: alln-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,196,1779148800"; 
   d="scan'208";a="57151642"
Received: from mail-westusazon11012046.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.46])
  by alln-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 31 Jul 2026 07:50:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=klRB+eK45nlfTsjapG6uWyz97PiVc9YDYX3XIRO72rSlz0jbBA5re09PuV5ZexR0n1q3PqHJLM0fTx/LFFyEywT3tyuqsomCngzD5kL1OYU2mEnTbAQPpeNu/CJx4e54mlxjvIx6+cHIjVv3HyQ34OfywrAA9Tghw1anC365L4OM8f3SvkRjSYRH82wFBl3PN6Ioic7dpPD/SdNq1ZkKWaWFuWmhbXU9HN+67lbTq45XVQE7RAgTArJbrRkbU2oqSmxNQPuBLzbS3jpxhKydw8Dwn36DcMh9pYlEziB55yDwX3KtEEJbX70L0RhdKhAT3DPpXXoVvqaNQkydgi2jkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4LPtISToMLWHYAe+PkMvCzOS6BlPGK0Y5RNDNSbzp8=;
 b=RUxiCB52yLVTPznXjGewxzu1hLcVvowG6z4E4a8/W5nD+Bt4qVGmLidvwl0oupSnFJKEOvNQUMhxzm74zbkBuJ1+aQ1+aQuEdUdCKay0YZt52RzJVAxNCn5wSG6cD4nKuf0Rgzg07P9utbBqH3vOqomRxI/UrWQqwxG+LlSH4BEx/ciz3v4EwzJc5/W83OsrRf0Xia5lPeniylbO1CC6aa0seCL3OUiXQzHjo3a8L6fQ33g+YzQkDWPRR9qqDAA0YXdZMOS7sdHVKx2+D3FJSydWcS8UZoss0+Wtmhbbinrepk0sRRu1nlXPL1RCLNVPzQtRS2KJsgd/D8ClC+fIoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by MW6PR11MB8437.namprd11.prod.outlook.com (2603:10b6:303:249::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:50:16 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 07:50:16 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Linkai Gong <gonglinkai@kylinos.cn>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, "Arun Easi (aeasi)"
	<aeasi@cisco.com>, "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
	"Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/5] scsi: fnic: use GFP_ATOMIC for VLAN alloc under
 spinlock
Thread-Topic: [PATCH 1/5] scsi: fnic: use GFP_ATOMIC for VLAN alloc under
 spinlock
Thread-Index: AQHdIL+nu7R7wNrP80ySu9fXhk5HQraHP1gw
Date: Fri, 31 Jul 2026 07:50:16 +0000
Message-ID:
 <SJ0PR11MB58969BAB1D8A2103C50C7D6AC3C82@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260731073820.16449-1-gonglinkai@kylinos.cn>
In-Reply-To: <20260731073820.16449-1-gonglinkai@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|MW6PR11MB8437:EE_
x-ms-office365-filtering-correlation-id: be083b3b-c662-4f5e-a73a-08deeed85c47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|6133799003|11063799006|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 WzdSDBl5MnQJFnQTQbiE/op9UbLaQwa8JUCEEp7kkYVma22qW2/Jsy6g96uuR9/pMZwgQ7PUzaOxf65dRfvB1wp1Msq1VObyxGJYXYNlAdkviSJqMqasqWQrzNdr0EtbHtSdET5wFVNTPT+op9l/bj8yWM6XSbL1GYHluMfRFDoq7vb56MUsiGmnWzAM0NneO0B6cfq+ryh/CaF5kY7fyXWzKJ5NMQheg9ROOp/Z/J0zRTNudgSdcq/gSs7hUfxPXChvIJHMDLmI1J2as3NdeYUl7XG+/4dksQOH8cuZGLtfeKVnblVOYTKparLVbwAce4D1GsmdHJhkleN8hsL3QR4wsa+vHnOkJ38ecuxxL7Bn1gFw1/wHn5cf/mObpdCFoOjDuYUHT45W1kjh1E+d32AVcik4uTadKl7QUqMpWdwh9+YPMzURvYf/5AJVadyb2yhokDJARTcrNe2jH3dYDXDBJ9Gt5kuwyRwgcKEw3ioBnc0H97FiaskkBIP02To8NRyp6pZDOEGgb9fMj4YDo0vQMYvhjp/Rmt1bdYOWyVnzeXAOvZvkJTngHFuAGffw/3/c804sK2C1YKiTEEX0svhDUtDRkKj4QTfgpWWtREt7VV+leJVlYnbC7Nj6Q5aArp0JhM6MqVusO3XC6Vo9wrFtIhMfNNSzeOMdXEtVTk9offK2xIh3YBuJ0lLPocjSGg8wIeJoglGAdxf36G0yYEsY2PRyunXYnut+45X8O7w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?A2xoRG38lsplMhYdI5QrChFkf+kEugL+HNofUaJ4ldFYIT4aVqrGESrnWW2O?=
 =?us-ascii?Q?3BtqgQnyYBMcASzCmaxU7F23O/+2dnh9ZBsWlN3P2mi5jwC2hwvWxHoRjLgc?=
 =?us-ascii?Q?YL1CFmw3rG81q+Gt98SlOymhfKJbM3eWoF2k8rsR2vv2SDYRa0vFcuVvHuJ8?=
 =?us-ascii?Q?G3URb5/0eWR6xMXPKkRCAjVZ7WqNasuQZc0NyT9oRWU79smmw+sqd3Oq0DEx?=
 =?us-ascii?Q?o9hXflebXTNJUUW4uvyg2cBZ3OQg2xlwrxaPe47eWz98jKeQTfpWoBqpeO9b?=
 =?us-ascii?Q?6C1nYpKF4Q02eJAx1s2udq2Dy/r8cRSjL3UuXrZjvJCrDUQaI2CQRmdjCprg?=
 =?us-ascii?Q?kYLjBfgsNQyT2nVadvnVF9NzowIw76WwgoOIyskmaxcKSahA+Aw4NLucyhDr?=
 =?us-ascii?Q?FhqVRy4wh0J+m5/lh1j28vdipR9/RG8bDsFfzbFo+cannUGTIqUTi0DR+2vJ?=
 =?us-ascii?Q?DU6+DZaqmqZ5karFq0+07wIG8jFfWU5UlWSf92TCFLrTgea7QLvPV2ZtYedE?=
 =?us-ascii?Q?dy14Yhx/B9KdVzc8/0rVbVwsKvURm19ZLOpMgf3uiO/uDM7nAG2YHT95vobU?=
 =?us-ascii?Q?97QXjCHdrXBl6pwP1xkaj4Kkah61N5s6k5y8fLE94yEk7rWS4Jla2dNSRGQT?=
 =?us-ascii?Q?WRPi+tQQ1WqcU29D1//mm9gPGin3iXbQpoBp+TY/Tqb1OW7HwUv5bd0QDi1h?=
 =?us-ascii?Q?7F+iotHceOO7WuiZ35XaJMPBbal53Py3SZnbxSYSTQ8x2t7+/QaFfLozrvt0?=
 =?us-ascii?Q?rr2uJFIk/ixDGMby/xEmdO+TkMytd1jYFNOT/sJC8JeYP5zlY2iAMjRod6A3?=
 =?us-ascii?Q?/3BcZsp2b9Ed6QRWeJ9eFaxuC51m+VvjsMaRrMbW7V/bAFahi7uh2xYW4Zod?=
 =?us-ascii?Q?UlrvImhFViW4mIPchSfcm1b1Ym7CbVOAMeZpvmcxa37ZcEXHyUpZxwt2UbTh?=
 =?us-ascii?Q?fiigoIJfaGeIg5xRgMUauml7vlwzXeARGcO8NTNCanJywebHHmrQyZCjouA3?=
 =?us-ascii?Q?bvjtoGjEnP8HbAVCOBElnBYcNHjeW0YBXu1xWRi4Epy9XI2aqRsQrzvFzteM?=
 =?us-ascii?Q?Xyd3xdhXJGxSXf98Nq+P5tJVz/gJWmHgqeQdMi9bKHX5ENZ7f+WjOidpTx7q?=
 =?us-ascii?Q?KPI1lM+CNm9Pod0YxzRvupn84vdQ1w0ajnPH4qcGZt6HcqQePjLDrnAhQzdc?=
 =?us-ascii?Q?UlefwlYf9PsozoYFZETyp6eci1l8hsgiQrM+XxPhPYOh4kpHT+cS3F9IQzsQ?=
 =?us-ascii?Q?57yMoZUAI9WYL2QwBO8IvUIJa5MtK1VYujppVVxOjAPv6nXmYy0S6JdUutJj?=
 =?us-ascii?Q?Pg27sXu/ndKeyVzrK29VXuJQPZOwExh0QCegAV255goy6ZGtkfqoNfl3lHRB?=
 =?us-ascii?Q?pb3g+Rfe0sJebtsG2qIFoz2QnMnYrv7fcurTNO6FTU0s0jC2mpIKOk0dDg9A?=
 =?us-ascii?Q?jGIv9Ua7tggO9NyyEMt8CPrWXBKiuuWW/lAgn54Id3r4pPOLB4K5SD159bc4?=
 =?us-ascii?Q?3Acjx3K36C/u9zlzkQuAXzr6GegCplxRd0ZbaRvNlJFbKb+XNksa2f1qhjNr?=
 =?us-ascii?Q?hqria5Vfs0BV5/CBCxWxyMAfMsZlTrfLKQQb/OiirBeZVs3PiUHS98/noUNB?=
 =?us-ascii?Q?UtFuRQXvn7PzMTG9yXsCBvtx54fbFit0qFlogy8IbF78qpQpQ1P2ykj3KyKF?=
 =?us-ascii?Q?F28607pZ1jruU63s8q3eLGckAE40HEXy1bhB2eWV9JrJlrf5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TDIxpcJf5XTVlwZaWV0lt9kBaw5acclRTNNpinAtL5ZaQQ495JHkxbdIniEwqIyYnbHO1St73sQmupXLAYPaZljVXWN+d20ScL3PM0Lg5N79SK8hyrPBi90KR+3FksOLE7oP4ExO7aoOABGRj0JDGcGse6BrUW+ktyGbkQJ2nguz6zlngp2PYBtfBHpHQag0ym7qNI23tGWACFDhLvzYW6og4zfvUWxMM0yeWZ94wqYMadavz93aY+Y4qzNnZTInh5zNfMMJzrgnj21CVy+60m355XoptXWyYlg1M0MAHDzN1Jv0dzIzm5U20jrQV/AHwt1Ox9lNrp8BvgxNBGX2lg==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be083b3b-c662-4f5e-a73a-08deeed85c47
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 07:50:16.1426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YkhSbBBOTqjxi+xjF27OieqjmljmP1xkxExaxTZ75m8fxCcp8Nh9vu5WTXYOGu+DFFCK01V4UTOPxfUJzpebTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8437
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-2.cisco.com [173.37.147.250];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.250, alln-opgw-2.cisco.com
X-Outbound-Node: alln-l-core-03.cisco.com

On Friday, July 31, 2026 1:08 PM, Linkai Gong <gonglinkai@kylinos.cn> wrote=
:
>
> fnic_fcoe_process_vlan_resp() allocates a VLAN descriptor with
> kzalloc_obj() (default GFP_KERNEL) while holding vlans_lock via
> spin_lock_irqsave(). GFP_KERNEL may sleep, which is not allowed in
> this atomic context and can trigger a sleeping-from-invalid-context
> warning or deadlock.
>
> Pass GFP_ATOMIC so the allocation is safe under the IRQ-safe spinlock.
>
> Fixes: 098585aa8aca ("scsi: fnic: Add and integrate support for FIP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
> ---
> drivers/scsi/fnic/fip.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
> index 132f00512ee1..28c9861b6501 100644
> --- a/drivers/scsi/fnic/fip.c
> +++ b/drivers/scsi/fnic/fip.c
> @@ -139,7 +139,7 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, s=
truct fip_header *fiph)
> FNIC_FIP_DBG(KERN_INFO, fnic->host,
> fnic->fnic_num,
> "process_vlan_resp: FIP VLAN %d\n", vid);
> -                     vlan =3D kzalloc_obj(*vlan);
> +                     vlan =3D kzalloc_obj(*vlan, GFP_ATOMIC);
>
> if (!vlan) {
> /* retry from timer */
> --
> 2.25.1
>
>

The change looks good. Thanks for the change.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
