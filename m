Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C7F53804;
	Sat, 25 May 2024 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716648922; cv=fail; b=DbUUd2VAUqQcjkieHnPae2UjebKr6YPX0nU3dHI/bnW+hYewhje1YUyGsDIVgSKT+m8pctEM5tNEEV3/OBNf9KcrRPTxp04weFtLBDHnfH9++nQi7OAuYzse7q0urLtAbtvGmxlhLh6OZVtDEwptpmB2dUzPuavKWDmeiDlfHwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716648922; c=relaxed/simple;
	bh=m3GsJacyc6x3xu1YppTc2KyMe8Q+J3UmSqJ4HwYjdUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Nl+eQP26ijh759HM4/DQcO71mCjsY1skyL7sd1C03GxsmgVxiXMbfjdpTt1vSUd/oNY45+Rpnu5vLHI8twczJpjTlduJ/hBoseZRbgmgaLqmRBMSzfooGmNHyNlTnad4Soaa8Qq8QJ7k/ufV+GzZ6j3SRA9qNrum0NXaYLVhI1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iEFMslA1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yXpxrBt9; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iEFMslA1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yXpxrBt9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716648920; x=1748184920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m3GsJacyc6x3xu1YppTc2KyMe8Q+J3UmSqJ4HwYjdUQ=;
  b=iEFMslA1hPggD1PqhkTu8+i/TJ9DxqxRIaLElDfnoP6VdyjfJj9JUJKU
   sfyduOmSX1VGdwT533df/MBRHbBfujb8b9Tb3oXd9NK6tFuLRV9ZDgleN
   M0GsdVT8yhctKujUpuS2dlJhgwrrhJEeDZZcpXGpahiyBiFa5KsCuZwMX
   WUDHffqcmL8mtM5AnSdNdQZDeHAsA5SI3TlcViSF+YNlmSoS6roD3Qtbx
   1V2sVITH2RFGwh6c8oh7xdGSiKsZr6gNFx+Wt6lAE/UT6at3IktONqIsH
   9lMyxQAWGxMxFbU5reYkb+uKd3fZVjOormMkB+9QHZ7cc33O1uIOS1wrf
   A==;
X-CSE-ConnectionGUID: uVoeZpVuSs27Q9xceNijcA==
X-CSE-MsgGUID: YivAV5w1Tm2H+bH4tSXRIg==
X-IronPort-AV: E=Sophos;i="6.08,188,1712592000"; 
   d="scan'208";a="17516968"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2024 22:55:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTT6/0TpT383hbhiIyBpbnSaL6m1NhfZG7eCuKSlUKDFeKoVbnnWO+643sZxvjGAvy6WSJ5I61kpIVpAB9DWC2tgXCt8XWvqAog6/lph3by6mRrz1PwbnVXok/+MJdb1y8nMkTYhCZvoxgNvbhbKbjMaidk4sar8G0gseNSJPmox/LksnSPD+doFnv85xdbkuepi/cbljugDo3KJ2OMwLX1DA/LWr0PxQDlFpf+nDG4GCQL9b+GKaMM/mHATaQ9n2zQC60iysz01xLljsveEdMRARxPbODmvEop52UP0V+Z+18QoI9G/RG2/x0nQ1+T38fHNw5m+jny2E1cA5i2RAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3GsJacyc6x3xu1YppTc2KyMe8Q+J3UmSqJ4HwYjdUQ=;
 b=PlWSoA+k2o4TFipOsoNERNdIpiPtizMQ88EfcHinXoGMYzqZC1sYHMftd5wYU5cphMeG8SjKZEG6iA68ylpeo3eIhByAAs7rZATSiMuPkiHbVCZ4Bg0pXVh2vJ8bS+qazQXZYZn+SCn6fypdTejLE+SY7oXIdkLk+DE1+xInY/+U0C7pVyYpT4z6yka1CW+1DGSONqnOa0iktJr9A0W47R7d6JxO5JqGPv8Qf7x+pScNyT95s0twQugkIeJLoTy1sHqUPEfyjSMS5NB+Rr0qYejfk+t/HxjO3T87lt/y2EobfecQPkHlPHxz2JdykYdKkVmgHVH1+TyBzfm24WY86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3GsJacyc6x3xu1YppTc2KyMe8Q+J3UmSqJ4HwYjdUQ=;
 b=yXpxrBt9SgqsbddyMxn4LNk5eonVPR+jTjCBbdRTf0Z6EGEq1nCTZPDdHnO7RDEpWz0N/uMKQM0DdpsUaBaBFkf/MftPDi4Jb2yjYfqwRnBcjhpPF7sWnfIVigg3LBeY3tSvwHPY/nko39xlNcBnvhSftYphanbc2ZQcdErx46U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7552.namprd04.prod.outlook.com (2603:10b6:a03:329::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Sat, 25 May
 2024 14:55:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%5]) with mapi id 15.20.7611.025; Sat, 25 May 2024
 14:55:15 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"hch@infradead.org" <hch@infradead.org>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: RE: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Topic: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Index:
 AQHarRD6GlDrvRC83UqcB9DEZGGuErGkySWAgAABXpCAAADxgIABG4qAgACDN4CAAaIOYA==
