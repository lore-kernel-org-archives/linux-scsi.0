Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63E1F8691;
	Sat,  8 Nov 2025 17:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762624339; cv=fail; b=m08EVrJQy01708S4gFSJxiS3Drte5gwSYexUuLYUBelNFJkLKUQJlmrjZTeYMdkqiUtTR6Jsmd1CD/coPWIb5hpU6wOmJQaD/GxM8TJXm6KCza9HA4AnhcWOKDSE+pHDUu09UjWG6lwO6vGS70lXxcAxISOAoPwVwCC0xTMsX/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762624339; c=relaxed/simple;
	bh=4VopbIc6cyykjDOlIQ5+LTEuShBGeVVEvhC3NYL79iY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ln4aTMBBeaeLN3/+S84IQG521l1rfBc7yvy/DO6IlxGual2bFsQwCHufFmTqWSogekjW5ckCekBoYcP/HwvqIyhB+BSqYSU39QByrbNItoA/sYb0HdyvwBWA+/zHLVHjt6OUXR0ZJ7gHNMIBR6bCHYTYPAcPP4KnCisyD473m2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iCFZWR1O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LhYmvVga; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iCFZWR1O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LhYmvVga"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HaG89025470;
	Sat, 8 Nov 2025 17:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z4EGPyZPR5QQVa7MxK
	azAJ0/q9VXvqPd2n6U9NniIx0=; b=iCFZWR1OIDKXGbVSByXwfmTq0dOtpq1JDK
	QGfTB0FSBQ4IGjflbLW/eVqgev746Ar8kWXIVlzxZJnZ0E1Dy48y6SLNftfLal9P
	vKgJoCJclcnp14cJg3FILvSPkwKIOhEVCoPDzaj4N6JQAuUECdpw6Rj7bLEkzTLr
	3rn1I144Iz50HY+Nc5c1oQcbkBpByqN3UYjJOmvlmnHgQisq5Lk8yDXqO9bzMugD
	5s00a2q72UAUwPdSjunN03Pb+QOKEwMgYN591dsJiBB1MSqhKSpp8q/h5fJVC2Q8
	5VA99sq82gAgG6THQh8+HigxdoWoRYCqo0F26DLBXJtMOQtT44Cw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se030b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:52:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HEIo4039940;
	Sat, 8 Nov 2025 17:52:07 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va6qane-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7nF8OxlAcaTY2sxsIn3+GhllxD+oxg7hKJV5yxLUpbKmH7a0LJ1CjZTNsCC01PDcTrLbNZwc7G15XdqtF9Uy5zetWDIjxwBWaxcDS6Lk2AtRA+Z5fhpZNrcW1DnChVXaZalpybZKCWmey2LbMFmmeK4CnrySpCz6GxGR035ExhHrRI4X1crvuetJk3qjT0rSbzGWiVL8RdonATh3YWaLljwpSjSsxJxtKBp0RwAD+Sw4NhszAELvKU/14QmDBumvkh2I+oazhdVGzHav8hWam4w0qYJdXYkZUZjGK8IFbEza2i7dQrP0XMxihEnx1Mx8qu9e8PL4swBZyT9J0RsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4EGPyZPR5QQVa7MxKazAJ0/q9VXvqPd2n6U9NniIx0=;
 b=zRX8d5wmUY/ahojbDMdm1eyHiiP5MiTQ686r7IOosTU7ol//ZpDY4jkE6ZZPGInI9LF7APoJ2IRbtVAqqfOq8Uy6nOZPFC9hSx7X187TXJ5YiqQeHlHeArxSX3gafTksIQbZBxJHVwJ390EKZOgsRMi/ZJ0QIBhcW8LKFqkmTDXFejR6Y3IK0aFQUUypzvgXJd3mYk/wG1nX+33iuVJdlUR/rBZjbqRhNugCR0FaCdSBlHM6JeWvIR4IVK2+3KA2jyRXevfXwCfqsHQRLY3klGKizOzN5V1tU2rM9fdrdHE/ZpJsk+Nfq9/f9kLIDRweIXXmsLJ6enj4yHT9vYUU9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4EGPyZPR5QQVa7MxKazAJ0/q9VXvqPd2n6U9NniIx0=;
 b=LhYmvVgaZKTheShysYcjAimZWbWH6AYt9VnXkUweJxPPJ3L0+cMMVWYS5MrZnXt+92O+OcMg/un5YnYwpzoKzoFC8iEUb5gT4hbgAIcY0gE5Mm1h6UatJdtqOufHCsGpV4yLrEFyQs0jHoXUTFuatvBjnnwwHpGe6/Lueu+8+YE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8187.namprd10.prod.outlook.com (2603:10b6:208:506::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 17:52:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:52:03 +0000
To: XueBing Chen <chenxb_99091@126.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E . J .
 Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Fix coding style violations in commsup.c
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251103063824.46891-1-chenxb_99091@126.com> (XueBing Chen's
	message of "Mon, 3 Nov 2025 14:38:24 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ikfkifah.fsf@ca-mkp.ca.oracle.com>
References: <20251103063824.46891-1-chenxb_99091@126.com>
Date: Sat, 08 Nov 2025 12:52:01 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0271.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c1bb67-5be0-45c4-23e8-08de1eef868c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VUWqXNbjrqQOS4ANZM6z0HQlfolIRl4l7dP1unexklQnNiZnIuzpmmHeNL2I?=
 =?us-ascii?Q?r5M7qe3UYJe/DE/pH0Zm6ATKFTcinIuYHYfecx3UIa/SgNy6T/Vg2bbFMtye?=
 =?us-ascii?Q?mQFmQuRDVz4hdl5qu80872u/3Ft6kON+m1nbisIqR1+LetXxSlFGkThnfA0X?=
 =?us-ascii?Q?62bbPJZmTvmGspl++yDzpyoXUPyPJlLbw1Uuke1V8kprpqlcwP4lBtnOMM9x?=
 =?us-ascii?Q?s+W1m9s4J6QLNXnzPTewfF7TvZoxfhZoyu5LFqoyEICgpoIrlBuEduePiM/M?=
 =?us-ascii?Q?yUbyOmzBswRiJQHxT2yTnw4Zk/4mcTkufNKi1QnpxlVNkbAnLBKHqORyNT1e?=
 =?us-ascii?Q?CdExQIxwnLYOXSRp21CMq6CuTOvTQTtPxC+Y2YPifaacfkHOFgILnN4swmO4?=
 =?us-ascii?Q?ULCEhESUjcIbx955lZbVr7T5ABrgI6l4LFKthlz5TH89qopauO/l1M0kuYw9?=
 =?us-ascii?Q?wCQ5dJeJlyzzoW1zwc6gicjfcBSFlHZUa65N0GOYOYIcoOsPut1FyV5x3cXm?=
 =?us-ascii?Q?WjX6qQ2F6ZvCczZshiwr3PC3SMl3EdKLBn/COI4SKWH+2zepL4OxldYZ0Yz4?=
 =?us-ascii?Q?qPfBuzoaSXpkt/EMw5BPuVZLQ/qLrbZoyDfDFPAKrkxoxCKucY7Ai7ZPFdKl?=
 =?us-ascii?Q?OoV+zeA0kDEBpeYIfuDg7oN+Z702paS62hq7/zOyKOjqfTQ/ol/kAmHPhl9B?=
 =?us-ascii?Q?rR6QV3Cn58zHfASwDw6iNIMp7p7BJnGup0oI01RlFdHDhN7vcUS/BlKfAX/8?=
 =?us-ascii?Q?f2xEoDAvKn2Rqwbv7B+tr67f81knCaO8Z47tnS5jjTCB22Rpjdv3qZEYCVmH?=
 =?us-ascii?Q?vThqV1/rRtjNTHHHFZqSApqkNTrTNjDi7/Q0Kpt2JTX7knGRycMGSsBxoETy?=
 =?us-ascii?Q?+Ny2r03dTuYEC1TKKwwM9bnTSgajzOizH1z83B+7K24j6GbcxtyjSgjH/HGf?=
 =?us-ascii?Q?7V2c9Xf1YCLM+INP+PYYZdM9TpUoW/D9pviVCQ8dMDISt/2opPjJ6GLb9PBO?=
 =?us-ascii?Q?ZWFcFH+cWmqeEOg2cSLQ7EIqdbunsLd9QX9fdPR/apO87s9mV/V7M3MUYx2f?=
 =?us-ascii?Q?pYWZY1SkWoww8+zcN6cCStanjcXx/kybZ2xZZRlvDBiB9xXYB3BxNB921wkO?=
 =?us-ascii?Q?abwM45Q6gbdQrD8d2GdACU1o8BTHLSkyLEjGDws8BKNwp1A20bQBzIAzm7np?=
 =?us-ascii?Q?3VMoxF5jqJbAgECL2lX0XQwlTIfVhtl58yuUNg+L/4LnsfviCm3K7kIyyUmc?=
 =?us-ascii?Q?bN6FfxRyJgsPy5TJRtGKPK88YD3jCwohpAQrVXzxgliA/Z/M7KcUf0IT/L/t?=
 =?us-ascii?Q?5ThoKuyhW0dAyI+nHGqj/u8tMMA4zRXHsIXOlFBEyh4ra+3/zMoSURp3RnAJ?=
 =?us-ascii?Q?UsoxMovO6e+iCCBhUnTB4gCqToExiTmMVdzA2RwRV2Vi+/ND+CnnnIt/kTqA?=
 =?us-ascii?Q?9sMkMD7qcwB3ywxC98cXXZzZHUX2n9Dt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?afTX7tQt4uDC9NtI01FrAjnpU4y3N1y4cfJQqOY4ea/f8CiXrdc2slSAVQK+?=
 =?us-ascii?Q?TOHfLvrZTk8hSo29oTlWOQGzXjjHXtY4KRUb4LoD48STJOWEY+VuVjQEteBn?=
 =?us-ascii?Q?ooRbelkFJMqVzw12NZmVYlnFsJqJKy9C1VchiUa6eBBzPvWzpR/wx2vrezaO?=
 =?us-ascii?Q?NInf5ZeSmE795xj0/EJFxP6B37XqZoENu2FtHxGuMYTkY5AF/1bO3RLqNQmK?=
 =?us-ascii?Q?/+722Trp/AwsgAOD2AJRtZTkrPS5Luc9fcVDtwLZC4bSqaPzrIobCwajtdJK?=
 =?us-ascii?Q?7U+L434BafvS0MlBaL3fmNG+FMkywqMHCaaYLZZxTqJoLQmTw0Xb6Vf35rG0?=
 =?us-ascii?Q?Sim2UiQNanhLGlu6pzrty6lDlA2WLUraHU5EtR1f5ziWMdImuQgqqrtmw13M?=
 =?us-ascii?Q?rOZxDeqt79rjnP47Nhdtv+xlcty9dIlF6GyO80Mwg++Vyu/uG5J7Un/lIdTD?=
 =?us-ascii?Q?Uwv5XCbQ2Lw2t1o+Ff9WiNQOEWg/lQwFLzZAmYlZ1Z8BxDRm7tUeubAMxnDD?=
 =?us-ascii?Q?+wxd2J+lvOOJiiJJWSif56hjBZMPkYDYMgBOQLpJ1kdMCz5/k5haZvIgPbmJ?=
 =?us-ascii?Q?ujbKfNBGRvw7/h9qtzneuhFemf20UTbGzhVzoyR/5G8wd9KEB0h0tE9GH6EX?=
 =?us-ascii?Q?iEjeYpkzcO6nWU2zdyhFG7mgON+OxNgfTyULHiXCGQroez23Uf4eX2MAdRzW?=
 =?us-ascii?Q?otSJZS8mDqek6lpg5E26rv0uCmT86AGsFNJG5kRwqEpArSwzGB59TP6GpR2w?=
 =?us-ascii?Q?GONDZVd9tQe9Kfglf4ZiUBQ+mBQsJd0E3SiiCXXE0o0QcGqaTOtgRiFdjpvM?=
 =?us-ascii?Q?2qljqN33tyv8vY/aj6TGnxhSg42l24zSy5Cl/LwqPnlJ+YGAZVgjIto/8qpv?=
 =?us-ascii?Q?Y1qnznPK5X7cckXFno5dJDJ47u/VjX6SksQSRUdvPWp/RZE8O0ZSQgAU5HVs?=
 =?us-ascii?Q?C9+JBmDOea8E2pwEbtXHFsFFqpQ3um2w5SBMqwxA26s4DpUfmobtY+lw/q4s?=
 =?us-ascii?Q?F5wpT7Qw3qzrz5DJxEgC8luhiv0h40CIJczhtBn3KuTPNFDw+ebraLWAeRTP?=
 =?us-ascii?Q?VhwQ0L/IZFluq79cGacTII+75RGj2noAXcjoUEnnKuiNItwx4ww0Wo9KRG7t?=
 =?us-ascii?Q?ati8wELLwjgDSzHzHGK8jrkkVL7VG9bCYZ5B3LzGLl1Cq+PrLvGj0DBFygrv?=
 =?us-ascii?Q?CZIcCNI2zn2JopkAzK5ryeIEKvOq1zA2Y99SDLa2TscbCQjfZ27hdKMiqVdo?=
 =?us-ascii?Q?2peN0oH97OQLsUkh1DT/Imu8HLiX+XsxmdSk/2rUUr+mriT4TtlK9RwqpPaG?=
 =?us-ascii?Q?ir232HlfNVKNmO+6Flfun0s2wGwLixDwhbHnROodDYjSYNS/2JQWju2Q5XMk?=
 =?us-ascii?Q?SJxAiwVeDFEnqwKJCykD4eAv/KDwJ76Cgzr7XS2Pg6iKzh+deBE73zeEbX41?=
 =?us-ascii?Q?rFJNT0g9I9N/HyoSe0Onur7hGCiU3kZKK3X/IoZy36nv/phEUe4CIXYstlck?=
 =?us-ascii?Q?M85feEI2Qqgi6meUl1QGsjnqWdkx97lfWXmDcedHhqqR6474W87OLbVWcA+/?=
 =?us-ascii?Q?grKFa5JcfHapkrpNnkGeuOI5y3EmTsnH0YVB82hY1FQkMJ4MBAKo+JQ1KPXn?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	65iyA80d/hEAG7+Tx8EGmD75D5qSm9utw5ZPUGcM/CY6n71tbnwzK+TssN+gDiuGzLTmJKoofb1w4Bm/s/3DtqdQZDuiu62dPc6HHrDCCh1iT71EUOMaVjBDNkef6htYXjsgH2npIUd1Ry1JSq5RKYPJVKpj8bzi69lS3te5IHo3SeGC9LrwOeV6EeZKdfqq8WcVJqkto3y2DARQjF+z0OzlQgbzKf7GhQmLM+i4DvwkAYMaM9PfHR9bwfgYFjPIJUMfW734ebkuuM3OmWrIoC/7KXOqU9WmXYFaJazw6DtklzaiP7yOie1pRvyJBHhEwjN9A1mm2INGpHb+oszSjoQOTXuSOLM07pvF3YIcCCMWST+dM9vrXyu4hF/+aSIYhP4SONUQfqzxVUXYZLR/VXd9fmwVtf7osyW9EQiz4DmOlJbijzFi7q/TNPFZtRoDwP8APPNXoWDQrEyuK+CrneBYIWpAYe63CqqRmZ5s2IxClwxlCAKtEwPtVIaUWbjDfZl+VHZhXF1oveuDsitt+7V7EkxlwB539hb6bnL5brT5z2bw+abfoRiTHWLONgYYWmeOEaaicqMu1pwwGicujOgYIjFx0Lbjr5mtiQw30Qs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c1bb67-5be0-45c4-23e8-08de1eef868c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:52:03.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ugv7CkIzAIMbZvv2EoY5UBJcMiAOt9a0Q0LMipL1FVAL4nAcaj/ILfh5TgGvblir3naVMcrpLQRyPebkwOizXmw2Q8LGQjXtyp7ZILFAhbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080144
X-Proofpoint-GUID: bdhH1SLsa1o4Wgpn4O5Lt-0cd1VK8aQC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfXzhMT03dYqyYL
 9OVhz2ihyubxA7cm4qBsOJnYtPDSF9dn1Bx1HkXWgCE806M1IY6Bm11ztoGRFhdhcPaCYUO0ImE
 FKbqw9xLWV1vJXbB0GFC5TVCWz9/VN7VQwpsFO+RDWIRGQ0/uzbU8uzUYr3kLqulgE3uHzeLYhB
 6pQAoP1lmJu0VmVPqg/X8IO3J7H9xDNgzjuoQ9xLR8grhN6REyRHcdHRTdf1HIiUM/tWaREodlJ
 pKxY04vPzYbz1KwMbUzzlF5DhRJBApEGMO5/qt/nGpkd4UNMNzBaHoz+rglfvFR0rDPw3YhCkZt
 LZXdp0oSas+wW6+aVusm/bJH5TmI+LMKbO2g8IOjlyZOX8ejalQy/Y7I8KY5/mFuwV/Bs0w51aQ
 T7jzRq54AzXfiLcvujqQId191pT7ig==
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f8348 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=xXphaE5wT5peP3HK01AA:9
X-Proofpoint-ORIG-GUID: bdhH1SLsa1o4Wgpn4O5Lt-0cd1VK8aQC


XueBing,

> Fix multiple coding style issues including:
> - Pointer declaration format (struct foo * -> struct foo *)
> - Spacing around operators and parentheses
> - Line length exceeding 100 columns
> - Unnecessary braces in control structures
> - Assignment in if conditions
>
> No functional changes, only style improvements.

Coding style is a moving target and applies to new code only.

-- 
Martin K. Petersen
