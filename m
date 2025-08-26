Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49B224CEE8;
	Tue, 26 Aug 2025 01:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756173229; cv=fail; b=Jt7woByS+g0opzTpKMY18jZOirLbopsemPQmp8FwYm0w1Ku4BmeujI4SEYykTDZqWpKjf1oCYwHd5qIBMKeMu3Fn37XHXUsIPS+4IZvRRu61jdy9B1L2xY+ZunPdPV1VCtn+317G9SQ/sjz+FGu2eky1Rx2ec3hf/jEg8tRRWZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756173229; c=relaxed/simple;
	bh=oyKS0JLt2jM9PypZW9nOuU3AmGAGfM7dYU+E6ExWL9Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mJ52tOf3nFyQsyXDD8JI3PYD5Y7ikb+frMbfcqO/mb6McwGyX26nAT0/X6VJJsVj7haQe6rIlxzLKzcG9sgMhlWOqf/jbXwYWSfUK27FM9iYEU3HChcZJLCyMesd2Nl8HCQ/1lwo/qayixOEJKSiX48+wZWFzZ5TrLczT60p7EU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SWsSkEVF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gRPq/AuI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SWsSkEVF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gRPq/AuI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1mQ2C005056;
	Tue, 26 Aug 2025 01:53:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TqNgNaTKD/oVw2gyWs
	sWzMh3TmOo7IpsJAY507gDCqQ=; b=SWsSkEVF015dtE5udYM7+GvNpVKlj3cqTz
	UVNU+aOGBxcSgQrSxeHwVakJ9kxYaUCoPJrcNGMqVMVU7s63kCK1Hs0nK1JsBveS
	teSOCngcP6VstjsgGBRgEW50nbEetyXdASnxYcyP6d4XMh5ajPaavWxUTWc314SH
	jIb3QKVUgxs9Drsd2vzPUvF9u0nKUH+yADOTp5crh/M0Z1VuPP7em7uaUIPx/0KW
	GC76tqRqJCI3/pTfQbb8I1gSsXO9E/5gg5jQFrz9v2BOf8DNAFBhpATVpLxnZp+f
	thgfo6dWmS1DjuCTNPJQN+d4Sq3iWegd6eST1a9t8AZMwDEEiBHQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jakdh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 01:53:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1CwbV027303;
	Tue, 26 Aug 2025 01:53:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q438v2hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 01:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wn0oygfHh4mICm4Ix4Uptosf213E5pHEYLZRnRqamxSQFqwGxxxsa+kUJIQbOBVUibJva0Tk4krjiKKO3cewI0KR0P2ds5EjYvIwc1iRKo6dLTIoUHxYtxFUwgiOeJh4KHZBdvKZ6QjTjElj0BY4kSCbq90KAPf2DO34cgtvjaEayiXpVe4w77mpHGzTbGeTJGWWUSdbwswghc4/jQzSQdkZQUAdJJDObsnY4NivNIgGBH7NBQ3tc9SLg+t+MJRzxLfHaN9u+OZ//rYBwjlwwl/LrcM4RKTB4LcawsqpbVkLqwf6rCp30DkHp28cQHw6h0IVp3HqIwcCpg/7wk152A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqNgNaTKD/oVw2gyWssWzMh3TmOo7IpsJAY507gDCqQ=;
 b=xIgEUd9ecfjvLkXwr0DhIwUra7e4KQDdirx6ltmmRsmty0v44Q9BvVkTQM/uUMoY4otGgwbD57sk+xhD6ZIBPFRSrcggXw8LP18G16Zql6fD38PTtznp2uEb5il5cvYhW0goRZIDagtVv4wUZoKogUVk2zOQ4nvvP4EmHiP1bqMzDfoJ68v6waDElxMc0NPUiVGVG9FClCLeR325sQvS8VUcDMH6ekpaEixDTRnoRKWkXATGd6KDITKr1a+ceh7ARPlswhQkAoN/Fypo/9xG7Ap4m/79yoIxJ7TtprgrpuxGWiTvFh7YTqeJKYq/KPY8fyCqgvm4RdRTz7TVq6Scrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqNgNaTKD/oVw2gyWssWzMh3TmOo7IpsJAY507gDCqQ=;
 b=gRPq/AuIP2JkgIcHRIifoNNhhEG5pezb0B7DSAVD1OSh1Qdq2z4PsLfs2a1R8bC/dWmH9KBx3cuwsY67whuFUsDn/HzDM418+cYOFGPUEHMDdCmOiy1NaHDtHRpLa/oLHjLJKsNULKsco1oRHcHpLuJqpfmWqaqIMgF8nNwmj3Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4204.namprd10.prod.outlook.com (2603:10b6:5:221::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 01:53:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Tue, 26 Aug 2025
 01:53:24 +0000
To: James Smart <james.smart@broadcom.com>,
        Justin Tee
 <justin.tee@broadcom.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Hannes Reinecke
 <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: fc: Avoid -Wflex-array-member-not-at-end
 warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aJtMETERd-geyP1q@kspp> (Gustavo A. R. Silva's message of "Tue,
	12 Aug 2025 23:13:37 +0900")
Organization: Oracle Corporation
Message-ID: <yq1seheonya.fsf@ca-mkp.ca.oracle.com>
References: <aJtMETERd-geyP1q@kspp>
Date: Mon, 25 Aug 2025 21:53:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0160.namprd05.prod.outlook.com
 (2603:10b6:a03:339::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4204:EE_
X-MS-Office365-Filtering-Correlation-Id: 3413ccab-4f12-43e9-c37c-08dde4435780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YfgwpMH3v8MiSPcdtejSfeqOQ3lU4E3Abf5bWnXsujmdcSg/KXycxtjpspr5?=
 =?us-ascii?Q?pUbDlzj15EVT03Iy0HN/1Z0fIpTb6lchcms/7GP5jyYnBwH/u1JBEkg3cIg6?=
 =?us-ascii?Q?ON9Pj1uz45UQNxe1VO+zIwvNDUqZuWNFgCEGRxu1jbI8Q6x0HpCnhNPUVIWm?=
 =?us-ascii?Q?v5LNMlDG2qPklBUJiiMKaPK/MLpDDnNV9qEjqgPn1QOx1kEwfgC+kCKannfb?=
 =?us-ascii?Q?2s+s5A7zM5x0BLcNB5hTO4szn/i1bsFy34qm0NyVqp09xX6rdvshX2/2SgGZ?=
 =?us-ascii?Q?soMViQO+2dkTX2Rfw2rM7UyKTHePJN9WbC57y81BMinj3Yg+/mUHq9nM4qKZ?=
 =?us-ascii?Q?NWzkIXLlyEUSfQgriGr+zpjXmp0QLoHbjMzMmZAlXDiPJFPy/s43ohwhC/mi?=
 =?us-ascii?Q?sS9Fdu7qJDHVK8jbfVLxfbmk8F/ybGAitvDIybZN0t1OkXxj1T5iWRFHtbAy?=
 =?us-ascii?Q?TwGB1NIsnHAecmIlcCcjXxvzSu+0IF/9yczkBWYZd9I9/GuKOapyadf2UpJz?=
 =?us-ascii?Q?h4ueGJ2sg9EXoQQFSL9eajfFgWk/UEB4b+1q83TthKluos8AwKI52jy83+LA?=
 =?us-ascii?Q?6mh6ula0d7VeH3sAeeci0hKf9joum3p9RRQmqMoqCEh4wMF9zHZPuQ25vYk+?=
 =?us-ascii?Q?joDxTLPfTbnsLMbT8lMRw4NxOoV8vfqeGlIuQxQpoonzek1RVtWWBZjhqpeu?=
 =?us-ascii?Q?wahE0ncyftsMg05iMPngLEPChHOvQU/nOFj64jGo0Ncdv/UCaUEm1TYaBcsb?=
 =?us-ascii?Q?oH5Cm94fv8sHu0slshlwaDcjYlmEmzFzn6PsPQRUOHx9dECRy/O0rqqpW6eS?=
 =?us-ascii?Q?jo6dFBfZl5046iBXtJcw9s5iXAf2oyyrBJ9mPKFs9cmmCPG7nlc1BEhR2jYR?=
 =?us-ascii?Q?OTq7e5K/gwn4Jnl0K2nhaG/prs4IoFW76SqbNTCTrh/+dwuwh6yNt5PeE2ep?=
 =?us-ascii?Q?1TODb81qUrh14n875zYXDrT376wdlJjuCPJyC4qfZkvUk0hG1BqjmmOhOBUO?=
 =?us-ascii?Q?G5a6yrxxkE7774EnMISxAeAVj+VR8guijJF3H2SptvCta8aqvTKc9pEoR5fl?=
 =?us-ascii?Q?hrT++hAPg/z9YX0nlXUeYklidHxmVun7anLpVjZ9yF8b5PlHsR+FyztdoMHA?=
 =?us-ascii?Q?OqbOt7vsFpDsmcHo0nUj+9epxllZrkqLH86yqTY0cPqIRh7WYgS9w6iVd0++?=
 =?us-ascii?Q?BrG0Q00QHdxFodithwJ8BC0vY5NdvKGxzc/t8KE3sqeGZY/r0gzGEdQ3bnSE?=
 =?us-ascii?Q?+/nC54h3wVoOZSl/9Yn6KqGeLdz977mtCbnlGn6ruQfjzegqyXlSPj2yKKKQ?=
 =?us-ascii?Q?EJf0ybRB0PEWmfAKxOZ20D2HstHfVY9Rk4KvbXiCJ7Ru8u4Q6po7Fg8cF0u/?=
 =?us-ascii?Q?NKI+3E0zOxH+gn6EblSDDExRQs5HCcM4rF1LQYe7nBZGJadYP6PtMQAuYAsl?=
 =?us-ascii?Q?fL2akryz+C8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lqiEo7EG/ME1XLfLAffAxS7PJECzzahBWIpnRgppTupDCt7rEPqW+/XS+S+K?=
 =?us-ascii?Q?7SOuTyEYxvvFPvZ+wqpXTQVi3cDZ5c1Q8DJNJHtNSaUl5d0SW9Enz1Ys36LI?=
 =?us-ascii?Q?kYj9qUxnLTASbygZxGADNvehp8Nb0wDRsTEoxERKovmUqJoVLGXVt+5VCKiR?=
 =?us-ascii?Q?EaJUBXvVG/lZkak6+c0ZMD53tcSZiPsig96fnaWew3QQcjKSsRah4ZQTNScJ?=
 =?us-ascii?Q?IhzH+LKOHeYJGGqnW5seAGdnojIN9wx1uCnIUvn/5VUs+oqUIGJqhEjetOyF?=
 =?us-ascii?Q?oaQiQJUsgaSkKxtPF/eh1fltxIpWdJxkjjMZTHQOSjn/I1NBHNvRp6r0N8C/?=
 =?us-ascii?Q?rwklGmpPUAX9RA1rSAIV+sMpQ1Dv40lH1alWYYsRfxBh5Rc+YOki+5A0xr2b?=
 =?us-ascii?Q?epOk+2g0//EpidGIB51l0cI081wtOJGfc6zA19WKFVRiKZdGH/MEGDcaGwxX?=
 =?us-ascii?Q?i2utt5xY0mkyS1vZFX9fOO7vjAEdxxiAMatIZdTTi0Yu+hxvLvdeWpwFmEIR?=
 =?us-ascii?Q?Iocv82PD0kqSFt1JDV4SInAHVOoS94ha8zRPZ5H9gIEXiQULOPxOFqieOH29?=
 =?us-ascii?Q?91tDP7iUXSF+Zxiq8TIPyPUvmJYoD2+/QgCLJ5/yRZteK+q4oUfpqTJB5ZTK?=
 =?us-ascii?Q?ZCrlQOpR/MpwpTI7ND9qfL/Avq/z6Y0q8euFVCo1Z2i2QwBgHjh357LHD1Oe?=
 =?us-ascii?Q?TnXzfnHswFoyxsbFUF+n7sQQRM2zjsBphEGBZBWvVfB+C1Q2gAlwzGxV2nvW?=
 =?us-ascii?Q?ag1iq8RnzPHHeAEyaVB86fhCWRHslWI0ywr+szKCA4q4Wo20sjjRPUD4Pkth?=
 =?us-ascii?Q?fK1Pk8oHYooI2tPHfEdogV+ijHvosDCMulX+TDC32PyGYuVslsicqz4lcN9T?=
 =?us-ascii?Q?8onxQoBoXZOsczTXrseZboum3MKyrmKGMeoWI0yI091w1KOnxkXfc4m/B9Gx?=
 =?us-ascii?Q?0V+PuJagWw7q0lcdhs37lAR30fnGktJMLxh2Il+QTtuN/th9wksgGMClmWxq?=
 =?us-ascii?Q?kCldiVqzb6/x8T3Z+JUORa4eiP27iuOb036QRFWAH2B6dIPp4oiCRPJHQzYp?=
 =?us-ascii?Q?uV1KtSsTuVcC2D2xVynWWZcqsG2gFAsEje83H6Q5khoEcdkF/EpUW3FGOO7k?=
 =?us-ascii?Q?Zi9bgXb64Xb4973SFpsU64MdG2yyruLJy4nf+164EyCg1S3zlrKVpl/aLUCW?=
 =?us-ascii?Q?FocMcYPp3XmxE9m1C6OFq+Ggai4JNjlsiCOEuS4fTzBFS1NYIYM2m8PlvRcf?=
 =?us-ascii?Q?6sWZO3eZNg2dxUtarjuYmvO0iSGxZF89Qqu9VtKM5NL7HmlvWaMEz5Cqhzyp?=
 =?us-ascii?Q?7Ru/t6dCEMEWkv4GJ1ihjlkriELbYlIr/kP7S9fYg73LyfffWJfA42df4KIe?=
 =?us-ascii?Q?aKzsDRYTXYKdtdri5ate+5peprJ9eFe9YzfdBXO8goITwkvMEi1uQx4sBrqV?=
 =?us-ascii?Q?3sBXBIPtC4NupnMz87PvDW9QAggnUSrQhaHs3Nj5l67ixXXvNC2SyWblSJ0Q?=
 =?us-ascii?Q?d2NQRIoccu0L8qqlF827G3jmU9ZhM+tcLvRdzxWsTrvBnNCDh2Ny3nE6R79t?=
 =?us-ascii?Q?veQUOEp3allVfsyZTXXvUcMTEDz3IKZnOpawaE14kjgYl72UR4DEjg3PtFp4?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gWlJSjGRcdjt2ffJE2/tWUwfuErKs8O9wajRNyNCq5rV6OJj9GVyjtxYC6REnmfHfBDSCRZEWazjlcX0TWc1vambdhz0ZYFinJyedVyU9HBP0l3dKUznGNBiBhQI7dWBaUfhYAmbOQXgqACORImwegW9I84w+Y8Omzy0FZ2UYCIWWdRbXLQalLIo1cUm/hm3pdLGXDbuHqLWW2LVSssFHEd3V8EMRBt/oDQHDUMTl6ZyGvLo8XROAhTVlXyIFAm6AHwLQtOh2z8rQkDXukZnEN7FIcPGNM2bGrK3M+IY6+SlPgehVp9LycZZRfAxe0YPiQ5A5El2gyJwQsqEXRBj7+yUint3ubGJKi6dijZLgYLIgzvU5J7WPTJcxGYqvtScZ6lsqpsoc5cu+6bqShRrWA7tMgcuOJ1AuvBTbk+qCwo5mpdcEzWs4yIJnmnrjti4hYMpd5EtYhavRAm2RzGlCkCcMvVzGCOVXJLJ8uRwnOpH2nWn4DYfnaayiEPCY+w5p0rKVzSNXZPeEpGCRTo6f9+qbyNcK1lrfIeZcVEgTrnKkwxX0saNjmo2K0TJYmNnZcUEFA8TWi0/t2vlwEKx/8lVAIt1hXDXfRIPkQhMQk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3413ccab-4f12-43e9-c37c-08dde4435780
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 01:53:23.9968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLLZLS7nTM1TFi18NF6SBJUrU1yxgHKGODN/H7pivWISHIJ44+D+6Z5XUmJ9MayPNABtTH38RDhO4lbEbmlt6cR82bSS0uSItudU+BXcASM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX8dvF0OKxojr3
 dkJ8D8qIq1DjcI6E4pdJo7u9v7X4sD4vfUuoU+swqTS3Ho69U2ugBgX2NTWSMO1DH4E0u3OujLF
 jGUf9yG3rqvWDz1zCtuPA8mLmJY2qBIppnGxUUnFOQcjRnCa+WX475oG2sdwvrk/o3clB+44kgc
 D6qgOlD1O2dJaJxP1gWWzGnyWKJsbKs7faUv7aPOeC8pySiJ5JWDWEfuEz/IVY35oWtqr6bM/tg
 95HPpLnaGa066WzLQqaRP4Nz6zKfWQIwbnxbMXwYBCeGFx4pfJdHg7v5oQOkdw4bNplUXubTPSE
 4c7W6OPszJ5QEkbhghqe4f9lqle81vCIYcTtyYpen5TRCMm+W6Kkf4t//UnVdhf3sUskxK66x8l
 DZQIkoGG
X-Proofpoint-GUID: BDS2u9LL3ibniasBAYqHRIXJHjSW-WM7
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68ad13a5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7u5YYgFkfBPbUuzG0M8A:9
X-Proofpoint-ORIG-GUID: BDS2u9LL3ibniasBAYqHRIXJHjSW-WM7


James & Justin,

Please help review Gustavo's patch.

I also noticed that Justin is not listed as lpfc maintainer. Please
submit patch. Thanks!

> -Wflex-array-member-not-at-end has been introduced in GCC-14, and we
> are getting ready to enable it, globally.
>
> So, in order to avoid ending up with a flexible-array member in the
> middle of multiple other structs, we use the `__struct_group()`
> helper to create a new tagged `struct fc_df_desc_fpin_reg_hdr`.
> This structure groups together all the members of the flexible
> `struct fc_df_desc_fpin_reg` except the flexible array.
>
> As a result, the array is effectively separated from the rest of the
> members without modifying the memory layout of the flexible structure.
> We then change the type of the middle struct members currently causing
> trouble from `struct fc_df_desc_fpin_reg` to `struct
> fc_df_desc_fpin_reg_hdr`.
>
> We also want to ensure that in case new members need to be added to the
> flexible structure, they are always included within the newly created
> tagged struct. For this, we use `_Static_assert()`. This ensures that
> the memory layout for both the flexible structure and the new tagged
> struct is the same after any changes.
>
> This approach avoids having to implement `struct fc_df_desc_fpin_reg_hdr`
> as a completely separate structure, thus preventing having to maintain
> two independent but basically identical structures, closing the door
> to potential bugs in the future.
>
> The above is also done for flexible `struct fc_els_rdf`.
>
> So, with these changes, fix the following warnings:
> drivers/scsi/lpfc/lpfc_hw4.h:4936:41: warning: structure containing a
> flexible array member is not at the end of another structure
> [-Wflex-array-member-not-at-end]
> drivers/scsi/lpfc/lpfc_hw4.h:4942:41: warning: structure containing a
> flexible array member is not at the end of another structure
> [-Wflex-array-member-not-at-end]
> drivers/scsi/lpfc/lpfc_hw4.h:4947:41: warning: structure containing a
> flexible array member is not at the end of another structure
> [-Wflex-array-member-not-at-end]
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/scsi/lpfc/lpfc_hw4.h  |  4 ++--
>  include/uapi/scsi/fc/fc_els.h | 40 ++++++++++++++++++++++++-----------
>  2 files changed, 30 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index dcd7204d4eec..e319858c88ba 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -4909,13 +4909,13 @@ struct send_frame_wqe {
>  
>  #define ELS_RDF_REG_TAG_CNT		4
>  struct lpfc_els_rdf_reg_desc {
> -	struct fc_df_desc_fpin_reg	reg_desc;	/* descriptor header */
> +	struct fc_df_desc_fpin_reg_hdr	reg_desc;	/* descriptor header */
>  	__be32				desc_tags[ELS_RDF_REG_TAG_CNT];
>  							/* tags in reg_desc */
>  };
>  
>  struct lpfc_els_rdf_req {
> -	struct fc_els_rdf		rdf;	   /* hdr up to descriptors */
> +	struct fc_els_rdf_hdr		rdf;	   /* hdr up to descriptors */
>  	struct lpfc_els_rdf_reg_desc	reg_d1;	/* 1st descriptor */
>  };
>  
> diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
> index 16782c360de3..81b9f87943f4 100644
> --- a/include/uapi/scsi/fc/fc_els.h
> +++ b/include/uapi/scsi/fc/fc_els.h
> @@ -11,6 +11,12 @@
>  #include <linux/types.h>
>  #include <asm/byteorder.h>
>  
> +#ifdef __KERNEL__
> +#include <linux/stddef.h>	/* for offsetof */
> +#else
> +#include <stddef.h>		/* for offsetof */
> +#endif
> +
>  /*
>   * Fibre Channel Switch - Enhanced Link Services definitions.
>   * From T11 FC-LS Rev 1.2 June 7, 2005.
> @@ -1109,12 +1115,15 @@ struct fc_els_fpin {
>  
>  /* Diagnostic Function Descriptor - FPIN Registration */
>  struct fc_df_desc_fpin_reg {
> -	__be32		desc_tag;	/* FPIN Registration (0x00030001) */
> -	__be32		desc_len;	/* Length of Descriptor (in bytes).
> -					 * Size of descriptor excluding
> -					 * desc_tag and desc_len fields.
> -					 */
> -	__be32		count;		/* Number of desc_tags elements */
> +	/* New members MUST be added within the __struct_group() macro below. */
> +	__struct_group(fc_df_desc_fpin_reg_hdr, hdr, /* no attrs */,
> +		__be32		desc_tag; /* FPIN Registration (0x00030001) */
> +		__be32		desc_len; /* Length of Descriptor (in bytes).
> +					   * Size of descriptor excluding
> +					   * desc_tag and desc_len fields.
> +					   */
> +		__be32		count;	  /* Number of desc_tags elements */
> +	);
>  	__be32		desc_tags[];	/* Array of Descriptor Tags.
>  					 * Each tag indicates a function
>  					 * supported by the N_Port (request)
> @@ -1124,19 +1133,26 @@ struct fc_df_desc_fpin_reg {
>  					 * See ELS_FN_DTAG_xxx for tag values.
>  					 */
>  };
> +_Static_assert(offsetof(struct fc_df_desc_fpin_reg, desc_tags) == sizeof(struct fc_df_desc_fpin_reg_hdr),
> +	      "struct member likely outside of __struct_group()");
>  
>  /*
>   * ELS_RDF - Register Diagnostic Functions
>   */
>  struct fc_els_rdf {
> -	__u8		fpin_cmd;	/* command (0x19) */
> -	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
> -	__be32		desc_len;	/* Length of Descriptor List (in bytes).
> -					 * Size of ELS excluding fpin_cmd,
> -					 * fpin_zero and desc_len fields.
> -					 */
> +	/* New members MUST be added within the __struct_group() macro below. */
> +	__struct_group(fc_els_rdf_hdr, hdr, /* no attrs */,
> +		__u8		fpin_cmd;	/* command (0x19) */
> +		__u8		fpin_zero[3];	/* specified as zero - part of cmd */
> +		__be32		desc_len;	/* Length of Descriptor List (in bytes).
> +						 * Size of ELS excluding fpin_cmd,
> +						 * fpin_zero and desc_len fields.
> +						 */
> +	);
>  	struct fc_tlv_desc	desc[];	/* Descriptor list */
>  };
> +_Static_assert(offsetof(struct fc_els_rdf, desc) == sizeof(struct fc_els_rdf_hdr),
> +	       "struct member likely outside of __struct_group()");
>  
>  /*
>   * ELS RDF LS_ACC Response.

-- 
Martin K. Petersen
