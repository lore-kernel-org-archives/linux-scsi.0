Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44272DC79F;
	Mon,  2 Mar 2026 12:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452912; cv=fail; b=sfZ6HNOy8kPChpnh+j09H/MoQoZdrjCbUqBrDytFtIsM0g2tdAa72+qQCzCGPu6V4KZmHBlFdGmyfLnvWMEEKvORqBt0W119NTaUTrNwn8ksxk4UUAHXB5cwaiBK+B4aYmVvinwKU8yVlTRsaNg5UcUgDM7OC9ORczyHMGYw5Do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452912; c=relaxed/simple;
	bh=Q7AeJYR4E52R8ujM8GePXSeI1MBUDjoRPHDG7KkPO90=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DF+MyjrAu1OGTDNmpap9IOZor/h551HqVSnPNIxh5vcim/5T76NAg4F+gv1nu5E/XLGi9yEP+biuDk+xFDmDT1lR8WMGyB3m+IwFJ7kyMLS/npMiWkK0sdVcvoMkajRuVkg4G3fMo+Zx9pi9xVMsAV7ujZ1ei9c0C3/hzae8Dn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VhZamdYg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FXeujBjQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VhZamdYg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FXeujBjQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622BW7B21525681;
	Mon, 2 Mar 2026 12:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4hoQTXEPMIsjclF8+Ccq+6mSeIPxEICqYtn28z0ZDjc=; b=
	VhZamdYgQUHyWkJZ1zrjs2LKrY+HtOAMvoQ+CqgUGV0NMyoNocfB3GlgE0gvtnvh
	ZRKqozkGuFbgTa7/jz7XayYKBlfSs5h0c985DSu2YuaAr0InB0z6ErUCRwjodjme
	zsH91mLclqAFc7cAZmO7YSl+X4ZbBLsmWGT7Y3hqJKy/kZrDJAbHWAQfM9UhU5r+
	d8/zbiyf8LqgdR8eDWDrjqAukO/mwE1Wczr1nqZn/j+CVKbfW4sT/gZRc3TyOJYP
	6hLD43gXn9hAeXJpEKDnVJpQ7VcWJA/0uJXAaWI7JpbbcJAc9IfO56aOim+Sgp+5
	Z9zWWr6aKWPOR5XsOVhzbg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn9rjr19f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:01:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622Bthgv037818;
	Mon, 2 Mar 2026 12:01:09 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd4c2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:01:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEx/iLHmifiY/OSZ5nMieQTiKmXLMQqMljunWjMrtRAA0Pd3mOGfYWEsIUR5R4N9+YQmsG3e9K9X5LCqEmro4XPd5YjWegyfhoW69g7GD/ngy2lLRVUBu69Vp1b1YWzwkQV1J1avyDJyRKeXNGM8AME7psuzBuADjkNqwf1V1A0sddk3G6I+dhZWz9SevmLyd/KSkxQfI/IFhIuBKeyooUIpF+Qk7UfZMgoqz+b+yA9Y29r3SS6naKKGvjIV+sS3dqlqd4fop5IR3EpEhvv+RIQ63T56Ss5pB8mA3qI6Q3qE3yEhygtT/xO6/iEYmbTlFpFok5kHUBUHGKrKuW9MuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hoQTXEPMIsjclF8+Ccq+6mSeIPxEICqYtn28z0ZDjc=;
 b=vhC+e67lR0tkhYk31W2ut0RCtBiCTjRcoz/0ecHq165EYXPTeO4b+oiWWoYv7HuubNt37RKQ7f6KaIWK/UOH7V3bFWKFzVD5lGjbyPbircfKSTjndC9egjfnEH9JDyHvHAgZP6jiVZTG2KtW+4Johy24ZSex6OKSCReBey8tQRXV0yk4/TEkyRJ2aYZlQ8Lz1P44kVMXh6YIeEAerFRcuaEPRS4kyHn+Lwz0plzp0Sc0taVrdAfkAE6bsH+4vr6p5ZpXqdLVjj98UHHb/lIPoplaFXIEFM1NHxCRjVEXshgpT9mbTdiPtzmuWEuyX1/DAwnNCaZSKbV2Ur5DbgQpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hoQTXEPMIsjclF8+Ccq+6mSeIPxEICqYtn28z0ZDjc=;
 b=FXeujBjQBBGhW1NhpmYnvQxsyXG9e6Y7beaE6w+AD2chkdnH+94GD9A8bj+ItLXBzTRNL3ZZhoA3H4LL9TA0ze1qjKDFtXO6dndF1zC+bf85lJhuBkXKKu0Ozt9bJnsF+0vct9dRPVu2Q2Vw0TYsceZYmWFxl35M8SBPvgxL+rI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6874.namprd10.prod.outlook.com
 (2603:10b6:930:85::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 12:01:04 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 12:01:04 +0000
Message-ID: <e8403e85-89ce-4a62-8edc-1afe8dcd0c9e@oracle.com>
Date: Mon, 2 Mar 2026 12:00:59 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/24] scsi-multipath: introduce scsi_device head
 structure
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-4-john.g.garry@oracle.com>
 <aaT676hImMTt5tYh@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaT676hImMTt5tYh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0481.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6874:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e1ac80b-e28e-485b-0f93-08de7853614f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	/Ap5w1MYE3kw3sBYxC+FV8gBWeMwPDwCmdeXZl6xWmr3BnPY95DWEjpd0esHt+J/wkghslzrBopj6ufWc3l2dE7T8Kb4gS1McgTNpli4pkdORJiSfsc7i8rHt7/TO4R1CbHRqIN16l5VlYZi9jGPANLsTBEiqkTTTT+BNOkNa4gYw7iY8r2IGF/bfmk3hgLU7/C2tUQvH7q7AGGNrGCpcnsBytNhKnpPNXFaQyrvGTXzdfJnpis7FILihywJPe53gdlTDuWls6HC0U7DcoiibvFffumaNfyfrotp+43uO0ShZ6965Bl7N+pL/t8HDbsod+LEOUzTbKbhe80Ivc6f1BZcRiSGoELO+cXNPOnsOkM5Mj3PDb7RgvryDuI4tn0qWXsLp03ZgmWrAUQQPs9cHW/0lrb+zUa80LmprfAUn6f7cL3MqIWIuPWQA7oRB0FqHYfc9o45fFsGTCilbqcpAOQ2jRtuSpb52gNe4bsmFJ0qUfa42CCvyYwKTtB9CZt73nXGt6hx+kk8WAvua4LsOigDcorbkc9fHwn+mPdjN4Rs0Tbf46jVbW+n2yfxonW4vZz1GMDWtvM8p+ZVYT1inhwycXEvKbEtPMsBIC6yzVYwfOgTJ7EDMusXvJSr+LiUwQkuU0yR7HPTr3Qw122EicH5t5cAzz7m61r7XWn088xwtsUTwU/MV3SHl75AS1uLB/MusbmVW0eAGBoWzx/JQacwLhXRHulAfrGkzZQrzpg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXQ1ZlFQdXZhOXpLS2Z3Q3pGa0lMTjhEUjZYejVXamNnMWxWemlzZ2huYURM?=
 =?utf-8?B?K2lFWnpzNDFXdU5RbTlwSW9Jc3BEZG1DVjREUWlUVjdqaERLWnB6d0JEeHln?=
 =?utf-8?B?c2pldE5mb1MyRnh3Nm9EUnNpQ2Z1RU9FZ29tU3lmRjh6ZG5sSFM0LzlQMzhp?=
 =?utf-8?B?OGZKWlgxUm9xd0poWUtFKzNTbUN1Z2Y2QlcyYUNGKytad0JHa3FRM3pqRnhl?=
 =?utf-8?B?ZGR2UHM3dXowOXcybXJQd0hjSjVCMVRXQVpTYU1Cdk90RUR3QWxzRzQ1OGhD?=
 =?utf-8?B?b3pmdDYrUGYvbnJkd2F1ck1OQkZYQnowaVIzaXFxVlJrNGR4UVJodjRhYzAx?=
 =?utf-8?B?LzRzV3k5Uy8wZ1Mwc09LeFZFWU5MbmNscXlZNFJnUExDcjZRZ0hiRS9SQnhG?=
 =?utf-8?B?RlFneWYvMVA3OTcwbjJidURVb3J4YTVkSnZVaVErRG80dVVOODEwejBhWWhX?=
 =?utf-8?B?V2h1QWt6VTFEbW1pYWQ0THdBRmtHcU1PM3hvN1o0QS81TmxlUnB0SzIxTXlN?=
 =?utf-8?B?SDYxc1pGVjdwQjErTXJ0elh0cnN1MUlLU3ZlNEphMS9zVUlDUFcxYUMxb3lV?=
 =?utf-8?B?VmUvM1AzbGVJcVBRMjI2UjhyNmFRSWJBOVVKTTRvOTQ3cmhLMkNaZE5reGkr?=
 =?utf-8?B?bHdZS3E5aVpwamVNL2NHdUgrRW42NGxJakU4cS9Ga1R0Zm5XMXpyc1hmV0tr?=
 =?utf-8?B?cHhWOE9ZYTlML2YzK1Vndm0xTUphUUFGVzIwcTU0NkRtcjMvbWJyenZhWDlJ?=
 =?utf-8?B?UmsxU0hwVGJyUURIQ0l6V20vQXFMd0hwRVN6TmJwcXc2eEV3QUJHOUU0SlRv?=
 =?utf-8?B?bjZwR1pxR2tBb21BekZHR252dGlkZjlTNnZDS3dyVmlSMElrVGo5OWVjai9r?=
 =?utf-8?B?NldrWld3WU51MDJkc3lYUlhCTmo5dnlENjgxb3RUWTc0bVhKVkdyakpialNH?=
 =?utf-8?B?L0VSbmdzRThDalpFZE5wR2ZSdUgwcmV1REpzdEFTZ3dtNFpiOGN0amIyakxC?=
 =?utf-8?B?VkViUm5SV0FkRk0vQWVDRXpzaWFGOU9xTC9PS211MlFQTTBLTUkySXJlUndJ?=
 =?utf-8?B?cktLMEZaMkQzK0FxWGJLZjFScWNMZklJZ3ZsT0h5UjVqOXJocU1XeSsyd0RN?=
 =?utf-8?B?MVFmV2xMUW52ZzEwV2Y5NTBLU2pmSlhlZVZvb3VPcTYvZm5JdElSTUtkSHJO?=
 =?utf-8?B?Q2lEb2M3aDByNEF6M1lpVWNiOEIvVHJHSjVBVGpkUFlPOVB1a1hZeWxqbTk4?=
 =?utf-8?B?UW1PSFNUVTd1V0JDUUFIZXBVMUNYayswdlJ0MUVIN2VGYkdCeC9wTXlEOTJ1?=
 =?utf-8?B?RjJhLysrc0E1Yk43QkRGTDRrL1IreDZhMFQrUXZFNVF1d1NMcGwwQ2IzUHBS?=
 =?utf-8?B?WjJBSUIzb1lWVzNpaE4ybkY3MzJXdlJ0cWIvYXZQbnU2UGF4OHVyVDVsL3lx?=
 =?utf-8?B?NGhodEFOb092cXJRVGFhUkN5Kzd2bXJqazc2cXlLQTFvaE9Lb0dqNWlMYVJ4?=
 =?utf-8?B?MmdpQ2hQZC9yc3lUbnRwdHBYbFo2QytHVHZwbFpaZnZhUndlYWFySUVDRnht?=
 =?utf-8?B?cjJEc1VTV3ZjYmRKMGIrQkRDMzMxR0o3UGc5T082UDJSVy9hQm9ONUxKQk5w?=
 =?utf-8?B?Tm1jUHNER3ZDQjhyTmNuSVJ5VXBiUnB1dDE5aG9tRFJQcmUvQllrdzFCTEJU?=
 =?utf-8?B?amtJeHFFelVqZC9MMXJoVHFMQ21uekVlN09xYW9IWHg4ZE1xUS9YQmNqc3dy?=
 =?utf-8?B?clAyTDVFOHRVTE1waWJUL3IrcVNHY0J5T0QvRVBiM2x6RktnSDh1NGozdm5v?=
 =?utf-8?B?MXJkZlZwbWFWWUFVR2RHc25kK01scE1ETE5EV0pOcjBTNVM0bmJkS3JEVng5?=
 =?utf-8?B?ZEFLWXBiYWJkVWxWVmhzakpRTjN5YWZ5ZnI1OEJ6T1NDZjJCTzg4b3VuOWR2?=
 =?utf-8?B?ZWlUdy9tLzJYU1MvZkNFeXlETlV6ZGJFUXJMbEp0M2R1RjRTVGl5aTFWYWtL?=
 =?utf-8?B?Q2xTQTRpcy9mRUQzaHhxbEo0UFB2OHU1SFhSSTBIL2xtNnJtMHdGcnZZS3pI?=
 =?utf-8?B?OHVJVXg4QitXb3VoUFNSQm5GMzlKQXhpNVByalZxTU9yU2liL0UyaTlzMUZ3?=
 =?utf-8?B?SXp6UnU2WWpDbWhOMnlPSTFocklUYU9yTWdScmJpVDlwaTU1R1UyejViRGNj?=
 =?utf-8?B?Qlc5Yi9RRjVNUVduM2h0c1FGalA0eFBMWkU1ZnE1YkMydWEvcmQxUHlydmtn?=
 =?utf-8?B?M1pYR0MxM1A1dWVtdDdIbFM0UnJVbVRteGxmSHk5aXdqZkM2NXloZFdFUWh4?=
 =?utf-8?B?bGY4SFFZZm1penpWbWExcGxlVHphWDFLcXdhZWQ3S25mUWExdmw2UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NktGu88Zk2PQGHJsXLaLBSu9n81e1ZA3cmYvmd03YZA7XuVfQy+KljTjhBT1FsBEJ+TZ9C74mZUOlgRLH19Q6an7EuJccU7O93yGU7MhfCtl6XpiBmJ6MopWtWIrIuVQ/xu8OuGnSQTwsXBhHQPqGTUAC1GMwOAjEhblp5M3smTMNAGIHgmacWvTR2x/Y2eiZvBegEu5aHwDnb3XJ9UZ1AQA8VYrVH2vmPMWros8Dtq99xzTNvWP/xNQHJpLqRv8Ek7il+4fJwOsDlghIdSN1hwBrAyL/uu1SdRn/vEwbuDvRSnGwCshNZ7sKwGpeGTZrJRI7L98DbIvcHhUw/DxlRW45wAegRZi1QxEdUfBl2AFZkpQLnTpQf1imSngTo+/wUE2770lqcAp1rIR6oVF1IlhwB37/p8mKuPZ4nQeR8+y0A8WbLZvvS/LgTUUmVEpDVTyisR2DxDeGO0Dy5bX+pYJYPjLvCEOceUPb4cwEx+oPkmrRRC4dt6Qp734qLEfGSeujggQG3r8avCZ6naiWU59T3e1DZHd7ZG/ocgOLfs/O7rXdmAOVAsXOn87Xo9JCtHYXcMmJjJIYIxyeZWACgjx20xOYTn8BM/aOIZL87U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1ac80b-e28e-485b-0f93-08de7853614f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:01:04.5110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwEgt1KTjEpaNORFvbt2IbAp+o5/Y/VevM80RAjum7U2T6X2EcHu0JazVCBORLTJ1/eiMDrnnbdS8UTpEdFkOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020100
