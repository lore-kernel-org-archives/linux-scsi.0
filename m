Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F7EE573
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2025 07:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743145566; cv=fail; b=uGDZ7UTqwgvN1xCJiDJUsrBUYBw6DVLnZdYhYs0w5UlsRkEEju5uL374hLWN3UsmcTk2ayAaS4zWAaCVn5viy58Uu6Kuj5abKOpc+dot0vpxVXr2lHsmStHL+YAL4Aj7Ff1aspbfvCeMfVvce5RnFmOj8k289DkWzokqBb5/7eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743145566; c=relaxed/simple;
	bh=vWViiHAnaOfEP49W0EipYHPIB08m7b7fx3p3Sp7uklw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iZRSXXXpikeWciuO6rjbhelDTWeQ7KgCM4q4zkUJKaNVQ9VC3UzdEL7d1V61A+0xgr8XAHIgk1hxnUHg4/UhzOl+pQjvQOsrGkhXgQEa7nbINPgHUQ3EZEUKnagDepAwQb2AoQXgxCDaZUiQ1UBLAf6mWtC6yzItVp1Gn9HvxHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=R33Efdhe; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="R33Efdhe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743145564; x=1774681564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vWViiHAnaOfEP49W0EipYHPIB08m7b7fx3p3Sp7uklw=;
  b=R33EfdhexiMRVaQZZp4/1eGedklw+JA9JrF4VVFVLKpwPEe5L2hc6rSx
   7vf7HoLoPjpgMl2mxiDxeBOseiMf93/QX3cvBXSrRPVl2CdBkd5dqYfzc
   vlse3u8LEIKdpVMMStTUgsWuimj1w/DmeljLmjWxkS7+tIGIgjeWkNMeW
   O2PMx8LMusiAJ4JbxeYoxdpnhTujf8OFsE0cX668VlEkUrtniLWXsvEh9
   93Rt6pSlCTW3Tj/Ct/ycfP/ezotpRiMcRFIVm25JRynuA3avVkBTJPrm1
   B9ubgyUEmSXvGhfKKT/LtgGI+mVaiWQVE3oCZ0YWCxMl5cUnj4kDSLai5
   A==;
X-CSE-ConnectionGUID: 0yRV97AbQGCwzAIWucimfw==
X-CSE-MsgGUID: y7AzmMkiTGirrJHj6cOZlA==
X-IronPort-AV: E=Sophos;i="6.14,282,1736784000"; 
   d="scan'208";a="63284417"
