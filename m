Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071231F80A8;
	Tue, 15 Oct 2024 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729026856; cv=fail; b=iKreCrEJyJBT/dpq6b0cZdaisgx/7u5JMPUn7t3IggRredJYCMkwnoYYsmsvHXlDdoAUCbvPj14fjGDNMEICJhdZP4PcmcK1O+nH7RvStHGoR9tBOkbSQVEB5rxuuWyUR/G7XYhmD/cTxwJ+L41onhhuHhVGQFNN++JnV/AUgk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729026856; c=relaxed/simple;
	bh=UPRaP0MlkA4K0CjoBnwT0xCXmfCOAyxaDODq73UOcm8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jrAnsbO7aMZsCNvaAMmRC86vv88HePEK+uaN90ZenGrkqPXgLsgf7SnCts8Ni7xaQNuyp6A2Zv/dzcH6oNdDorxYCQyg7d81Hg71kvQE2eB46Sn+QByJJVdaX2QWFmox3VQJ0OUIxYjthHCaNQicca6Qm4xFLuOVDKm9PrYenyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rk5Woz7A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qL8ldHWz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rk5Woz7A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qL8ldHWz"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtfmA008287;
	Tue, 15 Oct 2024 21:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ogVPpp+kzbUsbJ7Auq
	Ggs5478vSwgzDTaiDU3BKUu6U=; b=Rk5Woz7AeTNORFMV/4ldmv6lgKaklOXaRM
	f9PlIKbXj58Eh1C9CK7h+ycThylJUlrkMvsZHwrwjn1KKDUGWtnbV35GR5daFc0K
	OZ8s0FLTZJaZrR/vR7RNGFZxBD08SsFfeOU4ZCBJgybh/ATHqaxDBN+CXrXH4i88
	6JvkmROWrE1QJJuUs2fOfqrkQzee/0U3k45nUnpO/1oVE6Ll+TN+7mXhS70jrf44
	UFcb1Lu0WLk378sB/rqzqwhGwob6I9mCQm7Vi3Cju9TmdwxWGWHfef4c3hWVhb99
	sA/a+vy+aKoAjWuZpYU/PB9j7Deao9ufjzwhTLY96kNQ4goORGgA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntaady-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 21:14:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FK0ph2019883;
	Tue, 15 Oct 2024 21:14:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj81b91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 21:14:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmbJdAx8kv/VDZZl0WGRUaZOv1v4TvUw52LbhHUwhnPK4fw7v6MTrc7k7w/NUZeFYVzi79tAYD4oErZs1zneSVj6tXa3+YLbsFVyQA4vytkfSOGs6jL3LTsiWdmWH5qU/1BLmHyvCzbugBmoZGi7bwawoGO4ZhflhCfWN/VzTvCCXjpdwiulaOtf0hMuH5dT3y6F9jbMGQjWTOl8lUTUXq/f5NByZRSpu93xxLApABWkrGR0dieNFqAbNwMJwy334V8gTpjVR2d1OtBduDT0XhxVAD4jgvf4gqVMXxzspjv3whop+js4ncTIzYq1LaS/9MLWCg+kYh7Icou0enF/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogVPpp+kzbUsbJ7AuqGgs5478vSwgzDTaiDU3BKUu6U=;
 b=Y2SGKT6fG2J2VMGfmyci+7CYcfiTLKjUMCXIIRatnUXQGp5UdBAh088AqeWRfZ7lwHKqwvHuRqzk4vmEYTb7bbqdq4z20U/KgtnEQmUe5uD1vWMaH7Q3Lh2SxjktHhXYaWYwP59FjNqjivHITBp9r93BSPRtnFo8Dw8atd8e5Kq/vqzywhKRYgQt653JgaGmWQkfOUaUFsZ7fFsn2cjLdn/s34IY0aSAkgL/2YTqFgjrTNA1m6io4A7uNtml/hrGlA9syBGf3ts/jozasSQ0EJhbs7m1fBtS4UWFhFYdm7HUWi0eBTXE3tpmxhcP/5JO/WRNEn2ixLVsjW1crpPkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogVPpp+kzbUsbJ7AuqGgs5478vSwgzDTaiDU3BKUu6U=;
 b=qL8ldHWzvMmNNteOYvlwLMAVuenqrnhA6v8Zbkp/2q4h/SjFVjrR797fn5jDHIaOTLIc/9Q8BAt8huXg42PNUXZw5DQBTV6Pa20pVqLfkqzdWpD5qi94V4BtbKJG/sUPKVMB4iL0DWEzKmIjTqb+oIr+lNeGFCKPgqDB5W0ZFTs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Tue, 15 Oct
 2024 21:14:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 21:14:06 +0000
