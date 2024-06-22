Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF98137E;
	Sat, 22 Jun 2024 01:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719020901; cv=fail; b=e5Tc6i+skeXaE1kAngoS8qsM+/P6b5hymW8Dyst8qeNofc0AUWEA57ko3afQZMUj9P/pI0kHB1weLbLINVJx7m5H6PGuDZuyRF0fslUyuEW8j2wNIEDXruZLvmHDAVdhp2m2RLsIdFZywHTaBxNJAaSR0pwfslHCOHkOYk994Eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719020901; c=relaxed/simple;
	bh=FkJNA5/TE5QMVsCaHG/fEs/wU3G9qGaJWNg3PKeGdp8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jyCGHv9FVUol6E6N4tjpa1zOMwOQYuSKGiM3Aoh6r3c+92rfm34q5l1VHfuLHxrwyW0NX0jtGiBckWnrnwOsAEWoSD0ZYdf5F8xirkYV2Z7OryIXN7EBJfUotuySpF2QRvGz9H5/+MPBGyLXx5Bb5KcF7/8w/8DxWODws1jiR7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d8cjimSV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HP5y6zYl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d8cjimSV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HP5y6zYl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45M1hkIC012801;
	Sat, 22 Jun 2024 01:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=2tBajZLpuKA+9a
	7Wq1j6EEYMQQOIIwkLSOSZBzkYNhU=; b=d8cjimSV5E0wmkOplJUn2TZzNTNmkr
	g6GcOUH7J+b7zgS8gtnPX69xWXaZDY0gSo8mpxRmQwWxV4+FOPVy1Ajz2YCqouKR
	AxuGd903vvwK4nk6Gj+Q9niFcEG25MdEcn57B9ph6L7MbcIus4YAu/sLxcefArph
	PXM9N6YK7FlIHsi2xAvHGV3J0cspu7yK3rcrJxU8xaFTwc3e989Y5h4IvNGL/+eT
	BEPwpBj2PhetxaIzR9wElNn97WqlSCPOUGUjJabsp1KRaLwXC8VbA2S/sI+lyENa
	98KMZby3TzWo4+FbdXG6F0wNXGGmf4MhVZl22M5j3NhCdKm95OQMCspA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn700033-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Jun 2024 01:48:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45M1XDFM024277;
	Sat, 22 Jun 2024 01:48:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn24r8c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Jun 2024 01:48:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtrfLxbOh43S+fUyhyNX7yQ1hSZjbT/1g6PPTeCbX9XHb+QKiFCacw9blC1Rg3ate9HTlZrOg54egWcR/FNuOzkO6H0x+wQmG+bcpN8YioJBNB6FSZydtG2EjEk6IKhpe3BxyX+8L2o+tMwQgw/YabahIUvpcjlQzsy9DUs47szpHsHh1LJXlcaALsUtc+Jk3aBYbLWXO6D+cFexjZb5Sx3CUOYPwg94nQRcS0oV2pQqK4MktqVtGoONz/m43tMarp1HUdnrLmkZ5wUktaqOFrJr6Hi9N48TAuz26kQxvkCLqLRbdpxZ0FPYm5JrSqHi3bQY5Bd29kiNV3WSmMimuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tBajZLpuKA+9a7Wq1j6EEYMQQOIIwkLSOSZBzkYNhU=;
 b=hQ8BzL9RE1RUAkPDleAzhW0jmyB15Eciz5ZlcX5pVx45dQ2/ruT0KR3Q/zLZpsGEtenhpP4LMvrPtecJPrn8Ag/rmNOTob7tzIw2/0TRPJT9pGd4H6T+PR56OQGNQc1+BKQU70AVfGeXZ9zYyuWKGE8+qfPC0vnWhSOrksF/TR5X9egFuE1IAhibx1/jtakINvOrr9cwnCb4iKwg1a5sYG9fMx9cl3CY6bN0P/BTs0COS/jG8iz6XnxagXNVAIgI2JG+brYE/dMXZ2H8b1NU1ZZXnvyivzX67mgsE2LcTfWhrkHxlgaiaFjvMuWnEkiaZlJlfYaOCuuGuZbMBV9z9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tBajZLpuKA+9a7Wq1j6EEYMQQOIIwkLSOSZBzkYNhU=;
 b=HP5y6zYleJlW4E7rV9NVvfnM1e6tF0cf9rhxRoOF54xJU6yjjVPFKJBhHXr2H+f3F8Hk/F42eOv7fyoxhySOcLYUc8Q34dgCSoWbYr3thU5Z5St+fuV0QxhAQ3EYAgytc5GumRd7GEVLQDnUEBNk3/TM7XytOPO4v4JDrS3Fss8=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BLAPR10MB5075.namprd10.prod.outlook.com (2603:10b6:208:322::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.23; Sat, 22 Jun
 2024 01:48:08 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a%3]) with mapi id 15.20.7698.024; Sat, 22 Jun 2024
 01:48:08 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bart Van Assche
 <bvanassche@acm.org>
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc4
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 21 Jun 2024 15:03:35 -0700")
Organization: Oracle Corporation
Message-ID: <yq15xu1oo3e.fsf@ca-mkp.ca.oracle.com>
References: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
	<CAHk-=whEQRH6eS=_JwanytAKERuWO1JQdzRb4YiLK4omzL2J-Q@mail.gmail.com>
