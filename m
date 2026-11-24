Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.166.238
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795533293;
	b=nDYQCXOqknyalG47pdh3lAWCnRNbz+rrkluTkQEuwTQwN7n8p5wizBnIVljgDxU/INtJ
	 68j+THwdvujIw2aopi67q8agNdiTMo2hPq7sn6ETgeue4XC28MH+GTCQh8WsRUqo7iBO3
	 UVYBjf/ZLomQJ8CKh1kJROiBevx86xo/HPLuEwt/JV6Te72Qxdn7h0dwtI242WLp9STmy
	 Am7ZXwLY5hNs/SRfDEFDFEA+FTP+20VyMtHz9iClWsrYDFCV+FnlwnzY2kumm7Juy49NT
	 9bL780mPcqZTITlssL2VVNBybCIz8HJ2of5fh0GWIqI3ivdkzsnLs1T6ry7iOhmiihA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533293;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SIFspOmt1MFonxdYM9R4LPrBxCiQm8tqEKc52zjTbAo=;
	b=topEOxcU+fWqTTwc8xdtpltKEzD9NoVfxNad6Rd1L+i84+vW6aqqkxT0jVLV3uxyCF5Y
	 VZnV2Zvka9JcJZfEgYEUI/qdMx0IEcrjP4yL/28BJIU95Tm7866iQBQks2jr7+abdtD92
	 7caxZ1eca6wHH7+J9FItITsVe8uQ6SrvtDzkJbmkhHmRSRE0PvOhfIY8w6cALkmzhZs/4
	 QG6ciuQzeXcjEP+m0kHZx7I9hea+Uzze8PWKqtt1YdcJXghqA570FRCWsICpE5jSpztsQ
	 Wh8ngxA6C7HNL5+QoOuVXY9bnb+2f0M/XM+wpwpYtuRVlRpFk2dYW9JLb8yUNiL/Q3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=windriver.com;
	spf=pass smtp.mailfrom=windriver.com;
	dkim=pass header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=GzU2UukE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.166.238
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7285A606A323;
	Tue, 24 Nov 2026 15:14:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7285A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=GzU2UukE
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOEcYco1106103;
	Tue, 24 Nov 2026 07:14:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=SIFspOmt1
	MFonxdYM9R4LPrBxCiQm8tqEKc52zjTbAo=; b=GzU2UukEhMtxWrcJdKewVuz9v
	y2HeYUhvTAMq0ghBRjVBOZzNoXy4uNYNfEyuvJszmQavOHunRzmYVXtM+jxdAjd6
	+i/i+N99HHWyB/zR18uQSPez8RRGnBfm+l7E/MRAMnhcCJvvdUK6l+UX7ewQYVl9
	V2q03YvVTQf2JGjMGkolQx2a1YQwKSp7XFy0L9jQ+JNF4G6UUNMK9MHYmiAtkEIU
	B6SdM+vmiIg4GHO8YwVFPB8xwI/LuijNopZheRR1ytiCut5rjq9S4EMUG4n/qcm8
	a8qT8v/Fw4RSB7D2zELvlcfOWJnsDDshTXG0LzxQmu1SJEiYqrf2kbTVdPeHQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023101.outbound.protection.outlook.com [40.93.201.101])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4j51d7s16u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 07:14:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HBTF1uT+9V2uSYnVecFWBjbgnbhWrc452RhdC7FJrQQ6R5JhUcrs05B7cZ5mgU82oYrQkY7OQS74J3ID/Ln5m4x+zCtSnVGPGAGeTSramoJ/lA85mfVq0a1iCHlRsGcYc+2PksX9zjxalmMu48VNklIKSwuqGWoPoZ8nqLbr0eT/RTu825lP6H7b1wxLY2PTTED+omvSl7yS2Qdmxv9vMU6FVcWNn8fQ6NDyu9NobpPsTCsAAWfopa5wdObikx9Rbwz3trr2YYmc1uK53pmElCTQ5hRCnHzdUJZHk11SftrUCTIb7DOJtxsT61P0lFGCjqYx8gaj7V5QqXoLbSsxrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIFspOmt1MFonxdYM9R4LPrBxCiQm8tqEKc52zjTbAo=;
 b=agFxd8+rVZW3Hu+wApH3b0kW8JMJYFResPcYvDOg3E2TzDqu7Ytegg4lj1Wn7Kv9Unpm8I40hWhdzK63d1OD/2I3dmYIdb+pGzy3lAWZ5+mD8kfQcoSCWoV9id3iBWywI05IjGeahXYqyG6HOyIiGM/I1Hj06uX1WNNbXZ0XWv1cU6adSPIRWiEQKWJgpArWOqa1d1CHSC+JNVKuYPMvDFiH1mbOuEMtE6CbC/wu44TgysolOdjjUe+agUetwGjq+fUuS2hY4yyy8gDPDvnb3wEhv8qKphIPoldT+YZAxJgFvsFjDuYew7c3PgSjy0Ono/26cxo/SI7/sDS8kFVyxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 15:14:30 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0639.010; Tue, 24 Nov 2026
 15:14:29 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ionut_n2001@yahoo.com, sunlightlinux@gmail.com,
        Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v2 0/2] scsi: megaraid_sas: fix JBOD I/O hang in kdump
