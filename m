Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39643D6A;
	Sun, 13 Apr 2025 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744517116; cv=fail; b=KJ5fJXqITqmxl5LIBXBzpxStoMAZZO1xTH5fd4zeTThbXuyGNPSbFvs6oE9FnL50gwHs9b6Gjol6xT7Y/8170aqiVcijysxGAuCpq3fTEnNh4fLZUwRdj1sKs84yb2CuVdtJlQrVv2XV5qJ3jWBhMLiPr8A8bX5YtCjh8QKx06M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744517116; c=relaxed/simple;
	bh=DnJOHvHVQX7/PYt0xbCywc7hK0vi78IimKay4yHFa9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qZvWl2NdRUG3oCQKq1auqPifU39s8QVOoFLOUA40crLA9MJMug+vUcE8g58rY6yvNljbcw9wcP36WEDGFLqlWFgzzAiF4ZdoGyZYjngrBdqBi8US7MNCaksmwycSsI5Jca8PMTu57qfqltPBxYMZ/Rn+zgNChlrNqyiDDqCKNMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FzTxnx3G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wP9g6SRf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FzTxnx3G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wP9g6SRf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53D371Pd010269;
	Sun, 13 Apr 2025 04:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vsAeNcwlHMxYfkhNJfjCs/p9nIgvOmgvZgNkgdYX8CA=; b=
	FzTxnx3GRE3vsaRhrOqstyMkdhbsdo7ZscfMbNN64XLcC4JuGw/faYLJSsgyLy3T
	RsCkIIw+8D3JfE0QULEEVW1OlxZykOF9eCoQdQTpoDuJSh8CW6yBa4TVzs2QGLHs
	DFjfjx7oDOycYwzRQY9OYx6iOQSFrIvX/G0wP/E1k2P7T7Jkp1A6TuBtqxh1r8r4
	tdlAtD2vOMRJsW7JOScyMa//NpSppJD8FDdPx4p/JwGzswkiVb9hvESWF7zo+WZz
	hToNqFnwKtnjenqvj67s4D+CDTKwKIrE6sTtmK/EYN/V3SnIHYOKgIe77wLBMtAI
	uqFl8xgHKks/zxgPR0qeHw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46052wr1fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Apr 2025 04:05:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53D3UXYK019917;
	Sun, 13 Apr 2025 04:05:11 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011027.outbound.protection.outlook.com [40.93.14.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45yem6sdhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Apr 2025 04:05:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXjFsECE6cMjXdm0MtxrnnZ8qaqKQnFpS/c+QD/BQeM6E0/ZZJAroJTPx0KSkQLfffRCETqDG6F5D+WtmDn+w5wJYgmGuqTCexaunBoqjACeK9VEkgcISmJrDcA6URFo03GNGLiRH1V6NTGspL+Kdynni0VfdtRZrF0xxG/W1m5m3iwHUEExk9nnnkw/P14hVY1ctqZ31XIrdosHh/3IzKVcFeZf3mYc54n9KygxvhkJ2W4U1DKobn4Tmhdme5w476Cd8Xo6Yh/Y4bgyiuhOL8mGyYQF/zkzDy9lXc8XrtzKLTHzYQ9TFVHmYBdEv6TR5FwL3IZXr3bCCMsOEqFmOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsAeNcwlHMxYfkhNJfjCs/p9nIgvOmgvZgNkgdYX8CA=;
 b=OZArD12q6p22OoMiXvQsVpYKB7jq6HIXE81N1eNXgBpXYa4sUlXyrHEom/IVOlNciOn1P6Sn0Af95Gq+r0uWI4K5/jyYvk+dIuSOCGGEYB2tsjpUrhzcT+KKWxYTYQ5LK74S8QEwjjTMR9Tkl6pAFcpP+xE+7e4/0yc+aL/U0ZNB3gUcfEa520ueyws5xTXZSI2HmxbjRoJc5aDra7VUYZ2t60TjygUPAVyhH5Ll+UuY8blPSVGkPJuZ4nzEL62zmt8wE+HRN85EM7EqdDUZuvS9v44E96ROoB2q262gF9U5uDQOiSYDxPwdxZQzl4I/RI1p466bD3nJzPoK4XTe9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsAeNcwlHMxYfkhNJfjCs/p9nIgvOmgvZgNkgdYX8CA=;
 b=wP9g6SRffryaVRYFvhjqwGlLsA9DmCkDgQQQtIHE0SFDfMsWUKIxtmtA7HKEQjxg/vIOYHwagDu9cOZvspCZ5gSpCubFAy19s6EKKu2sdX9HG++7B9TCHK9b+mP3UVz9/XHaUP/J/1tU/ZJJSeMTE/hBJrgXSOdeT5KtjiI5m6A=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4120.namprd10.prod.outlook.com (2603:10b6:610:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Sun, 13 Apr
 2025 04:05:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8632.030; Sun, 13 Apr 2025
 04:05:06 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/2] target: Move delayed/ordered tracking to per cpu
Date: Sat, 12 Apr 2025 22:59:51 -0500
Message-ID: <20250413040500.20954-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250413040500.20954-1-michael.christie@oracle.com>
References: <20250413040500.20954-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4120:EE_
X-MS-Office365-Filtering-Correlation-Id: 68cd90c0-6124-4f92-f660-08dd7a40602d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iX+NGN5J902+J/7Irsb66/OM+NAOSMjAvqSZJ/EIx5c9I7LKlvjWbXLOaJRa?=
 =?us-ascii?Q?SNryCHjRJDBAQHG8ffh5Y6kiTBnm4dsxl4Ay9I2hAtC4q/fvkLkpDs/yscCA?=
 =?us-ascii?Q?pXpaCvmUPIj7znqUJNLVxWS0usjE8Wo9B8bqzxAtjB+b8kU2oIf4IaB3kaKP?=
 =?us-ascii?Q?l3hZBeTBLWl6rXcw/pPEOw4VbgkA9a3Gj3QMP3NJZ47tU9WYP8u0cNjrK9Pl?=
 =?us-ascii?Q?97F7JJT8aPOdWPqPFJCYNoOrU1HZR/sUPEGgR9hnYBbGgHLNzcX2HXbwpLwm?=
 =?us-ascii?Q?PI3H6kxwct0LzON3ZOcNVjYfmHp4q6sl/mtoD7pbc8DfrBL8qOAgpl7tlfn4?=
 =?us-ascii?Q?MS52fpmZIUikUE3k+6ywwVW2cX/cQM4XV9Zr8pQmGk7rkm/CMOvY/jta46B2?=
 =?us-ascii?Q?g60Qf6RCJNgXK1PB3Lv9iU6d1g6LCYbaiEG8KptcMAiTW/7w/RytojuX2+gN?=
 =?us-ascii?Q?zCHDfd5FPoV8IG2o8BFfBnz4x+b78ZJ5ZWb4d8jRZeJUvafbTB4sGati+Lk3?=
 =?us-ascii?Q?7MzAQCaODJlFjYvVHZE3qNc0fsdUcymhr6T8IC162MqHFBSZjJJhe6Crxgjz?=
 =?us-ascii?Q?FCEqtjxWFqVtd4t0QhesoiDP47Ng+cTYYcsXZp8qSfy+IPhbu95QOqboQUF8?=
 =?us-ascii?Q?U+7i/cCn9QaArPxBNtGZk2GVZOIKIsosSX53h+Mkj7vKoP0b8O27vMG2sIM/?=
 =?us-ascii?Q?XjYPAyrWA2HvkWR0yK9nFX1QlEYTPsgz9bI/hZrQVIfiipUvcQY5F2+HxwiJ?=
 =?us-ascii?Q?D/E4SjUCoYxKts7W1xpuI3spyFsPN37bkosEGz1D36MPtFrPHQ7lGcx6jFVa?=
 =?us-ascii?Q?XNsZBtrWBKU33/ZE03c7+XG0FfkXFQivFqGtJ44yXTqYlWUZZqwYlzh5iwY8?=
 =?us-ascii?Q?fMBOWtPkaqSmX6MbAfiEm81csbp+/aULzxeC/6LsaVpundNW4PIkXrN1eNB5?=
 =?us-ascii?Q?9PvtvnrEFoIXCoMurh0wNBwAJGY7J4tnppw3HwXbw9O539IlOWQT8Y1BBG/Y?=
 =?us-ascii?Q?uscI4fJonMygtwY9ukfMrv7U4op/xR33WCCL7Om1wAhVQ0umCMp0BWYcMsaM?=
 =?us-ascii?Q?GS3cvZf0UulRUhBc6Nqchj59nfT0WFJj9u0JJUUeu8MmibHUl046H5VRHqPx?=
 =?us-ascii?Q?eJqpCorGvlRhcDdV3cV1BviAWAXD/vm7gofQVBZwKidZqRlFZ5Q3G/XB/ypt?=
 =?us-ascii?Q?YDeAE3LNLgMrhy8R4z34AiX+b7QrMW9zOCzELG7S+gLy76DaYzADee6y1CGm?=
 =?us-ascii?Q?cWVur1Cs52YNrK6olIQSB8S+ZtIKp1rQC0zppughb36ctAC3TsLtd/HtPzh9?=
 =?us-ascii?Q?PtXcvEvMAyVUkixdctoUlf70+2LJna5jtfGXy/q8TjgkFuwzNJUUoV99UnSO?=
 =?us-ascii?Q?FWKN3Z0mUl8yK7e9R7Cz59wo0qjeomPmEJP2eIy1S4eN3F53OPKcdtmHlvoF?=
 =?us-ascii?Q?PnvNcgTJ9Sg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zF/ogP0T+x3E96PK0wCyXdBC1Oat3Jap5crplZ7gtuJy0RWfa0We5lFdIimJ?=
 =?us-ascii?Q?BDDEQy6qxbQf7kZc40r0xJTzSIXuvrbh+/8MEKP8+kg+e+twdMLP3e74VJWD?=
 =?us-ascii?Q?wqelwM12t+alGmltvZp/aO6HKsLa8RQCf/DcH+QTVSXIAFj5GlUEA9/3JCry?=
 =?us-ascii?Q?+zknEmcW4Vyhu/B/pusC5E9S6yZX8FXbZ8mTVXLLjPxQk6JhHu1JreVMgNpM?=
 =?us-ascii?Q?Dh1IJHPa1GCaJw+2TkAcgeRvtwHQfMBJBvtB9MpaHS/5bkVRCBqirkUFTbYu?=
 =?us-ascii?Q?VMtpAUhWxpU05BG0bCqGUv7YMm1JbGqiZ6cDGvi/XI6+PSR53xCtJW/ctYuX?=
 =?us-ascii?Q?HBx6jtXxJgeu8vj7nlh2B5JIUNrnLA4nSXTs65jPX5Mm9wvwUbbha3yWFgbN?=
 =?us-ascii?Q?KcPHP2OEJ+ePOI+/q5wSzMuNWPYRsWBnATj0AUzj99hQPNkkgNpZf+bDl1JF?=
 =?us-ascii?Q?SW5sdz8L9P8iOdjwjcX4SqLPew5VHQuuWVTyKsGVkP4ykj2npDhZoIROkHKk?=
 =?us-ascii?Q?VNo0T8kINf1mOtf4aTq4kiqeJIZhNL+h+Dd7UB8a5oE2wM5+mPUITa4oLntg?=
 =?us-ascii?Q?qJviPKcz8uW2pJz+AVBaVxcQyYapmeNX+/6YgIeMwNqechHl72Ww0Vu+4Zrp?=
 =?us-ascii?Q?23vJd4XJoMi7pyRH6fz+HKiz4rBr6MLCoL1p4IfjGjHNeWwfrGJypeJ4ifl/?=
 =?us-ascii?Q?L2IxnRc0LXZPplIDEM3weUXeUIN4Xbp6G/CFlUZQmkakaVtphVQWyxltHRXG?=
 =?us-ascii?Q?KVgqJGnzk7yQzEjjP52Ej+U48nqvAliYBxrHfk8sc4GkpzN24omaby6E3slo?=
 =?us-ascii?Q?kPHTR+kJ8SrBbxGoivIWvmUms2ZH4+LmKL1qw4+HiKUMSYJHEzn/z8lPGgfc?=
 =?us-ascii?Q?TXibX/Y6ThDks0T6a5zMgOIZ3C6NwakZhUXDkPLaBXtY5/taQqq/smTuX8xM?=
 =?us-ascii?Q?HrphezmnqUH52b0N9jdBsbfDLXFSbg4A0OOc42TsNLlIVPC/IcbOPKhzZBGC?=
 =?us-ascii?Q?KDdYjnBf11NoeKB3buFr+IJZSO0VitERCNh7TJGa6zp31uY6hHhOoyj+V/5k?=
 =?us-ascii?Q?CP4XYuxiZXJUI/4PVM7YcHKTflaRycT6H6wKjaZdRwlMdCR4KOZ4aJyL0LWR?=
 =?us-ascii?Q?FzTv4yHJrveOLkW4daU07PeQ/9o6OUPaj3+ltVLzLUoTcL0j3psR0LXdO05W?=
 =?us-ascii?Q?M8nIzH/BxpQwZ7hgfF7McFyZSJwre7pkn3gPU7d7d+e43xVw4Pj2mi73+Gwd?=
 =?us-ascii?Q?Uo/8uxgQq8y++v6/U9dw4bA/3IllU2JDfeNSI0mSgcCNxj774037SGJRrobp?=
 =?us-ascii?Q?P5gZjx0segrQOK8ayW8pIyrzXFqlOLdArPk9//L2av24OAmQlhlGS8uEmgFu?=
 =?us-ascii?Q?Nqs17C0HPUJMdWz3+GKnRKoYJ8Qz6SDqvBagepon7at+V6Q77ZWfzdVkeHeq?=
 =?us-ascii?Q?i3aazA4UQeO0BUuSMwBa0msEKW7e57iVDCs47QQtlzbEA9vRed91oWKVWHn3?=
 =?us-ascii?Q?GvIc4f23w9aDzlB5ETayokdukDttBLDZXlvUWpIv1S2487M0+B1A/6Xo5JsK?=
 =?us-ascii?Q?hnG4/xvgE/hmXwGFnzjixsjeY69L1WPAbqeMrA8TGEojGW7eWIC67g9E0t8A?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QDkKQov1bZ5nF9Tzgyo9bFG0DnP49Y6cQYTjCis8XX7j/z0EMxSnYXagb0ymwwwD/WRCSmXgSJYnykV6HJctdF5UrGr3yNyx2EMd/58GcMJBinyGifhnbiV6b0dmewIQcucC9nb3LI9gUxWWLBsJG9SsBn4HVw3qsMUhFH7psWIFtHf/94xx2MiqAbC6bhmoi1Im3iBdSByH2kkvwEsuj3NFNBfCVrBSb/HjdzsHlRjZaWmoqRfstafaKU9If4xnyCVv7ZiMCdt/Cj5gF60vU9nPaBXqNW4Af8cAW2Qel6Z8vb7DDJGag7v9uTxHMn1eGucISdEVb2AGpyFz2pKYuLu+oAxkEpqzbZ+XjAY7s7vtn7OlbERhz5DhPuBw5Esd97ZKoctu8M/+tUmPqmnHoPPkEaINqa6VWm5oB+1TXRCWj5Uq07mxPNApQN34YfmE5ZeDWWvl4M08pnUVYuX/x0nBtGTcvTyBKMZ3wcUaqUdM0/1QAvMtHB06DTXghmSIpnIT44CQg3FFuhm1dWWhQh49sigfDxv3XNFnD5asM7hPMqSuGkPgyfmmfjwbQxywqi9LIM3T00qfApw8VJyCyqdvAoNFe+pwur/B/ZMXYCc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cd90c0-6124-4f92-f660-08dd7a40602d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 04:05:06.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QE0um4akv3KaHRrnrpwKiqp2c9s3CJRIDo9xY1H+LUyfPkgG6BHxQLkf/LcIYD5HMaVVMbe8XhbgrB2T9cNmxRja5rALhqDdV+qM3tjNl2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-13_02,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504130028
X-Proofpoint-ORIG-GUID: f-7K7bi9nar66VrTuglmfwQCGodCGex3
X-Proofpoint-GUID: f-7K7bi9nar66VrTuglmfwQCGodCGex3

The atomic use from the delayed/ordered tracking is causing perf
issues when using higher perf backend devices and multiple queues.
This moves the values to a per cpu counter. Combined with the per cpu
stats patch, this improves IOPS by up to 33% for 8K IOS when using 4
or more queues from the initiator.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    |  20 +++++
 drivers/target/target_core_transport.c | 119 +++++++++++++------------
 include/target/target_core_base.h      |   4 +-
 3 files changed, 83 insertions(+), 60 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 39aad464c0bf..7bb711b24c0d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -700,6 +700,18 @@ static void scsi_dump_inquiry(struct se_device *dev)
 	pr_debug("  Type:   %s ", scsi_device_type(device_type));
 }
 