Received: from mail-dm6nam10lp2042.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.42])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2025 15:05:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQcHDjXeH40uXbldYw+6rGsVaaBN8CvT5QLcGittfoDrQXf3P903JqnAADpks9niK/zMKVVBhQee5wbMHiD6vZaDHPj+Oo2ZDol/xopso/HyI1DOGSfV84hOLh5KUpKwN/Olz2bcUC8XhUfXyUYZFRUEGax/Xokiq5NJlwkuTTcM+vx/2bfR4x40emdE1PqhdHAjmjE8dDUkKY7Sa1JGF0+G0uZc6y4o3El0TlSd+jNB48z/9iX/vKs4KkfCivSo9EZ8Z+cUs3usCZig7+6tuzclVmgvnAjmFvTnrkHCrJK47REK81tM/CsAJVp1k0lxgWKy32O+06Cn4OiZTrPEcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWViiHAnaOfEP49W0EipYHPIB08m7b7fx3p3Sp7uklw=;
 b=U8/LU1nlXCYqG74/I4Ia3xrtR5sKmX1KqhLOQ9P0QeOef1Jf5XJyy/Hdp5NLmQVYLpWgh1DdIE7clPudS5/+zda2o/oFckgsNLecLD1gQ5E24VXPh2zFn23eFJMb2Jw/oWpn9LPjn/OVD9iCptcnYUCUF2be7Cyiv5G9uOU6wopzuy0Hf936BU7VCKRl0V00X/YiP2UkAKKf614A/qL2+slieCDbMyIrr+9tgSmiaB+HiQZ310Sq/HnrpZoBuiv3aolxpwHwQsP1CsLeUt5ySQaeZr/vHo20rAindhtOLHP7Zznb1d9R4+n3M+UPBSDdth5hFdPncramZnWRx2erTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BN0PR16MB4446.namprd16.prod.outlook.com (2603:10b6:408:155::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 07:05:56 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 07:05:55 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Selvakumar Kalimuthu (MS/ECC-CF3-XC)"
	<selvakumar.kalimuthu@in.bosch.com>, Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>,
	Manjunatha Madana <quic_c_mamanj@quicinc.com>
CC: "Antony A (MS/ECC-CF-EP2-XC)" <Antony.Ambrose@in.bosch.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Topic: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Index: AQHbnw30oEUDAgUu8ECtfHNx8Wh+hbOG4MIAgAACLgCAAT0DIA==
Date: Fri, 28 Mar 2025 07:05:55 +0000
Message-ID:
 <PH7PR16MB61962ECD8A529648422CFC82E5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
 <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
 <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
 <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To:
 <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BN0PR16MB4446:EE_
x-ms-office365-filtering-correlation-id: 671ab489-08e1-4842-0120-08dd6dc6fc42
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cUtadXJ0VnhXeFJwUWVDZTYwYlhFQVIrbmNscThmMHM1OVZ0V1R2VW1XR1la?=
 =?utf-8?B?cVQxWUdLR2kyUnVnN2tmSVZIMnpmOHJPeEs3dHNqdjFwdW4yV0w5d1BMZlhW?=
 =?utf-8?B?RW1RMFBsUDJOa2FuV083MlVzSG1BR0s1WGVab0xaUkp4RnJ5bU1vbXpud3lx?=
 =?utf-8?B?V05QR0tLZTc5NlcrUGJaVElvTGZNbnRteXI1ekZYZmc3RzliSEZ4cWRqVzdv?=
 =?utf-8?B?bnRnbjBJci9hRlRhUWJ3L2FyVzJMTDNQZS9TTFdYejRJTzd1QzQ5NlQ4Slds?=
 =?utf-8?B?bWFMU2x5aUxXZms2RWtyU2U0MkJYRVNLUGtCUkxSUnQ5U1Zvc3pGaXBXRHp2?=
 =?utf-8?B?ZmtjUHYyQWFLOWFqK1ZydzdTczdsekdRcGw3TjhnQmVkdUkxb3psWmtlWXAr?=
 =?utf-8?B?aUJnK1oyNDZjQ2pKa04yWHphZDNuQUc2R09qQVJRZ3lSaC9hTFViblNjZGoy?=
 =?utf-8?B?ZWVQdVhacFgrc1B1Y0FnT2hPcllkNzBsTG1vVzBUbUNnT3ZHeTZGeThYd00z?=
 =?utf-8?B?VndYem5IVGF6MmRUbm1TbC91aS9mNklNaGJOYkJGaklyRllXMXRXVVo1VFFn?=
 =?utf-8?B?NXA2cG9ncE4wLy9SRDk5a2hhMEJNK2MwUE5Td3VBMVhyOE5GRzBBSTQ3S0Fq?=
 =?utf-8?B?ZThSZzg0aFRRVmJVa0psZjJZa29FWml6azlyMllzTmVtc0JzL0Zxak1RaGYv?=
 =?utf-8?B?KzhRdHQ1cHlYbTJ2UksrZ1dlRFpSZ1p2MmJBclVLK1NGRnhVUDhCQWRIc2NE?=
 =?utf-8?B?eWsxSk5KcThKM2lKMk5aSURuQ1o3MExiWWFrR1AzZXNKa0Z5NjRYM3Z5cVlW?=
 =?utf-8?B?azdWdWFlUzdLWmVUQ1JMME5iTm5paGJBMnVQQ0srRkZGb1RpZVVGVjNhSndY?=
 =?utf-8?B?aWpPNmVDZmxFb01jcVRsYVFzZVVPcFgwSXR6UzEvQVpEL1J1aFlkVFh4clpt?=
 =?utf-8?B?SlN3a01aSk9xbC9Mb1gvQzFHTU16SnhnTFZ0RFloY1piNExYUGpMQkNDQ1hW?=
 =?utf-8?B?dHNyWG5jYWl6dTIzSEhINFZlRy9JNVc1RWtzWWxXUE9zNG1La1o4aTNTU21v?=
 =?utf-8?B?Q01tM0tRWEhvclhzcm4wRnNzREFYcUFOWGF1V0x2UEE0VkhiZmlKQll6SHND?=
 =?utf-8?B?ZFJhcSs2d2NYMHk2WEE5L3FCRWZwTlRENmx4bnE2TVpKSnA5dnlyY1hLOWF4?=
 =?utf-8?B?UmNwUS9uTWJ0T2p4ZnUxc3FUU3kxUkE5ZlVENHByZUhqVDMrN3pPUTJ4QjVF?=
 =?utf-8?B?L3BWV2gyTmpwMWZHdlozb2crWjRvVWdSeVRRR29UYkJHbDhMSU0zZDJmdEor?=
 =?utf-8?B?V25TZmcwOWNuWURxKzZTSkFUWG9ERER3NXJYNFoyOWdnK1RGR0J3a3RsM2w2?=
 =?utf-8?B?c2g1RnBmd0hnMXBwTE1KMXdHRW82aGdyb0c1VG54SkxTOU53VUk1cVFwVElt?=
 =?utf-8?B?aCt0bjdQenN2VTNiakwzSGdVdlpEb3F0Z1p6UFh3UndzcVRqekVleXhXSXd5?=
 =?utf-8?B?cklJNm04c3Z0Uk51a0RkRmp0eWYwOEdjZ2JFVUVWVGZBWURFcGx0Mlc1NWpF?=
 =?utf-8?B?UEVSbGJUam5CY1UrYWxEejd1VjEySUFyT3JMcHQxVTNyQ0lCVmVVc01lVnFI?=
 =?utf-8?B?bm1yYW5wQkdFYkh4cW9VcnBiUE9qM1FIQXFaTkJ6cEtXTG5MTDFVeVAvcld6?=
 =?utf-8?B?ZFdnelR5YXFWSWgzSTZxMEtlaHNuQXNLWm5rMlNnN0lMb2txd0VvbHZNNE5r?=
 =?utf-8?B?ZlM2SFNXUFYwaEJZV09YbmdPL0hMY0hVS1VQTHQ3eWR2Q09OZGM3VnVEL1g0?=
 =?utf-8?B?cVhkWFRjdGpHRGdoLzJXUE1lNUszN01ZT3k2Z2pIZHNFcUJVY1ZVQVlGTFpt?=
 =?utf-8?Q?a/EUEShYDz7Gi?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z2VPZ1habEw2TmVPMjdzR2lWOWNkTkRDM0RMTVVoVzl3czN6bFdEa1J1UjRE?=
 =?utf-8?B?ZGRxSlVRbG00NzZreFB2NlZidkF6cS9NNytvSmZKeXF5bitINWJqRllqTkZC?=
 =?utf-8?B?THF4QU0yUVNPV1UrRWs2bjdJZEoyWmRsZzFaMWRJcFRDTXcwdWlVT2RFNGVM?=
 =?utf-8?B?UXk5b01veElWdHZMaVZPVmdLM3JCdjFiSk5MUTFrT2R6UnM5Zk1WWjd4Mkpo?=
 =?utf-8?B?QVBncHU5VlEwc2NrdEUvRWZDY2I4S2hVUUpVRzhDZmtzVGZiTEFGRS94ZmlC?=
 =?utf-8?B?eTJVckFsUXlkM3VRRlpSZFc1L3FSUWwvZWZlWE5TcE5wcFY2cVNZem8ydWpH?=
 =?utf-8?B?c3piVTJieWxQWlIxUEV5QnhQSERBd0dUdktMa1V6ejc4dmQybHVtNDlVUmJS?=
 =?utf-8?B?YWVCOE1yNDZ0RDlFYnVYQ051NWpWVUIwd3p2M29wUWJsazlXQ09HbEtHZjZ4?=
 =?utf-8?B?aDN3TzhNemhiSFVhWkEwdE5wcENDbjRpRUNRSWdHRkZ1YnBtRTRMQjNuTitV?=
 =?utf-8?B?TmNTWjltYm84dnpWSW9ncTNwVUc2YmpmeTYvQ2RVY3E3UjJCZ2tzMXJ0ejVs?=
 =?utf-8?B?ZVFNZTNTOFYyMjZlSWljODBSNnBaOG1lamQrVVFkY041MlB4anY3SERXdXRk?=
 =?utf-8?B?TlZBeUNCVnJWSW9ZcHQ2WHBCVWRMVXR0bDhkUXJ1ZjArYUdkUEJrbC9ZZktl?=
 =?utf-8?B?c2NDWnhMN1lVMG1haXIyelRNTVhvdi9OMlNpNkVreTFjUERYYTlMUXRRYWxR?=
 =?utf-8?B?SzhtYjd4UW9XWDAxR1c4UmxUU3lmSmRyaWkyajNXSVRCZW1XVHM0TXhTZlF2?=
 =?utf-8?B?c1lYNllIbjBXYm1HWXdvaFVIZzhYekNMd0JiYmFodjhzNWgwM1B6eTVvZDYx?=
 =?utf-8?B?SlFQNE5YWU5xS0tFem4xckNhQTJESWZsckJYMkpnTyt6QXVKc3dYSVF1RFgy?=
 =?utf-8?B?ZExUd3BwMVdweStOMWFNT2c5cE9SakpSZDgwU0RVWERVU1FiY0h1VHNqVXpv?=
 =?utf-8?B?dE1pazBWYlJJTUdLelAxa29rQWZlamJCZjlQbUtBay9GY3RJbGM0RUN5czA3?=
 =?utf-8?B?aTV1ZW5hY0FYRnh0VGlxT0hZWXZ5TWRQOS9YQS9scXdCRXpYeFc5d0ZVZmI0?=
 =?utf-8?B?KytvSlBRNERNdXNSMndxbDlmUCtHUVZRaDdoK0xJUFBSdVRnU1N1N09hWmZl?=
 =?utf-8?B?enBzdVdSYlQ0YWF0QzhqdlVGRXErQWJZQmExUmczdHUxem8zQ3B1NUU2a1FT?=
 =?utf-8?B?dWZ1RDIzMFNieG55UUljNkFoZzlwbHhkeCt1LzdpYmNNVWxiL0JEK0Z4OVRL?=
 =?utf-8?B?N1loTEk2TkhKNnBDVFBEMDYxM0pZTmcxa0k3UHVkTDMwM3habU9XbEdtYk52?=
 =?utf-8?B?cFpBNHpESFdDUG56Ynd0eVFmdE9yM1IybkRDSUczSzFtNTFkbXdpbVZBQ1hP?=
 =?utf-8?B?NTc2dUxBZ25RS1dyZ01xSlNJS0hDZFVwb1dOZGpJckQvQlBwZ0pWYncyS1h2?=
 =?utf-8?B?SnlHQWk2Mmo1TUNPYW8yQUhtR3BqVnR1SjVrUG83NFJITGQwV2JDYnE5UDVS?=
 =?utf-8?B?WHVoSTdTNXhiNzNRV3FFelE5SDFsRWdDcDNyV2xFSk9RNkIwVzc4NDRVSmJs?=
 =?utf-8?B?WTBhT0JaMytaSzdicnQ5NnVaZkFOeXNWTWV5Nm1sZklXM2xTMGVQYTlrNmNr?=
 =?utf-8?B?SzZQVTJOV2EvVWNJL1cyOHFKWXROUDc0S3ZkN25TT0ZLalk4NHFzeDJUblBX?=
 =?utf-8?B?RTNIM1RHaUpQRGFzUTVoTEdyNFNiaE94NkNHWFc0RWxicS9KdEVuNi9NUDZP?=
 =?utf-8?B?aDk5QjZ3d0h6VUtTcWNTb1ZwSEhtcWtSNmtxQjVuTUdCTUFsZXFZUVFybUtV?=
 =?utf-8?B?Uk0xeHU4UFNVSkdQQWpEcUxiWnRXc085Yml1WTdZR2NZTVZRSzNrVzVPUVB5?=
 =?utf-8?B?ME84cTdERm43Ykk3aDJ5TEdwQ3pIdG5pY3lmM3NIUnA5WHAzUVJEVWY2WURC?=
 =?utf-8?B?NGdtbHpvek5DV0dYSk02eVhlSlF1YUF0WlJValppUjVSMVp2ZEMyM2VyNTQx?=
 =?utf-8?B?VWY3NGZYRGh3UytwQWZrRHJXYmhRdlU4cG55cCtHYmRVS0JPOGcrdG1ibEZm?=
 =?utf-8?B?SEFDbGVLWjc0d25oUzRsNlduam51TzdLMk03bWtRRTdpZ1RGbGpMZjU3dDkx?=
 =?utf-8?Q?3o1gGGda9vpeYrZv1bhl8+9MNOUltbE1JY3g7Lj9P510?=
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
	yFn8AwXRJmQo2XD60insy9zuYNKq5Jsq+9XAg1BWjMg37mVPn+/FpqbSCwisr82GNoUOO7aNKZwkumZWRXivajtFAi7D/zOdlGz3wRi2JAaRTTctXfdoDmIzoLpH1yshm2SK9B1k848MD34XFbRGCKG32IlHlXNqxNBQOZzcXbyUo1U5jyIthbVLglNpfRMtpKTB1Om/mfGdMX8T+hT3SjSADiNYXmClB6NQ0BgDzgRVaOmuze8/UUk+Uq/5SJsnKJeRvEvmp+VX4WplPa8nFkenAgKeeG54hsVikZJYltHUlUt0OYot3hlojagY+A50OdjQdZIXYxRwkFxklrzu5s5wHzp9vLpMjIfgD8eM2YnUnnOqZIEpytnsReQyTUgdhHaZDnQyyOYxc1YPNfo17KFCD+z+lLFUfP2JCWdnFDa8/dM6jIhFsNCrgqi+vZtbtCOxekIY+dIwLiqyFCvJylW2yjkWh5vBjovXYZXD0gQKxGuhGMzP9KRmYrzfcEKCTP1fJlLX47tcoUrKFQBzLdG92FJX2SpYIfiaFQJW3V+XoFrPRQbOow79viyEhz1sEynaJdMfNSZbS2MPoUqUc94e0b1A6nyLVQxoe6T9I/9fjrRkluM3cfNEaAMPVWI4BBBynDQ11Si58s/Ed3qwPg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 671ab489-08e1-4842-0120-08dd6dc6fc42
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 07:05:55.9319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rVCl24BiSLy6d5dCabmXeR4OxqJYZP3QsWCG5boX0dl9//SemKAQCsZtDMmBOK6g1nniirnA0ADYWHJ+g/fzEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR16MB4446

PiBIaSBCYXJ0LA0KPiANCj4gVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLg0KPiANCj4gVGhlIGNh
bGxlciBmb3IgdGhpcyBleHBvcnRlZCBmdW5jdGlvbiByZXNpZGVzIGluIGFuIE9FTS92ZW5kb3It
c3BlY2lmaWMNCj4gbW9kdWxlLCB3aGljaCBpcyBub3QgcGFydCBvZiB0aGUgc3RhbmRhcmQgTGlu
dXgga2VybmVsLiBUaGUgaW50ZW50IG9mIHRoaXMgcGF0Y2gNCj4gaXMgdG8gcHJvdmlkZSBhbiBp
bnRlcmZhY2UgdGhhdCBhbGxvd3MgdmVuZG9ycyB0byBzZW5kIHJhdyBVUElVIGNvbW1hbmRzDQo+
IGZyb20gdGhlaXIgZXh0ZXJuYWwgbW9kdWxlcyB0byByZXRyaWV2ZSBkZXZpY2Utc3BlY2lmaWMg
aW5mb3JtYXRpb24gb3IgZXhlY3V0ZQ0KPiBwcm9wcmlldGFyeSBjb21tYW5kcy4NClRoZSB1ZnMg
c3BlYyBkZWZpbmVzIGEgd2lkZSByYW5nZSBvZiB2ZW5kb3Igc3BlY2lmaWMgcXVlcnkgY29tbWFu
ZHM6IDB4NDAtMHg3RiwgYW5kIDB4QzAtMHhGRi4NCkZvciB0aG9zZSB5b3UgY2FuIHVzZSB0aGUg
Y3VycmVudCBjYWxsZXIsIGUuZy4gdWZzLWJzZyBtb2R1bGU/DQoNClRoYW5rcywNCkF2cmkNCg0K
PiBTaW5jZSB2ZW5kb3IgbW9kdWxlcyBjYW5ub3QgbW9kaWZ5IHRoZSBVRlMgY29yZQ0KPiBkcml2
ZXIgZGlyZWN0bHksIGV4cG9ydGluZyB1ZnNoY2RfZXhlY19yYXdfdXBpdV9jbWQgaXMgbmVjZXNz
YXJ5IHRvIGVuYWJsZQ0KPiBjb250cm9sbGVkIGFjY2VzcyB3aXRob3V0IG1vZGlmeWluZyB0aGUg
bWFpbmxpbmUga2VybmVsIGZ1cnRoZXIuDQo+IA0KPiBXb3VsZCB5b3UgcHJlZmVyIHRoYXQgd2Ug
YWxzbyBwcm92aWRlIGFuIGV4YW1wbGUgb2YgYSB2ZW5kb3IgbW9kdWxlIHVzaW5nDQo+IHRoaXMg
ZXhwb3J0LCBldmVuIHRob3VnaCBpdCB3b27igJl0IGJlIHBhcnQgb2YgdGhlIHVwc3RyZWFtIGtl
cm5lbD8gT3IgaXMgdGhlcmUgYQ0KPiBwcmVmZXJyZWQgYXBwcm9hY2ggdG8gZW5hYmxlIHZlbmRv
ci1zcGVjaWZpYyBleHRlbnNpb25zIHdpdGhvdXQgbW9kaWZ5aW5nDQo+IHRoZSBzdGFuZGFyZCBr
ZXJuZWwgVUZTIGRyaXZlcj8NCj4gDQo+IExvb2tpbmcgZm9yd2FyZCB0byB5b3VyIGd1aWRhbmNl
Lg0KPiANCj4gTWl0IGZyZXVuZGxpY2hlbiBHcsO8w59lbiAvIEJlc3QgcmVnYXJkcw0KPiANCj4g
U2VsdmFrdW1hciAgS2FsaW11dGh1DQo+IA0KPiByZXNwb25zaWJsZSBmb3IgUGxhdGZvcm0gMSBw
cm9qZWN0cyAoTVMvRUNGMS1YQykgUm9iZXJ0IEJvc2NoIEdtYkggfA0KPiBQb3N0ZmFjaCAxMCA2
MCA1MCB8IDcwMDQ5IFN0dXR0Z2FydCB8IEdFUk1BTlkgfCB3d3cuYm9zY2guY29tIEZheCArOTEN
Cj4gNDIyIDY2Ny0xMjA4IHwgU2VsdmFrdW1hci5LYWxpbXV0aHVAaW4uYm9zY2guY29tDQo+IA0K
PiBSZWdpc3RlcmVkIE9mZmljZTogU3R1dHRnYXJ0LCBSZWdpc3RyYXRpb24gQ291cnQ6IEFtdHNn
ZXJpY2h0IFN0dXR0Z2FydCwgSFJCDQo+IDE0MDAwOyBDaGFpcm1hbiBvZiB0aGUgU3VwZXJ2aXNv
cnkgQm9hcmQ6IFByb2YuIERyLiBTdGVmYW4NCj4gQXNlbmtlcnNjaGJhdW1lcjsgTWFuYWdpbmcg
RGlyZWN0b3JzOiBEci4gU3RlZmFuIEhhcnR1bmcsIERyLiBDaHJpc3RpYW4NCj4gRmlzY2hlciwg
RHIuIE1hcmt1cyBGb3JzY2huZXIsIFN0ZWZhbiBHcm9zY2gsIERyLiBNYXJrdXMgSGV5biwgRHIu
IEZyYW5rDQo+IE1leWVyLCBLYXRqYSB2b24gUmF2ZW4sIERyLiBUYW5qYSBSw7xja2VydA0KPiAN
Cj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hlIDxi
dmFuYXNzY2hlQGFjbS5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAyNywgMjAyNSA1OjI4
IFBNDQo+IFRvOiBTZWx2YWt1bWFyIEthbGltdXRodSAoTVMvRUNDLUNGMy1YQykNCj4gPHNlbHZh
a3VtYXIua2FsaW11dGh1QGluLmJvc2NoLmNvbT47IEFsaW0gQWtodGFyDQo+IDxhbGltLmFraHRh
ckBzYW1zdW5nLmNvbT47IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPjsgSmFtZXMN
Cj4gRS5KLiBCb3R0b21sZXkgPGplamJAbGludXguaWJtLmNvbT47IE1hcnRpbiBLLiBQZXRlcnNl
bg0KPiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT47DQo+IE1hbmp1bmF0aGEgTWFkYW5hIDxxdWljX2NfbWFtYW5qQHF1aWNp
bmMuY29tPg0KPiBDYzogQW50b255IEEgKE1TL0VDQy1DRi1FUDItWEMpIDxBbnRvbnkuQW1icm9z
ZUBpbi5ib3NjaC5jb20+OyBsaW51eC0NCj4gc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogUmU6IFtQQVRDSCB2MSAxLzFdIHVmczogY29yZTogRXhwb3J0IGludGVyZmFjZSBmb3Igc2Vu
ZGluZyByYXcgVVBJVQ0KPiBjb21tYW5kcw0KPiANCj4gT24gMy8yNy8yNSA3OjQ2IEFNLCBTZWx2
YWt1bWFyIEthbGltdXRodSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29y
ZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCA3OGI1N2U5
NDZjZGYuLjIyNmNjOTBjNzRiMCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vm
c2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC03MzYw
LDYgKzczNjAsNyBAQCBpbnQgdWZzaGNkX2V4ZWNfcmF3X3VwaXVfY21kKHN0cnVjdCB1ZnNfaGJh
DQo+ID4gKmhiYSwNCj4gPg0KPiA+ICAgCXJldHVybiBlcnI7DQo+ID4gICB9DQo+ID4gK0VYUE9S
VF9TWU1CT0xfR1BMKHVmc2hjZF9leGVjX3Jhd191cGl1X2NtZCk7DQo+IA0KPiBBcyBJIGFscmVh
ZHkgbWVudGlvbmVkIG9mZi1saXN0LCBwbGVhc2UgZG8gbm90IGV4cG9ydCBmdW5jdGlvbnMgd2l0
aG91dCBhZGRpbmcNCj4gYSBjYWxsZXIgdGhhdCBuZWVkcyB0aGUgZXhwb3J0Lg0KPiANCj4gVGhh
bmtzLA0KPiANCj4gQmFydC4NCg==
