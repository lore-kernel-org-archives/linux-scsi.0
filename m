Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6621C18E;
	Fri, 20 Jun 2025 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750426502; cv=fail; b=jxI9K1sFWhv3NjMWmOVcUTbMqWz0ooGn22fB5p69TcQa5+F2byKfKqjoOxAP7UT7NQJ408s7ObFOPot94TDerp58NjSD+9odlArQzrin1JXgJC9kxCGKbMhmSt0qFlpuJo31sYhzuUbCY+CWDF/KOJzWQt7uSYA0wotvwnRvWg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750426502; c=relaxed/simple;
	bh=jSjp+rNUN8kbyxSobmfsub9u1M8ffNCkqCJ0uHeuB+U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L8flgCl5+p8kM70j13vtlddsZ2RlLOPw2pwrEuWRHhzD25hQIupN2SPcFJl/63sTUA7pd4mqvHXptGaTHV+gObJ/5BNeK5bvChsQPfgad/t/ir6PNupFwm5j1EacPf1oKC/7LgK8W5uwbxo51P9OIN4+g+G+qspIqn7qDvRlVjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TqrWBzh8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aOJhGgpL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TqrWBzh8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aOJhGgpL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55KDWBVl031696;
	Fri, 20 Jun 2025 13:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WoPIpYx49kIR9VF/rfP171nQJ38BiTnZkV1W2C1HQt4=; b=
	TqrWBzh8BUnQFE1UmHwGHU3AM+6mMRUay4BdtLK1HbGu2FxzW4jU3Xk4wpW2nXrp
	gt0xj/dGJO/2BSeNGBd21qGDlhiNq7nH8LkryFzd4+tIxkGZxBxH5TBXCtAoOJlG
	YOevl6IJA9SxfveoCKOhA5kJy0BCOG4WhKC4m35ydX7D7r/cdJB5ho1psm+bnt1p
	IwGyw7B7CL1Mg4JZ9WW4crPlhn6UoVFZ1k1cWmT2SLqK9ghkkqkyYRKFx3a4wGLX
	zWc2/bH2YfBdccg/CFYrH7X9RlbgNCqc6Eu+Dxs72hb/VxQGRlgUIs72wut21xGv
	I9m12KVo0qPyr5Zz9VnkTA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47b23xy6xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 13:34:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55KCmKq1021557;
	Fri, 20 Jun 2025 13:34:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yhcpk3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 13:34:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBxhLlgYQM7M93/CCOq9946P1N8ecll23kGIruEp3A4tqfoH9bWErnC5EJFx/g8ll49qWMlTuT/SBBPQiL2S3B6o1Zs/U992ln7mBSiErYL+1BxT+RWG8WSBBTbhYvuRtZ4oHvsRPl6mNVFv7OXYxqDiVMUJMu0XMmKd56ODMGNYjXkfpk2/8z+IEL/DEB8J0mIb28THZb8NM7IgWmBEnK8AZN5UvZSOkDJ5//LRCotBGjy98Oa/tSLQUFbGDP/MrXqbGwF8MpBV+7G28GgtpfwLGWoLG53kqE/qK1ajv3rrmvStZNwMCJJjEvb7EQe2882MZd4CAFo3FGO2y4VMcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoPIpYx49kIR9VF/rfP171nQJ38BiTnZkV1W2C1HQt4=;
 b=oNAMskOigfSfvB5R1fdsPsWEL0vebZQ+OfSzwDP1V0Rl2djNFPzCZ9L1abDPQVXrXS0xFtnkoTKInYHhIAlTtJcukW7LpXraAd64lToIyMbq7udZCSxIoKTPSKyeXgc+3p8lCPKiBwkShKYaKyTQzseBVWAHaAM7fVhKPDw4+4/N4lWyOBdx+SCDa0Bh+8YWw+1Bn7zC7I47+2F4BxU0kcYzRtWVVKnWUH487nWlyqAhsFYBeICPvzAKZUpZlXxjtNCWaUuAu77HbGA1ocxCT8HtqSeWxdfmdHbNuCQMPDvGJmlnt97TL+2Ovk0A5QZhDSGv8e6ysr9EglAAh2FZGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoPIpYx49kIR9VF/rfP171nQJ38BiTnZkV1W2C1HQt4=;
 b=aOJhGgpLe+RigDz1UA++5njDo7e97wL+Bp9WvoO/yClLYac3/hD5yTlmC0OxByM0/o9rxPhOOXQHwuEfsY1XLS1FZ+PPgSK2gzUakjI64NrCEV69GOL6lf2SC2aE63nxTq0TXxUNStxD9zMCicQy4U9DRmTdH97a8LYyR6LoSWY=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by BN0PR10MB4950.namprd10.prod.outlook.com (2603:10b6:408:12a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Fri, 20 Jun
 2025 13:34:49 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.8857.021; Fri, 20 Jun 2025
 13:34:49 +0000
Message-ID: <9f1486ff-2351-4002-8ee6-e2cfad354251@oracle.com>
Date: Fri, 20 Jun 2025 19:04:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: avoid stack frame size warning in qla_dfs
To: Arnd Bergmann <arnd@kernel.org>, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250620113919.3974443-1-arnd@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250620113919.3974443-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::19) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|BN0PR10MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 70b774ab-d965-4377-34e1-08ddafff3a53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anpjWDA4eGRDOTBwWnJGMTAzOTgwcldta05zWkg4cGVCZXhuaE1LUitxUnVP?=
 =?utf-8?B?QWVyS1dwNEswSWhTSWw0QmtKYzRCWGNGSkFxUFd6RGpJRFE2UEQ3clhWa2Jk?=
 =?utf-8?B?a0ZLYzV3eXUxaEExRStRbWtvaFExSXRGSzViUlk4dnZEazdUdjlrUEozNzZw?=
 =?utf-8?B?S0x0UXp5UXZkVTdkT1IyNmJZZ2hydzdGNGVGUXluV3dOV0dPNWwzZ0s4eXYz?=
 =?utf-8?B?dG9pWmtGWGtuOVh6TUtlRWlZdVZEejFrU1ZaYXdaa2dSU3BhVXVKNnVzUEkx?=
 =?utf-8?B?dThEcGlsNFJraWRtWmpib0VTWXpSS1VibkRUeXEreGNtY2czaCtscnUwM1c0?=
 =?utf-8?B?b1VCdFc0OU1HaVlmVzdmTjJvMTFjNjVNcDVDQTkrelhXR1cwTFE2WjNKaDlZ?=
 =?utf-8?B?VnhxSlR3S1pyM0dYVGVvNER5MkMvNFowUkxILy9BUGRMOXJ0V1Q5K3k4MUZH?=
 =?utf-8?B?ZWZheWU2dDl3RWNxMURQdWpzdFJmUXlpVERaSVVXVTFRWkwyRjc3UldJelB4?=
 =?utf-8?B?dXdDeXZnU2V4Qis2Yy92bllWV3hCbktQVmhBZmFqY2JBdUE2YVNSV09VdXRE?=
 =?utf-8?B?Nm40K0FQSlZUUGZma0N2MUhYakdlald0RWhwY3lnZGFFWENmRnRDUVJjUFZl?=
 =?utf-8?B?NFNiL2g0Ymp3c3N0Rjl3L0ZNeEVsQitsejNEV1BqV1JNc29tVEVIRWJCTkhv?=
 =?utf-8?B?V0RuL0Z2RTlteFBPOURqbkVFM21TREtnTkVrS0Y0V0ppS2Fieit4Q3NyOURW?=
 =?utf-8?B?ZHpQRVAyNkxFWFNaamk0VmdBdVBWYzlwSWIxNDg0UzlmT1BmendtMWYwcWRY?=
 =?utf-8?B?azhPTHhRZ2FqQVA5WkFvTTRpZ0ZURXBqM2JUSjRGdXV1N1BrdzlaZVZ2amZQ?=
 =?utf-8?B?Y2wwdmRwS1F3Z2F6eHVwRGhLR3VWS1BITEg1UWQrbUxkT20yVDlBdnJMTmNt?=
 =?utf-8?B?VnBjT2VjL2NiTytDWXM0ZG0rcGJtRlpWZmIyU1QvNmtaLzRNeGpPVVJsS2ll?=
 =?utf-8?B?M1YvaDZyOWw0STVqdlRORXFMNTJDRUlDSVA1MzVCSzZ2cFcwU0Y4dHVVdGs3?=
 =?utf-8?B?WHE0YlBPWFJUamkzam13UG11QytEZkIxUlloT3JnYmdieGJZQ0thRWloem9C?=
 =?utf-8?B?dzZmRzFSa2N5dE9UOWZtSDQ2dVZFM1JyNmFZbWpBcVVoM296TER2T0M4SXV4?=
 =?utf-8?B?cm9UZ2UySFIvOUVEOVNCQzA3V2VNN2d1cFAyWlZ1VE9obkxtSDYrUldURWhY?=
 =?utf-8?B?MlpVNUNqaWsrcnhmV1hpTFBWYlYyMmNMa1NFK081Tmdpa1luZmN4Q09KTkpo?=
 =?utf-8?B?K09FN1FWWEppRExzaFZ2cDJmcmxOL21vaS9WdFdpeklpb3RFbHVOblU4OVA2?=
 =?utf-8?B?eDVnSG5pdnVtMHY1eWJSTlV6RnB6SHlXT3J1VEZHZVZ1eHAzQ2JZZzJlZFlC?=
 =?utf-8?B?TTJQcGQ5QThTOEVRR2ljYXhuTzljM2dPNWlhRW8wamxGL0lkczhXS0M0dlo3?=
 =?utf-8?B?eDNuRW9NWEgwdnR0YWtWZDRCRmVCUGJIM3BCbEdwR3laTzFIQ281M216dUVC?=
 =?utf-8?B?VzFkRldTamdNVnZxLzNQMStkbjgrQzlOUWhaMFpDYVkydVZhNWNCdHZtL29k?=
 =?utf-8?B?UnE4Yzdab25nUEd0bDVja3JnMGRFQkVFajZza0FUczZrOVJWVmIySjcweENi?=
 =?utf-8?B?cGtNSDBqNzFSVzJhWTl4NGh4VXdQTVdCZmY1aEkvU0RuWnFoSDlMT24vME1a?=
 =?utf-8?B?bjVmcklHRFVTeXk5SENkMG5oRmdZakpoZXM5cDN6dXk2aXU4bmR3eVI0RG9J?=
 =?utf-8?B?MitMcCsrcndDN0VZRk9KZlZELzJCTHcyMFlsMEo2eEhSSlFUc0dQMGlkb0xX?=
 =?utf-8?B?NkQ2WnYrbXJJdWZpdkt1TE50WXg0MTU3TmFEYU1HdjJjOXNLTlVtenZZU09T?=
 =?utf-8?Q?+R1umpKXCUw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3BjWDhMUWNZaHdxTFR6K3JyVUE5djk1dUsvNk9yNUZ3Tk5FNjJpK2NaNFpL?=
 =?utf-8?B?Z05NU0tHWk1rZHhOZnlmWG1wdFlkeTR4UDdFMTFDMUQrMHhNM1hlRkVHanp0?=
 =?utf-8?B?bDl4T3pXakZEU3hRTkFvYmNxRG93WnZpYTgwQ0RqZTFSL09janFQWklKNzZY?=
 =?utf-8?B?RGY3STJQL2o3WUlBTTV1YXh4K2tZbWVQQzFXS1VCMk02Z1NrZVBhK1hBWkF4?=
 =?utf-8?B?aW5ieDNWcFc3UnpzVGxZcE5ac2pUT1lXTWJRM203SWcyek5aVXNFUm1TZVZI?=
 =?utf-8?B?M3Y2Z1cxZ3pJMTNwU005ZFI2SStlOExJZWplMWhRUEF5b2lCck5HYzMybE5M?=
 =?utf-8?B?N0VMUkRpcmYyeDIrbHZyRDdKbisxekhRSmEyWXJPbWo5S2YwVFdSODhvY0VG?=
 =?utf-8?B?NHhXZ2NuM3hidTNkQ0p5TkNKaVl1UlFiNWtTY0tEYW9lYVFzU2UwRXRkbUo3?=
 =?utf-8?B?aUxXVHRJUE55WUo0V3BYZy9qMk9nMDJGUC9Rbi9KU3d0d0pjcnlBYnBZbEs2?=
 =?utf-8?B?QmZFam5ET0VoeFloKy8vVzRtSGpLZUdLajVjem5PNWE3NXkvd3lmNU5kTTRz?=
 =?utf-8?B?aE5YQkZmSWdVU2J3ODNkNGdSSnNsbzNaK2hITERFaEdSYWowb3ZsYjcxMUlL?=
 =?utf-8?B?UHMzQ1ozeVBLSnNDT1hkWGQvZjViaS9hYmcyV3U3QUhMeExnZy9SOHFiTGMz?=
 =?utf-8?B?b2dsMkNxdUkrZEZBTmNtL0FXMnVRcGcybnMwanRMdFB4RnFJUHpCNWVWMWNL?=
 =?utf-8?B?NzlmVVQ3MmQzWDAza3JsQmowOGUzNmdmZHVPOEJDVi9HaWVQNXowNEtOU1B3?=
 =?utf-8?B?N0hZdDBEV2l0R0pTN29GMnJmSHQzSElMVS9Mbis3SGJqRFpGNVhzWS9WSVBo?=
 =?utf-8?B?L1lBV2FEblhVcmFpTCtodkxjMXRQTWk3Yyt5TWUrbmwzdUx0T2UwVy94a2tR?=
 =?utf-8?B?YWlrcmFNQzB1NU9hRGFHYVppSWVHN0FsZWdVVUVZVG5zVzRhQU43bEpLRDcw?=
 =?utf-8?B?SDJGNWg3dndxREZEVzk3am1GOWJoRFVaRldHQmlvT0JVRUFKcFZScWVET040?=
 =?utf-8?B?ZjlsSGFWMklJVmd0WUdUM25veXFpUFhOLzZHaEl0VHh6RmtoOTdDdWRWVzR0?=
 =?utf-8?B?MHJYUEhJRmlweFh1NWRlMjJ5Y25FZk5tOTVDM1BGTTJ1WVJvWVpOOHQrUEJE?=
 =?utf-8?B?U3NVbUF3VzRQZXNCM0lRcFBDbGhFd2JJZlFadmpCWWpQR211SW1ld1NRTGx3?=
 =?utf-8?B?emwwTGd0QmpwT0tLUzR1V3QxVHhHS2YwRmk2VHNuKzUrRERHNThqOHQweXN3?=
 =?utf-8?B?U1NxcS9zVlVXR3pYaEQyN01HL2crM3V4OGE1SWlxaSs4b3hxeE9rTUFzbVVu?=
 =?utf-8?B?b243aEl5UFlVb0VPUGt0Z1F5NW4xWlltWGJ1WlF4KzRJNHk5SS9oWW55TXlS?=
 =?utf-8?B?T2FBMHRGK2V2OVpPUVBlTXpJV1ZWM25pU3Q0cEMzazYxeW1YOUpRZHBUWFd4?=
 =?utf-8?B?ejJlcnhyN2lONGFHK3ltTkkvSWZZT1h5cVRNRDFVNmM4YVVXc01TV3IzZ3pL?=
 =?utf-8?B?OVFDSGhqZFVZUnlkb0JaeVdzUEFiTmJMSlVlc3VHbGFJbFIxOTJiMlNpUWw5?=
 =?utf-8?B?a05BUUVxUysxbmZ6cXJ3OHA0L2hrbnpISDJtYUVCUlh6TzVqemNqNnZVWnVL?=
 =?utf-8?B?SG45N2NINGduQzh3WWFIY0VyN05BS08xdWlSNXdSanRLbnFrRW1HZ0IrdVE5?=
 =?utf-8?B?QW5lOXBUdDZNQWliSU5kOXBDVVgyTnhXYjE4aHF2T3U0c3VZOVk1a0RDZlNM?=
 =?utf-8?B?S2kwRDBWcS83ZXgxNXdjZkkxUFRWZmJEZEhuMFBhVklLTTRpbFBIL0FtUjhx?=
 =?utf-8?B?K2YyTDVMaXVUcVN1YUFZWlB2Q3dOanhodm51RDlvTnJaUFpzbFBvend1YWtK?=
 =?utf-8?B?TWdQNXVQcUdkRnBZVmJuSThYTEJDdno5VjdTTWk0cmNjMlZpemthMlIxc1Np?=
 =?utf-8?B?M3cwWlQrUjk3UHhhd1g5LzEvNlJuNHNLOEhqVXZhbWVRVmpKcTM3LzBTVzFi?=
 =?utf-8?B?UFY4bEcybkdvd3lJa0J0TDVzVks1K1RaN3h0RlNvRFZkdW1Ham0zS0JYS0oz?=
 =?utf-8?B?UmFZVEcwZGluUHBTQ0JCL0pGS1FQSEZCTzdzQUU3M3BNb3hjbkxjbTVMV1pk?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yeYG72qZWDU0luDtnRLJH3YuCOdAh6hixz2ZYGm/pACE4HmyraL52wJRJy6BmbZx7UOMOqCiFte4jewqnu7xNfV9orxRY7245TJLLBYVodpboP5wv7JlcgrUCkWNPzfpBG6TkxSpeNq74xTamFQ9j1RQ9bhxoIKDLG7T/rvm7bIczq5szuNzRD22mLQocaZbB3Z4MBi6W7xcDa3y3nTuOmEUtpRNCZC7OnQ+WLEt3fTcCMFvMOj8e7aq5BG5lB8APrai6h78sZ2KuyFydeCi3etJEMCd0oZRDpZp4vydh8hkXWQRvh8a+BneuRkn79P7cVud7bK+eNOrxrHvk8R4MIpX+F+umpi4uAr0/e4pKOM0Zdm7lk8wVgnLd8Ksb43aAr3wPQ5ayU4Uqyd43Wst/3RJBPTNcjoUFMaItbmfJgw2NOwkOQHYc2LDoCyFE3UG/iQrw5WV18rZ2L6zNA2prOBCkLQZLu9f4Ck12cnXwV7SdVV+y9PQMFFboEoSav8KdBcbD7le+U2V+HOUtdNKKTen1HCdZW5Z56CUoAlvEhg9ev9xxg0xVSm9b+trASJ8RDIc1uzXCiySBNW/oziU6zKbWB7I6LurafamQGD9ohY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b774ab-d965-4377-34e1-08ddafff3a53
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 13:34:49.0411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwTQxs8FLwaKdF3aWJod4AEr2A2Bb5LSGfi681srQSVILF7ysKXz0XzCSdMXIYeSWGEmUYxU/wdtCr9A6ajwMTQvnf7lb7L9AxQd4EPxC2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDA5NiBTYWx0ZWRfXyhE+NigVhfBg 99cDvSy8rV9hbc6Hr8EPR44F5ZGGZ1/yeFt4SSXTaMQXpv+5OC/Ilb8SvkMf0fS0PQHLL9H4t8q 9droFxTtTKyl2fObLzbg+rDefBzw0njlyKWmZQRN9whItaZgE4zEMVzRRyFw9iENc3UuKr5e/iK
 Q4Vgpnl5tv74LUffQqgmm+R0VDWw6l9qSWlTYtRHuYw8eHBjDm1rx7ecoCZilzQO225kmOrXuul Zl6oJJ5jwFpYx5XiGPpwAvd+AIHqqK6Hmt/xDnF4nnaCXtce62HNXk2g70ETGURMwp4NGJLQ2Vw Nn8+JivDJdl8gz1tSI0snAUXs/jZrvWBJFZW6xY471LKeLl9+/v6N/6bvzqkJQ0TOJsPBHH9yin
 0/vNUTHAu70M2/2vGeBYL6AC3d/SHt1qJf2Z1EFZc8Ujtz/iZzSPOJTU2OSsl+GVxl4/X1b4
