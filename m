Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C6313792B;
	Tue,  4 Mar 2025 03:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057625; cv=fail; b=mV25AAe3SDTqupSIlsceU8GfLpP+GkvcjMxzvnSxc1IUtC2v7MNvsGGU4KiecgtjdHVoAo0mk7kuWFLTVxxKqZBmkdyQTa5OCwCmIialwJL6T0EntA6huYEbo9NBUnhYz+h0Pe6SFhHBTOaso5uX1oEwkL2Nb20oyRXjM6+dPO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057625; c=relaxed/simple;
	bh=egc1Z+tlUj/nLusXFdthXrKnRIb6Mg/O/Tdi4HRZ+ns=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dpUDfxwIfjfDXuLrygj0TWWFCEN9B4tXfn+xEeRHiWeDS5tbRk0RhnhBABHYY1ZDEh+C2E7YSRArrA77rYAPy3aA0NrA3xo0PlWO4IGFCz/u6vg3TIPA9ntcOj0kit0RDMHM8SWxUMSeJmOXCQHohktSvaetT7t4fDzyfPZoJDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B4Ui1hRY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uUwmN8Fp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B4Ui1hRY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uUwmN8Fp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241NLSe016379;
	Tue, 4 Mar 2025 03:06:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=u/Aj8XyztfnBBTktfl
	R2gOgqnvR/8wHI7wmaVgzUnTU=; b=B4Ui1hRYqTKU6s+ye15d6qU4S1GjbeovB7
	cMAyOJewdnJoYj5hkg7vecnMjkgZX+ColeS25CqhQH55NReMzZ8wNCq6NTbEE9+z
	hydARytV6I4/d65+TjmoA7L6S2aMeH7dzEag6jXokCpVC8d5g14+0Na/XuZSuFLc
	0+M96rbmhtDAMsDqaOltvXJ5tFyRAXZSjjhrjK7/5LOcTjcW7Ko1NSges96VSrmH
	sW9bSMm7KFtwKc9dE8AuGrCge2Xc32uuc5Bs6V2R5555Dwtv+DzWH8rDg6nrTe+r
	4KCEzwTVUv8PDZJmZgwLQOohE9AW4O8apFMZK2/VzSkVaYHF8Cyg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u86m2fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:06:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5240ctJs040389;
	Tue, 4 Mar 2025 03:06:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpem3mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:06:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y7qR86jO3p3DLvKOS6nMSu2jEjgoypPKcOY0CDmEUvZZdAGSPIuLPh2ZTymIkdJR9bvi34o5b3ZNgAtakMp3MxFb73pfg3SYTd6jNk6D/AHde00/ONMGmO/VZlJwq3g0e+2JmQtCJxoJvYh38hVmf6zoxwmmvGS+seoQVk8/XLVJylA78K0Wj3qJP86foabkkWTIXQA/bpqbCGQSoyYCqyad7iZaEnh3E26wfPBPVqckqlHQ87WtWXQsHoXg2p2WhuVrS+cN/H0jcJ0nhzYfzuRdwo9gZ/dhHJPLgn+so3X9H6Q2o6IHoNQWO5LBL1uVbeOgNuIZXhInrJtsbczGrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/Aj8XyztfnBBTktflR2gOgqnvR/8wHI7wmaVgzUnTU=;
 b=cXG7wrXA1p7to3YS0RYlCtiy0zY/wbK10UOuInS0LiH9bI+y1FQpGb+3cOa4HL34QVli4/FaNYYMD0v0Zy9uMdtTlX6chcQBCAOrXuC5w6dlBficAf8ZCJtazVBduM+knQJ5LwQI/QvE+u6kcgq4RqcppSet8dEx5DEWcT52gnzqKPkbXg799Xx2VgFcGzILXbnea0upEp5JW6Vm+eYlMEVs8Yat3ODhav2LLZVvlYlGUWSivNjP/VUzkPgNL6lgoaCfHwojMB1OK2eWqe5ALMJoTKYkC2XnyhFGB0xZsO0kwAD/sXFftxGx6tMIJbQhO2UQGaCeBXsKSccmkYrhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/Aj8XyztfnBBTktflR2gOgqnvR/8wHI7wmaVgzUnTU=;
 b=uUwmN8FpAskHcgJRs4ROAzKi+AV2TXihdN1B1F7CE/s1vXk2UhaIauxOhl92EoRQ7qsZ5WEgXNsseTkxZauW2zZB1UOhY/a3XG1T9MVUh3qN+4pa8AwyS5oXKWOWEZmlhozrqpIBIVuGmIm0BVOSmnBq13RM2AVyW2AlpLnh1uo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5634.namprd10.prod.outlook.com (2603:10b6:303:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 4 Mar
 2025 03:06:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 03:06:55 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test
 robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] scsi: fnic: Fix indentation and remove unnecessary
 parenthesis
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250225215013.4875-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Tue, 25 Feb 2025 13:50:13 -0800")
Organization: Oracle Corporation
Message-ID: <yq14j09trz2.fsf@ca-mkp.ca.oracle.com>
References: <20250225215013.4875-1-kartilak@cisco.com>
Date: Mon, 03 Mar 2025 22:06:51 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:a03:54::38) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f3b7d3-4bbd-4b95-b0e4-08dd5ac99dda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OXS+0TLpW9Rhi67yfk95A0iNVhspVfFimbDusK+ngF42moYaXIC/PBWgPprs?=
 =?us-ascii?Q?+lCkwh4Y5uLj4CuDwvp4ei92DLK18CKbkSyrQHh/L40MpE18+mrOERtCJJB0?=
 =?us-ascii?Q?0zCQJoXiwe3BF4f+Mde5LHD+yCpSchNde9wSOYP2u4GllExC17S+yMrdZ0hj?=
 =?us-ascii?Q?qjlXTXB/sOTP33GKPDNiZ57R9QQcEwbdZP3uCVqkO69gMiNTCjteQCJg714i?=
 =?us-ascii?Q?U+1Kmj/JQX4mNlmSTWpXL4lcMTrtjxuagZzUSfx0zha2yz0qK4V7+xH0QhBR?=
 =?us-ascii?Q?br2+jTC1wBinRg9hXZsWBfLJ4rOIATRkRWTiCKj7Lu3iFdikXKbh2xBo+AaZ?=
 =?us-ascii?Q?meHxU2HI8F0AKDerkWZoSKv4ZZo2mrSSUTg4WbCFkHkdgusJ/KWH/gP7Xefp?=
 =?us-ascii?Q?CPMTvazaIuR93mOAJFjzxQIblXJvl/QP5cGiF0CHQI96my+UxJkfkGwaVezV?=
 =?us-ascii?Q?V31nfbnoiNttaQ5ytJDTo1gupJ6YgiCgql+iVSU4vQfmRP8bIfihNkLrSbPJ?=
 =?us-ascii?Q?FMpkkrLmQ4CW4Ka2dE3ZrH3CsFdO++enCn1HiSCL2np/40DCGA/HjAZAR1cI?=
 =?us-ascii?Q?waPMBokwwQTwTnxsdgYQz3+QTE86h9scluJE3w2LMFqW+DRB3qvJ2OaBxUlt?=
 =?us-ascii?Q?b4vyDcyMOwuh159iL5+NBI61aI7C5SgGEpnyT6h5YVUMOvp9lkgWOW3PhLJW?=
 =?us-ascii?Q?lFWmvvYoMbTWV+uQkMARlncpiX7TqytCSGnY3gsL7EsPII7PboF9cjrgrQlp?=
 =?us-ascii?Q?y/VKDq7/KLSgRfHS8eTLndNDYFasM/dmgz2wJN/kF4AvcpIGQZOcW3oZF9rU?=
 =?us-ascii?Q?ocrq8SoHaASOoUo5SFbGybw1qnLDl7ZGU5q9zH6fPOJ2RhIn9nbhb1ivQ7eX?=
 =?us-ascii?Q?X6XNxqaswhtGAydWtUl3OMZkrAUDKnTLZaNN7K3ZVFqLHjvLcNboQ5Ct1hBl?=
 =?us-ascii?Q?MxL5ITmEuP+9YLyAmDaNmqnG9MLKxK9sRYC2zWlGVlWx0C2xHxt1vGzNcW/b?=
 =?us-ascii?Q?zAJ4A5BpkrMmnR+XsNmlDLDMAHd+rUBKMIZFvoexFYeHvQY3Ch+cvjZieUXu?=
 =?us-ascii?Q?kjEfKY2Z/RPyRpLSEaOipEx1lS87TDvS0mzMG4kLYicHCFTr9FlO1QpJSakn?=
 =?us-ascii?Q?qUMicwG63P6jMsk6YfC+5PRbUw4q2dyk2t0iHR5xSb+4u1wKTOXpESpG9WTU?=
 =?us-ascii?Q?SlUqNFA3kslIfdHTQZLWQ8ATUD3WWzSfAI1zCljpBxCxzTeXgIR0hJM7X9IM?=
 =?us-ascii?Q?ugc9AW7sePdtio0AN1ah5TSGu4K0eesswcby9OEqLdNZBUtqbzznswZBY9V8?=
 =?us-ascii?Q?SVp6bVC9Qje0TxHb9z7DWrwm93Xb4j0nj78aVRvvkBhecslWbcsgu7VcNlpK?=
 =?us-ascii?Q?bttxRQRZopug97ii0lNJpi6Sp4bP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VmcymYFawbweoH0rTVJe1RKY+0rAjOBznMP6CL/SKySGIZ5n09zUHEO3dMsO?=
 =?us-ascii?Q?PAMIclwg5H6qmHfpdN6NWC3anJp4MoNToccOIJifJWaj1P/ksWwCCgG6vUHn?=
 =?us-ascii?Q?FcHnlVRkk/p0dQhcRKHX/dq1gmPlh/2wcCcfGaE2XhCa8+44hn22jsZruDgC?=
 =?us-ascii?Q?LZmQ1mEyuwSaFZvhm5N4IRQZzfsPaUY9JYO2Uyf6iWDHjNWuPxf96f6XeQBc?=
 =?us-ascii?Q?wDq9LokOijtvI/86PCGD/QuQpxvKs8C0TiOMaxsvzNJVC3gT/pEx9FBU/nm6?=
 =?us-ascii?Q?3AetsxTPzzUbS6o8nEbOs1yq5cSxJHoTiG4UQBknBgn6Ip/Xm7lCw68XzSzx?=
 =?us-ascii?Q?NuGksYW/T+VMoNPqO465RiOKVGxRNjYX7hiaxe8mpJIDNBwixlWHz/65IH8Q?=
 =?us-ascii?Q?JAB4JY+tBmx+8z1RqmkIcupzPzM2OfJ6OdTRCWzfv5Ja+olEizcBuPn9VWCz?=
 =?us-ascii?Q?oylX5UczL3f3H5kBJKNFDKkkIvFN9Bw93gjXrvtn2sNuTX1EgRSCiE6V+W05?=
 =?us-ascii?Q?G+EDT8fNMwRW+qu60LuiYXSh0F/mi4IS4g5pvsexX6UAc9XcsUNVYAYFragt?=
 =?us-ascii?Q?PuHS1+nBGSHJ4XJ+6BJtYa19VWtlp9qA9GwxAr+Ppb2TUcsM6zYD6N4+W+Vg?=
 =?us-ascii?Q?TN6ZoSNv0tEu9tV3AKHw0mi/+rzi0Rjw9Z32DWA2NG+XLQ2INhm1Ydronhg0?=
 =?us-ascii?Q?Y+W3VL61vLne0O6+oWGDKHDgqc8fxjMVj0boXuL4+a/XS1Rqjo0NFVAfbCHZ?=
 =?us-ascii?Q?/ln4YSbpjHH0sJcwhpOWeHxvlXpcVFkp9W+4GpGWtV/QLpAD0H5N+gOdPbpz?=
 =?us-ascii?Q?I/Bl4+OCclAVKpE9tMzZVAlNy6GmzoVITCAaKBxgGmZDHIbtN+1WXHk51iQj?=
 =?us-ascii?Q?QkX6bovrdk8UeU+oEk0xvdDI3vb/R4EK8DewXTO0FYpyS4LJtrfkbMB9Jinh?=
 =?us-ascii?Q?qadoZli01WtqxMMHCs5Mr+pTLMCPlfvvmfCgbMpYw7zvh7JjL8IqiuXBgVV+?=
 =?us-ascii?Q?50Wq/wluNqZupTbAv3VQ1+5Eqq1d0iFSrYPT6wTkwJqNPAxA2w03brAy0/ld?=
 =?us-ascii?Q?7pHfFMwvguDcldj6egaymetzCYu6ksLMY5c0niGsMHQwXUEUXrOXh/RNymR6?=
 =?us-ascii?Q?81U5pBODxHkpoJldGg8iByCF1UJp4QZgvyNg2gaz3lMH+9iTgv/4WAh9GWIF?=
 =?us-ascii?Q?nYutssHX5qRGIlFgakap/GeOS0YN0Y1wtCy6I0mNo6HJsaO1IrwwHNLrO1fw?=
 =?us-ascii?Q?uBCTBqH9mOKficnyvWIB8UMxygZdz2+ibEwa/0ZAw83jjszmkVzvfnnh9rN3?=
 =?us-ascii?Q?HGqhQ64dIlY8pDMntdTBfvTkhbAZU6pPAEjXXhWG7NTL4u8oKIGDac+EQL/e?=
 =?us-ascii?Q?GiBvtX33QL8b4DQvPctlu2FsyVRCn9X42H7iG5SvBMcw2j7ZBj7GFRqfUhGd?=
 =?us-ascii?Q?raglqAPgCNUerCB5SahWGl0qZIxHIpdOzBfm1KkoqMX72ShNnXoTON4fgxzr?=
 =?us-ascii?Q?RZDlWECAcOYljeu7dKEE4B9n/c/Gsd+gb1Vz1v/QRgHBA6x13mTx+iXAQtBW?=
 =?us-ascii?Q?GyK+823tFZotWTxQyGwfxpz4dF4vcM6fh5t44cpyJUDPEPEuWW8TcjEIrCq9?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iUKNWgB6otiBF2q25u4qhb9jCVh4J7E5+a/ynjIJ2bSjORdJsIJQJm4jf8DxX/wK8LrCZHZoHAhdg3EdhAa39MgJNM10c8AWM6Sfv8kV8gPno+Svv6WxXnRxDie+b9B12nt5PUJJoY9+D3DoI9lSdFPsO60hfZ0p+toxNJL0qud7u3I8dsnJHk6122+Qmg8SyFpT/unHczfWIjtDrVTWXmm85PcAnWTWVB8fNRCfveT7QC/QaBRkKuO7rPx9TLFUQTPneYKZ47hHDh2nC/jhsItxp4jlbHNrlRx2qP0aYeawPNppSbWd0rXLTchsavz99sTfjFvblEg97PhJ/FkXvVSupOx0ejsTgUk9K28GWwWkvrTnU412c5h97VAPaOKI8bI8kKy9BxLQ7flbxT9dq0Ve5PJFXCgjfo+sa2/nSiUoP8uBrT5tZPgnOBUl6Vnw9yWQ9GEEVmEYNAap59ZM1d2ZivqNxhdZUAn4kokQ+8GC/t5FowJ/UY9gvvnOOTQQxMG6cxmKT5SzXDQ8qNFDuYniviZx5i/d8fPBTOkC3NM/0FlQ6cRmcGJJ89Iuf49EOROXPPFh+P4quUhFwsZ5BFVr66a2n81NFhCx8S2ceY8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f3b7d3-4bbd-4b95-b0e4-08dd5ac99dda
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 03:06:55.0197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAbO/rTrHpPy7CPZEC6dml5Cx2IxIjs2c3ncHZ/8ZMswMTf4Gi2hC5Qy2Fv0UaTOWBlAKluaqJzYTdQq1GysXVgW6rwURpozZPNxQhDx188=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_02,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=881 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040024
X-Proofpoint-ORIG-GUID: o3OK3gw4is_HSEhFrze6pO0yq6MLD4HJ
X-Proofpoint-GUID: o3OK3gw4is_HSEhFrze6pO0yq6MLD4HJ


Karan,

> Fix indentation in fdls_disc.c to fix kernel test robot warnings.
> Remove unnecessary parentheses to fix checkpatch check.

Applied to 6.15/scsi-staging, thanks!

PS. Next time, please send your fixes as a patch series.

-- 
Martin K. Petersen	Oracle Linux Engineering