To: linux@treblig.org
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] scsi: bfa: Remove deadcode
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240915125633.25036-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 15 Sep 2024 13:56:28 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ttddqdbh.fsf@ca-mkp.ca.oracle.com>
References: <20240915125633.25036-1-linux@treblig.org>
Date: Tue, 15 Oct 2024 17:14:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:a03:114::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 768f97fb-90cb-43c6-ccc6-08dced5e4d66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q7nqpCFgy5v7No8VIW3tGxP93oOnowciqFoZiwP9jPgsmP0Zp6J19Rm10t2F?=
 =?us-ascii?Q?2+r5DXUhM4ou+m3kpmkKITz/AtBVlisYOmgafaP6emGfP0jDDgR/YeEfqh11?=
 =?us-ascii?Q?xrJiWe8txiwoMntRGG33OaurNT78lr1s4gID7VXMSDmJSi3hE4A0n7keztCF?=
 =?us-ascii?Q?vrq/vDRGGlFrp2lVFFup12E0TUuzGC7v5VqgTOfpbOwhLV8XhEWdPc4+yN+C?=
 =?us-ascii?Q?FfIvqXoh/XxLN9c4GP1sj11BTx2ilo4IW6P3Iox+HmYo28OR5LCmZPZqqWy6?=
 =?us-ascii?Q?j2OapJ0smtq7o5OYNR/x3/3N2TP/rsnjlBTd+LTGqaWCWWWK1AkhAWdNaZS+?=
 =?us-ascii?Q?Rtp95U7QgW5mywQPkvm0rlz9gFBsdfHby7vEUd7uPkyfS74jAKiTvVb6jIrc?=
 =?us-ascii?Q?hwIjiyLEJae1zOJGb/WOMU0/0vnbWdrjqJycgqIiP9N2utss/bjyYjUscp3p?=
 =?us-ascii?Q?oTdhWeKnOLCH/nB2bz8zGqiEeRASBvg4R6WvINiN/1X85BPmvV55fXjE7dXM?=
 =?us-ascii?Q?CZ2ZXIUFB88RN+nBC6QG4Ti7efGav1LwxIfQyD1eJuiAy+3qTUyVj7jbNOng?=
 =?us-ascii?Q?G7+V9ODCDiESCy6DQOE7/gkFxySJC7FwdizMmziVJ5Do83x/kRJygLG3ShLu?=
 =?us-ascii?Q?VSTrjd9Xhh1RMizV7om181I5ovO2A7RjgxCr3vFT3e6U25s6g7EjyYsAbO1L?=
 =?us-ascii?Q?OCa+xGp13FMrw3EBW515aBY/YRl3igDBBthRnBaTOtaPk/EBR0S54wJraJhi?=
 =?us-ascii?Q?xEnp4e8aMb8vNRlkt9uvbyHFROibItfqy1o7e1gx6bsQEStoLJF6gMyPapFT?=
 =?us-ascii?Q?LsuAqcr1z4+o+p0U4JmTEGs5BGJwi3L642uMD69VkDgjKfF2n9OT+xW/MHL6?=
 =?us-ascii?Q?6Y+VIrYV4RUqX1iJ5Dl3IfvPEysTUm62HEZLP6OJQjra6E+J5pVmzOZagloJ?=
 =?us-ascii?Q?c2XjRv6gtt3PQeap7E0XJQMbpqy/D1uqGU+CNU7E23UwTZugiE3h20Bkhhb6?=
 =?us-ascii?Q?iN8q/52mWF3Ukd3JpL8CMLW5d2LiQlxK78iHgFi3LWbeAH9tuumVHRcso2+V?=
 =?us-ascii?Q?rmuQYyPvRws7/2DtO1t08kmPyLQ7QKifl+LuTm/a35zNMPy32oTng+UElRzt?=
 =?us-ascii?Q?KFaYWxjgyutF/1fLMOfA3XMXfDlk6guYqkiS2S8bRVXg7idJf16gCU4yEcfK?=
 =?us-ascii?Q?P6qAHpkK1em3XkNefewVV3cPf6Pz4AdM2g+VMaVy3u85soAWbVtdXqFEQ8D2?=
 =?us-ascii?Q?tEKhCAHf1NFbKxArd4MyMnekztcIM4/JvkKRF3U8fQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O1ceNt0ENnd3mFKyuooNekEPmm3QqwGKagYtuef46na5lx7j0vKxP439dFag?=
 =?us-ascii?Q?fuAvNz/aqeOPSaVl8jKjhxqaJOggGbSMRs0wUk4To71UDKPBGCMkAjLrGc/U?=
 =?us-ascii?Q?FvPmF0zdFMXR2O7TYJtmoY7xCU9dOzRRbPoFgWgp9nwXY/anejVQJB6TLY2z?=
 =?us-ascii?Q?9d94YCnPB4cKNY6TT3+w1gA5v62wqJJewJGbfL8TAiV2X9K1FOZmV6zKbihh?=
 =?us-ascii?Q?ec0mGvSNL3dTA6PuyTjY6FnISDqoG43bb9OQWkgzYcDSIpkCPlQv9vSvrWRI?=
 =?us-ascii?Q?S4Zv9v9y4l4MV1a+Ly7bMjJV55aKEs9GzrocxuDqY/XX+VdnyDGnBPDv5WSO?=
 =?us-ascii?Q?ln9uApOUXhJWlz5MJ4Y4w3fRMNESFjbZO2u23gorTQ2Rp/Gkt2z/CZveDrh/?=
 =?us-ascii?Q?0eA90zcUklDfQb0veIiY03CViSUg2aezmWzrf9iolnCGU6pJ7ahkaXOwFIb2?=
 =?us-ascii?Q?aTDXzvVMYSMU6bF9soWpw0o4oejiqNqflPVDW1MWrZ4KZD2jsLaYo1Y2YCuv?=
 =?us-ascii?Q?tUb0ROrI+ahRj/XzodeeRwni73TIf6Wcr+U15LEcPWOxHjmICFxDKBI3cfdg?=
 =?us-ascii?Q?Vl7xshFKrjBqXWXT5/qJB+OeSBKMbmvLkzxlz1+qBSmQGo87TBxDzoI4LY/A?=
 =?us-ascii?Q?r/DSbw3PIYzl+mX9kgQojdsqa4/VqYAHc/XtweVeMHI92CVhB1kUBosHK4RH?=
 =?us-ascii?Q?C1iA3CI5aGilXKoqAX/dbrw4225KbI9fyRx3FIzCB2qzTLb4/d3Rmey+3BMh?=
 =?us-ascii?Q?ECmyBdqEtSWeyKW6ieJRNap6hfGjf96kZLkPy6rT9Acp62dq1rYW6HlFG+Eq?=
 =?us-ascii?Q?9PgnLphjrxYXKZ9e9CV7xhiu9CnLcdBfsIXIOWjP5yt1Zk8gcFVdSwGFVfPO?=
 =?us-ascii?Q?weYUy6U3WH+3rd2PLo0zGIpLqHTPJN4msC+d/vzK1PzU21rZFHSyfeGislxh?=
 =?us-ascii?Q?N38d46pk4epcR5BU/aqSH8a8eE2wbPHrP9TB0Q0HFaWyMMsRI//kk4gmbDod?=
 =?us-ascii?Q?A71+5Kw+LSvUHRhBAOuEdyoTVv5AKVRB7fRFfBCYqPXhgtdqP3XQWz/ay1i9?=
 =?us-ascii?Q?dL0qleoiFKsj6ZTffEK3EvG+aFy1lbknHXqRgDDn5jLAmRI+PAP2icr5nPr+?=
 =?us-ascii?Q?XQ8y+zDXQS7Pl42V+G9SIRJ60YCbH2mmpJ0gtosTkGSUU3HEGpurbNeMZlyN?=
 =?us-ascii?Q?POhwquZL9nlH/WAiOhdKRDv4HP8Gz6QHgua6K/m+7w+JomdaEaiBVN73Qm1c?=
 =?us-ascii?Q?o+k33xp4gU6Lqs8dq7NF+YItr8bFaJaHwimfH5l2XrPFiR3DM2E1kg9JPCS0?=
 =?us-ascii?Q?zFL/Si/DK0nITUweQa9VSsU9jT9Qiqn+WcCAmEKQlKe2w8ALUcOSXStAXyjr?=
 =?us-ascii?Q?24BFFXEJyfLI8PF/4q5kHQ0xud242/YBwyY6+cJBYKtimyBCXGNvDuHkx4vd?=
 =?us-ascii?Q?qaQMdmU7t9fQlYttZQxkeI4meMTxNv/q66kZhsd8TDHq649Sz6dwSAWIxkii?=
 =?us-ascii?Q?iApfeXXiD+I7W2EVe1tXUdYr5MLO0GvghEElyDq6DugKiebcPy51eoaugw7t?=
 =?us-ascii?Q?L3UWC2sMv/XeAPqN/WriPI9G1XVy/63bZe9SO/CoGQmGXe/XXfNMdnnBTeLO?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1+wAKYFZg+IM9hfMeYlTiH0z3brnknnZhEWWvqHQHbSqr14yYb5F21EbTzP52PZllFHA41GataGpDh4qw5dYjV33ecsS/LcYR6O8AXFEnTIH63F9le2OC+aUhO00hQUTCytWgL+vASrKscSRkjNOCc/S0bGEgsjb11gOQ906pcPdr8x6COKcBNvVLmSS0VgcRyjlB2ASuDR7x3WFWVgaNtJNzqvanmdXmaKva7zLZOsH1wjJSdLY/jkfZNGrMmYJ02EUgyePobA9mKZovwNS6FnqRiOX5egDSOKqIIX1WCGqAmATO8TwdhnK9MtjNSHxe8uHmw/ahLnXS+7GX3ZTzeAbW0OmAasqXq7coeYhYvBCFP2ZcoEQOnDSbDpZmfrHmGtFRGBfuGteM7Sp7LV5iFcmiw9ncL5sgAEk2CkcMcqSpJqoRxneXaAW5WtijSue65a7HcNCNkvKJI78dp8I2dvy3nbysOMpMNzjPVVObEO4BhClLYB+15LoNBpzPX+Z7LW70r48YENUXXqiIs8cNrKxQvTgN2Tg4vheai0z8lx+v/Qfl4oWbf60rl9tQDWsycXwNz9fBHNT2n77xGGIkuu1wQ0H3IxiugCqZtr+6j4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768f97fb-90cb-43c6-ccc6-08dced5e4d66
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 21:14:06.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2ENq/BCb82CfIXWgiNQxrLX1uTjAgbn9KAF1BTmj54C29ZqWgCbtSxxWKLRA4H+gAnhKqkNdyAi6iZ/AfWGpc0wNfchbOwN7nN7449zVr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7505
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_16,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=578 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150141
X-Proofpoint-ORIG-GUID: bK6a1habKKlHw4knvXCI2bKoBcJp5DGZ
X-Proofpoint-GUID: bK6a1habKKlHw4knvXCI2bKoBcJp5DGZ


>   This removes a pile of dead functions in the SCSI bfa driver.
> These were spotted by hunting for unused symbols in a unmodular
> kernel build, and then double checking by grepping for the function
> name.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
