Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF4247CA65;
	Tue,  1 Sep 2026 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259602; cv=fail; b=oy+ZS3mps9d3dLUQk1P7Wxm4MOdQ4C5kBiR/ffYp0yBoXNldCYNA4vx5VlhAoi525a0d4sVOl3ZCts6kaAACwvE1SM/uvDAUX+X7eaAOhysDfnw3N2Th5ABz8mMs0jm05wUPMTsGfkdl+ObqUDZjFiSGJbxpAqbuNSYAtcZGiCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259602; c=relaxed/simple;
	bh=nsNbSwKN5+uvuJy2Uera2kJwfsY1sTqi1ZKrIip/ybw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oMNKSNjqPpDPqb+PP4AigZ7Ax2Omozjr/OvXMcfjhLVeWsyZF4NObf1vB2xlw/vPwXgif7ooFuqJE1EEM+HL5KeibZ+ueg3B7yap3AX4LFGJKFden9cN+TaJxXMoAzp6+HSeYfPlE65ypU9rjJEe/KZrJ9XEwXyEoJ8hjp0XN7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZsRRxtlr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t15q+MMH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZsRRxtlr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t15q+MMH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLC46F2311414;
	Tue, 1 Sep 2026 10:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FPs0CAmV74ww23o4lA+2MPWaiZjfYFK6xB5v41+QnnQ=; b=
	ZsRRxtlrCQV053n9c0Vau0x1h3CxJl5TNQrPuofG/0Iw45EMT8JMggAg443jJaAJ
	L1BK/bnTKowsPe7QgrY1CeKT8dAwZoNXbTWra4C6LWiP6KQl44MiB4nCooxByXWj
	nYkJ8GabvytSclkqPApfgGlAF7SDTIQXtAr7sogS7EWPs7ulj07LY7aqUAX6vgxo
	v1rRGfp4b+FRgaRhAgTjMorUxd0j6iWaexLA21uzJMmoqG05LWScx6sD7Efx35gH
	FU5p8su3CCWzBWefCxzIgxCSjveIlDmntMfLNNXIHqinW8uc7sZhyS/xGquVrvy8
	M4FeDExWTQ0qOIu49tKAMg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbq1smbv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjLsJ037148;
	Tue, 1 Sep 2026 10:46:16 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013044.outbound.protection.outlook.com [40.93.196.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve34qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3Yq2HJd2c1wFZ6Njqcr/HJ6LPqL7wj5Hq62awzx7+NiZcCf66mjBWbcggmMaxixViFS4xPVaiGBdF4tzJSIcJGzp5VYLb0wibN6etMlYZ24IoO1RGK1wlP7Z0hMH2ozEolZgNU+Y4/jUqO8Wo4jzue3rmK03UgG/B/PkVkEjiYRGSoOCjBV2RK2HKnsREcxvR09QWBIlk6xD5kK/0+PepscO8DIPPXJVmiwWD+OG6RoJa22we75LDGoW7zYtsivCKVfOqjACGIJ+Ld+YGAKnQ1t5m3FQ39pUxE1SsVdluOPK1v3Debk1P3agF1e14twxes+sL/R/NVrm6dLJPDYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPs0CAmV74ww23o4lA+2MPWaiZjfYFK6xB5v41+QnnQ=;
 b=Jpk4sPZj0NZhXRbXgBM5oJKJQJpxw0lfkIF6I5ygqt6/P/j9IF8rtGAmODy+gEt8nKCCQ0Pzqa5PTfxC03vQ7stxZRYEA3+4ScIcjq+nREACATCLDANBt8vY9RpHchKL0He3vXt5kw3e/PkCRuunxvSJ0zvkb7xwpaQAcJ/TtjEgcqmT+9IlBMbbBqzOsc5sH4KdLz/xcodsIeCvdP6h1jeuRvHyii2hu2AA2VwKWzz4ALB+gd3L9pnoUTTRaGR7PfKQuO30nXaBKJtE/oQ63e/5bGE6ROyX/k4eBzyoZz8w76NqKpW0jvFjC2Ju9BBpNvki4qAqfU9nYaSjEeP7og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPs0CAmV74ww23o4lA+2MPWaiZjfYFK6xB5v41+QnnQ=;
 b=t15q+MMH+IQYSkxfdxjPjC5wJ4zbClOdxbv0+O2Erxj75iSLtovqIyvt+t+auusKOtbtupTgvPI2I8sK9NOfInxEbdLWU0E4ZqrE5sVb/Kin5dFVftcsMPvbPQRsNxCLrO0sdBHwn70aO8Uo6rO229kfpbN4deDAnk6oLsfkKE0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:13 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 17/27] scsi-multipath: revalidate paths upon device unblock
