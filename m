Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CFA3921FF;
	Wed, 18 Mar 2026 08:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773824387; cv=fail; b=H4Jucgd6bn8cPObkaEuEw6vjxPvlE3hgJui+hp8Q/X/iFqt7Itnx8cjMYr/25BDDsQ1GPsKUfsQ7vLkIyMpsPA2bCqNHL3x1YlEWsV1wBwxJYJOOCWNxvXnKuKPpL19yfWOzb5Zm/GknGHHqT+jDFhhPX44ZBVQRaQrwVZcezuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773824387; c=relaxed/simple;
	bh=lp1dq+qXU4pn9d3lGXIHn+IT/VDEomuQDgW134SdaXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sVWwLCF2E/OlN7hgi8L9SV9CMAmVbQjFLach4V1bpTsLFOKet9VYeaktuSB+rzaQ9R9tpxqidzifTS/8BxUmSUbmkxN5DBMOULuqVS1UugjejRQiIxW11CaZkFpK921/bSw0WsxzJsyjG001MMfDi2n0OexC2o4joHF2simY6Es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NS3S5vmr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OBc889FZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NS3S5vmr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OBc889FZ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I2N2Mi3797433;
	Wed, 18 Mar 2026 08:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wxqdxbzaeBXZPW9b69T+PxbHZWW34894fobJPx3gRak=; b=
	NS3S5vmrgTw/3Aq2eGdDClQHIoDEKOuzTEycxMg+fsA14kxKfrJhv/UgITgtBuB+
	IXMXCLDqQQW6na7WGoAhFzlG2FO9tz837238tDq2eD0SaKr7jBFYiT48910NbRYw
	PpNWkrvJ2DSv8vn64a3uyd3InifZ5jZQp1BFTpEOeRwc80W19TsJb+Ax1lHSqH2s
	ngKNA+QHyyCq+9mP2WqEncYbDT7NolH6t2+jg+7eMiY4fT/m3DI6TmWooafcT5Xg
	vYoJ9EwHX2t2T5rM3TPFN6xJuPv9MLFCNkWlV/jAlRCVR9CO8Q15l1K9Gtlj1nNG
	3IC0rV6Y91H74MmJ9u0tcw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbwmpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 08:59:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62I7o5pP031301;
	Wed, 18 Mar 2026 08:59:35 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4bbr6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 08:59:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qsiHDRP+3iM+bCNEcPhimOuf0HIUSJeqxdSyWG4OoKZ/f4iynakkjxz1Cd8PtZB2dACVIoFF0FyKfIMZuecwxhbNrmC22QjV9ksSr/Og6uNWB9WWqbo+DzDwNYLrheSRTIth0L0sTAmE+1NVmRG3xp7A4CJ5mVgSdWGZfpD76IPQVNXkldbi5DjgLEKNwavmlbc45qIx+m9tJ5g82M2nBzccsE3IhPCZ0/TOjUfWAm5G0OXvJmytsQdi73ICI1yWveHOWVMw/04A/B7DVgZ0p+QGWmkO66FkD8s+QSfuoLWhQH6+WBhXiBUcJIQxTUETqUYtBSiYlH5nuvM0GaA4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxqdxbzaeBXZPW9b69T+PxbHZWW34894fobJPx3gRak=;
 b=tctT5yQL3qECNOSIkI873vo67JDaiIH8FEOiADtR1Kc2OgXs7MNpndN26pEepwTaa+zRbdxQW6994WXrWXg8h9eA2PxKt0eW4aKEeA+vrLbti7rzx0qYnR1bAJsoTSJWk3x8xmpe/VTM3ru7Um/CEMZjTvDvDOyyYJolQCKv5bZtLdVJKRG3Vk5d6eolf400DaAr5yCNN+N5aRcU22MHp+MU6Cmn2oeQSyehoPM9zeBRZUnBDybmh7WqYcXhwD8n7rWQHodeS7h5EUnzWaE+PfCYkw7ScqrlXzwoMsxQ4JCOin/Li8KKEbYtTKH2xsImSrJ4cG0Sv0eQtacVNqt91A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxqdxbzaeBXZPW9b69T+PxbHZWW34894fobJPx3gRak=;
 b=OBc889FZizIy06z9tODmLOEJWZelXyxZXEVDU/g+uJCDdMt1HF190UoHUu231Pq1Ycn8F9axAGLStMzZTpSkGOcUzLwKW+1V5pGb9XTDvVJHoffLRdXf0Cg3o9ByxAMXTW1/wN+Tt27VvcbqLNhOwxuwjckJDDZXIYgJ9I5UxF8=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 08:59:32 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f%7]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 08:59:32 +0000
