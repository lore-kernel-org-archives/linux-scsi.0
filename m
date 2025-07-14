Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48BB79FE;
	Mon, 14 Jul 2025 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752515173; cv=fail; b=jn0RhRNg/hcKrJ0kHzLy9/lfrOgZ1XyhgFnd0Jf5651C3bmXNjnLA3EGTfMjZMYtqKqYncpy5uGF3b0nCu8RG9JXNWasFAgV8200q285VuXeOU5kJLhBvErG2mQKRSKhwDN+yzLFB/FbKf4Ke1QrB/A0Tn8GFAtF+YJWdkID7Rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752515173; c=relaxed/simple;
	bh=/EioSfzLJVttYX49C4e0AaXbKmnatArGJnuClU9oi18=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mA71/G+Ik/ZTZSVqRR4sbesGs1Mga8T/JbeQvPE1czcG25fIMrgSoJMuBe48xxfusOSnEMofIEbiy1eoCp3TCAHxHE9pr5q/MWssd6klKIuUIt20noG6ERzWGCvGabWy+otcmbOX7u/WqIIIP7v2jwU7nRb2gK8cpbhfJYtONmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MTEkCGyl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zD27ROOo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MTEkCGyl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zD27ROOo"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EHXDpY019067;
	Mon, 14 Jul 2025 17:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TRsAtIvnB2uuEeFWZ2
	uuWpx9rWmImqhJJbLsIrSoQa8=; b=MTEkCGylU+lQLOVjtI+YwSnQUFA6Ce/J3W
	QHaI/cgP8DK6jwRg4YiZB6wUh+cZypgHsnX9kGyKUzQtFMu+rHfqTuoRUMrJ12tC
	MHKl12obT5yvbCCR1ZbsPEck445VBx5h+xeJH3PKkzG2/qXlGFARyLFUAyztvUEu
	7OBdXv8tYEI503xsK6f+ZdCzRKi7aWla7UAZZbQnmKRjaXqSnUWO9vVk4A62dTLo
	/H31uJaX9AXFQ3z4Fl0jNUf2vm6xlluqu7xglNCE+D80SD6vZgZCzIn45RzmaERV
	pQTKY1QUjB6cKzS9Zdc/GPDiPXrLlAnKidTYrQe7ladMobwrUnFA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk66vkg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:46:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGrwI3013045;
	Mon, 14 Jul 2025 17:46:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58c8t6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:46:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHYFAbFT+QJFJqQL+4W8px2o8JyUMK8U2kK65yyJPjPGdyWJocC538sf1lKNtJ/zBXkfNPN9b7khwc+zBHnBGsZmr6xtVeUrgwYfAJzPXOMyGdXWEmbDvZuSR8Er/YpcMTF3HqzjaWYD6mdOIVrQiFlW6YdRUaSJbPV5xVVgnPSS82fMwmHP9wY8T/RvMJJkjwoHgc0YbvrMhgJJsSChhSF8WUSnwGJiUe2Y1OuUIv8KGOE/30aBqzArH0sIszpsM4c+zOXJvhMd9Q9dzICRT9OdOp0Q9me3bDlMGHa83XSjiKOds3Zpj2RsUwKglKXd6+TIqGme4ROFkGIOsPW8KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRsAtIvnB2uuEeFWZ2uuWpx9rWmImqhJJbLsIrSoQa8=;
 b=uG5jkPVdCnX1JJZxD0urq7jmHtNfYXEdxohd60Blbw0SiuL2Znvbr1laB/hH5aUw+sQ1lIKU5NXNPwaRXIr+EUK8hiT9uq8NMO7loacoLcQ11Q1jBEBs6a69Qs2lAADLPZloJaAR/9OScliikv2q+YfENL53L1aiANbScO+2txyP0zD40QcrbS3diKyN2/NUWjx5xamU33k1db31+V8kX2rAa+T4iaMNJybCp111TWZmN161DFu3RfL+YPqgEaDpJgfx/sKFNjgATGxZ2aP+GPkzTVWUj9WKf+CTSRhFpJP/jDa0SrXsDSN4FvHw8c84hHfd9X3EX3T94yLbjDOwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRsAtIvnB2uuEeFWZ2uuWpx9rWmImqhJJbLsIrSoQa8=;
 b=zD27ROOo1gIDSNqfilsQz1nYFyu/8hwi07nKqxP9iCblx5FgoUn3d3B64zSPsOftcFyxJ1DdoEmMvZfLjUoIXqQPlnLo1W8j0s97EfDdxHBlNjA1xQtWgBud1ddgGqLDTKdcHK9S7xnAA0PYnxTFIqmyVzEJ0TibZ34uLwQRi9w=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6453.namprd10.prod.outlook.com (2603:10b6:510:22f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Mon, 14 Jul
 2025 17:46:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:46:03 +0000
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Dan Williams
 <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isci: Fix dma_unmap_sg() nents value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250627142451.241713-2-fourier.thomas@gmail.com> (Thomas
	Fourier's message of "Fri, 27 Jun 2025 16:24:47 +0200")
Organization: Oracle Corporation
Message-ID: <yq1seiy7jjl.fsf@ca-mkp.ca.oracle.com>
References: <20250627142451.241713-2-fourier.thomas@gmail.com>
Date: Mon, 14 Jul 2025 13:46:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6453:EE_
X-MS-Office365-Filtering-Correlation-Id: 8162a4fe-ddab-4c7b-a6b1-08ddc2fe4d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nlKFu//G3IC6VjEDnMQew7Hp8zA8wfrDhk5yhUFGBPF+p7eqFLGOg8j/ZnqY?=
 =?us-ascii?Q?x+Q3xaUC7JdHLLZPwcnGekGCgHWCfEnkwrj06c3nD2tH6xNDRxwnBTRywx+b?=
 =?us-ascii?Q?U+F4Cd6ypmpRs+GQ+/TLOfX56sd2xxm7ICisgyEcwPGZ3SlFNtjyNo2IatEn?=
 =?us-ascii?Q?nNLSv+mL6Uf5ANtMA1DmlQn211YCRZO5iTDJYWq9vm8L+3UKvSpJ7l7iT4Wz?=
 =?us-ascii?Q?8XbKEU5teLpbU2gmEe+OM5oc+wV0tMoLq2tstxB+zxHE1D7596QW6bP8M8Dr?=
 =?us-ascii?Q?eAc/g4HO1n80J3H2raDZpZlyJRqvDceSba5dyvBVmkJsTciaRkPDCcj1fZ5t?=
 =?us-ascii?Q?UaePqj4gMQcRN3dyZMXPNrXHoSuTB6mqh0AboaGWKerdX0tmXU9Tu5SdwIg/?=
 =?us-ascii?Q?dOZvJl/TzFcyv333BJ3AtFU7de6VOn1FlErVy+Dy+o0hqs+2EBDV6qVBM9RE?=
 =?us-ascii?Q?pbbCj/7+nVVzqWW5mi99FjhIL/6pxfzsn0FkyU29CB7gRtSKz12D+IkIVN2P?=
 =?us-ascii?Q?FE2k3ggB4r8tYgP0k8R7fqrTrllnqrhCO6rYf2p4PreGbEz3qg2FHGNvOkxz?=
 =?us-ascii?Q?wGqc7xi8U4YV/AE1Jr1MQ2O7+1FPYztTMvb8ksUB3BzxnYiQIfYr0N858drX?=
 =?us-ascii?Q?j3JJqWxyrElu3/CH6HDPWc08l4u5B2uLEDA+ghHilTM51MKZuUkJzC7dPCf1?=
 =?us-ascii?Q?AmXGBOfUtLokacEEHwCaavuMdlRWxO4JU9Ln7130nS8aGsqlhxDf4sMnmQ8V?=
 =?us-ascii?Q?kAJiBBTCi29XcGzLvR0Q9Fm27pmylGJ5eQ1YCCVRUtVfSlTEKrGqxtEWnUMi?=
 =?us-ascii?Q?kQXaFgyHNc37W/kZTWVSHsH2mvfjhYr3WJt5SpNydhZkVXqC/s48OzNlXs67?=
 =?us-ascii?Q?qvrd0sm0dGxU2TOyx8w5QS089Vxr0gy3gxq770lfwyqjGV12n6u1wnwphGTa?=
 =?us-ascii?Q?sWy9VKGiFo9Dma8HCgQcJ9n+uUpV0WU5V2493KllhUFzClKV0uuSqNlJXEtu?=
 =?us-ascii?Q?kwz8W3qwQl8AnTv4trMF4P6OcLSkehsz1nP6TfSQlBCB5XJnhKR/vJlYFRke?=
 =?us-ascii?Q?jlbqmYlYyiMYPWlzqSOBeVb6TxznCzlKW+1mA00zI0geThf0qlZ1eIkKgP3P?=
 =?us-ascii?Q?CuT9d0VSx+dMTMcxISBUFYn7XM2tKagGSUMRqRGjpBV5GTXeSmBM1wWjdwWC?=
 =?us-ascii?Q?I0O00zZ514jHiuxgqeHZ2Oain8pju4kF7c4QsuyNAcJRfSDq4PV28dWvgA7c?=
 =?us-ascii?Q?sxOzXrYpw8ZzGw9pFPtesgUF0Z83e6veO8zh/4NS0jHbqvpW2WiFJ7BOijok?=
 =?us-ascii?Q?hWP+4LaX7tRjmzAc/a2IAbq+dkMKYWq1S3/WP707hOdCD8C39Fn2PYuOOQS1?=
 =?us-ascii?Q?rR33kZSfqJJN58oD+B9NdWXUAN9pjzhO5JnCawVktFYRAyLYKA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XLvYVVfiMitKDgYK0FlNibwrGityFSZ/WtZpwaCxvFp3QVuVZxCZ7InmUGly?=
 =?us-ascii?Q?0jF1B5MMjA/zqCTJWve1X9ZSIbuMloFLy8AnOJGDyJKn9DEOSspAyekgYuSB?=
 =?us-ascii?Q?lvW1+TeaIjmP6zwm2aeW62eyPFrPeWTA4+849A7ysslFPe+Yq/nuY9OZpGqz?=
 =?us-ascii?Q?4R2/4DH2dr3gZwF6ZT965TZ6BIKEgbaesSZx2uJe9ectjmhDZjcjztSuwMEZ?=
 =?us-ascii?Q?SKkSmhALQB19rxuJs1b0yzJoEGJIsNADFF5w+ol0VD5JXhT3w8Lo0DS+IK1X?=
 =?us-ascii?Q?fzC58QOnZf/AOqg8nLg7mEEbh4abZISZnWxyDVLKprj6L1nRL3GQxFRcYVGK?=
 =?us-ascii?Q?gjsyQMek390HP95KZYM3PtR0t56X3aLI0RYAdEhqicqzYF+KlqUcGVKD1DrO?=
 =?us-ascii?Q?V+K2BFkGZZ62PghbOK3DGn8JD9OrKes3AeyQEOQN0P4PyJTaIAWWuyMG8F5O?=
 =?us-ascii?Q?+AW4fji/kXI4rtoa1tL/x1iCbHvjHueV7GZ7tHtJVcsqQlyCkkAy/1wKDzhR?=
 =?us-ascii?Q?hHZ3xyV2AzwhIsKG4LqN2E3p159hgs3rsvEmnT++leB579npNJc3q48wfwTM?=
 =?us-ascii?Q?km4Vmr3Md9/ncI/BoKXMbVV9lfqXJ0o0edXrGjgqTjsyJMeOkXCBl5kWJA3S?=
 =?us-ascii?Q?JVMk8gdTe03EpkhXLICdz006f3lhVYQIw562mS2vnKja9IrvqWeNAa2zxCad?=
 =?us-ascii?Q?AV4UmGxbZYWvG81wFxO4lctqpwzJVGGM/bM0EGkgyeYw7jxcQQy2oTSz9RZe?=
 =?us-ascii?Q?zXVFudn6XEQy91Ol/SVF9Gk3JbT8+m+MwTmiwjDSLIVbcBUg2xKURj4kaIDS?=
 =?us-ascii?Q?5G6qo0B0xyFF/sjBw7+D84o/6yyGITy88X3IbJO5eBYvPsIQr6UbzN7Za9go?=
 =?us-ascii?Q?T8hWuPOXoaAJoa6tronTvr1G23iTv0iPGv7fnyy65TNr2pTR0waDTjK8GXe0?=
 =?us-ascii?Q?UYE7zFc+MX9fe3rc5j8BbWWf+rB6gQF/k4zNoswR/i2kBJYYZF77tXepK0U9?=
 =?us-ascii?Q?jrzJLManLrlTB2vXZWCZHf+n2VntZbD70N2lWK1S8rw8CfdSC8ze3l4ig/i2?=
 =?us-ascii?Q?K6WfA7UREXbPXBnFsoTvc88nG5SxwDM5P4sur35BLD6s0lgqD0xOIKLM1rbH?=
 =?us-ascii?Q?9BsSxkZ7YS/wjn4+20VEYVa3P15W/C4Hp+BxnKYUbQGdzGi9w5UBro1s4Ygp?=
 =?us-ascii?Q?+noBYghv8oAqX5+K5fUKvqPMNHsO1+deli1GawkvbI5u+hxs0XD7JYwlruu5?=
 =?us-ascii?Q?LywXoOeGPiA2PAKnYB78kzzPktO4bnAsYzHP0uwfmxj4tu0bnVuVyJlrTRR5?=
 =?us-ascii?Q?zmPw8MahdAlvcpGc7qjK37FqN7n+p1+7I6wIcRYDsl2e8urZORIuYIpIerDy?=
 =?us-ascii?Q?ssH4WR98Rkm47+cPaKCI6dEapO/59Z0eW9e+d2ToEKw+OKVzJUGYdvVMIzkq?=
 =?us-ascii?Q?E9zEcLikQEOKQAL5+x6C8g7b4K8uDPT5Yt4YT2+Kn4wjowIe+hrYp2q+dnOL?=
 =?us-ascii?Q?A5ESXd2o+2S18vRjZ2AlR6FAwDrNjXz6i5/OPZhu223WgeL9r8cVmz42bYUW?=
 =?us-ascii?Q?a5Ulxummfr7ff8Fp/svCbJPv3CLEcqvt3iN9mv9Nptba62wN8uadIutBfV+9?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	41CfKT5ZZKXIe7Nbqo4RI9oVEoEyEF93O+/eXlu0Ml/iJGrmxaRNcD+4J9hFY3Lz76kjaB3+s1jYqCNBUbVyU9H4CHQBOpXLMvdNHEQW6shXJbLSdyiFi6E4bAWCXvNCM9PdirSHPrdNYuhGtMiK/6GZZkhP/vSBlKs+hS1Smu8l1vILUbRpwEhCX+g2tWhHBZovQWy683RnpJKo7Z78yZyR0GxyirTtzEQu+T1maH5uIZZ+XWF1FmhWwAVbS9j84RKEWqdNBRR46B0eAOxlkOLnZ3kE44FOXafeEDJWfnslu/J+9/DNrtZfSzEQOIsl/nCOylpz/q+t+e8htaLZKUNsXv+TgdMfXdw+W+5Vm/5BNXyRctiw+czqfcCP3i4H/d+/npJa+h3hKkZB7b56aFrwupI0L6E5eLGznRLOvyqmXfhJO4BP377IRLyvaGsZyOUtDtnikNQsWKntjtvATwOvEVwhpzsio0E/iajihbrJwieFnYChe3vInhPWQ4MM3sS06ZOEVmXfRaBfRCqlxjOYWgz5L7CynHD/FVoAumfi7WQszxCrtNcn7579IlnSkw5hzy7nKsBR72BrLYduJyNU+NckPAokKMhDl5A+c1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8162a4fe-ddab-4c7b-a6b1-08ddc2fe4d6e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:46:03.5893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9SsP9tjFyA59HePkNDXLN6paIO67HwKFlylZlj64T1aD2aey2EHhpgZjQKCr2KHABrz6/W5a++bwiVnhWDCNyZK+tik1m6p0L2KJyfuubI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6453
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_02,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=667 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140112
X-Proofpoint-ORIG-GUID: vExwV3hfj5C2_0CkKJc7qKFuBA_Mp7cX
X-Authority-Analysis: v=2.4 cv=AZGxH2XG c=1 sm=1 tr=0 ts=68754260 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cm9y5QnUeDfAKpJ_UQ8A:9 cc=ntf awl=host:12061
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDExMiBTYWx0ZWRfX2z9/YQiSk29g lkeADv9ZKFYoDqTDgjQOOzkpCCZC6pnXVS/aEb/vYN0KSwRxXPUgZHbOHH40YE6aLFydSOFMxbF 4VC2QXiY+4gCzHdwyeutpHTRWad3gUU0RPCTCg4nXEGL99s0W1RFf5QdWT8ffOz3JLEUXMlEo2y
 4qpNzrL8GLSnaFUsmo2PVUO7YWBt1zmSixkBc2KyCFMKYOkCd6IhuQ6WAMc2DyzgFg3GgHB/Pzr 56YHF8IljWuF/xz1vhVJEp9zhAa9SCf6NlmZFOnXhqCaJz2alycKMx3t0CE0256nNeGGU7KY03E vVjetYrcdmCIYzgaPQn3pl+qmitKsptDYxM/bI/uyz43xjc6SaOSkbXNGGV2bYjghhe7f62kcC6
 +UmFaBANE8hkkVD2OsPDfcJw+y7k4OHQz/5Q3YLZVgi858jRICJpDNrFZzXrBLNn/77f2LSO
X-Proofpoint-GUID: vExwV3hfj5C2_0CkKJc7qKFuBA_Mp7cX


Thomas,

> The dma_unmap_sg() functions should be called with the same nents as
> the dma_map_sg(), not the value the map function returned.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
