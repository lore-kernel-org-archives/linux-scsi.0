Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204717C092;
	Mon,  8 Apr 2024 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583989; cv=fail; b=UUAKnqyAVaEito7wagN5c28zD+PhqU6Bclvy2gwUpmhlHVcN6gklskmBM8IKUswGU1CylrI6/2RbBmz8yry3477/wp+XihSlt+jX/bovf5CJ7cq1VeWkDjzdHvWMLFxGQ8T65+vKHwAJjjCyaJ672L/jIxgNo6Bxzl+HEQQvM6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583989; c=relaxed/simple;
	bh=UYn/JMPbpNV5/3ES2RjaMBoPPVWEfRZtHTGlbtesCho=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oBb+W5n/65EqgrpxQ7yRgSrOHQxeGVXiEwPhVD96AJ1ve6T9nIZQ+14rk9IFtuYOLc+zi3HSuLcN4o4OIYAM+ACBuw90mZKlPsvN1jmhsCsn47Bn+kjzsX9iwnU7y8GfQxz7x45yvooaYto/BPNgBkK8SQyQPV/K1ykIPX8g/6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rhv2c2n6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GSKbf8C/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rhv2c2n6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GSKbf8C/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4386ZsxK003868;
	Mon, 8 Apr 2024 13:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Z19RDSWQYqNNcN2eR7rXEkoFW7wgiWCNbr6B9fTlIdM=;
 b=Rhv2c2n6JyRq+qxfUoJ5mFTxTNOUFTEUF4v7t3IDyIgQA2YkwcWwWauVgId7AsxIKa3w
 awAWQCiHH1cAGqhLESA+FUf63TrPCR88+pn0ufz4ALOThNscQX+nG0FqDtNiZnu57pUJ
 siGzRfGnadVBN8LCiO+IQ0dstzDtbEAvdk5Kw8l3BneHDF4gaLBwTuvtJufnAcXtGVwV
 30N7R58VxOeHdKG5xgUqszHIKvr/17F98rVkSFksVw8S365aKYeAzz/FAm58VaOT/RP+
 6i2c+Sc31uw7+adReauUWwoPUc1rwwOBRsOrHNFuv7XgVAp8YhobmRkXhNEKAX6UUR9v Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvang7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 13:46:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438D8IwB032526;
	Mon, 8 Apr 2024 13:46:10 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu5tyj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 13:46:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPcAFGJRRabFxtcel6jt65FFcdmmaabQYBqSVdOs7olX3D/ABziDeegJCMT7ytdu8hVtouK9NOydTdHsqCccDEH66A63ZXvGd21n3Eoh9FJtxs5fWjEOBEIxdtyEdHkLNmKSu1YSOxfT/nz1ftm3wvSM6Xfl3OZEiumzu3VXZdFX2Il0AFLH/dZREQMEYO3RMxWfd9h27wjLkY+8mSozCtfkE3Ltd2cjt03juKWoJA1lLLQvHwfU7baZIdgYSRNNkTv+xgJv8pOYQO3i4xhbDd+9NPM1wR1XpUmlOv28bXt1p6kHpi+fSUvrYovotQOSKqv0ETVWOyjPuaWobetiXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z19RDSWQYqNNcN2eR7rXEkoFW7wgiWCNbr6B9fTlIdM=;
 b=UXAIXMaPI6JkYaOIuokEQxImxxiJyCAbemehvQNhJFuDr9R9r7xEadVeUL9hJ+cSjD+dS2jXxWX4mbOaniOk824z0Rqfl6fxiBKquZG9Zd/l9KSl+k+kGUzfn/MuE0WmeppQuLdfcJdSLlI5X+oRs6kOtC41julULH+NVkBx3aJ1VYMwm23F94JViHMUqGEeh9ReflgBFI8B6NSjs/VrIdTwdlGkjErGZvuwzL0er6YxjdurmwdMMNur/9glQ1HhaY28/W8aL23LjjadNUUUgGUYbilHZ9COUCR/ez5ZzIFCihjP0vOxfJIaGeUWm+t79Smk7VwoVkIZ/VjtmVc0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z19RDSWQYqNNcN2eR7rXEkoFW7wgiWCNbr6B9fTlIdM=;
 b=GSKbf8C/2YjeqknkIHBRC2DJ+5VrF9wOY+1oDpRAqAVbi7jYQJMJ2qzDyYmX2b0x1OQsggGC/CEfKbOXDKsN+0I7b+TZRlC3bvxK0QYFKg9TFKWlOJeQEtEyaH8BQmmJ+RJXISx9Gs6honpCqTRFqJYRWwq+aIUVwdAL3nmMrKE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6863.namprd10.prod.outlook.com (2603:10b6:8:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.53; Mon, 8 Apr
 2024 13:46:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 13:46:08 +0000
To: John David Anglin <dave.anglin@bell.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Broken Domain Validation in 6.1.84+
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <d04f4358-6c27-46b6-be26-4d42eebc2acc@bell.net> (John David
	Anglin's message of "Sun, 7 Apr 2024 20:58:13 -0400")
Organization: Oracle Corporation
Message-ID: <yq1r0fgotqd.fsf@ca-mkp.ca.oracle.com>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
	<d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
	<db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
	<028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
	<cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
	<6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
	<03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
	<yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com>
	<d04f4358-6c27-46b6-be26-4d42eebc2acc@bell.net>
Date: Mon, 08 Apr 2024 09:46:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:510:174::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB6863:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rfEJca+vSIdstzak4AZgFuIgTU6Rd4YzUOo5HB0daLdvUGE37uPx/5MAkjqSHvbdbFCiygX1yA9zwfSTw0r9Xez30feDOgr3ri3DumifYiP0DbWFR9ShTFeiGQY0rOGRFqegMjhdNPRS43pWIDqQXl7PcbvbgYL40Q3E4kix/WQI64sNTX7UHPWQcWmtvI30HZKAUUziLHnp1cfO3qGC+hef9omYU+qlLxC7is40eIRxt8FrhDiFk4ZEC4cpm/gKWknOe+AAc/BbSJ086HjGJaQJIPZQDbMDQK36N+SVuDONNueAYyAu66PKqPWN9dgG6Uu2KBRfX0zih1EU6l9c9XJYda5kgmFhvExiop1ec+HeGvBs4mAgTzedeEvUUBj3/01M45PJdThp4QVF2GW4SrR7wGHzVhVmtzw2G9f5M9cJ6ZTBjqQd/Mo4zZ23a1/GaPNu7ogKJRNC3VN7b8QZL2wW+iR12KytseB4VHEAFHeUptqmAKZJx8OG6YPFweWUDtUbAtdq8i6DMbxJYe7YJsXyS1lME9qq4SjJg1O/59Mm/CquvXQiHpq0MeNMufXDV/UVcFJbtJv5/pPfP/fcIsUdJHK4hVcPdZhBVVTafvbYl+K0L7nZch1x6NcUlxWQlQ1Yqh2r6MBD+xsWC32lgE9PgT8il+Mu/2GwZNX5IQI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?TmOJ6fSplAeoG4EGWm3zqPfvbfflxVSkD7/6VM+IM7ns6gO5QpbqGOa+flTZ?=
 =?us-ascii?Q?5JPhE1GUTgd3jPDIqOPfDs56IrpnX0WQYnyoiQni38hjtVChzUUNrkWO8dWM?=
 =?us-ascii?Q?2uCu4YUxtttTU4dL9cOLH/f5vR9WjU7C/Pkj/9UQoWKOkJq0rTz0JnKAtsN2?=
 =?us-ascii?Q?lBTFUMWgm57pGoObO/58LgPnoSwmEh69MXImAq/bNQYV43vOnrgCqrEDx/wn?=
 =?us-ascii?Q?uCOYpALqYXXiFrF1O2aJlpI0a7M7RsvL/QvCQNxjRw87UkMfNPjuS4WOAsBp?=
 =?us-ascii?Q?5Ud+YmjCiqaI+T5xvQ/5x8fXFrzEOyXweCSAsXdNs0zL2rqJbCmyiVHLFITg?=
 =?us-ascii?Q?ZjkGv5TgBom0w2QBMsqmYvLbhPzYTQxTJmZO/YeZ6UjumIXGEVObYRzvkIHw?=
 =?us-ascii?Q?+5Lv73p/Jp21JCJ6FxBcjtcnzCZL6RdmQ5lw7Lb+kVA/j12DmM0BKcnT1LmQ?=
 =?us-ascii?Q?is/IFDoW7hJ8CUiiLAtf+zfzpKsTFlVX+5qVd6DS5ybxiGXlyKZAj5Kom4kk?=
 =?us-ascii?Q?lM/oe+2/kaNI+wI49fXWu6ba0QvDG16El/CBt1as9Uo1w4uRoG2gB0ZX8Kd8?=
 =?us-ascii?Q?tfXtnLIVuVyAepbNNAWnNOrVvHPHkuXnqZdywxn4tdr7ypvbsVBlt5mGg3K8?=
 =?us-ascii?Q?68Uak+QyIl2yckXx9ylKkSkkLKJYC+wLf/qcuCbcPELUQVKZn9DxIXPByFJ/?=
 =?us-ascii?Q?J9h68p26xE65MFSbuuDW9ZA724Of5V9AT/BJbwYAicb7zeOjwrgrJt29cEzz?=
 =?us-ascii?Q?YZ9ZQMM6DkyPQc6FbrybVIrf3TohSkf03PmgJa+wvRGSgnnMQycy5HzCD70b?=
 =?us-ascii?Q?brOTmZtUdYDh87pUztlsjgrsJz7gSaWmZwIaheH9ujcOkSzbMlj/vx5AyhgW?=
 =?us-ascii?Q?ek1CNdj4uCPF59q1edrAkI0ifmSnC9SsdMVmtukkUTCqYkeTL6R6Bv96twfA?=
 =?us-ascii?Q?jYp9Y5RY6XyeWeLAKBC+Z7jzlEBiu2jpPAwAD4MmNQpIIicuPlxnJef5EhiL?=
 =?us-ascii?Q?uQgmAGksYiwPURVtYEJwvJ1nXcnrwKovoTKjfODiHkfWTC1LVTMy7az8J5CU?=
 =?us-ascii?Q?Nx1m9rk53yJPv9MFc8I9RCefKBur8qrriJz3TIEAloju6MbfWLOvUWLTK7HS?=
 =?us-ascii?Q?E5L3ruVod7PwXI6IWn2b4f4kPwVdi/xyO2fNoMMo98ovcbWbNvDb4aF3ROTY?=
 =?us-ascii?Q?SiLAOSRNyq9I9D8CMuJ3YPGcwYgjGCFYba0BUXnGwRF/I7MxvO+4js5Vpn7+?=
 =?us-ascii?Q?DbdKIqotQvWexXp8MCGaP6TQQhz8riJ2KnsMGtqPZp5RLu++jRXlrc/rIFgw?=
 =?us-ascii?Q?pJnuELv1xar55UkFj4SU/AAF+roPBZBcqZ1TcQozcOVRAabVIfwPoxHcmQQM?=
 =?us-ascii?Q?YI4EghDxkLSBTlgopZhHLHKUqz2zhtGEcHugbdSBtZ4g2UMJ+6/TT9fUcAGF?=
 =?us-ascii?Q?/jOQM8V3XwHfHDLNyUDIGrZlKgfUQZ+97PDIBZBQo3HRHj3kpz0+0WPvneOs?=
 =?us-ascii?Q?KBnvzV+Jyza1Cb0elGWTn+tb+qxjbDEbVKo7PrMotLnicmhqGOaLXBzPx1A1?=
 =?us-ascii?Q?3frJ9jLpCnKjLuGPG5zdYltP2asifKJCs7z0tXofJ1AJsk6dzuJVfXb7SrXv?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0lV76zADaP3Y7wjtVVpupTdJZexYWZHTTGIe9/23VzScHDA60zOJaVOKdcYFmTgFhEy8lgrLWSFdwL0zF3lkrauN2qMzRHhFwdb4B2OYnhYoz9jRKYtlSSGRzQKzBBJ1upg1IHxzzgJtAObpjo1GowPRiKuColTgn2Y4UvpqOmLE2inv9e81sGuUOPNq/vSmbd6GgB31kVSoqzeifurkSYN06dHxSeORbnTA0RWKwai/xLAL5wGX2c9c2qMplIDdtRLGls7h3PTcKdKu2SHHxR/yttLehhFmueyVEOrFMcl1Gs/p9+4e7PyVsxh8ITQiV+9l9k2CM7BRuKF3VhPCR3X3vTuop8Id7spZmbFM2q1cfsDlFbozNOZuou71Mv9fXUvx+6CITk4rdoZle1fJPMR9Gk1uewJYH2t1RYs7PFj7V6cL07k3NL1tXR/xVJX4Bk3gfPRcLhnQ/uyIPQvHwKzzu1WaBOdcfMccFuIxs8ZwxOvh01HzatNRcwFY+XMTIC8FiTnPuWVLUfFo18qzfiy/bkZbwpsuyxxVDNx5sC+GuGe7QU0WylTRTsGuUGF0lEM0CZGPVx3edFtIvkrOS5H/FnqUqD39ouI5xfxqAQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e51f86-d4a8-46f5-1183-08dc57d23e67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 13:46:08.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0j+4bQPJPru6bo72GsJQfCmMncZbtOCdMQaReObI94ZQ3YZbk4hsr83aRt+utkRJQgYizuSPiztYI5I8lyw6r35pjD8HJMoUjHzjrI0oKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_12,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=670 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080105
X-Proofpoint-ORIG-GUID: C2bpqTEXQPAByyGgrVD5qvwDlacYM78E
X-Proofpoint-GUID: C2bpqTEXQPAByyGgrVD5qvwDlacYM78E


Dave,

>> Could you please try the patch below on top of v6.1.80?
>>
>   CC [M]  drivers/scsi/sd.o
>   CC [M]  net/ipv6/xfrm6_policy.o
>   CC [M]  net/llc/llc_output.o
> drivers/scsi/sd.c: In function 'sd_read_block_zero':
> drivers/scsi/sd.c:3300:9: error: implicit declaration of function 'scsi_execute_
> cmd'; did you mean 'scsi_execute_req'? [-Werror=implicit-function-declaration]
>  3300 |         scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_l
> en,
>       |         ^~~~~~~~~~~~~~~~
>       |         scsi_execute_req

The patch I attached replaced scsi_execute_cmd() with scsi_execute_req()
so you should not see this error.

-- 
Martin K. Petersen	Oracle Linux Engineering
