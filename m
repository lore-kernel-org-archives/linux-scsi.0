Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364393644BB;
	Fri, 27 Mar 2026 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644284; cv=fail; b=f9pQR1U11QRKNq8v1Ola6L2l4/9j57uHJW1PvA/pSzRsaAQ+4Jc0Vw1GZyJbrCCDlXv5AL5C/GKOpkFL5mhjEAG8CJyUOo1oOdYsn4P5mPIlLs3fq4oTKwloHZ6sZbppBdstY5V6ejQ0pSnDaycAnmuUD+BaH6h0jwJblLlLTZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644284; c=relaxed/simple;
	bh=lRygVASjr5wQj/gj3KyrdKFzdQLvLur4Md9bTjSooio=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NgNH217Al8EqOjljgm2KsGcsL0t9/30iJbdo/MaaUmQ/JyC15udcAAmnuQkFspjWpEycjikqbK34PNFq5na53/abmNzACmBw8JjIrQOO7fCGKQWCedcFXJoGg4y1Q1nBDVfxflWmlhViD2KgMYyqNPda9ILVPofuJoCLlzgs0w4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iu1oSVuo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZRJfxA4x; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iu1oSVuo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZRJfxA4x"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGvrp9980048;
	Fri, 27 Mar 2026 20:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WLcmI+VpcyoJSfjMQA
	+DN8diIEIKgAJvAPAIyColUZE=; b=iu1oSVuoipvEHe1r3q/QlsxE976TjA2hKQ
	PdTIuRkme297bttvdKv1rOttCGsIjqRl3r/Gja8moLkaPIzOzbailuIaDMhfKMZm
	6omShuMKjPvw+ExIVbeKltNbETZ9NO0ThMt7iUM1u3yzv421JWu4cnFKvrW1S+K+
	UYpSLQ2kvvqIiQk6CTCaCgZkczDZW11Z7EuHCJ3V9CpY7ouywv94KGPTi7IQPO5m
	OqkVgGBpzIw9EP+cDKiTrYNdjZ76unYuogUnicUVl4okvRF5wRnFGe7vEZDvEkhl
	kj87D3o4T/DRXSZbB/M+/g92/mIKHA3/15zZRtpyLEJyuSFIzN0Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kgfts7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:44:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RJBwwU028873;
	Fri, 27 Mar 2026 20:44:37 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsew3mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 20:44:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bgw+d7IuaxHb8wNbGwe9BcRHaQsmS/e1w0dn4GM1TxCAqZeMsu5WiUEPy7YRc5DW30Y8yrHJ4W1Rkk2wx4P+YcyKKNWF3Mi2xRe0Jw4C2ZiTxeKjjs+NWIYBrmeuf/IfjLk3XLFVSUZ/1Tmp/9M9+cMGyOhL6KFvDsaf5FXExoECMtycIgiDnOWwUK6oCNg5TmaDKW0XUQtNdBSJstxXU0aBsjb23N9/tZ7w3oYZzHrnOFzGcfK72wYx3Yg6yXiKspq389UvPzdCdNnvjV9HXu/LL54L9hvbn6AOxphTRLRzdq/JKHmyOclj8hKj7VsBhQTgDNqH/UTB6lM+V6/11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLcmI+VpcyoJSfjMQA+DN8diIEIKgAJvAPAIyColUZE=;
 b=ew6M20wy8xePug3AoWQM3w+JOfOD8M/ZSNP+GttVkCbPwkjB0hoZS/Rp8jCOTzszzivO4ZXreiUlOwz+QmvlqbrxbYbPjxoDveJPrp4D9V6gFjFg7DE/ugySsBemRiF+B/WhSVgV0fNTrLemcsq1MCNMl5+iETHHfLka3SyVpl7JQaA+neqFo3mZdrKDQ2S5FQAKLNxSAi8d+qDOHfEqqh8F1C0ga+UNLiO36kzmpEt7SDDqHcvHm9SnqZD7Lt6fYpksQ5V5dzY4V0mZIYTfHbzorN2vMtz7vbBBhRc7MoTUUhsOqBBA/N0bn58xqJc/Lg+GsC2+0T2qlkV1yejBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLcmI+VpcyoJSfjMQA+DN8diIEIKgAJvAPAIyColUZE=;
 b=ZRJfxA4xP8m3tB/AlFfzaNU7bgCevLC7cvjt+OviLeipV2XM6BMJWV2gGlvijgihyWuGUR3uuAWA2VYSgfL7T9udhlBWFTxSLEeo6CekFleib/mf6dzqSarTbpvcG4/TbT8dXB6sMOAk4RSOCFvRry49AVe2kdwnoVF146KAtWw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6869.namprd10.prod.outlook.com (2603:10b6:8:136::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 27 Mar
 2026 20:44:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 20:44:32 +0000
To: Joshua Daley <jdaley@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v4 0/2] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_probe
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260325180857.3675854-1-jdaley@linux.ibm.com> (Joshua Daley's
	message of "Wed, 25 Mar 2026 19:08:55 +0100")