Date: Tue, 24 Nov 2026 17:14:08 +0200
Message-ID: <20261124151410.43279-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIVP296CA0113.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:358::6) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 7534ddb7-6fd2-44cd-1a29-08df4a3da27e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|23010399003|7416014|366016|376014|1800799024|6133799003|18002099003|56012099006|11063799006|261026140227099003|261026121527099003|261028144727099003|261021123027099003|261009223027099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|38350700014|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ajoy4niYN0kxzdIhUWR+V1binKW06R4KnE2EOYdPFLQHh/GCrF+kBQBVI3upVz+3phtVcqlgtpfmQbk4Pp6nKVxm/B3deX25NLQskIVVTBsfOVQjYDW/O4HLkg5nduVMMywDNmzo047mpbA+WwOid9bDkPbTbf0PeL92oEGyIzJGaTa9mlRdTnVUAl1RJ9jaPDko6jU9bu7vDx0qdTeKqqeqcVkNDTFaymQ+yQKtl1eBgdPAsYai4b6Uz5J36XMK+kDGowY+rrNgDWL4WepmWk3KreVRlfD4v0/Vm+RA/heKW9vGVLfzcC7e0b46d4mjh1CPichw0B6kauFLykl1IS1Tb9q9MCn1VJh5+AaLYOmr5okAse6RMpBE2jsLz2r7wJ07VOJSnIAxyUUnr6HlqYyCVp2uZYIXoGggth5z2RA+6kbSArlkK6LRwDmoiICvpveCPYKozExVEOTXnEPLORGGAkipWnQ5aRF6WDDhbCOXG6WI9Z+OWzqnzoA/boY3/FXUak9awOOknEBT1Prr0zRTBc7EZthRJHJWEok5oDEjs2g90PIsMaYK4m7NAtUNodm9byAa1BGqP76o726MdrWw0YjQ9wdtR9gu34HnuoM2vytF7GgjR7djx7ulnNQQrZ19jEzqMjJCMT0bg1hvYMsu5RBBA5KKSp2LFQsA+HM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(23010399003)(7416014)(366016)(376014)(1800799024)(6133799003)(18002099003)(56012099006)(11063799006)(261026140227099003)(261026121527099003)(261028144727099003)(261021123027099003)(261009223027099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(38350700014)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0lB3dWrefNh6IjxAy1JPNG3FA9me2drjm20td1Yg/Ja5q5aiikZmu4MScAEw?=
 =?us-ascii?Q?Mdli1Zmpn7Ei5GVIERxCL65ipPkbG2n1s6JKhKWrdHKwZ90CUhyx/RRwIUkG?=
 =?us-ascii?Q?uzWfN7tVKZ0NGJfuJVpKyk6gzgC4MhQIuQqY5wlvxQCt1Yc2u/arhKC5n8kG?=
 =?us-ascii?Q?2lM49KIJfSOqa32UWWp6I1W8Z6q090FlpEXxCpEHxwRVcEUHYywYX/xxuNpp?=
 =?us-ascii?Q?APSXdl1dW7VYDRc7WMt4fOgjrtRYQ22dIyjGNsDUo+4pxeQSpjV1KkTj1uSV?=
 =?us-ascii?Q?1nbusWgaROXPUEpbYDLTMwZVUr1E9tUf19vZFwF0seSOcVlmNZWB3f1CtXCU?=
 =?us-ascii?Q?lg+DT2SG6PepyTHp66qlEhoqodehDhIwK9ixTsTYNfC95+U2flI+t6FFMUqd?=
 =?us-ascii?Q?XtqkQd+vFITa4SVI8uti+LozxTKfr/zkDshhNrjtBYy6YUlutXmNTn5t6+P8?=
 =?us-ascii?Q?xHv65rT0R9UrNOOpAK8Bt2bw4znwAWufoTqqo1AzzzGLOaJ+l7Wyonyjcnxw?=
 =?us-ascii?Q?HPO0jmkAB/2WSpKYpHy7XzLq7USJga3UT7S+g03mDi9ciN8hqMQHm22RVmfq?=
 =?us-ascii?Q?FMPpcKkgjLiM9JsIr4cR19chLK5am3r0/uv+S/XYU0hMhya4eUKV5XUGOIZY?=
 =?us-ascii?Q?arENjHd64xXZgiaOKnbHMseuqeFn1rXEX6Vz1e6q7BwN6WkPlCfa0GnbB/Gm?=
 =?us-ascii?Q?BfyJF2Odv5xixl2/+kfh1Z+NzCCiyX6LFZeHf41IofZvjUJy1v3Aa9dE2Yq0?=
 =?us-ascii?Q?c2ndVRjq1LmARU5rq2VtmrOozHdttMwKHsm7+h017mrsuuJz2KuV4/d2Yqud?=
 =?us-ascii?Q?BvZb60pAsV3ekLgHiUW+g4z0NukNSaboc+02vetKCqtY9dI9O37iVvCcl/sz?=
 =?us-ascii?Q?qJ2cpRk2TUsZEhiyDD6moVez2iBv3R6J2Wke5AL1R6oS/rR0zdgn2ZS0tNmM?=
 =?us-ascii?Q?kmLvtgddlTy6jxXHeKTeX4Cfjj/MhXkwIvsNqpQIBe3Z62lxXh5bdn/iPJKU?=
 =?us-ascii?Q?8H3TRLE0H83pzw/CdwpByhlkygGgWmsHvpatm3+Ab/RBNfChogYHrnfnuqEY?=
 =?us-ascii?Q?S9352Oq9UXPXRSiSpsx6gxqyYCx0CCw0uTESrDvwpRuhu06BRkGd0moUnkmy?=
 =?us-ascii?Q?KEPGjEwaIn8gb+26+SO/FYToyHs3X2dmaNHLo6eICGj2Isvn5fK/V+wCRvZy?=
 =?us-ascii?Q?vlKD8k2T6YVDI+lwqA9qE51ljwUgHb4lyth70LUEwuI6KOfPygp/uBMKJ716?=
 =?us-ascii?Q?IidJX4IscxIqTvtBhMoSt7ljHqAk2/jP4eMh4B3uQ2Wu8+OytpJIdi6l2deL?=
 =?us-ascii?Q?tB6iec5l+kje+/czDB5kwFBrKt3w08QeCkUcMwy7/xufupwa63n609kPUL/5?=
 =?us-ascii?Q?stF36ysdrC6IrnSyt2IcQAZ7dMFX9sJ4+RbGIVkypylRAQj/Op7L39nNMEVt?=
 =?us-ascii?Q?/62UO/BGyAX/loVdxgVBSxFd2rrP6EBLpNuXLFu6q/WdCVWD9eU2IEt53U+N?=
 =?us-ascii?Q?OD5aOVc2LXTbd8AQX1epD68VobTpc7E1pirRyJWMLb8ToCLDpuKu2awNLrSu?=
 =?us-ascii?Q?LstgltcyhHXTbuvODNaudd6wrKbEfrvCPVFv7xmIrcswOGeqkOoc5JPDKrRb?=
 =?us-ascii?Q?3YJi8SVCd9GiT5brSi9lVuOfLlucCigTddJj9aj6a6ptnZFrafHkruNk9wmZ?=
 =?us-ascii?Q?TjcgmO+/dmz0Dl/r82/dMpP9DolP527GSEE5z4Aen+CFhCRZ1uWjnNjwdpiH?=
 =?us-ascii?Q?jM1Iia4ct1yM4rSewxtfKyFW/7JL6LA=3D?=
X-Exchange-RoutingPolicyChecked:
	Gd5ncq+wK/Z2aDSvl4J73PTgPKkABB8QgfVCjRNdxApgE1U3nP/7eWp1IGfTdEbMvUXW8Ssu+ZeKgJfb8J0ts9AcjVyh8uReGf/BWuT3G5cg8vEzNGp77Oe0j3DyikUHNLhE8J+Akja8QAp1wcsuvCtc5hs9I3XEov1OKfXFsjFgFR0JF+FgQGrFoiqD66AGTenPBiF4TLNoN7SINKqqW2VUuIyQaZDRYM8dOC2R0Z10PX+h+p46QE+nJQpF4pRnCHBFGX8ZTZMQjgL/E7uKBp41u43DM/r0ioQHK6HdZJcYAwlMWGWeYD/rUc+OpshADIq2JRL/dXWubhu/FXz+3g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7534ddb7-6fd2-44cd-1a29-08df4a3da27e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 15:14:29.2683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //usRHUpFm9HmLNDOP6cyzSJi+DuGexyrGDrtMNQTf3JHzgQzuOB9vvXq9DkHU98HeYhLHLT9urm5ei/Gn1AQ4hzf9vjSbqwUld/Nr484D0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-Proofpoint-ORIG-GUID: SngoMedOiK_iamciQKmTwruvG-oJ4agu
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA1OSBTYWx0ZWRfXw33+jcD6puux
 Ggs9jj3dYFIlsByXm2VP6+eq92xz5hx2gxWjN2eexaIY1jbL1GdXszT1T4ZVdeSlcQGpgnqVzWh
 F1d2DCQAqCmkurphuQyRzA/BY2RQrZZ6/M9ME3EwW6lNYWyFjmqr
X-Authority-Analysis: v=2.4 cv=GZOCDgXL c=1 sm=1 tr=0 ts=6b05a9db cx=c_pps
 a=S0CpYmVZ9TPoM0rEAH/1JQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=dMIPY1Nux5oDNjqvqqYA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA1OSBTYWx0ZWRfXz3J5SxDk2GKq
 keN1Edjj1WRjVrHRriM5sTKJFjRKdDjRRmnXcViuw0AdC0UC+xO2fyKLhkWmGMEXNZx6wcLbTZq
 RPOO1Bgy5F0eSGbr8KIi5LfOXtKcP4WTmYP1Dkbxt9eIZIf5g4137Cs1IBV2gxzbnVGD3B40qF9
 RGSpuBNPkZpYFIlo4M9+d1rfR3EYpbnPqZgdkoO6ZiX6ighT3y9MWE5VXvRIIW8K2s0yRiNFHhd
 iMZn7dLkEPxhAVd+EXyTaP+KTwpG8kgoqahj0sViKp0RI0swFLUjw5Dyyv2mZTDTqlOJlD7cLAk
 aGMqIKP0rD6W7myxBiRXsidetQVQ/77NyqSD6VbXPbblONnOXlKZlcSDPLowL+C5RRNBcTEpDDz
 OfY9/4+tY/wUnJRxTru5FzMH66JFPlEr8XJ7OSvTawL4r5Mkth4EtAeSDgAOWLxBMl2m+GATWnG
 jY8nNx9Iusw2O5xvbmg==
X-Proofpoint-GUID: SngoMedOiK_iamciQKmTwruvG-oJ4agu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_03,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240059

From: Ionut Nechita <ionut.nechita@windriver.com>

On a MegaRAID SAS3508 with SATA drives in JBOD mode, a kdump kernel
(reset_devices) hangs forever reading the dump target: every READ to the
JBOD drives completes with MFI_STAT_SCSI_DONE_WITH_ERROR (0x2d), GOOD
status and no data, and the SCSI midlayer requeues it without limit.

Patch 1 makes such completions consume a retry, so the I/O fails after
cmd->allowed attempts instead of looping. It is a defensive fix and also
covers the hung tasks reported on production systems with the same
firmware status.

Patch 2 fixes the cause in the kdump case. With reset_devices the driver
disables the JBOD sequence map, has no device handle for the drives, and
still sends READ/WRITE down the fast path with DevHandle 0xFFFF. The
controller terminal log shows the firmware rejecting each of them with
"Out of range devHandle ffff". Patch 2 sends such I/O down the firmware
path instead.

The analysis was done on an Intel S2600WFQ with SAS3508 (FW 5.020.00-0838)
and two Intel SSDSC2KB96 SATA SSDs in JBOD, on a 6.18-rt based kernel:
the kdump kernel loops as described, and dropping reset_devices (so the
sequence map is used) lets the dump complete. The two patches are
build-tested (W=1) on next-20261123; they have not been runtime-tested
in the kdump kernel yet.

v1: https://lore.kernel.org/all/20260208180603.568353-2-sunlightlinux@gmail.com/

Ionut Nechita (2):
  scsi: megaraid_sas: retry zero-byte DONE_WITH_ERROR with GOOD status
  scsi: megaraid_sas: don't use the fast path for system PDs without a
    device handle

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 30 ++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

-- 
2.55.0