Date: Sat, 25 May 2024 14:55:15 +0000
Message-ID:
 <DM6PR04MB6575DC9901DA305161AD21DEFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-3-avri.altman@wdc.com> <Zk8-rwjFvgP714Mn@infradead.org>
 <DM6PR04MB65758584960580363D43AED4FCF42@DM6PR04MB6575.namprd04.prod.outlook.com>
 <Zk9Anwk1HEjUzSxc@infradead.org>
 <0a57d6bab739d6a10584f2baba115d00dfc9c94c.camel@mediatek.com>
 <7d719385-beee-4780-ac6b-8c5cace90b1e@acm.org>
In-Reply-To: <7d719385-beee-4780-ac6b-8c5cace90b1e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7552:EE_
x-ms-office365-filtering-correlation-id: 750f487c-206a-4bc7-70c3-08dc7ccab005
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?M29lSmFxQS8yTjk5WU5yOTI0dnRBaWVZbEFuTjg3bEVnbWM3MnY5MmppMlE5?=
 =?utf-8?B?c200UmRpM3NCT1d1WUVWMGV2eFVTU0lQb1RwQXN1UEllYmo3SDRiV01kS3Fn?=
 =?utf-8?B?SjhEbTMyNExUVGpjYmhTaC82cnV6UGg4VGNHNTFhMzFBd1VaTUtRT2RMMWxM?=
 =?utf-8?B?dDVsUU01UHRRVDYveEl4QUZ4Zk1MaFdpN2xsbmFxS3RXZm5zZ3NZZWRTcFZ6?=
 =?utf-8?B?OVdEdW9BN3NWL29YSkxVMC9yVTVpc01VY2FYS3lmeUJ3OUVUemV2RkRqWXR2?=
 =?utf-8?B?QjNOS0JHODVoZHRTaWFjbnVSNWhteXI1aCs4TTlYMDFRU3J1U2VVSHlaamxz?=
 =?utf-8?B?WGZURmRNd0VrSjNLeFNPWWtFV3IyNldlNE0rQTRBenpwdUR1Q2F6WkNPakM1?=
 =?utf-8?B?VURZR0xqd1hkVHl4U3U2Z2twdG81ajIxTVFPVHEybG5ManN5MkszK0lpeU5r?=
 =?utf-8?B?dWk2SHUrWDM3eHpWWnUwT1l0djRLVm55ZWMyVXNrZXJGeW9qY2VWVkhTOHBm?=
 =?utf-8?B?VVNvM0c4bEtBV3dZeFhzY0RhdGE4d0VHNHEyUXFUL0ZmRUVYQmhwVlJhcVov?=
 =?utf-8?B?MjlFa2toOE1Ucm9KSERFZjJCUFBmMGV0T3lSbFpNUmFyc2hBRUM5OGlOcWdQ?=
 =?utf-8?B?WEdkQmRUNDc2R2xVRGV4ZUlabzdaZ3p1aXBpNWdUSE8vNWRJYW41UzAxTS9t?=
 =?utf-8?B?aUQyRHBleSs3aUlqckJDdWxyWW5LcXJ6SjBBOEYwSjRZQS9CWDJka3RlM3lt?=
 =?utf-8?B?TjFza2F1VHZtVHNNSWNNaGkrQlZGL1F6OUNCRWs0aElzK0tUN2FrdHl1WjVD?=
 =?utf-8?B?dVk2aFFTazc0a3ZpOUR6RlVoSWtlRWlHWStTSlRtVVR0MjJqeWZ3QXplUkJs?=
 =?utf-8?B?MEVUT2VSclBGRjNOanoyOFM1NWVGdmVTdUVJeWI3cndNSE5RZGZNdGJ1d1Vr?=
 =?utf-8?B?OU1Nd04vS0FUNXkxdy9FdUF0UXZtUUFYVWlwK2t4eEVRTVZsZWMySTBFOXEy?=
 =?utf-8?B?c05sck5DcXZhYlBWT2xnc3ZoSzhUY20xaDlmVmllNlNJWGlaR05BSkI4QVVy?=
 =?utf-8?B?SGZCbm1HTTUwZVh2MitYeGp6L3pDMUdKRUY0OXRYZHh2SjdGZjNwWEY3SEV5?=
 =?utf-8?B?dFpKYVJpR1gzUlQ4OURBcG5ZL1hzYlM1U3FxdEVBdVg5TFo5T0k0L3ZBQ0FR?=
 =?utf-8?B?MXpSOWd3TGNkR1oyT1QrS3NUc0lPWkhxS3E4dlVTTDRXd1p4MndqNFNDckRB?=
 =?utf-8?B?dkNWaHIyNnZDbnFVMlc4ckozajFHN3RsSzIwTEFwVkxTRXpZUytNaUowVnVL?=
 =?utf-8?B?c1lxd3c3T1lPUjR5WEJVeGNwdExtbThVbHkwOXM3MGdoL3BjdFhmTkF5OXlz?=
 =?utf-8?B?T2QxOFVsbW1YWnQxc2VLWWN6OTMzUzRpRTErZUFlNEVYM3J4aFNIV2VRL1hM?=
 =?utf-8?B?QVVWSHRRbGcxQnVPLzNEbEg0UkJnMmMwODdoQzQwdy9NdGRsejMvL1BLcWlM?=
 =?utf-8?B?YnZHcHZFWGlVa0lFSEhRTVVTZFlxYkYyQ2N4RFhjMnM5a0VidlltYVZiK0JE?=
 =?utf-8?B?RFYrclE1WG1DdExSYm1XVjZQeHk1K25uNG5yTXNaVDcvbS8rdEtiS095NTUv?=
 =?utf-8?B?RWVSSzVwYkowR0ZIUkVralB1UWxqMkIvY2pEK2craVZDdlo1ZzhaU0d6V0hZ?=
 =?utf-8?B?U28yTHlQWXNZOE42andyMGVueld2NGZWYzZTK2d3ODVYbmZwTCtMYXl2dUR0?=
 =?utf-8?B?Y2tZYWdlWEtIQ0xWVVJNWTBBMENFZ1had0xXTnN3Zjg4MmluUFl2Ui8xY2J3?=
 =?utf-8?B?UEswSjl5YndISXZ4by9Edz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bXM4SzVXeVpSaDB4eHNxYzczdTc0T0twRmpoVWZnb1lueGl0bzJOOXgxNURO?=
 =?utf-8?B?Q0dKcjMxUExhS0J1dUZiZmREQlNqMzlMS3dqeDg4YkNSNE5NdnBDcnZqYXR6?=
 =?utf-8?B?RWN0U2pMR2ZNeVM1NjF5cHI0cWdGYW40ZmF2OEFYSWptYU0yckRGL3VUZ0oz?=
 =?utf-8?B?NFBhaU9JS1pmOXlFeXdSUVNDa3UzVUNxVDNmcmJLL1RpT2YyN1pnNEdZV0dR?=
 =?utf-8?B?S3I3Z2t0STZnZ1EvdlR2UUxyelZCQ0ZkV2QyM0oyaVlCSnBxVWwxamZ1WlNy?=
 =?utf-8?B?RlNVTHVGUlZFTEFDRWNPRDZTU0pKTjlrVjBOQm84MUJLb1ZaOWRlS1V0cEo5?=
 =?utf-8?B?VDJzZG1KbnNxbUQvQjVKUVpVYkU5MjZ3TjFGZVlrRDNzMDFJeUpUdFE1QzBu?=
 =?utf-8?B?T1lTbkFSOXFnUUtBbmpYQTJMeEpGR3Q5TlNIcXB3QTZkZXV3WjFKV2FVWUlP?=
 =?utf-8?B?MGNubFdQYi9KeDVqSzdxWW8wQXlMcDBSNHlDOHlPaGgwV2hPT2NMYUxmZ2dL?=
 =?utf-8?B?bXV1a0QrNGNTWHNhV255bEltanpRVk5uN2tKdGxJWU00eU93RXN0S3pHYlE1?=
 =?utf-8?B?bkxwaFg3MFhGVWFNTjFUQ3JmWEFRRGJDTkE4aVg2akxqd2hTcEp5NHNxV1ha?=
 =?utf-8?B?dGNRWTErUWlFMXY1SDI3UVRlcFdTTHgwL1BNNDBNSkF5WGZJSHp2Z3dNNytp?=
 =?utf-8?B?WWV6dWtOWms4QThrSm83Z2FCU3d1RE9NK0UrLytNUzBXWnlwSFBPVHZlMWU1?=
 =?utf-8?B?a0FuNFIvRStrcCtmd3FlSmE1Z3laeXNRK2pJVncvYk15dWJ2NStRS1JMREc0?=
 =?utf-8?B?L2VLTUJzUTNKSm5Dd0pxSWVBS29uOWNnd0trVTBtVEt6aHY4QWJUMWRuWm9D?=
 =?utf-8?B?cUxCUXlCNmFRcDdoOGs2RC9qblY5L05sa2g4aFpkQk50QW9pb28yUUdsZUJU?=
 =?utf-8?B?S25uYVQ1ZmIwR0JwalU0amNaSktWVzkyRHl0enhPaTVDY0lUbk1jNWY1M0pv?=
 =?utf-8?B?Z3B2dExzaUtySFZnK2JRUnFzQjNZOXhFMFV0dk8xZjB6N3RCUHJsR3hMWDRJ?=
 =?utf-8?B?eVFNZmhaM0N2Sm9sVzBKdVZzRUgreWYxcHNHWnVJekdOMUxKNzlMVjA2RE8x?=
 =?utf-8?B?VE5XMnlSMlJjMW5TN3dpM2FnUThReVBsRHExZVA1QzFDdzczbDlOSFk5Yy80?=
 =?utf-8?B?aVhIMWtxMml4bVFGZGtIM0JBSEl6LzgvYzAyTldoY0d0YkF3RkxoYml2eU1Z?=
 =?utf-8?B?cjZoN3NWK2pNU1c1VFI5KzJkazBJYWxiZlJaR0RydXB6RmJhOXorazdNQnJ2?=
 =?utf-8?B?Q3dRMXNmenpEVzBxREVzSm5OMFdnS1lTRlZMcHZnQi93VDVKRWRSSlBjOCs1?=
 =?utf-8?B?QTY2TWVaeVNHVm45dkFqWUdxT0NhaVIxUDBWd3lzbDhPY1JJcG5Zc3dYdVcx?=
 =?utf-8?B?amZ2Sy9JVFRuUnBpU2NOcnA1cC9wZklnNUJWcFNSY1BGb0V2VXd2a1pUWjRV?=
 =?utf-8?B?ZVNyYzVuNnRLaHF4RTFEYnE0MFRZVzBHck56eC9GcHp0SW9nemZWMTBFMEli?=
 =?utf-8?B?Uk1uMzdkMVY5eXdoWGxtR2EzTFc2ZkdBbEVaSUlDbXZXZEhxMUk4cURWNU5r?=
 =?utf-8?B?QzFDNmR4TVJWVnFiOGNJUGxyK1hETncvRzU2Y25mV0VFNlYwU3VVR1NzQ1hi?=
 =?utf-8?B?dnBVU1gyMU81by9BY2VXdi8yOGFCamVNZnQ4c3hYNWk5cXdaZUIweXBuQnFn?=
 =?utf-8?B?Q3lYZjhkVXArZVBIR21iSVZKaHI3ZEdKdnJucVNoa04yaXoyNHlNRWNRODAx?=
 =?utf-8?B?M2VLYXJYTnFVbkM2WXgrZ1hHcmdEUUFVMlppS25telpGZUFsZzNIcDc4bVRQ?=
 =?utf-8?B?VTk4aDVJWFlnQlN5NHp5Y2ZBTVp5SUNzS0pHb2J2RDg2WTJaejRuOHR2dTQ5?=
 =?utf-8?B?bnprN21mNW9EaHFKakZtY3ZMQnRJSmQvVnM3NERzRm5OWVhRRWx3WE5xS09s?=
 =?utf-8?B?Sm9iSXZIZmZ1U2swNEhidUx6VjNacEYzQnBHaE5lVmRFQUp6MVpQSGUydlNU?=
 =?utf-8?B?ZEU4cElwS3VNVHBGNVV3NXdNcHR3eUczM1hScjV6b3RFNlBCYlVrby9TUFhE?=
 =?utf-8?B?MkUxRTRRMS9vdER4Mms5djA1OXdVQk5UU0pYOXcxRTR4bExmZzRUNHg1RFQw?=
 =?utf-8?Q?fkOcWSFYuMw2Z6QGLSsjRKO9JD9oewnshw5zwoxNMlV1?=
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
	WgJVVmerbWFPDBAf8ckexq3k1E4sB8IBc0+e5oTwlxjOSb4ceIf/oPv1cjvUUM9O8EjRj0dZiLDp6o7gigDsJ2jGENY2yocFIkbtsvvFC97wFuvYG7JrBScjIlg6O9wMEodXuSBqpeNkcNcuoQC7eNcYRioC7hQIvOonS1TrZnq0XqEN+r1amdBtAdIyWW7tvBkahBm3Rp5ulsHAaiKCmi8HpgVZDeUmBBG6Y34tNvuqzQgTyANJMRkbwc5Ch/S96YESjzy9yrw7iFeY2FHjQE+CQwrwOMc75J3eGDhNa+4x0hxvKekoXYXNesAOb4mHFWbOeirB2z3/lQiqnWOqKaslKgx+pqCvCoKa+pKmraFIDqmDFI4ASmUX6E+gMvOmhp4MkndQzOPCthPMrn9jd6J3yfYbHAvTRbqEB1Ru/pDSkkmOMKTS3RDtqZGPh+WsO0oavcglBN4wbxaSbAsTN9toFufC2C8I+nTj8td7978KLe+kQpgafGD0De0b2JQMJeeq6ralSnUGXGBY9w7Wl2VUJJgp3dytV1uQoyfnGe7h4mAmUhis2fhzzWQAK0ei0wp5756oHJZoq8nIFlTLFgpHAbUkrXqIFAX1nBjRrrFiCpeRAlgEm5QFnHRiwDC/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 750f487c-206a-4bc7-70c3-08dc7ccab005
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2024 14:55:15.7764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JvBh2WVkJfWHFOzSUC5+wVrXyuqSD4Rb/TpgVdMKfhK2bl37nTBAhh/haLOOVaOAxFbtfTGXLkmU3GjWZHnqgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7552

