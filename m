Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B79615C9;
	Wed, 12 Jun 2024 01:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718156089; cv=fail; b=Lr5Ok+ANYIJOdXAtH4ln7poHBcdfnwV9LuXG7WF9lHqoEPhO2UmfkITtit9GBoOj6LotKLEJDzJstlvuYZ9p01jKMuW7Hk1764Yl9oPhuNM+IOQZhEm/x+WVnute63Tt7nq9TWoEWAm4vJ4FtefxOwxPL+6npqacdOk8vs35i+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718156089; c=relaxed/simple;
	bh=AjWj1JGcl4v+iDu4qmloIMhdvJ0+LbYrxwYXpRkY/BA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jRdvuRvAeWN+E2avzzDvx7fOm5grLljkwPLaPWHSXL4XqYIZydURxwowrJBx+1y7HJU2tQao7LcabfPLHeXU8xFiFiiBUZdzGEFM/WCt6ZOh7cmxRf0EeHMOAEFH1bMVZqPPNe8E35cs3pJrT1OzjDjk7lKdjHNWgfWL2Ppc9pM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cCTAIE+K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DaqTxmut; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cCTAIE+K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DaqTxmut"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C1CZCH011740;
	Wed, 12 Jun 2024 01:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=kGm9eBgnyC02wK
	hRDn9oQoA05nIyvee5AL5+BFy2TQM=; b=cCTAIE+KDg3KmffBuZtLfiVkbO0LDE
	YBwFc2MPZBBH0v9m4LRunzxZba2UpH1QU5mNQBLy3NxDV4RRwd/eHgQRnqrXQQhl
	UBk6I6jxx13FW1X9kl1YfhwcupllBHKCEzTIAxBIXtOCPXZAJMBmjajpA0qVdpoO
	kG06F4yMLNxk2fZHDMI2muO6xCM71twlCdb6A+eF3SS+pLB2WU+N2Ou0CcBV6wWs
	oAG10SJdpDd2TP6JFUNPNPUuT0ltCjQR5mieUDZMGBRc3R5mJTTdfnKDKFyGIzhf
	16W65rKgft2vp9J4ScPegPU/3VCcGLeCJ2Dgmz9zFjkLUUH6iENAY1ug==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1e3u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:34:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45C17lQR012553;
	Wed, 12 Jun 2024 01:34:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9xq0m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:34:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8iNjGGu5LHayZrNeM3EiohbwKMsuiUiUiEl7jtCg5Vd8U7uihx0tRbTO9kDz1hmfFZKleje33x/tTGqvLXAzkkAnjuyzGfHdtHEhrMHt/IhZbAgTlRmjiiRFytccvxHWPh59v/prDOzLGFcWVLBJD+gGSZvB66JZAH6/gqxdMa7Zm7g6fPrZwiGlYZheklouvKM28dxKoUEZJnzMXxOHhPIRES1pWPG60/zRWS/usEHDjkFdGnfuCjr51rx4N7V+oSUcUyBIflb5z5zn6+aT60LWxGJYThJs46YP+m3CI7/AmSJbn5SpLf6jdZ7OZH3BuvXAi4AeEykKeHG2BCh0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGm9eBgnyC02wKhRDn9oQoA05nIyvee5AL5+BFy2TQM=;
 b=azc6jCWBh5ON1nImuuuO8vn9o9PZIiakoA/a6nMTP2P6pJonx6Yf+tpT6b5FEYesnpQ13etnI7ojXAOZPGMeeoiMnkkVJLUSkYl4vy1YBRc7/r87sv/461tjT2jSvatOUQ1y/q14ReL/mc85XK/f6Iq0HQyXa10APPfY4koPsuP+l5pdnw8owQTDzBl/8mlwP+PQP3yYdjxDzCY203qgdZHZFx0Rgc9xhorxPXraL3PY/ufrQs1c6ii8+3fNCkOzAMJ+cvwdgeWLlsf3E1u3+woNWM28mn9F5wU258jBVljVL1x4ELdfeNfUZmCyjgvu4bjRkCkTYs9ZRro4Cq1ooA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGm9eBgnyC02wKhRDn9oQoA05nIyvee5AL5+BFy2TQM=;
 b=DaqTxmutXF2yzLbfyYS4FS8V8M92La2TO4dJ8CH018XmCixtECAUt0vsU1VDLmPOe4ERJ71mS3VTSndTsxl3IM+H+TJeu4ac0qI9+IpYKg6JtrW+Sf80J7/hJ9mJilh0vgS5x+p2TvYnWH6EFlW7HmsFlR+eYkgyr7G468/xqHI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB7865.namprd10.prod.outlook.com (2603:10b6:408:1b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 01:34:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.037; Wed, 12 Jun 2024
 01:34:19 +0000
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Hannes Reinecke" <hare@suse.com>, Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        James Smart
 <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "Juergen E. Fischer"
 <fischer@norbit.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: add missing MODULE_DESCRIPTION() macros
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240610-md-drivers-scsi-v3-1-055da78d66b2@quicinc.com> (Jeff
	Johnson's message of "Mon, 10 Jun 2024 09:16:15 -0700")
Organization: Oracle Corporation
Message-ID: <yq1cyonymer.fsf@ca-mkp.ca.oracle.com>
References: <20240610-md-drivers-scsi-v3-1-055da78d66b2@quicinc.com>
Date: Tue, 11 Jun 2024 21:34:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO3P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: c57e2c69-fdb7-4475-33e5-08dc8a7fc735
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|376006|7416006|366008|1800799016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?caYa8zQh9E+OnFmSLn3VNaiQasij6WSwDsuaeKN9yFnwMhKu5PB9GsUPZ/ox?=
 =?us-ascii?Q?Z6QoGA4QP5DVd+SusxIpUEMRGT1OYEpeKs/RF/jrMekHPaDCwqVMW00O6xhw?=
 =?us-ascii?Q?tTFbAGYysWrMYVBIS0/HsAUaQfmvbeYURLJZHyPRxLgIE0f9onJgUAEdHVbW?=
 =?us-ascii?Q?kvz5i9EEoaPorHuluJG2HxQ1r1Difsu2RIHsZfAMOu22B3L2WOuUd5LACi5n?=
 =?us-ascii?Q?eAmBT/W1BgZJNrrPFAosbkIU1g2X17PB95IoMEQYIwvqqiNpV/GW/KmvSJ+l?=
 =?us-ascii?Q?5VMWdXqrVrMUlNmq3K2loOmBQ+6RbRbG2Bvy2JAS9/s7Eq8lj0DjT+1gMzzj?=
 =?us-ascii?Q?9g8qEc+BRBVCGLRfcBMpPii3/+6J3BqxH+pyxsBmJJcvP8QC26SlBRTsRO7W?=
 =?us-ascii?Q?HenQoCtG4IKNG7wVJQlcFA8muekFKANQwDlhaU1onsCTj1QuxJX+/Msm+79a?=
 =?us-ascii?Q?XrvzRRkK3qcYk/4YentVHeJPfvApOLtwWBAYKH2ugdZcn/fV/GiHRc0gaBbJ?=
 =?us-ascii?Q?RJ4Z5g1z1w/v7R/aQFlVJ5Pl9J3yeVwqlCs3Iji7hcN2gPihDvWCzDiwpqRC?=
 =?us-ascii?Q?IVjJmAIF5RuiCMEeILbNxPQM6hUTwYM8uUxYPGCGqn/IqL59d/PwfMYRNOLe?=
 =?us-ascii?Q?dbx87x5voUEutGiP8whuOYfixlWf+2uyCbrkWo852FnrOykciVCEh4novEUY?=
 =?us-ascii?Q?IL3ZdY01HxOcgI80IKAHspciQqpcTrU4cAjo2mX1GRUP2dgivJhj7QFrI3wZ?=
 =?us-ascii?Q?xh1FK7zChl0zNVwTADzsi+ZkTSXfJK0YVQgc5L9qKBrD/DKolNL4fXzpYWEd?=
 =?us-ascii?Q?IRZbE1LM7YO484OUo/48OqZt5MjNR4ybMcqXAvb0R+Ke0Etkcfk9/92auAkE?=
 =?us-ascii?Q?l8vWkd/Rlvtqdgkm+iI/W4HIcQp2XA0b/MCmfFtfZZgV7OlPlDGSfNV8lKBo?=
 =?us-ascii?Q?Q+jxRrb9YABKVWJD7tq8cAYeTVeyNyifDHDmh7R8cIljkzRuZJu3IukcxGw2?=
 =?us-ascii?Q?h+Vvxya5iKZ7B4BknLH4btghweC3GqQEZ+otaWnNx4L04GZsv5Fvx4r9AJvY?=
 =?us-ascii?Q?dynPF4wITR1FsEptHbz8Dm18djYohDRcNhO+VD86WetHQQsda+i5zEoxuQR9?=
 =?us-ascii?Q?BmpHT8kKdwdYUpzOyBSHVOsV5UO7KvP85cFB/Jyg5bnli0qkas13HAQAWj0N?=
 =?us-ascii?Q?w7dxQObXlNbi2OzUh7EN8HuUeLLkM0Ge0g5KuaNAOXUtUlU3hkK1x+zK/YMI?=
 =?us-ascii?Q?XbG0I7MmzLsz2QLPdxfVTjsWMT6mONVvz9OuSnw9I/E/38iOpxCk8BpPM5NX?=
 =?us-ascii?Q?K2diaj1BUExngJovLFxyrBWM?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(7416006)(366008)(1800799016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?QQ7kR2ctT93WxIiOU3idEQ3xapJVPABntXKPiKi/TaIsusrBiyQWNOYatKVA?=
 =?us-ascii?Q?Lz1WMulnDBYeU7XvVfuVdyEibl9qESam0R2BVd+kLR1D/aP3SuPKaG9heXBC?=
 =?us-ascii?Q?gtLsQS3u6NciVDDZ6Qyz1rSp9flm8bKJnHJCFNSEREzkAzxm8kw8yfdUOtBD?=
 =?us-ascii?Q?SgoV22oDzCbdIxfyFaogC9WXgYPnS5zjs5nm5TTprmAnPU9RoBruRf/2Ox9c?=
 =?us-ascii?Q?0Xsv7CJw5FAU8jCu67kQGZJoGVjS/RZYCR551Thy9SCHjNM8VCFsunKMeRoY?=
 =?us-ascii?Q?kmXdAOsL0/ArG44LeZSqL0jlRLw345C8XlpcD2O5Ev/CNYJmX4ou5CpBQffh?=
 =?us-ascii?Q?ylrxDOY17t4/CJYz7cmXNvmpHqcS/0zcrlAXbCBvpnneradk9t2pY9LQr8vZ?=
 =?us-ascii?Q?0sHgRG+HinKD/TtEi9TA5w8jwMTjycDrrIVVKo2YWr3aLORdhteBiUZb5IIT?=
 =?us-ascii?Q?3v6ojcHbm7Rv/rkopnvKB41pNgQ8vtaOL5IwHJ+fWpfE3/I4eD1s/gBlqkW1?=
 =?us-ascii?Q?koazbA6ApwbaBovMWOTQmF5h2gxOECji++p4lMtaWAk8hYffaM2pBmfSgzTO?=
 =?us-ascii?Q?n2x6FuYZNhs1P7HbsHVEEE6lhacoOJRTGVOdkww24FfTgimU1JgZm+K6YxmE?=
 =?us-ascii?Q?MHRApI1L0seA9jJpmsuopMOrdgSsLb7ccUlQu/74N9PDE1riYC8+pCVbblcn?=
 =?us-ascii?Q?Vvee+kUj5JkXfM6l4dTy+tcqvkcPNmR2s1/qbpTT1MpOx4gyuLlvx8LX1hoN?=
 =?us-ascii?Q?393Qtsfk2ncUOOcxE0KSDM1Qr2q3mKy5dcBAjjHBLOBRTmAkm85YuPgZaGGv?=
 =?us-ascii?Q?25SMrBaFm5vjxZnUOV5IuYW+ck2WAPGp5L90h0LwH3mowIWcbCY+x1jrg/qK?=
 =?us-ascii?Q?BpeOJnbWeXHK881NV8PCNgSUBDQOWoO7oF4XZp566s3N8Xb6AUNyE13/O5uN?=
 =?us-ascii?Q?notXYajZ7apYuqEaYvCk8eVJL2cL3Or5ztde2Wz4AS5ZMLCFZTskTPiyrWdM?=
 =?us-ascii?Q?P4VCmq17SO9Y3jsqIMJ5JPUdohmjRxFdF5mb8G+j7ifaRnXs0RPzS+BPvNNx?=
 =?us-ascii?Q?xkx77HabU+VtMxAQSlWdBJ+my5jiR9MYU2kKA64dvkxtRRz645DNbDZt4HaI?=
 =?us-ascii?Q?FzoV+Ll4xzaOS7MqUQmqrqqUQChvJg9E1JPsoAjH44FBHG668VynkVq3kG9j?=
 =?us-ascii?Q?1Qd2KuZrEU8DFdPgwB4BnfWM26bQbRF7aD5y8vANTbgnQjEiPSqmqtpBWp1u?=
 =?us-ascii?Q?NvXqwQ+v83T4fD1hLFh0bIu7K6zvHqXNtBHXeL8oMV0+LxKU+DC2a1EaEyuM?=
 =?us-ascii?Q?PZbP9c/nKYo+98ZigSOvXWJ066tI65DMFqqHlctnAKAAbAHpgyrd860D/J0c?=
 =?us-ascii?Q?isdGgxp6d0B/7BD0Dbm/m/kN5LdoPgUG54sFUBzUJnb9y3vZ0mAmeqO1/iVV?=
 =?us-ascii?Q?neqbiTkxL9Dn5L7HgL2dpP72RfwzJUcbs00RAQ+W3N+l0450wtxv7qK9ENuL?=
 =?us-ascii?Q?fhHiZgxwWGHjKh6m8FJSrgVeoZI7dYyna2ynRy8J3MBaSRujOMozvhG+jvBe?=
 =?us-ascii?Q?QS9Jh4Y7xWZ3YzE0CC8YMNTIWm3esD3cjICXz/IesTTWKqXkb3YlLWkmPdmd?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Bkzjlir8oYq5MALNAWCJLpAbtZSFzGYkWdYb8VsLqayxsymmSj5Up5ZGDCQh9eQg3bNKqvRrjdkJPbc/ffe20LTwQdrbCxROODyl/AJyz8HRClLATIMmyzjRYPR/C9PImsxSQVrZ87ey9/G7cIWcm6s9kUeNVGxdpaj+GLaU1bBTmx1SYjLH9rbJEAgRXUeQ83Vc8OrTn1tRkHjxAb9frQg6HOvpDCdmSU6VnYXUoBfW8xDMSHa7MB8EHo6g1M9GZ1OJq5jSj6mwyDixOGJ6hZ7SJ8KH+RwowMUZpFl+FIhwwFdqfw8Joqdy3l0hmMhMtX05laQQU8n21MGkvIqFy38msEv2YTWnp14pAwQhia80wikQ5QdprmCebC/2RYI1d/NeIe5tjYeikTtrMm/jAnqYxgjrcBVYN2jSYNHsCU3mxtTuJJB9XTWCCec+F22Vd84sArKsoDJjFtuqlGhVHpr6lKyzmADye62NasUZI36qs1orSizqcyvhGqHTWb9AA4pYo+lbmnsl8jbm25o9m2XZCtek2xln4Si3K/zhuU7nDTuKVf29sxD9maTPPyEbn1MdFxZNZ75C+B7fHW0ez8MJK4ts/XhQWxlezAEx9lY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57e2c69-fdb7-4475-33e5-08dc8a7fc735
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 01:34:18.9796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVZADPa0GlTuKJWY/flbQyWMKTXRto7WM7IhsnUBhfTU1rNleUDTeraD0ogP9h7QuVpCAnUq5WQr/OUwuokZEJ3mfZ9jINNG3hQ2HXGp8QQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7865
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120008
X-Proofpoint-ORIG-GUID: LNduR272ETT1HUt6g-tQvGvp69_QkxMm
X-Proofpoint-GUID: LNduR272ETT1HUt6g-tQvGvp69_QkxMm


Jeff,

> On x86, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/scsi_common.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/advansys.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/BusLogic.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/aha1740.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/isci/isci.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/elx/efct.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/atp870u.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/ppa.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/imm.o
>
> Add all missing invocations of the MODULE_DESCRIPTION() macro.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
