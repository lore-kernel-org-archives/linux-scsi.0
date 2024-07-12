Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E0A13D88F;
	Fri, 12 Jul 2024 12:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720787477; cv=fail; b=XQ/3/stTutMjLlx2zBHlD/8GobOguJN9fEXYywrm4lA0ljYEQ2w5tSjcOxSNIOVmRZP48VdBoWiYF1QIZe+xXK4t11J9cW1a9twcEtgfZbTrj+LSUeWbK3rI6WHEHMLCARRF8cMiTs6weGLYGc6yh3V3NEZwNWWBAQ5BxwSf/RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720787477; c=relaxed/simple;
	bh=jGYiGQ/d5Iy3jnALaRYT0pqIFrk59CYcPZLRBewmdqY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cg2VDJ5FEMstMmrOGfx9vR6Nili4DuT0SjISscFF7/MYI1ty6ra/vaaTJnr1/9cKkjC2qRBE/J3vJtMGSGM0t+P3hIpUu4APGMKBdPTMyXONBMBTzQaH6YU3ssLE7YoA6tEAxxBG7QoAejrMQV1iDdam/JHAa9wClg/jkFS5Tsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VQmWJxFy; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NgJs8ZxV; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VQmWJxFy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NgJs8ZxV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1720787475; x=1752323475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jGYiGQ/d5Iy3jnALaRYT0pqIFrk59CYcPZLRBewmdqY=;
  b=VQmWJxFyigB0goBCNREqlrcdIgiWNxQD9safQNUpvGu0G4ldQdf9gta3
   GTowq8EzLKbmGSz0wsMYzDeuSxybdMhyGeSCt5tpbtYcffQccpQcmsg+x
   jhc/x/0QQGsu2TPf71XWPaQVMNT8MFO+LpTlr8UC9DKeMO5Xg6pdtud/y
   Rb0VvmY3I/Un52jzM7lu5TD4kwwV2CbCmWiBkmlRrszGajruGknfPrLSE
   CTjVTNp+ZNLy/PL2Rv84af2KtBwJl62Uc3aMQwzYXQGKxs87RWlEqs+1/
   N9KHWLuJYHYbaWPnKyNRRe1JWq+YngPYRHiaikUTC3y7Ja+eXXy9omLZj
   Q==;
X-CSE-ConnectionGUID: 2odZxEb2RhG5w8wyTEt47Q==
X-CSE-MsgGUID: le+V67GWS3GxKlJxHqWqPg==
X-IronPort-AV: E=Sophos;i="6.09,202,1716220800"; 
   d="scan'208";a="20703323"
Received: from mail-centralusazlp17011031.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([40.93.13.31])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2024 20:31:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUhxXEZCWQblN5WQ6eHua5n68cdyWkrgiAnViLgzh7Rm5NtQEcyJCJjg0HE9m48FJKmjJV0K+Dg64bQlxBBh5DJ6XypYZS5HDMHGG1eCjCEh7XdHBC7h8o+0J2lcaQ52XiHi6jvvJV6n6T63m0bsdFGF0KQPOVS/rWz2VpC3aq3aQxCd2hfgXpqsKnfF10xpRUnKRfJgdzWkxeTCZvvIMpidhMzoljFDElXo7TAgGY1Kr1eLi/MJM4cz0MeVuVuAln+G7jQsD9X09upLQps8prvLoQIlNAl0mL8SRgQM+v280nfRh8iGK8q6CNmXoMBp28Jdw46JgyuHQ00qTAEI1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGYiGQ/d5Iy3jnALaRYT0pqIFrk59CYcPZLRBewmdqY=;
 b=hgDngWMqMCEUO+eNypyB1uf946h66VHeen9p+9v/4Qpe/2/EwUU9OgbodndnzkK0HhpgswUYeC9GvqoqKjGQRMprKz4FcM+FC/odxrnLJKMd4HrqTGh4vEJeuzNGDK9fSSk+MqJGhJcajMXT0coWPjAODYyK8vanLWu+wqEKhQ8OoYm93bws/vxlrrGMfBxufvMu6a7vQIYbcm1ea1o9O18V7JKED5HdUUx4hDa8Pf3Xk67YCvNs22SCMGcdYOq/oIBCz+AbrIEbXFRxkK4AXoqTzzFTEr4+GSyRbvdJp2caPhqGIfkv58PolMIS1DaDh5IAmlkPPs1WWOYeU1WgUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGYiGQ/d5Iy3jnALaRYT0pqIFrk59CYcPZLRBewmdqY=;
 b=NgJs8ZxVMtciiMXFubFnPcvH2mr3kqPv8eF/WwCj7kjG8JjBqG90Af+FvJA4CGscilI3IYJ1qoTafPdiHwE93qOKyvHcPKgYnRIZX6AjckXGyHxvPOFMLW+M+/vSH+cq6CJ4+5w0bwrU4sSQ58sOIOszgrd98J3LeFqClGL7+L4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CYYPR04MB8839.namprd04.prod.outlook.com (2603:10b6:930:c5::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.23; Fri, 12 Jul 2024 12:31:06 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%5]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 12:31:05 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bean Huo <huobean@gmail.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC: "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
	"alice.chao@mediatek.com" <alice.chao@mediatek.com>, "cc.chou@mediatek.com"
	<cc.chou@mediatek.com>, "chaotian.jing@mediatek.com"
	<chaotian.jing@mediatek.com>, "jiajie.hao@mediatek.com"
	<jiajie.hao@mediatek.com>, "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
	"qilin.tan@mediatek.com" <qilin.tan@mediatek.com>, "lin.gui@mediatek.com"
	<lin.gui@mediatek.com>, "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>,
	"eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
	"naomi.chu@mediatek.com" <naomi.chu@mediatek.com>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v1] ufs: core: fix deadlock when rtc update
