Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6963CF670;
	Mon, 27 Jul 2026 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785196315; cv=fail; b=oPd2QDwtWYU2vPNf/2Zh20OO+62aRmNRh9z1t4iS1hyxP9G7lPocRVHrNTgGKhjGIWvom2p0oFpD1RA6szJ0AH5/P2SMM+pix4QSbu4j9GZD1A5+vFduVFexMn0IN6D23e0kJqHEhc5rzJUVl627W+F/b0ZsgzElfnq1zi9DQR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785196315; c=relaxed/simple;
	bh=UgipYthL7ynmupk0xex1/HLiNn6ckRYoBD77MujPHVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WsztyORlULKreORTmcEbLmK+amIhegbBetB6G4QIch09j+O0ubI8waIEahvuKeBqaMnIV3vTeiMq1rXmWXBJ56BbA3JZAPQfsrUWP784jNT8iCDmC8qdK6v0am7XvcCLZIp0oUeXFAv+Tb6nbOBbwmFrdBekDRJte/5ac1QKLFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=QghRtRBW; arc=fail smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="QghRtRBW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3794; q=dns/txt;
  s=iport01; t=1785196313; x=1786405913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UgipYthL7ynmupk0xex1/HLiNn6ckRYoBD77MujPHVI=;
  b=QghRtRBWB/JXjiDBCqPq9+E+oqOu3VdFAd2L8yI6hVQ8rmvxxKLFL5wB
   FykuE00nskF4C80WQNm/bmC3v0PDI8RvcN8Bw4ZsS5Wzq0Eyd5mQwKWV6
   zEkgk6hG/Av+78zBoXdWLQcKMa3K2+31tq2qDsSIX87VgiPKhZWyiSq+V
   UAWnYtIV+dBpzY649ZTSSfpEnOJlW/oHaSRMFWVqbvf+gWS7ch6o2QLA8
   zGXQFrkQHGhejy28uzt5FNMlkBLVrgFDikiPij06tSesP1enAnihPnZkL
   5tWep6R6Vlfq7Umygg8p3OhViKbnpKxf+0zqlJLU1HVmwfBVkOXD02sw8
   A==;
X-CSE-ConnectionGUID: KbwGLRVYSfS2q2NW729OHA==
X-CSE-MsgGUID: iUDIrDldSVuCj3sb/CSwvg==
X-IPAS-Result: =?us-ascii?q?A0BNAgAW7mdq/5T/Ja1agS6BK4FuUxZygSNJiCMDhSuIe?=
 =?us-ascii?q?QOBE50IgX4PAQEBDQJRBAEBhQUCjWMCJjQJDgECBAMCAwEBAQEBAQEBAQEBC?=
 =?us-ascii?q?wEBBQEBAQIBBwWBDhOGXIZaAQEBAQMSFVIQAgEIEQQBAS8xHQgCBAENBQgah?=
 =?us-ascii?q?RsDNwMBArViAYE9AooqeIEBM4EB3UYEgmEBCxQBgTiFP4McAQGEPIEihRUnG?=
 =?us-ascii?q?4FJRIEVQoIxBzE+hEMChBOCMASCDYEhgXiHBolEUngcA1ksAVUTFwsHBYEjE?=
 =?us-ascii?q?DMDIAovLQIUDQ8TDwQWBS0dcAwnEg8dFxYeWBsHBRIgKkFFIwMULR44C0MFg?=
 =?us-ascii?q?VcCgXg/Ixk5f4ExdUp3LWkBAhAXSjgYgzwCghIDC209NwYOGQMEgTUFjWoig?=
 =?us-ascii?q?isSewkKcmhXNpMfkVyCIZ9aCoQdohEXqmyZCCOodQIEAgQFAhABAQaBaDyBW?=
 =?us-ascii?q?XAVgyJTGQ+hYAG9VXk9AgcCBw4DC5FoLIFSAQE?=
