Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mRuJiWaG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fd0uc0Pw"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FEA85
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 19:20:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0Sa1s018630;
	Thu, 14 Dec 2023 03:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=nD+UVPXHoADYpBjum1lEd7RH0vA/+GSQfkKRWnNf7AE=;
 b=mRuJiWaGPEAgQ2B5VPm130Wm6t58JqLfvYMYPcHPaAoT0vmfWv3349ypD6tCa0gLV1g2
 TlyXaUvzNh7apMRB4Yd1Z11i73osjr29cC/PpbIgDZRT7YolIIVqIpAniZPYa012mRPu
 VSFeRWjVrtT7Sz1nQe0o4mshV/hg7+bl9Qkv+dgBp/YzuCgBtAtqE3v1JyoSMJ8YYYy/
 8RiOFL8Fyz1NCbNfM4KOW6JO04PX7FcMMBS9/HYL4bfnzVgHe7wGSu9bfSLVsib2jMKh
 Sqov3n1QGlI0W0Uvj55bgFOcLuWs30E6JMCr7vwSA82JCqtPHe4Mx3oV5Yru+YDwGFgq YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvgsuhsf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 03:20:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE148OJ018641;
	Thu, 14 Dec 2023 03:20:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9dgh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 03:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWSLEOGMOaDtu5NQiP5xcmPPQ475S1lD78JpixgIZwM000aqr2BtJCacRXKaYUtYFomBrZDi3fwvTAsSUEBMVzL05m409VrGPjZ5E5U/XOYow4/YlorUvgzXm1cZxiYpCHbt/pjFD8Q0TE/k/NcFec7TqqWLsbGEfn0d/e01SSNNCpP8DkFASX4C4FbEos8Roakr8iMK9vJs/hwpzdjk6SjBgaapSr+WknNMKm4MdO8ybXC08T3KnHWgeEONgEc/hlhJcDLYj5c9jIqmN7tf+Bd44Z/+KIDReg/RadozXmORMOr0cwhW92dwzldaNOZKL4bpUxVbf9tsmLt7ewwMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nD+UVPXHoADYpBjum1lEd7RH0vA/+GSQfkKRWnNf7AE=;
 b=RqSvUbgDhFjczwlu1gkVawa4IujDXRsUViCEZOzrmTwwTQ0FTllsUdWVQhaqtCIBm+GZCSzBRNmkzfHaLxLmP99jubiM6BOJi0sQKbKid4MZTZvEmtNWHBdKK2JwCCIoyLR89CdGWso13e7qxMRBPTmvBPbVUJkkdgAo1JIBJSIZywekGjU61EegFu6iIFdYx1zOjRqX+PVSSeO3OKMGHKzMkJEITWn9XbYcFEUzmUirefEGbtH9A7Kvf7u/wFmS3bwxkUzI5lPY5HHuEi0Ym0KoEG+Vl0O2qZCoKogyfB0kBe82VbSmLv+1eaMSYUVSpEFArygRlQYkbjCKV5QbSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nD+UVPXHoADYpBjum1lEd7RH0vA/+GSQfkKRWnNf7AE=;
 b=Fd0uc0PwSOp55Cou58TreUJFXFMcto3j4G3X8lrZAkHklF9uvbWjmaEDWm0sz8QOLOoIMI+pnv8YMX79iWrySnN2jGTyeMBm2tjPPryQYZJSK7JojX8u21Oyas7Z8viy9D+n9roEKQqrsFED66FhvU4IzW2DlUkMy5QnH29ap94=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB6786.namprd10.prod.outlook.com (2603:10b6:610:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 03:20:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 03:20:16 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/4] lpfc: Update lpfc to revision 14.2.0.17
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0jph3mg.fsf@ca-mkp.ca.oracle.com>
References: <20231207224039.35466-1-justintee8345@gmail.com>
Date: Wed, 13 Dec 2023 22:20:14 -0500
In-Reply-To: <20231207224039.35466-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 7 Dec 2023 14:40:35 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0259.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: ae2f1743-ea27-435b-105e-08dbfc5397f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Pk9BPecbEkgXVSo81YXvwa2Tcyfv2SCyBgSHCboLTlYgSkjlyGRXcD94UxC2Wt7VVb6LZus7d5MNM9hBtRvLEXoMNwpb55h6+vzKNznvt++fA0Ie0wPAPGcy2rYURWbt9heYVZE3OjxcSoYBUoPK9zUx47ZhhRzTWeGgvODR9cCGvpAwVj5+yZMvj8GHv0eQlXY9A2rRx8Rt8Vex8IRqD65pkq1F4sY22/B9Nyds1qdy8JofvlfXKlzAvY4iy0KvZnuhNwSKy6ir+q3qXYvFLv2EG2rgengf5YK+dciDTT3MM5n0rA4WOBS9UvzOG+ljB2dPMBM2AHN5Zhi3jR6f/RfDy9TT9djVeVPr7IPmJN+hfnw0eKMtA9Y2VvtvDggMXaXflhi4nz7WHPdLze0Pgw0VCjOPv4eSlDa4QKDw5waQDQkgbDCgPBgbUwf0yyQbhyZc7B1JUGr3SrZQBrNZoENSODiKenLzxhGwi0xOARmc6A4TmxUOSQKnK26HUd4NglgR9oZcHKZWx+KzJAa8ha6e/x/E5HzJ32HmXAIwGQwwhFUfG1qSsWbvQJ4yV09A
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(396003)(346002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(66556008)(66476007)(6916009)(66946007)(8936002)(316002)(8676002)(4326008)(83380400001)(36916002)(6506007)(478600001)(6486002)(26005)(6512007)(15650500001)(5660300002)(2906002)(41300700001)(558084003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?58wiRw0Yhdq4Js8aRl9APykIwHRLLshYEmAIMExBurLeHKQcUDmLFEhB5xuL?=
 =?us-ascii?Q?oCbzXuGD89hOdmyzMN7EQXl2cOrKDvMAWxbYdCPAkpginx6h2L18DsgaLCf7?=
 =?us-ascii?Q?zylTGTsExmpLbAvJLpxNrSU/FtzX7z2e8cLYUKtfcaiTPeyORfSxMxPtJdgx?=
 =?us-ascii?Q?yAfz1wI5uuIFPQI//rIDROCcZdZu8mJwQIkpst8qYqyvbN++rcTo5YW57Fl/?=
 =?us-ascii?Q?QeAFcy6CI8rB9I7cNDXoAJrThUKJ0z5nzMDNj7oyct81+0aHgOihwQI9JHOz?=
 =?us-ascii?Q?QQrwuWQMb0ROM6SrvmtINh3DRG5Unj/z1fNSHS4yOStW18SqLoNuKVpFUhUb?=
 =?us-ascii?Q?rwEcJ8oJyIdGk5jhGGMS1pqQ70qlrS1giYUGIoVY5qGVLbwtC6Ak84NKUgNa?=
 =?us-ascii?Q?K8tQMMr6uxE2geIcVzrTZd9LkeKTOQ40acQMJm4gn8J0d2U9XK1f5aWMya1H?=
 =?us-ascii?Q?OOucARB8ANg9HZKIt1O4/HJl/76kAmELFE1Z82NhotihKc49dQUcefJIuv5G?=
 =?us-ascii?Q?9/03fWkUeNuK8UeV+PfI7nBNIf6RTSj5J61tL3Gz48unhFvJ9epN6X+hJqKd?=
 =?us-ascii?Q?9J6wwV/xqo10sMYcsRPUzR9nS/09Z3C3P6jG38eCtny8wrch8W/LS4V7yWBM?=
 =?us-ascii?Q?RFZL/WAOw1YhE28DkFlvBZSOgmD/olEN4KXgflwcMSYsamd4E8OuQf2EwEwE?=
 =?us-ascii?Q?9PQOTPplG9/5qxs+kX73xmAdcjAATOfJzGofFrCI2WX8KHXzLGkeEFVItP0s?=
 =?us-ascii?Q?/S0IjCYv964py3PTYSNwUblJY0mcWelpvdmhwbolfecxocD/GuQIAJVnEugb?=
 =?us-ascii?Q?Y4iBiwYFqIZdotCwiZ7qiMXpk/9+VQo8++XDYReu747k0RY9PJQ5XN4xcAsH?=
 =?us-ascii?Q?wXELJzB4FBMmxl1la8lSC6zgdzbws1uONCKwtX7ujYIBnowU+zo51/tq3HO8?=
 =?us-ascii?Q?1Rnq+JoSDbnzO5lSyAO8J3GstOqOmuQccoNYn+kK0w5lfubLf8ubpPM6TIhQ?=
 =?us-ascii?Q?ijRMvc1PVv3pJH4ltcpBkoyaP1W+f3P6Br2tgLPfXScMpBNY/5YdvAgFJMjo?=
 =?us-ascii?Q?klMYiUI1nkF+pimIs9t6Xkzld+4SQcg5DQFprwJGCEj8cyB37FP4Ykor4WRJ?=
 =?us-ascii?Q?ohUvAjG+IYgsNTtUk1RFYnvI1jnoCA6GuqrxaiK5WvdkikzKwM0IHngqwzlc?=
 =?us-ascii?Q?8MXNN+S02Vb5omDNntpvuZ9fmCoosfYk0tloeVr1ixD3oqZ1MgqG3sWd3WFX?=
 =?us-ascii?Q?pDYpVhbxHexbAxiBLnTDheX6ym+4vMWHIsPHQ/kLYSIvbB2Lwe6g7Zr3CyjD?=
 =?us-ascii?Q?WLK+U1UNGiZlFhruyLAeSB2Sr4KArZ8QvZuAysaT3LB3bmCpSiBvEMM3yguq?=
 =?us-ascii?Q?1m84OP+6UyhH3RyQxPVJRlUwwungeKfKgDP5dIequezl7tMT5bl6n/KAwbW5?=
 =?us-ascii?Q?U0pfBTzjxlOpeNV6E//c0aTei+brvuyi+Ay+PyhA5KJPrQkJFAd7s+PFPbCL?=
 =?us-ascii?Q?YUxgkopHa8sErYzFicw45Y8/ueGYRig2oJwXHV19Eo0DoSR/uDzVBR0cIB2S?=
 =?us-ascii?Q?eNeMIvUpak83EJ2N3Tg66Y/0Ow0L8KrFhV8U4cMw9D57F0cInDUMEMo8iqNN?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	60DWaOO7YmGrNGAECqgKb7/Sgl8MP+M70GcqWOmhINSVEDximk2vMfTpIXB/TOWrTNyf6e1NyV52K88TUSfPz2d4ik8Xk9s+mI50ci8DwLe/q1ShWKpJsK+UJBCpnSgzAe98yF1EFnGKrXKAhZBS4Njy/jgvyT7p+QeP+3P7glS4P3WhUA9AnABc88sI8RR1mz/C+zSZ+9X2e2/ZRBimInK9WaabOvKecw/rRb+maVSiAqMUA3Xm6eCZyyvA2WZj1bE/eXAUuO1ChsMKAGfI86FTqpr15BKsT//Vbfcha0mG2T1Rra5CWwHLsOfpkNBtQTMxkWW4CfZKMofDRKXdbC6UhsWbMlRHQbSREZSuFFdIBUugw33RxXgwnrXBHMdvMfk+AaGc0hpkTWGL6MnnnRAhZ4vC81nWGmU4RlOfU7kb35GsvXeoSohzTGyWxLucvV5iIVziqBpRTVFFtIrV8NPRGLJ6bswgdYzV1DOmFDpnyZkuKMIcNoJdWgweQabkBD45TMtfk7P6Pad6TshcVqAeMgAZ/72u1r5PKOhVZNG4r8pkO2Q78b8Sapgy2H566uTXkkzA+UCyCYOg3OHw9WoMFIqCRAjU9QSlyJILdGo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2f1743-ea27-435b-105e-08dbfc5397f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 03:20:16.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyYRn7xwLSxpWZNfZ/crf+wwB0A6V3Pr/hj9kj98Kmu0VTIIN0Jyk8i0f6gg2iOV/XTAc/N6k2RI1OD8h0apUFd0aW56IPUYyfJLt5ZwCNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_16,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=640 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312140017
X-Proofpoint-ORIG-GUID: PpKJJHpBW3Fen5AOd9Y5kUMa7pppSxt5
X-Proofpoint-GUID: PpKJJHpBW3Fen5AOd9Y5kUMa7pppSxt5


Justin,

> Update lpfc to revision 14.2.0.17

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
