Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A801734BA4D;
	Mon, 29 Sep 2025 21:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759181305; cv=fail; b=Vtnw2PbBQkULxJA469fIfvNGOZbqn1Ksjh2oK4sX4uclQzJEKAZz48pLwAny3j1da5Lb7SejU06tnM2O2fzEfxjcdvxnOE7zhBD/MWvh0DAm0lepXdPGnpcJULWE7wxPgEGohDGDNzo6jfzd5IiRpzHcmdmebfpFVUTxar9fG78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759181305; c=relaxed/simple;
	bh=7AN64DOhGvL4lQM1w8/geQhL/YkcFikpIWnRjuf1frs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eC4IXmXCK2LG3v1Ye8UwVlZpVsnTfufiC6aOq1fPaepwur7p0WoCeAxB3259ngeeWtNG4ulUzSDlnHSvnIBXxtFyhOH+dnekhEkDyRmjNb7SiFSYFIZMvur7eQWtyj64mo2Q0f6GmInpMK4meHMTQx/PSFR9GE+I2wCy7584U9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UT6SSIlS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cWV4KrM1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UT6SSIlS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cWV4KrM1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TK9bMc012008;
	Mon, 29 Sep 2025 21:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NJv9tp4En/jdXmR8/j
	8h75D85nWJWom8KfXrYGaqt2k=; b=UT6SSIlSnLcYM+DUSSzdT36KggOrVrWL//
	EQboOp5A787x4USt/6yRFnuvFJq2tK84AxWq3HBH/KnuFr+Z8svc9FbXV3ynG6cp
	ZtazmdZEEJGmLD+M5XIpMqcLCmai6/Nm0FAtYxeRS08xlXsiK8r785QkCA1H0GX9
	Hx5X/NXIMrDFAKUuW3ZBTNpUl20igu69B/wCtvAoC0eDetLZ8qJLJR4GKOv5do2l
	539c1bemSkDTSuqTtbtLnAARbYAPjETK+fwmw54t/tzaTe2n0zc8tXYPdtF5avwt
	ZGepE7PRPc55QDMa8DGn1dVI88lNqCL0nVZgjT0KYr9H3lOxsOnw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g0w9g447-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 21:28:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TKekCG027194;
	Mon, 29 Sep 2025 21:28:00 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c6yuw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 21:28:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPuvqKepNrWx8NwcUasif90Oq8TPkecpfXwbyKkI6E9p+SfWLp3vtEIkTDt4pxWiI9SaZcZ13CKNxHpNs4R4Ll2PUJ7wTJkSf+puih6Anu1espe0qymAmFULT3ZQ0n+NxbDl9EhuRjM38A96sir8Y3af13uDzMAtWjO9RPAtdFvnDJxZdjpAa1lkFVSg4K3r3jh5iTWndZDnG939vKez3J2z9AYFA6BZeNoFaX4LEA/f0v3Z3hlN0B7/aOhUSween7vaQ+nHUHs0k/bg+xmGNEnxT2GtHaKIocaAuqDDyE2Ql701V0uTaP3t0Qsmk8UKemR2LJQZ/8Sm6aQgIxIm0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJv9tp4En/jdXmR8/j8h75D85nWJWom8KfXrYGaqt2k=;
 b=rNh+YicA9O75HCzqssStnRjezTP/MM7JYVLvIUQg68w/RaluanTXEiQ+bF+R+ZAVRE5/V3A6L4izDCazMmxBODYbhq8FReK+qPyJyxqnEDK5BlSEDh1f95/vXOJsTsHwTcKUhONSaQvC03keg8DarfQC0ew0et683PEuw+QLcN418WY9s6Kn4gN+JRC2UU8p7blsz6OvR5h2sJzEA1vd/z6f9+IfTVuNqK9ouQlBv+0icOR+ImzTSOxX0bVECDeEle+bbUjuLb2wHd4k/lI6q/3mXrt1sm1GkbkMP9DaSX6KONXMOE3Oh3H5d2B/cM6z6NA7uPlj+bix3pz7VU8GWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJv9tp4En/jdXmR8/j8h75D85nWJWom8KfXrYGaqt2k=;
 b=cWV4KrM1YfnTSn+CZ/hqZ7bWrvj1hfTYVI6khi91ULIHDEafRLSzdEh6EEWyltes8LLrM3Xr9EkmIrbBQ2Gz0IztPupCKKIk6S7LtVzPZk3AgZE27gc1dZuw3z+8BfUViXFFWunosMKKbt5jWi9VKRA4xmaWvPSbH23zVnkPWW4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA3PR10MB7043.namprd10.prod.outlook.com (2603:10b6:806:313::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 21:27:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 21:27:56 +0000
To: Duoming Zhou <duoming@zju.edu.cn>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <christophe.jaillet@wanadoo.fr>, <mingo@kernel.org>,
        <tglx@linutronix.de>, <linux@treblig.org>, <fourier.thomas@gmail.com>
Subject: Re: [PATCH] scsi: mvsas: Fix use-after-free bugs in mvs_work_queue
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250920134201.18428-1-duoming@zju.edu.cn> (Duoming Zhou's
	message of "Sat, 20 Sep 2025 21:42:01 +0800")
Organization: Oracle Corporation
Message-ID: <yq13485ne44.fsf@ca-mkp.ca.oracle.com>
References: <20250920134201.18428-1-duoming@zju.edu.cn>
Date: Mon, 29 Sep 2025 17:27:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0125.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA3PR10MB7043:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b038e1-a264-4a2c-df6c-08ddff9f0e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yju0yzBkfswdDO4gJTLjXk+SMyEZnfqvjFAqu86oMMefKd9zfKmT1n6QLcmP?=
 =?us-ascii?Q?UBdD70eGtHsfIumw/3kbpcLZrbXKJlIUdGb54s73RDQ+UNVyStg/+0SYG/GS?=
 =?us-ascii?Q?fCRIViZzEz4DPQxwlhx6IeciZ0+Xy72IcpdxSowC6pQwDcEHcqWtQDiSVktY?=
 =?us-ascii?Q?YOBip6xZD7NsumOAofFp719uZ3gzQzVnqPqJsjy0zTQdmHAhoI3nb5DM6LAQ?=
 =?us-ascii?Q?kfaj4D2Py8YJior8vkV5hmS++Wtn0fEmpzdmJEIc3SKDuuHQnOOG2eOclh7X?=
 =?us-ascii?Q?VGQmlHf+350HT75niQXlshQPSFSXykoZxwbXH3YayMeYgZZhkJmewzfUSp1d?=
 =?us-ascii?Q?yl/T1sn2aYYe66bPYkEwloELS/S1ukuPJEmZLrohr5f2/0lOO6QYp5470OI0?=
 =?us-ascii?Q?ENup/egKvsnVGvIpMJ+aqeuEzAeeuORT8PEPCozFjqKNKfbFjY1t8Dzr48ye?=
 =?us-ascii?Q?1R/xPDeal8n+M2/7UHTNN0lAhGRZOHwErvsjnrArRDODcimpWFvxSDN7Gb1/?=
 =?us-ascii?Q?gj/fhtlfDmz+/76G0fsvO4NWw0kuNGwjX69oNkypX9cT4CskWwy+V/ZQwjmr?=
 =?us-ascii?Q?5rhAgy1b/kyZvCDm1f3qtxPqfode+637TxTvXQw+h3QT6q7vpm0vtYBzKzCr?=
 =?us-ascii?Q?ZJsh0z/12tlTy75/qwe528KKzb79rOU5MUxlaQ5uwCh14FnlKQaLmr1h5KHF?=
 =?us-ascii?Q?tIIlFj+gj7n+JRNYHMZ2wU5B48ow0OjujbS+zwRzfr6d6lpPlYsf4bPXLMbp?=
 =?us-ascii?Q?kP/1ODhTAWt9R2yUf96ybTtH9r6bCWl9zQQLxhd/xgO9gpr/gEOIbVjs6cdQ?=
 =?us-ascii?Q?Py2WF4ocHUaKu4OEmpOjqP3jCOZqG3vAqnNMicmT6cfJRlfswNqEq/NmeYHC?=
 =?us-ascii?Q?xfGBH3YWjtckNT74HeR19LNi5XuReJKFD4uUVwQDKKPihvB4hR5vIDievvHa?=
 =?us-ascii?Q?iKwmKJBAW/wo9h0xCmOMCZtYsrxyIQsU132bKQ+n0dESlcsP7t4xeLWCJAEu?=
 =?us-ascii?Q?IEEkew4t2wzx8obrTde9LuafTyAE7Z4eby8amHFz1g2I1H+e9xVu9lIIl01C?=
 =?us-ascii?Q?7j4VWFVmAoapLAPcVTiftsdnP9S3lT8XXvoPdTl04PHkfV44+UbFyOgfcgJU?=
 =?us-ascii?Q?bdNyiMZufAj7cZ69VIo8TueeRU68JiK26FfUMji7osmucNwu3iAihuiKgEig?=
 =?us-ascii?Q?VwtKJ2AvrsAIE5voKN+vgZfjX+bilkRTrbnvXQzZ5YxJhDfJJnQVuoMEUmjD?=
 =?us-ascii?Q?DABs0qhsnho+7ar3c2BknbRdTrOaGnYMBUIJbuChr4c52lsNTX9MIjMTaMPo?=
 =?us-ascii?Q?K8tqvQmEfYtS0Eh18PnnslQZ0WuyL/rQfEXG+nLfV+ZjqBR1OlGSvv5eE012?=
 =?us-ascii?Q?4AiRSKsD0jvalXc6Mgemh5NjrgugX5+jLEKDktqiZQDERCr5L6y7wA1plLO/?=
 =?us-ascii?Q?ZwlVMncLTXpXW3OCECRlCaGAcsi6XA9r?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RRd7Kg32dmqJFPZQzOYHkUi0DK/RLeEUp2IYtm494qmgZkVTAF2z7v8IhTxx?=
 =?us-ascii?Q?g/cLB8oyxdEBV+LeDB7Of6zDd7fGaBNQcQllGPu9mahdJp4hcRYTQt168QcZ?=
 =?us-ascii?Q?a9DPiRpZa++vh5fe7oy3tfnDD/DqIEmy+AlJf79+Qzajs2rd3iNeAwlxreNQ?=
 =?us-ascii?Q?AqRRXvBDGFjnbQpK4QkkGiq5rL6bFN2FU9t0gjyEr8rpQz5QDfhBEeQ3GfSj?=
 =?us-ascii?Q?XcaBpQoBq+Og0g/z7Pck+oBGR15okhaMUGkkYpo1HYlK14Tulm17q0KVJzld?=
 =?us-ascii?Q?ibYlqFJln+4hTyvB6Qq3mWwmhKOdNrknCl7+mGgGbooBr6vGJUyEsSQzYm47?=
 =?us-ascii?Q?6ttNcq9h1ebfHfRkhFpEHFwTp3hykb4IfQw39ev3V8tiIu933jUJjG6Llv8G?=
 =?us-ascii?Q?oIv1dDYlMv21JoDVbaY4PFQZPxvYWgtr3ssL/vE22gh9vSJS2iIzNwPYvcQM?=
 =?us-ascii?Q?SWXPln020rt3xCWGwCODqNuSc9wGCBmhsUSPhEy3KYo5iJz+Ec2E6S59qtun?=
 =?us-ascii?Q?C1pz8CcZf0TVUo7QyjCmDpqdyN30QT76j0YKXVtkpiaJZ/5RDzbEogB2tedV?=
 =?us-ascii?Q?9ssSBk8A9gO11DNvUJUeF+pt4YRjbS9cN+faoc8FsbLE1GWjF6rupXk/jEeM?=
 =?us-ascii?Q?/CqNiFf5Q1Y9W4KirYDDUhAlLW3N3pVjFuWpMe1VEGbNP3Ad+yiyRSqfLbLj?=
 =?us-ascii?Q?dmKn0qRIPg3LRqJpxefWL6p3HMpAVYV6qn4gcC8J4cEqgIBloA5NLNHf/FRS?=
 =?us-ascii?Q?YXNvpRAFUqCiRoRgxvePg9qIuCEgzmEBPBydT3llHw3zDfQyXnFw980WAEAv?=
 =?us-ascii?Q?64MJNE/WqA3s5Tr3J1KoWbfDlcLzo+ZJiA7VvlrFMNcTERikSY8btQd81mWb?=
 =?us-ascii?Q?sMAzwrfP1tutp26lXBqX34yIJjps5tZzxERq9V+rTY1Vml31IWUa9j/afmCE?=
 =?us-ascii?Q?sw2UfvgzRwZVU1LjfVVChGzQFZG+k1u89ZGbcpdPRMKOAhTllveCEoi01+u0?=
 =?us-ascii?Q?K1gRnYUkMwPU7wFilW7Ft/Xga6Nw4D47SvGGjkDAx16lobOBMZXapYnghtnT?=
 =?us-ascii?Q?GwHTMASCsSJYWLvy0tvA1hB8XWBa8bwsCEsaCSPJnRwVB2+CQvEihw5Ht+qH?=
 =?us-ascii?Q?UlHQBNDHi/3PO+CLn8JM6vqz8HzIP8chJcwKvltGDbD85KjrYmD6f7YJu5cl?=
 =?us-ascii?Q?YbbCNbkyHyC9jwBsG/IM+VLybeNi9VJWzDDMCBCyte6wR12nnk9x7oMrJyLW?=
 =?us-ascii?Q?OItYDAVLLb+3vty6HEtr9LKjpNGMDeoW2bSroyfQyWM3YQ5p1iZXG3XF46Mr?=
 =?us-ascii?Q?SXW8bKWLqKUkufWz+JiUv6Tn9Rr5RpcyVP9Nc/7g5K9T35+k8JBRDgc2xTT2?=
 =?us-ascii?Q?QxX9eomLpbOcm9FCbweOU1yf4fC1eqTHU+Kn4OAaFfqA0Z/PiBtHlGfyvEol?=
 =?us-ascii?Q?PWVi2VBCTmv9vwoYfoL9Seuk4+D4/kJYcvMukpsMrjoT5E41ASupEYsI4cRj?=
 =?us-ascii?Q?HemmAPyNI2KO5M1iCWZ5e4zSh1O6yyY2+VXJTFzKxo2tG/wYQSq8RlxhvBRi?=
 =?us-ascii?Q?CedmLee6gBNH/ilyLthUxH+k2xnErI9byO4OY+4ZACCr0CUT+ic/N+fhV5zI?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P6hwx8TrL9M4ZdFUR7fmjfis9sfES6MuSHMllezIcriMpDatApx5IAbz6E7E/pPN1hUD1xwfDw+4IIx+sW3Ircv6ArYgJH+6eABz2rsrGHZRwmbeLvIGLjSv5m11/NJAskXEaz2iPobW48/V+Xr4T9G+ARtBnL0PFaF9azpmxg/ExgGc3Hjo1W7Mb06GoL33QJYRmMeoVnadL1xICZeP2Pz5MaBOLNnnpqpsPuMOmjv7Xh+ljrvlVpIMj0IatPNrKGOcwQzzTjvASDcDhXgDJRycfJNNspn78J767+qPo2a/e0yBOTFijDBemGhdnzx0D5cH1TRHcZNwvzcP/rF/YJnOkYEXBRsVnUt7N12OxY84rI06c9HQynS4LZQ72RdenDMdPwVzK142zTEPsi2bTbIlgFf54gfh8LL55gcCeoXKp5xVNIqrK0yhsvmTXfxTsPPv71zOJcho/3wxLwVLR6Puk3+xJghPPrs5ol51U5ULnLX3gpwl18C3lHNkQCUF5RE76umBU7/Op0yWNJ1UZLzeKpMnUkzCrR3t4gZ4GM9UFmCmX2S6SMM5ipikQXxfkY+o8WE4j67KUFwdUU4vWnwWiwHhUAljioykv7bY554=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b038e1-a264-4a2c-df6c-08ddff9f0e4f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 21:27:56.4342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XySB/78L/jFFpkqfNF08mZUOEFhW9l0vvEnIyh4ayKYqGZBSabjyII3xcv6Qcym38+FBSqDH09ionmLr/jAhaA879WgFkb+8SsPrQKzW4sM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7043
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_07,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=806 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290199
X-Authority-Analysis: v=2.4 cv=IauKmGqa c=1 sm=1 tr=0 ts=68daf9e1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=zZCYzV9kfG8A:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE4NyBTYWx0ZWRfX+Z8iiPxEV/7x
 7MzZVC3fyLa9n308LF0aoVK7bIHg71Y9jRjb3k2Ox/CJfoAImwyITO9EmZd+hfxw4mHlkI9pPQ6
 jAIoerI1o+3ijdolcZhF+gtX1RdB5+7uy2hh0LiF8jrnNo5+z89YCorx0cLeNe30SxdOS12pv15
 MG930znTSW4JohnHd6zz7n+Vefx/k2MuB2bA1h8HRle69XKvEbiL172c1yNVtgRxg8g1tQbOesG
 28rnoviyf1z3+vxSQZ/BQZP1zLVRaQXQ9SJXP73FI4Zm5+IGQYrfjbZ4FepWQk80GBvy1hbXgSs
 x879XU6TJ8UWOTJi6q5hfklCxL8qL6rZIvIj8NbousX3XHLY/Vsx3muj0VLFn0SFvpoH/p6Kqra
 Fe2NERjH1AxhCYvQbRTx6hfesy9hrg==
X-Proofpoint-ORIG-GUID: 8z1K54dk202WiveSZf1kIPugc7nGbklf
X-Proofpoint-GUID: 8z1K54dk202WiveSZf1kIPugc7nGbklf


Duoming,

> During the detaching of Marvell's SAS/SATA controller, the origin code
> calls cancel_delayed_work() in mvs_free() to cancel the delayed work
> item mwq->work_q. However, if mwq->work_q is already running, the
> cancel_delayed_work() may fail to cancel it. This can lead to
> use-after-free scenarios where mvs_free() frees the mvs_info while
> mvs_work_queue() is still executing and attempts to access the
> already-freed mvs_info.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