Date: Tue,  1 Sep 2026 10:45:16 +0000
Message-ID: <20260901104526.3850621-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:510:324::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 420aac64-2473-441d-1797-08df08163d62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	4dNCrpVYFOfZuADI3bWQ8UumIqOlipb3mi0vBlx+apvm44/+WZ9KKiL7pK5LOpSYpW5+rsYJBDzSZTTkCxtt5aNCnptDQKRwZkVBNj7HjHlviLmKRFyxFEJvGj3gt9U6wXyjCg9WIQywNJV5ErvGP+grNrCKjLn6E8xU8myjWYHtThAASjtK1aN4pXeCVTUoYfpZbSlVTyLcENPB3AI3XTmaic1NTuJoWFJnt/zEe8kOdEqqgXpE6A59w4BgWpChjHptGrvly3j900CVsdKBA7qEXzKK2fOJSiYRK/LbGv2hlyi/48Nm/O1sT2MBbLb7akQBar5lna7kaPRHZ9BnpIN/1woTu9fvps5Zu5JQj1aqodiCjqPy9w5shhoH6l7Mvay8Gx8CRyteJHbRcD9dXGD0wtC0MacEmQ+Qns7I6DVDx8m7gNGnnVLE2liRpoohMq/A88wWJQg4oM/VD5k8r0IIiReaHODyaKktwIPQ9c4t3CjBFaHn0GYwxnKeK3RMIbv+OSSxg+zMsRB2rBmRfz5joiWyG0VUlrDOGjcPKyqvmtXt9U4BZ1OuJwfZzzyrbxHgoEumpOYRsj3WYZpLZqdVE5yys6oLIuQdZYRzpRN4bbRo3e9dhow0qB42F2Ta8pbT2JvwCD0Et1Nzaf6mBZxQbF4+315dZALkwYfN6H4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?APpd9VBk9ngmfOInDsk0ju9Qv1+bmfQvCWUCkCBuvvSpg3IH0H8xWCm/ya7M?=
 =?us-ascii?Q?IfVOEtpzUhYKJ88fr3WFqN+dgS/nM304XhwlQ9DkroUCkFx/W+gBbiL0/gLK?=
 =?us-ascii?Q?UaSZsMAZVVbGkp+RTmI9tKeB2d1y39WYGRxMe233plQHFgC6S2YdmGr9xu7w?=
 =?us-ascii?Q?gbcgT4d45VQuRAFVrhBEDIRlUhUDfDR9e0GQ2/O7L1zezepVcb4l0yvnIoUT?=
 =?us-ascii?Q?ogGkMrI4gquObBH+cemnzIBPBYJw2q1WFp0fqFUs0/rjBgJvf+dpjCd8Z0xr?=
 =?us-ascii?Q?dtjsNn9Inso2ZD7vabNvUe45hx2JDhnpB+q8bqLaEvgzvm4su/BpJRjlOkg4?=
 =?us-ascii?Q?pYetGCRwDdrFwUuuIBaxUS3TUNgOcMdA32JcB4MnbSbO0viMAgm64PcnImtT?=
 =?us-ascii?Q?kkNz9Kq7UNc6a0v14RhiLlLdR69KQ9WrHTAv9AV1kNcOxf9sPO3qAK4hlhI4?=
 =?us-ascii?Q?Z1m6xjKew7oXTPzrqe7ZndvKksf5N6kBFNzx1dNBbBa2xXBtukllHlile1yd?=
 =?us-ascii?Q?3sZmG8GjnM9YCABdo4GoYlO0KY8c96kuwNcR6j85hbpymNvvjGVI8wJFUPXP?=
 =?us-ascii?Q?cxp93o5i7AMG/4u3/WFk4se1vKYfhqVBKkvmoST3UlTvuQOymHrx66HqckmA?=
 =?us-ascii?Q?fgbdFRzZSSlnuz9aDkOAzwDT5gIIMNyws7q0s3W8BZQrpBQJUPnVm8+eWGsG?=
 =?us-ascii?Q?1Jt7K1IkAZpmwQdF5m/v8tbRFGx8mjwIS9PCqE9mg86WNJSofqtSHQudiViB?=
 =?us-ascii?Q?qztMI/cNq/QEUor3aGjaTTsvfZHjdikE8Eb56x5Fwixt85kNcgia+19OBWOt?=
 =?us-ascii?Q?ISxm/skvJAaT0VcFHVNmX/obJNhY9AeX0U58gZCD5HKlVPZqnpIFc3C6bMCn?=
 =?us-ascii?Q?EfaeeVDS7psJPqBTQllZdRv+7Sr8021Becp402lNT9ZaHk8A5oTQzIOrtCt5?=
 =?us-ascii?Q?QzYpbUSyIuAX4jJFn7OleOa8bN8zMjZa/9AYC1T85qtIIpBJAvn+IkCnZAY+?=
 =?us-ascii?Q?PN3Jjpu8uQxL4Pr7Cqlv8MAnuRvSmeDbp58OidO6f7qmTbIzI4QX4Akxik7B?=
 =?us-ascii?Q?8+V8qS6eJ1VBO0Yo3RupdyXwqTEfFChGXnOvFqPp8uJGwNcyaLXlDWteF4mP?=
 =?us-ascii?Q?G21zaDPTbEKJP07xMDZ5qnrBzInKfj71Ll8HwAcnqiZHXJSnOfGthK5JjnT0?=
 =?us-ascii?Q?14yHm9+FFQlrRCTBP/g7+uCsu31EdmUXye6UMeLT/iRW+tximiyfxWQ6i7cP?=
 =?us-ascii?Q?/MVQIczL1/iGPbnxfOKF3lfnC2G+ub4Cs5F4f4pN4tUa2uvs/uNNSE4j7THR?=
 =?us-ascii?Q?2w5F9ZXsJvp6eUeUalSATmOi1Sy6ae/q5oVWuCY8apowqCQgr8ScnGx7RwfH?=
 =?us-ascii?Q?ceIhHNAGWJ8/PDSJuQtpnMhn88hIY4ejyXpCOa2xasmaMv5DC+WsRnN2f42d?=
 =?us-ascii?Q?qULylzSiI8Q8mfQM9NrL1ieA3WP5DjzNy2CBfaBQNZk7r4QX/2yGC4YcMnTt?=
 =?us-ascii?Q?au+HAatZiPiXEVHMuNKqvCt6pW5WS37cerKd9Yc9xhK4coNSz++Uen2ksXAc?=
 =?us-ascii?Q?5B3Mujx2Z1ywkQTAtLsLnJDpyEyreB5/6RWbxn12UXJoEttMwP3Io7sX4uBB?=
 =?us-ascii?Q?u5fZQRgBn0mUktfTuli4hiUFR+XCmPr4XKaDq0g1GAmkg/D1L0d2eYwLt4uY?=
 =?us-ascii?Q?TMsvzDVa77WUU4h5TmFobpdCsR6HSZAN8Jz2QQ9Oo7vw7F3+Hqj4BJsvP/Hp?=
 =?us-ascii?Q?Oxa0YNg7z8UJO2Vr1Ioc4RTcHKAYq6I=3D?=
