Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C68A4C63;
	Wed, 12 Jun 2024 01:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718156941; cv=fail; b=AdZ17AlzOHjhzRL9cTCtxquu8jBsM/EH5yQ2G2YnP7RCYmLHST/n/i93AsB1BXCXJsi9b1UQMJkYnFrvSq5r3xYS5hC2WeToqHUh3a8qrTeqIpn8WcUddf3WPlO0FP7f/hK55xnlHI3NuqNORQr+ukX07qrgxKtinMVkOo6GdVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718156941; c=relaxed/simple;
	bh=s8wHJZTxK5lSO08CnALWnhLpjxTMo3arWWAJbklV+/s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XAqow2dxX7giTchKWB30R7aZQEsqDR1FytfCLXk5XC2agTUp2/R8AcbtXpMb7wyXEI9s7JnE88YFfjU5dfAFQRaYqTAH9VoJTbygc37EKlw+ZTXKBDzknLYEnRQfyfvt8TyyUFDRnieXivJ1t71rZGPUsK0VufvjQ4jVe+KOiiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QlUozRoN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CnRiOdt/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QlUozRoN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CnRiOdt/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BFgUAN013504;
	Wed, 12 Jun 2024 01:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=HKriVYzFo7vPcd
	oE82yPNeEfDYbcQxWuhb8lxmBFCzo=; b=QlUozRoN85drJNJS/JNY5xg2VAL7Wc
	K8+dvWO72uRaL/04c+zOVuTzLEsnJSHKNwEPDoYI908eUgCRGMR/8dez8F3tC/e7
	zTdV4Ej9DhHR/aLt2A/GN2o5jyzDgByZL5G+eSIUKuKny42rkMv0FrRHcOUqOn7g
	sjWz6+u2W8Ueu6NVsNuExaaF+tI1B53dyfP1xjFGAQmvMMnj0SgN0iwoyyb2eLFs
	yAmXdl2rFuF6vJMsiFOJs0+IUzQv0LfvsZF/gP7dyOg5XgZJXHUw4SCCam0cMyvt
	NrBzwwQ1LWnJkH/dr6DZ97tdeupXlhg6qEqWSfhJfFIP8LvHNfr9HWKw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7fp2dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:44:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45BN5D39013241;
	Wed, 12 Jun 2024 01:44:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9xq7h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:44:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=en81QhgWG8YiSZiUuJx4VwMXTgNx5MHlkwl39/UWxqyaVFy5axe8YkUdzWV0u2NyDfLGr+S4EbfSIucjBnPWCF+3GRf5EQDJ7AKMG9o7tpkDEq3W6c1MTIdKbqnHOPUP0SSoz3tvetk2/I5DSNLM7pGtKoj4hvDgBmDrmMJh9uKxHnI2txXuTIlLv3bK5RpQjPmcXgkbBciZykby+bAvn8zbDvv0tfcoeGc4GPc2GjQ6KJcVbFv+c6YpJAcQHHYsMXCOE27nv/Qrg/PMKeBP03c9kKgNGdtFPlXTXb9Fps76lNLW3qJBC9ui7sATRgR+Estt827dRuofCVyO2v8Wfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HKriVYzFo7vPcdoE82yPNeEfDYbcQxWuhb8lxmBFCzo=;
 b=jZ7sJ9XQ9htdGZB8ZDoXc1AX2KjU8vGuq9xPc/Q8yAmGySgrDT8M0kzCTVgyX4AcYGNpkyHgDaj/zYOG8AZ5NhxBqpZhH7TUYtqvErXr+drs721SiGvhaTX3ujMRjFy+hLcXv7aW82WPR2FtoHvGULn/Q0XU7yIpGoyG+qMhd0OWlzdLbFHyvDyzqUkbUIIsBrIEN+C5sKRhxTDBPj6kb04e4kB4JqrTGw4JejfoMHYgrCBaJrkS6Qjetk8m7sk4SloHIh7khVZpnyIo4Llc+8dkbJI7o8AGEuDC4NycLlDfIJHH01NM3XA3BTukKf2CUnEE9IggDxs65RRfGAdjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKriVYzFo7vPcdoE82yPNeEfDYbcQxWuhb8lxmBFCzo=;
 b=CnRiOdt/N3KVijtTRdCajAKZpJsQ9dvWgJOZuIGPNQyODSZt1g/Usskt9XoosKnhh1RK9eC8/xuO8QYsoiVItPRKS7mXnqEwbDclW2LSczE40CKn9kBxBYZP4bqOUzLarqC8HU6TqzJ7h95roLbYh8yDwObR8owI8+5xaj8NJvA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7301.namprd10.prod.outlook.com (2603:10b6:208:404::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Wed, 12 Jun
 2024 01:43:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.037; Wed, 12 Jun 2024
 01:43:58 +0000
To: bvanassche@acm.org
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <avri.altman@wdc.com>,
        <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>,
        open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <f3fded35cb250e16ee5aaa67d7a7288fe2799fd7.1717104518.git.quic_nguyenb@quicinc.com>
	(Bao D. Nguyen's message of "Thu, 30 May 2024 14:36:40 -0700")
Organization: Oracle Corporation
Message-ID: <yq17cevym2d.fsf@ca-mkp.ca.oracle.com>
References: <cover.1717104518.git.quic_nguyenb@quicinc.com>
	<f3fded35cb250e16ee5aaa67d7a7288fe2799fd7.1717104518.git.quic_nguyenb@quicinc.com>
Date: Tue, 11 Jun 2024 21:43:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:a03:167::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 47ea46a3-f25f-4311-5acd-08dc8a8120d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|376006|1800799016|7416006|366008;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?m3EsUfv9fRTY0x0MWhKpJhHAVwdk6nH2Qfeu61+KGMQ5O4l52zP1+GdUfEy0?=
 =?us-ascii?Q?JKcnsg6Esrede/E5+Qjjn/FXx7P14+UxhQv1w4MTSeKOJ0Ra0jiIvYEQYytG?=
 =?us-ascii?Q?lhNgstw7IFUBcWYpuUWcqTPZ0m9OdI/rIX4BkxOHNcXp6hx1DXQ55g0kPmp6?=
 =?us-ascii?Q?lFoOwIOMgKRMSOUPfR8wJd8QNhXajC0QcmmV5S2ED851p+2L6iK+CwTuXuyG?=
 =?us-ascii?Q?GfQWjmKnqm6pquOxYxmj64x3FDZKSbjSy73kjWpqzqXYDd1VEBF8OLpXwtmY?=
 =?us-ascii?Q?zb8HXw+S/tIpSL74H6y5lY1jYU1z2Qsh3ThlGLkS5XWSCL/wvPCiJYSQeUUD?=
 =?us-ascii?Q?d+m17Ql2l+FsPb+naaq8T0TeP8xWGz5nHwd1k6mL/wXLI74Q6W9z9OJx+jIw?=
 =?us-ascii?Q?otghXt/w6Nolj4eJ9ADXGyoDq/7Y+G7Fk7N+e/KFQssiS6fiDYU9B8IOMmFX?=
 =?us-ascii?Q?a9dCaIsRTnRx+/xR7hmvWXCEL1+ijLPcr3z0n7dyUx66PVQGb5Y4T7ESDpDK?=
 =?us-ascii?Q?YYzQD6sbvLOknQ6Ls4lMtAdzSKsd1o6T7mqbYviInnkv2/xqokrH5dUWG93i?=
 =?us-ascii?Q?nlKhrlSOEcr6qOskHv6vgSddoXaQ/c+evMCqPiRVJoxQ+vfo2mMaNWfah5f6?=
 =?us-ascii?Q?RHhXI+esc2/EbRbioxAx1NEoHIcSV+uuqtf3p/Wa6e1f6s5nU4qe7ZiLiuL8?=
 =?us-ascii?Q?rcd9BhLefSrHzouImeik0UCeznDXoQnOnRPFensZqqbR3x6ZknnrhZP9UaRW?=
 =?us-ascii?Q?L+fyNo+Bvo5hrhjzVjKdGWV/OHEahiZwq6K6Lsh1rNRkPC959cd/5t2Gcq+o?=
 =?us-ascii?Q?CGLVR93LoBdnesDDpiUgG/FL1sknaXSaZkVekCUZqjdRHxVK3eEWK+5mNN58?=
 =?us-ascii?Q?lUaz1Ovikx5/oqouzaB9nVT4F+Wp+Ae2fGf1+dWj9tX0IkA8CG9FkQSMFyo5?=
 =?us-ascii?Q?p5lEUDAKXoljFPMwShkfYd/czcm4TDCKuKNIAH60h2GfBCbr7Rjb6dg4UaGd?=
 =?us-ascii?Q?wbaOlmtcKyNLvgsfeoKbaf+rnefRkEvya/jAQU6lUkmqOlV2CLn4yvBPn6Wd?=
 =?us-ascii?Q?EhgftTg8cm4kS7tp2A1IFkVbPTBLEZDDatEShXtOKBV833LjeHhR1otXd488?=
 =?us-ascii?Q?z8fPvzZXfH3sboXooIaY8pPEE2CJsypTrqoTJyTA7g2EWlRrHbaFAm03wwco?=
 =?us-ascii?Q?w870e3qs0vPwliLa5Lfo5uhl6z8m4pEWBmCifCclvvWb26Wy6JOOgH5KvvaU?=
 =?us-ascii?Q?VwIDG57QaMOw7B8VdxrPe+J0SdslnC3AQSiQ7t9QV5p28FmIGUDyTfRQX037?=
 =?us-ascii?Q?jcg35U2R59gGymXuG8dl1Zty?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(1800799016)(7416006)(366008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?OkwTZEf/mTL6jx0pyPblW1UZNaD5rwx/Nn6Gi4m+5+i/ooqrg/soxNt/DgNd?=
 =?us-ascii?Q?n5YSFbRE+Gl07qovmu3RsYlDicbP0UDrdaIRFYTgGjJmqXDIqtYiFfi6hFEm?=
 =?us-ascii?Q?zXZkrTutUoPGOL/NKBelP09oJZsZ14Ng3rKCiBld4pwboO95hugIABTZg/eR?=
 =?us-ascii?Q?8DmJJhHKI9VRr4B3hUsGxk1Xh9vRJEnVizYnIMFTTpUOzDpx+6zGG7RkX71m?=
 =?us-ascii?Q?fapLQpfADW1fWMSdnjLTdBIMcaAAwzmu+twSeO6t9I+fFHP5ng6lyYpBZVOs?=
 =?us-ascii?Q?m12voVK4FTxh2op+qixyzN+5xGtBPM1Tct5WFLAVJ6/+45GwmHJk3JIarem3?=
 =?us-ascii?Q?cC4jS7LRCkDVQtCZwWXGaa3YIurp7If+RWz1qFpUriguwq9sJAJcBRYklPEB?=
 =?us-ascii?Q?BtbyiOMOCfWefL/08J+0E40Vef9bI5xDLi0gSdZGOS6wAPKg856vsVN74alH?=
 =?us-ascii?Q?HaggJxJdkq3m+8/OW4vUxVRB9YpqKWp9IrOAc62DW6mlQV3IFZwvK6Fm2OGa?=
 =?us-ascii?Q?/DWL61s7hERV8S9eYfr4WZubvZ4GyV2EiCRf3XPryw+YDUug/GKcxZN3TbUQ?=
 =?us-ascii?Q?T8JzOCQLsqQ2DVCJbWxZrVbtzugQUn4y/XiFdKqKJG9YyDdzfkhWUuJY4skX?=
 =?us-ascii?Q?+pjAVRGNlkawFeMhetaWiXknQgaBRlqFeUQd6oyWyng6HfBjeSh257/eeose?=
 =?us-ascii?Q?aNieEkhefpCPKdd0DMvUneOjiJrWGVN/qexo+K2e2N1kVtkmL3laU7StO1Wz?=
 =?us-ascii?Q?3rHu6DQx8fHghTT6omVpfyT8AeSKP/Yzc4Qp2UY5+oJfHuvaKmOI+B04FgB8?=
 =?us-ascii?Q?YRMk10uF/Qw+tFuJFkd6eawIu7tP98n63tA0ZKevi0hkHrDCah5LwhPurZB3?=
 =?us-ascii?Q?/VKjLYJNCpC3K1qJ5eoRqj2/lJcqebDLa+si2eO2N08lUIW7H8/6jPy60emj?=
 =?us-ascii?Q?bs7Y2v+lWMx+oamrbP2dZaqrla9NdYcPKUMKnIG9U6too4yZQAn4b6DH1xZk?=
 =?us-ascii?Q?MLHMm5s1giGBYGNmExvgjdd3VZXae1y/bdby9KUKi12ticcOQ0vCnrgYzFgc?=
 =?us-ascii?Q?cpM+lahv2CWvGy/0D73UAmjewV9PSFxCfO+gXj2jcFJh/5gU7dezPHHsaDwl?=
 =?us-ascii?Q?vdqL/v8vaDcWJgsE/xo1um25FUzWaF+Geq5FHxsPr78H7LLt7qZtp1ntJFN8?=
 =?us-ascii?Q?olQuhp+4/FkrChWZh0douuea6yEG78S07hPCk5PYTkSMYXwvPfFxSJ1lbarv?=
 =?us-ascii?Q?bf272lHwMfXYXLw46diQcfTDkt3I+JfXKveMhHi/ynrCOjhW+HE1nn0GwHsQ?=
 =?us-ascii?Q?z0fSAvAq3SoxDxnm6XaupZXJpsHCvA5nCK4sX8gcPcMidHy1M09m3P2A1/Ry?=
 =?us-ascii?Q?v1KJmTBJqR6RAep0NfKnvofPT6g5K8/ubI3PBWpmDEkK34gu85KOyYdFAiLl?=
 =?us-ascii?Q?3xvZhi6wJfLlUhpVOqK7YHeFKq5N1sv4kwOef1mtfsi6cXZFa7R1lLp2LBqD?=
 =?us-ascii?Q?Zs8YqqYnHxYrvIxaDH54aF+Pbun6UEnlSPogOLlFYoG1KhcwScu5EN9rcHTY?=
 =?us-ascii?Q?SG7XKYD8etD+Y34PD6Qxm4jRqAxbe91+x1T0XOZl2tidIrC+IDg1oWFyNepw?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	G+5HZo0tUSjtKQFHUTMN2LUmV7Q8P4kjyG86oa63WXoyZfAbogzvZrrw+B1hg2PGC/1esOdQHLxW2euYGjt3gVAI5R92G5/sAYIZCCjcZyQ9TdeRc5EWN1ycFOFcGArCLvzBbkQfyJxFHxhybYkzVI3bWhxRX9qCSOnUc6o3nwpVx+Z+LD8vaYcyA0iEqKrwkkNaVRtK6rcpKTYnKen9iCOoeLrCLkVFtqzNLrUtuQ4DQ50bwXtlm7F+VMUpXMwXjxqzU81XjNtYzL+K/vvYOov0LQzsJE9UE/bt7d0728kgOwFm7TRH4mRZpyaEF/tvFsDmSzyLlrfIRQyXvoXmS3Hf/ffrijznlKC69dD2w0xyfifdhyNuaUHyrjbN3CfT1LbHgTr6Gtfo5M79JtyD2OyUvnZGW27tNZNmwI51dQY1ZpIwB4ZOjashgGs1VUoRI2vLY8AkT0ADMRc2BIk0yJkWhozfo78VrHfzPNrZoH22LAb/jYyri+Wq6xS3sAA2/GTfKYHD5GEnkjR3i9lGf6qb44NBAxg7l0Bs22bCwb0U84e6a1OxPoR+bX63leVk+cbU7sNXOUDd1JOM+XQ5r18sUufo3L9CvzOvhLW0VDg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ea46a3-f25f-4311-5acd-08dc8a8120d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 01:43:58.6553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22mJ0eddzjtJM4P9whB6F6GrnCESOfEg/LLekP2SqvA0jU/FEV7gT7/+oYfdy+VFM37GeMtUVsvSYS1eVfym50KRJMy7cgTYFYA4qngtOUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120010
X-Proofpoint-GUID: 2LGEzWghlCJKvnX1QjWM-BUen6-RxCVI
X-Proofpoint-ORIG-GUID: 2LGEzWghlCJKvnX1QjWM-BUen6-RxCVI


Hi Bart!

> Add support for overriding the UIC command timeout value with the
> newly created uic_cmd_timeout kernel module parameter. Default value
> is 500ms. Supported values range from 500ms to 2 seconds.
>
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>

You requested changes which means you are on the hook for a review...

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
