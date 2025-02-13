Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1CD23BE;
	Thu, 13 Feb 2025 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739414740; cv=fail; b=CzoBqBimBx/lV+1lEsVSpIns+ZvPO+0yRPzmcYyt0EtXGsGxSfeR4G7aOkdblCfzQBmA6BwJf07Qp75lbkwM0k+CTOf8H/knVOdHs3o6IPPJc1KTqszJaw4neV/ccvTzxzWq5rhbgobInEO01WosziH4gq2gtb6VFCf2C+aY12s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739414740; c=relaxed/simple;
	bh=55lujS+L1Gh/JjqulvDz2vTJE59u9fp3FJsgiDxfPDM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=J7Uu/4KK2Q7L1fqeub6SCeW+DMXYNSlbeY4plwua5+8XLMsHofxgfoHmEQKrvTTisS7oZn8mDJQFJH0/8rtEReQ9U0YRs9U4E8AWsbZRR+uJkSldOx+Ri4krsWFnolBLWCXtECDXRFRqqvlg8Aqercy36OIhCqlHlW9WApC1oLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kt7wmSuc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y1kTHJ2M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kt7wmSuc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y1kTHJ2M"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1qBkb013411;
	Thu, 13 Feb 2025 02:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=gHIr293xMJmn2CnnfD
	ulbXbbR3Q30Y4HU7DIdB0+LU4=; b=kt7wmSucDtkqqC7F9kpciUdapnNvnXI4J7
	b7MjNNJFqYgtYIizGnR993zjfU8vxdcPpkIS6VXXYCy83mf/eSK8fDwkk6stJXkP
	YvW232ldJTon/sNdUGgXPXi0KyrfEPodWCJg3dvU5rsD9kQ++FPwrJPyqacp5brw
	YuAYeggcHQHiA0zR77kMOIsWHXldenPqnq0is+v/TZ2XqY8lehoYfV/FeoGzesZI
	K8KsH3smM8Llj2NLy5vJuQtbDgtjiLck2gAZdhUEditZjPg6AgAMs62NfetZFIiV
	Yv0rAQpb2vb3adYZH/JnIfsqB1X4vjAU4jwHsREQOmY/eBoehjPA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0s40r33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 02:45:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51CNtlgb012560;
	Thu, 13 Feb 2025 02:45:34 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb3yta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 02:45:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pPJJIXsf3bH9gfDijTM9avl+tl5nN0SOQYR97a+cGD7LX0ulYaEdOlt0hLWcFDzZySjcdZKm6ZN5Vu+SUeFkFYRUQ2b3mLfk27EKKAhkJ/qXoQ1NXHDR50+dp4Ttp37y/rnMenH3ZoE33neLn/tPFoUyvsBEdmgUymbw+H6h9rfF2PJY5EHrL3j+dYdVntFcwDCzFOng3vxHvJFyz7jyfq+3CSBH+LTKGfH9ZsERDuQ8lZXf3/lltB3cl30q1kksogoqjWRXOt3kqcnLqCSVaBZeBBPYIKjhjG1sfMnpfgYo4a1YNhxqKKphQTrQOMCAtMWKwUiDDqaAl5TfAH24nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHIr293xMJmn2CnnfDulbXbbR3Q30Y4HU7DIdB0+LU4=;
 b=eltS3FUmWyurXE05XPPOOuP5LqZ0TBC9SK+vuF5qmLLbjR5z0t4MYLYF2oRFPS2nzk1fcn+d2mbjH9nNjuwGDHkS6a8omWQjcsfdvWTdPzndszrcUR4Kr92CKb9IApF7zMDPI/HlthC3f48d55rXZzYaQQxYL09aiNi0ho9XZkWN0yHFx8sqPn8bKkYDYltghDUeZmEl5uyrEEORjCCUSTi2zzScwxb9ALVQjiBSoxqJoo0M5J/syONtPsySI1GYzG7cQz0+9d2KhA7LRJ148KKOgKwzOwYTfNTB4aIqQfkzzAs4fOZFwmE8n04Ukf3Wnv8ibjD8mQryi/vNilNpLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHIr293xMJmn2CnnfDulbXbbR3Q30Y4HU7DIdB0+LU4=;
 b=Y1kTHJ2MAVpp4Ysvc6w0trLJXAlTj3MBFaQjxvfVjUtYUOfoCtXXQoaAAzcHA04xq6y37UbVDVaS0pkvOwQJIl7doA63PVtV+vl8vm2vVdIoRymlfTMfu9GCrEZxnow5KbtwhdvxtDTFtS7PfVEqG9OXClj/QUT6+niypbcK6Vo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 02:45:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 02:45:32 +0000
