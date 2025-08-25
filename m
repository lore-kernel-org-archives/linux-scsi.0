Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C4D2FF17D;
	Mon, 25 Aug 2025 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756137611; cv=fail; b=LEHo9Ea+eunoKSl7Ka3sA2yRl6tjREpn0FfaB65Q0sPmDqkUhvwCl3bUPnLPkWLbJTVAeQklU34AecJUS4oYWky5yBi+8iQUITDv1+rxHRmQM6UBB74jq7GAkY+d2DzYIpA/3/iZU/GbGZhTVl/nuVVCdx3ZddwuMsZdBBTChH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756137611; c=relaxed/simple;
	bh=LmX3t6UzPR/bfq1JnOgK4VEMGnmVc9suNrthVrkOjv8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fZOLpo4lBa78cZsl0qrevF6yKUpcpZwOzc1DMFxCvtuupxtUdFU+CtV/VAQoDjCvtVGFbkuOyJYrJDCxyWVCF5+/dAJOlW4mJPqhNuQPDJQYkE/sUfWEKWQwKchr/WnuDhCq9RRf17+9VAYdkE7dMRs3VJEUwq7+eHxBe2Eb3Eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i+lk/kWT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U+O6VDXh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i+lk/kWT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U+O6VDXh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PFfsNM022300;
	Mon, 25 Aug 2025 15:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ID6f2TRRJ1FIyF7n+T
	wZKycnTX0EuF/Zak/OJMUvDTA=; b=i+lk/kWTXhDxjp6FRTWqXC8RMjwbPpc8rO
	XUTRsx2/lAMwCk7GXGdUbdxElQmXKpqYRN44cNzZ9skvPeYUmQwZY2/U6pL4iGzm
	r/FCJnOhL+oMAcpSUVxyxxAttSCJ5bIsm1n1INUdDowKrz49iaL1X0Sxge6Vi5ZW
	Kb13HfiM0ZraxN11pCWWm20BeVwVZsexngFjf3GFWizrasTBr1fkwROUKYJ9Afb+
	L7WqvC8eON3vTSrTRSzEAleTsZ52XRPSFm1fVspA0EgR8NFxQVRZD5S9gcPukPM9
	cYOoGOtlFxmlPHZbH7VtO2XD4Wo3tlRqSlNot+JJvbJFX2AcCc2g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8tw9dcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:59:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57PFIsLl018993;
	Mon, 25 Aug 2025 15:59:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q438eu0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:59:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPLR1W/pL1p4+2+kUByv995TS/c4EcjEZ1UOsAnrKbjCr6i4t+Jv5T1IqztJXrs6pQVqyJMlN6BPvQ+Ul1KcSNXmfRztdnzFIEY1GLMyzqnkjYWOfoW1DP8yaDVl9kvx69PreGoHY+XnF76nuekAcq7NobaBcEInQGzpHLvVXugJbM5JqQNcbbVXOtS6YRlW2nQAB5B+/iS7R1nKfD45af3vAxZL+UnRGMbF9r+AMWZCgeNWKxTsHOPLSxREFMbRGbfYxXoaoq7kepXYbw/eTjeabElmBXVMoDximz81APE1+3N4eE//DR0CgSWn9laEqQK+yyiM8eFrDL8zZz+qPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ID6f2TRRJ1FIyF7n+TwZKycnTX0EuF/Zak/OJMUvDTA=;
 b=BiTbf+NwZGqnHIfMgwxsyNI2Y9UTIrrDIRyJlMvVY3pA5Fz09m35KgISAMaDIjwz1h42tYybe+TsDIGJAHZWYQn+MDnRY5MWn79ox51tRoojpIpJ/LTF5yT0RbF+aVcZ+EMbim4Ajtw9X9AR/tBsZE6JAMA2hQ/rJvtsW9gEOBMvslqlgFi3sbp752wAfeq0gjC/jXaTlNCwOILppp3ljap8T9irtZfsY8uo+5l3XkwQ+dZvb1HMDgSugFy9Batv+6dKZyRSFI2W/ZZAItB55lwMqXD88UH3H9+kY5NDSnf4sFsmI4bLcCMgtmzt6LwLCQOAb9HFDIoN14Vt9r2GeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID6f2TRRJ1FIyF7n+TwZKycnTX0EuF/Zak/OJMUvDTA=;
 b=U+O6VDXhHJdqXthA0T9yw9XF9R93+nzm+xJ31F01Ikkjam+wOB2Aq4+jNrfLO8uWnH9dEgsU3RKCZpWYTH5kVt6YtJbHQk1fHOS6H712kiFC/oUBYBkeWd+e65vifhz8jRvj/r+1NbrGg9qIQqo/jZxS6bmeeko5AaIl6HH4aZs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7091.namprd10.prod.outlook.com (2603:10b6:8:14d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 15:59:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Mon, 25 Aug 2025
 15:59:53 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, <liuqiangneo@163.com>,
        <James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Qiang Liu
 <liuqiang@kylinos.cn>
Subject: Re: [PATCH] scsi: aic94xx: remove self-assigned redundant code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <0a345fc9-e780-486c-8724-2c313343cc51@oracle.com> (John Garry's
	message of "Wed, 20 Aug 2025 10:24:10 +0100")
Organization: Oracle Corporation
Message-ID: <yq1tt1vqtol.fsf@ca-mkp.ca.oracle.com>
References: <20250819023006.15216-1-liuqiangneo@163.com>
	<yq1h5y2vh09.fsf@ca-mkp.ca.oracle.com>
	<0a345fc9-e780-486c-8724-2c313343cc51@oracle.com>
Date: Mon, 25 Aug 2025 11:59:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: a1790c4b-f372-4c09-b130-08dde3f06e1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n3vx/CzzwCcWIn7NGh4/TtAO2dR2QQVAcAsGIsm2qP7v/obEFvSrw9rkaxP1?=
 =?us-ascii?Q?jLoCTQif0waRNeC28iJ9edpg+Y0FqbI3C5TkDw0wlq7hDcypQ1WvnwRPoqmL?=
 =?us-ascii?Q?yYvgbBvlPb8kroSrJYAkFi3ShRBfPt4l2M1VTqVzdzxYd3++vzCektUw7oH1?=
 =?us-ascii?Q?QhUVIGkmGdruxjHG/dgOrQCxoS0q6aM6i/oEUpU6Oo2PMaQI0zIDuQ+dKUih?=
 =?us-ascii?Q?zyGWB+/DynL6+EJhX1gVia9u2f+UVu2Fd4+unZ7kYk9PXEa+cJ7R9wQY0SQU?=
 =?us-ascii?Q?CHxiIYoyJ1wGPwJp8oeYwnXo5mHRchrD3cbe6rejM8ZpNLDFQPIr58yy9dlN?=
 =?us-ascii?Q?Wpr9lkiyKs9gZNVPoAQSAP9YwMM+I1fAwQyb/tlVqw+OC85w7ls4mrdw6c71?=
 =?us-ascii?Q?/6J9v6Zc9P0KevAhKicav++8O54j+lEAxm7JoEv3tQT2tndSV4+Qnoa7WTnk?=
 =?us-ascii?Q?yNChUAopPw5GMuHmfNMLUqD86yzLSmgkkQe7xAxDQgfX8V+ticGC8GKcO81p?=
 =?us-ascii?Q?oVq2NA/Z2GRysgcmBFPa8ma1+s1NB+gnExpMTftqhxrILPoQtdb7HF0FtfGw?=
 =?us-ascii?Q?xP5Z5XsFDaWQ4ilvsVi2i/Fa4M7oY7yEqJ+27P0dRkc5zqTklParDRbi0+Z6?=
 =?us-ascii?Q?POBkjW+J/fapIAkdC2MXzfFKlg10Y3fr05lBfg9FAeSVOQ24qGa3TtgOKLAz?=
 =?us-ascii?Q?t46uDGX+2dvBJdZsqnijkgIjbIUs7w8QslKn28oIP1vE3ftjDM9nuqVandHb?=
 =?us-ascii?Q?of+VVVCwSjUHZ9U7yYWjH/9vYv63F2PN6RpBNivUhGMaiRpOdpsSWmFk22yX?=
 =?us-ascii?Q?hpidrBS/C0wc4tC5ur+krd/PWaZ+zEzxM9MVuIhp6vx5kaj7Jhrrkri4xaRZ?=
 =?us-ascii?Q?rnp0vpCbi+qvaqJ5gB6/Plt8v6M3EZK93ho7WgrlWDqC+8yS8Cx7DUDviQmB?=
 =?us-ascii?Q?dVULXbVv/gLNyF4fTyoqEQCAg5iyNk9qt5gYdRXdNbjdMyo67RvQDnyVreGh?=
 =?us-ascii?Q?MKcftP8VTcsQ6Dgm/HELQ9IoUQdLDOaA7eOehkb4Jrk9dHem4rXr+FXixepo?=
 =?us-ascii?Q?EDbJ+dcQxAfqT2a4Uf2axUgyv83IDDFmRjct3aL55ulZpmwuScrcdR0Ig1Px?=
 =?us-ascii?Q?ctedCCCkLNiKfWRzk6ydTCF/T7+h7nk5GLc8oVt1wCxrrkmqsEX0BWceGRGD?=
 =?us-ascii?Q?D/yuPpAiz9ac5cOfCvPa8hiLRmVoSE4B1vy5S3XMusYdKkqOYUzM8Pgh9z6Q?=
 =?us-ascii?Q?sseBillbhan/KylXsEvwvD4VWqk+bX4I1fc5WonccPzzE5pVRbTR8Mst7ff1?=
 =?us-ascii?Q?Y6K3KP2IFCDyG2HEkJWuGXly7jC8UG/paGbTu7BZyRRer9auAu6GLjcGMb+O?=
 =?us-ascii?Q?hyPMTWJf9Am2cglZD/Wl2njRu06UAxPnfWwPT7E44x8dTl8rtA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J08nVGrDh39oX5QnAlEvCx2DLmVWLLqEDYej4SR0yzpJSyPD09eoyAh3m8IB?=
 =?us-ascii?Q?6a5KEubkfEhGxxtQtOkDJwiy3hZDmhQ1o986ltS0qhwFpVlqMod3X2vz7FO5?=
 =?us-ascii?Q?SyGwchWmLhgm2rbb59W3F2g9alnWbjYRaIGlgw3W2UpK3Le6lLL+RtYfQwJV?=
 =?us-ascii?Q?iBQg3XR8VbytbBJ0YO0fn0KLWVhy++JjjINYY4WP9eDBY3oRRPwEiIMPa973?=
 =?us-ascii?Q?ZkCDoeFL/265HvI101bopApbozkRw3xTeLyQH/UvRGq6jp7VjmbklMi7Ed5L?=
 =?us-ascii?Q?JcoUhzz7PWPKLhdPeKs2rw+R+QpQ81Q+06VTlbhFSTqyyL0qviPycvvB4qrT?=
 =?us-ascii?Q?jt89ntrMczrah7KnLXQOL5coKEQ+6o7jwULi1AIArqjUF64ZgsqQOSiK91NP?=
 =?us-ascii?Q?dn0ew0QHJDAjuf0+x9zOUTcrDq1CElzFIGyfKZuoUaVMZSU601ubk1VNSav0?=
 =?us-ascii?Q?r1WJIj45NV10B5MUa61Wk/mxebrza6JaP9xwmmSOt543hbGAyn3W+MCqwYmB?=
 =?us-ascii?Q?5DQ9qUswbeMYVAxbz95tdAhF+mU7dsMeKvq6reoyNewochLgL0LKAjB3HmLo?=
 =?us-ascii?Q?ORGRyT+adI7WOPLp7PuhbjG6xu1pmtkl96vDWKVTvEqivp8eHwdU+J3ndszM?=
 =?us-ascii?Q?tlQTG0ru18hr3a3Qs70pmX8Xzul9Cyew0LR0u63eMvnZYdSgVV4v3mS9hUMa?=
 =?us-ascii?Q?Tp/eRkOQ/y0ISWpmIk5R7UhFf8yerS7u1AG/ELJGCS5McYKbcg6VsrCqoYPI?=
 =?us-ascii?Q?9C037X4+EMotRvNauJMLnATgYNRW4r30L853CXF24e3tp/c2NjsHq3o9RfO+?=
 =?us-ascii?Q?gYdT+zdu7X58HT8g/bdxsjfClQvzhCFLhGYPXeMGuhFgJtYBK8Fj+cd1KjKl?=
 =?us-ascii?Q?WSC0iLnYfeD9TmRP88kZDYuKJVhs8/M7mXvnO+UQmolKYKxQ7PW8aqyxJD+/?=
 =?us-ascii?Q?7NM6TSza3wMsvBh3YhXx+zIpbgFfSLAShDYy7u5z2P3jXIl+OxsmQ9Zsx6PI?=
 =?us-ascii?Q?6LdjSZVC9yilAOwnbkylsOx60PHSBHH2cRUnR1ACTTbmti3W6ebN9lo8s6PF?=
 =?us-ascii?Q?NQlCj8xbEHkCggjIP9LNM7ff80DkOiuhBVatQE0puXeumG3VJjfK/9pfyIRC?=
 =?us-ascii?Q?6bVwpqnx5DcSnzZ4W4GGuYXgGAbqhHaiCEYEzfYoUMSpl/xoO7K+vHZQyQ3h?=
 =?us-ascii?Q?BKqXx3DaGYQPxdu6ZXarkEfbFKjjMmOz4SZFpVGmuumV0C386IvRWXuoHLKC?=
 =?us-ascii?Q?fMReLMhvddLvEjK0+IJt2Ti8qMP0ePn8V0x9A0d4TRGTKgLzjYJHx2MoCXY9?=
 =?us-ascii?Q?LTmB8WhcVC4uU9wgik7Vo/V6HVN/yDD+mrnGNdjsJXW9lq80W7Qb49btl+Bs?=
 =?us-ascii?Q?9I5KNclUJT0M1NBqZc8QmXVP4XDYoIoajzWiidHIRHOqHPoOvj062l/QD5Sy?=
 =?us-ascii?Q?c7PE0Wl92lVYSQbnR5L/4pOmSpZ+cDnz0DD3lPVpjYebr5eRYPpGvRFCsuiY?=
 =?us-ascii?Q?nk0sRgffMfFiWSiaJ3BkLDAyuX95bcNS8nXQ2g2nKEjBMUGnBpp+36Jf1OkN?=
 =?us-ascii?Q?csXa9mTZQ2mYz44XrTRhp/Zu+vIdulh5fsHEBsxvTVILmZFsbxbxYaA54Dmn?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	39vEWEb2cGmQ0huAaM5z2TkzJ12GRmk5CJN7HxIb4LunFPgXf3iTD/+l0uXlY9oAvCBLxFeU6OWE5DKw/ZFrrWNhnTAB46vdhnfKeNE5E3mhJy0Gqk1xbRBLl9fjZ2V2OrOogUf9Vr+P4f2Zv7bgcDHWsbGTkl6qk6Lz4ULN4ulrCja4PkYJS60xX3zsZrJMurJbu1ebNoCx789SUK6le1IWbLokkSV6TVakESMzqSNllYXLne+n8+TdP47oA/rTYxTPjmJ3gIrpBDTJys5lA6lB/7azbaNJkN027Oy7I7UzSOGKBz46jZ54RZqGBVNaZtzYy2WxZevzhZCQzetTPhxHv+MYjyjR2UEhQ27No58B6WQw0TyC5yewQN8BuBz0m7OJtCfQpu9AIHw05eFKB9U8BRT8qu5xkcLu/aDePyrRLIU9Dlq1AUv+dJsZPeXVSQP97HMFVV4Dad1HWpqKxxDNla6vlf7gfZXPzk+73768zUUfMvCKZY/jeGFT8ZBdXOBIq2pfVMH8bZgRggYJSQ8r8K01KqarK6A3WpiYPHQQ26Xtz1kqt33sX7tQ/a5PZQ6Mjii/dqEA/lW2CeREnWCXouwCqs57QqutGRH1/XQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1790c4b-f372-4c09-b130-08dde3f06e1c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:59:53.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0OKBgdO9bLOWur4CKXWb0X5a1gPWnXoC8HoXq1Fz26iiVwiqc4XqexMLZsKaDeNATxzNXZWpcZ48G/joZ0UOBY/vHYo3hBbRWjqbPGyDFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7091
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=929 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508250144
X-Proofpoint-ORIG-GUID: zq_ApGtFc7eBZ9dwkbIVaOoHe2KhDsLC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX7xcyKXX3+ioZ
 xhc+vUsjS+oNBb5y9edqIMeUnQNytbYzHeOmjl8uuLpQXFCsG8jgIoJBtcSGFC5Y9/x6CvzC/OY
 6UJxjvuBtJKj+OSr9GMn5mD3KIIGn2d45plM7m68Dv4QyVK62AeL+PT3f2AsuWakYWLX4pVEVOg
 DkogvR1j6bNOlG55YsrY6W117+Bv9X1/vGd01T0DysxdGQJMvuy4pD+Kg8dKTHFMS0YUVeexd9l
 JScXSMUS7IGzFR0UtTalFJCDfCjHoXOgYcplBNl+UaI2OKpofwS4s7fjcsf7dfwzuz9oFS+lvuY
 nTlSbLRRuhUZW+8dtOnseQu0IfxLyVzUeZovzAgfROWzVQFCHU8dXNa3QIHhGNPDvSpmrm4u+sX
 TGlFs9R7
X-Proofpoint-GUID: zq_ApGtFc7eBZ9dwkbIVaOoHe2KhDsLC
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68ac887c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VblFAk6oar6JXsPA2SAA:9


John,

>>> Assigning ssp_task.retry_count to itself has no effect
>> 
>>>   	scb->ssp_task.data_dir = data_dir_flags[task->data_dir];
>>> -	scb->ssp_task.retry_count = scb->ssp_task.retry_count;
>> This begs the question of what the original author intended to
>> write.

[...]

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
