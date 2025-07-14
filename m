Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35412248F74;
	Mon, 14 Jul 2025 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752512956; cv=fail; b=YRYovjG9k93NjXnxKv2TIZdP5btzwyTeLMihZ3d6XRwaeH/bOsfPK+U7pK+6GQopzqjuMnnZL/PSxlVCNpy5x7rvDUhsrQjdlJpSLZz1KZbmRWkcT+SAQPb+/ytNa5Be4aM+oiroewTlWPFDIfjEZKObuCVO9+QdHFwTv51Djjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752512956; c=relaxed/simple;
	bh=DbDiGRl+tpMov4+j2fByjeVUfav4npmJ17Nk4KocwwI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qAQ8yeBnBt3vk7Hj18+OBQFIiXUdra/o5MBcP/rBVc8bTRWiHkIgcKSnmMcfO16IQpO05uZGjEBqqFZUMkZj8F4BwmuKHxEPEV1M0cPWgD/6a3XRKRl4O6i6dRFAVikLbLIGy1nrT7fKYysY1OP1fboMXYCmd80rjE8Xd+dBbo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MoQ89o9d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TdPrD49Y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MoQ89o9d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TdPrD49Y"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E9Z6Gn019053;
	Mon, 14 Jul 2025 17:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kZS0AkI6fnuPoJEq1T
	hb7scthLoWlLck3Gc9lr3j5qk=; b=MoQ89o9d4/R5J8WENI4OrMkRfIyTSQH320
	HtAzQjZTljQuWRppmPmo8G5FNJ1Q/SdL07bitGpNXqoWrZYVMpQde+OX1vlyiAls
	uruFXNfVrwQSepWx7YdwwIo8ZIASUFwCwAXDAnsoc5ZM753fCbYv/s+PeqfoWc0H
	RRfIum7XcIHOTMvur2AOKXeyCXmwk0jbD5D+zSJK7YA/uOvrjzJYMjPac+kZzCEP
	FNpmKix+lFx/mSn46GaWG6kYrW3o4M6ZBPGjhb7NOmpS713RUC1vRowgO6Ftqv8M
	awiMklF1cOeIkEZlk8SR2LWwukCMosd/bTvpdKqUJ5niGZlgN85A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk66vgbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:09:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGD77V011665;
	Mon, 14 Jul 2025 17:09:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58t323-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXT4MrzN7smYOzIo1q/bKn5qY7rx3bupaM3Dvl8rvkoMRGxODnysX1679M1l3pr+SucUWL1pJBVDRaeeZS33T5yDovx0FvBrMeV19PpwMe/tTZj0AX2Hlt+hWkh7CAGRSn3TamNWQt6gGoqcHCY0mLasXtchy3H3+ZTOIeYeGoiWCJlcww6Ake0mN7d1MNIh0QsKbfuAZFmHaciWO8WbsXdG1XzFlcCBCnOTAIEzyrd/pvf00pG3dPuDG4lJjixbDybDhEZXllZAXcKhez6wHnf4bHiHMlcjcTAxDDaLZiSY85DsoqC2Lu6f9RkmQHbDiCydgpq1CrVnsk2QVGF4Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZS0AkI6fnuPoJEq1Thb7scthLoWlLck3Gc9lr3j5qk=;
 b=b6usV/2wkNk5pT/Yl/MVISJ1l3iqATzXpIpdnWDoX5IRoo8UbWT+j+YgwhC/2p5iUn5GUKmzp/wURR7a2zwE27EohR6EfmRJsR2lnxUQn1MphRtyxNeH9G6icEIzmvZYGkkddDlSoBlaxuags3EINZFdbfPR4eL5p0j3oxh/vQEvyO1ahstxsPOwejxNxj1I7mCzsQ+5LQwB4rIFY4rPFhjVvwBvNxJTi3yXsativQaJhCcDT0mhO0MVbFyATxxL9oiljCpfjWr4sEV+ZPNw6/e7p88uWf3+C7bVZb9L9mSRGKPby90P9G2NozPrCixwMaQsgGnoWvesRMM3EIO8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZS0AkI6fnuPoJEq1Thb7scthLoWlLck3Gc9lr3j5qk=;
 b=TdPrD49YN3In7lOpw0yim1vH+tbUCnXCGABif8W8I7BKbfGkjHK3JbxWQGIATaOWTTvkjVArxkUwQcuhafj4gkx6B3l6w0eyrROhljEx2LvA14Pyt66F+b+sVmjwgL1zaLpu7osVCyRyuvpvzwYL9/U5+7GXtVvsOFbhO0y44hM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6195.namprd10.prod.outlook.com (2603:10b6:208:3a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Mon, 14 Jul
 2025 17:08:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:08:05 +0000
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI
 <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Rob Landley <rob@landley.net>, Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: Format scsi_track_queue_full() return values
 as bullet list
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250702035822.18072-2-bagasdotme@gmail.com> (Bagas Sanjaya's
	message of "Wed, 2 Jul 2025 10:58:23 +0700")
Organization: Oracle Corporation
Message-ID: <yq17c0aaefo.fsf@ca-mkp.ca.oracle.com>
References: <20250702035822.18072-2-bagasdotme@gmail.com>
Date: Mon, 14 Jul 2025 13:08:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0051.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d30dd62-f89b-4237-c5cd-08ddc2f8ff67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9KCJQHh7A+PmW64D7Za34S6R9UaqZqHTNQ8YIjhuHVjtZmjuXCUEppmp5sAs?=
 =?us-ascii?Q?SZ5zdmkQEYvP7UypVpf+FZFBRxJng+4aJtqkGa4dfoVJ2RZAJzJOEyM+wK0U?=
 =?us-ascii?Q?Ay4wwSO0eyaVpFpEx90Zzxl56zvSgMmLDlNU398LffPp2i5rVYMD86D3wdkb?=
 =?us-ascii?Q?C9n4758URY4tHCkrAsmCRAKNTGRrWhZ6gkZZztQath8UlqcPqwsIwdvoBgmV?=
 =?us-ascii?Q?8xp9gZz0EZplKvqTHbcHcvoIEkc2BlPXgv/YQd8rc4UinE5t7zPJgaliMRat?=
 =?us-ascii?Q?r4GCG2lyniKFTGsVOTgyUuk+WZb4hKocz2KwUXVNgDgoAqrkEz06mSd2rmIe?=
 =?us-ascii?Q?AorhypNYd0PGsbj3D043nZOJWOBl+8G1tJ/TeKkTYWKUSJtFWDBOt7erdYBB?=
 =?us-ascii?Q?cnNbAiR3BEJ11Avqkbmk049FzDyGp37HbhMusGzirJtluGPOFu6876GNP59+?=
 =?us-ascii?Q?XllkbS/OKkIU6GO4q9Iu1zwuWkVeDuMEH2lRmT7yZIyTjjYKmxUgZL/e1TMr?=
 =?us-ascii?Q?bietGsk5sA9cEd6Xw4xgIE0galAGz1LNYOmNzpSCQkkZYbTg/E6JBs3aaP6c?=
 =?us-ascii?Q?nyoWif6cqST5XS8Mi4dPYnvxlSKsRuSNXOnvJtAWVWzKvhdvXvWt04uKDf4S?=
 =?us-ascii?Q?J0vOCG2sSWcQ7Hq2fHmCkbfHxduuYpcxPApu/WBcvWsP5NeJ97XGAjPBiJf2?=
 =?us-ascii?Q?a9gRuKd5kwrrQeAqPU/NCCIH0nrGPbs/r7LZG7QZkwQUbCp8bW8nxJAiCGbY?=
 =?us-ascii?Q?0JdYE8TqHX9AybTRBKi2g8ZNxGfF9ngxp1e5wGaKpidmStaIkndsU4JkKqhf?=
 =?us-ascii?Q?8iL3jWp8e66EaFEuSvRxnjkZVg803hzFMjFZ0aHQ469UcDxyMO0rbzyrRi3b?=
 =?us-ascii?Q?mfFTde5rsLE6qQcT/uiqUPi+H1OxdgRPgTH7PG1V8UklA24w1g8XydrLjHeP?=
 =?us-ascii?Q?aRzasNiYwFU1YwCzJ7YmsThMYh/xeDyNQad01xO1aIWg5RFMKcdYxoGMJD9O?=
 =?us-ascii?Q?wUP+sCVrLKpQzs82iS4ze7OBmaemxb5FNWIls6efZOU2ReJQM8ckRElH4duf?=
 =?us-ascii?Q?C+ZflWC0hLSJlt0yuevavlF11wrifnGrHtwQqiWMorGmaUV7Y4ZoqPI0+1Gb?=
 =?us-ascii?Q?YtCnS58MtJ9kFaq58KiFE9oBgAIyGnHwv8CpIBHq+77HMAqN1SwFDR9rWOK1?=
 =?us-ascii?Q?P/w3oqJhI7Sj3eGlDL+cGBWefjnD+9TJHuunxoZawVkTV6DDygVKYxGI1MSb?=
 =?us-ascii?Q?Vc/R6+7dQodYV3i2BfI4IIo+GpTXvYlvcLztrml97w+TibUdJBt7eg77LViS?=
 =?us-ascii?Q?9ExCv6KbcrcQ9OJ9LU3GbzfPV9v9VapTsbELd9SYr0hriP9sF2XLreREB+OH?=
 =?us-ascii?Q?dkRpGfWpshvwbejr0bu/fzQfiEsirr/9OccGMRL1KMhCS2XeAbcPtNgTXCLm?=
 =?us-ascii?Q?cnKIw/EcdN8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zPpGUwfRJGaRxOgdHX07U1N6AZa/T7AmD8r2iSvQ924Taq6gBXAmuqP8q7+i?=
 =?us-ascii?Q?BVvsVbsa+oQisNRmQGVUXdMuvQYHkZersUd8/7Ot42kHfTcerHYAdYc3+Joy?=
 =?us-ascii?Q?ODSsqCmOGo8ZbgGL+8O09X4WYru82ES0FG/zx0v8WQEjd+oE6WVvK6b5ToGM?=
 =?us-ascii?Q?rVszO+emWw8lH19H09eEv4JwB7wuUXLq3LwhJXHd4EXWgVveb7TBA4u9eQnU?=
 =?us-ascii?Q?VqVC21VWK11sor0tOI0FHf1eQ4JvC+1NiExBqw3mWc/3gezBz+mZP3a+4s+K?=
 =?us-ascii?Q?dHoiE2n8KYquqW1ojGYEKCba3306AN6fiKNgDOWMQ0RGUfSeHrdsYVSmvm9T?=
 =?us-ascii?Q?s9H3uc7UIenFRSNm9rD6rPa/g1UUBaIMDXCHjYfX808O0Bq+DRndmKRu5/H9?=
 =?us-ascii?Q?GCYjAAWZNgdbRr/ROAyrPrgZoyG21RKV6shwjhhbgakby7cHrw+SrQguaEeM?=
 =?us-ascii?Q?jxOKkBlEiMS9IzQLt6g6hebwhkVk2I+wZ4nzbaXq2UwFup1yrw5FbF+CB/ee?=
 =?us-ascii?Q?hibm3YlrHa5MBAf8+WslM39+PmuF8RhdZgGzksOVwMA+UBHLeVBOjJQscKHM?=
 =?us-ascii?Q?PB7jyYfSSgp6IbzcyMHKaaYIo0Pbj1FCLg5tSa3BAzUm2pYiUTFEDySuV25U?=
 =?us-ascii?Q?uEFJBQ56r3vi9jvDP2HRxfYBZVa76j0jFevGtcu6G7S7jpBg3kD8q50zM7y0?=
 =?us-ascii?Q?55/10ECC0frvp+nhKLsx/XIgJ9PA4fNNx92tVIYvOyGDWIwFra4+1Z5o3xMV?=
 =?us-ascii?Q?MEVOdHJTp+e7aPp6AOyg8vxNBfGEmvPLu5UgQWy6g8EqaZPSSiiq7jlKVh2w?=
 =?us-ascii?Q?sedMmBxflx3jjm7v9HqsjWI12WKhYoFi3OpIv0Pz/DsbdmtgGLvGQkQRuL5i?=
 =?us-ascii?Q?GE3qgrr43L3hCC6YkR9soR60svmuoKeE8Yrn7uWNYKXVOgbcN9r2sAoyBU3U?=
 =?us-ascii?Q?hpSepfLkvUpKm4KMgtIgjuYF3Xk++LN1fcyCx6oIgOwJFNwZEYCvyaCPIN6r?=
 =?us-ascii?Q?DDbopI+SZh5Q+pf1tl0PwooDf/yE/X2yH9H38Ax/3ZhVcKmFiKTlKN3YeuWP?=
 =?us-ascii?Q?2bhFTgwnNof2h2WVt3IXPZLnVJ8KrRMnpYvsTuKLsJ7yfS+2Or/GTG/vXEsP?=
 =?us-ascii?Q?07QL8db73V19xPZPzc0Dcy652ZYJfN9oQQyJRc+JXtksBk+iIT/Imt7jdcfJ?=
 =?us-ascii?Q?R9OB+uLY6teVvBFwVUB3qPLEQbae8dv/COo2J3du4RlU1sYr4KpNMHjLgiHP?=
 =?us-ascii?Q?3C8x9UCkEpFMLzyOV0Lo4gonV/YFQ0gqUPUtCTMnlg4FzEZOkxQIoScqJ++W?=
 =?us-ascii?Q?/zWLfF+2gZAIZzFey2rW+zWi1WvEX8g+mfc6NG50Sv3ArpCHWS1OFTVPxuYc?=
 =?us-ascii?Q?WcV9qZOgBKC02bfUDu7GKuhi/FxDeyGeWTAuiPN5I8ll2wYLED84oNmmyyuf?=
 =?us-ascii?Q?Q2Tnj4Mqx0I0Y+OgNoFJ6qyAMmX962tn5/9C2amWNunTZ9UfH+kLAeotngio?=
 =?us-ascii?Q?IerwoRzUiP/8TievT8lB98P9YBoFFvSEvh6YhhwqClmeYyM5jIzZMJccIZKO?=
 =?us-ascii?Q?Mez+TTEil1Gkx9bcJ3Z13hQzwqvc034W7rd7qiyh3Dem9vrm9ODCtepn68h3?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ulwq5FC/GPrZ/BtzrK8o70cUR/FBGOYeZMTs+dMGaNz1c66FdXzwc/Qn3AZjr3Z8PfvWoypaGxC9n4TWAX/Nz6uumT3i8ViKlHi8Y93Pr2pSUzaRRRdNmhJhAZJfWS0q6O5n6tiSxToq+VsIDAQe3U39+5LTt9Rd04pj4u0NGDWML2Cm3tPC9mW/+LSigRXMwLqWN3sp3JiGxjxAkBRFknVSDM5OSGM/ktyKJ6ZmTaFueBfsOP6PH9LAgvI2OCmnmBcRp6sd6Y/mxnefqOTgwTxp1W1mjF9G6m7nlQ6MnfpmrvOLO98Kva1XPOlPRlPMBrjp+nuZJuC/diZHwyWXWeYfqFQN/SkVpMccLwOOpw3BX6AVR8SaFU1dd0/2iMHRBbHUkd+mKubkTFKUq8YLdHry9U2uwu092ItaNDyi04G9FQoPqsAnIyiWdNBoDzzHreNnPEZB7LeiD9vWv9a6KEBAvsRrC2qDC2mY/BdOeAUvnc/NufuHbyfIFuGTYIVKDOYKPb8iGLT3BSzT4Q+5t3CQxHNilOYAS4sCzpZP6RR/CDBb4geBYD/IVBCQtxXej8lxsakQKYuwGss1hVM6SWm4TmOpV3yEf++j/yKKOmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d30dd62-f89b-4237-c5cd-08ddc2f8ff67
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:08:05.1285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qN975o7gF1YBSGpBeGfsuAk5DyI2+rsULtolmWaGV6LIAAsMPLaywAZgemHt1Er5D+hb3pe8NFu0LSb0usS/HelyK4MyPJyZq9AJP5pNl0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=912 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140107
X-Proofpoint-ORIG-GUID: -6FmpjWLj5IJ7XmRWDM8SxLEvwcJkD6i
X-Authority-Analysis: v=2.4 cv=AZGxH2XG c=1 sm=1 tr=0 ts=687539b4 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=XLpoPHau0aaAfUmBSNoA:9 cc=ntf awl=host:12062
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwNiBTYWx0ZWRfXzo+dhdqPS06i Hbm4PRHlsRlcTjTX7uOoMEfdHzt0XoDuc3+tEkHm0S+uYW+WypPBWf2Kq29BB8o8puqj3swhZ9o 6XFJAQNsfQF8Sq2eSBztvUiVz3BpAGmQF4rjxB4J32ygkJXfBolgSo8Q71gXpVZyUvndm+RfgEg
 /pduWz+7e7I9l4rp0Ap0FVRS2xYa9gOPz/q7EIDVAtJqqXz5zPoYOOebTMU4JXfMqNyFYD4pJ1f m+5O88YYHJAhs4MnDNSxI587xPmSLi4CiWEu58OSX74f1jm6/5kxTDDRychR1+et7UI8EWlYFOB 6JD9VS/TQV3T2DKgAsd/+QEzK1lo5iqtPvXq8JabkaSx9/3LFomNd6vZ5s5PYFRXFEhSpYakd46
 j7Whn9gWGrUTxgTx8IdxMKM11tLXTWSA4GHwQhuwcLQrkTNdiiTpHUOGeZF2XWrItdt3m00R
X-Proofpoint-GUID: -6FmpjWLj5IJ7XmRWDM8SxLEvwcJkD6i


Bagas,

> Sphinx reports indentation warning on scsi_track_queue_full() return
> values:
>
> Documentation/driver-api/scsi:101: ./drivers/scsi/scsi.c:247: ERROR: Unexpected indentation. [docutils]

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