Message-ID: <f0625323-655f-49bf-bda8-324c0fa4f520@oracle.com>
Date: Wed, 18 Mar 2026 08:59:27 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] scsi: alua: Add scsi_alua_stpg_run()
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-8-john.g.garry@oracle.com>
 <1bf4f9c3-7ab9-4be9-9061-0611a41242d3@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1bf4f9c3-7ab9-4be9-9061-0611a41242d3@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|PH0PR10MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a5b4600-d3df-4f3e-96b7-08de84ccab5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3hRq1xHDoSt/VoFoWxS3acm6OoVAVf2Ezergm+3PTKmRCbo+bxfL9OSPyMR5PPIhAAqJWAvVPY33VZzMNQfFN7vHBiVsphnkXz3OLC2P5zK4Gun4gZO6LekJDvCak5MURaUI0eaQGq+JHdMn8YeLdQ9HvuznsuEzPk3fpc4cJjgShJtvxh8nQbRNbExtWaeHczj+iDec75NLU/d3TuO7gMb3BxgI7AINid4RQ94JXNJeSQ+7BOrlRzw7I7FL8wlJo4WP2C40CC4tSKzbq7I3WhtHhu3tv/oba3+VIzgLzzFO+lntqbDj2zXxgSG9K5bvYn+x8Wn/9W5x8oIuYldmXf4GNbghixQl1Ja9UBueAzHpg//jkpagdv05v1vtuT1bFCsdMdS0uTGeV0zKSKvqV9fUkSlOCRv599NTB2ifnoXyt+TkCJ/y+F5KAKmcPDAONHE8QDC6sygcGqcsiIkCjQ5Cpd62Z23UdZNKjMbmmXPy93YE9kbfFedJdd+2Saz3Fj7SLYWdC1VI9t+Ebc1WvDLiZ/4YxFmW0djCQh7d6W0EFOadg8JAaQXIFtIo6sYkZQEim61w/diPJGAvoWFo7b+bxKd2BKqGDFmCI7Us8YB0Iq1yZYevWsx6czSgljNz3+F2QGa32+h/htuDNKgqppI0oUUfCimq2atN6Hw9PJnAymCn/WWx8ILgCRqNfivEZqTJ7U04RKsm4jg8YpIqB5yCvZSJaAklLs5jrJXQip0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmZHRHBKUktWbkpiR25oZ3lWWGk1ZU5NM3kwZFl1UngweU9jY3lsY21NSGZY?=
 =?utf-8?B?N3BNOW5aNWhGZXlwRVRCWUVOYlJ5RSs3OHRmb052RFpHaUp3b3dCWDVCa3BU?=
 =?utf-8?B?ZzJHV1JZQmpkUXRUS21Sc2UvR2cyaG5NQmxQaDQvU0c4T3EyVXlmWFpZRWhG?=
 =?utf-8?B?cW9tN0QxV2pmR1hJZFhQRHVrWnJvVXdRMGVsMWN4ZFFxcFFrTDNCOVgweVBx?=
 =?utf-8?B?R0h2SjBsY2lQMlRxQmo3bnBjL1NscUVKdTdyT2Z6bUpwSXprMEVvVy9zTE5K?=
 =?utf-8?B?RTNIWkRObEVvMytZSjQ1VUIySmx5c2gzdlJack92WHBXbHp6ZzY0TGpGaXJx?=
 =?utf-8?B?WDBwSEZ1akxkUHkyWkpBZkQ3eDV0bkNkUDdpZ2VUNWVSV2ptT0VJQUt3MFVn?=
 =?utf-8?B?Q24rcjRXb1NaSVhnRWJ2WGhnbzhzRVBEREYyUVkzY3pyZllQSkdhaFhqYlha?=
 =?utf-8?B?Rndqc0tibHptSEJ1WmRIQWlIMjVxMGdXMXltMU96c1ZVQjY1NU1GTkdpempk?=
 =?utf-8?B?NlNyNGdpdnI3V09Yc2JZaGxybWEvMFZYR1FQcDV3ZG91bW9vOVVOMjZiNXB3?=
 =?utf-8?B?Wkc0YUVVT2FVODhyUC85MjRBdWFSS215Sjl5RVU0VlRzQmZlOFFwQW1KVXQy?=
 =?utf-8?B?UnVaR25OQktEMXBFQmZkc0FyZWNxdzNPcU00ZTA5SVNWdFRveVp0ZjBDaFNj?=
 =?utf-8?B?S0NZd3A1ak8wS0dqNWdaQUhGVW9PTzZNdVBsQmJER3N5bGRCOEtpS05FVjM5?=
 =?utf-8?B?cU16YTMySng1RUJGcmE0MTNzUlBKUUQybUhYSU1OdFlxVTkxT1ArM0dpYVpq?=
 =?utf-8?B?d3FqTVE0WllYYnZlSzhOSEJTcnlScXYzVmpCQ1JoSytqZDRPRWh0V0FFREJy?=
 =?utf-8?B?cEhGMVh3MFZtVzRZeGh6NzdUZUtYRzlCYzhSVmN5ZUZKaWZraldpZCs2UHBM?=
 =?utf-8?B?ZXdPQnVlMnJYVUI3ekFqVUVTR00vVUVsdm5vYlA0dm9vc3NTY2FiL0pKREtk?=
 =?utf-8?B?K01Da1VtTEMrWlk4VmFkdk5mZFZPQVNMTmZvVGxTUmp6WlJoWFJNYzNnbWRl?=
 =?utf-8?B?b2hvM0xTVHFyTUZnaWx5RTJMaFBEeXNaS3FlVWFNeEpkTlRqMEY0d3luenFy?=
 =?utf-8?B?b1BzQWN2MGM5NWdDeVNkektMRTNiSWZoL0xJWXlzdnMwSlROSnBDRnl3QjVs?=
 =?utf-8?B?NlRla0xIWnlWNXdHdStHSjkrWU1McVlHZ3p5TlZMZHRLeXQ3NnJ1dkNZT04v?=
 =?utf-8?B?OU9TUTZHUHJ6OVJ0dWdpTEVqNjVNc1ZIc0hUN2ZuREtCWEhFNXZjS0VxdG5R?=
 =?utf-8?B?VU5iY29mbzZ0MnNVeU1SMHdBUjRhTmhvYXpOZDkzcmlwM1diZWVwRFRhd3RD?=
 =?utf-8?B?UXBEMkVlbXZ3bjczRlhtWUNMWFpsak5Xa0ErWW5mQTdmVFJYMHJSOWpDQ0pL?=
 =?utf-8?B?eXVvY2dkc0hxRVJteWV0Rm9rempGcG5PT1dPYUpLaEJTbTRzVXJlTzZ3ck1I?=
 =?utf-8?B?bXYwcU1rUklBcjMrcTJjYncwS0NVWHF1My9OaFA1U0dQZjlhZVFJNEpLREkv?=
 =?utf-8?B?VGhBL0l4NDNPcDZ2RWIzVlA0VlYrL08yUXJHM0lqeC9kZG1FYWF4NDgvZEpK?=
 =?utf-8?B?b1lwTldzanVlaHNDZlFjRldSZFh5ckxQWjIrSFFuRGtzTnRvSk54VmRtZVlQ?=
 =?utf-8?B?STVDdmJJc2ZvVE51aEhCSkFrZ3Vmd2lzMXdlbHNEcnBjZksxQkhYRHkxWm5Y?=
 =?utf-8?B?OUVXTG9ETXBaWlM0UmxublZ2N2QzdTQrc2ZRNjNwVHNHZTdsRk83dTFTcDF6?=
 =?utf-8?B?TGI0YW1BWU1uQndLYlBENmlzSDZLMDBUYk4yOVBYSWRqTkl2R0Q0azBBZGZZ?=
 =?utf-8?B?T3BVWkhmY0RaNmxEUFpSK0FlWmRXVlU4aHdHUXdiMzRGeHNvaldURHF0K1VH?=
 =?utf-8?B?N21HaXZzSjR0N1ptelgzQi9nUjF3RFp4M29qWS8yTXR6R054QWt2MzFZbWRY?=
 =?utf-8?B?MnF3UkxXZHFEM0VDSWI3dWxnNktmZmRRbGYrMG9ZVDJ0Z2M0Rkx2d2FmVFNL?=
 =?utf-8?B?RVZIUDR3K053UzNpbzRQaHJ3N3gwdXVjQ01ZOTBTUEw5TVZlU0dvditvUTUx?=
 =?utf-8?B?Y3lrQTV6OWZiOU5acXRjOHlFZjdrY3BGVEtCd0dLS3drd1ozejM2M0Y3ajJi?=
 =?utf-8?B?TFo5UGVxdUFYN05TRDJ6aUVqendCMW1IM0lqcEtzZU9IUlZMOHVLQzBmS1dL?=
 =?utf-8?B?RGIxT2ttaVM4NUtGTElrbEZmTkVrS1dOY3FJQ2VqbENJNWdZWXQ4Tkt4ZGRG?=
 =?utf-8?B?RXN1STM0bHBxZjRlMUorcEtJUzV5QVl1aFpOU1dhUSszRVc3Q0w1VjlhSlE5?=
 =?utf-8?Q?yJopjoVbGFQxcaqM=3D?=
