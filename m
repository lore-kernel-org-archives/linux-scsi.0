Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6F6419FDF;
	Wed, 29 Jul 2026 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329627; cv=fail; b=UmUheRxqAmO+l+t4pT5z9I5KIqBPcVUg6Wh2A2kH74+57GCdA6v7xsDRf46MWZHgO5eZ4gmT2q/jxrQtbmmRf4FPnHfWfQsAwKh8qQSnBLflifXBzT1fd6zdLYcKNjndimmbHrXh3wHwdlnRXKRWJbCwRENLxKT4kfeuFy2lGyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329627; c=relaxed/simple;
	bh=aFlu3vKpkb18s6LA2/hn/Ofiok+xq2+1+xpSHVvKitI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=isJQSlLqaKxU9yljJ/HmdMaOBueCYFR59MRTHB6OEw0zEJpou/mGQcv5Fcphc9FaV2Q+Lohm8eXktFbTaXUYA1L9BlRMPfl9BUnkmYvFgCtdpCUhePT1ju4ByIDOm4BQTe3iU8U1CGsH/SRMPEHsxL5NRNpu287hxW86JT8Hz50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mp0RTLNW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OVUsWZlT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mp0RTLNW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OVUsWZlT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9XKpM1120893;
	Wed, 29 Jul 2026 12:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gqaMDaXAZ7sC8Q4MeYLFgOt3cKRJNKQMOIGqWbkZuIs=; b=
	Mp0RTLNWe2zDLOPDcaTwcEek8KiBK6azUfGFRXMmLJ4gsj191xY3uq3ixQoIdbhm
	dEOWfWWK9Rp381jqGYZZ+SRDEj6rfAhDrJZ8qhVbg4fUCxigATzw/L/jPt2Pltky
	XFOxsvN/lOa6v9cjiszT3n4XKxpEr8K8CxIZ7X5XbEdHPa6wlqLSd/W9Rl1VoD8m
	IKM07eFzwk6ChZ6+8DrDH8T6LWio7CYaq/QUESVywAqxD/PmOJgaDoamBFo1kAs0
	Q18XlPx1ESXS/jkpEsyvg8gCnaqBjIdhS0aBV1PEJfz3cS84MxJKlRp+RmYPDQBQ
	feiuc93MbUq3Qnaw3sVO2A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnu6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 12:53:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TCPb3G033655;
	Wed, 29 Jul 2026 12:53:38 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6qx9xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 12:53:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HgxMGQO6Z6xAD0wnmBrH35aID+kScrXrZex9OVU1lk9hiaPIvAXPtu1R/Q5PpwOiAWKcfrWvrgfAaksxyzEim5gsU9FVRJAGX8TpMwfVIPEVzamIgHDTfWYAn3QYzRu7rugl0WdbeIgVTnLCEeqQdKOadTWt+6O/9AB91hruHe8zOuQ7ntny3B7tSkdXCdjoMxgaO8RR5FBmq66zlZVcA3l/2lZt20Fus4t+bwb/kVhzMbCkRNqIsXulSzdKeT++33oDpTYPVeyyMmtNYAOBCtfZsLpSXdB6RZhXQvFqDue2L307VeIfOBfk462PLJ0ag8xBd4VF1ph4TIXjzNZqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqaMDaXAZ7sC8Q4MeYLFgOt3cKRJNKQMOIGqWbkZuIs=;
 b=mRgIlg+8FFdC55hT5s+9WZC3BtfG42Vh4fkLx8du/SpWSfC7LmKDCBLsjOp2r7/O1QMwOYnpSpCTD9ZmHMblyCZVxWgi/iiBKwkfu0VQogb7w9ZV1TtifP5GfqMMOhS4FhhFKkWmL40CmR7TuYsDth2w4GOCzoRSwsBDkw4l7DAf3p+Ceba59pnHtwrKjuzSdWqsEJ7MNqWShgnmSP/l7gzB681eUjLZLEk3k3kQJzDHSflV11OcKzLbOmfUSDRaI16sokOhv2HXXTrAKYhDOQXVVL3Gjgo7WTGIWlrqjDo8YNb3QhrIfJPQUhlLFXhwMUJ/s+WbGTpSz48Csz723g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqaMDaXAZ7sC8Q4MeYLFgOt3cKRJNKQMOIGqWbkZuIs=;
 b=OVUsWZlTemCK91rn3/WNtbifxeCWRNtTFmIdnsMCSTX2N+7gMeU+WoJ9vXknSysmna1kvcc5OSs8vxc3rN8zCJP7LNoose75M4ZXZTy7buN37uTCHwP64FPIsSD8aaV5Jm05LZafxMKztPwqjfTfSI1NCl6gbaymqQIr8ggG8sA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 12:53:35 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 12:53:35 +0000
