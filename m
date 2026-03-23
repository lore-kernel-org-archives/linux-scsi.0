Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B603AEF29;
	Mon, 23 Mar 2026 13:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273450; cv=fail; b=r+e5dZcicVEPB/2GT1uhRKz/1p0A0RpJgLUBNwGSTCpIcW1YEwq2Kn+BXx/YcZKeu90/wFd3nq1/JFC5G3OzTpya5SjIjjvmgMs2FzT1KGORkdLamJ2smrufTobOU8sXg3po+/JzPY3WHmPG21QWmc77Iws+l1H0Bp0r56cWCTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273450; c=relaxed/simple;
	bh=PnNHAlxVdc8qpDzOcAsijPiRg8Wylxj8Ix4E27Bg5N4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ktvG9sxodWY3EZrOcBb4Ltmt3HfWjGtuDU31M/vtFUfP+CAycmC4xqwNumrstbJkOvtoBm0sH3pB3N0iyrZ537n04672BC0VPtywd0yrvjpoHowGIpxTubiUZ2JYC2ge0lsyOis+JajHLSy+buZGMxCoToaLCQ/wKlSM3A3VQyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CP39xwkS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nN41DjTq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CP39xwkS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nN41DjTq"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MNeUf31554459;
	Mon, 23 Mar 2026 13:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2P7n0l/4h15hlzF3lVCkT/utDi+kto+ljq9iW4Lb4gY=; b=
	CP39xwkSC9xl5XAN6AnECiF6S8mXXkAt3fKQMwPCe0z+3j0uQdQRyK7PpsoBkjUz
	4ybNUVQcxQrgzwExyTXEESZA+OsG7TZgpxmRWZlPeKpIETBIPwomjPnp5Y/H0zMT
	JcUcL7uCO80J4KqTN4yrltY3+qNcqWYCdsnBwwzF2dpQ0xeRARHBQSGpMEeL6s4a
	Y261Ms0W2p+HoE7WsX2Y9zMhjXIVUluNGA/dEN9urcITWBheEXlKa223tqOGZ9hd
	l+hvX9sOyRHW54tdvpJi0kdanFeiN5ae5IVjfPpVTp8IwD89Vab7x+RT70gVJAWQ
	FJAAafpCiUeJoFiwLYBQOA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfpj9ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:44:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NBffa4038856;
	Mon, 23 Mar 2026 13:43:59 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8jk68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:43:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GILnzVAKREU3dDLfLOlD6oYMMTyT8ZK647Yrilzd4PR5smWTnuDY6AeNJOrnFG+nu8GJlMjJqeeHOuus8OlUDBirpd7hfuyi1Twyj+AOsDFHr8mFjnE+GMTUgeIomWJH/KTLI9H4n/iMUPBsEyWk8Ehxg44eX5lK6qkuskecn4w5OSREn+Sb1AqB8ietFduGnI73WfMSDW6vs3M/0zd5U/cejUy7T4RvmgmzfH6u83s1f7fi+aJawVWHLv0hD+6tlZSrWON+hlcvqm/cbxeZPePzElhSl+BtnJ4LOgUj4elHqYU8oE03oy3VMOLBZbCX4xpVnurG+M1Bhei32GlKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2P7n0l/4h15hlzF3lVCkT/utDi+kto+ljq9iW4Lb4gY=;
 b=mTOVAzTmnkDRjYtKSZfBkG92SDF1lgszqLT6yiDySEOcXAPE9tt2bcV0O0XW+KSDq88a7wrsWmXGQfrFTM4joGj4HqZ1KG8IWtbbJJZ5ZuUEk6MzysOsKp9+Om+LmfDHZAf0/bWYkP3+7cDdjOs8ECqTQT5WXGo7KWWSrlQYdqyJuIjgS1qbkJ89wN4dH9tj32LEF2F8MWM8NuZIRQ4TwASbI7iwG72ZeKcPpNT6iROOG/rECMetHvdje62mC6LWaAkTjoorFz50HiIbG4Kt2zxCDz2u+gU0fOPpzCNrrqnKR/BU5QKEKAn6SstfinglLeqZZro9uN5XaxoLYf1eDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2P7n0l/4h15hlzF3lVCkT/utDi+kto+ljq9iW4Lb4gY=;
 b=nN41DjTq1vB9FWkeUA7PTGXHlhyyRH6p+9TMfJU04LJ1Vltg8AY/b49GBZ1RHdu3/9+tws4mnmXruYhS1AG6nwiHvoYGGDRKvhIko2X5fHblZpL8Ndbydo6+O3ZCs8yX7mKciQsxR2VjWz78Ii0mKrM61jzvTrRGnFwM1Q46ric=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB5155.namprd10.prod.outlook.com
 (2603:10b6:208:320::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 13:43:55 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 13:43:55 +0000
Message-ID: <1fea7d5f-bdb9-4864-b28e-cd46652aea80@oracle.com>
Date: Mon, 23 Mar 2026 13:43:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] scsi: alua: Add scsi_alua_handle_state_transition()
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-10-john.g.garry@oracle.com>
 <1f964e4c-8dc8-4daa-8ef9-25e053d065ed@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1f964e4c-8dc8-4daa-8ef9-25e053d065ed@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0036.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:58::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB5155:EE_
