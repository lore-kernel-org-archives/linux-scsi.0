Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C6619EED3;
	Fri, 18 Apr 2025 08:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744963560; cv=fail; b=Ah9/TSVtCGLDJkzmr6VXohPmI+mWDNzLMVo5QZ510s4aJnrA7VRfe7oY8X17wdPQXIkEeadZbXWfN7rR2IKuUiUlKN+0L8Jwnsi8L68tGe0sOZP1ywPLE3rjjIYOTvqe4EKq3A36i5/Z+8ZKxBjdn8686nDgOATmUeh1EEKRvEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744963560; c=relaxed/simple;
	bh=uLZgZ8KArPmJgjlEhBqw19e55spfP5ql3ngGcWTZiP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s3rfKerDEAl+GZp4Cxm/JjlaPBSbzI4vbf78vBoYhvYMKlHsiAxLr06VA+9xqsFR3OwATWP3aUEO0GRoz5MCCO+k7viSzgRyd9Q4nHiiqZ30gax/fgQko7L3EuaUUodH1rlsPQDG4ETy+OXoQaARD+clYM2kmVKLW7BMj5XCSrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=IRpoid7A; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="IRpoid7A"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744963558; x=1776499558;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uLZgZ8KArPmJgjlEhBqw19e55spfP5ql3ngGcWTZiP8=;
  b=IRpoid7A0QcmoJmP7UWeiBc1YpgO9DU+84WEcBvfK2TeX1/rHxGkN0iH
   Ml16eAV07cJfiGUa7kmncareTKJ2SRxpwfDsjRtgnxQUhLO2Y1zlhsZVd
   khxB0LkQyjwHECvnNIPWXI4TZef3cXA7vsrxW2Qr7/JiaDfjRIPCj9b1R
   n14coqzO4Uv+fyVeO0qAH7tGe7+8ScLQhwTgmGdmgKXUhUudP2avXO6Qx
   ew2eXWZiMdAe2xh/DYIRHeCnz5kkO2Lewpj/7mv8WCrPJQ+BL/eZfZU6h
   PPUwmh63v4dgkCculOXGQyaf9eU+GTMer2c5jld6JjbH010fha59W5Z+N
   A==;
X-CSE-ConnectionGUID: OyCiyZCPTECu21qSS6S7Mg==
X-CSE-MsgGUID: 1LT1LVN1TgaljfvJvTXhzQ==
X-IronPort-AV: E=Sophos;i="6.15,221,1739808000"; 
   d="scan'208";a="75823144"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2025 16:05:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gP1X7OGJSEH1Ow0ss45yoSMhQQjHg1IaE8XgDtVZes56fOFzEBpX0Ku4i28T6rSrQmlVO1IRj30ry1tqWeyqquR8fTV0iPkyOstEENoIgxNMJB/cKy1T1+yYNoSMjdyIrA1nB86rKzCLjBPRnVBpOXrvP/XRpSIusmMSSOtYRQ9IYuwDmb7XD24Vl68Umv/jyRNwW5kBTBIfUo4Rx8XpPLy16jCMS2dfjVIZ8RXHtCXuDNm481JRUYv9ueMyVo1B/oIpMih318lzxxlcnCqCLftJnvkhZoaEI7COFqGqDJkgZd1eR/ooJuXV6X7V+rQqPdz06V/rBaLsjNfvNp2veQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jhrw0cfU8N1SvDCrsvSR9el5Q3p0W4EtHjo3SBd9b/8=;
 b=HARRxUwg1fwZLoG9THRo9HB8Pl9gPz/S7oOm3GDf/OU0A/33XRSt193ire6h+ISFJGQjpA9n9HhQ9SSY/VVUxJ07Xjf5cNub2fg8wTRSYAzLWi4ZKZc4zjtVDGkxQfOlhqox0q5y9oWNCDaXkSkHyYxgJdOnqJxq5w+RLnZ9OGxk7N97pqmRG1Imy2DbnjIvpGu09Qzbab0aU0lJxHuPfUE3gMx2PtxuwBmaqLjO5GgzYT5MtV0AYcCmRpTwh0hA1OMdLqeTwt6sIjauSEfYFNoo6u6L9JkfTYhImKi6PNvN+JK2U8rV0EoBwX+RtJRwv2vYBjvswUx6bH+y8dm8Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by CH1PPF09CFB818D.namprd16.prod.outlook.com (2603:10b6:61f:fc00::a06) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Fri, 18 Apr
 2025 08:05:47 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 08:05:46 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Huan Tang <tanghuan@vivo.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gwendal@chromium.org"
	<gwendal@chromium.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "ebiggers@google.com" <ebiggers@google.com>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>,
	"luhongfei@vivo.com" <luhongfei@vivo.com>, Wenxing Cheng
	<wenxing.cheng@vivo.com>
