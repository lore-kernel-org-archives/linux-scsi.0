Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14DF125DF;
	Tue, 22 Apr 2025 01:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745285275; cv=fail; b=uKSik3AB1OmMMVKB7TjvejhSYDrEkkWhla1ox8KdgK4kqk6w0RU+ziY/6RpQdNNL7bQgFIV4K3VbJ79VOtXAWVn/NKonFYhDDalqIApvQkBnAf4NpJI1mcKR2kgBtbHdJGEmneBMcMjzbsEg/i113ImhVIQEm/rrvGLuMFdIgHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745285275; c=relaxed/simple;
	bh=hOMNpFBU47HvwRrtVRSmFsybo2I/XKPutCJHWA8VAQ0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=a0iAFQXFzOZ+/8dNe7uNTRs1VNbVyAvnbucgvJxSJeEvdkOgEw2T4QFfhubumWjZJeQG8KDAO2qTgK2JquSSKrdcoDs7QOfIOnqEOtKUKsum4Jr96RWsVxDDkqVYCZW5vi0gkAS/MA6rofDXDY5otAeTjV/uIIuoFgo95YjO3W4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RVFUD1Qr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ovBxURF1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RVFUD1Qr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ovBxURF1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0gQKp019860;
	Tue, 22 Apr 2025 01:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=xwE2klXjM31lOnPkFG
	k7yEEWuI+jULqmD2SR0Yo9G0Q=; b=RVFUD1QrYz898mYe3CnnRDEHgWtWHw9Lv4
	OnJRxWmmT0f5sfVMLxqYEVgZQvs0juppu84vcr0vJNSB2okbX7PEgzCqJzPmpw+h
	X+aT2OkT0djiupsmX/KsWzoL4JdqWwv7n5yNiBO1zRs08AIImlIrQj/+aQyE+RkR
	oMrAkW3ROEvoudfFK+lGAZE3XNWV4Qb0dQeA+Hq6NOJxH7CCwBSJQ6MKtvAfTKia
	QJhnJkaoRZgAweMANyHEay3hwN01IAQ3W5maEq0Uh0C0ZWGCHS1ZYZjEm0UZYmfE
	/1prVsVOh7J1LbXSjFC/zKKI8F1XjqV7K4IOw0QUKHUoSsOGqfQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643vc3jxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:27:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53M17Ipa002890;
	Tue, 22 Apr 2025 01:27:48 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011031.outbound.protection.outlook.com [40.93.13.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 464298qetx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YSdVixYZxMAMjrDoCkNpomZAEcFelx7stZKj/8K5lEWpCjM3y+kyH9v0EGb2Ch8+QSBqk+pCQhyP9NhxqvxAOBOT+ODFduBiCJhEcwR4beB4tBnXkjoKlG2MRO164Q+ju5v3HqayI5IuyI8Em8SMw8EEaAEvoVfXVIE7XqtHOw2dIdfOLxORAnfiC9zBRTfzePyXhobZMeEkG3C7lxtvbH6laQwMGtR9m0VzfUiWcis1Nr6/pMLt2jCf1MoWdz1/qykQ3lDW/E0On0ECXItgQ2hR9mhBIOLj2pl3rrDOpl+zz4DeXNSXwGnWUByIkXcFQoEQSv4YaEkSK5aS1sw7XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwE2klXjM31lOnPkFGk7yEEWuI+jULqmD2SR0Yo9G0Q=;
 b=ErwMftA5BICTCx4C67NPfYNJxkhud3yO82RX2mKhDcezV8XC6xra3qnLxPCpBLzxkRKWvHGF+AYq4owvEYteOv8yeq0YQAeyWo5WU9uB0TZHimOMd3KG8edKCXV6LgKshq8PPQW65Z2nMIQfgrmgstE82vWbzFYZHIraaK8Wd/Sl9F4I/ZRLAHDTcQS7Pp8F6OcYUPeSOTXfhr418QJWTyNOia6eNYjpTXhYMy9lFYfqHYOdzzTOlNbKyJIgNIfjHKCKb1hkAJuZmUqxnafyezXZ3mVRO2bHUktZrLv+zi86R3ptX/fKli+HSflAPSYw4QE3bpaG14SW5aBE+1BrWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwE2klXjM31lOnPkFGk7yEEWuI+jULqmD2SR0Yo9G0Q=;
 b=ovBxURF1W5+J/oGUu161v0e4p/s6MmS4XCAfuKYKAolVfLYw5SjoTqcTMnpqGZ5tDyXiOopy8Ejxz6N4yAfAFKQA41hGXpvodPJdxhn5K82ayVaK9q8KO2t+hbhFTq8qqPM/AxrAOrcUCSrG779nuD/HAFCXCDtnLljGu1oi9J0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPFDB252061E.namprd10.prod.outlook.com (2603:10b6:518:1::7cb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Tue, 22 Apr
 2025 01:27:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 01:27:39 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/4] CDL Feature control improvements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250418230623.375686-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Sat, 19 Apr 2025 08:06:19 +0900")
Organization: Oracle Corporation
Message-ID: <yq11ptlasv7.fsf@ca-mkp.ca.oracle.com>
References: <20250418230623.375686-1-dlemoal@kernel.org>
Date: Mon, 21 Apr 2025 21:27:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:a03:333::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPFDB252061E:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7bd3c1-f5ab-4003-7c9d-08dd813cde7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R3HsWDOM6+7r5GoKnIHpkktDt5TOD0oY92eNIhMixLb9AuG0kbTATJoOzkAY?=
 =?us-ascii?Q?nzHMTrRpUofyjHfFelpsZPUYQUF2J0ucdpdqypeG7HP2sCRSSFgCZpkeU/nA?=
 =?us-ascii?Q?4ghf3TxMgq5uJhi/gdUSITCybSSaBmOScZPjh4aramsNTZwpp64Cf9cwa479?=
 =?us-ascii?Q?hqKAoVU5ll5vi1vPmrssXBYQ0NRGy2efaYB96XBn3kKX0llcsBNaCCqqar4q?=
 =?us-ascii?Q?j+f2XxUowr7NaGglNV2IlIAfa1qCNENGWm7PzpyYsPuGrTL35LHxT74GhjWx?=
 =?us-ascii?Q?8Dsbq7mQjO/swtmX5vDpOLwLgWurlTG8jRUdO45Il0IaS+3ifI/SvvMMcyKr?=
 =?us-ascii?Q?nu7Ero2BMwXnpXib56jOK0QmAXKVmEHqILmmsTSNbRfQtypUOybm0ubphhVv?=
 =?us-ascii?Q?GxqANNY+zYUnw3z+Iiic3CGDBmaIv2kSASWGYaVmGF6nVA7DNmNVMegOX2bq?=
 =?us-ascii?Q?qPGG5KwAo1gALAq2xy4vZkFnBP5yxY62NU2sz7bZ2jxLZ8mQE3nr7TAyN/Y2?=
 =?us-ascii?Q?fMHU6kJUpCHLxS8AgfpSEMAU2fs45EHUxBdsLSn1NzbqxKb7IP4RR31bVZzL?=
 =?us-ascii?Q?R8sj0HhpgRUsn/OtWOjTQxZAbQjjxQ2o7Sy+MGBbZZpjY6T1te6RO197EvTM?=
 =?us-ascii?Q?1ORvoUrYwUWs2jW9vMbTu7sdiMjNOHqtY/AzoH3M5bbhx2+7EpJTl6ChoYOB?=
 =?us-ascii?Q?7O71+j5TFsKtsCFS0GdxokR/rlKHFf/0lV/ivb/T+7g9Ez5yLj7ddQfYFH9L?=
 =?us-ascii?Q?3EenhoOeIuEuOC/a+Dp8tVMvsWyT4ZzLhKM/zkgpL77lpNExPoI6gdNJQa8N?=
 =?us-ascii?Q?v2S/iboZkico8lcmiFsrtsdjwWSCLF6aVbxNSoMm6jiEKT7PQbYFFJ93ryZ3?=
 =?us-ascii?Q?nCM0E8/ammFwUqUEKS4mSjoJErvm68cW6SKOnfHRZStcmsJ3+rfZoTwdMU+D?=
 =?us-ascii?Q?wFdquLIacsk+mOa+UmGX4kWmRxifGfm9IAzGu/Z7i7LEs/6jwGfDAgydTK1S?=
 =?us-ascii?Q?jzdCbvjewGKubQS19wBZ0sbraT0RBOYEigEf2JjUvUWJUBFgrVZVAtGCbNrm?=
 =?us-ascii?Q?lzplatpiDKex/q2WTROuC+jvSI+UplnD7fLbDizIem00snMKSEOWwLSzFM+H?=
 =?us-ascii?Q?aLeN73mE0PUwKU0nMMhZwv5dbsjqHtQ+1eoXTJEQ1rSQLjkEItq4eTloNXaU?=
 =?us-ascii?Q?enQ0+EqGKEPKUF947Cas1A3WqXNRfIttYx/OkBXyMMT9Ggj/KVJPLl6LjFqa?=
 =?us-ascii?Q?qTvUme4bK52uyQEOvJlz0bM3VefZlbnubjdX4P82ZxuwLBGuDlyF/UM+2+YX?=
 =?us-ascii?Q?i011FowItw45tgS1eJ939yhgSTuIA/V5bydzhVkzBQNcz59x2OcU3Kc4iYE4?=
 =?us-ascii?Q?kCH87E7aFymgVX1lfN//osbjUm1/pdGrVanmQ1f+99omfFVqatY7SzsmdBZ5?=
 =?us-ascii?Q?z2b6wO41VpY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dXoiIFVoy6kcMI+PKDZojONOcDow99yUBk3GeLwdbf6Hb6fng4tVI2VYX6/8?=
 =?us-ascii?Q?p4YzBbqkpC32Kib2opm2hnT2i9QO+JjAuX8RzAZ8/nBbBtB1XJyl0X2N5Ntb?=
 =?us-ascii?Q?/p0skOzwOD+B4S5hfeSPa2skDNds+9AzC1EwPauQoGGUeCfB3LcGrieacyNP?=
 =?us-ascii?Q?d/4rcoArWhRZpcSGJjTmh5cgtsOlcAM9/1EVOVP3KlHpHk8raxTded2fhEh4?=
 =?us-ascii?Q?fDuFLom6M+XfQV8OM4s+dQTvlTkNBFib3mT5fDmoR4mi2qZG6nJumdjYgXLK?=
 =?us-ascii?Q?ZkfnzdaQf3SAqS4L95Yw8UyqYTnDbhMTTWgprxzA4TRcb5ES7B0TfMDx3/BW?=
 =?us-ascii?Q?jTSOHOgd5+nIvAAReJXcHKcruQBINikVl74LhUgZQSApRKhHvESJqPljCm/3?=
 =?us-ascii?Q?TxDuHCfudogIUm3iEHbtDbO2FGYmgm3KN4Kr8mmZCeEuXlX0ArDmYeEsZTJt?=
 =?us-ascii?Q?WZQ2EjqwObavlcntFsxG4EtYkfoaNL6f0Nj4uNyPbe4sE6C4FLpsE67Hkkjd?=
 =?us-ascii?Q?lDsd6H5/kXYQCDh3keucvDXkG26TNUHxyR6kaJJpgw815YYfzUrfjVZg8iT3?=
 =?us-ascii?Q?JDuC7Y0O+Ows38F2Drjskodn0n6s2l+N5K/0fC6B87aI27TyAoTo+CkvoLGU?=
 =?us-ascii?Q?SHuysIzm0/JtOv83BSnpHXblMYuzC6T4I31ILveG4biacIVlrH3mJxCkQ0f6?=
 =?us-ascii?Q?Z+pi3sa+7gKxuUnsqasWSzqPTs6Wm+jJqSiKtx5q22nog7dGCi9Ez+2f2H8c?=
 =?us-ascii?Q?Hap74VkGrf5lz5GsSpKT8XtOcN6zpp75WrukPeFkuWgk6QxRI1BLK1LDKhpg?=
 =?us-ascii?Q?vmF8D1Yz1sgscZ/VyvJM+BnB0xWFvg1ch1YyooeW/48J59EMkvXqW1EVI2MT?=
 =?us-ascii?Q?BBd+kmu2Oe7oZ+KIAQckF4i8s1I0G78nRoetmXU+W6TetmLNw4XvQaZoB0eL?=
 =?us-ascii?Q?I2vNhglxfkjsx5/6I7DlTRMg7iLFV/db7BvBnRIUB4x1JNFQbbHTv5IAkkir?=
 =?us-ascii?Q?12X9e/0kvpjeueUBYyfJs3mlvzcqZH16XOzoVHlFtMZT9Umk8e8n319kW30t?=
 =?us-ascii?Q?mw7xJGZXdM2xPnB27NVxnadON8maNI+jwQ2rtyyu82618y94E2ZZ86U+EefY?=
 =?us-ascii?Q?cw0rRd8Jz/uU3KGhAcX/h2cDzeSGLKsA42kwemvvtGNIp5XlsD7b+L9uIdsn?=
 =?us-ascii?Q?2576PksmfWafpGxkyNGWfN8sLO5W8gpndcfVjbnOOW/OfnAhhpMFmCICTc4f?=
 =?us-ascii?Q?d/9Yzq8hb3EusTgmqp+JEebJKzyymf3ZNgqZw9SEYGZgfvzfr/p+FAj86D8q?=
 =?us-ascii?Q?ol4H7iQdhGRyI1ZLU+qPZlXnfSNBW6VKTSnORBTZfA1qWYsNO9/cNzUD3Rmi?=
 =?us-ascii?Q?DCzpb7dGl+Ujk9pnGedSDAT/fdujs53pHkZlYrSTdtk8H9ayDMnZMNW3ux/U?=
 =?us-ascii?Q?5Snbh8syYS/gXa5wkQenwwsK7grHpAQ0A87QtDhMTszfrTkwne8cDGvRrVkP?=
 =?us-ascii?Q?SVEQ6ZS+Rb8kuzE/AStsmk/zPJ7pBCh/6qXhyA0KTmZkzxmd5V/DYH4qWm4z?=
 =?us-ascii?Q?5WF3QBwIZQ1rtBIUS4KxFCcWHlPg0W7xXg/5NrKEB+FyNcka5lNNsfrPDRRX?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hbDrKpjYnL1dWmP4YcMQSNuCU+w5wY6f7GfKtyC+QPwe0g5mBasmmQPKoVs/Gd8SNtCJxg9PNy7gxRuLtZHCmM4dd4rNesV11XjgBzBLUDA+TaFU9VZ5gjdOoUMsfRNX309CP5Bj12FfKsvnrHskauPyV8YHOz7z4sBR2//KspiZ0xnFcAgMFI6FJklntdS3EEyZ/x2RlPxSkQstF8cKMz/Wrs0+5sERQnBzIGOX3AfcyBF6W6GgJrsGujlJcjS0jcb6VAZyLhuRt0GukclnSCNgHDR9CTl4NsjrBPPcPnz8Rs2GtVDFDsU3M99OnoEfatKSHY6dJTiDsII1WkL6O1TJaWrhUxqZtBaWkgqVetJpvZsBIXogip8WVFMEmrRZ61+4rB5OPYMcqBYEXf5kBwDQUsOmrTrFXRTAwPdfl6Aan/Y79l6Jxwdtud0NhzRLvfS2q7PwQ26YPkMJeeSjKf1gOWf1Oc2Qc4YtSWyAE6cuxrgHEXeYoX9EEkVhsKiRU+cc7P9J/D5XHN640qcZvWi5QG6TfFMaqtDFLZq9plfX6D4X7PkuAvPB+4iG+ynmDeQOqfiB/VlHF6KzZ/X1XNVJnhL/sWuF/SzXicbNB/0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7bd3c1-f5ab-4003-7c9d-08dd813cde7d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 01:27:38.9190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4xxx84DG0WLCpAFVB/jl/AAj+kEBA+QW1QCU9eV2kb7sK0wkW+UDn4EK9L2bJMp4WyCIqEF2fiAubjTSVt2RVj0x40meBJ2LosMqewNx5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFDB252061E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_01,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 mlxlogscore=899
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504220009
X-Proofpoint-GUID: APIGzwYAsiqUXjsbjW-l9ZTA-11AAvaN
X-Proofpoint-ORIG-GUID: APIGzwYAsiqUXjsbjW-l9ZTA-11AAvaN


Damien,

> I can take the scsi patch if you are OK with it. Or the reverse, you can
> take all patches through the scsi tree if you prefer. Please let me
> know.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Feel free to take this series through ATA.

-- 
Martin K. Petersen
