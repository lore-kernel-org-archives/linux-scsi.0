Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAFC353A82;
	Sat, 25 Jul 2026 20:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785012277; cv=fail; b=JwXU/iStyELEXrupUtRfwP916/h0T9DdNl3Jgwit+o9/cRxTSMX9XnIQqpzift+pRUgp1m3qiSaV3WP/K6W0Sy/Ev44XgfKFld1OqbDN9EYsYrUuAfmj8L8at6uTDrTSQFMB87+EOIXyoMrffdx4QXTiKupn0HF4uCFPBITETy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785012277; c=relaxed/simple;
	bh=/RBpjNGu85bXQfmskJmcBB6c045h+ZPYaCyK/nOi0X4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lfa62ItruOAipxsveuhBFrDcq76uGWGdlC5CffvOqnnnNMfb9zAM9h76+sJxcHHNSporuiI5CFRYkIEmamhAqiJA4EVAFV7GXgiJeeEimWXv4xiSrtqMnSdyIIm9UClLJEDP6NzgKpnYaJDRMt+akYo0tWn6tU7DgsngeRRilY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dv+RB/kz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nZe3uKFc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dv+RB/kz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nZe3uKFc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PKWsbm2324753;
	Sat, 25 Jul 2026 20:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yWzotJDfezfeo2YiOq/YQDt4Ib99nNeiV4jJ1E+RrXc=; b=
	dv+RB/kzf66E0DJzxFtrjl8yIwKBzwAKebudObayYujerVZtL4sn34zLteu5Gx5R
	+dGOTaiJ7l1SUIw8dokz78hWRzM4Rgtm2/sIMwQQnAcnGHguGHo2JoG8oGarYXxb
	seAriVm+NpeK42bBKFgbzGVUc6J1NTdesM6TSkjKloRqpbSYuz1u4k53Jc0uvVM7
	BflBvFAo/+sVCUKV+HPx2mmf8wLl9ZIaGZ+wkybKMhED5F4MMzHf7DmeOVIMXLyF
	ZperEPiiYL7NNt1VhrXA79rkVDpdjzNpcbVojFvzvzyOCL9WVRqqdhFRzZIZ+zqi
	JvF+qepo4bvLYjpPOWILjQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xra0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Jul 2026 20:44:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66PKh7vM022479;
	Sat, 25 Jul 2026 20:44:31 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fmkkbw6yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 25 Jul 2026 20:44:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aja+NxlmJ9NNwbXX4fx6izO2DquBWOqTIe9P6Il2aorAcd5qEB9NnCBLuvIq3GmqwT16zd3GDSEdDCB1zxf/sd4E/SUJEtPhLm43GILb4SUSatm7RtYHmZuGkzlTedgQ8i2FqLrcSiTOdgyGu92QajsAdVUtVfi7PYESySol7WEvjXvG7E4LjoqKT24OxnH+dOYwQ/V9vNO08EWetdBE8VIsgPOy1KGsowRCLqqFEnZ5UK0Al8jypUMGexx6YJ93m/+/41CfuyoBFm7ghaD5+Id43sb2+P3XWWjxEl/vK27ZwFvV4GyiHQrRg630wK1Op4i2DXPEPqtm5IhhHKdZ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWzotJDfezfeo2YiOq/YQDt4Ib99nNeiV4jJ1E+RrXc=;
 b=PruLCS372SjHlbr5fRtHQM887X+5Ey2hdC8JhWhDIAbDLmaPki8u33sl6Qs/HOlU3QIEJAySv+St7VWeSCg7qfpY836MkA8vS2nXBs46HOAxp6DEk7K6QQUhpupTp8S37ID5EYTW1CP7l5lkC+6Q4S9cOkMmMM5LCsYqC6Td9WcX7W5TfN4q90RmADBzOkM0tZzZLUAq+M/Duf0H1osXOuC3AVeY2zE0fzg6xNGI5zKMxZ76/hVMs8aHEw7BtUi/gZer0S/IcmfR6Xvkus0Z9errAIyk5xRfKOcHTXrlwhYUm9IzYMOHD0BzKhHp5e+0vhq6cI6ZoloBt5yaEOHxog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWzotJDfezfeo2YiOq/YQDt4Ib99nNeiV4jJ1E+RrXc=;
 b=nZe3uKFcani9dDvC/+oKYN+R8drtq5+F4QEei4V4x4ZTV+5+wZka/7KXx/QqbrBAEzlDCw9rakqRCatfsQJskaFo75bY6RcniIfnbmjAJgoGPK1jZd9n+IN1Aiu5yPR5/r5tnhV1Sxy6v2j+Aw0zksu1gKs4c7TgyfgjtmxI/4s=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO1PR10MB4547.namprd10.prod.outlook.com
 (2603:10b6:303:96::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sat, 25 Jul
 2026 20:44:28 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%4]) with mapi id 15.21.0181.016; Sat, 25 Jul 2026
 20:44:27 +0000
