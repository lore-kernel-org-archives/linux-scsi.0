Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1DE4A2630;
	Mon,  7 Sep 2026 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790381; cv=fail; b=ixQLLqo/hPno6HhKY9ab0rn8+gsPrC0i8EWy7bjpXzL101E90pldLvGruY+KzKWYnkvhfSjpAGjkCJcoNTettMDZPK+xspiFklFd04gF+RzUM/OXyKeZdHpQ/qOpSx8H6fLEu+FIgAirzU+NGpXu+7JzOZYvVcN2r0Ejr4gDgJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790381; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IYPKPScf3YR5H6fQCq5hTDCpOimU+TUre7qmY20RyPSMz8KDMTEnuhOaY5KJVtMerRIYTLOgglOUSWuCNDdc66Bavt0iQmT8AWUPWOZ6QDh5r2637halntaxIVzCi/GABqmg0PVYYFT7W5pRWz2qmpB8jrrZiD3+etDFuH2Cg9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kVEB0Kw3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ftx6KbfM; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kVEB0Kw3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ftx6KbfM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788790378; x=1820326378;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=kVEB0Kw3wutSdElPW9Bq6sUMvCGXCA75LK2YbHwq7n3raEpfxz46+UzF
   lQq79wZaCb5JBtcYiRR2r2WLYF7ZALT6/F/C6rdIGID+BHq6Xfzkomf10
   yWzRV8TwXKV7q8qESvyd0rH/U8h9U+Z5UT+bzIqQu/ogiZD2f0Laa73L7
   QnmQVFmbgMRkf0JVl+rxzv3bIMG/BXnB5OzyBRHqPPLP8IIy7w/0e/Rac
   Q1pvFr17Hd+bGf0eTrDhXwlHdjXBj94MfNV66Cg63QbVdz9B7E0QjoM9F
   pJIPkYDpBcVFoDpWoNPphvVMRHWjSPZ0OoaJM0vmncM/4yL3TGqbbcWOH
   w==;
X-CSE-ConnectionGUID: psD7L9/8Sfij9rl6NPoz/w==
X-CSE-MsgGUID: m0nHXBtnS+SEPa3kQ/NSVQ==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="153544907"
Received: from mail-westcentralusazon11010069.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.69])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:11:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ex+wazxkzt3mHBwmARNv9JEYejN9xj0QfbnCfLEa7r4gpMI4NwbtvMMLkZ6No+8AvxuGa/HB49FOqd2Tskr5RmZzlGB7O4FyJnonov0qaXtcSozn1U5rkVRgXuh75akZulax7OPvBFbC6Y5z/PVpKb0If9taYIbWeep0QIYx6yVyOJZ7kOV85mlD+MAHPowAN3TSQMbGn/xsUtvCKhlkPWDq1pci1lHe/3wPCYb8KkEUl06Vsj64An8thjjXaw0FYMpw0ouqRUMiNAf3DOE5Nyz/2YpO4oif7Kuj2fj+GXcLI+/GTcFd8dvQB/WcyQ9Bb7JcXLW9On29J/9Xs0cokg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=IN6XdLaqzChuuPw2bbZZq/n4jbvVnuSJMyhUgfD7lyar2JRjcLK/q/NeZtuPZhbSCyoMivsd++PQwiGkIsSSJP+fSPmUP0D/388aLUFvh76JvvHGWBB5cIPgqRdU0foor3HzIYqGRN4djknvhIdrmZJElEtPKiddFltuzL5pE/iecjjYcqOuTY3/yT8Pa3wk01rRNfkmgigypFe/REK02poXPzQbCzOhkEzawIqGD+ozbsVV6CcYy4weS/GbvKtLTQNJ+j2OGRZNDZrPlXxBfeTDh3aYmY4Wu6FWO0W8FmKfbvBNjQk5klI6rSvqZcHWhj3UTCRJ/afdXwzSBKTPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=ftx6KbfM0AWgJi5bVjg+hn5Roh+xpWbXyFYgWJNZQ/ZCzxafISEvXABlN8q3aaRDRLkYNLwJADdq9UxGJz/hFTxvSVeUIsWVhBjoMhF8kDvW3hIvWZ1D9QonO0bIkkSPzHYgZi9eSYX9tC9jjlwQ/hTOhora7DO3gO1jzlLhI7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV4PPF5EC0DFE00.namprd04.prod.outlook.com (2603:10b6:40f:fc02::90d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:11:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:11:44 +0000
Message-ID: <b7584a51-91b8-494f-b0b9-6a49d74ebd6d@wdc.com>
Date: Mon, 7 Sep 2026 16:11:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/40] scsi: device_handlers: rdac: use 16-bits defined
 sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-15-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV4PPF5EC0DFE00:EE_
