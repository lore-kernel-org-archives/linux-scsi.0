Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A9A35CBAF;
	Wed, 12 Nov 2025 23:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762989581; cv=fail; b=KX47688KFu3JRCcyqqn1SY/V7P6FwNGCOZg4D4oimYjqkZfT95qRFyQJ+dSX6rGDVSaOF4aUJ9WLsr3qN5sb6rqPQhTsLnTQ/hoDiNrnz/LXFTc73lkHeqHMtZXARSe/q/glXMtDOMfjtryTHS3OdRJHx1KuQjrwzBLMmi1vXN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762989581; c=relaxed/simple;
	bh=BG3ykaKE9az3oFiSIFGoiYl55GFNI4MsaSJGWiPuQM0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=E73RFRP3EbFwGObPgcks8QzRddWYmBGkeLictwjbS3aepG3kTLwwQcebKyxRHVprPZYT/+2Rl0cl5QGUFDA+7IqBcN36nWiwdtvF+smQ1pdCO4ZpvMWbZguyuGXHN5kkNHMclu56ql8OUS5jW1v7ut+YtQCBeVsI/lvprdDx1G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZmmS7ZEn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bhuUBwFj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZmmS7ZEn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bhuUBwFj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACLDR4E016466;
	Wed, 12 Nov 2025 23:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xTaBfZ/HJ/nO/Nle2+
	Y6p3ZcmQEbGyDnnq0hSnW6DiY=; b=ZmmS7ZEnaV53TzLZer+jKQgfiULq+3Khim
	hTaCnpXC1oeDu/fxBO5cZrtuxAvjUsUe1535wc34o1hQI7bp+DidAFe6T+2bp7ty
	xqsrw8YCYEABpQS+rNxVQtAsP/Y+kRrcfqlJ08SoQDRsVWH0H2WHKDRx9aAzH0e4
	ayyzckQ5qRXJXN2FUSI5jK6O/SlpKVf3z7EsUHdURWBIrFabF7orBD0fjJkRh4ld
	XcyVo2sJnAn6OswdA+Kjsu5CPX+tt9H9UI68nU3I+nk85AMhjwjLBSVhdDtNJ37B
	TPKgYSkr9Pq8ol7fkz9r6K1fFsW9YJyO11qUcZgY3ilH0LH5hQ0Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqrhh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 23:19:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACM2mWt032464;
	Wed, 12 Nov 2025 23:19:17 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van47dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 23:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ic1XYpbNUmwCFvYPtHa6Si9TIyr/hYliNio5IkZKNPjCNufWMgWXj5YRsXlxG9z/udjc6qesjhT51s5qwaPK77EeJ5WY1l+7HbTaqxyjaLyBWDONmBG0OeNwTGTrcb65KWPY/vZBJ50d1vh9OxJGf8lOn6ZHGZ5PWBdd5n2/5RlFAlgbqRoyDSZmWTBdm5ruIvtP6djPBpsF5w+897vti8XZKgpSrrw6lIxtZvg7XceFSE7nHHlxAnTlC8VqHBbSAM/fp6qjn4s+jnRxx+Uo7nFphBcjd+f2yEiDoyg9zlhTZac0cI4IvWyYG75FB6zkpWY7qFdTpZDJwplqyFw4iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTaBfZ/HJ/nO/Nle2+Y6p3ZcmQEbGyDnnq0hSnW6DiY=;
 b=QvywsD2YiyorXYgZxNbtxhoWYzWzWVfa2noTw4FJ3F6couCmyITDXptuvzfhtb8+W+WmH0NQt4jOCIzwl7N/S4l8Ie7q5YG5Jt5Oe1b8sR2L6hdSlrOnl9UewGT1POUDoCcHm0bbgPI4TQe4V6BEQwLChghHrULC6010xmg1wxDSzYoL1HwWX3thz0rV5ZVRAOu35nlUABp9Zxm4sfs8fl8Z6qwoBpyW4C1yp8yt7uFtM9osBweRVxZco7/Xr6AAiK+FwP/rkoHYAol1QZRWO7OL9pz3Xt8kPBn6W99JCDB/6XhZOOonFZUiB6YhbF4XtS5sRcL2GxNbsq80zdlxow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTaBfZ/HJ/nO/Nle2+Y6p3ZcmQEbGyDnnq0hSnW6DiY=;
 b=bhuUBwFjz+tHyy7e3m6Ri9TD1UvRfbSgI7YXDwnlPwN/PjUvYVVX8ZluDIPO9uX6iptgOdOPQh96zVjVNmLkF+V6mcaoqsSodrSwtwjLVwcNx4lPKTn1HAgoC06+hYVBdLBMjoXWX5abj9zzm/2alJdLeAbSpP8NMYu7ukcltZQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Wed, 12 Nov
 2025 23:19:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 23:19:12 +0000
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
        scst-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xose
 Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v3 00/16] qla2xxx target mode improvements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com> (Tony
	Battersby's message of "Mon, 10 Nov 2025 10:46:45 -0500")
Organization: Oracle Corporation
Message-ID: <yq1o6p6etkz.fsf@ca-mkp.ca.oracle.com>
References: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
Date: Wed, 12 Nov 2025 18:19:10 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0219.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4312:EE_
X-MS-Office365-Filtering-Correlation-Id: d176054a-1272-4ff1-6fcf-08de2241e3ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pvG+ifVRwbDAOgpNcWXjRlWgklxF1yZtyLXyH89YMUX5ttYjlTbyz5+QRqi/?=
 =?us-ascii?Q?SX/thtbXuJCB7tV7Xe07rYaK4s07/bL3ti1OZBihzp4eue8hp0oG20By+GqF?=
 =?us-ascii?Q?YN6nRYAXVmDW1Q/6oFb2ZR7Z8rAp+bC//0/ITx4Y94uQIljkq5oB982D/EML?=
 =?us-ascii?Q?dzT9P/pwKUUJQjsJ8aklCE43bDcbUPljt3E2JgJnenze5ZaNCZskb+A3D+et?=
 =?us-ascii?Q?nHF7ApZNUJwLj3YaSJG5GAL0CT1Nw342YGnCxBK1SQ0fuZO5K1ceMW5Li/d8?=
 =?us-ascii?Q?MmAPK4ZHQ4KrUsru58MD8MxSYmNbFbW0TgogzcYb/3vHpJpHU3cOyPkyECpF?=
 =?us-ascii?Q?TVHhaZtqnoINrZ/JkQldIEJ+WpQz7ny/cn6xnr1Gnp87M+QvZgti4Y7ksFp0?=
 =?us-ascii?Q?1zaSCs1sPmbDxg3NMm6+Q6BssFmqstDt9IVo3fSzig6patbAnYO90MXtHFpt?=
 =?us-ascii?Q?Mr1WDZTmnN8gk5JoNBii3UZvdpigPO6hNcXS/lTxUaYHanJ3jpKTDxjol2Tp?=
 =?us-ascii?Q?QH3WEWjukY2xxVoqF52lzDres34WiP2FUIMmvk39thb23CidW0GewWnT2ITf?=
 =?us-ascii?Q?0T8H6XZzbni20Z0TgcGgHXqUuE/tJJ7eQzfxS7kI4UmaG7emNTegwB9K+JKM?=
 =?us-ascii?Q?l6JYqwHQgKMB5OgFZqodsRGUgMv1X8qrJjyS9G2/yLmz9aYCnlMa6iEsycak?=
 =?us-ascii?Q?d5mM/FQmfdj656KRQWYw1d8MGXSpSFvS4m3VpT3b/s2ywyI4WTWukCNrxvss?=
 =?us-ascii?Q?2CYimxr8Xgml9FK6TcagSZBizByvb5bO2J9M9Q25uhJr95yXO5wU+yG1DY0Q?=
 =?us-ascii?Q?ZpccqVjn89uEbKeWpk1HuBJy0wtN8CxpWiSQQjIpcw3E6s7SYUT5z3+MpTnL?=
 =?us-ascii?Q?Y5qVjItxT5i0cjMhcJmAb/qNGZwrYicuHz60Nmd6Kv+4mDGVC2t630XUaUSu?=
 =?us-ascii?Q?j8ULMLhOizznXGWXZdDiYjP7t5yFgjlGe64gecJeNuzAh7wi3o48GkISP+XO?=
 =?us-ascii?Q?uWRMMaMdXku6pkPea3Diqh6n5OAMKP7NrXOCBE3R9k04PwkD8zq0hsQ4NBhc?=
 =?us-ascii?Q?ybqJEUVa6VvoTijGgG5HinEAhRKS5DFOgf4GNRdVAmMDugTXFGU+7EmG0aLP?=
 =?us-ascii?Q?wLDTKNTnL7c6z62q774omYWOCpVu8oZDRZZSkbdFcyyPtsuezungziV8tXwD?=
 =?us-ascii?Q?16KI/7a2TEp9zep56bE2kqbndHyhAJlWJoUzncU8yHEBw7B8aqXVWxjfNW83?=
 =?us-ascii?Q?MvKUTYFUyHUWeOPE1klwHEIXFTAsfF/bFvUiZZoPy0CiAmUZaIlhS7XyT/4c?=
 =?us-ascii?Q?+r4mUyn995yom3YpRzqZMOG6pOu2iBYVMGPYhjG5kfxTgo3kLhnhFV/1JLc6?=
 =?us-ascii?Q?/kSJ1rp0gWm2JIw+yvoTvlS5hLBwDSMKxMR0RSTHU1t6rx70Nw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wapvZJTd8VbtGK3j3ljSnblcQ2xs+IiSntEtK8uOx04f3tv65EiSw+M3ezuV?=
 =?us-ascii?Q?eXU0U5Cm7gs1XfCxP4n4hS+JR4eiDn7wXIVCEEVXIcckkRvkUaYt1qO3Y6mf?=
 =?us-ascii?Q?QAfn+o2oWlD59kxwqxnE4Sju+7h9UF6tHAzIMcz/UDmdtmkL7P8rnrOJBcZa?=
 =?us-ascii?Q?wriZ2AGPBNz3rPquNcgguWG1HcUGhspq1Tc/MsnRFTD+ADp/TH9FiwZSiIu0?=
 =?us-ascii?Q?rMHElK0EMUhkxuXhRLSXqr9V7VQgEe5Y1sdY33PwRkO/h3Fm8cazknYR8rFO?=
 =?us-ascii?Q?B/qkvgPijjhakY9SSh5nPM0wm5h0qJ/ZloPgsE36CcVkhNiMgekxZgb00AfF?=
 =?us-ascii?Q?KwHdQPAD16HkFevu8F/IpLFoz+cDvV7coBJYPfh4VDQOpnMM63nUk/ZdrNnD?=
 =?us-ascii?Q?jf75ELyDHIUpMKEIIouvPz7SawCawwYnKIMrXHMaMaApq6+NzBH5WHWSPC9U?=
 =?us-ascii?Q?bEjQ3sVvx44vq7YLrlb/zh0nv0vwgrqo5wE63roydoM+lKyco3fg8dZ4G1m9?=
 =?us-ascii?Q?I5rCJQURiFjXxJj+0zEhh8939EVFNYPspM1YSfbunam1RDUZJPFt8TE0ajGZ?=
 =?us-ascii?Q?L9f5M+j48rKuwnoLtflV8fAkq9InAQ5KhzRD6OazVvVayjEhbbOSzZH7ur5A?=
 =?us-ascii?Q?w7z3dVBcCAdAFYHXvwciKcX2AoRbOsHRsENoyteVefnmbr0yZXhJnH9F2jKC?=
 =?us-ascii?Q?e4yN9lMmGVcRZRVGIQ7/DrwdulHlZaQLGFtwUPv1mBdTgpmCojKE9WT8WQ9x?=
 =?us-ascii?Q?Zw4Xn0epMtYAIKkM7QpH1NTa4Y3u0XqicnPjefPDWJnzpBOfV1ExawXDVs+T?=
 =?us-ascii?Q?6lhLa0cyb/+dV1QzxyNC3Yas8G8sIAlKHwOVZvecl8iTVBXRIPRnhe6fT5gM?=
 =?us-ascii?Q?INKgktBGOR3YwTHryK3Hgb19EoGCPzuxW5XzeFrmFwjH6lC1hgIkPfd32sNz?=
 =?us-ascii?Q?1UbQZUfQ3SaaClmZhAEMkkqqoEBnwfghFYrwTiDlRlPevUpH8pMTD9M+3QSu?=
 =?us-ascii?Q?wB0xY+R7urGz19wD+5jvwfJJtkBxbV0U4xZXP70CQf81dfwTDBhO5D3F2Y6r?=
 =?us-ascii?Q?G0YfpPRsb1In9F/7gJlHyVWeGD7fi34FKNUCl8ohRw34KlF5H2A37AXhkOYp?=
 =?us-ascii?Q?BkpK9UbkoKWLgx8F6HFA9tPFWHW61u+Z/cXa9CXZ8sd2FnhCn/2DS0rr4ji6?=
 =?us-ascii?Q?364rTRKzUugsO6FGB4zVQFkvn1XWx3wch8a9XhTTOkD9Dbq+zFZJWsqoPngq?=
 =?us-ascii?Q?sS+xdrHwgi2h4hehJxFvC4NIXvk7oFDxkJ4ZR73aimLQ+i024h75rTDgXgwd?=
 =?us-ascii?Q?z9W95dZqnkE3pCVqmUwD4//pEaPt2bvqS8L55yGjdaOHkDgJEuqK/lMfRGcM?=
 =?us-ascii?Q?EnqACs49i2xVCHTOjaZfF0ySGcIiOiQwberUWjn8tRfGF2ecz9J1AmDWSDb6?=
 =?us-ascii?Q?D2fQwg/pqvhsk3N+yPOqp3oKwK52po8FdViVvBRwa4nhwxi0jRDBA2gayuGP?=
 =?us-ascii?Q?JwbTOhLPuVxhBbsNZBPYFVc1FkMUGJsWeUveV9bYwrcGiVdXN3T4aUyZDzRk?=
 =?us-ascii?Q?p4vc9pbxf2QmEwkkDbvAuZ3SF2mQkreQoMJKYqsBihzsBq3AV1peo4nIAQbN?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VAixpM6Zg3hnNJgPgJCcxQpLq4EVjSGZadJWKGdw2ywlaXBtSBjGK5l0AFxtHZ06rTOJaN1hg0F4l+bNHWDkCAcgk9GBD1lga8ciqXY7RDF4mOoh9CvkhmcO0Mv7B4MS2RkGEm/RA9uwb9UrtSY7XTeTQxcRZuIYQ/yImxqhn841AlNv2DInGAcYPn66tztGjV2Ut/KEwzpqXV65WEUVMxEOeKlw0wf0Wr0MPS6BRafWmdy3A+j/bL42SGwjHJXFSpvOsRFWu9gCVd5ap9iaimC8ZpMGiFw9E5HvcXZxmmAqCDd0H5iqobp1VjlqXYW/Al/1yilmaaNGuc6bXNOYCxmH66U5cpQaZGSYwpuI6YAsF8vMbdCp1OQNMKbmV5i/Zas3QcL0x5qs3XqkI6osTFHJcmyJ0Vy7Ibww0NWNfpMj6GJNtlARkJrmYJS7jG2scwdjk4VqtqKelgZfkNGzQxNq3pAga3TPbTpmUqKpXvahutECIUDTDOpmAyzcdZ4IdZOxl2a7vETgLehapnvmCpihE0+fgL0SixsJzleZSefi0i3DIxCqBH7JqDZY9LuV4IGFXvdlqEzqeoDnd3Y7IrvQZVXIgBTr7qpQ/4tj3VQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d176054a-1272-4ff1-6fcf-08de2241e3ba
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 23:19:12.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmXvFjXTwkmmtW6qfL6VFBljQ8TdvA5z0XcTb9Z4VUkeaxS5HjqCA0QCIbyFAx1/4IqQvS6Jk1wd0diVgr86ufbmoeane5+Asl/zonPc/BA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=961 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511120189
X-Proofpoint-GUID: PiymkrHqxGOuFJUGQvgar84y-ki8jrA8
X-Proofpoint-ORIG-GUID: PiymkrHqxGOuFJUGQvgar84y-ki8jrA8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfXzcrdLsnvibjp
 aFVY4hlf3E0CPfQioeIIbZywylm4r/Ax1BJrVUy+UcjOntF/h/X4b9BYIAw5YDINnSgwU9TnqD/
 Pp3BBB1VRKNRIn8Jxmh/hvKJRqsxTqgmmN//xSU0kTUcOfZwacqv2cLpJjQou8C4BRijOMgktJ7
 cYUsFzzCurufdXLJgATKSnnfMNlLM8DjQhimeTbZAvKddt9oCoIjo44SniXp7JUU6P0VxkXqzel
 1dTpNKc8vHCI6SE9tJnQngv8Q4VwiyvPjponTin8ZnhL9ivhN7jEHnQrcVqxAjAI4EeRkxl9l+R
 8JVUqhWmeTd0RTvIVvd+iCGUVzZ6tjfwTSKYYTCKrox7M1L4jwYiiZdcT4bPmHyLF7H63WXpX/h
 rg3wVPaeBe8PMkNTRnL4hKXjureF1sCYBC610uXscS0IZYRVtHY=
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=691515f5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=FP58Ms26AAAA:8
 a=ot3jVWqdesoLQ1ONHb8A:9 cc=ntf awl=host:12100


Tony,

> This patch series improves the qla2xxx FC driver in target mode. I
> developed these patches using the out-of-tree SCST target-mode
> subsystem (https://scst.sourceforge.net/), although most of the
> improvements will also apply to the other target-mode subsystems such
> as the in-tree LIO. Unfortunately qla2xxx+LIO does not pass all of my
> tests, but my patches do not make it any worse (results below). These
> patches have been well-tested at my employer with qla2xxx+SCST in both
> initiator mode and target mode and with a variety of FC HBAs and
> initiators. Since SCST is out-of-tree, some of the patches have parts
> that apply in-tree and other parts that apply out-of-tree to SCST. The
> SCST patches can be found in the v2 posting linked above.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