Organization: Oracle Corporation
Message-ID: <yq1v7eh80lm.fsf@ca-mkp.ca.oracle.com>
References: <20260325180857.3675854-1-jdaley@linux.ibm.com>
Date: Fri, 27 Mar 2026 16:44:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0033.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d3aae0-1a59-4e22-9501-08de8c41a660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mvlg0Mjt4zQG4dwLt/Hluaub+8S8FCJrZD2/t7oX/6m7aMC/NfLhrU75e3js5SuMqyEn9+34+p0CwM3mbFsiZ9b1lit8LFxYsfmg9aiRyZSjnkRrZ7q0kJ00yiY3VBxCOch3ve/9lyKrXvadPzqddWavqQqJkLaVhMCXrThqTskEun4Z9HerZUaHnhoVmhft63GuOh3kG+vRqFG2pKzwqm7NXmQ6zYsC5puqYDjE7wi8sv87nvWOe1vFRgAKG25vZv2C+By96ZmmNqMDIYAXefn2Zj53goT0F9g8GLgtYB0yQQCt8/ZFLn/Wou4C8LPZhdYtpD+YAZ6Vlk/4eNZ2UWJQBOdP+pffFHrntliLk32U2Ryfo9qTE1EKZFoALZsqgdzeOPYeTIbvXP6VUdUxMnJB6OxbkHsg+BhXHdL43hlP1zHDT4Sc8TV/9xKBkO8KurpGRTcFvCOQ0rIs/rV0a6ftp4QIRlOCIK+RyMa8WsNnc4c9/BO5+RsGdlX43IVvdUtP3Cj7xPoStZRjn9K2/KC1+D0LrW4DjLLWR99GnO6rmNQI3n6TbCitmk7kiiGUff+um/NJBUdiG0IZLx43D3mro/bskY6UyJ4Y/+wKgf2arJR5Nc3noWN36woK8UASe88KhlYpJ+5oRUiPfLaE3etTdcn5ZHwvpIJk07TPBfLAsOL1MU9S/pz1Yfi3DzzzrsUwH/HqoZqBrA4YkMhB3QIPU0iZKhVCVFOLh0mMUokbGicHqSha9A9qu82PeTPx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8AOby31SI9vN53tYgQguWeLUxRtsX1mYMiuYQ1pcNhXo6QFE8PLUwmdcNlHQ?=
 =?us-ascii?Q?WQMmduqTHFYsVvHg3xO8/O311zPCJRBekXEuJDpp1MJdwdfp0+OqVyjUlRkP?=
 =?us-ascii?Q?k4sozOdOvjUxN7q3mL3jNiGQivzVuemCGwh3IvhAw7sSHocW5bR03R9W/XaD?=
 =?us-ascii?Q?/5RytkCiRFevE35/S5kk5l3TUMPvH+KC1Yj8CDvUJiHUnA/zUQ639l8HshPH?=
 =?us-ascii?Q?4VDYDP0X2MJzX4Qj/Z6GYiJQwTdy2KZvUnvWyFSipYcpedm6T/S9eJ55iccH?=
 =?us-ascii?Q?4GcuK55GXz99aGbdJHVUOGjiYVVRsIyxauZWiZrm2PyLAFZhAeX4VP72+gL7?=
 =?us-ascii?Q?OviZWxhR7UZpIRA63cVoj+qDPBgDca6X1uRaCN1V5C0hAnhAwP8r+0tuwCqX?=
 =?us-ascii?Q?osFzWC7rikjxBlSGz58QMAZGxe5oYpZxIQBog0iNJmZG+gXI9ZVQclLEH7qm?=
 =?us-ascii?Q?3/fnqN2l/mskca1gTYIFzJiT7gm85W/oLphkd6sycKUWXQPuxW5kK1iUEYeg?=
 =?us-ascii?Q?S3eX62HdYHa0qIXr2O5f5ijJ3HGWe5Nvi8TOeQ3O51TGHABT63MCiCYVW7Fv?=
 =?us-ascii?Q?aAW2bM9DEK6ASxarr+mDAIPNhBKwaPJIRVcvC2kOSYIewoGlGh+LpxJyCftF?=
 =?us-ascii?Q?34N0qzK0+jzAGJ1iYkBNGX9/JX/P6Ww49uriARYEiM/2VGx7vC+4FL/5m10s?=
 =?us-ascii?Q?quXFy7DgXn7CUiNtPqYIn3Vo8Ur+qvxc2NjZGCBkcE+cTvR1zaBeFGaTQMAe?=
 =?us-ascii?Q?XsPOKQkq66E0xyUVvk6oBfI7v6PhZdvSuC6HeO9Dvk6AleEWpWNr0XUt8+Lo?=
 =?us-ascii?Q?oruK96vgmHXcV67/MB9z4inXn/F/cnfB7In3RzeMsw5qakpsUXDr2AQAxAOx?=
 =?us-ascii?Q?xz6DNdajd3wIqpzlFVqudI6OzwVbSYNPOUUIwHH6r+qOp2vywfcC9AwsCQ1B?=
 =?us-ascii?Q?OKZoTWtLIM0upUVx2pn3ynPDq+hSDU1+bSMU20X/4WY36Xo0lyPeO5+AT+I9?=
 =?us-ascii?Q?ASIrY61uYhuDz8sniw4KHQ3mClPxGf4fazdnJ+S/g5A8eYh+8sVN9XhK7kwn?=
 =?us-ascii?Q?L4tj/kn6nYW9Zp/0t0z1r4fsdkz1LxU3odFkqwsk/Oool3y5aoCIAHnIKPKP?=
 =?us-ascii?Q?ZTfKiXAcycqiqRkuZ7Zh+CXo8JT/IFYan+g5eigcv8k15jauQp6d2s7rwucw?=
 =?us-ascii?Q?+VrCKq7vwYRYP+btTFN32U4+hdvJID58dS9ZB9eRLTkwjxEqcwHpqqJQH+Cp?=
 =?us-ascii?Q?XJ5rXZ4yrskdkvEHnYMQDFVMYMatMIbDvfB4x7zydnNaTkwRGmbaVrWAafW8?=
 =?us-ascii?Q?MUQujhz4B+S18xp1TyMrmg1Huwyzvw+chB3kLZRKXRb6lo6YGdw4/elv09Y8?=
 =?us-ascii?Q?9n6M3duM46hKjPklPnWTx6X7jUh1Aw59FgW++Ru6sO86XA9ynDXpCO4w2Jf5?=
 =?us-ascii?Q?LumfrBL/EwBOvIFAZ2ip5VClwjU6L6S7gibo6fagNkptxhXkgKD6YPRbOg8U?=
 =?us-ascii?Q?vIot085xgjJXaUHzbT4wwR7Wszzsz8rPS+4o8Nquceow2u8gtkVYLFFcNMFP?=
 =?us-ascii?Q?82Rx5YTAJmFghYmX0MooSsu96BuhJnx85uQc4PukjwQXXDIu3t4ILc+ahMDl?=
 =?us-ascii?Q?h/urdljWrPaf6x2HXpOaFhQKwbSV7u0X9E0JYkuwpzqQxVpqAEFTKUMiH8Io?=
 =?us-ascii?Q?AvnUczVbKB9F2l3WikDPkmRuTI2ywnyTql7fKWodok0Oan1DNlnY/SqdFl9S?=
 =?us-ascii?Q?usPtUiuUxDKpcffwhS7x2guDE4xpF4A=3D?=
