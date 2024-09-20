Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113EE23741;
	Fri, 20 Sep 2024 19:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726858877; cv=fail; b=rKI/H9fr30qBH+uM9TdiVC1wQXwUXoAoYBAwaSyxvRMm2RfSd2PxdY1+b5154jS0SfuY0EvRd8wGGFOsfPofIG8rky7v5i7iUr2Ucgu/r2F8uLBPNuerslNrKp673z3ek/ru1VKNht82rJHjSC0+B5HM45xiRhgVsHlscMC1keM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726858877; c=relaxed/simple;
	bh=lBKyyi+w7Ux1Is94bGgSiHRdvKV0LRFuzAh64m9jTko=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M8uKKXZAkAW5PHSq2Xhw8uoZfBZa0k8BoWMdiw1db5+VE4SKKC0lTCDBPbpfwBSEEkbd9FKLXVvQX/IG5vFCISr01z/rUbZu49l93tbNKBhDiuVAcUlK3xT6XDbNHyL8nMJtUte/K+JtuHray8Hk3pYiMaXBYPfCMJlnofX/SF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iRbHEI/x; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TVLtGN1C; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iRbHEI/x";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TVLtGN1C"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726858875; x=1758394875;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lBKyyi+w7Ux1Is94bGgSiHRdvKV0LRFuzAh64m9jTko=;
  b=iRbHEI/xy7nC1FfJESygGo6jS3IZLf8tfLwUithxF5IUwm79JXhpBt2q
   u/BKD3SW13u4OF7fPp9H1cBBmFcxppmXA54KqRuR83b6+3vwZlQogleDX
   NMMw1/IqT1xeUC/wwndE4ekvq7TM2Moq8kn4vS2YMIiZytHMxy267B/6n
   YRMervnSmAVkph8myVaAkp1kMPko+hgkKpZLz6Lp/qKV8tweGJZ5dT3j6
   Hy0qg+bHCAziCyOVdP24+1772297uyTZqjhRfgR/5YcC1yvcVMoVnZ7og
   A+y6t4qVCISybpb2G9L2zB37SCnr3etvOtNyJRn0v8mRMWSj+du8aGb6o
   g==;
X-CSE-ConnectionGUID: lWnKzxM6QIqxE/Zj+rMBFw==
X-CSE-MsgGUID: tvMyqKy2SQC34W1+FL5lZQ==
X-IronPort-AV: E=Sophos;i="6.10,245,1719849600"; 
   d="scan'208";a="28198995"