X-MS-Office365-Filtering-Correlation-Id: 314001b0-3bc8-4da5-e94a-08df0ce9f235
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	k1tKAj8kU7yc5NP9d8IYqEmW7OAsBYCzDg+3AUkppD507+hGksQkLMHJ5Qc4EgHYRnan+//DvW4fL+MJ3LV3J6NRXYRYBPvaQjMm2LuFbn+s6Ae+8FCBDIqnKm8mpR+tP3PcHVNf+qw7nD4zQGIV3uK8krxaFznZB8f6cABIWh36UguNeRfk1zPfHEESkO4eQCQ9RIPSFGyQ4Bl5MX9BYT4pB84rzYsdVtgx00qjDTeNeLc9HaqXKJmKkUIVmRZpgTNTu8ZmLYH6K15mLaUp3Z2DeNVcQ3dzjgw9GqTtKaSfLTEQDFUsqco6TIXngCOt345LU0gUJiEmp02AojA+2eRTauWW98oFKKaolE9qWj0M+EUJcr600vqk5S4Qoy3wf2wReHJsaRWD520xN4E15L2Ufgtf7vjXnlrsqVLnroIbk69hk0N29OrR2HKANr77HF6EIYzx2J7gF4cXm6d6AcZ/v3ODA2jJHZALh4M3LXNRmAemhcRqPP9nRrDjAyqEj+DkBHt7el5XRAt94iO0xxVgNnO5JatofzaxqLPIRB64qGE5UEXDH10a3FCBc0od9uQ0dYyCy3p9Nfj9/bqo2DuXGk65cuQM4WgDQ2pUPMu1j9gOtic5RsLDnWjzk1SdK987ZlJflz5ixZKk7O07uGtmVEfcL772cj5zHnXu+HuUDO7jrtGul8qQ6hwBkKyKaKSEtF7RSQ6QwJDJALykAA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bCs2czV4dFFCS1FPcFEzWkZud2Jyck5ZZkpyWm9OcGFYNTVkSXFPTVdoaG1T?=
 =?utf-8?B?OVFxemQ4NEJaZTdlNGJvQkRTTXkvNk1uMlIwWmtwZ0FnZmJyUU1kdjArenMw?=
 =?utf-8?B?aFo1Sm9jVWRwR1ZjOFhtQ3FxekpELy9NeHVJNXJjNVhCR01CMFk4Skxjak9z?=
 =?utf-8?B?VXRHQld5ZEFjSjM2ZVlVQ0x6R05IRERtZWI1WlQzNlMrYmxPWUlxVFBMclpt?=
 =?utf-8?B?L2lXQWlPbkNhT3pueVk0eHVMMC9zSVlrZG1uZFdacDVPQ1pGZERPb05VdVVK?=
 =?utf-8?B?QkE1eGJaNzNkRDRDUkVJUFIxK1MzSHBWZXdwdTVwL1hMeUZWM3kwN05KVy9E?=
 =?utf-8?B?bmZLeDRIZGk5aFdJS0tJOFRqbElESFM1MHdYdldMamUxb09qK3pDZ3oySmVm?=
 =?utf-8?B?czRJejdraVNuYkowOEkwY0JNdnZ0d1NnNTRaU0JnN1c4bDhNc3E5STVaS2I5?=
 =?utf-8?B?WkF2enIrVXphcHB0aFQyUlM5dGFDR0dxQ1BKTTNkQzFrN2hveTdNbWVvOFhX?=
 =?utf-8?B?U2xQZTVtY2F5Ym1nTGE5eDVDTUVleGRvRU9RQ3N6MExSaU5TL05oOUJmNXJx?=
 =?utf-8?B?Z0pNeURJUEJYQmduREVQa21YRXN6VGhERWJGT1lYeVZiUE8zNHNFUllmWkEx?=
 =?utf-8?B?d3NGV25xTHB4eXJpQWpnL2g4clJoeGlEanlCL2IvQk55dHM2KzMxa2xLZXN2?=
 =?utf-8?B?VnR3SjJvdTE4YVpzNjkvQVIrdWZ0dVFtZ1JkZ2tQWDl1Uy9PRFV4QjI1S2NS?=
 =?utf-8?B?YnZHRmgyV0VtR2crY0F4TnZhSVUxdWFkT2Fxa0Q4dXNKOEc4UnM5VXkvZGs2?=
 =?utf-8?B?WEtWNmpRZGcvd1dwNXhvbnZVdkp1SERjb2c0MUFPYmtPRUUvZ0VSN3QrKzFE?=
 =?utf-8?B?b0lvblUzcFAzRjZxcCt3R3hnQXdpQlB0Vlgxc3dzanpyYklyR2krQituN3Qr?=
 =?utf-8?B?TFA3OTZBUkFybkVQa1VMMGk5VkNDNTBvbjhocFF6VGZ3THo2b1EyOXplMEE5?=
 =?utf-8?B?dlVRYXRhOTNLUEV2M1FyZXpNZzFXazJoc2dsaGY1Zy9raFVhdGlJN3NoVk11?=
 =?utf-8?B?NHNBZlh0VnNJVElxejhBOHZJVThrK2UvMU9JNGNMK2dqc1pYTTRic0N3SGRQ?=
 =?utf-8?B?M3R0eEJFSDNrTHJJTTVnb0UvZDRRMm80K25qdVp0ZzlPS2JWaklDTzFsNFdq?=
 =?utf-8?B?YVVOSlJtVmNnUW5sM3B5Q0tvQ3MvUkMwQmZCSTgyMEdXQ29rTHVpQUZNenQv?=
 =?utf-8?B?eVdCdlZkQkw2bWJRNDdvK1ozWnRSWkl3QkhMaCtrSEoxbm5Wb3l6cTlpNENL?=
 =?utf-8?B?WWxZRHMvRmNsU2hPek1xZHJ3MThzUWVJNlVINjVhbGxSY1NnS3JYd0luRlBC?=
 =?utf-8?B?Z1pGL1RDVGIyNVBzd0RRbU5jYXVtcE8zbVhsNkVlVUkvUWtiWUNucllwampZ?=
 =?utf-8?B?ZFViUzBkaU9uZEZMSU9XeE5NbXY1d3Y0RHJOMFlXa1p1cnlqaEhHanBKcWJl?=
 =?utf-8?B?UkUzYVY3UEJZZS9kdGdMam1tMmpmTXJ2YTJ0RHNwaTROaXFqbDVOUUlORHRH?=
 =?utf-8?B?ejJVRWIvTjhEYXhKT3o5WUNqOUV3WG5PTkxzS1VhbnNQa0hjTE5MK1ZpYWUz?=
 =?utf-8?B?aHZyWk5vVUJoZmErRHhSUDFZR2x4NGxsaUZCZWF1SlVvZ2FVTmc1K0c0elpq?=
 =?utf-8?B?NE5RMkRYT2lBV3dBbi8yNFFHcjZiQWU2MTZldnpVbXRpT0xMc1ZiLzVvL2xI?=
 =?utf-8?B?R1RDWlNESXpxcXdJaUVaWjBzck9ZMC9GdmxkakFQbENFamZlQzMrekgwclh4?=
 =?utf-8?B?TVE0MDhqTHZCa2lWOERhNERaY0pLNHJsT3psUENHbjlpR2RUZWVCNitpN2w3?=
 =?utf-8?B?UDl3SFYvaG1jOU82c0VaQ0JhMHdpcE5XaHMwdksveG5lYUdFUWVTamRGTlVw?=
 =?utf-8?B?dFBoK2xIamRHUkZ0VzI2WUU5VTk4RHRZTklyNEZ0MkpSNy9idXVCNWpWZEJQ?=
 =?utf-8?B?OFk1TmNKL3FCYW1hUVBvSjU5SnhCUHBsc1RieXh6eEpxZ3NLbkppWnR2M0lD?=
 =?utf-8?B?eGl3OU93OE5IcUM3TnJ0ay9MY2tFSFBvVTBXaDhNd2hveExrU0pESTdSUzlN?=
 =?utf-8?B?SzN5UzhINFZ0N29JN0ozc0JlcFphTndEVXpEWVF2ODhXWm1PcndNVDUwbThv?=
 =?utf-8?B?WGZ1NE52c0VuVTI3eS8zMGQ5bUpIU1ZKZDhBR3BjcWd2eFdKcnZpNm4xbFFj?=
 =?utf-8?B?NS9RSGdWb2FWQkZLUXZOL2xKYlgvWG1UT3RFdi81SUUra1lwbHYrbGFlckhD?=
 =?utf-8?B?N2wxNWdxKyt6V3ovb2QwdUNRZ0ZPU3g1K0NxR09TQk1pcGtyWThmSVE4TytZ?=
 =?utf-8?Q?x1rw3QgPzkGpLc/c=3D?=