X-Proofpoint-ORIG-GUID: ilknonY1bi5y0xtQxZ2ngbnwP799qAy1
X-Proofpoint-GUID: ilknonY1bi5y0xtQxZ2ngbnwP799qAy1
X-Authority-Analysis: v=2.4 cv=LpafC3dc c=1 sm=1 tr=0 ts=69a57c06 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=La4qyT21iR7sqkRmqt0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13810
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMCBTYWx0ZWRfX8JCrzVvXpd9Z
 TZV/0QhnXD+aAXxeGY6L3m6+yP43Bxc+sdmDvyDYGssAp92ROFQh3dmL3a3xx645TAe2gGUFPDt
 4NPdCkYsS4yspoNZZJ/UqY40b//E5n3cObERvr5N/xWMvvOaItdR8KeWYtKmGMSzni1EUwvbIb/
 EzNuzoPZK8f2mHs0y8LIPOQyXlEV+EEwKSn6fijfmwnmAPeq+E3nt+vku8jxRVSQwiLItQLyOON
 TeG+jfkENC7PIfluEz9v7+AmQc2PKky3G1sTcyTdmvHHMfC+ep+OvnrRYtAMv/y+HW5jTK7Rmp1
 LOzNs6FJugG78NmeavZS4nJCm989ogRAviiox94/J7IFF+SLW7BtgrZ0snlYsZgkN2XSPVVCVa8
 OifmjNY0blJhT/r7B8NJ4Z6ynKIdHX/tbsaFdehymPUG7jZWWwL+33sUiRULNrXqGwrTXXXwExo
 AdjlVXfRw/0PSu7tIcggX89JNOG+mYevKWeI8ydw=