X-MS-Office365-Filtering-Correlation-Id: ef34365f-ebe3-4bcc-1c63-08de88e23a30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OjPsUDL74VHFD/yrEuKnm0c3cbsMEsdNmIA2Txc+FzLV7pOkfhlLs7cUvw+DEHiKurEALxpML8Xckqb+GxYPIS1OaQmKEqWL4FyJxTddffSed//SGGPBwZ7BjrE5P4p7kWe1JmwNi5iu3UrGOKD9GAX+ez5uNg0HZcc0cJ+R5+7rMbb3oN1yCtT9H8vCRZMIHgz3c/f97UhjfMVxVTqkk+o4dNWrX4bTFbgsiyPk/JYp0JgVE3D1Y5ISnumi08YH40plgZaEjVQ/fEU3SaRDxcA3w2K2jeqKmBK1AQ5E8lMGZJ4sgjtKIqZ90/gGnI6SxFO19neQSDrUV9K0ph8zVdYvFkDYXzfhMKsrF7p/hGLbExU7Z4nt2BzDqVDkMScuE8aq35VYX7IOHAmW5XaLtRa03UNWgm9rhaeoi3JDIpSFyHzHmTWuhstzrn4D3Vrb4pFfbuO/pzX9NksFXRG5nZ11zf0gJs1ZymvzUM1a1Ydknap0zbEtgfu9U2XEDKjAo1QiiDCaGGWygSaNtReT73o5NHnJnQ42+I7BRNM2U1y6iW1JYsAPxBHD20RGJHOOZKq5lrldSj0AYNKDdd+URzLqwhbDrMKGH2uKHVRdfKYIM+2mqURnqj4NZ5yorGn52SEo2sWrNKhJ2C0HccY6ICDRa5Ng/bNNDPq2HtLkyyMoNVolbfKgTpYOV8KW6K/l81evKT1q7pPMgkyTcO+UFCY+QArlDELTxRaTlrTulcA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z05NMFhlYThCZDlCY0xzMkJBSjFVUkU3amhmNnUvZXltT0s4RDkwVlVJbk9T?=
 =?utf-8?B?bmluMnp4TkRlR25jY2p0MGVwVjFWVVpRcFgyemRJVlpXNEYzMkUzb1Nvdk5J?=
 =?utf-8?B?QmZFMlFDak9UMkwyWGpjM0ZCOVRFZzBubzFhYmgrL1Ayd0FCYkNZUzVpSUtE?=
 =?utf-8?B?S0lZMm9YUVhMRDVYU1JXbGhwWm9nYWI2K1FIaCtQalIrbktiTVNkcmVpcStZ?=
 =?utf-8?B?dTBtSG83NjZsalVSV2wzTkk4Z2RiY2VVaXBYcFdQZ08yM2ZRZ0VBcUlYVWsv?=
 =?utf-8?B?bmdtWXRDaXpsOW9NaVBxU0pURmNqSHZZNnVFcWtFMDNEbGRNOURpOTQ0OFZ5?=
 =?utf-8?B?ZzBkdGRCSkxLSDhBRDlFMHIybGs0QUUza2NXNkNXSnIweDQzbzJwNklacXp3?=
 =?utf-8?B?Q1U0TkJ6NjVJeEUzcjlKU1JIZytFMUVWcC9RQXZaTkswZE12bUc5TnlZeGVv?=
 =?utf-8?B?amVZeGZPTU15RGhpMFJhRHdKMUY4Y256S2ZHeXgwaWJLWXVhUE1ZRnByVG83?=
 =?utf-8?B?M29OaXYzZm56anVmd1Z0cDRCWTFjZ0Z6NU5HQWVocFZmU213YkhHMy9oL3lj?=
 =?utf-8?B?ci94SmFwSC9NU0l3Z0ErN2UrL1VYQUtVMXJjdWhrOEg1ekhOcW1POTFWM1Ry?=
 =?utf-8?B?VHl0YzltbmFGcjUvRlE4eG1NU2xLUWpydWQrWFdadnVjMDU0UnpHeVBhTjRM?=
 =?utf-8?B?N2tmT3JYanNvdkVCU25zMEROTEhKTmMyWXJRUnhjcVg3WXVHVWxyTkI3MU52?=
 =?utf-8?B?M0MwNVdWWFZSUVlDTUIvMmcrcWtzZUNtcTRGY0RuZzZkd0tpTnNRbTJoNkN4?=
 =?utf-8?B?WnB5bEpoWW4xTmVoMldpVU8zWFlZVHhrTGV6a0pNS3ZGTjA3M1VZQUhQcTNx?=
 =?utf-8?B?RXZVTzJldmlYUjRmWDZVQ1o2WWMrZHZjNjVoQkViZGlFMVJmT29iVXU1OCtl?=
 =?utf-8?B?eWhhT3UwdnllUGlTMGFRcWZiajJHSmlxK2t5ZzZEa2YveTJCQnFJRFZURktz?=
 =?utf-8?B?c0xlK0JJV2VqZjg3dlVpYXg1ZXEvMmxsWTdZcU1EVW1SdkJjQWJ2M2FXcXd1?=
 =?utf-8?B?ZW1TYXFIdXNIcFV6VWJpODJSdkRPcWxSa1hhckRHSXRhZUczb1k3K2t3c2Zi?=
 =?utf-8?B?Yzh2c3dicXJFUTNEaWgrMXlpWDRneldCMjlMUW9kMEZhd1dra0hJcjJPWkFi?=
 =?utf-8?B?ait6ODFFd2Q0eHNMcTgrMG5uR1A2S3FRUG9icEkwazU4MTdEMlpFM1ZJT2pW?=
 =?utf-8?B?eGxvSE5BUEZqRE9BU1JkSDlqOE5vWnk3WVU0cEk0UDVqSkxZalBDakU3aW1l?=
 =?utf-8?B?ZDVtSm5aNERmY0s4MlpGZy9HVlFhdVVOdnd4RXFLZ2g0bHR6WDl2eTZXZTlF?=
 =?utf-8?B?dnlmaGI5b1V2TlJUajZGTEdybStGN3A2Z1UrZkpBRHBtNFRyWGtCVVNqbXR1?=
 =?utf-8?B?VGRHaHAvbEV2S0lWNXY0TVRHTGtBOEtNZis5OWtid3VqbmlzVWtNcHl2YWd6?=
 =?utf-8?B?bDllclo3d21HSVc1N0w1U0VlTTVuRkR1dW1tdkxBQjNxNTlJOTF1OXZ1ODZT?=
 =?utf-8?B?SEYrYkVxOHd1Y2xBZmlWVXh5SnJRZG1WTDRTRklrV25kTmE4cENES2VhWlhQ?=
 =?utf-8?B?MzhPWTllZXhDaEUrMGtORndpd1NMcCtZMTBldFpTbTBIckNQUzd2RkVUcWVC?=
 =?utf-8?B?OFdPdFpmMFVsc09jSmkvSktCT0xLdXpEb1k4b2prbjhGTitKWTZJd1lsd3N3?=
 =?utf-8?B?aC9KUGxaUUNHcC9JQVFuUzdsYThWbkkvZHlGTkVINlFObHg1ZGlKSjlEN1lt?=
 =?utf-8?B?NCtiYWdsU3hza1JSZ1ZtNXB1MytXa2VOeUNqN1dhUXNLeHB1SitwUVI0MkhF?=
 =?utf-8?B?TGJGRmdQZFNleFJ0RkZBUVU0Y3FERjdlMEJWRlJvM1FmcjV3OHVnbE9aaVNW?=
 =?utf-8?B?VGY3eHpwUVhwWjZ6QjlmYVJtUWpqd0JBeFZUSWJNRUZUUXlYSWVpcVUyYUVI?=
 =?utf-8?B?cWVJS21KR3dvWm43QmF0VEhFQWdEUUtoc2JEb2t3OXYwWjlodmRhc3YvQnlh?=
 =?utf-8?B?bjVHbHUvU3FXL05oMlJDUmZGQmsvdUszWGg5OVZUOE05SUtmV25ZRkhlSnor?=
 =?utf-8?B?cEdZZkQ0T3ZncGtFV3BMNWl6emc2Y1FSRjhwOXhod0hFYmsvQWZYZWY2aVJ3?=
 =?utf-8?B?ditGYkVGc2htTUNOb29YSmNUOGc0Y0s3QXpqTmhSTzhRaGFPQjZncGpNMHN2?=
 =?utf-8?B?MTBTKzRNVW8xNHhSU21kakluWVpWWnJhMUVGSTF3RVFrcm1jMFJ6MjFqVHVt?=
 =?utf-8?B?NGZVU2pOeWxncjZJVitZVmpwd29laTQ4WG4waFFtNktXTE82a3FEUnhaOGds?=
 =?utf-8?Q?FN22ZHLBHfaKZs3o=3D?=
