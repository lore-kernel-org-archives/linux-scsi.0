Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAB41DBB19;
	Thu, 17 Apr 2025 04:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744865950; cv=fail; b=EEYz2OZubrvnSIjPRF4b62abzbesvi+GtERksocFd+P3u+hv/Q9VEKUbVqTzFosGFWINFyZbc8c5pJcdBBO9VaxrfSI+8CN0ERKd1S6MMJeJ0Z/Ff0+Ib1lGJo/qTC8tBdiaCpbfSxWB85kSb38qxto+X7S1/C4GgILNyU9IyvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744865950; c=relaxed/simple;
	bh=J6rb3vq/1GDJ47lENV7y6DwHyHXMDXM0/Z/1V0Il2hQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p0oID6ZtYl1tZXVQibwVaScw8Ms9lQ/0GRqNUnVPiyDMOnmQRfwNxl6bzON8WOStR4VjGc4wTuxrbT7eLypoHB04sg5fgObYUa93E1ASk7LUAZUPMspCJvFJMzIi7WSLGkDwB3D4DFWuYt3EdHHrZZ2MM+y7z7l6eauPYpgN7Vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=jqL/2/uy; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="jqL/2/uy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744865948; x=1776401948;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J6rb3vq/1GDJ47lENV7y6DwHyHXMDXM0/Z/1V0Il2hQ=;
  b=jqL/2/uyF+vzV7b8LwLlnnTXdlhqBqNkM++dO6BXZhd4e/ql7SJv3/mo
   1h6H6YDTs5+3oVxOxGzFQ95DwIniPl7Icbf0RLLXxnhpIKEzhYk3hHkZU
   EKuBJs2/4613OuTrZdUJZPiSDgjH3++VYi78fT+N8VmP1zXzQyySGeiU9
   EnhtRYfzXn+KM3KoFoPQBVR0nJrX4U9ZQlIaSTZxABicVJvhyZUkdpWnd
   RMd9zNYQkCltvon5afhHWRzv7AY4P6UjXr3hMyABeq40hQ+QAZp8eD71Q
   30w4sPIqpCusI1NW3r/tqVXb9sYeXf0/hBv7LFff4jPc0yGKrAEzgaqbr
   w==;