+static void target_non_ordered_release(struct percpu_ref *ref)
+{
+	struct se_device *dev = container_of(ref, struct se_device,
+					     non_ordered);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->delayed_cmd_lock, flags);
+	if (!list_empty(&dev->delayed_cmd_list))
+		schedule_work(&dev->delayed_cmd_work);
+	spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
+}
+
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 {
 	struct se_device *dev;
@@ -730,6 +742,9 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
+	if (percpu_ref_init(&dev->non_ordered, target_non_ordered_release,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+		goto free_queues;
 
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
@@ -816,6 +831,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	return dev;
 
+free_queues:
+	kfree(dev->queues);
 free_stats:
 	free_percpu(dev->stats);
 free_device:
@@ -1010,6 +1027,9 @@ void target_free_device(struct se_device *dev)
 
 	WARN_ON(!list_empty(&dev->dev_sep_list));
 
+	percpu_ref_exit(&dev->non_ordered);
+	cancel_work_sync(&dev->delayed_cmd_work);
+
 	if (target_dev_configured(dev)) {
 		dev->transport->destroy_device(dev);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 05d29201b730..0a76bdfe5528 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2213,6 +2213,7 @@ static int target_write_prot_action(struct se_cmd *cmd)
 static bool target_handle_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
+	unsigned long flags;
 
 	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return false;
@@ -2225,13 +2226,10 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	 */
 	switch (cmd->sam_task_attr) {
 	case TCM_HEAD_TAG:
-		atomic_inc_mb(&dev->non_ordered);
 		pr_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n",
 			 cmd->t_task_cdb[0]);
 		return false;
 	case TCM_ORDERED_TAG:
-		atomic_inc_mb(&dev->delayed_cmd_count);
-
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list\n",
 			 cmd->t_task_cdb[0]);
 		break;
@@ -2239,29 +2237,29 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 		/*
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
-		atomic_inc_mb(&dev->non_ordered);
-
-		if (atomic_read(&dev->delayed_cmd_count) == 0)
+retry:
+		if (percpu_ref_tryget_live(&dev->non_ordered))
 			return false;
+
 		break;
 	}
 
-	if (cmd->sam_task_attr != TCM_ORDERED_TAG) {
-		atomic_inc_mb(&dev->delayed_cmd_count);
-		/*
-		 * We will account for this when we dequeue from the delayed
-		 * list.
-		 */
-		atomic_dec_mb(&dev->non_ordered);
+	spin_lock_irqsave(&dev->delayed_cmd_lock, flags);
+	if (cmd->sam_task_attr == TCM_SIMPLE_TAG &&
+	    !percpu_ref_is_dying(&dev->non_ordered)) {
+		spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
+		/* We raced with the last ordered completion so retry. */
+		goto retry;
+	} else if (!percpu_ref_is_dying(&dev->non_ordered)) {
+		percpu_ref_kill(&dev->non_ordered);
 	}
 
-	spin_lock_irq(&cmd->t_state_lock);
+	spin_lock(&cmd->t_state_lock);
 	cmd->transport_state &= ~CMD_T_SENT;
-	spin_unlock_irq(&cmd->t_state_lock);
+	spin_unlock(&cmd->t_state_lock);
 
-	spin_lock(&dev->delayed_cmd_lock);
 	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
-	spin_unlock(&dev->delayed_cmd_lock);
+	spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
 
 	pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn",
 		cmd->t_task_cdb[0], cmd->sam_task_attr);
@@ -2313,41 +2311,52 @@ void target_do_delayed_work(struct work_struct *work)
 	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
 
-		if (list_empty(&dev->delayed_cmd_list))
+		/*
+		 * We can be woken up early/late due to races or the
+		 * extra wake up we do when adding commands to the list.
+		 * We check for both cases here.
+		 */
+		if (list_empty(&dev->delayed_cmd_list) ||
+		    !percpu_ref_is_zero(&dev->non_ordered))
 			break;
 
 		cmd = list_entry(dev->delayed_cmd_list.next,
 				 struct se_cmd, se_delayed_node);
+		cmd->se_cmd_flags |= SCF_TASK_ORDERED_SYNC;
+		cmd->transport_state |= CMD_T_SENT;
 
-		if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
-			/*
-			 * Check if we started with:
-			 * [ordered] [simple] [ordered]
-			 * and we are now at the last ordered so we have to wait
-			 * for the simple cmd.
-			 */
-			if (atomic_read(&dev->non_ordered) > 0)
-				break;
-
-			dev->ordered_sync_in_progress = true;
-		}
+		dev->ordered_sync_in_progress = true;
 
 		list_del(&cmd->se_delayed_node);
-		atomic_dec_mb(&dev->delayed_cmd_count);
 		spin_unlock(&dev->delayed_cmd_lock);
 
-		if (cmd->sam_task_attr != TCM_ORDERED_TAG)
-			atomic_inc_mb(&dev->non_ordered);
-
-		cmd->transport_state |= CMD_T_SENT;
-
 		__target_execute_cmd(cmd, true);
-
 		spin_lock(&dev->delayed_cmd_lock);
 	}
 	spin_unlock(&dev->delayed_cmd_lock);
 }
 
