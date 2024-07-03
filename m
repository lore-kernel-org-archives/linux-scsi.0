Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508CE139D;
	Wed,  3 Jul 2024 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719974270; cv=fail; b=iHnFJX0s0hOE3L/a0Yl3JCPjXydzfiXpjLgCJNyRRnJu1UQV4XCU3KJ2/nBabDmHRVAegyNH7BVNpv8pE70vq1id/JR+vlgoPVmIyWxKo1UVNrvjllqufd5GFVnEvdQGtNg1OHUbY0pXaGlGUclZ68rS+hq66S9MKtR3XduxbeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719974270; c=relaxed/simple;
	bh=b2ydxhB4PcvXzZd7beqr0+aQgrkkwR4JSVVIc1SvcTo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LEeHoqVfjQbUzkr0l4TszPHGFivYcmkKWlyjZXOpFZV5vfGcIFEoGxHAViuDA4TxBhXou9CPT7rg4HWhV4RKObksBVbZD4FnueMH0Qaqz62zhhmUa91lsXamR6CZhY4V9JiOvYYm9omTL7QKzZJtrloXoH3LkGTi9SaIV5PM3jU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=igUkn57A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y16kuVIP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="igUkn57A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y16kuVIP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4631McC0008680;
	Wed, 3 Jul 2024 02:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=JqKj39kNtx4Wqx
	tLZHzP0RjCAdEaWUeGpZiTmny0L4Y=; b=igUkn57AWQqRlDt64afAovFVU3Hlsy
	ZgigZ1vZq+dKf99Hn14AHQCy1UF36gLnGUgQsMLEY23veVuLn5cDBcghrGpMyUWd
	8WAM44XxsR8IdjB4O9N4oGsOer1OKlPx6sjuN3O4UZoTvOY9axmCRnYh+vMlPhz6
	+XJ8xHfbjpj+w1f56OoEN1Y9csrviKGt9YLR/URxYSjQaoFoWICUXmGA5gewPkFy
	iZJwMLcQLKBhbz4GNMdFgLgINFvjCaPeqSHaa5FcDBVKNtJJNEGXNseSJCcOq50G
	ZmkRo+H+2NcN7mdMA4xNKScfaFXMwVJTWDJ2I30OwwTu+K0H0miUGNiA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4028v0q7w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 02:37:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4631V3wK021479;
	Wed, 3 Jul 2024 02:37:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qenfpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 02:37:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAcEsYOESVmqCXfQtDeV9n9sSYL89uxR0lAU6CezkP1BV/pNLf6rccq7WsSjLKJU4mjBObZZ9TrsYu/ULXqof9QgtayQJzLkIUXH/b5tR5LWB94O+3Eoxrd1D1fpzn+jfayyth9hIhXWgF7gb+jc4Ad2GsI5F2fPSM3kxnI46Zc7wtBbf8xxRIsm2mh7VfFY40G06IRYpz2HZaZ77Oi6T0Csl47iCHltEh/6cUkOTTKZTKOVuk8zavXmyYkDXFwOWzPbLlJXcUmahBbfkN7mHbtR66ianc64vTM/NJG7++gIEp+JSnVin6B0r4gp7tooN4P0pNz0OxZ7X1pWLxpnYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqKj39kNtx4WqxtLZHzP0RjCAdEaWUeGpZiTmny0L4Y=;
 b=TVJaVc0KsdqPxwtXcUcfj8yMpSF9ZpcURv094SSfGWWVciRb8akw90lSfC0rtv32wknKH9F9LmQwkDPW1R+vbxRI+6nveNZrzzH4mhu/c4fx7ezxKo2AGhlIs8GJXYxdKQKPt5QFvXUStJDYB8AELErVKiie368ZIfPLy+UsMYslXmQIU2DhOUES7b2/VhfSwVa44bzjUhsZ12CUC+aS+09Xy/czZjYDNL6+xuFX8spGThu5M0zbcn4CRjTrVpE6xaZ+UFhMSPhLHEXDwR+b7lp0meijjBmX86SuwNdZmnC8+p3RjlDGj8iWJ7E2pYdXki1dr4vtQz75zBRUNkAoiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqKj39kNtx4WqxtLZHzP0RjCAdEaWUeGpZiTmny0L4Y=;
 b=y16kuVIP2SeTKnAOQKppXlzCMW0SP6x8qAyeJjD5JWIx2M1gwS6jbVxuglEIcYsUXsZEqv0ue5v//gGVkUqI/EOdEsRcxnKRYZJEjslooDK2loR3PJnjRSJH7VgpdRlb274rQeeeih9qNmwhlMl3BY1cYQuPaqeT5TrxtL8KGFk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7121.namprd10.prod.outlook.com (2603:10b6:930:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Wed, 3 Jul
 2024 02:37:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 02:37:05 +0000