Message-ID: <79ceea04-7fe3-48b2-91bc-48b208f10229@oracle.com>
Date: Sat, 25 Jul 2026 15:44:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: Fix NULL se_tpg dereference in
 target_complete()
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, martin.petersen@oracle.com
Cc: ddiss@suse.de, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260725165818.769963-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260725165818.769963-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH3P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::8) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO1PR10MB4547:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f861c2-ded2-4d1d-eef5-08deea8d8469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	p5uAqKopCJt0sEy90CXXoGaJQ1F8jJpVDshvV/TEca1pwRj9gmLI0QcIZAAhbuXMgsFNKHLilmeHEoxli7+naU6rvhh7L5MVUd8iBYO3i2jflWWpHlrwYQajoluIctC8vxmDJnuNalKB3Jki/LvNCKvPV6/xnTiuEqo39uBkzR+Qw/raf1+NE9wxePYQKEA2rFNChZY0DE4u6JXJZENKVI6U8OvfbgBch1rvBmqZlQvCopS6BbFv4j3I21fRB+QLMN/Gxzwu7J/EghQNE8p9F/nZDGi2poOW0Nj21X661aaCM0jfKwRnuKhukoLg5OERNe17o6uxh78ciVIdwAvURaz09IzlL+/wF/FenlC17cImZdCxpqCD5zO4BYiH0/2fabgfvytvH72q/h1WuQ6LrXcX6+DBxfMbqVa8OUREHpQuPOBGtF7fhUay2vYUkGVydeFqVIYdwzQxMKF9v+DcuAyHbppoEzSInPUdGl/YkSuHgYZcHdPyf40bMbzJlWURxNBRy++PAe92pUGiNLSdkG4kt40F3vgHabzbfBHelCRo4GH8zo78z29OXLGFpFYG8sc8X+Tpb/V8FvishfBLs+ONAOUjvqEenMyXx/DYEyGYrb+VUAKYqlk3QuJaFDoSyCnXzYekIo8MBRLRZi9Szm7jwOb6bG7jxetwDUMoZ18=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnpFcXlTbFNYWkE4Sm9DazkrNjVWSVpHb0xSUVlKWlpvbFE3N1ZPOGhxSEcw?=
 =?utf-8?B?TXRKRlliNG1UZExjTFJOWGJnbi9LcXZlajlVbXJOTzFDZCtVNStJcWJGWm5j?=
 =?utf-8?B?OG9XdVlyUUJBMlowdE9Td1VoSFp5blBnVnczRjlUUXVVaUNSOE4vaEV6SzRK?=
 =?utf-8?B?WDRYY2FGdnNaTjErV2NlU0tqN2VYWmtFcUNQdEU0RlhneWpBSHZucWk2dk13?=
 =?utf-8?B?RVpvZjZsaHljaTNuS3VVZU8wQ1BCb2hVdDRydXRyd250SndPYTV1dkNzSjh3?=
 =?utf-8?B?ZkVVM3poeHQ3MHV3L3E1Q1J5U2RLeTVrTVR0RVM0cWdXRnhORmRTbUE5cUhO?=
 =?utf-8?B?TEZ6MFM2bVI4M0IwRUJZaXdiNks2aTVNamx5N05aYXRRS3NDRm93NXAxc2ll?=
 =?utf-8?B?ZWRUMTk2VGo4OVRkUWVvaStjUStyVUVSUFB4N0xDWnNTSVhaZlcveVdlcDNR?=
 =?utf-8?B?N0JGbTYzejJ2a1pXTVpWMENiMjh4NEczTlpJVzl0N2V4WnlKOHdkaGdMMjF0?=
 =?utf-8?B?YVkwNEprT3V2NEcwQnNJSUYvQ0tObHowRE9sU2FlZ1NJYy9jNFpmNkdxYk9h?=
 =?utf-8?B?ZnFNMW80bVpQOFROcGd5ZmREM21pT0RzdWhiT1grSW1VT3UzaEx2bzZpWUpy?=
 =?utf-8?B?UmpEQXl3dXBOWHdESUowMldXdDE4QSt2SGNjMlJDa1MxaFM0cHBKbUo5VXZu?=
 =?utf-8?B?VDh4S3Y0TG5NSjJIa2ZOT2I2cGJnZit4amYxRjllZEFiTHdUZjFSbTlTeWpq?=
 =?utf-8?B?QlFYSUxjQUE1TGhsZnNWVDU4aWVpV1Brd0g0LzVTM3FuUlZqeFNRNmtPc0Zl?=
 =?utf-8?B?VjdJK1dMY1ZzeTJqUVdLUEUxOFVwbXczc0s0ZU9jSlBWYnFzVm5EdklHSUY2?=
 =?utf-8?B?S3FGclRocXl0THBvaHhsaDZJa1I1MVBrZG5JYVZWdm5iZk9UNCt2c0x2bU13?=
 =?utf-8?B?bWc5SkErZU9haUNpaS9PZGZWQXRlZ2NxMnNRYzFkNDBGQTNNbTRoeUM2MGF3?=
 =?utf-8?B?QzIxWEJTbGtMMmtCMGFRN1ZkbkxxNEFBU3lYRml5N2xmTDNWK21vaVR3U3Ns?=
 =?utf-8?B?WVFZV3ZFZWdNUzdvemRDYnN0eFFvbGRKa3crQTE1cG5PNVRpZzRMeTFaejlw?=
 =?utf-8?B?YVUycU96VVFkQUwzaU1kRHlXaTlvN1FlSnpRVDBtMTJoUi91ZjBLYU9SaEo5?=
 =?utf-8?B?azhlUExLM0RmWUNFYnJpWFR2WFpmUTh1ZE8wVzNIbXpEVmJ4YnFpa3QrOTB4?=
 =?utf-8?B?b2dOUWFMaDl5L0hOVzZkMmcydTNNY29nRUZPZDh1MHkwSldabGFHNG1oUVJS?=
 =?utf-8?B?OHorS2VWN2pXT3dGSGZSVUh3NjQwbmI4VTlFT0Z1RTRuMDJTSEQwNUhhMHZC?=
 =?utf-8?B?YXZMSGdzdS9BaVNPOXVlTkpYdks5MTJxbmRadktIWC9EMHdKTlA4elVtN3RX?=
 =?utf-8?B?K1NHQk15NzYySmtQYnJJZmtRUEh0bnJHU3lKMWgzSjZ1QlZ2M1VEWTdOSy9j?=
 =?utf-8?B?T3d6anl4VUlhdmNwNzJWUlNBTHdKUmQ1blBRMmtCR3VSOVEvcUZPRDhEbmM1?=
 =?utf-8?B?RE5OMERUcFJXbXIzNGhlaHNKeHdPYW15S3ZsWGE4YmYwVHpuTnRzS3M1YVFh?=
 =?utf-8?B?Tm45aDdlVmxEbVc3bGRZN0Z2UndIRE9VMkJRTUdoSmhpaW9UUzZBWGcxcjNs?=
 =?utf-8?B?b2tyR2h5cUhtYytLT20yWFRpWGV2eG9HRU04V3Y1SmV3UDA4aEs4VFJHRTlj?=
 =?utf-8?B?S29RcG9sa3h3Nm1aUnBJWjdrWVZvK3Z1b2tVdk03MUZwdG4wMExJa3NJMk9i?=
 =?utf-8?B?SjFrMlAzRnduTDhxb0ZEY2lGbGVnN2lyVmlIY1VIMkV1VkdtT1ZBUUJDRkxC?=
 =?utf-8?B?c29SeTJ1d0FGaG5XTmZZeUdLT3VUNjJMSjdXckFuUTdEMnlOQW04NXhTKzhr?=
 =?utf-8?B?ZmxEbzBFMnJpSXAvbENwa09HcEdaZjJ6dUpxZmoxemsySjF1c2RUcnhYcWx5?=
 =?utf-8?B?M3BhMDI1TDZ4bURld1ZwRDdWanV6UXFJTjlWNi94WjdLK1o1S1M2ZnllNHMy?=
 =?utf-8?B?ejNjMndhRnQwcFRmckJTcmpubFFValU1eHI4RGFLeEFVSkFNVUlsSUlJQzNG?=
 =?utf-8?B?OWVxSGQxT09POTVXSnZIMWhPT20zNkFHWGVPN2szdzVFRE04RzcwOWlLMytT?=
 =?utf-8?B?OVNneWM4UGZENTVSdmVNaVY1bmFSdGRCQXFFYkt5V3JmNzVDaXAyVjRrbzlR?=
 =?utf-8?B?VHZ5NDk2V0ptdnJiY1dOWUVBbUhxeWJCM25iUkNoVkpCa0loTGJvM3YrYXFL?=
 =?utf-8?B?bjJMUTBkczM0cUtGWGpIOTlkV2R4U2kwNVpWZkRCekU0REdkMmxJdjVUYmFC?=
 =?utf-8?Q?LMJ2l/AiPC513UUo=3D?=
