Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69704204B;
	Tue,  9 Jul 2024 03:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720496131; cv=fail; b=RaxrKwaoHFqrZeCzFuAFdy1bHDvhq+p8gGN+cy+soeXnpiyR3RpkKxzaBC12s/9qceScd46WVoXcCox55c3GDPfwLlQJNu/gn7GWpFPNBjGezI6jqr6wBu//az8emfTFNYTkffWTGi/ljr59fq/DelTHRCxNKz1KwCMLM/y/orY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720496131; c=relaxed/simple;
	bh=5a4yIBkNzoqmpuUzcR8VKWizOpi7cb6Fj4VDs4jE01U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AzAv48kWeFZrC6HHGyxA4BtDU22rxn3N8ZCsVErOqkykvT0AHnNL2YsAOb1L3El7mlvZ/bpwqRL/Et1VvSmN8GXu4UYn1KP4APswt6/AIycYMgb27+WM0eQHbzhT69h+yRxUA6HA4oFEAl6pu3L96RbqDy81ICiFx0G2nCMIy5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J9lp+p4D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=scw7BXKS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J9lp+p4D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="scw7BXKS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 468JfTjQ029021;
	Tue, 9 Jul 2024 03:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=3MAiHkIXFcX3vj
	kKV/y+qPskGjL0sf0PQpWB8jEHCtQ=; b=J9lp+p4DT7pyizS54L9Cli4XxZnVoA
	Y9/5mwqOc733vzkwTMVvzhqrZvd5laUfokRZXtVA583Aghzd8AENz67Fqe95EDBH
	g9QzTIYtWWh3U94XZ8pheRbB+9IiNOk2/r2fbR6/hJDGst0+YA6KV8DcAOrvlEtW
	UnJaJvJJnP5E+Mi2+DqV8lKwUrv5emzRd9Yi6BY+B/JnxKLIqdKUHOLkYPSGT+SS
	ksPbhVPdpWY5Vp7X9SWvkwCPkMSs4biWJgaxedJMEh/pIe7FHkNkWAx5s4K/b436
	XcuCyOnYDRK1tnfrrNYnM8pRAMXgs6tJygR78qsmeMUHbNGZFHSQ69rg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wknm0m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jul 2024 03:35:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4693Xs6h005758;
	Tue, 9 Jul 2024 03:35:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tx2411x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jul 2024 03:35:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8DvH7wZEgvQjd+6fw40+aQieF1F7NoXvQVSNQ5WW3UbequMz7EVqO+EKQQtMwiWfHKYNmjFuHAKmTp6tlQxH6Wf5qdmJe2pkHsHxiBA/KsdISJ4KwhN5ZJnXAs1ECNcnk2FBLg0ViZkg+zEnDG7HEs+YpnNrCfYrjMvn0RzRv1mvWY6+dUwcARJOIbWzjCtR4RPM6amzIpc13o4i6ZRvr02I8h8UsIpq29FyFe+1vZZXn6dcLl/vb1U9FRihD3+xW3aQALWX40V8siFxq/YnDul1yWSprmlGyOnpXRDhWI3kiasMv3pA91o1fEmV7LTvsYeqv3z+BJlRqGdFXnbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MAiHkIXFcX3vjkKV/y+qPskGjL0sf0PQpWB8jEHCtQ=;
 b=En5r5Vl7mOHUUYRfKgELM4K8znVpSaDUvNy/P2781EpLIzVP+hsUyCWlWl4DNEyUU2d35614xtdTiEj4t04ekShSudoDNMV3bmkn9p4avlYPduWA2g+d9UfXNVliMXgJzVkgwl5j/1GfpXiRZfqOZjgaL7kzkvwN2CE6F9XObAlgGO5uCbwdIforyxol50nuI/czrbt1QpAKJfO7OZQM8jwA9UA9REu+kcIwIwqtZKPLJMe4Nl5eOd8PDjqkNbAtWlPmBKavrx58OuLiCTdXIn1lljB3mTJjRhck10Usa928cjsHD7yHCj9rdl/+nz7CyPquhcelhPPgBmU7WSFCfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MAiHkIXFcX3vjkKV/y+qPskGjL0sf0PQpWB8jEHCtQ=;
 b=scw7BXKSiFlupm7VxNBKLxVz3WGnxUUc4HakV6x+w1vZXhjN87y8Zpa1PQOSvGjqHaMaIDk4GH6VBQDTAV3bX6P0irB+4hVrHoeW0m7qKgkPbphdf9V/WEvC9ecYAGP083AYIpNHdMr4eFJnVYBNJzvGTwLa512ZOG583Hu/tzY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA6PR10MB8016.namprd10.prod.outlook.com (2603:10b6:806:442::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 03:35:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 03:35:15 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240705083205.2111277-1-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 5 Jul 2024 10:32:04 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
References: <20240705083205.2111277-1-hch@lst.de>
Date: Mon, 08 Jul 2024 23:35:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:208:329::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA6PR10MB8016:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d219931-b58e-4214-4be2-08dc9fc82562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?k5MCHj60ivAK1DRtl5NChpIY2N6i2mI3MrQrT6zmlS8m3e+ZL7bqPLhGM2Y4?=
 =?us-ascii?Q?dYK+FLGu7d/6X7nNcelatYW0zHwumTCZCc405oOMd8CVJTQjpUJUtdCVlyUy?=
 =?us-ascii?Q?bZOHt6rTvVmS6dyuPt2cYmf9lopRBlGRxF2mYOQYwsiaXuqs4m9D+/qkIoI6?=
 =?us-ascii?Q?2A1sKXrKvpNXDxwrHG6AV/vK6Z++jHQ7sGRGkuuzosgw+xPjit3+e5aePS+g?=
 =?us-ascii?Q?ey6ZaW/pkawoldhxMA7DUfczmhMLEUYiEW9b04l/GVLPyoWPHLVQOdL3Ed9C?=
 =?us-ascii?Q?wVNHgYOH7VEYqy4Cf2NvC/cemA8kGO/l6QSh/lLs1rvuaL0H8EGhees6eavU?=
 =?us-ascii?Q?aAL8PUU/mSsmqfFrG5i2dqmpS0EL21Sf9v7jj1p1kQQiBUtIMhs7mP7VBwPT?=
 =?us-ascii?Q?M3kC8awTFfzUBq1IuAuR6oGwOQi8I55VUHF/5rsb9T0PfxfNHg7G4ovDhx/o?=
 =?us-ascii?Q?WogpiTdlk0W+9EHN+szHC3qe1cYOLFcGGsC9p4Yk9slJVBQBLgJaO9S/QF3f?=
 =?us-ascii?Q?O5dKokTDBOhLndOkbSFwiPG2ffiXEZ9YDs3q+Uzc5GGhaFPJ6Zi8s2Ar7wUg?=
 =?us-ascii?Q?GQt8vlS8uS3lFKfMVBf0aUd0pAMM66anXmHrtKSG+5Qwt4SInrxBZEtBgXXz?=
 =?us-ascii?Q?yMP4czyt8PMgkmSIgX1JNabbravU2MOBiMEE1ntvW7eGu3dS1LL//zA2WUzp?=
 =?us-ascii?Q?AJO4j7exd8s/d/GKg/fjTd+yIplG8Np3sWVo1N+W1Ceq0chI/bMc6UbWpDdF?=
 =?us-ascii?Q?oengU7JGxw/CSXr2qgg2XYvMbuZ106mOutOikaARV0jzIMlYRbYZv36qjSc2?=
 =?us-ascii?Q?o7edEcisZJUMLxTna4i/6eRvv4uCB0b+Ylki9Oy6mXbQpBQoqpMyXiYVmKEJ?=
 =?us-ascii?Q?AvO/QUJWUk4IPdtgW0BTYm/LTqoLrD7QkhRwfhvt1YOIeV9wVqF/gxWRIqpO?=
 =?us-ascii?Q?xTWLDJIMCZVtpB1Jnsz4zXL5648wA231UV+6PoIaaRdsf3q+1kozh2Q0L5dE?=
 =?us-ascii?Q?L4qLeq4GxDv8zCJfr9nw8f74GyVIKT5hg8kxbqpWsD7ZF00DEpdKjR1D8Qdu?=
 =?us-ascii?Q?vpDFprSTvjLpq8PlzZnbVMpBYdo1/F8g7dNQ+NpDc7W/iQJfsjAfhfgiDObC?=
 =?us-ascii?Q?8ml8kCKjBEGg1p3dPxgRd7d1Aorrke+JsF8qS8Fuzjc1T+1VxCsXvFE2U6Tn?=
 =?us-ascii?Q?LpYmob14mGLsUTnx1XQrKsKciBDLtZsgI8vXcjioooDilMPGohMsUgDwwt8r?=
 =?us-ascii?Q?/EygyFXCgXYvYrPXlw49RRvdhbmI0WntWeLM75KD2XChhbZYB9sQlDR227NO?=
 =?us-ascii?Q?mOrJ36+491AIexgo4kmE303mbSDP0Gv07QZHj8i0UNZHbQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Hmo6gqvgWNSgv6wt8/GdAati7kJgfGDvb6aBL0TraaGVbFOlKaSfmrYwHdan?=
 =?us-ascii?Q?9gEE0KgWBrVDNKl1KTMADAMF5umk+Qh4+DdCpcRYgAbDs2fuofU3rIOXe9c3?=
 =?us-ascii?Q?3p8E/RO30GWTba9/wrFpm50Q8ETiteLnX7zbOJXBl9xqN7FO7XXfxzYllggD?=
 =?us-ascii?Q?z0nBfZF/ntsC3jFGMkVugWepFqIlxeHcCCu0mGT5Rmqxliz1q96mISP3cuSc?=
 =?us-ascii?Q?pCGZI2dF86Xb9TKnE/Ag3Hm5iWQE1FAnEO0qGrfOWsveyye84rvjMf32pErf?=
 =?us-ascii?Q?tRFG1A/uFnVg0pWOOIz1/4VRLmaDGZpq7xqYNp+Rh8EQnqkmbpolqkIDxbun?=
 =?us-ascii?Q?lwR/se8RLMeNbpBmF1EmwwJifMGLI+03mL3LjRlZBtTzXw00+D7GHhMOjE5E?=
 =?us-ascii?Q?+Sut7YusFvUSrZqo6u6R/LHzDTkEe12nQriEeSHP3p5wDkAGrdRmIKdvPGFZ?=
 =?us-ascii?Q?nJ7IPsTe2TmNg36ueL1U6fM/isJiQr7iOdzVvb9QnkM0vGfFquWtBpjHStH8?=
 =?us-ascii?Q?XitHk2oFkVc+5UdpfI2bOc5z6yO7PdwAQHQQiYtoma+irdnYmjepECE2UykR?=
 =?us-ascii?Q?m15m3JuXxakTcpEIiBGB2e+1u9Ibe+RgUNISu/Gl0qiQzP8mKa8tP88r2I+e?=
 =?us-ascii?Q?C/iVOjSCsmnEMXaInGNpATF389pNEd25Kpu6IaewzsdQwDuBqjyeHS+HFKZA?=
 =?us-ascii?Q?+lOaz77lM76pNuXjqCknHTEtGlc6QENCMboJmlki7LogdE8RTrQLxkSVr+im?=
 =?us-ascii?Q?bSZlCuVtoXSQBFjdaT6gP5vCGkQg3wl0gHDPWJRmltPuwlCry4K0Ih7b6kpj?=
 =?us-ascii?Q?rflzoQIYdH632gUUgoG6CIfL491I5jlp/oXbBGyvVG0mOR89SOHLmSniH7LS?=
 =?us-ascii?Q?mJ6NkXqq4G1E7diBsOz+IO9VbZJvDlzNVwg5N920rVESGJQimH1Gj5x17uXh?=
 =?us-ascii?Q?hJYBeOPEGaayzXnYBzok92lwD9Qb/0c6ncgq7O8HEWe1qe290XS0H+XVLp2S?=
 =?us-ascii?Q?34T5rNVJ/RwU22u4HVsnsWLMMkDvnVb6YZqEcpOyoHuNG7iU37HQu4oIOKkT?=
 =?us-ascii?Q?kvosg7SaE6Y9Sqt0/kqXP6Y65tvsQ6ErCUxEZxEeyXQ/VXmAV0IJBX9MeaF1?=
 =?us-ascii?Q?gWzqImfrtvutXANTX601yD2N2gaaAcMUZIQ7MiC2TanR+Azdqw6Mf1eKBeNh?=
 =?us-ascii?Q?zDGxq/CH9uI3HzQ53Y18dvcTTUG53LfZ5ajH6M6B2oxYrnAByFq+dUK3E9iu?=
 =?us-ascii?Q?CCr3Pfvf++Cky9Lvj5pXc287LAqHrhbDaKevGYTH+AJSC3xb/xJw/zzL+Mhv?=
 =?us-ascii?Q?E7LEpE+7Ib3yhqfYeq++ttQ6KIUnRSsIbz0mBjk7TnJ2RyYvUURSytLuoWtz?=
 =?us-ascii?Q?jMHqxWjEcfQLOwfDi6H7m/dP/iBypomy5Ns/4kaHWFElXKTWvXZfNnsxv6gC?=
 =?us-ascii?Q?W2dAddtw13IOS9inIP7YE/xANZVi24OcP851nf/C0SfdKx5QvICNPNkLwOOt?=
 =?us-ascii?Q?kzNPGhDsNgJCXAGP8QeQTR8X3PqJgHSGjaQ9+IV98yjX+eN25kxAsuQ5/+Jz?=
 =?us-ascii?Q?GjWs5OHW7c1Pl4YyPS1wXV+9CqojTaPXB8TXsOXtH6rduTImWD+gQT299iBN?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	geFRi8j0TFnFvm+gt5rxMudJKFN66SB/GZj1l/dNaBR2A+ElJftkCxRX7vjpxe1zLjV6VAwmvej63qCA6v9l3cMist5M96Q8xIJ87nHOUnDzOajfNGsfUkwJsJ0ja0nVEDA4b7BGbcM9oD7bUxol+oLml5+Wz69EhHpmoTMkQWgk+dnIJXpBz44lXTGKf6xDLWsLjmzvDNCZpOPErWTmvZSTC7s7R8zXuQIJRcB6MSKc/fPFDFenbuQLMdm2G9bnbrg2mRHPFvEHykN/EekzJ96YVlvzEBY6bTjK8DrRjQMAvs3pnH4ZkFiAtErqU7KMUyzr7wZ8r+VSUw08WJd437VFTJAVS8SgiC9neflbYICOxlM8rHKfIZgKB1Q9Vl8BuK1Du7gqg5mU9lj5c4d5L+A/OP1JEtZJMCrHY+GfMeO6W4xvXDBZBsws98A7DOGegaAgIwK2OEdNxaUNJD9b6Eh4uetgneTbGQqvORR8MeiyDPbQFy/aC9S/KyNxYu8vMQbSHMDtVkr0PLR5y+L7kHa2bh+moZlw+j1xo2tuGsLxA7232cYGNY0RPCfOa5/w5SlqzhlhAL1m4YHDhNLsKq+BFmqzdsDv0IKdxFWA+7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d219931-b58e-4214-4be2-08dc9fc82562
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 03:35:15.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBNBJIiTFUVpYXob7EwxYOovGeMzprcoEp1+T67hFHeQhFxZtmlSIShN2AMHj7mwY3GLjPTrwO26IIA/4p7S1yrWIObZuF5DmBXzJvQB9Bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_15,2024-07-08_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=807 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407090021
X-Proofpoint-GUID: BdHLdR2QKkxLsIEOKgTkasjzBfG24Jhm
X-Proofpoint-ORIG-GUID: BdHLdR2QKkxLsIEOKgTkasjzBfG24Jhm


Christoph,

Sorry about the delay. Just got back from vacation.

> I think we'll need to change the in-kernel interface matches the user
> one, and the submitter of the PI data chooses which of the tags to
> generate and check.

Yep. I discussed this with Kanchan a while back.

I don't like having the BIP_USER_CHECK_FOO flags exposed in the block
layer. The io_uring interface obviously needs to expose some flags in
the user API. But there should not be a separate set of BIP_USER_* flags
bolted onto the side of the existing kernel integrity flags.

The bip flags should describe the contents of the integrity buffer and
how the hardware needs to interpret and check that information.

> Martin also mentioned he wanted to see the BIP_CTRL_NOCHECK,
> BIP_DISK_NOCHECK and BIP_IP_CHECKSUM checksum flags exposed. Can you
> explain how you want them to fit into the API? Especially as AFAIK
> they can't work generically, e.g. NVMe never has an IP checksum and
> SCSI controllers might not offer them either. NVMe doesn't have a way
> to distinguish between disk and controller.

I am not sure how to handle the protocol differences other than
returning an error if flags are passed that are not valid for the given
device.

The other alternative is to only expose a generic CHECK or NOCHECK flag
(depending which polarity we prefer) which will enable or disable
checking for both controller and disk in the SCSI case. But that also
means porting the DI test tooling will be impossible.

Another wrinkle is that SCSI does not have a way to directly specify
which tags to check. You can check guard only, check app+ref only, or
all three. But you can't just check the ref tag if that's what you want
to do.

I addressed that in DIX by having individual tag check flags and NVMe
inherited those in PRCHK. But for the SCSI disk itself we're limited to
what RDPROTECT/WRPROTECT can express. And that's why BIP_DISK_NOCHECK
disables checking of all tags and why there are currently no separate
BIP_DISK_NO_{GUARD,APP,REF}_CHECK flags.

> Last but not least the fact that all reads and writes on PI enabled
> devices by default check the guard (and reference if available for the
> PI type) tags leads to a lot of annoying warnings when the kernel or
> userspace does speculative reads.

> Most of this is to read signatures of file systems or partitions, and
> that previously always succeeded, but now returns an error and warns
> in the block layer. I've been wondering a few things here:

Is that on NVMe? It's been a while since I've tried. We don't get errors
for readahead on SCSI, that would be a bug.

-- 
Martin K. Petersen	Oracle Linux Engineering