IronPort-PHdr: A9a23:9m2ZzxAbk9d/7xX14QrRUyQVXRdPi9zP1kY98JErjfdJaqu8usikN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+hmG
IronPort-Data: A9a23:mtn8c65z11uEdVJwRDSXFgxRtFDGchMFZxGqfqrLsTDasY5as4F+v
 mAeW2rTa/3ZMGqgeI1yatuw8h4BuZPQn99mHQNs+H01Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo/qUzBHf/g2Qqaj1OtPrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eHocH1cJNP1B1+
 8dCMWorUU/Z1sWW6efuIgVsrpxLwMjDJogTvDRkiDreF/tjGMmFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkEfUrsUIMpWcOOAgHziaDxeqXqepLE85C7YywkZPL3FbYOIJ43VGpUK9qqej
 mP700XjLhUWD+KC4jje6XjrrdTQgyyuDer+E5X9rJaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZiRKZNpjsIo9QiYnk
 wbQ2djoHjdo9raSTBpx64upkN97AgBMRUcqbi4fRgxD6N7myLzfRDqWJjq/OMZZVuHIJAw=
IronPort-HdrOrdr: A9a23:i8teJ6++gCssSwn3Xnpuk+Hedr1zdoMgy1knxilNoENuA6+lfp
 GV/MjziyWUtN9IYgBfpTnhAsW9qXO1z+8S3WBjB8bSYOCAghrnEGgC1/qs/9SOIVyFygcw79
 YFT0E6MqyOMbEYt7e63ODbKadc/DDvysnB7omurQYJcegpUdAd0+4TMHfjLqQCfng8OXNPLu
 vl2iMonUvGRV0nKu6AKj0uWe/Fq9fXlJTgTyInKnccgjWmvHeD0pK/NwKX8Cs/flp0rIsKwC
 zoggb57qKsv7WBzAPA12jc1pJSmNHw4NpODs6Bh6EuW3XRYwCTC7hJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt8xOI6kdt11bSjXujxVfzq83wQzw3T+Bbg5hCTxff4008+Plhza
 Nw2X6DvZY/N2KEoM293amNa/hZrDvznZMQq59Ls5WZa/pHVFZll/1ZwKqSKuZaIMu10vF8LA
 AkNrCt2B8fSyLoU5mehBgt/PWcGlIuAxyBXk8O/uaR0zRQgTRF6nFw/r1Dop/Fn6hNFKWtII
 //Q/hVfL0idL5lUYttQOgGWse5EWrLXFbFN3+TO03uEOUdN2vKsIOf2sR+2AiGQu1B8HIJou
 WLbHpI8WopP07+A8yH25NGthjLXWWmRDzojsVT/YJwtLHwTKfidXTrciFjr+Kw5/EERsHLUf
 e6P5xbR/flMGv1AI5MmwnzQYNbJ3USWNAc/tw7R1WNqMTWLZCCjJ2XTN/DYL72VTo0UGL2BX
 UOGDD1OcVb90iuHmT1hRDAMkmdM3AXPagAZpQy09Jjv7TlbLc8xzT9oW7Jkv22FQ==
X-Talos-CUID: 9a23:7bJi4mxtMY1scY4/QCkpBgU3EN8KVkfj/UzeGBWhU0BWF+fEbn+5rfY=
X-Talos-MUID: 9a23:KZFTnQqUjEMMnl8i2iwezzBfGOZyz6CiM34QupddoMPDHhdvJTjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Jul 2026 23:50:44 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPS id 4F90218000165;
	Mon, 27 Jul 2026 23:50:44 +0000 (GMT)
X-CSE-ConnectionGUID: Y8Eu59kETvCrYPaFd9f88g==
X-CSE-MsgGUID: 155/AfWeSX+585lkIz0Apw==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,189,1779148800"; 
   d="scan'208";a="89754753"