X-Exchange-RoutingPolicyChecked:
	bthSVN6lddMVPUynmqQO+yPOEZHfELFDsbBWzPp/Z4/iLP4zKYJp8hn25MYG7WDXp+TZ4SarU8cHzwuCI1xOauXMkdT2pjtyU6vT8nH9+SgDK+YMVZiigucQjHWm9e0ASer0eBSqm3/rLzACQq88rlmcG9J2WSn3IMqYE/PC22b9Fi+9S9mkDWBG7F5edMaKPgNWAYKWxjrSPa6qCZJfwbhjq5YzWBOd2Y0RfGcOOePbYh4r1sSIkFbffgiFe7HKU3KXHOuFW4FUrUK6a7qRCzHRaPBp0Yc9abs6Um90F5lzczCl99VgceKSLC8qjr4GRSTy+v8v3PTgDHijrKTSRA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FtqQPQpp4OCV+O0Ryw+IJe5XtMUHQFCiWNZGvh1V1N7nt99Xt0vZxke4dvHibSTvpqoD0suR+P3v4rpVO9B0JsGJZ2LvNjnSCDDYtc8je/irRSym4nDlUZ/26KtqW5eFqM+p/aQAB6sosf7BUBmT1werjytQTZItKxLolQWrem9QsLRodKiSBgERs4340/vYV8z4uBqokhp0mw2AqsFdYmQmi01NCc2lYuWTDZo6SCFT9GFVdBrQwlL1qtqmDD232aKybyTrWOh0haNzCAJR/TDQp+DNtJKr2h1Jxap+LRpqmmk+D7Xnee6D9F27JLS6tg6Vd/wkhAUb5PVfGPwItJDpR2ZMoRcmL655a6Rck0cusZL/Fmtg567TY2fwZ2V8Isvzg8ZLyQaVfy14FBy0bh4TxP5eDo0l18igMnsfbMzOuy4MQ/sD/Sfrmd1k18GBWoXcc7fCxOUt2f0u5t8yoirx9NBqBKawYFV9dFESEqrn/EQweN3+/e/9mTf7LYtvjO08Hjw6n7nq4XsFu1trjLudtXPvONqYhkXkttiY+bDDPGx1oS2Xn2PHoQXGQ7nMhQcJ/JKK+phSJcXyR0Fm9gqZMulvm6eLMg8OtkQOImA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f861c2-ded2-4d1d-eef5-08deea8d8469
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 20:44:26.9005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6k6EUWywGXQWTS3GNCAN/hljC1QCd+JNLxpebb2u6Xyh4aZVv48txl0lY+3HGpciESGGjZVSS45i/2bPDHVWKcip2/OwndBKf8wHwyBmPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=903
 bulkscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607250197