Message-ID: <9c8972ed-3282-4d58-8e83-0e3c4563f69f@oracle.com>
Date: Wed, 29 Jul 2026 13:53:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/27] libmultipath: Add support for block device IOCTL
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-9-john.g.garry@oracle.com>
 <20260729123951.D95981F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729123951.D95981F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0016.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BL3PR10MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 70708901-1500-4237-6518-08deed706701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|56012099006|5023799004|10067099003|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ldAagANHkaMRtGigYrGaQyOVutlT1MCt3nGIJ5QrAANu707pCZithYSSodrTOSk69ku2PPaPWV1OrBVyHQ+C5V+5nH2Cy0mQaImtn4arabYDjEgrawGbTgt6c1mld8TbbVu89fB2QlIwTghUFD5Ix+mrYFprfTTktd/SPC9FSqDakZTQHeYW3VRqeUdK2DqRw9QQ1mmnCcmujk3AnAeIcGuT3BDaN0ycT7NFPyODD2Kbxw0OOr4v03Z1d6KHBvlPxA/wP3kbqzxPkvAaf+QUiDSKKqo3Q+UYGcHyBnJu2pw8WWj1g1nwbChuXG059cN0iop6moMmZzkeS4vuiSTlvJeTjvD6eSbbk4vhAOALqPzrzzK8qJf4IWthSGcIEgKs8aSC7M8V7Ncmvn1uO+T8lZSRN+ANHNJGNfHxmW3oM+DihmzktbZ2p6500E2q/TgTwYJSDoNMvIQtlc05KNMdUOIRA/9PO7X3gk8VWUYnZtlOTHHT/cmxJTk86t8kYoJNRJza7tgqQ+xHKDPdbSohUD1S1bF+sbyXdpwwG9UHL3jkl9LRD5FO4nEo0GY3GUbkJXOiSHSIjVKu+VhDw7sCpXnvMQYTsgUZYHtpl/0FeC3paj6EkV5cJAADF/marF0eE0v/t6pjr08SzeDH8fetxBTLLbsRckZgDp3Sfrc8U08=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(5023799004)(10067099003)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDNPWjJveTVleG8vNlVLSEhvenF0N0diMDdIZXJVM0RtT0ZKcG13TndDNHhj?=
 =?utf-8?B?dTlEYS9OeS8vRjBqNkY4U2tsVXg0V0JpdStwbzhaeGRHOU1YalExMEQ5Q2pO?=
 =?utf-8?B?N3BuVDNQSFdhOUFDUjd3TGFmajVRRWZBQ2NmdUVJbHQydmdEaTdGNDR3bkoz?=
 =?utf-8?B?T2dlZ0R0dXo3VURlTjJqSFU2aG15cjJEbnF3UnVRS0Q5YXp6REZ4Zk5Pd05k?=
 =?utf-8?B?UWFFRm5mUEZkWjVJZWJIZ3MzeTF4YjJ1SmhOYm52ZThCdlhUSkJWNDRYaFVz?=
 =?utf-8?B?dy9DNW5VUm1PcnExVzN1UjI3MU11cEF5bGxXVGx4V2txczVGNlBqWDRPNTNN?=
 =?utf-8?B?Q2xWdURSM3J6UkNXOG1XclFJZXZTN0UzaWFXY1ZHMGE2OGdMbDRkbG1LTVBz?=
 =?utf-8?B?VVcvWlYrUTlWOXZ0NThvUURORkZqQnVrNjFJcXRWWUhYRmVEcjRrMHc2Wk1x?=
 =?utf-8?B?L1A1MVBsQWN2Qy9MUlh6V3lDa1RBSml6ZTRZMEtkK0FrNEVweng0Mno4YXda?=
 =?utf-8?B?b3N2SkJ6NzhxbnF5bnkwUUVMUldUQ0MrRVdVNm9NbmRLZ09EVnVHRWdnN3lY?=
 =?utf-8?B?ZUsyVmdRR3VrekdjeU9Xd0tXMXNWaUc1enNtRlB1Nk9xd2dHMGcraHVVYmcy?=
 =?utf-8?B?NnhQaWl4S3VjQk5XR1hCVzZSRFR0bW9rM3RaRDRLY3o4cCtSU2FqOEZwYVJR?=
 =?utf-8?B?clVaeHFmSjM5MGl5a2hjdnltOEZmOS8vRnU3WXBZNHNocytwZG5QQTFaeHJP?=
 =?utf-8?B?Q3dHNUw0ZFBjRTV0UWNJKzM3L3lUTXplbDFaWkVsWllYQ1VsNzRPSWFUazZw?=
 =?utf-8?B?RUYzT0VHb0JlWlVud1VJMnNSYzZkekdTTjRFUGtkNUNKWDlMeDVqVzZ2cEpJ?=
 =?utf-8?B?TTUxbnZ5UmNqNE9yd1dPQXZkRkdGN2tuNTl6R2gzVUdnV3Jxdm1EaXA0aERV?=
 =?utf-8?B?LzlnQk4rNHpSWlVPWm04cjhvaDE0L2J1bWlCanFGVE8vYzkyd1ZxSkRsRHpq?=
 =?utf-8?B?Z0hGOGxwbEdGMis4ekFjcW90V0JXVFh3NlBhUmZBaW5uRCtnU1grcHltbkJZ?=
 =?utf-8?B?YUR3aG50UG40VGFDTDMrS2xsbjNkSGRIQm1UK2RkclZsRzI4N1lEQTBZK1Fa?=
 =?utf-8?B?aGpGL0QveWFUUE5PWHk5WUdaclZsZDFqdXJPY2pNUVgyanJkZWpXbG9YeDJ6?=
 =?utf-8?B?THdOSGhGZWo3d3AwczdhNjhmYlpIOGtMZ0F1cnN0blZYWjIzUjVqVWZtQ0hL?=
 =?utf-8?B?R3pGMEs2Ymd3WktwYkt5TWk1cmhFWXlCZlNhTG1PUDZobmpyaHppb0JWWUN4?=
 =?utf-8?B?YVJPTEtaVEl4aW1sWVNnMU9TT0xlR1ZrOXhtdzYzSWFPRHpzVWhpNS9PbjRO?=
 =?utf-8?B?NWM3LzlZZnl5aTc0SmdHRXBva0d4dTVPNWUxdEhDZDBGa2thbnhyakF5aEtL?=
 =?utf-8?B?NHExM2dNenprS3Zxbnp6R2FPMlVhVzBxa2J5cDFOSXlwVk55bjhLWnp6TXVR?=
 =?utf-8?B?anJsOGVSZmtwQXI5UGhPKzlSald6cEJndHp1eWpDZE52RytPT21vYzNNaGdC?=
 =?utf-8?B?UW1xM01aZDlSZTBtUzlEeHJCZlQ1L2h3aC9Udk14RDNqYzFyU1J2am15UGpY?=
 =?utf-8?B?QjduQ2h5dUY4VjRnK2NwY3lJdXRnbmZjTkRvSFZBQkdUUlRId2d2N3hZdVBC?=
 =?utf-8?B?YTVvYzlPNG9rOHduUHNQU09MMmxPallYbVM5c05vM2UrL1JVM21kN2hkZm40?=
 =?utf-8?B?RkxyY2hMRW4zcHJkSmJ2b3FJLzZjNnNOR25leDB2S0tZMnY2QURKZjJGRFJC?=
 =?utf-8?B?K29KMkI1M0YzaVBFY0ZVbFZnU1FWNDF3QUNKVjU5elhzNnFNeDA0bkx4UmVq?=
 =?utf-8?B?clFidmQ0VFFqSjFSYS9xNkxVNVJ6dzkvbEppY05uWXFva1pRU0swVTBmL1Jh?=
 =?utf-8?B?cGdmeWM2S253MzVNMk5BZitLMW9EMzhPR3l6Szg1M0t5N254WFNxamwxMmZl?=
 =?utf-8?B?WTBqeHBGN1UzaWRIbXdMb2Y4ai8yRUc5aERwbUM0Zkp4SmwrR2draE1qTWox?=
 =?utf-8?B?anNtbUxNK0thbnM2MzJ6eGxJWUxaY3RwbzhHY2tiK0FWdzcvUFcrK1VnVHQ5?=
 =?utf-8?B?M2orNmFla2NtY1BkdFlmc0V1T0d4Y0luRGpVa0VoZ25KekZaRVk0QjBjVFB6?=
 =?utf-8?B?K0J6ZmJZT1VuMXBRWE5tNUtVNEt4WURTejB3NVJlN2ROTTlQQ3pIeGtiV1Ay?=
 =?utf-8?B?VXpNUHI3UzhHZ0lBWm9xWUlxVzBFSTVGV2ZaelRxdGhjZklOUG1ESzlSSzli?=
 =?utf-8?B?U0NIblhhODE5ZjFIZFBmb3V4cHNDa1BEa3FsQ055LzdiR3VJS0VjUTh5MnFR?=
 =?utf-8?Q?GKAcUVHdRUcTLOO8=3D?=