Thread-Topic: [PATCH v1] ufs: core: fix deadlock when rtc update
Thread-Index: AQHa1EAMhMEqtVpRCkuCtX1cIaukurHy5CbggAAFtYCAABwIwA==
Date: Fri, 12 Jul 2024 12:31:05 +0000
Message-ID:
 <DM6PR04MB6575CF59300D4AB5E1BE1377FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
	 <DM6PR04MB6575B81B788F260A8C640684FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
 <edbedd4e992dd0adb93adbd45a74614c4c0f626d.camel@gmail.com>
In-Reply-To: <edbedd4e992dd0adb93adbd45a74614c4c0f626d.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CYYPR04MB8839:EE_
x-ms-office365-filtering-correlation-id: e3eca3d9-91ba-448d-1c65-08dca26e8017
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z0FweXo5SUV3WnNINDdiTXhzcDlQaU53NVRPVFIxaVhtSEhXeDdwN0kxSmZV?=
 =?utf-8?B?bXdkQ3pwR0pQZTdyVm43aytObmozbUUyL1h1RjllT0lLbXZlNkkzK1h4bDVu?=
 =?utf-8?B?VjJlcGpVYlNYbWx2bmpLSitydmxSbisvQzZLd0E5b3pLSGk0eHR3d1BnamZy?=
 =?utf-8?B?VTFhWDJkNUVxOVRCYTV0Mzh0VUpWQmlhdXExZVc1QWxYbStjdjhzN0t0OGpz?=
 =?utf-8?B?dVI1Y2p6Q24xS2F6ZE5OZDJlTlkxMXpONFkrcmk1MzIwQTBQWFRiTG1sRHFM?=
 =?utf-8?B?RHJ2ZVgzeHNpS05UNHdiSFJBYko1VllDMzBFMFdEeGNuSGg3bmV3amptTHVD?=
 =?utf-8?B?aGxpK1FNbVFyaDBzdDlMR2hWOU9WTVBCTkpGSEhRN0Y2RWRyVFpDbXF4T2du?=
 =?utf-8?B?UGZFMVZvenk0VTQzaUR0aURGT0lSWmZnNWtZd2M4WDM3dmlqd2ZsRFhzTEpQ?=
 =?utf-8?B?bno3V1ZjNi9WUHJpV2hLZjVrZXhxYncvUU1pWFdQdVhFV2YvdDdlQ2FWcHZZ?=
 =?utf-8?B?TUlsWTlxeEtlZHpCVFhQMUt2RFJoVHErdnZSR2U4aFV6OEVKbjViRFBBby9F?=
 =?utf-8?B?dWQ3S2doc1h0bXJuT0RYVGxBY0xQMm9GTGxjR2ZrOWZLUzZ0NCtvZmhvbWRK?=
 =?utf-8?B?cGY4MkxBcEtXUDc2WmNZa0daOWJZOSt6UThZbjkyTnYwb01MVm16VmtXUjhj?=
 =?utf-8?B?QWdZTytaTFFKTm51M3hhQk1DOWlvbG02dlB5VGRSNkRZM1NkSUU4OVBVd09D?=
 =?utf-8?B?dHJ0R3lRNEIyUERBdDEwOFpqb05JK09yNGNWamtBUTJyMGtlR2lubVhVYVZM?=
 =?utf-8?B?ZTlCc2NkSHJyN0ViU2ZaQk9MeEhBZUorRzhhSm9TcC90MDUybXBtYWJOS1RH?=
 =?utf-8?B?aVRsbERlMEF3aHh1V09XY2tXSjJhU2R1WTVzQWsvYWU5UUZYaHFTRFNva2V0?=
 =?utf-8?B?LytFYnB6WmV3RGtNaXVKN2I2UkFsR0JiTkgrempBd1Yxa21PQlg1RVZnZm1l?=
 =?utf-8?B?d3Jscmdoa29IY2xybHZpUE9MY3Z2NXpGYlVtRTlhcXIvUXBhdW9rNkVxcCti?=
 =?utf-8?B?bGMwbkp1UDZ6YldmZTNNdmlYWXQyaUF6SWt0RWM4bUszNjhJM0dscHk0TGFs?=
 =?utf-8?B?VUFST2g4bjZnMjRPYkFkUDN6NmdUd0xocTVYc2VMY0FiMXJaRTVOMkhFeFgx?=
 =?utf-8?B?aVN3NUVYMXVRMmhCZk9TRzFsTnJkdFQ0SzJNeVJlejAvdTFMSE1YVzlJZ2Z3?=
 =?utf-8?B?TEU4ZkZZYy9EV3Q1U2t0cUZ5RnBJbWVsc3NKbzlEUFRDZUNtTmFsYTZ5U21P?=
 =?utf-8?B?WXlnVThWcDEyUXhReThRYU5PcW5YZlMzb1BKdjJaYnlSSjN3TTl2c0ExVUxo?=
 =?utf-8?B?c2Jmd2xYTy9XemJIdSt3Z1NCWGY4aFVJangvbDVzcDhtd2x0VjVHVUM1TmFT?=
 =?utf-8?B?OWkyVnkrUStKY3A4bnBxTjNnL1U4T2JiK3VtUUpuLzlyb09qWTJ1WkJ6eGtC?=
 =?utf-8?B?ZUZTalljZ2RlejVISU1zb2s0WEFnVnVrcE85dUVzeTM2YXpCM05zR2VZU3RB?=
 =?utf-8?B?Wk1sOHlaQkpYN2dyd2xxZkY5VG9vNmlvQWNEaGw3ZDlIUnoxTzY0di9TQ1lp?=
 =?utf-8?B?dmkzVmpnbkdGdE1PWW5xazVwa0xNL3ZxbEgyRzZtQ0JxdHJuY3o4TU4rVzJH?=
 =?utf-8?B?d2YrRlUzSzUvYzNqd1NjVk9leHZkaEppOUZTQmFrUm8rN3p0SjhIQVJOQmUz?=
 =?utf-8?B?b3Y3QnRMTlFxMVVyVjR2cmxLaTFWc2ZpS0pvN3dBYzIwcWwrcUlPTGl5a1B2?=
 =?utf-8?B?QmlIWlN1azgwczQ1ellIYldLbkpDMEhBMlgzWkZIdHBvNlo5VEdoUkxDRVNK?=
 =?utf-8?B?Y2RTN3lpU1IxekdtdS9uT3hZSlB3YWtqa2JPY0dldVlSeXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b2tjR2dXSjlmUHFXTDJTS29nMGkwRSsxWkZGWkVxSENpbkpuTUtlbzFMNm5j?=
 =?utf-8?B?K1BGVWJhbGFDQmt3QjhGYTVONm9QZ291MnA3dVRnNEVBZFpVNzhvUFNEQ20x?=
 =?utf-8?B?Z0doVW5OQU5EYjJKNFFUR2tCQmh0dktGeUdsOFNDeUE0ZExqQVdNZ2M4QWJk?=
 =?utf-8?B?OG1YVS9TV2pnRTBQUUJscHhRTzdVSkFPcGpXUTR1bDg1SW9JYlF0aDJiSkxE?=
 =?utf-8?B?QzBvMFlpTWZLZTJ2bCtUSFIrbmtHY0RKOXpJQ050ZjBqWUsxQThBOUdjMDZ5?=
 =?utf-8?B?eDV1cGpzcUZCcTQ0akNpcW9udmR4bWpqR05XMG1CN2gwQ1VCWTRWbDdEUnNV?=
 =?utf-8?B?SFdYRG9iZm5HOUw4RjV6aDRUUVN5TTh2UkxTWmJlaXJYNnYwbXp1ZHFCSGU5?=
 =?utf-8?B?dUJFUDlMOGhyY1pGWWpNNnJ3d0t0RjVraXppQ2tNOTZUMzlGSjJXUkk1M0lP?=
 =?utf-8?B?NmVPYzUwcVJXYWNJVWNLdkNpaWtnaHpscmVYRDRYZFVsTFYxa3JmZDJ1NUlQ?=
 =?utf-8?B?dWVlMTNxZGN6SGdlaERNbSs1dlk3eVZGSzFOU1ZYSEJDNFNGckJVN2ZRUFZu?=
 =?utf-8?B?US93OUR4S2lTUENJVWpNdU1kNEN5bHZCcmRmLzRTK1d5WHRDQmdDR2NVM245?=
 =?utf-8?B?UU4vV1RjNzNjQlIySnM4S1cvQno3Y2F3ZkNRVlZGYVFJUnU1STFrNndmR2Iv?=
 =?utf-8?B?TlFsMGNzKzF3dG85RjhOeG5Kc1Q1cGVZc0lxdnZSMGJiTkRLNVdXWS9NRTlt?=
 =?utf-8?B?UnhyZzk4bkgxcVlGR29pN2tkUTcvcUJSNXJCR3lqWHY5S1FWMzB4aXRIT3Jz?=
 =?utf-8?B?RU9vYlFGSDRiR0FaUVQ2N3dTWXhhVVRjYlNJZE1oODdwQURLclVpaVZyZ08r?=
 =?utf-8?B?NEJzWThmMlBoWElGUGxFc2swUE82eGNnTDFhbDc5SC9pc2RNZ2RaYWJvaXc1?=
 =?utf-8?B?d01pQVZJYWdoaWlqTDdRWEhYRWZ3c2JFMEI0SXpoZFVuRkZPWVV2a1owL2Iw?=
 =?utf-8?B?R1AvNWFwaThHemE3K05QMjlWTUNPeDEybWdBTVozZEFGTElwMGdsaHFSOUtH?=
 =?utf-8?B?WWxBa3hjaUk5bllDd3BDbDhYdkxzcmxOYlJ2cXhVY2FTYkxhaG5FWFJ5NW5D?=
 =?utf-8?B?T3IzS3VtdFN6aWN5UERKdUtGYURZeHlncG4yeDRJazhhM0k1L1dpOUw2Y1hi?=
 =?utf-8?B?MW9tRVVYdEphS0c0U1RmSklYc3FFdG9KakhqTTRuUmk3aXI4Rkk5U0J0NFZx?=
 =?utf-8?B?bGhHSldRUnplQ0xxOVFPcHZkU2dSQW54NWxpOG5vYW1EWWJ2N3RuYkhHeElE?=
 =?utf-8?B?Mi81bDdEbjZnVStTaGU1UVV3M0I0di8zTTZqM01GejZsa2ZGei80dE5pZHZv?=
 =?utf-8?B?cGxKRG5JTjEvNjVtOUluWjhiYVdWMnBHbHRYTzZ3M1FTdDNYbVpZdEJqWnNh?=
 =?utf-8?B?WXgyL2gwNmYyeFY3ZDVsd2Uvd2h0bE9jS1k4Ry9tRzI2b2M4TkxyTklrUFNZ?=
 =?utf-8?B?SzNyNW9BR01iQzlaRzVPWGNOTG9BbHhVVm1MNnJsbjZvbHpaWGZYakV3dFZL?=
 =?utf-8?B?d3E3NjBUbUdaejh5ZEVTSE1mbkxZakVoTkF6aXBtSFowWGpucE9mejlGdWdy?=
 =?utf-8?B?b1QwQ0ZZRVpYZGdhSXp3YlZtbktReVlpeGRQZ2dCK1ZWcnVJWk1BbmFFSkdi?=
 =?utf-8?B?R2U5OFVWSW1TaXNpSmFmd1lOOUNNeHV6TFh2WkREQVpTYzNjNWFXSkFyMG8v?=
 =?utf-8?B?KzV6d0NnRDZ3NFloVkpCVkVobjhTWmVLUWJkaTd1SW1neUNjSENHRVZEY1Jn?=
 =?utf-8?B?MGtxRERNa2NMdWxrd1pFdktVVHZ1WEZtVnVwWmFIT3B3UVNxc3dSMVNuQTUr?=
 =?utf-8?B?YUZqS2Q5VnJPcGwyQ01lNGxjZC9idC9mQ1NMVm1WU3FhcWkrdktkd0pSa1A0?=
 =?utf-8?B?RW5sbXNWaWJqV1pXWlpMUTdSYXdOWWxiWVhIejRjVCtpeGI3eWllc3RYN0lJ?=
 =?utf-8?B?SVk0QXRKdGRrUXNEZ05ydzFOVTU4OEF3cDdpcmxwWTRWZkNtZGJqQ043UXFi?=
 =?utf-8?B?VUsvWktPaXc1RUd5U3BQQXBPcEEyazVuQUtFeDFsbkcrdEFhQzN1amV1MUV4?=
 =?utf-8?B?ZlNkMEVwQ1pOREh0VzFROXBHdy8xVlVHZUM0bWRTcC9uUkVTYkVNSnA1eWdI?=
 =?utf-8?Q?Whv7SedTvm29egQ2cFr9EFfAbWvw2gpr1vXv2T+Uk0Fb?=
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
	2oVW3bXk/vOGmoZo4vLkX10FXlppeu9APWEj0Wzpy7Ju/jPr1rxY3dVqXbj3LCDKZ9yNYivle7R3b8GZfSZoIE2l/xmFx9p6LNskAf7nm+gHVgtB97ScZ4cZ6L3yyuQPLEktt9ciU7chmrGZAnS2yV16VB4InTfLSOEQNmYYKuX+2mOOMwTT9P/71q29P8vp7ttIAwm4D2mJb+N6H3Jy6uPM49Ii9AnVD7uJqXNwkxiVCze8ensB1GiLrP8iEXo5lYvwjEjFDNcBoiP70YhXy66Y35MNgYXbiqZHO0elCEmNy6UybaPMueK6vcU+/3IOq8TcwJR/y28W+moAg44/e427gVmbwawu1Ie8ZfQBXqWsDqhsII6ALHQ5+FAqVe7N3oxLnDRk3f9rDnf+48hmMnNH42ESZWbulJIDpSUutV14GqprZ276Zw8ukcEj2/Eg8pDRmkEWrHWM/HEJnUhw9CcsLVfwfO7GntjYughZfqNz9Eeuv4qDqkQVWaNXvXgtO/1iYt9rAzANUG05yOROq+NwDwR1T8isIUJlxWilUrwEn2xU6btPZoj0Rwuctkykw58+6gVLXEpo6fLA880Yw7fB7jxd+cvxH/wADM8RC+zMqC0UsCsdP+6771JlbMAs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3eca3d9-91ba-448d-1c65-08dca26e8017
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 12:31:05.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kzH3Wf5a2U8HvfPPTOpHVK2b73dPZcnnwPY7T1ePSMOz6GDRIaACqf2ZNZo/ZEJu7JyfMx3UCo5VSuXzLqmtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8839