X-Authority-Analysis: v=2.4 cv=DM2P4zNb c=1 sm=1 tr=0 ts=6855637c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=lMdmhQsT8_Uv-OeJrEMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: FwI0a-DSeTRgNYBkLgYLqVVNkCSUXrb9
X-Proofpoint-ORIG-GUID: FwI0a-DSeTRgNYBkLgYLqVVNkCSUXrb9



On 6/20/2025 5:09 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The qla2x00_dfs_tgt_port_database_show() function constructs a fake
> fc_port_t object on the stack, which depending on the configuration
> is large enough to exceed the stack size warning limit:
> 
> drivers/scsi/qla2xxx/qla_dfs.c:176:1: error: stack frame size (1392) exceeds limit (1280) in 'qla2x00_dfs_tgt_port_database_show' [-Werror,-Wframe-larger-than]
> 
> Rework this function to no longer need the structure but instead
> call a custom helper function that just prints the data directly
> from the port_database_24xx structure.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I don't have this hardware and tried restructing the code in
> a way that makes sense to me. This should be tested on an actual
> device before it gets applied.
> ---
>   drivers/scsi/qla2xxx/qla_dfs.c | 20 +++++---------
>   drivers/scsi/qla2xxx/qla_gbl.h |  1 +
>   drivers/scsi/qla2xxx/qla_mbx.c | 49 ++++++++++++++++++++++++++++++++++
>   3 files changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
> index 08273520c777..43970caca7b3 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -179,10 +179,9 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
>   	struct qla_hw_data *ha = vha->hw;
>   	struct gid_list_info *gid_list;
>   	dma_addr_t gid_list_dma;
> -	fc_port_t fc_port;
>   	char *id_iter;
>   	int rc, i;
> -	uint16_t entries, loop_id;
> +	uint16_t entries;
>   
>   	seq_printf(s, "%s\n", vha->host_str);
>   	gid_list = dma_alloc_coherent(&ha->pdev->dev,
> @@ -205,18 +204,11 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
>   	seq_puts(s, "Port Name	Port ID		Loop ID\n");
>   
>   	for (i = 0; i < entries; i++) {
> -		struct gid_list_info *gid =
> -			(struct gid_list_info *)id_iter;
> -		loop_id = le16_to_cpu(gid->loop_id);
> -		memset(&fc_port, 0, sizeof(fc_port_t));
> -
> -		fc_port.loop_id = loop_id;
> -
> -		rc = qla24xx_gpdb_wait(vha, &fc_port, 0);
> -		seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
> -			   fc_port.port_name, fc_port.d_id.b.domain,
> -			   fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
> -			   fc_port.loop_id);
> +		struct gid_list_info *gid = (struct gid_list_info *)id_iter;
> +
> +		rc = qla24xx_print_fc_port_id(vha, s, le16_to_cpu(gid->loop_id));
> +		if (rc != QLA_SUCCESS)
> +			break;
>   		id_iter += ha->gid_list_info_size;
>   	}
>   out_free_id_list:
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 03e50e8fc08d..145defc420f2 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -557,6 +557,7 @@ qla26xx_dport_diagnostics_v2(scsi_qla_host_t *,
>   
>   int qla24xx_send_mb_cmd(struct scsi_qla_host *, mbx_cmd_t *);
>   int qla24xx_gpdb_wait(struct scsi_qla_host *, fc_port_t *, u8);
> +int qla24xx_print_fc_port_id(struct scsi_qla_host *, struct seq_file *, u16);
>   int qla24xx_gidlist_wait(struct scsi_qla_host *, void *, dma_addr_t,
>       uint16_t *);
>   int __qla24xx_parse_gpdb(struct scsi_qla_host *, fc_port_t *,
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 0cd6f3e14882..a51b9704cf4b 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6597,6 +6597,55 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
>   	return rval;
>   }
>   
> +int qla24xx_print_fc_port_id(struct scsi_qla_host *vha, struct seq_file *s, u16 loop_id)
> +{
> +	int rval = QLA_FUNCTION_FAILED;
> +	dma_addr_t pd_dma;
> +	struct port_database_24xx *pd;
> +	struct qla_hw_data *ha = vha->hw;
> +	mbx_cmd_t mc;
> +
> +	if (!vha->hw->flags.fw_started)
> +		goto done;
> +
> +	pd = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> +	if (pd  == NULL) {

remove extra " " after pd

> +		ql_log(ql_log_warn, vha, 0xd047,
> +		    "Failed to allocate port database structure.\n");
> +		goto done_free_sp;

-> goto done
as pd is NULL it wont called dma_pool_free at all.
dma_pool_free, trying to free a pd (NULL) confusing.

> +	}
> +
> +	memset(&mc, 0, sizeof(mc));
> +	mc.mb[0] = MBC_GET_PORT_DATABASE;
> +	mc.mb[1] = loop_id;
> +	mc.mb[2] = MSW(pd_dma);
> +	mc.mb[3] = LSW(pd_dma);
> +	mc.mb[6] = MSW(MSD(pd_dma));
> +	mc.mb[7] = LSW(MSD(pd_dma));
> +	mc.mb[9] = vha->vp_idx;
> +	mc.mb[10] = 0;

seems Redundant, as already called memset ?

> +
> +	rval = qla24xx_send_mb_cmd(vha, &mc);
> +	if (rval != QLA_SUCCESS) {
> +		ql_dbg(ql_dbg_mbx, vha, 0x1193, "%s: fail\n", __func__);
> +		goto done_free_sp;
> +	}
> +
> +	ql_dbg(ql_dbg_mbx, vha, 0x1197, "%s: %8phC done\n",
> +	    __func__, pd->port_name);
> +
> +	seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
> +		   pd->port_name, pd->port_id[0],
> +		   pd->port_id[1], pd->port_id[2],
> +		   loop_id);
> +
> +done_free_sp:
> +	if (pd)
> +		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
> +done:
> +	return rval;
> +}
> +
>   /*
>    * qla24xx_gpdb_wait
>    * NOTE: Do not call this routine from DPC thread

Thanks,
Alok