On 02/03/2026 02:50, Benjamin Marzinski wrote:
> On Wed, Feb 25, 2026 at 03:36:06PM +0000, John Garry wrote:
>> Introduce a scsi_device head structure - scsi_mpath_head - to manage
>> multipathing for a scsi_device. This is similar to nvme_ns_head structure.
>>
>> There is no reference in scsi_mpath_head to any disk, as this would be
>> mananged by the scsi_disk driver.
>>
>> A list of scsi_mpath_head structures is managed to lookup for matching
>> multipathed scsi_device's. Matching is done through the scsi_device
>> unique id.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/scsi_multipath.c | 147 ++++++++++++++++++++++++++++++++++
>>   drivers/scsi/scsi_sysfs.c     |   3 +
>>   include/scsi/scsi_multipath.h |  29 +++++++
>>   3 files changed, 179 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 04e0bad3d9204..49316269fad8e 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>>
>> @@ -107,6 +178,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
>>   
>>   int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>>   {
>> +	struct scsi_mpath_head *scsi_mpath_head;
>>   	int ret;
>>   
>>   	if (!scsi_multipath)
>> @@ -127,13 +199,75 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>>   		goto out_uninit;
>>   	}
>>   
>> +	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
>> +	if (scsi_mpath_head)
>> +		goto found;
>> +	/* scsi_mpath_disks_list lock held */
> 
> Typo. It should be "scsi_mpath_heads_list lock still held".