X-Exchange-RoutingPolicyChecked:
	CPJ0+laXMgEFRmNENXSN3SW0nW5EI3SIr011cCuJPnY9Ho1MsL0liXJeQONlmC43ue5hJn0dklxZN/CssIcXuoIvCWyyIuCTcxvsrrZR9PhkDfp0KD4SSnyErl1xnAaQx42us3hrXHOzn9cBvatZyiW9K0dCsXTJACjqu2SXAyQ2MgkIScUCqNKUc7sAd37l5yy6h+XWVfpTTOKgHGSk+7N/Eh5S6iwPxwxCK7p1C6tdSwPkRdEDPRh8VPDjUzM0PGZrredXlo9W0dNrPD163exbchQYfB1a9Syk1iR9c/yTcysmPk8tZzxu6iVRArtO5ZRSPamsYKBFKYMIwNZ0gA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Oq1vY2wB35z65y3b2DFs6SerkR9Pzy5DW6nvlsk6mAjgPmfU/YrWijK1aJVaZEkHERQgpw98yQlUpGzzV4CosLRes/ns5wL60kiZ8muXsKnfuLf7TGBvhR3kEXWUq1V8Afp0/T+MfCuJl2yioSRvSo8g36MStLK3kccfx/kVjQlRgRCiPgXZeYJSfj9iEIWP3EOUQ/FcCiIL/iImPI4u3+uNiVcAv8i/V3lI7xUldGSLFS9uaWixpZ++MLBjfut4mq/akWdEoCqI+D639+3UjZ9kcqW0BE2QWqWiVaQMZo0nMcoEuv4MOU/fgpFQYzBsP2Ppi8YzWlrevivYo18Lj95Riv44XrkqTHC8WKq/N5wo121FpUIkq2cFYp3oV1t4+pmKfDQj0uWuV5ZVH4a9fI+SLRlg20atfgQ6275SBDnPt2SyKHst+C+1Jxu6FMclXv2qrTQsa9TxO89SB8RJDFD585Ocw/8O3aZcPAqXsAhWQIbtuPKie/p4pNqxDOCyjX+c7trcGLZqoWYOlxzeicRooN0BEwarxmLPN9mBoL7w+U/IF7WzP+rS0WB7j8g549OBP8AVZakVzu+vCAh+WANAN+tSzOKQML6Hh9G5MXo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420aac64-2473-441d-1797-08df08163d62
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:12.4276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WwmFfYf1Gn+3ymM9jzjF7vRlTil8CbU7YkVlnk2s6AivLHV+BySVTBSLXuY5HjhF6Ip9qkOI9QLyDw64PGrAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=922
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Authority-Analysis: v=2.4 cv=Vp0Txe2n c=1 sm=1 tr=0 ts=6a96acf9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=dGdLxrnxUM9qrin9hOsA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXwkGyOQYJCwIO
 3UBCjQmDzq14VCl8wyYj3Gdo9igIm/Qkcw91iTu8WF5EyTTrt68xydqu1DFEAfUGlf9f50jZbbZ
 66hKnOCN4Ckf/fzksGg2vvyDtLMnmE8hQX6LaQzvJELgOq5j5SlK0o0/dIcUcWsZ1KltBiwBIS2
 /1zXXjJxnNj0ehik2NqFDWKUMLUKQ255qcalY8OGF6Bs2bPzpaN6iptuJtSOMQoLYgQMlGumWUe
 cPUuDhhhkMMAxZS9vxOOHEYU0RCPvI3Iy2Ud83bF3PU0+gY+m2fm6yQHvGcgG5GXVf8kOOAyLQh
 OSDe8KqhT2iLgNgUjJDUfmEpYcJ7WMCWS80xEFy0GOLemL0WUt5YC0Qg5wd6u1j+ZKxBGAZmbjX
 IWLd1ocr0pNZe/lOYPSC6y94KIidluG7ClZXDpb1MN8F9oJjUgYLn9f+oRrYmq78yyPi2nlSRsy
 bueONUx56hZyT3VIM4Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX+Q2XVIJrCpot
 mZiB/ofN8TczY9Yn7wnkQKf32dyxDO9dyQ1gmyA29CTdwt67jbNGMNm5qdHcB0D00CrO+m8nR4o
 MbayNgqi1rekwkn323UBOp4RpgxLJqAdsS3vVozM8Mi6TD1/mcim
X-Proofpoint-ORIG-GUID: JdZbc2FKvAqXZvFg5VF6tgK5SyPbT3AZ
X-Proofpoint-GUID: JdZbc2FKvAqXZvFg5VF6tgK5SyPbT3AZ

From: John Garry <john.garry@linux.dev>

When a scsi_device is unblocked, we need revalidate paths which means that
we clear paths and requeue any queued bios.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       | 2 ++
 drivers/scsi/scsi_multipath.c | 8 ++++++++
 include/scsi/scsi_multipath.h | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f02b3a50e20cd..189263ce56624 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3093,6 +3093,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
 	mutex_unlock(&sdev->state_mutex);
+	if ((ret == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
 
 	return ret;
 }
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b16fe6a55fa73..456351fee4b98 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       mpath_revalidate_paths(mpath_head);
+}
+
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
        struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2064a3e922748..6e50da94fc5dd 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -56,6 +56,7 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -104,5 +105,9 @@ static inline
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