Date: Fri, 21 Jun 2024 21:48:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:208:329::10) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BLAPR10MB5075:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb75ed8-0386-411d-6db2-08dc925d5d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?k24hVlRmfvI5PPTnV9gEMGgIRYtKx6EQzCIQJqUUKG5cLISf61wPG9HMdSoh?=
 =?us-ascii?Q?A/hTN2vs9125XCijZvutiKJUkwWb7MwBwjqss2pCs/OFaQgSUt8or6Ug1TcB?=
 =?us-ascii?Q?6gKdxdmVk15T2AbdddSKnpsVA3lq2YO2u5b5DVm63A+qQVhTim3BvczEs7PO?=
 =?us-ascii?Q?xm+Gy49wQrgqdtogSQrMBU0tHXE/TrxTG6dofGuOVQKFGuboxOd1ONBNgmiO?=
 =?us-ascii?Q?LMxcXhLHIbPtXdKr3x6nsltMvnFaRSvnN3DNZMpA7vDvho4dFBXkprD+aTJc?=
 =?us-ascii?Q?g94ta9L637qEsxg7q/Ql85wAhyIlC7bbvQmjZESlku7G2UgV02TbkaX2yvLH?=
 =?us-ascii?Q?H51xiByGr6G2bJAS8nvxbt19sNa3FsPknuWsIyVtHDgBpIfWF85NUho5F5uL?=
 =?us-ascii?Q?wFKCro3oazxKWiPqdPCzhkEVgH+68L/LOEgTbo1oIKRthoNmu1tsCaDDTi5B?=
 =?us-ascii?Q?asEXAIbv48y0v/nNwl99aUHd+EhZcLE4N/1JvhOm1JFo1325Q+/ZKBCTmWRM?=
 =?us-ascii?Q?QNjt/0q2rxZsb7Z4hzzS8oxH9QK01oT+havoMTiTEssWqt8nGmidbUGaV77y?=
 =?us-ascii?Q?vUAyLev08kN+3yV9NYD5fE6sedH0OhiZmel+LuabOuhEjF5dLn7rVjxO5Zke?=
 =?us-ascii?Q?fD+UfXQZP0w5AiYrB7EhKBLx5mg9nWSfy85nqcJcD2N7ni3NrWtmBL1Yvvz5?=
 =?us-ascii?Q?NgPTZ6ChnpW7Tm2VOKI8UJu3oagk83NJ0SfSqDsTgoeIxA/1GQXgWIOx5lEC?=
 =?us-ascii?Q?cDP92rfA5htMVFsu+gnCeSIL+ipCOmz6s5Ujcj1LqtatmQp0WvC5nWODu0c0?=
 =?us-ascii?Q?0XgHagwEvQEiDNc90LYmTNe4F2EMNXmGw0mLfDOxqL7Hcq2vSvxvMf6w2eeT?=
 =?us-ascii?Q?s3DT0ZwMbmvEASlYY61EiMkuqpvSmCnqJMibWye8aMkyytRCXeaGK5qUzL5g?=
 =?us-ascii?Q?0WW20EkqKE7sCMZp0Yj0jXjdOaelHHI0c/aVDMo7QSDaVmwXxYt3Ly+vb1OA?=
 =?us-ascii?Q?uZKsdjRdZnPv+xeGdf6ifTbUgqAVCXyl3wHeNpYAlMu6BTTwL7uEDucRIY0X?=
 =?us-ascii?Q?K7wGjSWlByCrkWQ6vdYPXSTR/P11qSF6cA62mGRxxCI4XUQzOi8JypzZgN3k?=
 =?us-ascii?Q?aDq1aqA7WF19v9x2oZMg4aO+Bj3m89nPNdoGWMt0h9iSXwEivWoltGjUH/bk?=
 =?us-ascii?Q?WNJrCXkR4oX+zySC9NpIR8JtyQpVVrRihC5x92+ZrUzRm40lx7ztq7f9C4JL?=
 =?us-ascii?Q?IMYAgvolmoyVBaJmpfvqWpwAHFsWV4uOy7FHkIkemofVdq72vZ8k08Gt9gNs?=
 =?us-ascii?Q?Nfau+qUD45hDfsmkq/gCgSqY?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VF4/aAWobNql0RX4XwRwcB4hwnoyH4/jEoZOEaPuUUR9J7xfiyWHGn7ySwIU?=
 =?us-ascii?Q?cEkT7CXb3kPYvVdYe/RH6zVLKZ0L3WsJOlx8ovtz6SXjCafOkGsv7YBvIGii?=
 =?us-ascii?Q?R7X+wpxlzwiYkkxyTYhkkaxfc5KaiCGGvAyKjQ+efmNWpx8tAjrjyC3/NaA+?=
 =?us-ascii?Q?8U1mgmaRmQoYnEW0iLCYD76kh81Ifh3iHelhmH104ERgD2cou8RTY08mhEMw?=
 =?us-ascii?Q?pojPRrW7rFVan2ymG1w80WGv52Eaib9guu+fzgAseAVWfD582yo3zh5ZCza9?=
 =?us-ascii?Q?fFgDkus/0zKJrUhbI2VPDWPx5GEguOQfA6omYAnPicQmvUUrglENquiAe3xh?=
 =?us-ascii?Q?T/wPl531ba/rsRZGWZa2oJD+FkL/QikXl8k1ZBT1+PnChc3tM/oOBEFW5qhQ?=
 =?us-ascii?Q?UIjr9hhFfu6qPXpIKlbX5VCkiWkks5THGybxh47G/haIuua8HKZd+1lyvDB1?=
 =?us-ascii?Q?fynYBiSaUZXnewnUJDJwOWBqmI/Lpamia7kSI3PJP77fIWdtWLwOOyrT/nN/?=
 =?us-ascii?Q?XDIWakCsBMbCQXWuW4OLOcGhBsjaL8usr3EfSrK4B1tH+V4X1aBCITCOt3UV?=
 =?us-ascii?Q?1qvkWFlF9iCQYsBav7Kycdlb3MCTFa2FFknUZ3Yrgthv+ShYYzfVKdCJN2rP?=
 =?us-ascii?Q?Cqzgw0YbvCo1/hmY54sa6KpQ83q447gfDUa50zc2JLCJDKMcdU+tvZlJxWBT?=
 =?us-ascii?Q?tA72OdyXJjSDdrQ08kM6ZTQTzSg6qS/0CuY2T2sbgu1bDxTZTkBys/yNiWHK?=
 =?us-ascii?Q?T2VzxdNtHlhMWA8+TjeJ/kAROHsOLjSenvJ/s2C6QGDFGV8H5f59Jp/vQi9F?=
 =?us-ascii?Q?TmPvAHwVvujEx7hehK4TCoS7JB7LXAjYGXXqP8rQDxyIXkVllkNQPbLJackn?=
 =?us-ascii?Q?JllUK9v96W5yFPpL2//JCVJzHQlElxBQIW6DRAws7SSp1fdyNjt1VA1miClt?=
 =?us-ascii?Q?K+DvSdRwQpJs9llqBaiAonX0kL9hss2Q5rPyjTfuFuntsPhCPSNJYuO425DU?=
 =?us-ascii?Q?0BuxhMahrEpbCptuTxKS7XMAXbV0xwehHIBs+cN5VZx7AnFUCJVwTHl8ko0s?=
 =?us-ascii?Q?b+o86P0K+w+htqPLeP2vuCWKmiIdVtJv87RT4Xblzwdog7sD5XNXjl3/OAJY?=
 =?us-ascii?Q?7fSrDEO8FFh6gXpsni0/bkHvKRfma7SyOv5XEX6+iJAc9KZIVo/1swqZw/jq?=
 =?us-ascii?Q?0nEp1e+VGvWN/cqQ5evmMP/ghTCWJUGwo7L30Ulp+RJHYGpIxLySHqF8Wbse?=
 =?us-ascii?Q?lZL58EyWfkhbNKDee4xwLdvUAbqBEhD4/5+SUrplP+TqkWTO08dZj02pH96b?=
 =?us-ascii?Q?A8PMkaj5M86JZzKixpN49mDQqISSSVlf7I42fGvlhYN0dcWOkK0CLKnj3cFW?=
 =?us-ascii?Q?jB8RU60OorxBjYoASdDxx/Xa7AjKUP1PNWE5cmcyqIpMmhcXLiFKd8Bh2lDj?=
 =?us-ascii?Q?XC2yv59Kq7JRze9FY2c2VmWzMvM+S4AO664tWAP+iaYKxBjv1QrzIaRIyEf8?=
 =?us-ascii?Q?Ny0RTBLomaeP4kmiKb0jCRsQ7QMyCEx4yGpMxqM9cdwoa/W+31OHVK+/5x2n?=
 =?us-ascii?Q?EK4RfAnTkfJk7txc/nlNX1PFvJmXeAfRP1c+vspbr/pgxnGdgABATlhM17Pv?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	b1+4TEsVoIjri60RNXntaKsiK7fcputF7LiZ9n6HUVOnZ6CowVkfJbgsAbQElb8a/zOCF4jccBbx69F6Mkgq/2jP7p95Qnh++AAP+TRmRFZyVVOCa3WNGu3xw+Ys8fG92vHBsXABNWbuhN5ckYFDuTOL8TaK+nr9mlxjt2h/2WXX1Mwt17TE6+YD3lk9ckSAD3j3U+/MotztPRYLhWgwHlqKdgB03z3zHZ0iLGPJGoWd849wWcQnRzfhbHKCX2qLsdl/VwhNaVIffJSNkHSdKzl2XTuinZt268CQCGTQv5QHdBDkz7EjrErvM5erFa/HYwevSST9mKeGzqXMHacZTi+tQHHkYW4OyavLO3ICMbhRrSv5Z+/JuLDObM6R9twlili5zOBKMHwNh1TJqM8B/9igUQuoMn6PrGYITv5CFU/wBgDVNQ0gL+ezd9QXCFOlENjpie+tcflrDX8VdeLDzBnsZoojgk5C9C8aF5iiwPMremLEbbHJkT9XI8VjFkwtEsYw+AiyFsYe1MqSeIdec6MFFUOn1ZFoaN1tEVEPNTZQvOi6NuAfbPkxhmufxGbcQFPYx4FDQplgRywta8zInTqUPIgbIpUGRvANvIogObc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb75ed8-0386-411d-6db2-08dc925d5d8e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2024 01:48:08.0085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCsfP7SL0dX+xnzsXGq9CyXmlFWSLd49Dt3SjLRj6LnhI3nFzbi2jjsFpGkpNIPe5skHBFSeZLs3bTX5Ww+UMnPgV2wGPlwpOjkpvjHIBgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_12,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=847
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406220009
X-Proofpoint-ORIG-GUID: cHDIvzTMwvWJ9NyD8C7TDUynDZJ-smLo
X-Proofpoint-GUID: cHDIvzTMwvWJ9NyD8C7TDUynDZJ-smLo


Linus,

> Can we place just make the rule be that new mode pages are opt-in, and
> *NOT* this kind of broken "opt-out several months later when we
> noticed that it inevitably caused problems"?

The specific problem with mode pages is that there is no way to know
whether a given page is supported without asking for it. Whereas for
most of the other things we query at discovery time, the device provides
a list of supported pages we can consult before we attempt to query the
page itself.

> Because if it isn't some mode page that we have already used for
> years, it clearly isn't *that* important.
[...]
> That should give people a big heads up that "maybe this thing isn't
> very common or commonly known about"?

It is a new feature in SCSI spearheaded by the Android folks. That's why
there isn't a lot of information available about it elsewhere.

I am super picky about having good heuristics for when we should attempt
to query a device for new protocol capabilities. In this case we lacked
a reliable indicator that the feature was supported. And since there are
non-UFS devices being implemented which support it too, restricting the
mode page query to Android/UFS devices only did not seem appropriate.

Bart: How about wrapping access to that mode page in GROUP_SUP
and RSCS? It would be nice if we could key off a VPD or two before
attempting the MODE SENSE...

-- 
Martin K. Petersen	Oracle Linux Engineering