X-Proofpoint-ORIG-GUID: BQ2pBPGMqwHjS9JvIT1F2thdykAIIhGL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDE5NyBTYWx0ZWRfXxxAr9p9fYdhe
 jTTb7qARZPzAGkui3mUaYnlq9PADbwZqOVjFlhNPsPU4XE+oR85wLjXp1AuXSLn22bFy1v1VFSo
 fnKgM1QzQRqwPl+yNP7M3hhF2zfhwUgWWwuRTqrMg1LxmA+G5WtvRb7qTCkfXd0SZDwrk+yq5YW
 wCnDfbd9yoWcFL7txNayGU9CBJK7tLjvPIfgI/QZBf12xUryVaamdxdASxAP5TVNhpZEACma+2j
 LJ13K1OOSf10/eHWTV6/FUkhZWPdSlwiuc9eaNKg331vmgqzD7zV/i+a9UdGw/OkIL3zmWIeNDl
 8UKr7/gvi1UFdZwtADPKLItqV5H3LmEWC787hhDG5ck1jfKoFZJm/JddGy57zHm7XmLReRdU+LQ
 XcZPaAl1WQu4Yzr46xOVcOxFUnaQCqvNU9P/P7ew6rMhFth4thU/Jjy67ZCQdz7BWOWenNcI60d
 qiuM/1PCXP99OA+GT8w==