X-CSE-ConnectionGUID: OuR4koMdRCio+w5Kylg3Ag==
X-CSE-MsgGUID: 4QBzZx+/TZ2okfowEnCyrQ==
X-IronPort-AV: E=Sophos;i="6.15,218,1739808000"; 
   d="scan'208";a="78438518"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2025 12:59:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jIYwFqi9KyNynRmH2sSpiX+zaW8zng5NDiegXDpBKOWhSrohBsCucLkbnymuk0a+nSm7zvhK91+Jl3HQYzXtPIhbc33OXoF2uVXh7bUij6FF5WBao2VmXGQdWOIBio/Ze/HjzT67VHMfePI9bx1sP9tSDtQJTWlRgGtcxnZK6ba/8ofRtix7lVPDKcY+TfSWidNt96Zb7TGBimiS53TuBEBemtd0o0AzV29G93srMJKv7I32cOFJnOzf6uCieUwBPsN92SKHoN6TzAO1B/g+vZiDki2huWZRyE37AZ5TDDqqu8fvR11l6BqpX4NV+EQgyGwFbd5Ca6UiK6oPliF8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/qhn56HtkomTy2h0tjXDPUJqpCK7IeuhpNRXeuHjM4=;
 b=zVtaHRdN46OwXYWZGyhir0Z9zXcfD2c1Uk/n2QELUhoYvYr0Mo1nM7pjWREVmU8SHVjfchj+wQHK8QnlIJK+KMto7+HORnyR7oKOF+3Ke7QDr/S0I/A7UQnxDxUPSYKxLPadbTFdh0gtADCbWoSzBleDD+QfRsPjMIya7VXOz1OxGtY+X6V0QmCEtWR+Semr3eOM5MEIacO8vHfn69BI8zMp41i1/U6NDueXmbJWyXqunnQU2BDouxgL2EZ2+uL4gnC5k1JibMXiCyoZAcjG/JX9jlMkowE5ggDGyAPvX370sGA05/sCz9AKd5bM8zQMfFPwLkfxkclOS69gix1cwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CH3PR16MB5302.namprd16.prod.outlook.com (2603:10b6:610:15b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Thu, 17 Apr
 2025 04:59:04 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 04:59:03 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: DooHyun Hwang <dh0421.hwang@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>
CC: "grant.jung@samsung.com" <grant.jung@samsung.com>, "jt77.jang@samsung.com"
	<jt77.jang@samsung.com>, "junwoo80.lee@samsung.com"
	<junwoo80.lee@samsung.com>, "jangsub.yi@samsung.com"
	<jangsub.yi@samsung.com>, "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>, "sh8267.baek@samsung.com"
	<sh8267.baek@samsung.com>, "wkon.kim@samsung.com" <wkon.kim@samsung.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs cmd
 error
Thread-Topic: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs
 cmd error
Thread-Index: AQHbr0FEY76nD+lA9k65Pp6IVYSiabOnS2Mw
Date: Thu, 17 Apr 2025 04:59:03 +0000
Message-ID:
 <PH7PR16MB6196EF7F7A1862B48B66C5C5E5BC2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>
 <20250417023405.6954-2-dh0421.hwang@samsung.com>
In-Reply-To: <20250417023405.6954-2-dh0421.hwang@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CH3PR16MB5302:EE_
x-ms-office365-filtering-correlation-id: 849ab077-e74a-4480-4cb4-08dd7d6c9368
x-ms-exchange-atpmessageproperties: SA
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?FJGdBKpPeC32u16hI5ZJhzozcFe0Qf5W8wc0YmPVxR3NTYE+itTk66Y5MIuC?=
 =?us-ascii?Q?AseF5zDVA4YzlEtFe71obkr+TaT0nok/KSsBkPuTglhdFxhdpF+wDnKN/YSn?=
 =?us-ascii?Q?LlhpznZS2qxy55bJrLhaFQYBga8KlwldDrfydNDui9aI0FnxFLuLl/mndTeM?=
 =?us-ascii?Q?j6SHDBJHyF7qQ7P9o0wv8uTndHjp1/Pcsc9xfQJj+yLLQcR7bs5NpBbJX16q?=
 =?us-ascii?Q?2p8afwsGsd/vpmzz6Oc1BZCaKLSn/RAnAA3R3O5Zc7sZBTmJ/ugHOI9ULKdo?=
 =?us-ascii?Q?yKpFea1Lmmfln/nEDhGvBJjg1QJJcguDlMivyikb62i0GFA6QAROMqHks+Se?=
 =?us-ascii?Q?aWHkLVefv5hSz7yq72VLaCwkdWWA6zambHgcRmIwDUEjZlzZZtI6nsA/VUIJ?=
 =?us-ascii?Q?OYCa5t6Cd31IVCY6TIovqDkZiPwIKkm4JY98G7VW0nyDvWiJrVpD34x9okVD?=
 =?us-ascii?Q?0asQq1UZfnrY7Q6riT0Hj7WX7I5vauaCo59fy7tHctfFIX/OUNBfr4+hmeqZ?=
 =?us-ascii?Q?ZwAqSXzsTjE+U/t4DqqtILpiCg9s77oArJhKBybV+rks6GNXyn12J3vCLbde?=
 =?us-ascii?Q?cPPrKU+9ZASk0qa9io8m9p6Bwwb1GBuCGryYj1tKx6boBQfeF975ROvlR2pp?=
 =?us-ascii?Q?gGqEwYDTsRLep8QkqINgFcGhaZ7yr2+f0R7WAy988OxpdOYD9HHl7BKnH7Hy?=
 =?us-ascii?Q?bN+ObNo4PoDJc+wUUzpp0RWejTwOsdkT5lEpvQJ+GMTp7xVqDkHGAxR9mNUQ?=
 =?us-ascii?Q?mhegCxYpV5IQDDuLuw45ysob3D5btFA9Mpa/knO28bPO5azv579mSPMiRvFt?=
 =?us-ascii?Q?9gnDAM7F99NnvS9ed8jwNzrut8OCGcA8PIyT2VbKF62LWbvlVUC/gZ4xUCqW?=
 =?us-ascii?Q?TW5tIreTTCl59NSasQ983rs+juLTD9UIOwBm8yMniIR8Cl6CV81pdOrAWd3N?=
 =?us-ascii?Q?P1uIEdCX7IBqd5/qmd/xTkyIAdcEeX5sXerEtFhSpZvcmY2m8MNwDHNLS+yr?=
 =?us-ascii?Q?5d1Zdp7dAwQZfnHhnrTPxI0NjzRQp7OjGEhuQAacPoxZrYDK7lTfRb4AxJu6?=
 =?us-ascii?Q?a1KS4ymZEBlhSUurekSyPshzhQJyIhwBLPBWiMD1gGXq/5hEJsGc0sAnCXbk?=
 =?us-ascii?Q?V8fb90nD7ckkpgW7dms1vSwImh2vBE2zele+0sBqO9p61ppmIQot4K77loyD?=
 =?us-ascii?Q?bYffLv5scxrZeglytn7AFFIGvb+G/dne9OohIAk44AXd9s2bkdxoEABQIEd6?=
 =?us-ascii?Q?6W/tuM5uQI1u/9UrwxPwxziyleMAYuPi74gBBRg89+0cfP/D7y8xF0rjEy6R?=
 =?us-ascii?Q?FotioDqOQEa6rU7sG1kttIv2hycb0kbD+BOs44ewXEgGVCgG2m/foWyJc1Qc?=
 =?us-ascii?Q?eT4iZBGPf4k9HBCZKmUuD/QVX3E5RhwaqObzGMmgc383AHo/zoU1OdEb7OUB?=
 =?us-ascii?Q?oH39xqQuN3NFBoxtI4lO658MGxr/mX+e2j66ajhktkAIyQ10SWFg2khuP6tm?=
 =?us-ascii?Q?M8e0Vnj0fcc59JU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jSSCjC7qRJ0BrxK6hI7XIiLXtysGfTns2kW9qMMlyqXe4QUu6RvjM1MExoRG?=
 =?us-ascii?Q?oZLP4fOTq9ycjN5H+N3X5MEBqsXJB9dQRuAe1ILLWuFT72rtahCSQwOHavB5?=
 =?us-ascii?Q?vwD/2i99T0Iw5/li3Ia8wisIXTdTft4lqylX1MX0ip6JzfHZEypV6NVsq2F1?=
 =?us-ascii?Q?iYhyKpzs4ssABm+E69DQIl3jwaeJuLy4aE9A94m88cSNzdJPbnXqhxQgYNUb?=
 =?us-ascii?Q?PHzEPxcUEwOUvP2mk0Y8iqnazxUmjpOxnMf597grr5o5Lff+uWA5J1VQIdAU?=
 =?us-ascii?Q?lk/e2MyVi/LmqEr8SyHO8dqEU9UgP+GzcealHL157f7MCUCb8jPZ2/TY8g/H?=
 =?us-ascii?Q?uagcvRhlPQKwYN1iBSVihIsTfpGcIbicifs5kJETyZ2NLqGtLvfWDddoUU6u?=
 =?us-ascii?Q?otrN8FkVVW4imuKzhtNYkCkgP9fvc8MM1ytM5Yzj59JARiYEuAk8vvMeVl+R?=
 =?us-ascii?Q?LgyGbgo2ziSs4OWKEkM11/srTbyUEjE7inAF3YOXhLrAHLetrhqa21RQqATM?=
 =?us-ascii?Q?ILsXFy+pfAQxeTkp4Ne+Pj5gvRQ3/YKy8L7prW0jqorpAuKQSU3mp3VQHpuI?=
 =?us-ascii?Q?4hvkTNkhYFiCUfv+weA93nUntNLVF2WPDyWj/bZ/IYH3ngCWi5b9CRw70G4F?=
 =?us-ascii?Q?GBwcQxtcPMTIiF8tiA862ZNqdrJZUcTootKFNomdRi8H9GMh6UJOoIrZT6DK?=
 =?us-ascii?Q?mgaUzhGs+WqtvHjs7N+yI3ry14IeBueHSzPxcE/CnuR+3Fc+tlT7tDP+ABm1?=
 =?us-ascii?Q?5eptYKP0T3tnOLFupNG7Qb+pXJxY5odilFzfR32qX0WUX1UtG4XC7jxY0BJM?=
 =?us-ascii?Q?E2s6NkVHzw96QoU35ZdeLM4PTWpfyMakccaU2q7W9SVEFWRVWiVDnu/Ev563?=
 =?us-ascii?Q?TnVO/0SagwMuGL+iSAHd7LhSQ81iBPUzBPSZNvuI/9RMB5heyYQ9ycWBexCm?=
 =?us-ascii?Q?OxrpIzAU5KFhAaIdRBQSHDDzVBJz+uowfzKBlkPxy2PBGA+VX2pltvsBum1D?=
 =?us-ascii?Q?Yj+1ocF18clKvyY7/zhBP4eoA4kPjBvv6bTFvHQ6Fe9uYKWVjp8T+ryBmcrr?=
 =?us-ascii?Q?Bk7J6c1ezm+23N6mP8/szm7UuxAF+3P5betmY100+UpeDZEm6XFv+BMO34/k?=
 =?us-ascii?Q?Jz90qCwo4hY3FeGc/INOWcaIAqukTTOHZY3G7abeZseXoRSdpRpDjhmmCdkQ?=
 =?us-ascii?Q?kKNOmhTCSLppjsRCZDRB1Og9TyR0zTIX/LOojE3qnn7MmigmsCQusweK/INr?=
 =?us-ascii?Q?me2qUT6ra4k/+zqwVAICio90/zciY0ZzPYYPvWEWZqKoYSdXpymJrtL1VWvq?=
 =?us-ascii?Q?nTuU+0Gq9B8ZUd0g/FG1JXMEVNvrsuIE12nzCEkPrHdS3M9b3MIK7Fo8P0XA?=
 =?us-ascii?Q?UrYG1Cmwt+vONI89X2gOyMkaXBPuyG2s3cUyhk4sSa3NYHSq4JAE7hJ3gyKW?=
 =?us-ascii?Q?jwWdf3J5vAD5MeY3zscLWI5PF7APrOWlIyffYRMSumHlDvNsH6UEGYLSiWy+?=
 =?us-ascii?Q?N/f2kpiCYHpyilXQvoTciSd/ILQI60tarNwnLVnteWk1c4IqGfF8yO5mfIco?=
 =?us-ascii?Q?airLbyPhoGlDlqruELXK9dPekBjEh+y3ontdGlB/bsr0tyjDnkkPC8AUAL47?=
 =?us-ascii?Q?Cj7OTDpyAacDRQTDWFNZj/XDUuot1tMYEUDcvYxL0/dg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V95ajh3oz8eKTcYoznbg3fmEJyMtabWlF5UMvmqUL3Hi7ZbVSAzMbTLXhWh5XgPq9L/BViDpL7xAHK5P+6CFk+K+BRz4Id1IFHEOWV7B5x4TP/K1Iboj3CDkLA30DDzgFxw7yvnqt6Y6kWrGqyOK3tiKhQOuCW6AtjhQLiNL9VwqEvFCgT4fCY6j6r8t7OurYa/gF6XEOdt1FFx3d7RC5nXaqO3zTlE8EVYZPihPc6aOmHkHGzgn2nky0GWX4iUJR16oDmC0xgKBTh+nlp6XdydlZ9kwAGF/K9IWy0QndS0OeLB8S9+D7W9OHEJzqVEb4cDOQqENa52+cApSqTKc3EUC+ubD7Xg1bDXh1ZEmJESYH3xk8IbY2Re9qtxVi0nVTrvUuMXbosxaA+Dy29r+6i5/JKSFkzxQylClBNQhyeD3LYfmqX7rP5oWjxk+ieGReo5JtghfjbobQF/juhtjXirpl3e2srGEpwq+xrUGuOhUL85RzB9G+vl3djimV/hT4slIolwTXQj/EgvSOQRjp1zeHZ2RVptYOHrAcxsp/25NbdVRPIQnMHwmaEWVnObZHCoKGlh+He8GfrtdKC/wSXOWKzCBYwgk5rHeCYTxoGBZEV0Ctzrc4W3OYLEQ49c4XWq9U1PpnvQw+BndUV7GjA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849ab077-e74a-4480-4cb4-08dd7d6c9368
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2025 04:59:03.9332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sBiLgSOe5aXDJqnwyxpHCxLjUVPl5U5K9qXcSUegKb7unP0E5agjFdulTfEvliytPWfgLy6WgNh6tKg/W2YyNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR16MB5302

> There is no trace when a ufs uic cmd error occurs.
> So, add "UFS_CMD_ERR" enumeration to ufs_trace_str_t.
>=20
> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
> ---
>  drivers/ufs/core/ufs_trace.h | 1 +
>  include/ufs/ufs.h            | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h =
index
> caa32e23ffa5..43830a092637 100644
> --- a/drivers/ufs/core/ufs_trace.h
> +++ b/drivers/ufs/core/ufs_trace.h
> @@ -41,6 +41,7 @@
>  #define UFS_CMD_TRACE_STRINGS                                  \
>         EM(UFS_CMD_SEND,        "send_req")                     \
>         EM(UFS_CMD_COMP,        "complete_rsp")                 \
> +       EM(UFS_CMD_ERR,         "req_complete_err")             \
>         EM(UFS_DEV_COMP,        "dev_complete")                 \
>         EM(UFS_QUERY_SEND,      "query_send")                   \
>         EM(UFS_QUERY_COMP,      "query_complete")               \
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h index
> c0c59a8f7256..7f2d418bdd86 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -631,7 +631,7 @@ struct ufs_dev_info {
>   * This enum is used in string mapping in ufs_trace.h.
>   */
>  enum ufs_trace_str_t {
> -       UFS_CMD_SEND, UFS_CMD_COMP, UFS_DEV_COMP,
> +       UFS_CMD_SEND, UFS_CMD_COMP, UFS_CMD_ERR, UFS_DEV_COMP,
>         UFS_QUERY_SEND, UFS_QUERY_COMP, UFS_QUERY_ERR,
>         UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR  };
It seems strange to me that scsi & uic commands are designated by the same =
enum.
Has it been considered to add UFS_UIC_SEND, UFS_UIC_COMP, UFS_UIC_ERR to en=
um ufs_trace_str_t ?
Also looks like UFS_DEV_COMP is unused ?

Thanks,
Avri


> --
> 2.48.1

