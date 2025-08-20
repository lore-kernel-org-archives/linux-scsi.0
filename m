Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A91C19E967;
	Wed, 20 Aug 2025 02:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656066; cv=fail; b=N1riwIbpraKLgxeD9/twooDqDzOo4ohbcY+ceOY5ajO4EXzFeFZlt7307rMchFENoZVRtl7q6CycOCQrYkCYFLnNjBxZMSIBUHFGgkqdYAueHz8wAm33ggbvL40N2Magl5cPLlGqiMgBqGZ8qHL15h6LJ0/vVZTrRPQ/1hZVaus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656066; c=relaxed/simple;
	bh=qyxf2WmacjOcD0DzkUW7MJIodNAzDX9rnulNPu4tWE4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WzB7mPHFqdke6LKkGidDlKViXADQxoPLLqEG7aX9aJ+nZj6MDK4C7Dq4MVcqMAwwz8ExnMHcWc6fhHqJIj+ZD1yfYMidVmRltLBjL0+mMohwcmKL3poTNgRxPB/jdOIExqWj1h3285xchY01aUQsQsJePJbObpUSOtYGmzybUP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PQjYZkgp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aYqfhsWn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PQjYZkgp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aYqfhsWn"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLD3Rx018599;
	Wed, 20 Aug 2025 02:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CDvrPMa2EC9mcjyxng
	BiAO/MK1RYQfVul7brMnroBOE=; b=PQjYZkgpzoyxiJqUZQ0XLY0JVOd/eQ4YzY
	/vpv7FULgdGBDKRCH505qpP4mb2e4HkqTkmc8OoAhDav8nOFd2/gu2f+k2Q0BcGK
	r1QmI931P+v1WPyMO18qqB+3tY4Ny5g44lhmj5tCeof11iW5Iy8tDXd6xvyQ6tYA
	vW5Hg+ejBq9tj+04DrozLzEUBIxrp1aHg3vib9ehb3arbbh/MtfmCrOw4iTrp3mc
	cds1FBQQwoHwEf5a0kQ5eAUpN27BLGcqhkYN0DxUA3nqWJfi32ea3toCu2Js2HIP
	XnPbw6MVFBuHOUAesKFDjJcBVmjFCEzCNKwUvnAo87Krf+dod9/A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ttga15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:14:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K0Ocxe027228;
	Wed, 20 Aug 2025 02:14:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3svjb8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BmMJmo8yC3PztRmhSabxOgasd2imQz9hqPdsZj7+D8C03vR/LvU+V2/TdXez4BdWRPsZHldzs7HKLV3XW9FTWnYrUs7W4iJZjw+R9B1UkOvGB2Nxkx2EE3ivA+zkfatDco91x5EoE+PtRvE1cm/7rsjPqeNYuRAIWwhMF/kSa4SSrqW7xUQOfbxJm5rq1WAGDsr1UHcysIoW/qo5PH6RyD/VRujIIFJd+ZJIeRNhAGDb75ZHsuxKjnZwvcfiXsApQq/EK72/xTiFnSgq7+mMhxED+D8BGOCdLyZCRQuNoQLUon+S9E2zmhZhxcwh3uroDUgvk1yL9GWIxjUaw0NneQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDvrPMa2EC9mcjyxngBiAO/MK1RYQfVul7brMnroBOE=;
 b=Ez8bf1yR5uHRggnLNHD6N3gIaMuZAjAxYM8S9JTBcPfAYYc8BzhH1xSfdeVmtWKnmgAkdwF+4QzMPEd89vVJNFOcgW00cTNCMHW/wL7+0D8828OWFaWgqri8yCrUC3BEkiLjrdVPJNXComO97xy8ULHJJ1zylR7DNV+PXXDDYk6wrqQ1/c9Ik9UzlRswnpmN/JnL0jfXFNeHAe1Nz9j74Yyywu7Vi7iAAMoRWtjWEj+OcCsvW1u+E3QDLuX5PJbQ5Q5kxsjNP76Scl+JG1aIaZ4kEXrUSVxMAw5GQ5hFOuv7fLbOFjXeFWx0CpweJS0ejXklJT0mHkHZUazd0Mvcgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDvrPMa2EC9mcjyxngBiAO/MK1RYQfVul7brMnroBOE=;
 b=aYqfhsWn5a7LkcpNtVj3e+GZ55E1KuUFOY4umcRoCEs7EBZfFwGx6OWo4Oa54pKIAy+pABf4RRP7E8mP6hkuk78oh1tcphSbW0ZJxOAStae3Fo6kNM71SjwSzJ/v93NdURAwmuOAaGuM83EnCCrOiZPSBALYqNpX0QWZ4qDSDy4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV8PR10MB7966.namprd10.prod.outlook.com (2603:10b6:408:202::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:13:57 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:13:57 +0000
To: Bryan Gurney <bgurney@redhat.com>
Cc: linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com,
        njavali@marvell.com, linux-scsi@vger.kernel.org, hare@suse.de,
        linux-hardening@vger.kernel.org, kees@kernel.org,
        gustavoars@kernel.org, jmeneghi@redhat.com, emilne@redhat.com
Subject: Re: [PATCH v9 9/9] scsi: qla2xxx: Fix memcpy field-spanning write
 issue
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250813200744.17975-10-bgurney@redhat.com> (Bryan Gurney's
	message of "Wed, 13 Aug 2025 16:07:44 -0400")
Organization: Oracle Corporation
Message-ID: <yq1ldnewxip.fsf@ca-mkp.ca.oracle.com>
References: <20250813200744.17975-1-bgurney@redhat.com>
	<20250813200744.17975-10-bgurney@redhat.com>
Date: Tue, 19 Aug 2025 22:13:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV8PR10MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: 916ec748-9fd4-413d-279d-08dddf8f385b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0OMEP//+I+7meKhNDfGLHf15USYEjoZ8VMk/26giZV8rxyxvhGfba6XgtLva?=
 =?us-ascii?Q?ymZznIv9SF74dY2FgtN3le2vJI5F+xrHM9ILBoe9dlU4Wh/IfBF6p5X1Em4O?=
 =?us-ascii?Q?M0k1RWksgcjz8h/T/HifAZRztu5CuPmrzpjA9ARpAROguBT2nFmBzhKjYa3h?=
 =?us-ascii?Q?UcSxkfcsUmiF1ChmAVbY13GqTqSbG69NtfmGnPWALtmKVASzVPp5y+Rkk2sd?=
 =?us-ascii?Q?wByW47eJYJ1lcOG/oKDpt7KzAE+N385jFpW9h4p5qFmeWfBOCaSU9MuQmG1u?=
 =?us-ascii?Q?wENQAIJ0T9CM3zLpeqpyYsa9YhPyEypbdc3CocS/W4pTuiigQ5byayHuns8e?=
 =?us-ascii?Q?hjQXV88aub+eDiFgO73tUNCeaxE8Ysju7R9xqymH1LkZ++n4VsQTsm1Mus9z?=
 =?us-ascii?Q?HHwWQn7QSlHbJcNOy21cWP18I47+zy0w3Km7FtqHx9K7jymLRQzKPQo7k+Tz?=
 =?us-ascii?Q?hkHfabpvUXY3E5huAxgY1xdATkzdOdXVBXWfvZfe6Rcp8JHRfNqOWFWgOCeg?=
 =?us-ascii?Q?2cO5aRgwT61kriBWlaqz8C8+CD5p0rPLsB10tMFvQCwtd68I9wAvFxVwJtrf?=
 =?us-ascii?Q?3JKgUHnMo5++JpaLq8ZG2p4EbaG/dqb/xqtUMYEkz0K5ULj6udlAc2ZP3vQ4?=
 =?us-ascii?Q?ZMeefdvPoFz28EbS1PxZGdgiJP6G3eqLLVH4dDdJhEpj9DM9VTHgEIkClCrl?=
 =?us-ascii?Q?6Kvl8iUZDnMnW3GB8YrfKbbJUhBNQaKRxhY5InWrgL3YmlPaM21vvjhHp6Eb?=
 =?us-ascii?Q?xhOCOrM8Rdub6W0fRPdYgmdkJTIEVqg9iZ9xo7cZrXYrKiOKrJNxWYYrO0fx?=
 =?us-ascii?Q?Jk8Zr5X+9F6ZeGwpt9k84pJEhI4LJMK++5nuPWDF5PvvGYdb2xscWfl5Y4l1?=
 =?us-ascii?Q?XeTBB1QUhAi9ybmkO6JUK6wOaHQirRbMDRqSmBMAI/L6ezLuJ1Wia+AY9woI?=
 =?us-ascii?Q?jd2PECv41lffMRZLZQ9BAW3cRK5A5LEopAwXpqyDgU1RHVg4PzpB33Hno7Md?=
 =?us-ascii?Q?X6f5bcBQ5j+H0iI/F/7f7V9oGCoNt0g/g/kVnZvFN8sUHbaE4FIMKmaVOyiZ?=
 =?us-ascii?Q?BU77QlFb1b1RloqbhkEemckhfH3pt8ZllRjsV7JG/llUzHWdZx+IqmEKGyuh?=
 =?us-ascii?Q?3Da4dyFLSviFrGsFX3vmXOF124spbnHLb3orjKoF8lJWeRzai3zJdR1UECIM?=
 =?us-ascii?Q?7A9F2Xn4QzaZUBN0Z2ptF9Hb02QpTJDo9IMk3YPat5k0Zy3MjgeHliC1SBGC?=
 =?us-ascii?Q?R/L2QEnPOg1f3gdcABca/0zYjM5mb6E1FmFsf6Zyw0fsMq0tOUPrjv7TqBwP?=
 =?us-ascii?Q?JZTbmyC7/z5SR8eez+pL+V+FS8rl8b0jZwCPSVO5CLPYEN+nHs/QuM9hmv7s?=
 =?us-ascii?Q?3A5dOilZvhcFAo0grWi8hGUciGb1IKm2nuMyKjsQ6TQ+TtGU86+30JMwPEOM?=
 =?us-ascii?Q?S3idmAI/XxM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1RLHsZcYxhgxHMTQBiVoX+YeYoq3qqeZ+K8hjqTMqIk2Ig9l9y+wV+5LmWwe?=
 =?us-ascii?Q?Z2+jSoVC5Oq44tZHDQhAVhkOV5K+xH42lELwHLKJ9jCw+oyzMbjshrI9XUqS?=
 =?us-ascii?Q?g1gixijVZozr3iAfpoOmeRFP3llLsFMME0Gfolrw5X1o5QFuIuW1ESq2eEJN?=
 =?us-ascii?Q?3nA3eMdcFwTtKGsli8V2C/Iqkx3xx/xROMBxzYn7Wii6QCmF5nY0ag08n58t?=
 =?us-ascii?Q?ubyXDr9ThVhA61fNRffn0uLmJ/a7MS0gCCoKt/SI0mz0UMFNSZTyhRJ07+Da?=
 =?us-ascii?Q?6QswWlZems5KNad0CYIHlW9NUrOJcKFXdXK1WBjkr2mVRB7i/zH2E0tnU8L+?=
 =?us-ascii?Q?g4fRoQy/4d1hy42qTDHz5oUW07asrmb0oX395BapBWMF8/EszXgSf39jnxDN?=
 =?us-ascii?Q?6qKWtnYvqbCuLUMpDZZQ6rHvBW4b+9NDs42vUz5CmpS93ga/+4Q+HNocfgyT?=
 =?us-ascii?Q?mwtzu8HIQ5/xjgLAJng1+5T1mpgLMT+ASD1qos3R40FspOvlY/QyDI1geNPh?=
 =?us-ascii?Q?RqLlCX9l4fFrnYA0vJ5LpdVXphj1cME5v9dtgMAe2dZmqVJd3rVGuGROZvmz?=
 =?us-ascii?Q?VbTmuKnreODiIZ5ORNwwUyzAXa4Zy+SjydZJVR7RnNqdlOtGVt6FDWqtxYAT?=
 =?us-ascii?Q?BnW2Ow6m+WA/6LhoXyQYAoq7s0V3k8m3LjR+xBI6VWlDGqpGpFmYqGoWFAWi?=
 =?us-ascii?Q?kQukprLdYhc5proyRijY4wnZZ7cwjgjgbFyIjXLSu5qypUDoMaZeziBzxyha?=
 =?us-ascii?Q?AJbt7I9ATlXhDXSx6PtlZTt3ycmALPYGbG4+qTpzB3lPNaTuvecdvE4MPHph?=
 =?us-ascii?Q?XJx/ZU2k/H3U9Yu84X718Ix1ox67cJ6E6tnVjkHUiF6urk4q4RLK/BNWoOH4?=
 =?us-ascii?Q?zTMlIEDfYEt/uFF0EQWwXMdQBg2CVYnCer+1SjNGBJviu0SAuvlOGkWJZ4/O?=
 =?us-ascii?Q?M++2YVOzqihaKMP6ll01zBo5cMlWzl76e5LHJTCWUuNm0rxB9aFf/ZJ/ytaB?=
 =?us-ascii?Q?qPDzyBZOH/LSR1sBEKBbcyiU+TRMRHF6URm7BYgy1FRfvR/TNqgfMsGXAnDK?=
 =?us-ascii?Q?IpTOZgp2vznJJJU2J0cwbkMhgFCH9m7I4ga5frEKPprwk85PtsvV9x1FWEDX?=
 =?us-ascii?Q?7qPxwljRgOEaPA1ndLXKhXm7IOe6MzQkip8I7mvdty6SQ8CbF8vrtLaTHt7f?=
 =?us-ascii?Q?qsZ2qu9VQeg+JdpBj4A8Ej6NUrBdNSFDMYrVMtAkfD1KOPJKqeCjiy5WWNIe?=
 =?us-ascii?Q?Oiy+jVm0GwjyLAM6n7hD9BUEUNRGtrUSlUF6gG0w1JmWfGrqQa833olye87H?=
 =?us-ascii?Q?FFEVLqZfcNhAC9D5aBQth0LUdVkHgda0tLZpREoSqE9DqDW0MNBUxE3fXnMw?=
 =?us-ascii?Q?aUUs8sAR4v+zj99+nk5Q0KIo8oKrOz3FGeZvrNQqX2ETyABNfpaG8ZXZYrW1?=
 =?us-ascii?Q?FoXymr5mMRN1ooHL2FcwZlw1WyzOe3earc1ywViEqzdeJ9zCwgZgbNU7MIiu?=
 =?us-ascii?Q?AkNXx4Aw9Ra/jfswmbT1CWgDk/8nQJ6YpSIvlQLqKnpLe+lnch232ahkwtFk?=
 =?us-ascii?Q?rUi+EnnYJ1y9V/jiJJkr8bbLznLWKnIvheNwFZUiljTn3L5hI9CvpMmnMPaV?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3PASurwlZQvHMJr/kMAvj7xZxl6KvmuiOU4rqFWbCyQQIBrFP0cNrXUHlVrXKcuVh58bzDDWozUDMz8v9ZxncuC1nay5oWJDrWUYUSl9qoIZqfHiZt+7X+9JqA3aOwDM4MfuuQoJ6DVQdEz26v/I9HxPEYjwMsn2V3wkRuShHZUZpczPVE/FvBk2ddzKtKkLRCHI+O0rXbpxmCa1JBFTmHGUPFU/BYgLjhjSfYN6DqAnqphK0FjjZLd6JXi13xrZUDZEFQE6RXKOkFVvBaWRXHZiWLc9faFc4vaD+h2c4vq15zJvtNqHj+ka3dN3/6ArIW4I69SUcoWiPoX745JXm6Kvo7Hw6q2awvwZMzgElshb7/Fc81QRgbJ+Ob+cECoK7wO06DUjAIySmSX36wQi1VcVdjBBXvZfkMQzQ76mv9sk9PLbr1IGm2ZkHwVHwNvfnHKybm+/grwUNNS8TSIlaOcW6OCPsqWoPotTM8bClKq+ZGbhaYj/WdqrdMJoGjPfkNKI+TzedqBpsTrFbGPuxrp3nG0TMbC5CgfuIsNqNI9DaZUmZHbaqdYs9V7OLhrL5tA2Pbdx55lN5WKh9k+umjEfDzCADF8TZanfVOYOOKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916ec748-9fd4-413d-279d-08dddf8f385b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:13:57.6451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDNH8oasEdSiqaTOxeKI6uyHI+wRDnlfSHagAGCdQH+XdQiWZzaxRVLyrrFWIKqhpsyGbhimOc4liKT5h6XfO72qOLVmgcCOtSkOd/QxKdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=754 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX/BG5qcO/kL25
 AVzml3NkCVwoh/n8CC7icypC+xa2kTGJC3r8JVFWxdl/P/9S40MEJ95dxD+lFcHoaRe/+SIhtFF
 zChPczLocW6Z1ws+qgndscTQITl2eIZ9QCgbsanbfqNuwbisTn5V5vcHejLN7a5vgZF86dCrN0X
 FNCR14QQlUWvh+lSboiS36pUbhDk718uYKLI6jgIQETiV/fQRny/M1a1vT2KmVSIS3wBakTQ3ZY
 CrTUlgrJUbTxAM4oh7/ZpGv98yuxRA3VfsxG4wcLmKjvs/DFeBzEbsn/CgM8F/4XsD7oTpoGU0t
 YX/6apBqIEt3HrzUNzxZCqQpwd18+y0uRLcLt52cqCMwT064R0TaiT4e3/gksBNDZGPvfj4/Pm9
 Tdvg/gEpyyON8g1nOeyCIbHg4tvgew==
X-Proofpoint-GUID: 8MbVWeamPf76b-OTuOwLH_uBlPYhoGt-
X-Proofpoint-ORIG-GUID: 8MbVWeamPf76b-OTuOwLH_uBlPYhoGt-
X-Authority-Analysis: v=2.4 cv=V94kEeni c=1 sm=1 tr=0 ts=68a52f69 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=cPQSjfK2_nFv0Q5t_7PE:22


Bryan,

> purex_item.iocb is defined as a 64-element u8 array, but 64 is the
> minimum size and it can be allocated larger. This makes it a standard
> empty flex array.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
