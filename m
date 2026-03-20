Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB62D837E;
	Fri, 20 Mar 2026 02:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773973262; cv=fail; b=TkiW2iQXiZGQPTiZodmAw52anm6oXTb6/nlWAnGZPQgf/JZCAuk20wB+YWCyRYZKK2tfTbjAfMSHb4jnE6+UNvsH90yZ/lhLJtfBmN7tCpCsWWHdo74/FUmT0kuSHBe/TmkK6zJ9txVNrwVd7DsJroj/0GfIPbtJun6pBKYab1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773973262; c=relaxed/simple;
	bh=e5HcE7LMg03cxwnUksmngyYpwyedtAbS+/uoxvrwuao=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ahCyxjngINr4WlfaZKrT4rgo9rNsX4sKt5IkjEucOl361rJM2PNfN5/6XX/Fo+u8LE+QkID+fl6B1QdOLBDiaITVpLJLDeYokr+Uyp47nvbkg4QXLV+8qlvSMBYweAK0xcAA+WP1CEhqllicBQXn6oFZ4jknBpo46KVFs+Z05AA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J1bOvU+n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BjmxmZST; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J1bOvU+n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BjmxmZST"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62K1ATLA2606477;
	Fri, 20 Mar 2026 02:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=C8yk26CQOQc3h6j5xp
	sFaCZZWou1P4z5p4x1HlKE/7E=; b=J1bOvU+nseaoGJfLHWUYg9MYph2vxc3eXo
	SQ7MLi32+gwYXYnRfXP/g9P2pI236I6bmd60M/EBtYSx4i6XwMxss8njABGAC5mA
	m5ZpI/zNRQiIWx1+bqXmD2WGYCzXgD+LI+qSOPXWvkiRd2bd7JcDq3SHJ2S0HOWD
	3W7dJdkDYtwQb6FP4+GpqXGFsslUo0Ilvede+OZWnABcIID6Dl+Yx3TOQ0SltxcQ
	e7ESmrKPmk+sUrj8LFWWomfg45rhcsMgQmKukdGw/KOQYhvtm54SFL4SZguHofjO
	RrMfGhrq8jstFPMSS9yv5+8nsfi95LJv47X1qyU6YhSxyJ2rDshw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxk8h0r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:20:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K1mmcD002788;
	Fri, 20 Mar 2026 02:20:38 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4qxfm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQuOIdQen0YElKnfdigIzHn55nEZdCkbPKhLE9mitFnijEDUWUxlsIItDcl2WKUJJzHlwfhUL8VGlhtT+uRgqCWKvlWuDPlb36YvTw63KkrB8Zn4qrhFYpnqrU+JSJwE5Og+x0ZSMyACo8g8UitgmOei7e/jso4wvhJh7e0mEiuaA/CvUW+C+quLoxjIXpQtkRqqsI/p6+fmvVyxQtBlFc/oYFoMX4yBp3WpElGMqRn0nV8eyTTc8wnOqazJQNrwwgk1LBE49YK9kJgiFEoBcDuunKb8amETgNY+OtKpaZaBPF7s/B/IF+yY5YMrElSxYzWbd/9e1GPsL0RYwZ49Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8yk26CQOQc3h6j5xpsFaCZZWou1P4z5p4x1HlKE/7E=;
 b=Lvvc46P3VYiN0VJaX8viUJl9rCHHd46G3u/u030d950uvQb84SdglRmm75Yi3IX+HAlhmY3gSFQWBrCGJp4b31iwFXag3kyOA2rB3yO26isKBrVyrLl8zcGBrdOGawHJATsZOTVJpcdZPbLkLB5slUPLC0lXn8Td1t+qWbRZDoHUmCiQGRmSACHaV9dCujIfIHfC0SKPiPwKkvpWssNvbJ2CTS0yMYtGS21uXEfYmipw0P+eRNDIO7yTwnjGNrksiFw0VwZize4rTAto7uAESIt2CF+/R13TvSEgifH8dqZWtfjCK0vhPQHsCSz6sbVfQosGd7j4sEQAsrqH1hpBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8yk26CQOQc3h6j5xpsFaCZZWou1P4z5p4x1HlKE/7E=;
 b=BjmxmZSTjNfCIpbwdm97r0slAmJWB7m5QHslU7W16rdstawGzqkykjEj06BZlhEKmO7HRWN94UqrzMufrYbnNlw/ZIL74/MCCBujksXSou94kCB8JqFttaVZ7DylqUNqEv5GYl604z/fxQZSXq1Tg+bBNF4VPIDuFTKFTu1bN3Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ1PR10MB5978.namprd10.prod.outlook.com (2603:10b6:a03:45f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 02:20:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 02:20:35 +0000
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki"
 <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>, Tarun Sahu
 <tarunsahu@google.com>,
        Pasha Tatashin <tatashin@google.com>,
        =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
        Jordan
 Richards
 <jordanrichards@google.com>,
        Ewan Milne <emilne@redhat.com>, John
 Meneghini <jmeneghi@redhat.com>,
        "Lombardi, Maurizio"
 <mlombard@redhat.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Laurence
 Oberman <loberman@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260319141142.5781-6-djeffery@redhat.com> (David Jeffery's
	message of "Thu, 19 Mar 2026 10:11:42 -0400")
Organization: Oracle Corporation
Message-ID: <yq1y0jnjl7i.fsf@ca-mkp.ca.oracle.com>
References: <20260319141142.5781-1-djeffery@redhat.com>
	<20260319141142.5781-6-djeffery@redhat.com>
Date: Thu, 19 Mar 2026 22:20:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0008.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ1PR10MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: fee1da75-e0bc-4ebc-52fd-08de862744df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	NW0B8aUb9MuwEIN26CxtrCi+ID74RmvOPYThdjGm0ID/2xSpA/UpH9fXF0lwcrcJ6giJ9NLz59jm4FWh5yE4x8tghhqiRu/BcdkcOfMRjWeeBI4IsX14rI/xJhawMgxbRaV5XhmGqCK0/PVdRoOHNAjSxXNfYYbxBInE3DO9nTG7Wy81o3gQL1Ocf2EnJHzj+qOiTJcdHYraCNsJQ9quso1tGrEr43OrtMV5P4veq5B2e6R6tQE3IhvcgmOommQTvHw1x28+1N8g1DF3wzeUKtcR2+tcO/efKyqmiH0HhEQNlmselfIyxBAn4ML6YPfwJcbqDltzn+PqKqBrqpoQpIECgiMII6kNdDGpC8My3LQNeRejlgSVI/63m4f1dOvA0BD/VV1znMdXtlvn8hHlPA/imrOG1Cou3h0ksYeB7Y7KUxvuD7isWCOCUgI19lJ6hlv4EZIEIRSmLQCl+ohCz4BnNZU0oDGcTlYZTsZVWPwDlkmHeyMYrWKahyso/Ulzwao5R8olQRs6t0ucp2UKBiTCsAN7Kt4YR3Pt/9FoKLrGm109wXW5XidcxOCet6+ifb73IShDaP5fORSbNesSfygadxxkHo5Y+B/B58Ie/6QVjjIWm4CEKyHuFcqZUC4VMdm435CW8TTyoqDlf2JfGdPj3GdFc27dcKHr7Kbe2GuBazfHMef7ynvJIdXII01ir09lhFcCLXQa0+EJRPP7wePonkuJqGojqreWy6E1dus=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qP8jqxVBsaXUow7eHic1xSWr9GFSNG3Dnxeodv5+/eV/diUZHkJLvkcjQD8S?=
 =?us-ascii?Q?qQnhCpErLmFE4G4WW4d/Sahpz/YLq4zBqIwujA7zOOTmex1Vj3zc44BAmnQq?=
 =?us-ascii?Q?ksS8DL+0YYps+lXHjihQVGVEK91XISstGMR5HyjqrQ8Ljk6rjoqydql8l758?=
 =?us-ascii?Q?NkpSIjA75l1FErR1tN44zz+D1B1PNVUdGguO9DT6SpEw4G+w+JBC5549/uu7?=
 =?us-ascii?Q?EH4I4CH1z086vMwc7MWiN6lO8tEQZubCyDj2CRnfqxdPzs1TbOswMswWh9WS?=
 =?us-ascii?Q?nh9fiPX/LgwTxBR7zshQe98XqaM3TktuScIzu40He1ho4+ZKFcuWoNIOPmM3?=
 =?us-ascii?Q?+wbHIx9OIF4UWuNI46QaenRcqDPHtRtFT6rqAjxV5E34u9vaZMu+6yV8qkY5?=
 =?us-ascii?Q?l3XCawXPdOi79WKUyRLAT36t9Dexoto9/91xWwd4OrAA+yYK0Gwfjj+DfGax?=
 =?us-ascii?Q?z4FR3zqyOvDErr+7KYu8WKPQY1g/U85f67+mK+gV0Ifi6Yod7EOypyS1N2/F?=
 =?us-ascii?Q?afMaIJTGuB2sJ0hLxjJiCTZI7mgMyE8qc3/ova7WnX5OTEuTluR0vy+tgki8?=
 =?us-ascii?Q?p4MXNhYW9lYeK1oYM+mB3FeqXHo+FJ0UQZTHxVp8sW9fT4eyFR0QRDU7ORra?=
 =?us-ascii?Q?LFmJh1eWte4bhF/FgeOAr2TN4Hm1UOiF6dizzjajSP3XaLtIik0TB3SYT4CP?=
 =?us-ascii?Q?a6vngJX06CggZqaX0BWaMnKGCAgz20V3mxruLUTljFD6xR2GD4JEtJic36w7?=
 =?us-ascii?Q?ETHJ7JKAY52MrBp2+Tgzz+Q2ptMJVUYvAqAi8M1OVVRDgvxHNl94emGLv5tz?=
 =?us-ascii?Q?2Y0RZe5e6cn9W5CeVXaqfE5zz+rDSFyxJ7KD7UDOvN90dj/hR06O4v2YN4nI?=
 =?us-ascii?Q?rraWkyEMyIYpqfHeSThHp3wEP4UBfp6AvftO10rMF26GClR+JtePR7c8EKbL?=
 =?us-ascii?Q?+KXoZiNgJmc44ny5wcHZm1hoYCzxleBjKLongvE8xd34py9CiFAAFZoRlEMk?=
 =?us-ascii?Q?qUvo6/FXsbQHy3dTctO9YiF/3XJ/wTTTjXNDzyv5tx9TikK3OgSPZj5wvA2C?=
 =?us-ascii?Q?1Kngt35V8sX79rIBHb5xDSLYU7ebQhjrLPnXyV2EajdUHZK8udSkRoaGH6wh?=
 =?us-ascii?Q?j+nIEfqp2g41FVFrhrLaIi9d4FiKzkk+iFrrRR1jmPBEK4/JrgOaWFx9eddC?=
 =?us-ascii?Q?gy4jsXKQLXRg5ILjXX3oEv0l3hJQd/jNdqF/VEY7nFkTseMb6nkbZtdUj04h?=
 =?us-ascii?Q?dsU2LZAXpzI+oMp5/+c/jgH1g5Bz0zQ3pvZCITC0fidvWl5p5QcywUtadzM1?=
 =?us-ascii?Q?e55fx30GDGYRfCsNBkZOBz31WCi8tQuYODiTVs2j2pMbZRgJ02TjxXPRjDOF?=
 =?us-ascii?Q?OkxpX2gx427uz557ioy6UQUKgpKpVodiQn3FVCVIf7y2UGa4MMeqF0y8ETqK?=
 =?us-ascii?Q?Qcsqcm10ycmpMhrfuBlJSGaSn9AqH17YVa0zHWK/wzMJFn2CNx/wpLYDEIb1?=
 =?us-ascii?Q?s+C30pbuXyl5uqH52eUDVmsUYSrTqdpDgVpvo2YpymWRH/2ooAbYqMUQK8Hz?=
 =?us-ascii?Q?8MplGAzm9XVvcpOSw2J+otOWRKr8Prx8YhXORZLdBh3PLhnjc+fEJTgEA7AF?=
 =?us-ascii?Q?k6mgtRkwmGRnimPIDv+WKdE7R432OwJej0W436adGQYL8i1ijgByvxKeVoQu?=
 =?us-ascii?Q?EA9fX6Toe/sBDhhByA2CE99DAf47kx+LnumBvKo5ZD+LCAIRcvVpEK53vjxK?=
 =?us-ascii?Q?c19PVO5mSxbBDWRaH6SzNQ7Ij1S6SJo=3D?=
X-Exchange-RoutingPolicyChecked:
	CjbV+vliBpd048Zu2Mt/lTGZkXBa6bStkhFWLWzVD10bQOSdV69Az+bBGEjW/kh9CFGXQVYyFCKMLxD0F7SQR7Dl5lCyVaaEESAVSFQHc4s74NzDHB+NG3tINQyrNmz4ajg9baDNDTK2KQsz+ZbgQl6VdSXoQvNW4hhi/A1zZKEXLv86+kVuLlAkA0TQ0AOe0NFU7i1wKC2Ti/zbrDMeEbMkWspe2sPAOGOBCScVWtExszlBszLT1qRWqfZhJjlPub8N9rRRvbL1pqGZ5+UdGkgymOlrotZbUa4e2fDsm9/CJaa7HRSx8etBmpo6H0H94o3+fvL8vP2rtcADL9fzrw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YgE06ohTFEd0Qoe04XoQQEaW957d2UBZFJAu57APsqAtsyT1zdpZgCB3+5hZW9zM1im5HyrbfIGsMBi+4QCWipW6JMGzjpV5E2Ysm/gsSz770jYdvQNaG+UbXu+RhUi3SWZSGBBYWqBwbeCsjg/Dtth0JEc51oBSGFbRut50dglNhdVDAelj4OXLs1WkIBnsL27uLn+0o4fjzr6WXfZSphgn1hXcMQddsZmyrPi++38gyrnaC3wBD3FkUp9wOKLhkpbDUULEacT/egz8x8WnuF7AGMNLZ+iSpte047dGTOP0Zir07xS12/au4OUcDvckjvpsO6+cvETqMYF6i+Paf4eGSY898OEdJcPNU40jihXlrfcXUaJNP/0s//1R4urKO5j51fpepWdVCiqQyyCGN2Yj4SUhovMfh+DwKX+btFLcOJeQT7W4Q7p58nnR3j9aBCeUMIXNNVXvQA4kR3vz+0Lgyd/tEFA/nhavNOt3h/DXXAkSbzcHkyIlHo234go4G8jlJ5xoBg7prudJX0XR1yHtmkHgnTnHNK3XX4gYs7zyiqRYiddylY4klksuwzuQ7NwVroHfugie7KfAN2bqazI3z1vLlLH8iUYbhW+BHDs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee1da75-e0bc-4ebc-52fd-08de862744df
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 02:20:35.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74534gXIyJRK2RQ6/VPjJryIv7QVkphILUuPmWY5NRKPuY+sfU6KaQ4U4jW6oOGRZ26IXopt6lfziWV+OqGnAUSF8blLzh10PzcnnZnKHPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603200017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxNyBTYWx0ZWRfX+6mB7Fys83JE
 dBIHL8ulNOmEPgiAJyc7a492BhcCwo9hwR5kvQLD9HpmoaDvyoJGSXI+VTfhM7XsFKaTTaelrVg
 eJgZlSnmQWtmxVhrYw8+Ft0izJVdcOSax/JIlSEm5InHW8/sG16ufe0kj6I3Rk+dwREPSn3tUbr
 duKonC/wQ0JnHzVyl+zMgryIYRkCAVsZ5RUqILZOMvetxo03f3KuQy0rE8zZ2K3QJ4IkxU9DVxy
 Z3bMgoGFJmJUc18gl7tzQ0rdx7pOKst1mxLqfVmvIECJvv1BL0P653QuBU2YticG2hrGM+E7usz
 gz6IvhJTXyijfmU1L58sItuRt+aAD1uL8Fbqwg+zyHZerbLBjXFchmBLxchLrOnN0phJ9TY2tkS
 cNOXAXpBXy3CyEDx2qjMVnxVWAIVBvhE7FdNxnMiEUAHvfVqClyFocPSN+htheWzTmkbYmjnYFu
 1YDB8ge5rAJREbFXakTJa41ORFH9e+lXvctIjpkY=
X-Authority-Analysis: v=2.4 cv=AI0/m/Lt c=1 sm=1 tr=0 ts=69bcaef8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=Vmfo3CvtGgswePUCxAAA:9
 a=MTAcVbZMd_8A:10 cc=ntf awl=host:12272
X-Proofpoint-GUID: V1w_LqJOpjNuyQmU9stMSoYKKW1BOZbZ
X-Proofpoint-ORIG-GUID: V1w_LqJOpjNuyQmU9stMSoYKKW1BOZbZ


David,

> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