To: Chaohai Chen <wdhh66@163.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        d.bogdanov@yadro.com
Subject: Re: [PATCH] scsi:target: remove invalid loop traversal in
 spc_rsoc_get_descr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250124085542.109088-1-wdhh66@163.com> (Chaohai Chen's message
	of "Fri, 24 Jan 2025 16:55:42 +0800")
Organization: Oracle Corporation
Message-ID: <yq1wmduwojp.fsf@ca-mkp.ca.oracle.com>
References: <20250124085542.109088-1-wdhh66@163.com>
Date: Wed, 12 Feb 2025 21:45:29 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e1aba7e-d393-4b34-d8e9-08dd4bd87bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lJ+PN8eivqKtYNfqE0a5CAh4OtHO2GlwdgmB+5mJhHUXtVEjQn7+pfQo9/A8?=
 =?us-ascii?Q?8bHydmWWr8sQi5ro8Kq3/qpn/vb2KJp1v5oMN5e2tSEycazZAuRyrV2+0bTC?=
 =?us-ascii?Q?SFMxUNvKbtG6NQocovBtu3AWDP/zWkHH5xLi9Ad3VHZ4e3+a3HWHyiT1Iv6P?=
 =?us-ascii?Q?IYhI0hbPb4hH2zb6xgmD6RROPeEL6A1IxU2I9yt4ncJS0Wg1WrDn5dPFU6qj?=
 =?us-ascii?Q?Hp3ZmIHn7Iu8NsuAkxdOMoXI791+4hTeMuvW5qA7HXoab2CdX11BcHHaNlw0?=
 =?us-ascii?Q?Ml6x5CG49lGeW4gDPiNl0Xo9797W4hXp4/Z0orGfHmNeLk/pSFvv6uRXyWOT?=
 =?us-ascii?Q?v5WDXChJcOzirz0ZpEHpWjx9+EAzkHot6I6s9bjhFt+YEIQ/j0TdGdSXpyux?=
 =?us-ascii?Q?jmwSIIyTZRHKBaEHtZn1oiGKadQpyDZrneulOoV4xkZfadFhS7b+MQtFfJQT?=
 =?us-ascii?Q?hhmVVbZjYMCiYENDaVOau8R7GkeTriVhmU/FDSH6hXmhdA4+93JyPHASkzI7?=
 =?us-ascii?Q?WpBlr8qeX31S7GQI/ZXyBUXf/lm3OJVl5Re/UlfxJj1nrwacDJxCAeu3pBrr?=
 =?us-ascii?Q?PoaV6R08swNHXBFqEjOarvk0NrXkPCISZmxDGPeHuIr92ARzC7g+k0mpQCDA?=
 =?us-ascii?Q?Z6VEHQ5wZhBMJyxBN3vY+x4MVYDRafh5GJizKl8S9URu3tJekYuW9IYwci3b?=
 =?us-ascii?Q?9NOEurNvSSRY7etizGZBYDwd43B5f0AN3Em7MNMMsGAscoUoIdgzbyMr0rvg?=
 =?us-ascii?Q?zUPqYf3SbiLg7ya6MLSFBwFBIR0g/pYpJF+1JRWHx+TXKaWZWh4Fe+BoLbg1?=
 =?us-ascii?Q?TlDBaNf/wDhhQeqKDcTnk2UERmBCs/jjdlxriCq+nxaHJMkZkqGp4dvNrr2C?=
 =?us-ascii?Q?LDMIbGILgH5eAObYkDpTctRusgK1LtzIv7oxA3WmrI6XGu//RQmu2tIo/JXd?=
 =?us-ascii?Q?sR1fFBJW2S87Szcm0ggJqY4rVKPLwIqU2VSdOxnWnpOBytdFJWPiRnuxI7tq?=
 =?us-ascii?Q?JQqXC4rYak6mLnKk1p+s1nZrIjmTl+/+VGn22V8az7F3fH/jNj6OCAtwHphm?=
 =?us-ascii?Q?bkACr4d1w6iMtKPjOkShUoBBRTYFSQztVBv26MkZ1GIQJaFH/VVJc5QT0BGU?=
 =?us-ascii?Q?1zc5BDjsioZ5VfkHmV8Nn5gX1z2262ClEWxGy9g41QNWz7wdDxvBwNoJesJW?=
 =?us-ascii?Q?6t4TWkKkd5dWHQ3W8BQqUh3ILaa1drDpRfMyfaRaiLApB3fDfZPzczjHWV2l?=
 =?us-ascii?Q?BKoxlOPgy8a+3YUtaadtvo/HCocsPl6y4ZFs/0UwVzcP2u54BkRQ6EzZRiAw?=
 =?us-ascii?Q?fLmh9zigYcdom/wlisWG+ePMVzFYoui/9D1OvhEl4GtsGQ8ZEe/EBV5cOdhH?=
 =?us-ascii?Q?bP01pnaycwTlTeL5OXvvZ4ArNest?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eBfqzEz55te1wchfuOksvCOc3tFau9rNlX0Ybn1YjfXkbtRSOHhTRlcMf2X7?=
 =?us-ascii?Q?8z3POhvbLjpG7Iir+EV9WSP0h1je977VfpjxxnEt1bH5X+5yhFVKt9BHQYh9?=
 =?us-ascii?Q?aJ5brQIpISef2BylM3krC0934J0T6o/X67xled+D+kX6F+VGODoYjhYLrEEY?=
 =?us-ascii?Q?W4cZ3VyIh6831m94r2RqPsUmUIK62jvxIUNNp10L7yYBhryg0sFT6rzUYair?=
 =?us-ascii?Q?0EdsEupIdPsF1EdwiKa4DHvb5kmOeKHwBCrhSsUMIBe3ePogCdxTtIvzdsr/?=
 =?us-ascii?Q?OJp+nTS/kQrxGeTLzvlFZElQMi4ONtSN8uk+7I/QfwaSiQ5Mhgx6dubv1QOz?=
 =?us-ascii?Q?JudnY6j9fqPnHaRmjDIZ7UuY32haQdw1POFsqonJoSNfoJTYFE1mSCV2fyR7?=
 =?us-ascii?Q?0E5Ve83Pb9gMKd/AbztmSQPG6RNRu0GPU/QJDc/z/zPfYsB33O4oA0qPpvsy?=
 =?us-ascii?Q?3OL4vWA5a66VXvNkV6USAgmPTKfx+XZPvV4A5NiKXq5DgsdDLj+LEslSOZgt?=
 =?us-ascii?Q?OaZxy9hA9+tul+Dom0cyHWLHPYQgDK4QFOxSNlumlGD2yWNCoB3WM37AfzmS?=
 =?us-ascii?Q?Yh0IPLCuHGWDDM0IPzZiPRANw2VLZHwKp6U9f37dsDEsvgMbmUDznPqdQ+T7?=
 =?us-ascii?Q?eoJYl34o/2wjnp5Tte0Xx/9fZHNMzBXLd5yj5dIT4oMrHXxI2rrpQjb/Vm+Z?=
 =?us-ascii?Q?7Ecf0ogtsxwKNbuIdGYaoia3GkAYmba11TViGj5aRLpHBWiQBIf7SXf16JGk?=
 =?us-ascii?Q?ytKzax1xTuqJ+yK1EyeFcQhpTn4DD5+shWhKyjkWGrW0aQcK7ZuybV5QbUaX?=
 =?us-ascii?Q?gCxk/3pW5SwM6WRQ5//yMkxcQkNhqY7/XyJE3gIj7OcfY5b4wa2FxEYNzc92?=
 =?us-ascii?Q?bglKacfvDN0td2BU/6ZzqXWq2S8Xtqm+fK+uN7SiFvZ3bdQmPXkvhCfFZyIz?=
 =?us-ascii?Q?HayU+I+9obzMwY7qUSvecdBdMuuqKgrDJ8196leeXyWa2bZYTN5t8iTFmJZb?=
 =?us-ascii?Q?Mbx9rE6XzcSc9qcfwyz+dZtHWfmj+Aj2ihLZHw6LslREqGkD/ox6p7i0JYVN?=
 =?us-ascii?Q?oA0HOK2b7k2UVYMYeM515rjviTDW9US7+xemX9sWjrYpavu8rqd11cppkSI6?=
 =?us-ascii?Q?77X9SKbkrYBnceO+vQ8vY0X02axqND9glXsT8bs7lWrmuzZpXYQiTipWbWsZ?=
 =?us-ascii?Q?5RL4avpj+5yxDe6MEJTrnIKGd+f/kz9o/c6OopdyFv3K3Xl1MphFNJzPJ16Z?=
 =?us-ascii?Q?J7k8GapPpP1MT8W6WxcTmkxeFizEd+yxIpEJ0y1NOxq4oiVK/Ywl8O/k5Fr4?=
 =?us-ascii?Q?l/HujNVXczW6DOWS1O+JFmdQno8Q2umKezN1B7cVGNvVq5p0VzBhVGKRYNWq?=
 =?us-ascii?Q?BCcb84sSda8gtdALHzgquYAM5295D/D7yYnvGGEolxV2WPHwJHl/PtypW82q?=
 =?us-ascii?Q?/mGuyDsQcCyd/zPFasJXIFCRd26D7NhfNQZp6gYMXz/KAdBnvMMfsZ/T5arZ?=
 =?us-ascii?Q?xXdet4V5vA8Ah2NglwROLh9W4uN9uniY3GuFEdYbQl9EIagHbOAaVEKuLCkA?=
 =?us-ascii?Q?sFkGO2aSYquTIIQi59Ps0CQps3f8IKPD+pBECeVFgtSNggHM61H8DkVQVhgK?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mns1t9rAiSrZj2O7sBofQZwiFanbncdixe2PFk/YiztZa6dSCVDLVcZUML1ALlFOhYLsM8VhMrcTV1vnNJtAzVJkU0fnApNnBbipzz7CUNpvhEPpi095PfHjT9gqevrqvjyjQf3pT5gAwWXmzynu2jHVpH/xTKJOAVODhkLBPL1UIrOUsjh2NouLsX82EDwEtAWpiPjcujSVGBWpVf0eHW6t0zZUiNqLDdUcDtPH1FlXczGZATSQqfmqpOEUtwFBHGt4KcZy8+qwtqrL4pwzZ7QF7foWQDPgj8tJK/w2jhrZTS4lJLuwbMIyMg+3YhP1ahemdHyVmPmcfzmJ7JjJZECh14R2snhehhBJ//Elk2oAg2VqLt68E/1I/I/pD1twoJf2q0+VNiypuMIH3xPHjSiFCNNGrBbD8Fl0I4f8srXXJ/4sITzsQlD9Q6CAnqmbNcRamNoYEWImb/WrYFWAXKfXViX1e3wVgBImzZfgWSaic+7hGSAY2HJvn1sOp2SHkzDkTPmOcogoOoVl3vXJiWnjprk69LM2m7h8qIeuTqoiqphjOdZhQE3mPeh+XzR/g5K2RTtZiIp4xab1oGTns6Sq+7GuCfMXSrv7WK9luaQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1aba7e-d393-4b34-d8e9-08dd4bd87bbc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 02:45:31.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFi37/g69FZ7XabmGebWVwwnjGsaFTX5xI3lTKG24AQHWK2EAQ5o3klu3J87R9WuH3Wx+AXwTb2bFd2szfsGG4u1OmJC0aJ6KnMggzFuzMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=912 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130020
X-Proofpoint-GUID: ai0pwaMkBu0T3hXVS444e5svYhlfbqik
X-Proofpoint-ORIG-GUID: ai0pwaMkBu0T3hXVS444e5svYhlfbqik


Chaohai,

> It is necessary to stop traversing after find appropriate descr

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