Received: from mail-centralusazlp17010000.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.0])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2024 03:01:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROeitlsvxbORd4PcSz8SsTOI0vvnwhUaBSC4uhqT84+o//Rn2EOVVhhT83IvMQVQwbLKqWTUWlkj73lG5R+bhOn9k89EZiLHZ3LA3W9l2mNDkaUjb3Q544GoW9gYzBdhAtgWIwMA8Fg/46AAHFAu3rWoo5QWT3hulZnoVVHBeqt5I3qKJ+Od7uJsAAMOe8H8sU41yTM+LDEhGlKg5fYDMVvVHNsRa1+VJAkNDZgxBSdXd+zMyy6bCHbHTjHk68atiGDgDpHQ8PmmCTxzVsOlKQE3HazBq4FAHj4SpwfkgDCvehS99N4OyXsTksSZ9O6n9Yx4CdcHxnHbdkMd5kflyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBKyyi+w7Ux1Is94bGgSiHRdvKV0LRFuzAh64m9jTko=;
 b=hdFS+90SudqPRfXKw5urYlVFvXmL5pxg+kMXmRUzZklJjbPAmDFmS467i7CATBg/7EaDeQOmfsURIQWYQtECy0vbkeiRqnyi5LSAqlL8Bask3dIO6X4f+XIVQlL6MZthfr/VgJnYxiHBsyYv8Z7dL9ZIttTP6x0yOTWTXSx5EobgsvijULcyx1SRIToDp5w10WqvxUQ6JmZPmCImLzYc4gO5A07LMfoPXJSHa7O7B2JJ5En7VxUZTUlJeEFEOJXjlxTunpJOl9T/+Fjmrouja0/ZBeWf5h8KmuYdCpRca6RkTE6inVk2OxVWOgSXhPae2eoPeVyVVrWkh020GTxiVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBKyyi+w7Ux1Is94bGgSiHRdvKV0LRFuzAh64m9jTko=;
 b=TVLtGN1CzRm1OdhPWPR76ch2WxyklmYCalQkcE0K0FmXhfH2qvwInxQed47y5ABMtpbNbrSWZYM4oUvdr/guo/jFrtFtOYmfpnBfbkGi5CXIAH54c3CEZZMEs5egD9Anez8TcePSBmXlE4KEGln2g3o0zJ6EGhbdA5a2sIeu+FA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL3PR04MB8121.namprd04.prod.outlook.com (2603:10b6:208:348::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Fri, 20 Sep
 2024 19:01:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7982.022; Fri, 20 Sep 2024
 19:01:07 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Topic: [PATCH v3] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Index: AQHbCnAT5/OIcPHDE0ujGD1fh4hmALJhAPEAgAAI8xA=
Date: Fri, 20 Sep 2024 19:01:07 +0000
Message-ID:
 <DM6PR04MB6575F21241AD2B765375B715FC6C2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240919084155.17004-1-avri.altman@wdc.com>
 <0caf3cfa-d1ec-44b3-b2db-1d95a33567ec@acm.org>
In-Reply-To: <0caf3cfa-d1ec-44b3-b2db-1d95a33567ec@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL3PR04MB8121:EE_
x-ms-office365-filtering-correlation-id: 7fc3f5ed-7656-4ac7-4845-08dcd9a6958d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UWlUdXh6TEtVb014VUNmdDVQQzlNUmpmZHMydlBJZ2MvNmkvdEdnRGFQeTgv?=
 =?utf-8?B?NE1IUXVHTTJLL2N5V2JwTk9jb3Bjc0V5M29Rbmd6dytTczRTNFNMWG0yTFZX?=
 =?utf-8?B?YUZkZ01HUlBRbUhhdUFGaXN6NiszRkYrMFh5QmdLdDVHazVUUTZOZlB1Mnk5?=
 =?utf-8?B?ak5uWXpLMmxjY3BnQ3JvTFYrQi9JaGRqbnpPaGIwdmM3cm1sNzhFMVpBOWlB?=
 =?utf-8?B?MUZlbDZLcy9XRlhPMXM2VmNuTWJBd3cvUDg3SWU1NzAvRW5FZXNINWVJQm5Z?=
 =?utf-8?B?YUEwWnpBVU54ZWFjdVdZSDA2WWxzcDhDQ1NOOWhlZnZaVEJCVkI4bEt3b3JC?=
 =?utf-8?B?bHlGa0NJeXQ0TG5vcW5ONk9GaGJEam5SYm96SUZpZmRjV2xFUFl2bTRoTnNi?=
 =?utf-8?B?WWdYTjFvWlh0UUhhT1VkcGwrdk9mYWRmdHYzUFZ4aGFKNDhJby9Kc0hFeXhy?=
 =?utf-8?B?eUV0dVNyVHcrWTlxZDdQTHRDd1BIbEt0blN1bmtWL1dlOFFtVzkwTFV0bmM2?=
 =?utf-8?B?S3dFVUhKdFBCaTZjK1BUMkNEdklob29xd0FWU2MzWW9nYVcyMDI5WFVsQjZM?=
 =?utf-8?B?Qi9IVnVjb0dUUFNQQ1d6aEtTamU3dTZVQlczZm43LzhjRjZ1L1JMR3krR1c2?=
 =?utf-8?B?RVhTWk9lZmZBYWRLR3BwbjJZbjRhczJacmJXMk44c0NRVnN1TEJtT3RibVBC?=
 =?utf-8?B?dVpxVDRqQW0rS1BqQjVPWUtPM0JSRlYzNlVuUGs3ay9KekZYSm5JWTRTcjZJ?=
 =?utf-8?B?QzhzV21FY3ZCbThSZ0lOTXpsT3JtS2NCbFhMcUtyREsyNHpTMEhwck55eFlK?=
 =?utf-8?B?V3ZOc1A1SzYvdjNtdndOaEdVcUI1MFMwN3BjQld0WFVWWDBGN29tb1ZONStm?=
 =?utf-8?B?UmJjenN5NTl2cUNtRjlBZWRRWmM3QjVVRUswNDRqampXK1lDMXJyaDgzaUhP?=
 =?utf-8?B?cS8wU0d3cCtQVmVMV0N4bnpURjNFeFA0akV0WXNmMVljNnVjNTVOVUpINkZG?=
 =?utf-8?B?Q1pMbWd3L2J6RGREK3NGeXRFMk9EQ3hKOTdtcVFHSDFOS0dxd0VUckJmTy9r?=
 =?utf-8?B?alFPalhPc04xVkltVzIyeTJuMlhOcHpQdFY5ZjF0dUp1QitJVFM3elNuRGRZ?=
 =?utf-8?B?cTE4OXRmMVhhVU5zM01qcnlkTTQvbGFDNE9IQjJjWUZnalNCWkg1ZHpIM2RJ?=
 =?utf-8?B?T25TVWxNWUc3NWY4T3c4OHJ0V1Fzakt2TzUzNmw1SFdPVmpqNkpvdGNPcjd1?=
 =?utf-8?B?SFovRWVxa0NERzkycGZNNHlPUEltSFdrazRtU1kySk5aZXJUVVdMWm1UTzNB?=
 =?utf-8?B?M0xuME91MG5QcG5JdGs3eWtvRFRJVy9ma0xQcUJIb21YcjlwTGVYN2lMR25V?=
 =?utf-8?B?SXVXWE5rTFZTcFdsVldrZHViK0E0RFk5VmJ1U1oycHpqblM2N1ZxRlcxdEY2?=
 =?utf-8?B?ZXIydldoNjJrRTR4dUxEVGtiTHV6THZBQm1uOXpuRi9RaDZCLzAybFpKNjRw?=
 =?utf-8?B?TEFtLzl4aVhpTGFVdW5ZKzQ3VFQyYkFZUGU3a3BQNVdtRTh0em1pbFg0WU9K?=
 =?utf-8?B?WTQwdEYrV3lrSWlNa0RVbHUyanB2YVkxdENtK3RjQWdSQ1pRZ0tCY2NYV1J4?=
 =?utf-8?B?UGhCSXVzQTVieldLNXU2TFdIVGZYRXVSbndQNk9BWG8vQjljdnpQREFhQWta?=
 =?utf-8?B?WisyTmFjUkFNcW9ocXAzb0V4dDZpYk4xcktjZDZiSXpCUTlocDVwUzJydDJO?=
 =?utf-8?B?R2JOYkxYdGhOVHFQQTZ5MUpjUWtaYnNrazNKRXZHOEpZcW1QdW91TG5hMXJR?=
 =?utf-8?B?ejlmRDNGRnFrOFdnTGtBUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MW44cnl4WlFmUm5weVQwVWNwaUNWV3VHcVp1U1ZVdHozbkJVZTdPWTlzSjlK?=
 =?utf-8?B?SW04eSs3dHlYTmNSM3NOYlJudVRsc3BPcDhob1U2Z0c1UUFWay9XNHRUNTFB?=
 =?utf-8?B?c0tValJTQlBaajA1U3BENkllRmE0SCthVFdwRmQ3dm9waTdadkM1a1YxN21r?=
 =?utf-8?B?Y2Rad3V1RjRkUWFQamtKOGZVQ25pK2FwWlZoVFVSWHBNMzVUU0k1M2JQcXo0?=
 =?utf-8?B?U2JWeEZoRGh2d2dkWDJ3NWFXOUxPM3YzVURvcFIyTCtQRzE3SGxCUnBoNStO?=
 =?utf-8?B?MklIZE4yOFdvT2FQTWJzd3BZcGZxMGJ0MlR0dmU3L21EcDBtNU1LTlhzdERK?=
 =?utf-8?B?b2VSR1dVVXFteTZjR0hmdGZ3QlZxbEtXVklhU2JzRzVyMnA2Sk8vTXdxb1J3?=
 =?utf-8?B?enJHcFZuUGJ1NXRwNWNmZnc0ZkVBNnFOWEJKOVp4ZGc2ODl0bGtkMnVCWkp4?=
 =?utf-8?B?ZnFNZjEyRk8wNjRyRXN2N0FsQkNkN21lMm1lOUIyRndZa3YyYmkzZ1RLUU9O?=
 =?utf-8?B?d3NkMXQrVm0vY1VKdnpkRUZsZFpMUnhPU0RkWmF6YW5OOVJOcGZRLzBhaUx0?=
 =?utf-8?B?OWZ6Wk9UanpxOTYwL3M5eGlZanNKanlQQ0syY0tZbkhlNWxOUC9OWTFpdERV?=
 =?utf-8?B?OEFtVEtpMXVPazB3ZEdnMjhHLzJnTXRyUmlEMTFNVVJ6VjBady9yVFd0dnlx?=
 =?utf-8?B?RzhRMVZGTk5BVkVoVGlxZjNiUkRkbDVjZW0rbktZckF5Wkx2L2FYVkFNY3hw?=
 =?utf-8?B?R1RhQmVmVkROQkl2elVVSStvRVdwMnRpUVV1YjFXYkg5R3ByMURKdUhGZnV2?=
 =?utf-8?B?bTBJbnc0a2t6Mzh0RXZDNkhpaFlGWW14VU54QzlHRWJtR3doSGxxK09UZnlP?=
 =?utf-8?B?Y0NYbm9GdG5EZDVEY2RzcnNreEZMSS9vV3dKS0wvR04zYi9GNU04VGh2bjdY?=
 =?utf-8?B?N2FaVUJITmpXUG1EWkp0VjdkNzE3VEpuMEpJZkhwQTl1NUxvTVg2UGlHMlAw?=
 =?utf-8?B?SFZKeGFhVm92bXVKQ0hINWMwclpQR1AyNEh6L2FTUW83dEJqY3d5K1NiRkE4?=
 =?utf-8?B?Q0xUMC9jZDFyb28xZkU4TkJNZjJwSVV2dDd5TUZtdTFpeFFKRkxwYnZSZXdX?=
 =?utf-8?B?R2hBVVlDVENiTXdyb3BuRUFwT1NBbHlKQy9UU01YUnhUZFpWUjlXTUxXVmM5?=
 =?utf-8?B?R2RNNENMaFppc0t0YnZCUW5QNENmMUxUMGRxQkFvVkNYMzJyNGpuQWVXdk5U?=
 =?utf-8?B?d1BCUDA3QmVMVC9OalU4YkxWQm1lTzlROVZYNTFpNlJ6ZEUxU2lZS0JNem1Z?=
 =?utf-8?B?QlFJKzQ0Z0FveXNWdlY3aGhEUzVQa09OT2g2Rm9pdzNNWlZETmRKOWtpb29Y?=
 =?utf-8?B?d3Q4RVZZNmk3a1ZmelMwZThoOHFobE5ISGRXSVJYM0Rjeklmd3JKTDlmMXZw?=
 =?utf-8?B?bFQ1Z251dS8rUHptVzdjbGZSbytrUy9HYWdiOXBoVlQ0RzlLdHNyZGl2dnFW?=
 =?utf-8?B?WXNhbmhUL1BscjNQQk9CNk41LysvMzUrVUpnU0RjSFhVa3FMY3FURGd6ZDly?=
 =?utf-8?B?QmJ0M0pZb1Rsc3A2Z0c1NkQzZ1BNbUMvcFZXMmtpalRzMHJSK3N5WGVQeHNx?=
 =?utf-8?B?bDJYTGNUZUg3dmdmL0VHRkFjSTVaTFdkNTNMRGJGTXY4czJabmdRQ3IrQkov?=
 =?utf-8?B?N1pnOUdacm0vbTFaOEtnVjRaUHo5cndUbVNXbTBDcmhkWHN0RDduVVMvR2Zt?=
 =?utf-8?B?emkwY0kyYXZmOG90OXFkOUhLTU9JdkV6bDRxVURjSG9vRkNMUU45MWltVis0?=
 =?utf-8?B?N1hTYVFuRUViUUp3allCcE5JcHlrNE9ieXkvb2l4QnpQRzY0eXRBWjMvdk10?=
 =?utf-8?B?L1RvaHdTYTBLZVFBV0hkTWp6ZFhnRzRtMzM5TWxPbm1vNUo4TDFCMTdSbXRy?=
 =?utf-8?B?KzBFWEpxSWo2d3VCRVhSV3pOUkh3UGFrRVd3ck1Hc0ZwVGEvNlRpVXc0VXg5?=
 =?utf-8?B?SlA0NEpZOEViUFY2bEU1aDhWY0ltb0lYWGx3RzQ5UU5YRjc3UHVXRzZYOStF?=
 =?utf-8?B?MnBxdEtacy9tTXMvSmd0cjlpQm1qTnhtck5zdm9zTmx5c0JxOGNBMmZNVkhK?=
 =?utf-8?B?SzRnRzNuNjlHVFNwOFQ1ZG9QWSttWC9GR0k5ZWpSeTVYeUpHSTZZRnFCRHda?=
 =?utf-8?Q?EshuABmRZUKuyuoKg76NzlNnrLmxISVyvOLmRB//63tn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uFNrAcnrqnSyvT934/jRrUhf48r5AYtoL6bq/Tio2Ga2LfYsfvGt4exeACpff//qxOct3Nmj2kHym9Du3b6YM8HVEULcNUMjK5NhPxTxnKJAZC8TFwrI1w6OFxLosFc2IWPH9nu+UimzzJ/VI+ruoL264W9IoIGxoslYgGruQPP746fG2krjge+7yWnWkt/MnrmbahlnCrm5yChI++tJLAnUXV4LjzmhrLWWlZLdbhe4QHGo3GwzL+HUPgB28D2DeRiWy/vqI5pRbZjnk9OMJF92nRzVqgWZQAEbs2hJr65R6Wqex2iR0TifjxgiHvXt/dpwAjWVwwwrPUe+bg1sEgS6JUOEokN5CmleaWtgxtlqP5QE8E3c24mknFpZmZBMtMMgDEBgB4gnh3fjN91QPAY912NtLIakomo2YSBiTp/y0oIIwc4mPsSPjEH2s0YqD3U+NmoRTH33j6r2C2AVB5zWBWM7nKDh8dQLcRFLlerKworQevCzqj7iPKyaHKqpV/SiJdk0EjUX0NuIvh3H09jcAc03Nw5kH4gpbmOffV4LwYcRqC7YyBpSe4euHp0PDhoOEcpxJBNJOq5UnlVjmJbwPUigQ3Dpkuo4uMDPBHxrqgSMjL+6Z6tT/G7wNVLC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc3f5ed-7656-4ac7-4845-08dcd9a6958d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2024 19:01:07.6062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ur5Djp5mssngbrwXEt2W1DqmQ6HBbJr73EVBpXySINxGrb3zBvUr057N0eTor4sJtvs/dmemucsEL93efVdHng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8121

PiBPbiA5LzE5LzI0IDE6NDEgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ICtzdGF0aWMgdm9p
ZCBfX3Vmc2hjZF9zZXR1cF9jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVmc2hjZF9s
cmINCj4gKmxyYnAsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHNjc2lf
Y21uZCAqY21kLCB1OCBsdW4sIGludCB0YWcpIHsNCj4gPiArICAgICBtZW1zZXQobHJicC0+dWNk
X3JlcV9wdHIsIDAsIHNpemVvZigqbHJicC0+dWNkX3JlcV9wdHIpKTsNCj4gPiArDQo+ID4gKyAg
ICAgbHJicC0+Y21kID0gY21kOw0KPiA+ICsgICAgIGxyYnAtPnRhc2tfdGFnID0gdGFnOw0KPiA+
ICsgICAgIGxyYnAtPmx1biA9IGx1bjsNCj4gPiArICAgICB1ZnNoY2RfcHJlcGFyZV9scmJwX2Ny
eXB0byhjbWQgPyBzY3NpX2NtZF90b19ycShjbWQpIDogTlVMTCwNCj4gPiArbHJicCk7IH0NCj4g
DQo+IFRoaXMgZnVuY3Rpb24gZG9lcyBub3QgdXNlIHRoZSAnaGJhJyBhcmd1bWVudCBzbyBwbGVh
c2UgcmVtb3ZlIHRoYXQNCj4gYXJndW1lbnQuIE90aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGdv
b2QgdG8gbWUuDQpEb25lLg0KDQpUaGFua3MsDQpBdnJpDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBC
YXJ0Lg0K