X-Exchange-RoutingPolicyChecked:
	Nz/Ha6dmt5osEJ3HX1dGQhPndSeZwrctdlD1osnklI6j9WKJpAWXbxJQyX+xkREd/qup7KkMdKvRB0fnfc68u9J6aNTwdGcPjcbLadDHkUd7Z45jwR8J192d4vE6+zbDvAuGxy7xBf0495p6DjqOIdR1bNDmuYnCZFTPQ6a1B48SPh2IDJdZMml7QX8p9dJ2b+nJ+P8VcWz/zZMIyeqEX7Z5HR4SIjZzaBiJA6/3+f9fmnuHJYkKUCZA0v/pIN9kfDYaUMqIjLMg12bHDr1gIGSW4sbaCi8bK6/wibDMlbob/z9AywzTBKXQ5Cg0otSNQIJzljpW36c+B8r7BvaVEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wyb4YnXKl7qLw8dwDLZk9UKELspnU2iOEAtJwjLXUhi0Iwsl8Kt+6zw65OOGMHUYm+9yMOD3sDf7hobeg9mfpqeLyU6SaxphfHpwKWKIQMiQI/LqAp7uGAWKVnTLE1PMlXhAXrwVFfmwsOwIZpIRz2pxpsQqGEluHS+uo/qsdwliT+6Im+x8jHIi9eCVEHC89jsb/nA30GLvtZchbEgI5DP5CDODedWbMxNYt512IHZxo2q7zrJGhLbKOmZC11uFssK42l0vQ9uVG4kOn+hhRVukfCIP3pOAqjkCEVrr/ix4AQDFzOVpQ9bzxi0lrITQvoa/w969DwgmWeNvcCP9+CPFKJymTuTpYwGumSAtkhvGPthzCjglSuXmJtXA/SMzAWbJWZkjtI+MPuz8E0OCEpSouQIJoTV1LIEA8ZjMYPUxt8+oHBhD4lvoDFeZY5+PY1eVotPjSg8teSi5gWGVi+aurQcIZSGAIXzLRAdSgbzEYlS1pIZ5wOBAIOdLU0AtW4uovqVE5YX+h1zFgL09hp8vtVZyOCh0c1eqK5GTmSXo1Ylg2zbcOMI0ynCr7cJIbkzoD0TVkN2GE65pHmdcnCVlrU3dJJvj6hl22kMRqUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5b4600-d3df-4f3e-96b7-08de84ccab5f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 08:59:31.9043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpdO4zLKBMw/a63pukUUmohMbF3WfQOxrPHa+04+26cKXn4PWBJbJOIrdkZHJbThdFXUMawWY+ESpx1IEpaolA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5893
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603180075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA3NSBTYWx0ZWRfX7jy9kyvGGmsc
 Hq2DiH4ASB03lV5OaoXa68dAxp9dgmQlwqCnnRU1l4SUxP/CqAoSwP9ymq5MPp3/FoFhIn7jmne
 +NDnJbwS+FNPzkadkNyiscaejh5sYd4pmzEhK9cothBqfMB95rfy83Zwh5Bb7iM5PTW7oS8RzeD
 RH/0fCuFQzKyVLy1Qk3SSNBkFBYkDqwp/0CfifphAsJKz2uBwUYDDvYRtKVk0xc4GTVpzEymuqO
 3eYLSkr1JUQEJ8BlZ+pPoNHruiFHeDHhKMAlpaQPApuqrY2AFgHI+2nwQCVGeDLpHDA8jpBtAKN
 +C8xqlmiXD/l8hAHUSmL+NzOwJycyxBHUNwUpX2CcbRmb+5IkPDcrq0a5oIJ2Xp6fMtEJ7uuHWj
 n890uShOrPJ5Alpomp2YFWqn1w0EXChUDGUBbwBkJ0W6ZpycW6QmTmUYCrPZ6axmiJ0ya+GOztN
 B+1VRWfj0Hlqnla+ptQ==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69ba6978 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=lcTniTiQsoYudSlxUZwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10
 a=0lgtpPvCYYIA:10
X-Proofpoint-GUID: 3P2M8rWZm28eCZ9OjWdelblj96D0phv6
X-Proofpoint-ORIG-GUID: 3P2M8rWZm28eCZ9OjWdelblj96D0phv6

On 18/03/2026 07:57, Hannes Reinecke wrote:
>> +static inline int scsi_alua_stpg_run(struct scsi_device *sdev, bool 
>> optimize)
>> +{
>> +    return 0;
>> +}
>>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>>   {
>>       return 0;
> 
> No. STPG handling should be done in scsi_dh_alua _only_. We really
> should not attempt this in the scsi core.

It's not so nice to have the functionality spread out. The way I see it 
is that drivers/scsi/scsi_alua.c is mostly a library, but also has 
functionality to "drive" ALUA for native SCSI multipathing.

Anyway, can you confirm which of the following do you think from this 
series should be in scsi_dh_alua.c:

- scsi_alua_stpg_run()
- scsi_alua_stpg()
- submit_stpg()

You already said scsi_alua_stpg_run() should be.

Thanks,
John