Received: from mail-westus2azon11012039.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.39])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Jul 2026 23:50:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsvxco1qqwZY3fy1pZUBHb+6pyLF2xaDnNYvRmB2sTS1pMehSmOdybOtMukl1iuZCSvK85M+D469PP/1+lZRJrgoIUqb60QktCdxETW1RbWu8cP1/Dn0Anv3SE9WwpEFkANBLf1o+RhCj9aHCqq/pJzklDJ+BIXpA1GeKlB2eIOc5XwI4MLNFB+RxIkYn15FdqdSjoIPc0px+3bZSA3OSfgazTGv6Tao71kiFg7b97EvMM5LBCtz8kjDDnhmerxtvOcZl7+dgyRwpsMP70b7pJOft6Wa9VNjJrFo9Zv5u5oVe9hQdaCR++QvD5FVxx2LU5u0YKBrfHfEaGgzxmsLHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgipYthL7ynmupk0xex1/HLiNn6ckRYoBD77MujPHVI=;
 b=uPEglSlGnqmsUgmYgabY45C006oPG43mrwT7HMRudSb/oQoS4JZiF+bVHSUW81djm5ceqvv1254yCSupiSm1aOpVOfWXDk2EzhHzEEd0rbhA+Ks3s5Puv6RdU+FTEs8aP/oqOZ0bSrhaOLxVTSBdaIGo54sh07LiaVXvvV2aLio28QgitmTUKCUtnXEoqFQryTst35pH0BfOFD44sJ9sUueGOrI3YDilXN+LY+o3Ix1oJpRZQ4JzyVZzwubb4AaFx8v90ZHLIjWvPJjf0vjRlSw5NXbQ09o8Fu8n/L1keZRj6bHVp+wjLmuI/I0+zdF2dpny/QRGiYEvBTaVcE775w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from IA0PR11MB7281.namprd11.prod.outlook.com (2603:10b6:208:43b::16)
 by SA0PR11MB4608.namprd11.prod.outlook.com (2603:10b6:806:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 23:50:41 +0000
Received: from IA0PR11MB7281.namprd11.prod.outlook.com
 ([fe80::2ffb:2690:fe8a:1d8c]) by IA0PR11MB7281.namprd11.prod.outlook.com
 ([fe80::2ffb:2690:fe8a:1d8c%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 23:50:34 +0000
From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
To: Chen Changcheng <chenchangcheng@kylinos.cn>, "Karan Tilak Kumar
 (kartilak)" <kartilak@cisco.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>, "ames.Bottomley@HansenPartnership.com"
	<ames.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ccc194101@163.com" <ccc194101@163.com>
Subject: Re: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation
 failure
Thread-Topic: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation
 failure
Thread-Index: AQHdHZpzIOvl/Bm4cEuDTb+Jr53r8raCCgCB
Date: Mon, 27 Jul 2026 23:50:34 +0000
Message-ID:
 <IA0PR11MB7281FD7F32AB31000E83427BABCC2@IA0PR11MB7281.namprd11.prod.outlook.com>
References: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
In-Reply-To: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR11MB7281:EE_|SA0PR11MB4608:EE_
x-ms-office365-filtering-correlation-id: f5f60341-b1c3-4939-143b-08deec39d9eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|10070799003|366016|1800799024|6133799003|10067099003|18002099003|22082099003|56012099006|11063799006|5023799004|38070700021;
x-microsoft-antispam-message-info:
 0fslzKSqhQY1kbZc+ugFrYBg2Dnnj3MyBfQq/PgSLwK6lHeIPnzLZj3Yhrrfb+yXLNDuDMdX5WMKYvWpDhJH7L9NEG6+aKZSVQ/rvIBQOovP5rk1bNqSfeQah3fMNEvhTSjIiPaUT3bZ/OqnEm6K55xLPFJlx11Rekih7LDTT73cdgxoMQ1O1hN2lL1UO2Nmugwo3OzzKms9PhOGSOzYj397K7XMdaFftnLVPiBrsBoYC6r8KgMfd9KTZWALDjBABxmZr3wfqKeXpeWgxtj9yyR46uLm4QHr0wdDY2bvy6wr07msv8WAlk5Ipzm3OETEWDip7hvi5ZCiIuJBrLzwJjkrydqzvuzUugcCb+It3I047jN2BS0KUKJpzSG6+C0ybOoYsB1GNrC0gVdbRSKjnuG1iEqgv0qn3dOvZc2JKTkVnhZ9y+M4CDoetIKF2ozZn6n41xFtBIOUiYNIHGpUV1l6JHREbGv3LnrDYvxKlngRnV+lsGOWJlLboUPWVYOnndfdTqwxHBEahc0BK0WUKEbo2UrfeLINQX2b62AYydE/br8OjqWAzre8nKrOS1x9u0gGyOnBvnlgpuh8VziPC1C74uOKiDHlypPDokUaqIVpnWXbwaICRNvzJIrGdf6dRUley77nhEQZxYsqgMheIzmp7QGW1E4XEd4CWIyzA9ZVKf00gtgATy20J1z/5Y+kubhCfmByklTdWQbJMND8ylgep8GoS7wTGQUj8Wlg11Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7281.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(366016)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?c8A/cPqZ4fo/3yfMiBQ6kSvGtM2UsEVGEyumamK4Pp9azYnoVpHWvs8lyv?=
 =?iso-8859-1?Q?P1pwP+g4dwPed5lgJ5wjlbYsMiR68bTMvHbuX7fXe09IxWFIUwIt5OZpV0?=
 =?iso-8859-1?Q?jsXCOQ/63mv0xkmRMUl3hv2SAdLwGug+GwL6Wr9zPBEwc0Syut3yoirhBi?=
 =?iso-8859-1?Q?ZTXPlgV6YDkUXD59GdI27bzwf48tp4PJ2hGN8d3Ao01857VaRPgKVy9P/8?=
 =?iso-8859-1?Q?ivLLXRXuibAnHQzWaRiSjNZkZf96lEAjsZfGjOTo6qvywwOMwiacaS1Ueb?=
 =?iso-8859-1?Q?HMb/u+42uLoP1KNXdpjMDtKhxhKQviX1M0EFkJg+xkJOdKHEz9UucAdFrm?=
 =?iso-8859-1?Q?TeZjckvpi5ENniJO/H488xksSOUdJBl5t0W9hpIfBZzGV8sMjmtXKLt40i?=
 =?iso-8859-1?Q?Ruxjv9TLcdgyr1wS+1mzpsUigNuYl18DiKGKTSn4Mh3KXjG7JF35oUtee9?=
 =?iso-8859-1?Q?s7u7GFLGK6QC1eqOW8vOYH4H1Y0ehuWp5h7sX47Ch8c3VdAT8BbuOFpO7d?=
 =?iso-8859-1?Q?ZNWDoLPdSmapRkmE/xqtkzFaX4G6lCCcLYeva29SNkaIjRLZcZjFPNScdK?=
 =?iso-8859-1?Q?Fy5mnQxfm+vCqkPblLu+ITXi+gLWkDsQuYThoJonwTZXnSV+kPQb5lTVP8?=
 =?iso-8859-1?Q?xbHCPkBj6bHcsOOnqlHZd3uQzOUCAdVzbKq5+pYPAejikVYoVjMSXmLZtx?=
 =?iso-8859-1?Q?rVyDnheB4I4wfeZlppLxmxb4anAfXS6O7fUpC9ZxO5reCQjCaQRwzTGaK+?=
 =?iso-8859-1?Q?vjQ7TuizRhwXE3hTlXysaswD0ezPYWone+BqP3FgDRCV2fVss/aHB8euqH?=
 =?iso-8859-1?Q?PEFsMho8Le/qCDh2kw70vDT9p8ghXxo6EEBgRmpRfAwK90QTVQkLvUbWpI?=
 =?iso-8859-1?Q?/tyvu/UhwizQWlisRlhPtQQ8cFYj8LBen4/nO0lYeK97InjlHx7vbn3EpO?=
 =?iso-8859-1?Q?sRdvdDZVqskhAQMcnXt7qHclQN1FXQ5aR/VCLLs+ntzOcEFPXgGpvko6yX?=
 =?iso-8859-1?Q?djoUfSzgsln6HDsmG4g/Yzm9nr7delYxBf9hywpToKoZtMZ/V1de+ZZ5wz?=
 =?iso-8859-1?Q?WDmP+9HvSjKzQnJnNzHDZMLUtMDWQP061T0Dp37Km4cZqi13pkviM506gJ?=
 =?iso-8859-1?Q?/skTsjkLJaNPeA500K9nR79v0zC6iPjcPUBAP3LfYuUoK75Yk2zezhBdyE?=
 =?iso-8859-1?Q?pV6lw914O7nvUNaan7DJZD5GA/MOeJQQqNTU4gkWoq3eKC4SZpmY7GY7AM?=
 =?iso-8859-1?Q?275O3b5oCUAu3rHzkb6L5QPu9l9D6TwrHDd7JECkwQlMqIXBJKvl5XIp/8?=
 =?iso-8859-1?Q?EEU2wN4PvgOqw5sKl8nE1GfxXheskcIytyVXj7WJxkZM0tn3vUxAmkxOw3?=
 =?iso-8859-1?Q?NBGnNVrQ0afYVwA4LnSJ++R5wdcoEIH4Qep0+MksSaDjWWMX5n/jROG4mX?=
 =?iso-8859-1?Q?1ANtJCkXSF8uXrO6KM2qG0KxOrw0cwbKZCXyZ9sBPxqtWkCxfGvA27EEzE?=
 =?iso-8859-1?Q?XGs7VnGnmD3VfMU2/BVyK1PA4MqpDFNjWeWrI2mZMLfIjn2fCvICGG9jLi?=
 =?iso-8859-1?Q?/cOWQeqfLADlCVDY5Yoh02qQr9cHSemzNlxh/YhVCMlifIdfwjWOJ5EPQR?=
 =?iso-8859-1?Q?jURHIXAx7Hr4scB0f/XY63sabTqrPOKNeI4wjeZXLgAFjp+MR2kcmvT5Ni?=
 =?iso-8859-1?Q?z8U9KVikoriyytSHukHmgZu+Wy3X5y9zC2QeTyJVve/rYUxKiDXPYEhDBF?=
 =?iso-8859-1?Q?vW0cYzXjXe3JrnH8Hh9sZLg3LQQTO2EtOtkru8ovcbFHkUeNYiEcytxrqS?=
 =?iso-8859-1?Q?mmHqCBavgHjeIjmqONHvso0+GDS8L8Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	XfZ1r9BM35H/I3DsyoMOo1lACBlOsQHbehn5X1j5HcyFVv0ef5V/lXSANx0EEEUowXNVJSXk1isUEowsY/KShYp4Vcv9ZVhE0iStqBFsD5QEBpFa7bRR19iPzoR5gc7toFm7qFqiPi10SknoSE5LBbKnDgbpk6wlQGJpNjjN/r63Os60cVDCiiGUXxfxb+2NivXO46cs8DPRr3KtsbB7w3nTVnPxKlO3yGntKbjjlBgaV15WqMmDrqFkcpyoSj5gyk40osvaX7EJKQcjhrJtOsLjDK6veEfi422334056UW0Rn+N8upuYDZh5ir49WRH1+pFQVtrnYolARk8mAgp6w==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7281.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f60341-b1c3-4939-143b-08deec39d9eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2026 23:50:34.6137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VS79ftl14OjtKtVctpi+IPHh7TsdUnqqFv18ZQxJ/YQV10yeOCgePRxDa50R5+LWTXBQNNqU4YU7yPlcvcChFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4608
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-4.cisco.com [72.163.7.165];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-11.cisco.com

=0A=
=0A=
________________________________________=0A=
From: Chen Changcheng <chenchangcheng@kylinos.cn>=0A=
Sent: 27 July 2026 12:34 AM=0A=
To: Karan Tilak Kumar (kartilak) <kartilak@cisco.com>; Narsimhulu Musini (n=
musini) <nmusini@cisco.com>; Sesidhar Baddela (sebaddel) <sebaddel@cisco.co=
m>; ames.Bottomley@HansenPartnership.com <ames.Bottomley@HansenPartnership.=
com>; martin.petersen@oracle.com <martin.petersen@oracle.com>=0A=
Cc: linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; linux-kernel@v=
ger.kernel.org <linux-kernel@vger.kernel.org>; ccc194101@163.com <ccc194101=
@163.com>; Chen Changcheng <chenchangcheng@kylinos.cn>=0A=
Subject: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation fai=
lure=0A=
=A0=0A=
In snic_add_host(), if scsi_add_host() succeeds but=0A=
alloc_ordered_workqueue() fails, the function returns -ENOMEM=0A=
with shost->work_q left as NULL. The caller's error path then=0A=
calls snic_del_host(), which returns early when !shost->work_q=0A=
without calling scsi_remove_host(). The Scsi_Host remains=0A=
registered in sysfs as a zombie device even after the probe=0A=
has failed. This causes:=0A=
=0A=
=A0- The leaked host remains visible in /sys/class/scsi_host/=0A=
=A0=A0 after probe failure, with state "running".=0A=
=A0- Subsequent SCSI host numbering is permanently shifted=0A=
=A0=A0 (the leaked host ID from ida_alloc() is never reclaimed).=0A=
=A0- Memory leak: the Scsi_Host allocation can never be freed=0A=
=A0=A0 because device_add() took a reference that can only be=0A=
=A0=A0 released by device_del() inside scsi_remove_host().=0A=
=0A=
Fix by adding scsi_remove_host() in the workqueue allocation=0A=
failure path inside snic_add_host(), undoing the successful=0A=
scsi_add_host() before returning the error. This is cleaner=0A=
than modifying snic_del_host() because snic_del_host() is=0A=
called from a shared error label that also serves paths where=0A=
snic_add_host() was never invoked.=0A=
=0A=
Reproducer (requires no real SNIC hardware):=0A=
=A0- Build CONFIG_SCSI_SNIC=3Dy (built-in)=0A=
=A0- Add snic.test_mode=3D1 snic.inject_wq_fail=3D1 to kernel cmdline=0A=
=A0- Boot with a PCI device matching the snic driver (e.g. QEMU=0A=
=A0=A0 edu device, PCI ID 0x1234:0x11e8, temporarily added to the=0A=
=A0=A0 driver's PCI ID table)=0A=
=0A=
Before the fix:=0A=
=A0 # /sys/class/scsi_host/ contains a zombie host0:=0A=
=A0 $ cat /sys/class/scsi_host/host0/proc_name=0A=
=A0 snic_scsi=0A=
=A0 $ cat /sys/class/scsi_host/host0/state=0A=
=A0 running=0A=
=A0 # ata_piix gets host1, host2 (host0 stuck):=0A=
=A0 scsi host1: ata_piix=0A=
=A0 scsi host2: ata_piix=0A=
=0A=
After the fix:=0A=
=A0 # host0 is properly freed and reused by ata_piix:=0A=
=A0 scsi host0: ata_piix=0A=
=A0 scsi host1: ata_piix=0A=
=A0 # No zombie host in /sys/class/scsi_host/=0A=
=0A=
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>=0A=
Acked-by: Narsimhulu Musini <nmusini@cisco.com>=0A=
---=0A=
=A0drivers/scsi/snic/snic_main.c | 1 +=0A=
=A01 file changed, 1 insertion(+)=0A=
=0A=
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c=
=0A=
index 82953e6a0915..cd638b4a4d7b 100644=0A=
--- a/drivers/scsi/snic/snic_main.c=0A=
+++ b/drivers/scsi/snic/snic_main.c=0A=
@@ -305,6 +305,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *=
pdev)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 if (!shost->work_q) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SNIC_HOST_ERR(shost, "Fail=
ed to Create ScsiHost wq.\n");=0A=
=A0=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scsi_remove_host(shost);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -ENOMEM;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=A0=0A=
--=0A=
2.25.1=0A=