PiANCj4gT24gRnJpLCAyMDI0LTA3LTEyIGF0IDEwOjMzICswMDAwLCBBdnJpIEFsdG1hbiB3cm90
ZToNCj4gPiA+IEBAIC04MTg4LDggKzgxODgsMTUgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3J0Y193
b3JrKHN0cnVjdA0KPiA+ID4gd29ya19zdHJ1Y3QNCj4gPiA+ICp3b3JrKQ0KPiA+ID4NCj4gPiA+
ICAgICAgICAgIGhiYSA9IGNvbnRhaW5lcl9vZih0b19kZWxheWVkX3dvcmsod29yayksIHN0cnVj
dCB1ZnNfaGJhLA0KPiA+ID4gdWZzX3J0Y191cGRhdGVfd29yayk7DQo+ID4gV2lsbCByZXR1cm5p
bmcgaGVyZSBJZiAoIXVmc2hjZF9pc191ZnNfZGV2X2FjdGl2ZShoYmEpKSB3b3Jrcz8NCj4gPiBB
bmQgcmVtb3ZlIGl0IGluIHRoZSAybmQgaWYgY2xhdXNlPw0KPiANCj4gQXZyaSwNCj4gDQo+IHdl
IG5lZWQgdG8gcmVzY2hlZHVsZSBuZXh0IHRpbWUgd29yayBpbiB0aGUgYmVsb3cgY29kZS4gIGlm
IHJldHVybiwgY2Fubm90Lg0KPiANCj4gd2hhdGVsc2UgSSBtaXNzZWQ/DQphKSBJZiAoIXVmc2hj
ZF9pc191ZnNfZGV2X2FjdGl2ZShoYmEpKSAtIHdpbGwgbm90IHNjaGVkdWxlID8NCmIpIHNjaGVk
dWxlIG9uIG5leHQgX191ZnNoY2Rfd2xfcmVzdW1lPw0KDQo+IA0KPiBraW5kIHJlZ2FyZHMsDQo+
IEJlYW4NCg==
