Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D014D435;
	Thu, 16 May 2024 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715873541; cv=fail; b=ZCL0MDaLLBQipskucNKtwp6eXsK4p37HeaGUtznNoFYklTIuZYVr4LdwxVGuJPTCvJNLgQ5VUPRGTU2L84G4T8Nh33WYxaZoYI25LJ4nFM5vj6Zw8PP3GGaolfpL+g/pK9X9P7u5JvP6zF6Sc3Yj53n6owEWbq1xLbjEVUo9ov0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715873541; c=relaxed/simple;
	bh=jXeSy4jTKIxLTuV5gbLcKEjNGlJjBUP2+xabqGx0iHA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G276nayiCjZzRyhU8Lm3mvPbSbjuSlDss498+RTWeVLv8tQsGsDAHEiCMnYSMgHE2TqVE733eFpokBfl0BTHHC8tmrRXm+5Fe+oCUAi3vfkE1IXZRBP7LLdxMKnbxhPOY7kInV3TTCw2x/rP1Bdu6iQYhVVn6hBdI57CJ01Mhm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pz+WG1rQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uSfTxPKu; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pz+WG1rQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uSfTxPKu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715873539; x=1747409539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jXeSy4jTKIxLTuV5gbLcKEjNGlJjBUP2+xabqGx0iHA=;
  b=pz+WG1rQcVZVgJsEQbG0EhObKHdbNG7Hs3K7VWX+1OpZfhoGYn/dk1nf
   uFtgaDrNkuMXrqsrUo84sFkJue1bV0vcyZKwocwZ9j/ws7TuADOKXIqNi
   nE7uds+kFK/SP3ECNYR9qZhFF44/N8iUq35U4EnvIlWeXwOLlY7xP8lVC
   rIIc542dCHXnq5v4I6hdD65rixGeY9yC1qufmt6j9ccfLk9fPd/kFZu3M
   28XAnrnIyDfB72KLpklKOkAiqYNjmhP1hLLSCzHBg+6EMl74vX7bAZD2J
   gBRTSI51U0D5Fv8nONpPIlDh4bJe4e+MLNaGkDmAGnIJqX2CYYWiXelAd
   A==;