X-Exchange-RoutingPolicyChecked:
	Se1NH1aEo/HINaCj5mtsEbD+msEeLjBdXTdkYSdjsAi7RuqdpRr/2W2HAyinAeLpjG4zp3ueaWHqB4mxc3B3skzkgPQySmEUZMtKUj4nrQ6AJNLAvul5CJJxFLWesfLaIQC5s66P5fiTDCVqhYOe0sB0fyQm8nYEEPirdTAHCJ8Azn8g+Jq8xgdeTtZ0I5fgudnZndCAIr5QEFJ+VCvqW8EoBO1FiicWUnuKpb5kquBbvHu9VjT+V+X05ecGouZbIBDskf/YglDKU1NypggLW5iZi4LA5Dq1qqpr30twdOrU12UvDlGAj6VojAMC+WXF96awaX9i50H8y/vALYIwYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DBrQZ4wEtZKu3H6SHWvokkTsjOsBqbz43N2gkiXElr2FM4owqWx1mUPFDhF/FYGB7mSAxU81u6u2l/WUVVm94BcGlgJPjHE51E+Rp29TuRnMqHfr2A/0ei6mRDm139nPinUu8HbaK6rqcCg5tbunVxbMOtYcj16oaxy519paxYpCrJBrGXc9oX0GV9hA6RrKkvBBOa7E2DIJh4pcNzG1yRH/+cZhpk81nWgAeXZriVpYyiApYtjslUDqvEsujIAfdAlmDc4V602w06S1XuYW2qvb92RRctQj9HbmnMC8DLKAS7u7yZ8w5jLj6TfbIkyCBDyCxnUB2aT3HYQ010A4BEEDaYbMdf5Zqtn8mBYQqfzMM3k/WQnt4qFoShjbbo+qkuKIhT1GzEcX6Wl4Jhb3sOcRxnc5fLG81ngURi1Wm6OI2WmltQ/DSsge02zHoDB43o6Ctx6XokC1mlK26Bb+/IE2ob59gzqpYiyozQ0kCzBFczYW0+VCs3fS0OiV4KR1kp1r578mhMvyR3MDbvf75uTWeu+0apJvN05ZC9kPSVzb9Jx2qjZonIn+x9jBCPIDkaipxLIsOO8awoltq19aTQ/dXh5Dkw46ejuV3s/QrqYAiL1rtYxHDgiBDsILodOj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 314001b0-3bc8-4da5-e94a-08df0ce9f235
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:11:44.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxSc+8Q9lqwihgcVH1GwXRV5ptEun9gaxo1GMtuP86iuxIx4OX1saiH1lBBeTuxHo34DzM09X4tqRioW2LP0GZouflB8mdxiUPt/fb4bRU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PPF5EC0DFE00

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