X-Exchange-RoutingPolicyChecked:
	jtGqZ4ZaQMlqjfQhZ9wYI1HyTThBF/iUgx7B1fUueWHYyYKD+jVjGOJvo9hpeJQKLqZwBWzrZjqi5xtNS9esxKfiaj+4NGtAnZ7RtbYt0Y6g0qjQteZQJ2l9/g4Tml5fzUuqGvAmOBvzY6WVfs/1GA5w8lPaZMvb0LKsYhd84Cphz8HMmD8+a4jCLZ2+T3iFJ/1W1nfvy6w3PxRiQDQejJvXSNh+fh7YlPTqK1g6CSal+XMSsTC7kU8nu6SwWkIs4Fr9apV4ThM53Mbp1LndTNl4PM7Skdl2oXcCBY7nPfOZRCEoJbBE3B/GI29aHQHQdedlhHv3FvgCoB7FJr5+zQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cx5EawcZJOktPY6M1taDxhuVn7f0fhINn/W8SeNSmqcbFLi3GzShPW8LSAB8IrGiuTWMXqraieONDf2KL0RXlkCO/3MqfDMFHKcmz6dkwfN+5KWygTXNgYBFi1k4kUbbMbMs42E1LjsWv8jBQPYyNusvDTIU9X+9mI+cbtnXegczO+NMkug1bT5oRy6ssoGvw2cWMIjLJLhki9silxvzmpbPrj1NdhsdTt/MFW0CyqifzN7w84EzJJHNMGyk3mqEzjoRuOACaT6q5LaHrdU6d3q69TI3G2ngv4WD1cx210b2NCun9z0Yicll/3r+672vagCZ+T8uUlcJyTK6zikEqnjVzhI69f29AwrCTx3E4fpLh6MwurwWLGpvmLKZra7NF1NJB2ieJ2AHZ/fWQdE+2b+PNjHjDRUa/STv5DUGGorOAPratxQiV+L+r8YoaS2zhquNwOr1fZIDDE7F0jWgeo1ymQ4NgK1mclqbaIz7ySdHXHY8kbJzGuBn9DjwdRjKXvpvcWl1djB5RUanQsOnTou0knuT5BUgZmCYH8kbXQBFWOmNWnq7OFpDOhkDZnWYGJSTsEggZjtoZiG3JW7ucNWnC6aP6VNuMweXKWCQQVE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70708901-1500-4237-6518-08deed706701
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 12:53:35.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7stqWbHuLQrvl15RAfgVGdoi/pk2inS7T7iFZL1/cRV+xtjGvnagt01ePs9T4FCUw84fQxdO6Fvz5ICpSgpYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290103
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69f7d3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=T29d9LgtTY6PxLG2OI4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-ORIG-GUID: VR6pu-wjQGYYlCi8ZpCSZDKsbTAL1Z4m
X-Proofpoint-GUID: VR6pu-wjQGYYlCi8ZpCSZDKsbTAL1Z4m
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEwNiBTYWx0ZWRfXzJz9Ku3HSgXW
 XZVMU33Q5b2y4vvBr+IDuBGoFV+GEJ41BWTkySEof6eFobIysVxW//NBIFhW7qYaYEdcsshgiE/
 cVgvoO8U2lsvKRlxyvOplxfz09gq0RduaDEuViT0OkzucqgVQJNY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEwNiBTYWx0ZWRfXxnBF/ORqW2ZO
 jztsr7A6kKGhza6D08QM9TYEUzK4VsGwvHOApYlvUnMZpr7xfeQZKHno9+LntkfcXLJufvhfybY
 1ko542QjgbVKUGG6Fa61KRNWqdMuMXw3LGbiKac3VmNQVPvY7XKGFLD5jDFE6fGoQ7QbEFEMFy6
 2UakRB8erH3RSX1VlPs8cRUHL1FHWofxnBdvULqgeg3yrZ3oxv5hlnGSc3DgF/skZ7/TDKA+h/e
 +qsaDOuOMxzaY4G2yBoBP8CO7HK3cgH3fy8ALWZR4urAFl9SjgO7KvwloMVx2sz8GML2CsoI1dD
 iCpgR75KRy6Mr0VSbx2ZsauP7RMoC0sQYC9sDdc7mbPHdLPzeE14ezr34/1fVsn7wdt4ZPZI4p0
 U4BLkahB7dNr6V29L0F43azS/hJimPofPmPI0EakkgM76GJFvKxa6WH4CrIrFZRPovXa1kCOvCY
 bXaOuuMZeZlbeRIOVt8ARaNL/TnS1KfL6cQSc/Js=