X-CSE-ConnectionGUID: K9jXtQ8vReCK3R2s786+pA==
X-CSE-MsgGUID: XdFrJp0iSo+PU+9lijX2sA==
X-IronPort-AV: E=Sophos;i="6.08,164,1712592000"; 
   d="scan'208";a="16741464"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 23:31:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYkzTadEJ4P72WqE4b1pEI7KEgKxrFmWUjjf0vAkatolepjfuufVeJ6cvAHr7n0y/gMIqOJErOlWqpqJ4NjnCLrw3sv6341/4Z5fmiXydIJJh152CQ0DblzHU/CThAQy10kh/zTYG1UTUu7DiVF0w94GNMZHRP21wJhiRnQ86GxKoCmwf4H6qfEYcd4PxCRs6Pe3L7QWqy4THOk/dfoMJ6vnGFWzbkrY6nP6WwPW0biWe+cgoi1UA5f1YUcBj7jLZrxqKGJq8eQMM0kqlgdDpbfdizOLWdwmuENbFnvZVqcpmdFIrKjq9wv8NGysVh8EO4NSdYvSibDEetcBQLaOkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXeSy4jTKIxLTuV5gbLcKEjNGlJjBUP2+xabqGx0iHA=;
 b=OwXqfQkGAP3SI/15FVE/xg8l2lwnDLkIKoFItd0R0L9NhacS3ug5XH87RQrIBxGTqOI0/Y8CH8fJhPN2b2ru/Dt4hURoLA7kWkqZ3PSQ7bvl06zkDJcSbvOBiJFFM+j9X3at+wCePhjVRb3qL4gatIThqLITGOrf/LyeRG4mmaMVSFKDknrmmdIHODULQwXlWK73qzwUPWgNsjd4aTTDQeRuq7/t7QmaaYkBG6CBP6V+hI+T9enR2nOiSrd/5ZJmDcEo052FIxfsMzc3lLkn9z8CyyUvsadGKjB/8Z4m92rMc78Xbv21Yfggid51xg6/r+j+L7Kihz3h8+m/rZgXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXeSy4jTKIxLTuV5gbLcKEjNGlJjBUP2+xabqGx0iHA=;
 b=uSfTxPKuD2fIvM8KVh9JCMnyC7Tfp4AbPKiqrSiM72l98uaKDsoYW5nW9q3kNTs6JbrFBZbPeleXQS6pI8lMcH73PGgZ1WsULrpB/cZKA19inxDRrp011GRmIlTxUnne7uv4YBlHtNFANx+0uTk1Gjx7r9tRj4wnRzto8B/v+Mk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7489.namprd04.prod.outlook.com (2603:10b6:303:a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.30; Thu, 16 May 2024 15:31:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 15:31:01 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
Thread-Topic: [PATCH v4 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
Thread-Index: AQHap1UqCn30QJuzdkSR4jUZe60dILGZ6NSAgAAUfIA=
Date: Thu, 16 May 2024 15:31:01 +0000
Message-ID:
 <DM6PR04MB6575E8AF1B1B0ECAF6F169F6FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-4-avri.altman@wdc.com>
 <054739a5-f38c-4756-b248-94dfb6bad916@acm.org>
In-Reply-To: <054739a5-f38c-4756-b248-94dfb6bad916@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7489:EE_
x-ms-office365-filtering-correlation-id: 23a30bc4-dd60-4c7a-4b79-08dc75bd310e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?Um5UU0VQME9meFRKU0Zhd2IzMFZlNDRZUWE4K2ZqYmEvdHUraHdSbFg2K3Nr?=
 =?utf-8?B?U1N4bUJETWZIbzllSzdMWDZRa1VYdkJmQm5GcU5ZU1NlNDZFV1VwNW42TTUv?=
 =?utf-8?B?aXp3emJ4ckcrdVdpVUZLZXV4UDRSUXg0bnRHR3FrbzhVTlNKWGZSZjJhYUU5?=
 =?utf-8?B?SE1GVlkvUlY3N1hUOTJpaHJBVm1OR2JOTUpjRGdKb0lkYXRhbnlpeGFDRTRW?=
 =?utf-8?B?Z1o4cUIzMFVXK00vWnBYd25tUnRjeGc5ZXFxYkJtVnBNb1lIK0NDWFlxOFYv?=
 =?utf-8?B?Q0FtK1AzdVhiU0E3VWIwQjlQWjE4RUFvTjRWbnVWQytXWXE1eE1jUldsQ2o5?=
 =?utf-8?B?cmNoblZkV3BDaFZ0ZHFEdWNCVzNrNGw3M29UU29GbFdodGNXdlFmOWw0WE0x?=
 =?utf-8?B?RUlVYjFpUVd3WFdLK3JPbkNnUWFjK0pGNTFrOHhoWGRMVmdVbHc2ZGFtY2pr?=
 =?utf-8?B?T1B6SzdTYUdtcFpUdGNoUjJ2VHNoaEZpZkdwVUJnZzJzZjN1eTE5MXd5RTla?=
 =?utf-8?B?WjR4bHNndWZjcHliZU5FWWdEQk5WZkVxZjBidmtNeHNMVGRmazM5VEhUWnpu?=
 =?utf-8?B?MlQ3dlhkSWdUeEg2dHh2TWMxa1Z5VXpjV3V4VVdLNkFMRHIzY2U1Q3NuZEVV?=
 =?utf-8?B?SmZhOFZGZkExQVFKYkRvckhqSlYrOWJkSlFLZ0JIOHk1aXVjMDQ0dDZKYXNy?=
 =?utf-8?B?a0JXTDlCY0k2UGdXUGJEa2p0em14a2t1WCs3L2g5eEpiVzhjSXRiZGd4N3FB?=
 =?utf-8?B?Z0F4am5ydFNpbnJRdHl4U0x3NjlTWHd3TnIrNmQ4bVR1L1Qvbithb3BKdFVp?=
 =?utf-8?B?cHhWdG96T2ljYS81ZTVrWXBsc2NJYmJ6elZmR2hndXZFWG50bmowRW5QdUJF?=
 =?utf-8?B?SVg3SE9hMFhOcEszcTIrcVV6bGc4cTk0OUpwbURiV0RtbUxRcWovTkxtREpi?=
 =?utf-8?B?S0FwQ0dPOVFSRnVCSG1jRFdFZjJmQ0JUYWpHYXNESHdKY0NiR1d5aFc4SkY3?=
 =?utf-8?B?SWowb043TS9WQjZZTkRMc1QwSVUyUlo2MVNNakNQeFl0bGhMTzB3bUpoYTUv?=
 =?utf-8?B?VS9haWNPRjdaYkd3eGxYYmNXaEZlbUJOcnF0dzFoYUZoc2IvcWpxNVdlYnFP?=
 =?utf-8?B?alRqaVQ1ajFKMGlDbjh3cG04cWh4alhiNWhvc0xUamVQNGJhTFR3VjI2eTJu?=
 =?utf-8?B?eDJ1NHlVdWtkbnBBdDdFRzFYS2VrUVA5bDQ0VUNYWFQrZVdkQUhsc2JScFBv?=
 =?utf-8?B?cnNSS2VtYjdHemFoNjlFT0ZydVFzSmppaVBRWlBROEgwZHhHSEZ4T3ZlVHlV?=
 =?utf-8?B?QVMyenNMcnVqUm5tUDlMbEZuRWhKMzkrSTRzNnF3QU5idkZBeTJVMHlldVdT?=
 =?utf-8?B?dTNoMlJmb2NCNHFqak11dW0zVUVLNHdiRUZHOEFLOG1YUm8rbDc4RmZNcHBs?=
 =?utf-8?B?cEpZS1FqWjZiOFErRXBuOUFyczJrUURYbHV4N3NScHdIeGtQN2hWZDRRRUM4?=
 =?utf-8?B?UE9aemtYYzNrWFJDZE1ETGNKc0V0cHJQYm9wamk1WGR1aDY5RHFQOVNUb09i?=
 =?utf-8?B?NU1aOTdDVTVPam05RlZ4SXFsRW1PaWZVME9waWJQaTBRU0s2aWI4cXpGTVhT?=
 =?utf-8?B?TGgxTG9XNmxJaXorcGNHN3FNKzNxOWU4UEozMmM4aUFabDdOUllMNlpsL0w3?=
 =?utf-8?B?d3dkUEVSSEdhbzVIVWFuVEZGZG1aWlA3eFNRVmp1Qm9odmEzOUx0Q2I4QmNk?=
 =?utf-8?B?YjlidVVUSVFYOFF2TDgxbTlDeHdIWkFNVnhCWFdqOWJiR1EyekszSGhJUUxW?=
 =?utf-8?B?NVU4WiswTUJlL2prbVBVQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGo0NEk4aUlBQUFYMnJhbkE1U0NxMzB1QmdGdTNhcVlrZWF1S0NuNTR2bHlN?=
 =?utf-8?B?RDlWRVpsVkpFK25wV2VRc21OZ01QQUJ6dmxhVjZOd2xHTXVYRlhHM2RmT0xl?=
 =?utf-8?B?VmUxSlRuWEhBUVAxa3FRUFBmMjBUbVIrSWtZc1VCelFkN0hxTWlzanIzR08y?=
 =?utf-8?B?QUxvY0JsUmpkYnoxTUt6MGlhVG5HbkRyVE5pQnZ5K2RvUWo0Y1ozRWFRRVNv?=
 =?utf-8?B?Q2ZENlJLTHJlZjNhMFlweWFxWkNnLzEwUTdZK2pud05SU29wRzB2Tm1iRG14?=
 =?utf-8?B?UFFvT3NhZVY3TUE3aVVhWldVR2syNGRBNjFIQWhPM0Y4SVF2U05BOUJ6THlj?=
 =?utf-8?B?MDJ5clNnUGxVTEt1VDBnL1V6L2kycmdFejFZN1N5MDVaRFhpRVVWMWZFMlVE?=
 =?utf-8?B?SzZhL2pmSU41NFZ1Z2FxNDR2bWlqSXl6L3F0b1ZPZnRZWEQrV042U2h3M2E2?=
 =?utf-8?B?dUZDbUJlKzU1YWw2WXlENlE3dm5hSTY3aXp3U3FaWWRqQTFMRzJpWi84VEZD?=
 =?utf-8?B?eW5pSWxGdFJNYnBSeEVJcWlEazJNVjJ6ZFkwYUsxTnpVdWVwVDBkbjFaN25S?=
 =?utf-8?B?VUZRTGRNMW41dEZ1N0k3NFcraElDL202azdIZ3ViTGN5UHZGdHJ4aUFiSjhr?=
 =?utf-8?B?ZkVzTTNjU2p0aCtKWGx4eXgwV2ZWakF6MUM0dkJzNTN0cHErNSs1dkFUcTFm?=
 =?utf-8?B?dGh2bk9ENXNGWUdWdmc0SW5wYTJDQ2tXOTNSemM4c29GeS9KOVQwMmMrN2l5?=
 =?utf-8?B?YVB0Wk0vZXM5STRPdDBUMDkxU2FqOGFBMXpCM3l4Vi9YeUVzdExJVHdSUFo3?=
 =?utf-8?B?YVNORkd1TEZKWWpkQjYvMUp6MHgyQjhXdFZOcjdQbW93MmZIZnBpcGRoNmdE?=
 =?utf-8?B?TndYTWEvU3pqL1NXeU4xc3BXZE4vd2NoYmdkQzBoZUJWL2x3TjFLVkJvRXdH?=
 =?utf-8?B?UXJnK1UzWkV3YjUvNzRzV3VQMzRMTlhzZXB1cjVJSHQzbmZscG82cU1ET0tl?=
 =?utf-8?B?VldybTdzdG9BWmpXZnBSN0FvcFVreVIvRXJyQXU3MGxkSFlSUGpqRFlTbXNi?=
 =?utf-8?B?SThMWUN6a042Y0tXbG44MjB0V3I0R1pRTzN6S2QrNFFRWmMvcEg3K3JpOEhL?=
 =?utf-8?B?WHQvK2RpSnVGZVFWeVY2N3E1VnViZTNKeHlIN05RUjFVdEZjSU56UGo1eVNR?=
 =?utf-8?B?R2p0UG9vS2wzelNvRzdQdmtpeUx0ckNVa2VKQkFBREszRHBMbmtlQXdtbEw3?=
 =?utf-8?B?WFlYdVlxbzlYUjhsY2cyL0NvSEpnLzYreUl6WHNIMURrQnpMRlZoTnllL2FI?=
 =?utf-8?B?UGR4N2xlWnY2d1g5NjY0ZFUvb2RQM2FxTnlmb05uN0QzeHM2TE9RZjJpT21T?=
 =?utf-8?B?QmJidzVQL054VnhGc2FjaS9DalVXZDh4WGN6ekQwVUVJTUIxdzFncEZTL2hG?=
 =?utf-8?B?NVVDZHp2Z0tmVDlUUDNWaVdWaFFJTjBQZGZYaStOckVCYVdBNWtOTlRWSVo4?=
 =?utf-8?B?MHhGeTZZak95QlRVcEh2cncrTktwVjZKZHhUNVZLU1dLdE9kYmduUlJXL1kw?=
 =?utf-8?B?a0dOSHhnVTI4dEUrMHZJamY1bGpWUG4rTDRXSi96Sis4UEJ4b0JDTE1mbDhZ?=
 =?utf-8?B?Z0FwSUF4ejQzT3BZNFFyaVprSkNnS3NHem5NdjNCdUxGS2dQNDZxL0V2ZC9E?=
 =?utf-8?B?UkRWV1NzbUNBSjZPcnZZd0t1U0xwcDNEbDB1NFRxcnFFZjJyUk1KU3RFcmpE?=
 =?utf-8?B?UVpLWGRPc3krSnpKdkxTOGRManlUSTB0MFBWa2liZkNXSmZWQm1aSjB6ZHBU?=
 =?utf-8?B?TWJHK1IyN0h4WjNuODZUaGxST2RkOTQxUmpObllPbDlFM1IxeFhyRXBDMzhX?=
 =?utf-8?B?Z251d25TMW5aOFhmY014YTUzVHZDbXo0cFNxamtXanpDcWJrK1BhRmthYmk3?=
 =?utf-8?B?ajV3eUdsVnNGUEpMRnJ2R25zYUdRMm1ZaVBTaVdlUEJjNjdORzJYdHBRYXE2?=
 =?utf-8?B?WWU3QThjS3V3c3U1NlVtbnJiMXNXcy9QTm9mSGxZSFBSYUp2bXhIQ2FFU2dZ?=
 =?utf-8?B?dHhySFArLzd4NFNzYTM0YVlqQ2N0dWNyNjJpODR5QlFMOGpxcGZUQXp5Mmdq?=
 =?utf-8?Q?ko7s=3D?=
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
	C4CdGVY7P1I1Tp6pUCW1vXsylcpWiD//o+QZg83yxxslufPPcDD7qAvdrcpmV8i5pZRqCygJbchh3PylCbFAv5sZVtMtQoollHE06+FDGkCAgrZ5k5NbkkrvuhI1lwdBTi0O6O4IlurVa+uT9BnjHW8fN6HF6ojVJSf3ms7kMom2/ZAbDKmn295MDofyZjY58DL+tUxtCwHwItBAen9Hv85x2l+Szvce4F6gwCYYfKjbgs3vT2wF0uFXlNFCD9TRo4Z/ng6saHlgsCdaqwMVoQO6x3Z7PR0Z6EBF6OObv2P8pMBERoG4yGJPqZz6AF0F329B6EhMgdrok+CpUSwAV8z4I+RMFwlDz1uWrnlgdxlv3KpgmOstiWoHauzm2ISIZYO6Y9g/STbp8Rr1wK8AXyKuN8l7jcqmiZAwJMWJ3UhPkgUNqeVUd8R+H1fCvkTshf8rCD3qXxHVp5B4DbHdihS7i+vXz8XGsynLD3XFvJB4w5nnb1kdr34nm2vL0MoGwpbgtB9XNXg09L9i58IhyFsIQs92DAm9AQWAysCWHcLgT1/7U+sngusOmaijyCy+kKhyB+neCwb/P9u41zOZN6T1c9XiISHAZvDv/1hKvyzY5xnWjQ55okvGu7ZodBg6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a30bc4-dd60-4c7a-4b79-08dc75bd310e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 15:31:01.1525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cecn03rwRd/ultdlFJsAkffJLwpIo54PU1uBDbid1zsvlqqc/XE/WliIo7TotaQWpIhFKylHRChvb2LwJuhGFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7489

PiBPbiA1LzE1LzI0IDIzOjUxLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArc3RhdGljIHNzaXpl
X3QgbWF4X251bWJlcl9vZl9ydHRfc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LA0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0
dHIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICpi
dWYsIHNpemVfdCBjb3VudCkNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCB1ZnNfaGJhICpoYmEg
PSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPiArICAgICB1bnNpZ25lZCBpbnQgcnR0Ow0KPiA+
ICsgICAgIGludCByZXQ7DQo+ID4gKw0KPiA+ICsgICAgIGlmIChrc3RydG91aW50KGJ1ZiwgMCwg
JnJ0dCkpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKyAg
ICAgZG93bigmaGJhLT5ob3N0X3NlbSk7DQo+ID4gKyAgICAgaWYgKCF1ZnNoY2RfaXNfdXNlcl9h
Y2Nlc3NfYWxsb3dlZChoYmEpKSB7DQo+ID4gKyAgICAgICAgICAgICByZXQgPSAtRUJVU1k7DQo+
ID4gKyAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAg
IHVmc2hjZF9ycG1fZ2V0X3N5bmMoaGJhKTsNCj4gPiArICAgICByZXQgPSB1ZnNoY2RfcXVlcnlf
YXR0cihoYmEsIFVQSVVfUVVFUllfT1BDT0RFX1dSSVRFX0FUVFIsDQo+ID4gKyAgICAgICAgICAg
ICBRVUVSWV9BVFRSX0lETl9NQVhfTlVNX09GX1JUVCwgMCwgMCwgJnJ0dCk7DQo+ID4gKyAgICAg
dWZzaGNkX3JwbV9wdXRfc3luYyhoYmEpOw0KPiA+ICsNCj4gPiArb3V0Og0KPiA+ICsgICAgIHVw
KCZoYmEtPmhvc3Rfc2VtKTsNCj4gPiArICAgICByZXR1cm4gcmV0IDwgMCA/IHJldCA6IGNvdW50
Ow0KPiA+ICt9DQo+IA0KPiBTaW5jZSBtb2RpZnlpbmcgUlRUIGlzIG9ubHkgYWxsb3dlZCB3aGls
ZSBubyBjb21tYW5kcyBhcmUgaW4gcHJvZ3Jlc3MsDQo+IHNob3VsZG4ndCBtYXhfbnVtYmVyX29m
X3J0dF9zdG9yZSgpIGZyZWV6ZSBhbmQgdW5mcmVlemUgYWxsIHJlcXVlc3QNCj4gcXVldWVzIG9m
IGFsbCBsb2dpY2FsIHVuaXRzPw0KRG9uZS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiBCYXJ0Lg0KDQo=