X-Proofpoint-GUID: BQ2pBPGMqwHjS9JvIT1F2thdykAIIhGL
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a65202f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=pUkKy5xo-yymlEuOJ94A:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDE5NyBTYWx0ZWRfX1IhLtwpN03EE
 KAo8CZYBLs1/mjtW+rj1Fu6QAV2iqOjpw59bSrGUm1sm6nZBURCgFw7IW1m9J3Arv8KlSxW0dtH
 +d5wQN9izqQhP6wl/f1MZ3pg4Iq9ID5x7DYm0RMCU5tnfHw2rP58

On 7/25/26 11:58 AM, Yehyeong Lee wrote:
> The same statement can fault one level earlier: se_sess->se_tpg itself may
> be NULL.  After a session is deregistered, transport_deregister_session()
> clears se_sess->se_tpg, yet the isert receive path can still submit and
> complete a command that references that session, so the backend completion
> runs target_complete() with se_tpg == NULL and dereferences it:
> 
>   Oops: general protection fault, probably for non-canonical address ...
>   KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
>   Workqueue: ib-comp-wq ib_cq_poll_work
>   RIP: 0010:target_complete_cmd_with_sense.part.0+0x17d/0xc90
>   Call Trace:
>    fd_execute_rw
>    __target_execute_cmd
>    iscsit_execute_cmd
>    iscsit_sequence_cmd
>    isert_recv_done
>    __ib_process_cq
>    ib_cq_poll_work
> 
> The exact window in which an isert completion outlives the session
> deregistration has not been pinned down; the guard defends the dereference
> regardless of how the command reaches this point.
> 
I think we need to figure out how we got into this situation because we
can't free the session while it's still in use.
