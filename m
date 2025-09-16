Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D049154425;
	Tue, 16 Sep 2025 01:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757987053; cv=fail; b=EENX4uuDd0X2Gd3tUM4wmp5Bgt1g8C7GLPXEu/kNvRSbxdUwcpOnBGhOLPEdNhBm1HOXEwQqEycFO5s2tP9lYZ8IQmXVu6FATRpPGyK9xKKF0cXNq7/h367CAw5/kW0EzFR6UMqC+BjsI1CO8jBwQ9DaQChfy9mqTxLxMp4C1a4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757987053; c=relaxed/simple;
	bh=Wdjzb2SJBGizzeMRzM9cn+I2GMCJ91gc9knb2s8Nhys=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oiN9+/ocYMpHZFbX43bhwUcGEaDIL4JHZbmdlumQCxzdGpHmGpCFINYCgcYrdi6c3V3LaFQFqNGBWEvaGh9slTGt+d+WWl9E0PoDIDc3GJ3HI8ibtLbpa8+0/xOnsfNQxRK4PmLVsjjDT0Da+OQCtWu59LWnNdOl3nVksGo83ZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UGtM+gdT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=czdwZ6yn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UGtM+gdT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="czdwZ6yn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1gZej013998;
	Tue, 16 Sep 2025 01:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7WUkSKfWg7pGUtxV3l
	I9e7CjNB6aP0f/Yu5YqhxCc6U=; b=UGtM+gdTJDD9jq1yZeKWcKm507hOuDeOSr
	Xlx09E7CsLazMOQ+ZHwJjWrmhUDrC0qH9j981mhWAWjGwR48izQNzKnFMA9WJELH
	HcTuS1GxrzJDeTypoguDi1cuvmTkEarKFYQFhDxb1vRyZb161gKvRA1Z7b0AF2FP
	P17eRIvylXDLTXGo2UvBXZJyOuhUgrwthIlHM6Lt+4fj0NHlDrmn6gZw8HyqHXGR
	Dp7EPlgLfPmefGjiJ7O7uECV+S8rF2mvjd8lXLzAmnY90texFKf/nrFCnc6s8Dx7
	duI4y03tPi4Q5eL8X3ICWGbk5Hw7YwBy8c650txO03RGWoyvJH9Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yhd3nf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 01:44:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G0vAi7001468;
	Tue, 16 Sep 2025 01:44:01 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2c02v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 01:44:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=juSzZMSE8kyJFOuUniX8vSVuWnddXwIEPpm/ik9lGpf8eqtTew71Gs1agikfvEd67owT7UetxHqm9FYO53ryUT2TmVNSY5MFDFVGB0M34jVNxdU+4m4rjax5so00VgUdnlZUqaM0lhZsgKKwkNipEf7wW+lYZSmPcHjre+3Tbaj90IRKCBc7bgBjRvcwsI/d446r2w0CGl0bFrvXdqDfnAitQSV2J96TJFVqP9HcqfWS/5FjDEYWwJ6Ue3c4xt/GmvjAts7/QRr6XmcYlkNGZvQpsjCNr9v59NrDCkVw3eQd66nSCW6a9gRGA5IYVvWOhBxkBeSrP9KdtOvk+Sw52A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WUkSKfWg7pGUtxV3lI9e7CjNB6aP0f/Yu5YqhxCc6U=;
 b=U1geiNo+LkOxLL+g+wGkbx8ZDJs5jYomZ/0CvFprycTsmjjPVcnhc9B3o+nata4cTAoRqVTjbzBEJYtk2u0ZlPnvs+9J40LN5+4KCOViahr1sMUrvy+XKhB8v/XfKO1bNmQGb9NvN6kh4LkYYE5yiTsfDpBo4O1IRzGN7uGEGnckr4I+DyVR9H2CTKDs0IgPAH85T8Lg3v9S7id+a/0Lisl9rxqdo9ZsdOHI/A0+8cefPgfcuaJa9+W6m/HVMb22wOnn2itVoEpJDaDVDmETYGxeIuLAb6SrzjFk6uxxpvSEm2YyRIFB+/WWrMcGQSYDp/tW4Dj9fBRjdnZvrb0SLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WUkSKfWg7pGUtxV3lI9e7CjNB6aP0f/Yu5YqhxCc6U=;
 b=czdwZ6ynNgooGHW0WrSzVAKQBEbuH6qF2QRu40jCmJQ32MM0gLeWk9wJrAVxgav8HklmISVFJU0JVjMf/3hp5O94ieYq//TcWcXNHvs2Zn8SJ9mgpHHhhEc4WncpBTCQq++NEipucWuQ1mLVkhTfaBQkSwBwk8I42rd2Mwv/QcQ=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SA1PR10MB7856.namprd10.prod.outlook.com (2603:10b6:806:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 01:43:58 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%4]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 01:43:58 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: alim.akhtar@samsung.com, krzk@kernel.org, peter.griffin@linaro.org,
        martin.petersen@oracle.com, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: exynos: correct sync pattern mask timing
 comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250907202752.3613183-1-alok.a.tiwari@oracle.com> (Alok
	Tiwari's message of "Sun, 7 Sep 2025 13:27:49 -0700")
Organization: Oracle Corporation
Message-ID: <yq1qzw72muo.fsf@ca-mkp.ca.oracle.com>
References: <20250907202752.3613183-1-alok.a.tiwari@oracle.com>
Date: Mon, 15 Sep 2025 21:43:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::18) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SA1PR10MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a1a98e7-af5c-4835-8117-08ddf4c28131
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xqMrJ/ylAX279gP60Py2eiamIpNMOAIovWEhKk8Yl/Do18ggKHMXZp4OKuJ3?=
 =?us-ascii?Q?k08SeHOd7kYifum/yGBhOUHlmeTDrUGTRw0ofXHRrZdm12jOOdNlEfc5x0Wl?=
 =?us-ascii?Q?c01I4D1Iu7i5kETf5AoPZZG7kgFNLWD+HXLXlapXUgWpt2lpn435mSu6YgE+?=
 =?us-ascii?Q?r8gVQvn3Obxd1GjTd5KZHWMhlD+Kxb+JBcNxey+rKkoRsnB4s2jZMFMxg9Sg?=
 =?us-ascii?Q?d1jeDCQoE1N7+HTmfr5iTx3a6+OkAqSHXIgjQJhLW8C2LBK+2bTnblIBOsZP?=
 =?us-ascii?Q?HYxyJ/wiC/j6NTOv1/UghXWBN1mvhrOZXuSMaKimKCIAOW+VYABGM9J1HsYa?=
 =?us-ascii?Q?StCSI+UZhsWSGGaW8rFE/cM/EG8a4yGrrx11AUI3J8IPWDCqTlgbbsan73He?=
 =?us-ascii?Q?y1zql0zv/gCO+B+r/KR4MP4KNQ3aDYZpGL8ptaBduS1sNgEj3mpyy55xOfXF?=
 =?us-ascii?Q?EYN3fY2jQX0eWpUjOtIZ4u2WISZC9LlQffzYhXjwcqs2BeDRqlzXEneF5868?=
 =?us-ascii?Q?YuKH3m0IhuTy9LXsSm+eoaZ24LaNOFFpqwqrhKH/a91Mcw4IiAmeDNcFPdPG?=
 =?us-ascii?Q?buhWW4njT2hvfrUDTgTLOUvZJ190m+ri9knBpojV3m4xGxsDvE+ZufrZryoC?=
 =?us-ascii?Q?G8WUfjJnGW5IX+WZ4FkQaXjRmFYaZubV3/nhzont7ZUoGmnX6gfqZkHqIeUx?=
 =?us-ascii?Q?pRPgXlqLD5Bz7TdVkY6/SLJ5/49fnf/IJAvZ42GaSJkcFxjXBlGSA/kOyEEp?=
 =?us-ascii?Q?qVACD4WtGMJxrZ5FqKP+JzBbMwMjud+ybcWVUQNbYHKSwsjOO9VmumB3qmXF?=
 =?us-ascii?Q?IfUnxVy6MbZVEzHzYuOHdf9AwafwLc4u69klh4Jtf25OMnCtQ6RDnhW32AjF?=
 =?us-ascii?Q?8D4pEK1eaXjFv3SnPwK2Hd/WKOhaXYQtuj9sHGezWoT+2zsRiFAYMyfRgzmk?=
 =?us-ascii?Q?jMXQTXIjv1eq9Hc8O4rEC5olsrXijFNcQIeYK4ARA4psjzJyyVpp9PSMJeeQ?=
 =?us-ascii?Q?JL4jh+FivomRicJOG6TRTFrolR9J0/9N8acYw56d/+5G8vrWKxUETLM1r1rX?=
 =?us-ascii?Q?4M1DQ9Q3g1tyA+N8MdWNSvJPmGw9U/jS+T8uZh2nkGleByrqY0OT9DVRMCUR?=
 =?us-ascii?Q?qfZQK6HMhn3AotytTBrmkPt1SU8/tk41cHVvNVWfQm379/wSTUONJrejd3Oe?=
 =?us-ascii?Q?NZUoI1br6S9hJiVtC0q/NTB8i2M4A93QYYJVGojq7cYzVkDaGxOqJmeFE0Sd?=
 =?us-ascii?Q?kq92aWNoJh1vDQ4aDJ+vEir1xv9KL24NUSEXZ5rE4REaLN3Yi57jRVCaawlo?=
 =?us-ascii?Q?aDhjprtDN+QhCA44Y4i5BCPNTOzvbyYRS0udaRvkoP5vBM7rS+4r+DF4I95y?=
 =?us-ascii?Q?Gw/aNejQzpno/se+kNhJf/jheHZ1KVr6wiyZHii2IlaBrCgXjG3+Hufz2Mbz?=
 =?us-ascii?Q?2T22VlCa+ZE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DOOK+d5y+87cpZEZ2GF5n1/V9tcTUYmEtZo0SjBLByuWcymVVM+h8dSPTitV?=
 =?us-ascii?Q?B8yTrFqJMD7s4MggyTN4AKv9vfCLSzJJWDA6DBggWJipHKoYygcEY9Z/5SjK?=
 =?us-ascii?Q?C9DWRiXLRxWkLX/BKw1Ggb/5Z3I8smZ+XQTvrRr79glbNWBDhF99GvbyeANE?=
 =?us-ascii?Q?J8h/7xVfDXJhGSCp+KHrzwjyFBcx6yZQGKfBU4cksYuu1Gox831GVEMfdNft?=
 =?us-ascii?Q?z9YTaj51q28mniDWeBe8cHyWRxdy1tQAf7v4V2Tg9cnCm381SlklbyZU4kiC?=
 =?us-ascii?Q?/1Wdn9qOQys9XZaV+jZ21j41lfwtgPQV9n7sWhO9cxsmBNaKeXZK/zJRbAl+?=
 =?us-ascii?Q?NaO5JOOPXz41GcwQBB5DCVB3gdF3dMSvDSBiFARQ5DJBWWelzmbCIj77lCB4?=
 =?us-ascii?Q?Xyt+5sDhxxh+e3I10prgs0CN+vSg/rShmkDKzk98rNWccaFoA2eUoFdOjVNX?=
 =?us-ascii?Q?mdVItoqHaGP0B2TVd0l/VjQHYZ3k6ejg54eddBsQLL2hdJHFt2se9JaM/GzM?=
 =?us-ascii?Q?8+yVwkocYfyqgmGNRwWQrODXnr+e1qCvmUEC4qEtTXnBl0xn0jRSPIGYPu7k?=
 =?us-ascii?Q?DFqp+dck+TP7Lle0OiTeMJrVfWF8LiziHS3/PTqrCNkErXQw6UEk7X98W7i+?=
 =?us-ascii?Q?5wyuuNYaPiTCN99Q53hg/FQt2b1JxdFjiLTVMfHblXmPnJDDhTyqqQRh+cFY?=
 =?us-ascii?Q?O45+rCdX+HqGSiJmm85RtJ9zET2RR6hO2g0h4OrA3nPr6Fy/OSXRUJCTlPjt?=
 =?us-ascii?Q?Lgw6JTui3PJefIPpsSyQPecm/4FIL7LdlkfEVukNoSCcl+ufwmTdI1dlk/55?=
 =?us-ascii?Q?z2KDlaxYS692R4gpFXbWi2cseZXqi4tSowGUUnTI+9C6hFf7JEGq9PeSrbTs?=
 =?us-ascii?Q?5n82QnZpQ0JWUxeyz/efzP5nWh9wjbOdt/gzmSlZse+rCuKDyBILeFZd7xxI?=
 =?us-ascii?Q?rB1/fk8koj03qQT+O72xPaIyVRbS587ZlTknQbYBnO8NhA3/b/jyfrdpVgDc?=
 =?us-ascii?Q?TUczVvccrvnr/+VMY1D31zKZDs1Pragb+x+oMkVlVzB95Lsb850Dxv/coyK/?=
 =?us-ascii?Q?1g4s5MX3994p5fu0vcSG0fnS4RFVbiiLj+fAW+yqrRq1WKJILghHp28d0WIe?=
 =?us-ascii?Q?jEpXIIEufrjvflmXKZYco1WQkBc9++fiVxVIJLYAnQz9WhZBrvqtWc9hBJxE?=
 =?us-ascii?Q?JjzSu6QB1gL9ihMe+svQ3OcGZHt3XyQ9HftDPAX1fWDOkiwftT4I0b7cR130?=
 =?us-ascii?Q?4eWDDhfjNd89w63NsOyB33OgvB9rcg+LSYCYfIN6IPfCNnX9FzIPVNdiWsT+?=
 =?us-ascii?Q?OZeuG4rBORK6ocut0FCZgKbfGXRAOmcRNhn9DfgUm1jhnrb0POEnDg4Sob+y?=
 =?us-ascii?Q?FKegIUkVmN+yop0WnR6iYoWsH74+l6C4SZkUUZhUYOptRixLTzZdoXuxKQ8S?=
 =?us-ascii?Q?C1cEW5VdSV5BZfEl8L51y2ut3KlhdQaG7qxC6H9/4yLpjckuBkMsp4Braruu?=
 =?us-ascii?Q?LJanako92VCUE4ji6Ze4EJrA6vMVH3o2gwM7a4J2BImtPS07R+L/Dv30UFbt?=
 =?us-ascii?Q?85HP01dxfvOoj3LUtJI78WEmZSAg0dQkQgAwaQbR+xVVueEWl6lLMQSBxvGJ?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4baxILGpES+6c8u+pzKyts2iTeWq0Pf3s4uOI8oa7ELSuxKHKyjxzPrdMsWlmALAvqZCq11cxpq052h8Mt21fTi+48XubL5jAR6gcwIZLdWzJXXIcO+Y5DXybJhnHk06dULrQoYiNfELKslLqiVyd6eWI3QVYwLJ52JXG1AnR/fjTSJ6TGiwzEa2RRZ8sS2a4S4seEontkG5/5xzynoNbpLMCL6Z2UOsEnlq7z5PR/6fpLAfZdAFGmpWTgZvwlijHEFxTKxbutssUCPgJVHn/SSihs2PdvY4c8TK87k8HP9OfkpFrgWEJMqstNFffHEmIlLYO0LEG3tGZRDsFBk6YjypvrPWm0/cW+jmrU7Sw9kgNcmvbr13AiT4TuQYDA6fOkt5QLB//eikDyVq/CWfL10er2dVarDkQW1oqIzjk0QKT075BfTeH7lAWGCmPn+JyYTswb2dJyhwcAU8eXc4pkbbeYPSjxXaZg7J9M6XY/xZElDm+ZFUJP4QjLESkt9w/uq1qJXQs+DiVpH+LTwQ7/8vpEFrXWmfS+QyrSAW6SQrU/lcuKhqJmYPu3geRmyHtP/+uQt+1yQZUJWggxrQw/n7SKyEoSXz8yAGWZc+Urc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1a98e7-af5c-4835-8117-08ddf4c28131
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 01:43:58.6369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfxArFc0W1gd/r0GICEm155SObwiWy1qcsJ+cUB230CP4s6jY15eiTAiRf98jLAt8SRXTGioWgyT8xcw0pNrUIN3GMtr3aT8gzNE6R2rXHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_01,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509160015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxOCBTYWx0ZWRfX0xRW4s7m4MZi
 P7VwfY3/g24YmvWT1kmCl8hEXZV+R9iGCupwyT+eUyPKwQ1Ma44ngo84jDrPAzWJlBe/943h/YK
 Jwv3wO5cgAIf96RIq0dbJ4YccDlpzSpIwEDKzfoY1lJPvQaL/rE24zCb8mFG0IbJ/tsmZI/3b2b
 4IphzoU9+++cowcL0AkZrFX1V0HojJpjCFz5z9SOGrEZT1VhgO/3eZw24gWUX2pAQk06EJwwfwu
 Ww1hdsZrT3Y7DO7BoJF8BM9sB8HBcZNGth8gkisclWb27kIUC3looLTpuho1IAWUEfGsZ7ml9XO
 9kqxNn7yS5uU64IsiY0OKkX4fjL0Yyl/ZsaUi5jRQdqblNiX0KKS+VO0Gw2zZFZrl8WaNRCKv+S
 +G0Fi2cN
X-Proofpoint-ORIG-GUID: BYWLYPgMpNx-iZKqRskcV6fSU2f3oiSk
X-Authority-Analysis: v=2.4 cv=YKafyQGx c=1 sm=1 tr=0 ts=68c8c0e2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-GUID: BYWLYPgMpNx-iZKqRskcV6fSU2f3oiSk


Alok,

> Fix the comment for SYNC_LEN_G2 in exynos_ufs_config_sync_pattern_mask().
> The actual value is 40us, not 44us, matching the configured mask timing.
> This change improves code clarity and avoids potential confusion for
> readers and maintainers.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