Subject: RE: [PATCH] ufs: core: Add HID support
Thread-Topic: [PATCH] ufs: core: Add HID support
Thread-Index: AQHbr5dWvNtDdiBEX0m87nfzi/yMqbOpDSQw
Date: Fri, 18 Apr 2025 08:05:46 +0000
Message-ID:
 <PH7PR16MB6196FDEFFF1041EAD0668AC7E5BF2@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250417125008.123-1-tanghuan@vivo.com>
In-Reply-To: <20250417125008.123-1-tanghuan@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|CH1PPF09CFB818D:EE_
x-ms-office365-filtering-correlation-id: 051cc682-5a90-426c-bedb-08dd7e4fd34e
x-ms-exchange-atpmessageproperties: SA
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?9TBXXqVxBn5KDT/5kY84G9aDU/lq29yaBalyP6tNegV0xRhYINwYg5SyyJWS?=
 =?us-ascii?Q?nxtuFQ4k4qGkFY6asrJ+kVyuBfdCAKRDWn07JFZ4EKN42Iqn+Ja3IwuKNu/e?=
 =?us-ascii?Q?DSJ/24h3lFj6rieaNBkjLTcWhFqi266Pom22dROzIFF5lvmcZjBfEb7243tr?=
 =?us-ascii?Q?emGjzn8/QoJ5/QnahWZS+LTuinCrtVwAYqVfd9qG3bk6EQkOfKE1WRa+g6J0?=
 =?us-ascii?Q?OyvUZu3XWtx8abwgWouiYP3HM8sWyOOicaye+DxbGcFMlm0g5drNLx4KU1j0?=
 =?us-ascii?Q?LzZnaJw1+uZ67EhGHEEG1V0tEZJkPP2nPXj7EDSb87SwteXvREIrtY0EYnwe?=
 =?us-ascii?Q?v28b5OlNaPdogKU90SgKbv+SyMjfz7tDKraMtdRPRqGhwGdQl31HzpE3JMQL?=
 =?us-ascii?Q?YshE4hIyWRBcRXXNGc0BBZDHnaueklqr2hOZYYLr6Shk8psoh4qFCmw0rlux?=
 =?us-ascii?Q?IaC7cEbnx0l4CDv+8n55QsvpuEd6/7JWq+Gqy3GgwCxncS9o32H1Dm6GUYPc?=
 =?us-ascii?Q?mLeVRuvY1Xux9QHiUOqRPtuiNwm8amahrkkQRbOEVOp+hToJeTymjxEe/b4q?=
 =?us-ascii?Q?8mb6AEmD+QJjqmA00oZk8VxPRWmKFKD2K6KmYk3kLPs2w4iWeUBTnGFeULbY?=
 =?us-ascii?Q?6N4JePjgjS7fxeK5ic2RXEO2tmdmtH7z0WgSIn84ncqaoLjbYMrVXeU9NJFW?=
 =?us-ascii?Q?+q9IgxlqbKGapBPNRl3Vsgsuan/Ne3YUNL1xlHcoBjlUVzYJ3ZRTx0bvHSBd?=
 =?us-ascii?Q?V9JPmVGF9VWZeEmxnmITMEV+LvPABKLS+A2OlDnJ1jjAR2d/ktMWCoy4jCiQ?=
 =?us-ascii?Q?yNr0ktUgOnXKfRIcDyXYSnnDWeLyxPvCNlF74JFvp/xilvuRVF5GZV9BNawX?=
 =?us-ascii?Q?cWYoAxBSpFVSFayLrdHBE74uiFFGrQJPPd6+T3cBroKFhBLBuLf+6CcqltnM?=
 =?us-ascii?Q?G6+VTnvlZ1NB/Ef/205BOMnb3GTEaKusn51TT2ki0fMbk7eEXY1IMC8Rg9B2?=
 =?us-ascii?Q?2cL+SsTD8nxT84SNWIf5wRdzCHAJojzK41wE0kY3kAYrn2RvTvZz1AuZvTB9?=
 =?us-ascii?Q?3IES9VibQXOn1nLBcmv4hOAwfJtY14y8TZC+QwWVg/iDPk1q2IThNdhkiyUs?=
 =?us-ascii?Q?mqmr+sKbUU4qoLDAql8dS2Ba8cYxTHyrvtTSld9qEydbzh/8rTkoopVGtdRl?=
 =?us-ascii?Q?bVgOSNxbQpOrI4jpoEP4N4dmIte6tYVufRwpqCoCMq2y6nHujgAecSSjwNtk?=
 =?us-ascii?Q?MfxC0SMeQmXCJaz2faHp1ROjCWVuR188OaLGKoAlwz3cTtoe87xyxAsnKJhc?=
 =?us-ascii?Q?QfgDpbhCauFXrhvHVvqrJdbNAdpW+YPUNFhl/1T99Y3sDSXb7/M7xd9IIb4F?=
 =?us-ascii?Q?QT+7pzmmuwLCI9V/OWY5pbO62O9EwidLmABKsfwL7CYJ/96chiMHYVRNKz0N?=
 =?us-ascii?Q?AqRKGZpZK8AC83CKLWj3SqpBe/B+3PytZTGbexMiL9AG4FL7HaCBgxIWAfJD?=
 =?us-ascii?Q?enZ7hYjrRsAtxKA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?sye0U6xWNOpRymVScIHwaCID68JsASWLNIyZnUc3PIF6t07Hee6MpO06zKbt?=
 =?us-ascii?Q?QWyPCwpxdbIVxXp3xUmueWUXIKcAoGf99J91bOHuHCgEEjJibuCdRhSgmbJO?=
 =?us-ascii?Q?FMkHyTS1bAQgEXviVZkrei+WLK6IEDP+RulF2dg78Xg45WJfynEsURpQ5uQW?=
 =?us-ascii?Q?zIkJv9bsmo9kI45PgcoVl9Uzu9AzPpXZKIBeKzNaSiUg9xF1EcmVMY22H5Xh?=
 =?us-ascii?Q?NvY+sxtckrRj6hkV5Ic+hwqcuJFvHac6YBjWkGKIA6fLnlYrSfT4eDGhHarq?=
 =?us-ascii?Q?WBH0Oxzj+UKZflyXYMcWb0kQtjnbBT/wB3j5q8Wvwi4PN1zwA0R3N5PkZii0?=
 =?us-ascii?Q?RQHK0eLq6hridRoS7UEhIEMLKawkMi935Vy03VV/9mPMD9VGx5JsrewOk6Fz?=
 =?us-ascii?Q?FAvDxacYGA5rNVVPXZwUonlx3fVVCLxnNHjzCMgiMMnZqUlTVDWJ6ObrRNQD?=
 =?us-ascii?Q?ISd6n9qJkn5thW/1h4fXTxqSZqlQKMzODHZZzJAQSBpswsUnnU+kDjP2o7j/?=
 =?us-ascii?Q?vU+XQMLHwOHjUxitB8VFhL4rwQsbycdWHf7gEIbt2MMj9njXEJfV0YCYhxBv?=
 =?us-ascii?Q?NTODjeOrWQ3rcN3TNUlQiguNkNZFAE0mF68UHsCR84kmY2Vmy48U6pIgXIMS?=
 =?us-ascii?Q?MzKN+13mxmbQxPCOCNJ3ui6KLXZxc7BDPtt/lNcuOXES5ccCE/XsBTTFhg1U?=
 =?us-ascii?Q?nQPNpSaAZ/Hj8TGAMdFCS6YmhLaBoURr+iG3Mgh9ey2bwv3Fd8PeegYg9ajZ?=
 =?us-ascii?Q?TBa8154ar3EFg2+F3f4/ZS3EX7Fvc7RE2kJePojd32nSJY8kQQD5foYUId99?=
 =?us-ascii?Q?dfrTk4/WDhzlrmBHHBYW7rBKAUTvaYkeFvu03V5wBdVnS8Q5MHPSi7UStPZm?=
 =?us-ascii?Q?sCplTovKEwhoR2+PDL0YNcOk7CKGa2ejoAduQPSLukfLB7+JQWm2J4w6fK3u?=
 =?us-ascii?Q?yW0kfrrsSzeEQB/nvbICcH1kR93iWGg988K0h1bQABHR24YTe5z2UyD/EDtk?=
 =?us-ascii?Q?3nrk+kRgDkbmj9lRm+d928Wv2TavJ5bx7tO6GqoqVLLwRFlNXBenZeUHWY7O?=
 =?us-ascii?Q?zRVOB+ZJFKG3Abh1E4DU4oMiMeMOZ47gKtQBiB1qomIAZ4TXEE4Bryud+Mpf?=
 =?us-ascii?Q?xplXs5zCWO6cvAIaEmf8i70mZuoRNXiPqQoUO3nQtLOI3mbk3q+LdsyZGXxQ?=
 =?us-ascii?Q?hpVvo6eCCDddXCfwszgY3gCnoh1ETXTqESwd49I3QpG3+gpjI70luZDsRmJe?=
 =?us-ascii?Q?farblxZ/xTs2e3z1nJnBiCxI0QFLgYy9aycQReItKRc2vWs3gwdFnDCAu7Ij?=
 =?us-ascii?Q?+s85UbO6MLJDKuyTackFYJIlYBl0buKcFzFCKyCevTqeFc/HA4OPRWc8iwSm?=
 =?us-ascii?Q?fkfbYFwpyybfisWZLSPI43C0WG85zaQwh0HxUPnAw3vHsYZbX9vV/jVkQGue?=
 =?us-ascii?Q?xgIO2b2YKG1sTqpxHW2FB9Ack2/CX2uxOKcoVWtbjk90VgZO/ed+hPNkr4ee?=
 =?us-ascii?Q?OCIkNeMgljQDKJGKseUfCoJZy6argT4oIOJ+CHf2ryynu7s+pAzFDxJdT9uh?=
 =?us-ascii?Q?6JT7tn/N7euYfuvkBo/Fm/bAz16qm0SKjAK8ILy6THVQ0M0yjbqTYfz69/LR?=
 =?us-ascii?Q?c9LvliSXN0XRIBvhELpCdIw0C3sngDlrUWjac9UatxOm?=
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
	2TwPttUYOtpcmqrWel4anosi52jq8d5yLalllqdHVfuMsb8BjoPsQVy0i2BesQ9NS2cz9Eqe/V/bKvBd9T+Q4cWnyHoNv9k79MX7SEW3MbsvJGjx5KO+xo6G7ukeDatROeeVnvzgsDftrAHyWkPEcXTLoHwcT8miCm+sqEOAV7wVSNk0hHmEdXgUWMMpL7ZPku+cnADCVWeN8sdG8DNuSiI8LM1jCsfSnMh5mqwnC+6ZPiN+sXPDJmkfrHKEI/hPHtt0wWmfOYayzS2cJlli8phuTesKuqeJzv8W89g91sedFnMC8JawbKHfnTpIee2aORr1YxXu8IlqGCYk3tkvP5brdUir0vsjnzsOlosotDrT8zLxtkHKi1B9kJ61dONy2B+LVUoOA6BPxQjpN2NqGnSZawR+XgR9K/XSnB7A4ju3PvAy/0EiYHDOi5uuUQl7EvihJVMi2hWM+UTlrNHd/HDXfyDbhqFz2BQSQaJNL6+m2yoAkR5b4W8niiaU5e4CYYNeCoqdDaSFpsTgvlC9LxrLEF6TCZIPe0Bg+CXFDKGQXtXOUc8Vz4uRtIQJARfs9eT82RGtnxxx848lh+QwK12760fj0fKBFI95lBv6+wNm9s90MVCCUU/2rqLsLnX08eFPj4/CBWB7ncK0D3/5tw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051cc682-5a90-426c-bedb-08dd7e4fd34e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2025 08:05:46.9009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U3q8X3OYv7tC/DlMSH/gi5l57kthDXBziywj+oW0MNM0pl3FwKKZZ1RpK+1HWfERCr2pGMOmis+VnLGfNFNYXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF09CFB818D

> +What:		/sys/bus/platform/drivers/ufshcd/*/hid_trigger
Maybe have those entries have their own hid directory?
Which will be created if (!hba->dev_info.hid_sup) ?


Snip

> 9614,6 +9619,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		req_link_state =3D UIC_LINK_OFF_STATE;
>  	}
>=20
> +	if (hba->dev_info.hid_sup)
> +		cancel_delayed_work_sync(&hba->ufs_hid_enable_work);
Is this mean that you need to re-initiate the hid worker, if not completed,=
 on resume?
Then if you are polling the state from user-space anyway, maybe move the en=
tire logic to user-space?
It will simplify your implementation and maybe you could give-up the worker=
 altogether?

Thanks,
Avri