+static void transport_complete_ordered_sync(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->delayed_cmd_lock, flags);
+	dev->dev_cur_ordered_id++;
+
+	pr_debug("Incremented dev_cur_ordered_id: %u for type %d\n",
+		 dev->dev_cur_ordered_id, cmd->sam_task_attr);
+
+	dev->ordered_sync_in_progress = false;
+
+	if (list_empty(&dev->delayed_cmd_list))
+		percpu_ref_resurrect(&dev->non_ordered);
+	else
+		schedule_work(&dev->delayed_cmd_work);
+
+	spin_unlock_irqrestore(&dev->delayed_cmd_lock, flags);
+}
+
 /*
  * Called from I/O completion to determine which dormant/delayed
  * and ordered cmds need to have their tasks added to the execution queue.
@@ -2360,30 +2369,24 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		return;
 
 	if (!(cmd->se_cmd_flags & SCF_TASK_ATTR_SET))
-		goto restart;
-
-	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
-		atomic_dec_mb(&dev->non_ordered);
-		dev->dev_cur_ordered_id++;
-	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
-		atomic_dec_mb(&dev->non_ordered);
-		dev->dev_cur_ordered_id++;
-		pr_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
-			 dev->dev_cur_ordered_id);
-	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
-		spin_lock(&dev->delayed_cmd_lock);
-		dev->ordered_sync_in_progress = false;
-		spin_unlock(&dev->delayed_cmd_lock);
+		return;
 
-		dev->dev_cur_ordered_id++;
-		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
-			 dev->dev_cur_ordered_id);
-	}
 	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
 
-restart:
-	if (atomic_read(&dev->delayed_cmd_count) > 0)
-		schedule_work(&dev->delayed_cmd_work);
+	if (cmd->se_cmd_flags & SCF_TASK_ORDERED_SYNC) {
+		transport_complete_ordered_sync(cmd);
+		return;
+	}
+
+	switch (cmd->sam_task_attr) {
+	case TCM_SIMPLE_TAG:
+		percpu_ref_put(&dev->non_ordered);
+		break;
+	case TCM_ORDERED_TAG:
+		/* All ordered should have been executed as sync */
+		WARN_ON(1);
+		break;
+	}
 }
 
 static void transport_complete_qf(struct se_cmd *cmd)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 05e3673607b8..a52d4967c0d3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -157,6 +157,7 @@ enum se_cmd_flags_table {
 	SCF_USE_CPUID				= (1 << 16),
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
+	SCF_TASK_ORDERED_SYNC			= (1 << 19),
 };
 
 /*
@@ -833,9 +834,8 @@ struct se_device {
 	atomic_long_t		aborts_no_task;
 	struct se_dev_io_stats __percpu	*stats;
 	/* Active commands on this virtual SE device */
-	atomic_t		non_ordered;
+	struct percpu_ref	non_ordered;
 	bool			ordered_sync_in_progress;
-	atomic_t		delayed_cmd_count;
 	atomic_t		dev_qf_count;
 	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
-- 
2.43.0