X-Exchange-RoutingPolicyChecked:
	oD2jQbh+fycX7H5M6ZCUAM0SLVHZm9qOrdTdWOYPQFnF2Tba6IJO0pzkPKFOsLDqIaBBlqYy6TZyiCSI+EX2AlfaaBm65yKynj/bk0BHzwlTsbGfjeZaOwHPpCVQN/nvfj2P6GCyftF4uRVRbGB0mxrZyQ0ANVRrkVgLYbXX/1yX6jzKyDp6bcnwTxAH2r5KLUTier6ZL12ayxrEk6r6i8gufEZ57RTXs8hCY6F+8319r5gOvy/bpTfg2nYm1oAWVqvLj4fzgv8iSdySGihurpL8gQx8HK0lpEhldEY9f/XWHD+hMoD11OmnMVJ+iiL7QotEJlYzH+xoS3pkzA4t3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ERrKMdr52xGOmDAuMkA+g6CcmlkUzMuW5XaagPFnftXwktLVwP7yps8wAgz8it58cx4F4H4j600vyyD+YX9r+pyRpkx18NapRLkrSWEfQ0E9FJTjgfWu8KLw5/f7WTOWKXx83HJKCEkuJvjCj2DARl5zvcAyr7pvucZJameb9mv3Pl/PB9occtc4OL1vR/bct6z4hVaj7ty0kKwXMAtU2Beg45DWXi6xLHdo0zjEG7WUZEyUg1sc4ba/n0X51LpGd2AwhVc3PsZ5SqsKNCe88kSeBj7Sn8Az3gaxZJ+v96RieThUUdCaa2TEskQFf7xW2X7vrhP+6EIhuArKhJV3lyKX1kYYQApypkNR862qob1AhVm72DFo+15je9jzrkHhRh+5c4b7gkYvb4zAwC8amW+gqqP7XKC8b+zLmclg4DAmktqh1ADjVGsSoThxGVoI8j5SmWaw+qvlP8bQrN/PEVzs1SpU2yHE4M/0jkLp512GCQwj12f63KQpGpr/4KZRfF+/S+uKZjqE4UwOHHyEqBny0q/tpDxT5m3DJlB5HQe5vfA1eJqWjMUJ+c+AjhrWza0KCViZwV5MJKPJGXEnx6iibZROa52Lrd1RWB20QGg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef34365f-ebe3-4bcc-1c63-08de88e23a30
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 13:43:55.5597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QS9pM8W3Zl7u+5jY9oHf7pFhKz0jSsK6/sDuBtdcYOApYd1oyvNp0dh2hAo3K5+OqbuI0z6tOXbbzCLtybiopA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230106
X-Proofpoint-GUID: QKv1RnFSLIaYV68Jzr2k27q4jBYXKnXq
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c143a0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=spEgapX5M81rVYHmYZwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13824
X-Proofpoint-ORIG-GUID: QKv1RnFSLIaYV68Jzr2k27q4jBYXKnXq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwNiBTYWx0ZWRfX6TScRnP51RxJ
 WwtWOVMrgPYyjZWsSs5PJXZ++bW9dvCMx/p7AO52xHQgm9Tkus2OxUqxjGskHnSAZreqn4+brk0
 oViNPdlx5PBfapEuk0zBFfbyrnrT+39h4NgEsoSk9ydIzDyDCqlVJM9dHDM6hacG8GVXQDW4QMf
 kaIVgSchyh0qUdIhkznTDsa0it19dJlwqTQ5qb3EGyJY1P6y7GYXFVuYuomOBBEnwTrivfaN+y7
 rRyI0/Jge7+zj6QwXGJP5doAokKUiul0l7D/mFRNTdr4oYPXKlxW9AjeVkOCimEY9Be2DWme1Gl
 jB7IzsSqbLoiMX+3smXVwPeWAF0hOkT4KrF3h8YDF8lJovSFPX22kG7SuO6H62mvg9PkQbLDuxM
 TTRajv0JaK9gvYmTTAC7V1uSNklQg/9+I+8p4ACfM/B04H5bbbUHDPAWq5o9QeTe6oYkYrnhkrl
 TPC7lOfUzQtYQFUghlQhbIdweT5UbIEWJqXJSqBY=

On 18/03/2026 07:58, Hannes Reinecke wrote:
>>   int scsi_alua_check_tpgs(struct scsi_device *sdev);
>>   int scsi_alua_rtpg_run(struct scsi_device *sdev);
>> @@ -39,6 +41,9 @@ int scsi_alua_init(void);
>>   void scsi_exit_alua(void);
>>   #else //CONFIG_SCSI_ALUA
>> +static inline void scsi_alua_handle_state_transition(struct 
>> scsi_device *sdev)
>> +{
>> +}
>>   static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
>>   {
>>       return 0;
> 
> ???
> This doesn't handle a state transition, it just _sets_ the state 
> transition. Please fold it into the patch where the state transition
> is actually handled.

Sure, doing it like this is a bit silly.

Thanks,
John