X-Exchange-RoutingPolicyChecked:
	CExfRp/xeR0Ztn2Ka+hKLpvSMjpR1781tcxD3ZJ5roJCzE6OWrgJHtSkY75jILsqm2QExqIpe1AqdkH+3i03GLp4cS9lxHXwwW5vBvlXDAAKBs9ta/V0/uC/2gSc4nNrTD06QXk6jSiUAbhgCniQZ5FvXnCyPwlF3UnP2uaUd28QgRYqBt49NY7dPDV9ZHmS3cPuR4LN+o5h3Qfk1OvBGl7aOl5XTbf2lw9JJdefmqvAAWkZDOksazq6RUynfhVTD5pn55bCGvyCmcG2WeNnzMcvhxIoWS8xjM2cbb3Uref4MD0Yf2cAbKsW5jmysOWA2scGC7iE1hZrF25sDnM9qg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VPz1n6RnKnD0QreLovRD9kAqCchyUnycctrHqq6r4gk7FrQ7elUz1S7dstw4oYYA0s0auMRFcxot+nGeCdKbwFeLngtAovSYIysMs86jt4HpoOMKTt5O5ojZ8Kw+SRQ8POj+6CZoDg2lO9p7zr/wNLDdzF1gLme/j1ndL9mrWbZyOZjR438ry629utiorOWO2HZGNaeNGSX4uUYmnUOqul3Ud7U+3KGiupcaVQcioJgoNDFzEtQsD+OXz7Kd7TWL1DhL7rLGp9UZI/mIWkZrhbfIYfE2ZczAv3QN5ILwnoxFu2A5w3BKHbPha0VAJfFoegtJRit3Ih4zR4+rBdSaFq8nIhM9De0CehMTu9W9MLv8soDJhOOn9lFqgGXdXovDNmQTL/WxRjRXLUFxeLFoIa9lFH/OUbWAZw8EQ7SE1bPINWCdptj9bJTkW5lITBWQPhsULErrRNg8w3raHjjhf5LoL90mqEWGYaJBrQR7bmh6vnY5O/GzAZOluSKfTIOY63XJ6yH8x+U17HFSt/11q+ZQ9gnn5dHbp9tyf3N0zE9v/ZabcuUMVihu7jFkN0lSW4uqGbDlieTE6NOa3VR6TagGje45UGRsmTy6qY7iI8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d3aae0-1a59-4e22-9501-08de8c41a660
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 20:44:32.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/5qc19fAt/0mKrYVmRaKcWt8cwokz9FsG3WuCCTQ4NdwmpgdQNOMPj20bcpbvXZuNbjj2F3iOf8p8LUXdUi81C67ObOtsG1xjhu6NHvEnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270145
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE0NSBTYWx0ZWRfX43yin3EHCgPZ
 +/qjTpwZ9iyi0r9+fR4XCeSvblNAgEqHhG964VK/ibT/uoM5PJZJprwBcWDthk1n2+h8zq20kfB
 gGsk9OwYi9mM9AVoBR85BaMMjfb2FLGThUWGYWLCFoztm2BCjYOhkO94YCaZq0DqLlEUkADwUzi
 D/xuwHI9rpkzYpuAhg+y2DKYV5ScjB2ytJ+3JlDhRf3TL+NiI0ivyabsXiOFymzf1mCxZ0mGapq
 Ius4h3fc7EpFrSe+38O3lziqbulac/vVYoyMPyHfDIK66WauSlGI/nD5zS+ZGCCBDcZ7vKxH+ua
 4lL3/gMSntiLy/vUSrmCzzSbXn6ZfcTpsO2Iuvuut2DuQ5ntToYV+EgjwYz0CEMXn8xtfzBhWCa
 qwgdNCRzAPSF171fQVB3D4nApG9vvvUzN0PjqHwBNZgB8VrWuB3VSHUg3+lyKTqqm3ZeLW+MjLx
 pAxeSimkatt4T6YsoRg==
X-Authority-Analysis: v=2.4 cv=aq+/yCZV c=1 sm=1 tr=0 ts=69c6ec35 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Zd2fF6XEy7yUuk_1SsQA:9
X-Proofpoint-ORIG-GUID: NgCoK97AzZ6BOI5OOnxntOuSQR7cDhFf
X-Proofpoint-GUID: NgCoK97AzZ6BOI5OOnxntOuSQR7cDhFf


Joshua,

> TITLE CHANGED! Original series title:
> "scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init"
> Previous version:
> https://lore.kernel.org/linux-scsi/4a93583c-47a1-4700-a7bb-da75fbd231dc@linux.ibm.com/T/#t

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