On 29/07/2026 13:39, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Deadlock in `mpath_bdev_ioctl` due to holding `srcu_read_lock` while forwarding ioctls that can trigger synchronous path removal.
> - [High] Bypass of underlying partition-specific IOCTL security policies because `mpath_bdev_ioctl` unconditionally passes `part0`.
> --
> 
> --- Patch [8]: [PATCH v6 08/27] libmultipath: Add support for block device IOCTL ---
> commit d2e45114ccfb93fccdccc60ed75e05084f9b9173
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add support for block device IOCTL
> 
> Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
> handler calls into the mpath_device bdev fops handler.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 58eb9be5bebbe..f1758d1e60a60 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -454,11 +454,53 @@ static void mpath_bdev_release(struct gendisk *disk)
>>   	mpath_put_head(mpath_head);
>>   }
>>   
>> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
>> +		    unsigned int cmd, unsigned long arg)
>> +{
>> +	struct gendisk *disk = bdev->bd_disk;
>> +	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, err;
>> +
>> +	/*
>> +	 * This check is duplicated from sd_ioctl() as we don't pass the
>> +	 * partition bdev to fops->ioctl. That is not yet possible as the
>> +	 * per-path disk is hidden and, as such, does not have partitions
>> +	 * scanned.
>> +	 */
>> +	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
>> +		return -ENOIOCTLCMD;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +	mpath_device = mpath_find_path(mpath_head);
>> +	if (!mpath_device) {
>> +		err = -EWOULDBLOCK;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (!mpath_device->disk->fops->ioctl) {
>> +		err = -ENOTTY;
>> +		goto out_unlock;
>> +	}
>> +
>> +	err = mpath_device->disk->fops->ioctl(
>> +			mpath_device->disk->part0, mode, cmd, arg);
> 
> [Severity: High]
> Does unconditionally passing part0 bypass partition-specific IOCTL security
> policies in the underlying driver?

Check the comment above regarding sd_ioctl()

> 
> By passing the whole-disk block device (mpath_device->disk->part0),
> bdev_is_partition() will evaluate to false in the underlying driver. For
> drivers like NVMe, this strips the partition context and could bypass
> requirements like CAP_SYS_ADMIN for passthrough commands on partitions,
> allowing a user with only CAP_SYS_RAWIO to execute whole-disk commands.
> 
> [Severity: High]
> Can holding the SRCU read lock across the underlying ioctl cause a deadlock?
> 
> If the underlying ioctl triggers a controller reset or device removal, the
> teardown path could eventually wait on synchronize_srcu() for this exact
> srcu instance. Since the ioctl is waiting for the operation to complete
> while holding srcu_read_lock(), synchronize_srcu() would block forever.
> 

Currently the only ioctls supported cannot support doing controller 
reset or device removal, etc.

>> +out_unlock:
>> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	return err;
>> +}
> 
> [ ... ]
> 