PiANCj4gT24gNS8yMy8yNCAyMzowNiwgUGV0ZXIgV2FuZyAo546L5L+h5Y+LKSB3cm90ZToNCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMv
dWZzL2hvc3QvdWZzLQ0KPiA+IG1lZGlhdGVrLmMNCj4gPiBpbmRleCBjNGY5OTcxOTZjNTcuLmY4
NzI1ZjMzNzRmNyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRl
ay5jDQo+ID4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiA+IEBAIC0x
Nzc3LDYgKzE3NzcsMzIgQEAgc3RhdGljIGludCB1ZnNfbXRrX2NvbmZpZ19lc2koc3RydWN0IHVm
c19oYmENCj4gPiAqaGJhKQ0KPiA+ICAgICAgICAgIHJldHVybiB1ZnNfbXRrX2NvbmZpZ19tY3Eo
aGJhLCB0cnVlKTsNCj4gPiAgIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCB1ZnNfbXRrX3NldF9y
dHQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IHVmc19k
ZXZfaW5mbyAqZGV2X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsNCj4gPiArICAgICAgIHUzMiBydHQg
PSAwOw0KPiA+ICsgICAgICAgdTMyIGRldl9ydHQgPSAwOw0KPiA+ICsNCj4gPiArICAgICAgIC8q
IFJUVCBvdmVycmlkZSBtYWtlcyBzZW5zZSBvbmx5IGZvciBVRlMtNC4wIGFuZCBhYm92ZSAqLw0K
PiA+ICsgICAgICAgaWYgKGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPCAweDQwMCkNCj4gPiArICAg
ICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsNCj4gPiArICAgICAgIGlmICh1ZnNoY2RfcXVlcnlf
YXR0cl9yZXRyeShoYmEsIFVQSVVfUVVFUllfT1BDT0RFX1JFQURfQVRUUiwNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9BVFRSX0lETl9NQVhfTlVNX09GX1JU
VCwgMCwNCj4gPiAwLCAmZGV2X3J0dCkpIHsNCj4gPiArICAgICAgICAgICAgICAgZGV2X2Vyciho
YmEtPmRldiwgImZhaWxlZCByZWFkaW5nIGJNYXhOdW1PZlJUVFxuIik7DQo+ID4gKyAgICAgICAg
ICAgICAgIHJldHVybjsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICAvKiBvdmVy
cmlkZSBpZiBub3QgbWVkaWF0ZWsgc3VwcG9ydCAqLw0KPiA+ICsgICAgICAgaWYgKGRldl9ydHQg
PT0gTVRLX01BWF9OVU1fUlRUKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gKw0K
PiA+ICsgICAgICAgcnR0ID0gTVRLX01BWF9OVU1fUlRUOw0KPiA+ICsgICAgICAgaWYgKHVmc2hj
ZF9xdWVyeV9hdHRyX3JldHJ5KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfV1JJVEVfQVRUUiwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9BVFRSX0lETl9NQVhf
TlVNX09GX1JUVCwgMCwNCj4gPiAwLCAmcnR0KSkNCj4gPiArICAgICAgICAgICAgICAgZGV2X2Vy
cihoYmEtPmRldiwgImZhaWxlZCB3cml0aW5nIGJNYXhOdW1PZlJUVFxuIik7DQo+ID4gK30NCj4g
PiArDQo+ID4gICAvKg0KPiA+ICAgICogc3RydWN0IHVmc19oYmFfbXRrX3ZvcHMgLSBVRlMgTVRL
IHNwZWNpZmljIHZhcmlhbnQgb3BlcmF0aW9ucw0KPiA+ICAgICoNCj4gPiBAQCAtMTgwNSw2ICsx
ODMxLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+ID4gdWZz
X2hiYV9tdGtfdm9wcyA9IHsNCj4gPiAgICAgICAgICAub3BfcnVudGltZV9jb25maWcgICA9IHVm
c19tdGtfb3BfcnVudGltZV9jb25maWcsDQo+ID4gICAgICAgICAgLm1jcV9jb25maWdfcmVzb3Vy
Y2UgPSB1ZnNfbXRrX21jcV9jb25maWdfcmVzb3VyY2UsDQo+ID4gICAgICAgICAgLmNvbmZpZ19l
c2kgICAgICAgICAgPSB1ZnNfbXRrX2NvbmZpZ19lc2ksDQo+ID4gKyAgICAgICAuc2V0X3J0dCAg
ICAgICAgICAgICA9IHVmc19tdGtfc2V0X3J0dCwNCj4gPiAgIH07DQo+ID4NCj4gPiAgIC8qKg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oIGIvZHJpdmVy
cy91ZnMvaG9zdC91ZnMtDQo+ID4gbWVkaWF0ZWsuaA0KPiA+IGluZGV4IDNmZjE3ZTk1YWZhYi4u
MDVkNzZhNmJkNzcyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlh
dGVrLmgNCj4gPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oDQo+ID4gQEAg
LTE4OSw0ICsxODksNyBAQCBzdHJ1Y3QgdWZzX210a19ob3N0IHsNCj4gPiAgIC8qIE1USyBkZWxh
eSBvZiBhdXRvc3VzcGVuZDogNTAwIG1zICovDQo+ID4gICAjZGVmaW5lIE1US19SUE1fQVVUT1NV
U1BFTkRfREVMQVlfTVMgNTAwDQo+ID4NCj4gPiArLyogTVRLIFJUVCBzdXBwb3J0IG51bWJlciAq
Lw0KPiA+ICsjZGVmaW5lIE1US19NQVhfTlVNX1JUVCAyDQo+ID4gKw0KPiA+ICAgI2VuZGlmIC8q
ICFfVUZTX01FRElBVEVLX0ggKi8NCj4gDQo+IFRoZSBhYm92ZSBwYXRjaCB3b3VsZCByZXN1bHQg
aW4gZHVwbGljYXRpb24gb2YgY29kZS4gV2Ugc2hvdWxkIGF2b2lkDQo+IGNvZGUgZHVwbGljYXRp
b24gaWYgdGhhdCdzIHJlYXNvbmFibHkgcG9zc2libGUuIEluc3RlYWQgb2YgYXBwbHlpbmcgdGhl
DQo+IGFib3ZlIHBhdGNoLCBJIHByb3Bvc2UgdG8gYWRkIGEgY2FsbGJhY2sgZnVuY3Rpb24gcG9p
bnRlciBpbiBzdHJ1Y3QNCj4gdWZzX2hiYV92YXJpYW50X29wcyB0aGF0IHJldHVybnMgdGhlIG1h
eGltdW0gUlRUIHZhbHVlIHN1cHBvcnRlZCBieSB0aGUNCj4gaG9zdCBkcml2ZXIuDQpZZXMuICBU
aGF0IHdvdWxkIHNpbXBsaWZ5IHRoaW5ncy4NCldvdWxkIHJlcGxhY2UgdGhhdCB3aXRoIHRoZSBu
b3J0dCBjYXBhYmlsaXR5Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+
IEJhcnQuDQoNCg==
