Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4281FF7B0;
	Mon,  3 Feb 2025 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622302; cv=fail; b=WmULsNvihvIkE0k4n27YkkPnW7k/twifJ4dqkLK+Ipx4LSPL7+a72Pn27rSRn/Wo9vdUj1P3YGn5X2ZAszOcx7YaBChig3aRVefuO3Aj7h6dCWhoYXBce/hLOc1Zl+Px4SeFZ0aD/7SUN8eF+zZILXIY68dsffV9rnyW2XsLzMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622302; c=relaxed/simple;
	bh=31PLMNhlhulCk8SinAxHhLPKXJibGWxFS5xTkUf9/n4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dXnwn3WW0Fpv8jA3UgMBdA8yITx6K0lDcM2x67Qqn7/Gz3wNd45QkSgxt4aJg9FlGo71GVmZ8rpIzwGoPYOW1go7n8/1/qt3UWiEwAgMJgFekgcMouY2DKNyiAfUfYDS3I5CipYS6ZSs+/+/Rk1Sv38+HKQ1FF4k41y4datGAyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bBE/Jnif; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nFIEQl0i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bBE/Jnif";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nFIEQl0i"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMrIW008560;
	Mon, 3 Feb 2025 22:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=EJZ7F1V9hsHcUe/PcF
	EOXjuRwvEMM5fIC6skqUMQg0U=; b=bBE/JnifRsxKhVEPGQ+5muSL3pAPq0v0aO
	Rkc9nlpDqfaSyoexBhviOBIhO5jT2HqLgDqKccJ62oBtPfwGKq5EEIUveLJwWcS4
	/gg+ATOttl/JciDlLDPfirCaVThgMc4TRFchhsVRXNDyX8ThASb4UKnDhqMdHsfu
	FxXnygQN7mLTob+uhFUkrvyOFb/cYAhSL2C26J+lJ2qMf+SLyjicisl+eJSZNisU
	3IpEfYJikvt/mE3Ua6o7tTAajmN8praJxQsPCrEyNh/vei1+sxplfg7eBOsMYJ6G
	asrVbrDv/0FjkpV6fpvMGKEDr7uJYTXQFpOJPG5PS0U8C5xZtADg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7v3kwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:37:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513LUe5M036476;
	Mon, 3 Feb 2025 22:37:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fkftck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=veQbgjNn4rlIE5Z9O6tKXaUJEEztjAdCxpgFGq5nUsRLAJmywFaWhfz5dx23EI5do6/IunLQTfS9VdvTImOZvRjpt9qZvqs9O8aFzpR4NQ1EQ1MYG/JWVkyk9nLWQJsUQIxoVagII4fdyh71MYDQij4t3q4iJFHLjdFs9yNBFuAq0LVd4b5siwLvKjVw8ScTcWl8kZMT45TvKCOuLLRU5DH4P2NYVujOo1geGmtFTp7We20V5Rq46OG37YxnJaYPJlIweDwF/vpXpBBYB8wEY5+NsWgcQBgxeuayUNU9NlEofGW3fY2yg5xN+0P/9AlMauiD9AOHvpYygr+Cc5X7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJZ7F1V9hsHcUe/PcFEOXjuRwvEMM5fIC6skqUMQg0U=;
 b=ppA6FuIkG6DfgsQLIr8Zd7llM/xAXgzkv3a9sLPAai7nFDJX0RhCSP+pQl3ohB9H4Q36QXdGM20FGRcKydRIRjyuzSmzNc8s1eNCla7t+8S8puwD7LXn4o+PuoCwinC5OaEtJ/2lEeimLAtzXwCCF+hpGH/CQwTUJ75WeJ4/wTpmK6G8XDJMZgDoBKhEa4UfhnWMFISIjHFlpw5YBMv8N3re0sfWzO94nLVMu664PriD0GsxKMG9FusFaO6vVS6x6TYprWiLY/qME9ilrt37VDXO34lVlQRfa49GBEZtHx5aN+efCczvK76OUZml0/8103FTaTpqzKlig3oA/DmQ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJZ7F1V9hsHcUe/PcFEOXjuRwvEMM5fIC6skqUMQg0U=;
 b=nFIEQl0iU7zmg2sRO1lLT4JkNghbdYRpyDohrW5aIoplOe9VwJromo/dCHkSEpia4EQ1A6EByl0GFVQgGx3on0yrr14Kqo4gfBRTu1LnEs8d+uyqKrgQ9XBr5BfSC1EPQ6VRChddNwsTFvUoKbWgxWcFc7X0449+sXHT9WkR6i8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4319.namprd10.prod.outlook.com (2603:10b6:208:1d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 22:37:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 22:37:11 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Sathya Prakash Veerichetty
 <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: Constify struct pci_error_handlers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <efdec8425981e10fc398fa2ac599c9c45d930561.1737318548.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Sun, 19 Jan 2025 21:29:39 +0100")
Organization: Oracle Corporation
Message-ID: <yq1r04ehd00.fsf@ca-mkp.ca.oracle.com>
References: <efdec8425981e10fc398fa2ac599c9c45d930561.1737318548.git.christophe.jaillet@wanadoo.fr>
Date: Mon, 03 Feb 2025 17:37:09 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0408.namprd03.prod.outlook.com
 (2603:10b6:408:111::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4319:EE_
X-MS-Office365-Filtering-Correlation-Id: b3fb0c11-033e-4e0f-18e3-08dd44a34cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L/aN7M/dhqlurBHrIDGlTwZrZqDk5VsrWBvCaovedIyogCEz+JStnLGD0qHm?=
 =?us-ascii?Q?UikeftfJcxpy7RsYmZUQ6hfNfQdAPLf8H4IPz8H6JMbOCjfrGoDMSdCMSZdn?=
 =?us-ascii?Q?PaQ8lZeVwZjd5CBkQkT7S7oXEOcqUj5JUGz1eIHz0xtGD6JPGssAREO0T+EX?=
 =?us-ascii?Q?obq+NjjBxOCu1TRYOTY73sRJYzyddB0Pl7QcR4ZfuvWbj2z9deAtvWWlgVOE?=
 =?us-ascii?Q?M2+lDqq7KqrLjep1WHIc4pE1E4lTM5pSjBgDxAbQYirInS4X1uLpGyko46q3?=
 =?us-ascii?Q?tBHNLfC6TlcfxtKFult9a/dLd7qrz6aAtw3DLrCbzpJ/IU0uJWGC5Ccz0q8k?=
 =?us-ascii?Q?fGcTjjmb+eM+25R/MbudmWduGfmRASeBwgG2DLuav2ZpuVOKRHfblTk3d1YF?=
 =?us-ascii?Q?rEXoSfMMK4vKKGAr3TSyLkRHe35DkXgoX2/BmQh3lGefcPZyxxSSmpmcJ/91?=
 =?us-ascii?Q?XnQcITEm3xkIpD9RAfgOz5YMg9epftmyPVRoYsGCvxt8KGXj+rRFyNvqnk3i?=
 =?us-ascii?Q?l8BcPfs1SE8XRwQplciJxOkEDz0kKl6CaZqVQ3qmdNJJJy8sXrQhqTOxxSB5?=
 =?us-ascii?Q?ffS4PpFQDReg7E4puy3pWGUpM0gKSvciKs6DdONKsm3utuKAPqsWbzzWbzBB?=
 =?us-ascii?Q?NKQPifRuLAscCXzm+m52EwwGDFjrZ/VokkU7qQqOclJH9rRmXKL5tA4tpHcV?=
 =?us-ascii?Q?CwHgCmBU0WQ41IZ4csjY019A+Lr0OqA4xrR5qCBTMSulA/tvSbPqq9s1+dx4?=
 =?us-ascii?Q?aoBRmsUu21why9YCc/qZVJhJBjuKmcwMW6Ivr5WzdZN8AsUIJLXYqSbP1/Qk?=
 =?us-ascii?Q?HJMDq40grR+YYkyVrauLTMq4CND5Lc31CiNg+gEA8U67SAG1HIwnsiLOFB0U?=
 =?us-ascii?Q?OUjLwV33nfBuukpMjivM1F76rPYZoQ9hLBNaLrR0y3hrsf2MJqiBO2IcbPyF?=
 =?us-ascii?Q?/Xa/9b1Flb3g2vhG+c7kVnqVW9VkQzN9jEQi/+yRilKSzpFv1aGAE/S/E7kS?=
 =?us-ascii?Q?Lmltemgd2/S/YciSbczmmAJmDGpWJGRLBhXcazxrVFfLSdKvMWGR7LoaIq5Q?=
 =?us-ascii?Q?Vfn3bZVRJKGG74sJ7VWPvr0mfgrqQQnqWzl0T8Q7CuFXMDb1ry1YgxSQMyDf?=
 =?us-ascii?Q?mnftDMAO4P2abckwEbXNGMiPsrv5pUN7zHulJsdlThVUSFjBHrki4GuSd7SW?=
 =?us-ascii?Q?7gkYBAChNEVB8IJXietVn9OJLRMmOQNuZinxrvEieYgGUAuWjaN6+/ObLJMW?=
 =?us-ascii?Q?QnAKt7v3/3OIELrUQwHPL6ZRkb+w9+VL9hfVGeo/iANyiDEL/yeKdfezfaVJ?=
 =?us-ascii?Q?4Ayui19nFRUx7j4vWsEmg2v1UF/MzBO8VyZAiz7ecv0892Xs+8eeN2f4Fsiu?=
 =?us-ascii?Q?0ZyYTFBbXhHRNx319R9nK2K76MYi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EzJ/rdGtNmBWxoutvwDNNcL+iaDGMjWu7oxaloQalACbj9cjC2+RHoJT2dMo?=
 =?us-ascii?Q?B69uWVC7M9MvUD4+vjDyZsa1FlAp3W6hgfsP6MIxnpbWi+6R25JTW/sikEXe?=
 =?us-ascii?Q?5lCOmKnNXoCOBP9J8Ge1F/QcruDUCw1h4vA84TFh94YVQbSyVLAkQwOKsobV?=
 =?us-ascii?Q?u76/DZIjz/jAgxmSX/dT8erDsCcHMjvkdeQLFnFI5G0CrKgPtsd135XNy0Tn?=
 =?us-ascii?Q?1B4f5LL8KfUo4iUavYYDb3HkfqvnXu8UVAU5wwQfodqxnhkWoTfAmU0rtIKE?=
 =?us-ascii?Q?sgSNv0Iu1Vkk3XzRh/cNqdrwW69zNVeaZqAPsCwqNJ5dNwjQFIoMPFvNKfBw?=
 =?us-ascii?Q?QC1KI5/+EsBDf+a9/bFn+aHXiS7oehK9XuetOsHIGbO6jIc5TdT2sICnXHJu?=
 =?us-ascii?Q?v7lJPDvuP1qLqXfMnSX2/wiU6DELCinUGmcIpS2fN6Cc96Gc3RAnGvKLfWpU?=
 =?us-ascii?Q?yTbHsVkc1y8LWTwuzZIZP4fZ21rFDiqj8EPXQMLrlXfXDnOJ76rV3emN5i5Q?=
 =?us-ascii?Q?NNN8uAQC9FQUCi1NPTQqcuqGYJuMEywDJ1vmAj9LE9+8OenFHSdtW7mgcSmO?=
 =?us-ascii?Q?HAhe7kasvIQu8iv515CTZpfBy6+/E1LvL8xOlKQnm11eepAvBxixqJukuBLz?=
 =?us-ascii?Q?zHIBUKr9UpmUof2KzMKHuRaftRdq3r05ZDS0H2RmEJ3G2di5mt0sN8UAhIfd?=
 =?us-ascii?Q?JN1zwl2thqWTOWW5wQCzchpDPuAT8tHjfpoHt8OYoZr0+sNej7QoIS828cxT?=
 =?us-ascii?Q?XfiQJIDSLs690eto5gJ034zsTikrE3PKxh4uZ1bGzPXQyziJdUngLr5OxDdo?=
 =?us-ascii?Q?+ic0FCD9AdppknX+v2FpqUOH8qNJn1qtQsXjZD6EcHMtDd2KMoTThrVl0IOt?=
 =?us-ascii?Q?8azjbWbuO8h/ApGzn727hV5h+dyaJOlUEf5vjJKwpZruBvhl7tfmMUEjllql?=
 =?us-ascii?Q?MoTEAQaNnsALcCXlzMjhOcOrnLHcog1QlJhrf6gGlWDe2eh16l1wN8MAH62B?=
 =?us-ascii?Q?G/w8O7NXV+Yg54RlSLZv0QK6p7T9cOVj5b0RXmiwMakzJT0ddILUVPO04RT/?=
 =?us-ascii?Q?+r8eND/pJ5X1MA6lUiUdYt+CUrCP9BC/aSvIEHB2RzjPnQQCqV2jN8RMdrOh?=
 =?us-ascii?Q?MKHdsKeGXStKIPtc5sugui2E6Eo/X5GkwdD/N9vlK9MbSI0TmupRNqTOwLnX?=
 =?us-ascii?Q?aQOD+ZNbIW5F4hVXGis5gLKl0JWsUigEEEaUHMiKIzqbnTyInARnQK7SlmhO?=
 =?us-ascii?Q?rfHjj3n+MMw54lEAAdUrbzDxJTvAAQVOnuLGt9AQ+ZhBysSwWyejDMV9fNER?=
 =?us-ascii?Q?J0u4k0TGiSNL1/ay8e2LXggkTokK/VdhFjdzz6Jxgv1A2N+9dJ0E1P5wiEEp?=
 =?us-ascii?Q?EZa7DI5pQ4eG+SmFkFLrab+QDwzOIR65vy6sAWI70flIEBUxGDFbOGKFFvfy?=
 =?us-ascii?Q?f2kXlnjQ0Dz2B8XTKmARKcMNMBP5Mt5VwOEFm+LIZ9KWv94hN/ZRHgk+t8+2?=
 =?us-ascii?Q?K92eqWjmI5sLMh6hYrQm8nGWvVT6gQBJ6NpOqhkRQE0Yiq5SikNEU3cGJeYz?=
 =?us-ascii?Q?wurSik5bie/JW4/GZLhg7kXuxjPJ0nGnVS3Xtnk4UpnKhh9iRWPj5hoijCIa?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oFUcytvhMzUHWcAVupIg7gggMto74Ute6LErTyVbSuALd90XrSWjjnUfqTvh9lEoEvG0wNkiDEWay5ESddtIGeumfXilFMMonNRRX/i7EouCVIEDBPKS8mVw/zRUX0DztAUjv5U7Zn0ue4VsyIqjt5GOfBXcT8+LDZsXAP0zZxnObrOcSbFn+4mTuuApyLlgVLO+dZllrorFj+S2Flsj04yghqkGbBydEe5Bxlf+ymzlenwSKyvlR/GxFfvq6voE7bLCh3W5y7ijpJ6vuABF13KxG/hJi3A6x+HQGgueuWO0sL6NeC9wac09iNO9t3EQE8RyBQOIQPTRfEOWaqRZMNAyuXg9oqY53SboUTfYyeH+rHBRyXipm+Qh1A52s7YZzuUTAlW8M0C1IRmsjImrIWKsfFRjnJ+UsXNrL/KeKJcryCtZ+KlX0xssFR9d0MJXpwecVcuun1H3Ma15HgpuFAOJoahzvW37ntFHGbB0SUxlwYH7lecloUDFH7qVUEdb/YAclOttKSTanNPY4sJD3y7NEuPCCgHED2gzff+TfGZ7uDO3v9pLkpiXvjqZ30mS10cVeWQ+Gky5hqqA/azDBEX92wNG3gU1IpEHs/RmfNA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fb0c11-033e-4e0f-18e3-08dd44a34cbd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 22:37:11.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlGFEcpkUhSpZjXARUxP8qeS9YfW87NJ65TdETx6dZWKEzOPPIErRs8b28CUoMD8JrHMsYZPhr7rJazOjVoxHAeyxvot6JP0MDKRV4Cc2hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_09,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030164
X-Proofpoint-ORIG-GUID: j8y2_O6JD5T-tsDfD32iKDopCRwwVZfE
X-Proofpoint-GUID: j8y2_O6JD5T-tsDfD32iKDopCRwwVZfE


Christophe,

> 'struct pci_error_handlers' are not modified in these drivers.
>
> Constifying these structures moves some data to a read-only section, so
> increase overall security, especially when the structure holds some
> function pointers.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