Yes

> Also, why
> split the locking between this function and scsi_mpath_find_head()? It
> seems like it would be clearer if you did in all here.

Maybe that is better - I'll consider it further.

> 
>> +	scsi_mpath_head = scsi_mpath_alloc_head();
>> +	if (!scsi_mpath_head)
>> +		goto out_uninit;
> 
> It seems resonable to failback to treating the device as non-multipathed
> if you can't setup the multipathing resources. But you should probably
> warn if that happens.

OK, I can use pr_err or pr_warn if that happens

> 
>> +
>> +	strcpy(scsi_mpath_head->wwid, sdev->scsi_mpath_dev->device_id_str);
>> +
>> +	ret = device_add(&scsi_mpath_head->dev);
>> +	if (ret)
>> +		goto out_put_head;
>> +
>> +	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
>> +
>> +	mutex_unlock(&scsi_mpath_heads_lock);
>> +	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
> 
> You already set sdev->scsi_mpath_dev->scsi_mpath_head right before you
> return.

ok, I'll drop this duplicated code

> 
>> +
>> +found:
>> +	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
>> +	if (sdev->scsi_mpath_dev->index < 0) {
>> +		ret = sdev->scsi_mpath_dev->index;
>> +		goto out_put_head;
> 
> &scsi_mpath_heads_lock is already unlocked here, but it will get
> unlocked again in out_uninit

Yes, I will fix the locking/unlocking

> 
>> +	}
>> +
>> +	mutex_lock(&scsi_mpath_head->lock);
>> +	scsi_mpath_head->dev_count++;
>> +	mutex_unlock(&scsi_mpath_head->lock);
>> +
>> +	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
>>   	return 0;
>>   
>> +out_put_head:
>> +	scsi_mpath_put_head(scsi_mpath_head);
>>   out_uninit:
>> +	mutex_unlock(&scsi_mpath_heads_lock);
>>   	scsi_multipath_sdev_uninit(sdev);
>>   	return ret;
>>   }
>>   
>> +static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +			scsi_mpath_dev->scsi_mpath_head;
>> +	bool last_path = false;
>> +
>> +	mutex_lock(&scsi_mpath_head->lock);
>> +	scsi_mpath_head->dev_count--;
>> +	if (scsi_mpath_head->dev_count == 0)
>> +		last_path = true;
>> +	mutex_unlock(&scsi_mpath_head->lock);
> 
> The locking of scsi_mpath_head->lock makes it appear that
> scsi_mpath_remove_head() and scsi_mpath_dev_alloc() can both happen at
> the same time. I didn't check enough to verify if that's actually the
> case, but if it's not, then the lock is unnecessary. 

It should be possible for different sdevs

> If they can run at
> the same time, then I don't see anything keeping scsi_mpath_dev_alloc()
> from calling scsi_mpath_find_head() and finding a scsi_mpath_head that
> is just about to have its device deleted by
> device_del(&scsi_mpath_head->dev). If this happens, the device won't
> get re-added.

Yeah, I think that there might be a problem here. Let me check it further.

Thanks!