To: Niklas Cassel <cassel@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, John Garry
 <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Jeff Garzik <jeff@garzik.org>, Tejun Heo
 <htejun@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Colin Ian King
 <colin.i.king@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kai-Heng Feng
 <kai.heng.feng@canonical.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel
 <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/4] libata/libsas cleanup fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <ZoHH47jc5E-a8iV6@ryzen.lan> (Niklas Cassel's message of "Sun, 30
	Jun 2024 23:02:27 +0200")
Organization: Oracle Corporation
Message-ID: <yq134orcibj.fsf@ca-mkp.ca.oracle.com>
References: <20240629124210.181537-6-cassel@kernel.org>
	<ZoHH47jc5E-a8iV6@ryzen.lan>
Date: Tue, 02 Jul 2024 22:37:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0017.namprd17.prod.outlook.com
 (2603:10b6:208:15e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7121:EE_
X-MS-Office365-Filtering-Correlation-Id: 92370f2c-740e-4e09-f18c-08dc9b0906e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?RGHss1SCeLJnFol5HhCrtFISFQiC0PSqDrYdtnmx2TWw3sQ8/oVepYs087ej?=
 =?us-ascii?Q?WHxgzZuAXXjhrNlNRsShYePXHxf93mGaPOOR58Emlh14xsruH3xa90cLAuHj?=
 =?us-ascii?Q?eS5kcfOIz/OoQBNlnjB227+If42yL9h9hIwkMshb3I5GwIg12riUGKarW7DM?=
 =?us-ascii?Q?jmZP7SyiHbIdR9cwq8Mb2QkbmTIV9SevnuCpC85V3/ZckaJ+aC+AXh2lx9tV?=
 =?us-ascii?Q?cV824j7wf66TnE4LlqWgUYX3gTVaOE7Ej+eIdXQKHAwqABkGNo5yE6MOH+5E?=
 =?us-ascii?Q?JUenDqc2TZ8EmJZdKi1lXguia8Obrto4J3dcJ3W0QjOO2IcQckjjlOKhhETr?=
 =?us-ascii?Q?InoAG0V79T4cY3QY9VDWogEW5YzEGT8rQgzA7nK0SzhgA4PByD/yna/EB/MG?=
 =?us-ascii?Q?vu6sP6ywvzoxe5WsaWaQce6hZaQNK1ScCOcGgkFnr75zCJBW+qXMxfvCVhVl?=
 =?us-ascii?Q?DqzldMV+YfmyUGHETWC5ZeiYeU1WCjv+3quinYwbHUC27aBPtZxErva+vODC?=
 =?us-ascii?Q?VTPqVtaybsYZ+OgmWAJHu2R8+yR1X/ubG6lTlOPn5GIyRfEanFhI7YlIYoJz?=
 =?us-ascii?Q?obpH1cbVMjxCucOsLWQrvM8oy/7jVsWcB3XIiM7gH8Sru35QjeEXkPraYNOv?=
 =?us-ascii?Q?sUt0j5zcLJr96WUWBB1p72nwomb5/yN0Mp5UzI8f/07yCfh5rvdIodKPVWfG?=
 =?us-ascii?Q?1Ar7Yt7AvmHJnF2Di1F6/JbM8HOxBfDm+HMi3j/n2fGbH7zDENGjYmMtncj5?=
 =?us-ascii?Q?NoOpCkFGPTtpYOwjnBgbjZMoBKztveZ51PP4sz/eCvg/O1MK0wxNnPH34/im?=
 =?us-ascii?Q?JLvfrPvv3h17x1jcr+O4Hvg7/euLaOccxcBc/TrYGEeWa6dMYdSviAqEdN6O?=
 =?us-ascii?Q?pclFtBR14hJEzkKf/5fM/R5QPcEIcNjH90PVXpwdaFCiW46EYieZqk/zIHk2?=
 =?us-ascii?Q?vpUnoWc/vcYmtvXJbnIS/CGVFSLlJjdGjkR/xcK4i/aNnxn9ON2vzwnVlfEG?=
 =?us-ascii?Q?+l+PNMj0VWGL30r1JdAET3WabG4G0zjgbf6tqwmyufdRGmZRE7QI25SS9bkq?=
 =?us-ascii?Q?w/aZ+5u5cVIxlzYyBvIFJsvHjCYbzd7f0i6jiWajnTzj3tB4g0sA6H+9OuIJ?=
 =?us-ascii?Q?moilQcdCnptF7IXnMg23S/CHBvntgLoRPJ7S6aipv3DeIsZKvPulGI1XqmVC?=
 =?us-ascii?Q?lz3BsTqWzLyhNQK9CvaoWG3hu6BYoFO/s9de6VoNuPzmn3M85ziWNP5HgFIv?=
 =?us-ascii?Q?RIz6qrHP9BO5IcYvJohRdGNSWyz1nRd7IcmhMF+TJgDde6WGOepK3Ihr7EIx?=
 =?us-ascii?Q?OajJgnZvLdJoPxf5e5yjAP+1m8g9L4E4tv8hllWhXLcJvg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?eYxXJ6/UiL1ahwWAJE4gi+IUlO0LXz4B2C6ONBBE2YQc8fhwBDUyIy5TzBBE?=
 =?us-ascii?Q?rkulv1M4f9z2MOajRkXeozMTictvVmQc8tn6/YCyeBD3DbWNeeKd48st9LCQ?=
 =?us-ascii?Q?IKQZt+Vdvv4tLrn6tMrG+TYCGgM/3znnTBHYbShRn4RF1BcCgHRoDJuOaNob?=
 =?us-ascii?Q?gEZdKWmu54BNzma5HI9CBC85nNIBkScO1jqMfDaji5kLSKqth0r6Kbi9hTYt?=
 =?us-ascii?Q?O477FyQkPjaAmIOgFAQ5RTJLWB2YCScZLw5LBJKbPQ+Q3zE+zVUxSS61oxSm?=
 =?us-ascii?Q?cp2KyonI5zog6x/k3d0f+Jj+ZmzakBd+6On188la9Wqnf5qw5TxNQrqhE4a5?=
 =?us-ascii?Q?E0V9eRTj45JhZLLLtMgqxBbRS5tHbep3tN+3dYyWNCR2x0jsATKDJ2KTiHxQ?=
 =?us-ascii?Q?b5B2NJCF1Y/Z/UBkvVnHcsEwYEUfoiLnTg+DGmRxdBcVIdaGiUFI42I8feoA?=
 =?us-ascii?Q?RVQVqxVsNDDEBUFHFch8D0bjL13CTPhhODW4iISUuzMcMK7i3yJPwirp+jUz?=
 =?us-ascii?Q?Ku3uwKHWrBY0skk9bNjdpUSlNl2+8eTwJTxcGjMM+/edMQjYG5NLrmSX4Ht8?=
 =?us-ascii?Q?XZdesdc7L5BaFptkbF4xTjJC//r5XWeBcFnW1Zsx0f5g+qZ9SeNQS0vYROBv?=
 =?us-ascii?Q?8VVOv/Z9kWublTlZRl//o5DECuaGTKuTtLS6/rT6D4BSQmnSwqcN9o+MyEwy?=
 =?us-ascii?Q?FQz5Zz63wFG5SSA3m1tvYmOt3m/vKuFw6JsngRbkbvFQKNty173M6ahIKpom?=
 =?us-ascii?Q?aYTV6hjsTQghhwGG11VGA+JC/LatzsDktLSqWH3iIrDoE9+TOqjaGHN5+iU9?=
 =?us-ascii?Q?D+ZP31U8jgbxLE9Hrtqj2+fxHSDELTUG0CmXbIpVZAvvvTgfe46HP7WYrlfH?=
 =?us-ascii?Q?cUV+Ckbyej4RsFEXkHlUB+MVc279kLFdYq+q43mim9LZl2L3qpLeI9IzjaPf?=
 =?us-ascii?Q?xbVfpouR/Lp9bJLOYycFyN0dldvzWbRk5S98QCY/fUk6EXwEU4mXHE+MpqVM?=
 =?us-ascii?Q?gJb4O1vkZgSk4IfBaoHhfYGh14OjGLzXep5R3xMu7+9B5ryCHxhgs92Cb2bF?=
 =?us-ascii?Q?gNX1JbaD9cTB14JZHYAwWRCBSZNRSTR7zeX7Xs7fGBEdR7N2a7akkCWOaK47?=
 =?us-ascii?Q?RgBRw/wfWhsUu/M9wQlA8+uQQ3Wxu386WQJ7nyT8Q3d1BarkvDPSqZmWo/D7?=
 =?us-ascii?Q?JJvyeynSG8fe/AU3E/c5JKlmRab7kd2Iy/imtp/zUG7gzRnjJaHrkUTrTnYw?=
 =?us-ascii?Q?A9z+D0vyCUJ3jxBZfMfNj+miRACyCqOLUnKzRo2T0rCYo/BzQSzaKTEF+Yp9?=
 =?us-ascii?Q?cld7U1/2oNKiU0ynAsmkJjESYLqlEs2qEzk4QUWE6eCcpn0YDyJRK7KXGTw/?=
 =?us-ascii?Q?D8mRggh9314D/egpGEhsoT3P1zdQ2TdhR1fleKJPXO9vzvwxSe8+WhqCa6Du?=
 =?us-ascii?Q?/vbgOe+1RI03xwh8eWwl6eUOGfQ90oPeoaNCxh5ZugM/j1Ta424A495OEIyo?=
 =?us-ascii?Q?3CcRc+ZeE4gZdDcEab4mvCykwgfwK+gP9slP9R8eOaXjCcNw+QrIPb/bMe3F?=
 =?us-ascii?Q?GX3QUImDObPuXnVISKDBg0ZfWOGxXNOZpHXRnDm/JPqnLFDPVFaTeinVoyId?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	EEG20H0t7bizxucQoGmdcNjNaI9eiCkAUFVaqomhdqxktUE6ctSYdr6tLZ9Ip5PRZYDeKqoXngLdRdCsIz6DRc6m6ou+I+LY4HHjdRKINIz8xfUL9TcynEVjtME+fSUhZ+RXh+XvxYMpiCwAlpFK6gCtz1StMQ9qYHV6wZYKHZ2yj/QZOI3liq1Mdh1mGhijxtqQlIqX62+U0AzGh+1OyC2FVehv1q3vVy3JyrRg3KJTfSvz/4epOuZCxRb3MRrSImIujfVUjAiwwo3qJWrGR0FLfNdKAM8rCbxhj2Fb3f3bLbGpLj94hrmnxlPYtQEoiEZ9sF8TGJ3IbLOSFv43qfEnLMGB4I1uaCeY/Mga/NBDFJrbQ3NWuBJdz4hpbzo29BU38/ZxPbxaZMfBcJHe0SckS5mQwKCpSDWt6BIEuYDVioiBve3aL5g34ou/+fhjekjkLu0293DEQef6jT9/5nd+T419tWEXghkI7HIrxYscspqzvOijwipUBuVURj05JClY9XIQFOxWJSD0f6olMEDi2Sv4fBDd6zNR/NpG6iZzQkOPNR19EGYEqtxz6UIVo7X7YEPtugy9HVGcTg173h5F/ZHr32V51JjSbwnkOqQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92370f2c-740e-4e09-f18c-08dc9b0906e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 02:37:05.3911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1stsh/KxoefJGjsZz9x+rcYPWFW6qeimIJ6PZdHr9Fm4kavJMKShykNJLXAft4XpoIyyWLf/1oVf4fTrthjCeVIS88O3hwCRlXtTA8HnUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7121
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_18,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=824 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407030018
X-Proofpoint-ORIG-GUID: aFTRpwoqC8_jCJkUs5u0EjqNJibsXwNq
X-Proofpoint-GUID: aFTRpwoqC8_jCJkUs5u0EjqNJibsXwNq


Niklas,

> considering that the libsas change is extremely trivial, and that the
> libsas maintainer (John) has added his R-b tag, I will simply take
> this via the libata tree.

That's fine!

-- 
Martin K. Petersen	Oracle Linux Engineering
