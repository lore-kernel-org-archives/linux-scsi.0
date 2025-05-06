Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59192FAEDB;
	Tue,  6 May 2025 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746497070; cv=fail; b=moUERMvfDvaC3pkW0B+T09VENAityokMc9dQpNePTRl18u2tfEmdMigEcx5Keq3dUS/3HILgQJDXCaAD61bhuAI/kiC8NpHQFpc3Smb62QxM+8LCdN3h8FLQLCKWnW/RKOGeVMsNgF2FLTdf4u2Abp3Xlp0FicdnQoJGC5PYODY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746497070; c=relaxed/simple;
	bh=jETKm8vGUdZ0tFi9l4lkoJV/ruGAT6toCF/7tNJ+FyI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=I20VswzT25+CMNNmyuoxrVxBqpG9wdmfUcue0l8f0wMdU0ybSJahmpEUlq/YW0OO9hHJ14wYqSIJd5Seb1JqGEkbt6tLFjlVooFDAz9PzsiiqfRd+SjUgVz4TrNyxLa7gq6CgmTuoqqpcuV7w8Uo/NWQYlJjQ9cJKiaD5wEn37E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L7ogconq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YypHYi6V; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L7ogconq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YypHYi6V"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5461q7FE031882;
	Tue, 6 May 2025 02:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Gx8+i0pFDxoaUPykjY
	SHI79PFQz8tashEL64bmqHiLk=; b=L7ogconqVO/L/Wc1qedTiebxMvk9geJ+6w
	TrqfrevD91oSFcC26NTplPJ/imxgcDMofdMRpjjuC7sng5PdbayGMCdbw63GjCBM
	4zNiUIdDu6Z2sB041WjnP6JuYNRSFmtDWnVAuiampwxcjBLxY0Q6I5FzZXuwccP1
	KDda1DPxTeSFkEQFiGuZ7S/dStbDwgyWIN8i4rdXs1wIPl0dC1TuNq+69aUtu/VH
	44qmPoplcwZy6YGTbsyhBV2ScEM5FSPkFHyIuaunwtFTu3N9Ihb+IfdQ3zl7PAcx
	RhwciJ//e9x8xKdlYQZ/LBhaOo3xokKguY0YrQHodR35YuGcu43w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f94t80bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:04:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545NccN7035287;
	Tue, 6 May 2025 02:04:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8dxqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:04:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NXBfYGVrYyw1vQ7drcuBbirE1oxB4oulqyjxlZZ2ZfDBFYirus6ftFR0WS0wPJ4RSvsFo/wQv8KoUrIm7xKXZjw8AQwzOxRmj/3hFwPHRtwPIwhMuiTLN3HlxjUqPNu1dyhUJe1rlwnH7EffW4btyw2LYrxGv3UdjKjTMGH79ZoPTavEkyYljmxeK5WGn38DH7jR54Ewogry4GnxyYt0tZ3/MWd9jwvQX9TtlJkXNKQpcHA7PDSdnlSYsZUqRQOTasQB4+BJ0FtnoRW6yh+S0Z4xJl60KTqzWLfB85eryrOQ3My5C+IyvXqP3p76k3I6Fad+cFnZcV+zR2qyEQQ42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gx8+i0pFDxoaUPykjYSHI79PFQz8tashEL64bmqHiLk=;
 b=UnAFGWMkZc4lVKRoxThv/VUGOPk2Fiu58QNQuE0ULsGvEkWJmPHxZbRff0OQvi6Gie1HoxrfGiaxXHYOkGUgqNL2G10hCJqnFk8s1YxByux6lzkYexQtYwX9/Z0ORHrTE26axx3iojHV7UNYN/WPk06yIXjpcBLUBBYkt+AcYzIEkodgseVUReKxPhGSK4RVidlAuxJBboFb6gjyGuzvJA5dwboU337tMz7zhy2PycefUsqQVjZAvPxS3Gl4O1l+P5T+84kiRZhtE/qDXsfaFPgfCgWjXgPqfS5Fl9rHE5+Rn4hS4E0oCgChoHsHXcEm63xDEfvE5esCCxYBl/dIXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx8+i0pFDxoaUPykjYSHI79PFQz8tashEL64bmqHiLk=;
 b=YypHYi6V+FeWp2w6S99NGp+Z70lUWfulXNVGXCUNwTl7l8QstDwsurtWay48JOCXJcu6ZFO2oCICdXevUVXrTk6gmo6Y9rTpMGJvUp14QQbc20pRlplFTCd06euY3N0CU749xK7ycGy09+vYnTR9n1kauRhqLlD9CEDHhmllOgw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5871.namprd10.prod.outlook.com (2603:10b6:510:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Tue, 6 May
 2025 02:04:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:04:11 +0000
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Yi Zhang <yi.zhang@redhat.com>, Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Delete a stray tab in
 pqi_is_parity_write_stream()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aBHarJ601XTGsyOX@stanley.mountain> (Dan Carpenter's message of
	"Wed, 30 Apr 2025 11:09:16 +0300")
Organization: Oracle Corporation
Message-ID: <yq17c2uwl5h.fsf@ca-mkp.ca.oracle.com>
References: <aBHarJ601XTGsyOX@stanley.mountain>
Date: Mon, 05 May 2025 22:04:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: ed23fa32-1e11-4ca1-b35c-08dd8c424b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V8AlcpOHRXflIDxz+lN26LpOMHZYHm1XCKksiff4kCEvqZWbFDNr2AOD3zST?=
 =?us-ascii?Q?Qvcpv6ZrOXlGruAIzsub46HKuRlcwjk0WgBbz5i/6k8APFyCGx6QhMD5BdcF?=
 =?us-ascii?Q?xAyETU6ovEFUjajdK4WXOXhAeRilOk+O4/csRU2MMQRz6lYl7YhAgP8BIQPh?=
 =?us-ascii?Q?oozxL3UBFbXfeSzopb1ipgPAsmHifNnMB3anncXvXgZDEZxn7bg1zO8SoCw6?=
 =?us-ascii?Q?R5xHNR0soJlf9FxYTPWDXKLslaOXtffpghFTj8oAWfpS92nl6UVXdJOG1Lux?=
 =?us-ascii?Q?loYBTOvcwVvWAHwNAezJiB/vpTeTaRpqGT4G7sa1Do6NNjrmpeEV8AmEcz5Z?=
 =?us-ascii?Q?5nsvAStEOvOyhm9Ej1vN7vEYO+JjhpJxv7TqGYhR7sT4J2wZ3URKGyljAbjn?=
 =?us-ascii?Q?0DBAd+SV1tq2i1kBAau9d6jdhGyQ4CF6b5ku/9nprGtFqHFWao1KToLlYUn7?=
 =?us-ascii?Q?eDBAvPEUUDDs10ytpXeKx5R7P659Du3+Wo7FTnypQb8NIgKgadazern2c0H4?=
 =?us-ascii?Q?YqpdhyvmJvLYym/meCvQleEjqnt5kBqcr2390zqhaOgvGaWHnY43/uFffpMG?=
 =?us-ascii?Q?M71HvERoLGt7eBpKp+76zPSbuF2zrXhsurJ07urhJCVq7cvpWqrncqTn3W8T?=
 =?us-ascii?Q?iGN9PrjJr+lE4NFuGd/lkg86rIuCuOa9XDBLyENccucaKoOfWlhaT8BQ/cRN?=
 =?us-ascii?Q?eC8APFKQ0T75R5MVPQqw1g5DGb0wTuvHsSWF/cQkG/Coit4Aks/EStZviqEM?=
 =?us-ascii?Q?9L00YEr6w7JrM8xEGadHAeKLpDEmWWXnXNC10kKNtxsKAiu8RJF/voCKkqA2?=
 =?us-ascii?Q?XwaRoxIqVOqBjw05C1rX5vkp+PJMkXC+Q7O3V+EXRDi7U7gc+FC6JkhaoL7S?=
 =?us-ascii?Q?egCyEsJZb9H/wZJFzl05KDSN7E6/PtSep4QVgATzMABF5R/BcpfDu+7RncDp?=
 =?us-ascii?Q?PiB2/prQvfeLkHfAXowk06Zi68uQqr75pVDc0zs6LhPQAssu8If/QLAEqcD+?=
 =?us-ascii?Q?GtyXssWn8x8UOtuTTBXIpCHTDD7L6Vgjdjr6l2Nj/+1YoKJDUm7UoQMcMS/C?=
 =?us-ascii?Q?YO2+66w5qgPoo6DlkLXsRz/AOs4kMbDnJB1zNz2iB/FS5m0dW7v4v8X7+hPY?=
 =?us-ascii?Q?IneSlqZ+1Ecx6PXlz8HP6ShHuNs21/dMukm36OcR9ZbVJrelxjg+LQBIwNYu?=
 =?us-ascii?Q?rgEmYmHpk6ambX5Hl6Ba4/l54pJmmQkVY5XrGmA5ilQDO0Jc9weLPbKGiLiL?=
 =?us-ascii?Q?jCQOp6mMzCI5VyTNA6wcJVf3S1G7RPGJ31f5ojQwjyh/n96cjP1uwSScKAcM?=
 =?us-ascii?Q?PN/0rEq5HWJrgc26q1HXKmm1B6WQ3gU0TSDGZadxOyEVq8eYt3NNsvyy2EpO?=
 =?us-ascii?Q?EcoaJhx9gx69AzPamrLhgJWfZFLLXy2qKh2ebrt3hXsOOwxbpVGgw+Z12YtL?=
 =?us-ascii?Q?EALw+ELQP30=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eMUIh+k0uhNzIFX4v0ur7o+kX+0CHYR90r0I/WNrlVZXWPozhA9D4DMek7F8?=
 =?us-ascii?Q?L++Z0gGswtQL2u5zwIfuavYdjL+RrQiKviX0CwTehUfXDopnYUew6VqTW/WH?=
 =?us-ascii?Q?G2qj1CjHNUmtkXRZJOCbHfNDTGR3EXZkGhTB1gHWLOXoh53OB1b9S7DZn1PK?=
 =?us-ascii?Q?mj7OiZfCqn+A1JJ45EgNCZBm6ickt3XhGMx0NfQ6XX0wZp+V2W4DTyRs5DxB?=
 =?us-ascii?Q?HFppTFV8aBE5wTQBN6ISAgM58UT3TGskXbcCLywFm/3W/EBcPXNAmrLtcPs3?=
 =?us-ascii?Q?BtPCbUPLkLlzcMFb3aTbfzmwx67hGdT1JHD+uErrNqGkqbhEFzSLqIJaIGbc?=
 =?us-ascii?Q?oUTBMIKCgDvvaJyg+wQ8m1rACW+i7aAOSb87mXkQXOX16XD0+xKB2Dr4e7PS?=
 =?us-ascii?Q?0WaTZxBEBGcs76nrY5NdID9kLtCdD/JC9FM8AhqYqQ4tUWugNRVVi4OeCEBZ?=
 =?us-ascii?Q?8ZV/HtAWEyCa7MaxIWAF4QOpehwyz5tKsPCvBA+ffisxQm44S2CXB9DtKldu?=
 =?us-ascii?Q?kVLTtTPkZC/dC419ALug+XA7+HogdCCH+lwSbkxgMzRLQRfcMvbVAEH3BZL3?=
 =?us-ascii?Q?JjQY3IZmzxeg//nlRCqN/mLJWkeue2a3T92JnPVMGZLzsSEvPfiAvYzsjjCZ?=
 =?us-ascii?Q?QIit0Jff+GH0Vx1IT6A6mAvfHBCz1ICADWNfRVjh0wu7rSwR9zZedjU5bbNd?=
 =?us-ascii?Q?yS5lctvnRC76AeB+IO6hYP/oozD9O9jalVV88O9nplXWQbSeZmCuYgRyu/KH?=
 =?us-ascii?Q?k1IDcDsN/mI43F+lq0cwf4caPtg6xFF5LIRhM+mrAZoFULH/9VW9wI6+zwbz?=
 =?us-ascii?Q?D5l1X1Q3ZGMJd1vczYzdh2coN5wZoUSM1wxH3OBIpiUhmWUK6JoB9XmK9vbj?=
 =?us-ascii?Q?iNU+CoO4Y6HZU66Y0KSIo7T6R9TvIoifh4METzmFiSfglF8w54fOuOhMbbme?=
 =?us-ascii?Q?/xOMToVA4n1/A6/sidtSUTH+Pab9OlqMIsbJZWBEZLyQ/+3jBaOl7NvlNc+C?=
 =?us-ascii?Q?/KnbzXm0xNran2tS3e8XOW0xRZYyhoJO4cB/Hz2JXF+Ghg6lx3H8mlz9LnJT?=
 =?us-ascii?Q?YBNhmaaj/Yomm2l4xB6qagYX44m2Rtlnw7S6MMr/VrW34yU0m98VLK5d8oR6?=
 =?us-ascii?Q?6iqMcNm/odaWbiAeuJtPRPPtuLEGG/tj1IzHnm8yqAlRrnf+DHxIi8rl5BHn?=
 =?us-ascii?Q?BuYbiArBIbXKVKNAY7S9rOcM8IWD/CI3BSNdI0HRgJ8gFsT8dihBlYKybZ/k?=
 =?us-ascii?Q?YZBM9hNXYdgxV2f/24iwFJ33AwzQZJwU1zkK2AsH7actk+MH+KpG3Lx87ggl?=
 =?us-ascii?Q?+DyT6CBOiF0n99NMRUIQKz2A466Ui0KPFXc5mDv6VurFm9GEM2jMEJ9BBsN1?=
 =?us-ascii?Q?nGMbXGCgXkveDTi5M3Vf7wae/szBkOSPdkssw82IM657YZ6iSF0n5W1KlXKo?=
 =?us-ascii?Q?b9NlQfrZOLAfArTSY06YsxcdSh6bbJJhl6QgRtWN6WYIf14ToXrsIFqEOR5W?=
 =?us-ascii?Q?mlA2RyZzDW+Mit4WZSbvG5a/DsaQFMAD6b+Mj72MZOjH2aRLKpbCCADlEgvn?=
 =?us-ascii?Q?/MXMTeIRu19Fenjv9G1XS9WSwZIRceAq32SdkA14dFJETyMbHVY7NBcMODdz?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IdnQpSwsTTpHzFANlUrfm9JkheE1TR0A/4Mv2tyldtUUjxdOnwmvBDPL5PgqmrkJVhZY1dpezydF/nTDBBMruyPbVfHv/RQOlNz15/VcW6dJ5PcKB2DNFAu3Jgr91S2iGa+zAbTmp6DCYdnDNkAozQvX5nTH8Lrr6Q+fGsbWAWTyCVlj43/DcOH321QTQe2A8Gtqah0JxxkQ7cuyCu7qgocoGqjkqN4aycsqSrJxNN3zK+iE+1qCodHNPiEcVua0PKBxbuQLikv5GlvZwidi+IfuQ3E+ds70MpMNrfiPfSj4JPSf1YeG7MD6dky2jm5H5ZAl5Ie+nO2N32nJOcdSQoEuL9Aul7clPmcxIs9x0K9emAseV37v/RhuNRwcE4p+Fk+A2qUjeQmPQKvXxjZ+nLGkk5sGZdzLX0SJImwDewLogXZeUFFrkpyBiHYGznVr/m6KKUJCV7gAIgdlHEt4kLUfk7ouA92ElbtXlj5ToLfDFD429ogCTa2gbs85qS3DZT6o+YclZYxBZjiB1bDZHfWEi/szBOgHYF9q6DMVEchVSMDfQV4ab2M3FCxR1smWl+m7WMh5ytdY3KC3eP2NqrshBujkvBG/zIIIU52Iw8A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed23fa32-1e11-4ca1-b35c-08dd8c424b6a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:04:11.8687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CB77xiKNfj+MLoJxi+QxUnPvGb5EBw2MmXOHL767ttIcRzqIQesm4mRJ05NVgZrWeGjQU6saIu3aIRS9HHx8hiUon/v3OGgKUYL9OE7ORmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=834 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060017
X-Proofpoint-ORIG-GUID: dkU0DEsu0R7k3ZMwjQQOwpdXsILFQYgg
X-Authority-Analysis: v=2.4 cv=LaQ86ifi c=1 sm=1 tr=0 ts=68196e23 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 a=UzISIztuOb4A:10
X-Proofpoint-GUID: dkU0DEsu0R7k3ZMwjQQOwpdXsILFQYgg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAxNyBTYWx0ZWRfXytPGF/nI9LHQ Hu4bYDfTHYHcywAFy1NcKIr0pbfzVRIdR1DH/cRy9/laSeH3u05rx6mxkK31kfp8cbY/mIE/NuJ MBTUDVtno+dzq+RxzB/jLlGzHDUbGmPZaQ721Ha55QbDqR2P5wClwJ7Ub9/KRKuAqH6DE4vWu6u
 kk2kCc+qXD9+sfKWP1sOdJ48zDsjn4OP8Kf47maW83CKSGuK3T4iccltCSL8Cq0kh06Mb2QOGSG Nig/xYujIl24KLAgrdh0gG+Dgk67NrVZOv3jyfZQ5kGMV77aQ1IbeEBQTA23eA/omjC32mR5RrZ StsvCDKOlINoWN+8LBFjgO3E72qkO95T0CITGc0xMk4PNDEzgK8E//ZCf9xX8kukHMUxZFGrEIo
 W4R33fHW6sbSDR8J+IJEiliGeGVAG+mPbVhsYltpoDNs45xsy6UnDsb7GIKiK36DvWl1fxEt


Dan,

> We accidentally intended this line an extra tab.  Delete the tab.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
