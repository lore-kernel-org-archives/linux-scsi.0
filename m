Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D88A935;
	Wed,  6 Aug 2025 02:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754445984; cv=fail; b=spVPDNCNsEvhBm1AnOTmu66qHtL5wyRZ5i/shPbEJswWCdiRLKePVK2M8d2XeOva4sXqBf4i+M3QhClVIaS+JZYWfxCLYf0yRc+CMuy/7AnIyZx9bIGl0gHLJ1DuS0GmdCTXBNZtKJfuylFVlJNfmwvOXwLrYem/3NbVlUsLJTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754445984; c=relaxed/simple;
	bh=U3GB8ZQ6t3aRpXKD4CWyt9koWtV4Y4+rq7H/CjjifUc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KqBwpPGhK43TayW1rbVY4m4SvQm5ywglG7ZPv1yurjNp2gV8MSJmxMUxn0I5tZmUNDwBt9929xeJ5EQ30NP49pac9DrPZAuN8J9RELoqvzmRHTqzza5PkB53aIRXNWNhUylz00rLicf6ilFNemwXXKP3eVk/stAlvcl0waQtaTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E7mNwolN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kySLt5uJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E7mNwolN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kySLt5uJ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761u3n8018494;
	Wed, 6 Aug 2025 02:06:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=diS1GaOv7RVtMtoSd1
	76PkEFD2FTCLxzONPtskcQJBQ=; b=E7mNwolNwOyGxfKKi+qg7UyiNbheQzw49Q
	r7rxJk0hVMZ43ViLSZLloNk/PFmzB5El4zF5KidhuKd5a9bffF1VcayJUbbNqeMY
	bUyPOCMzJno3uPxP7fNzNSRKFFunZw2Yzpn4wMoQyiGw2Ugzq+TmlCVCuWQwve6m
	74nHvD1xQjZMIoUuwwoW5TBs6Z9t9YsRhuHoEKYdjToq9sV0sGSRg1M3VLpsk6Ft
	bZT6/ZRTE5hzYiH3M2v96i+HoQAGz+zcK0HRlfxqIDAy1bOXV5qcDi2paWsH0mV3
	cFYPHtPOVVakNWKEfwVZqOM7KyGvWeUP9cBXQ9MEb38hRpmrR0gw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve0kq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:06:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575NNILW005633;
	Wed, 6 Aug 2025 02:06:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwwd5jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EAo2jmKSUVfPfRmZ1t7Z9SB7yhQ3pshLNkXLDP7bqMdkwkcUUOXYIMvHgW27GQ4jNm28r/J2QWawfX2CI4hN7Ixz3ArYLdkf/R586ukbeXtVSfXjJGeyFZ5geA8OnCxoIYKZU4qePkxLXM/kDM8xfBe0j9ydzwEVOZbZ99SRWpSYgRKR8hHjA3I2mdoXPJ8oxBpQE6DsTbX6KBBJtcFIzgAEN7BiTQ3uuZTj0EzKeoEKeG1eyf+7AaVkrjM0tFxtQj756lSiiZPdAB5xBZTTjflUnboPKl9wdpGguKqtUexU4Z829gWAXRJCVkS/+dD3qfaMJhbwzvt2tbzvCn21/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diS1GaOv7RVtMtoSd176PkEFD2FTCLxzONPtskcQJBQ=;
 b=LyUJCIUPGUaFqbQGX6d8eUccwPIeaOZRWQvg8AThcOVVFT6URshrx4MrjGtsbu6mkFsGuSRBrQfTN+XNVZhvBnR4z9/Us/7wP6pguuZk1LPVkffximbEVpfqZI/idMFzTKrj/Vvyw/vRjhQZ9UzqnX12C3+VoSiCw5MQ8YezBL4N8AoI0lxeXn6RQg3li1kpJG6+QOAM3kLOfjt0GolGRT20oYJ4pbtosvgaPqKLYu+Gklrpae80VNtP+zJ2JkNpQdC99ZE6zrjmPcxbb+Py3/VOylO4A6NFl1wCZUYAcu6J+A9hIT42BBtEbHqRQ0V179G7VRAJmBOFUtpYdaZ89w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diS1GaOv7RVtMtoSd176PkEFD2FTCLxzONPtskcQJBQ=;
 b=kySLt5uJRmInhJGCkuvDDsE7QIORzWt2PLMq1EsO0WQ39c4q/N+tpaq/rQaskvTGNdHMHQRCrSXdUC2ftmBQdV/M7cl5/URXfX7aZ3BmP+OAVh6SsqpiMckRspOtCgu06hBGa/enAk8VGM5mriESfqAuJ1BYDsLgcmKDxe/17Io=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH4PR10MB8100.namprd10.prod.outlook.com (2603:10b6:610:23b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Wed, 6 Aug
 2025 02:06:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 02:06:07 +0000
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Remove redundant assignment to avoid memory
 leak
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250801185202.42631-1-jiashengjiangcool@gmail.com> (Jiasheng
	Jiang's message of "Fri, 1 Aug 2025 18:52:02 +0000")
Organization: Oracle Corporation
Message-ID: <yq1fre5b3we.fsf@ca-mkp.ca.oracle.com>
References: <20250801185202.42631-1-jiashengjiangcool@gmail.com>
Date: Tue, 05 Aug 2025 22:06:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0069.namprd17.prod.outlook.com
 (2603:10b6:510:325::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH4PR10MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d6c394-eb60-4c8b-d895-08ddd48dce2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KUT/vxdaPgDlUsf69/2EDmwAExO+e9IrV2xfUdV2fkd7OJN7f0I/0b3MCyk0?=
 =?us-ascii?Q?gNUwlMAqEZ6MZ0d3wihXAKoPM2H8PbIJbX6ckoqRVJ86NMy0IPsi01xMifDj?=
 =?us-ascii?Q?18g8HmLwn4p2oGJMxuqlQQ6Hu+5yffODqHdJzGx3I/+maZnHxKKReU2GN+Kg?=
 =?us-ascii?Q?DHRtmgm/O4/xkD+0WQKgRj2X3mEJJdKMJfYfxN5Kb88XtV6P1MVw1KdGqpWX?=
 =?us-ascii?Q?Pq2uMjbBi6qCngmS5yQAFIcK+jqGk1Omw7pkNDejiiU0RZtC191QSCivfIaN?=
 =?us-ascii?Q?SQ/NnQUIpXusJrGPC81zJV0xOp+WipigjwRkqf6nYe/qVDzRRQ0Ee0AyM9Um?=
 =?us-ascii?Q?SQUdORVdk1KWabe1+3cYhZhoa7k6b8f8R/6y6bIJHYQ+uWLkROAP2TVJ9u+1?=
 =?us-ascii?Q?FoU68OhAkQTl2n0vsMQvMSCYbXWwV0kapfC+Iiog6Aqs7k+jmTHEGVPNVG16?=
 =?us-ascii?Q?ghFucQGvsx2x9luw7HDBLFc3YUOTK56/GJrpD/SRsXbhW/ZLelaydYsxCuEe?=
 =?us-ascii?Q?meKzEpMX2NefoOg8PQVtxaKJPeCUV+80V2QzDKAdGOYElh4HE7am5wWko/YZ?=
 =?us-ascii?Q?Fq6w3NO+RMGjJFUEVQ+O+SD87kCAe3xFi9Fl8mp9oTiTIcBGuBBYCGdlHAaA?=
 =?us-ascii?Q?0qx3Ju6YWt/FBeb6WEnWORJqkfct4Qu3lsj8v25np3MTS2+QfiG2Rmm05j6i?=
 =?us-ascii?Q?SD//ubAuVdkeVYf3psmfhayBb22Z1SmuuIIWZWoDxyiq6vdun6opQXk5NjvZ?=
 =?us-ascii?Q?kWjLHKq+Ddt1oHuIQJaSMD/bs9yEAcM2OG92EXaMfD7ZPoXZSx0SWFTsX9zo?=
 =?us-ascii?Q?SnzdEPVm+O4Kpj98tT0L2bX9V6fdgl1C93T5IuEZFmbuIU7uoVyPyMpywgHi?=
 =?us-ascii?Q?N/Ky7PgnNA0iECqNswOHo+hf4xWYi1tFzDVowiRLNrKsiBiX4Kh1uKIICEDR?=
 =?us-ascii?Q?gtMhlbQxbZaKbiNKB9HXn65c0104/jYwxhuagSoXPfBHt6adwCwKxeWH531/?=
 =?us-ascii?Q?tODoU+rIvnbT0xOilSg22ZAeM5w11PjzL7zdnxIWEd4P4Whyw8xwmufwhhLY?=
 =?us-ascii?Q?rqCng5dEr9KYYYVj2taP3X2jDyHRtDYO2NjCiZ6t67V73S+BXzUm3qT8aVvZ?=
 =?us-ascii?Q?9kK8xofletxjE/h0aM6Y8yEfHbuyF9kD0HYkX3fz3i0wG53CeNF2kEx9lDbG?=
 =?us-ascii?Q?DEG/BqxOB6txqDSD18HbdMaDmbzqlbUIcqiyee0UykDz4/pmEpt2+JTUBPm5?=
 =?us-ascii?Q?loeokECVjlx0QE+wOjwGhlPu6zCVum+coo/TFLmUW4tf6xcONpy+Yrz7qAlH?=
 =?us-ascii?Q?dHDOsMruX6nfMyYdcVudehH2V16Z71kH1YZ7U+6IfZ0gAk70DgDy15RoOfVz?=
 =?us-ascii?Q?gkW5WP4j/TPX6A12sbrCESl/DryLwhxusjukTvoog0/f/W4FVHbNjNwUkEim?=
 =?us-ascii?Q?Hy6ud+oZACo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rIKOnJAgn/woMvduy/a5be4Gpo2gHeOl+wnWDcHW8KTmofhVrHJHh4V+hA4n?=
 =?us-ascii?Q?ZqG2rt2s6iSXL63CEh0GbGeyw3CMdu9cBHM9FN7DqKnaPBvgPM9GjoFymLl1?=
 =?us-ascii?Q?wc1GOVMwWoitIertpfK69hrmGi2iI0MM/W/NGcfhRwgY1TDwV1kWxqoTV4U2?=
 =?us-ascii?Q?63hNqeJMGuAyzv4icWpN/0Rajt2/4+iNnbinXEqHwZ/Yhd8NhW1FdWMOOSyb?=
 =?us-ascii?Q?keRFXxFMnfdMGbBMOW/WRJXJHlUuOUiq+LJqBWRRebbMXBgkYKe4x48lZ+xV?=
 =?us-ascii?Q?O68IkIEWIOcgSyxgZQAQpkxvRWMMhHosZBIwFbLFaCtp5GmX5mojjZIqk0ZG?=
 =?us-ascii?Q?GkRtpwvmsKIfAQjvVVOIlmCvB6V5IlZUVpR9iByI2+czij0sXqQxIhjGHqKu?=
 =?us-ascii?Q?OJSQpHP3dtBJxH/nlGEEH9+yBqGhjKg8sIkNAFrk5HCCrhEc8V2AimAAP2RM?=
 =?us-ascii?Q?sGmu7jWwM6wVmjImKKe896zhkwktndAaV1ieKSsY+MceoR4ZYHkFrtxIIdnQ?=
 =?us-ascii?Q?zcFeAdpXGbGxwYy/flcFp6sa3CIVFpwImYULbqKXa9Pp3aTsqP2ck6BpKwRW?=
 =?us-ascii?Q?0w90W4HSryalNWHKJJq8p8fGWNKfy+JmbSjkkSzTpVuNamowSOOgHFKtjj4q?=
 =?us-ascii?Q?A5A1tfGMb8M2D+0K+9h6Rt70+PLSfsgdlRh7YpoKi72QdbRr2VYCWevf0lJX?=
 =?us-ascii?Q?UrlA/sPTrIm6Z2vZO5owWQQ1zG1IkjZNziikf9YHjER809G/FzvlHdsuqaCm?=
 =?us-ascii?Q?husAIbI037d0eT342W4lhHhvUIKhagn7yN/rHBlZkXmLgEHK8e0dpwVD+aHA?=
 =?us-ascii?Q?TfP/bwNpO2XBakuCLG+7VDDDyMKMDYuBDIbTtAq7py8AQGyLpIuDOIzatshj?=
 =?us-ascii?Q?MjlKCJ9WPUJJy8yT97OsmMb+sKz+7z+j0d3sXxfwLZf9ZekxvMEZg33irowc?=
 =?us-ascii?Q?5Lx+jr1trwAb0BaZtf46DSkbcMojgyhfq4LoEHrW7V4Od0m69lUaEjq/SIVb?=
 =?us-ascii?Q?AWhT8Q3AAtgbqIf1ft6+AeOdRex3zCUsBQ8MrhxpQlWoJGJXRlom9kGYIrrS?=
 =?us-ascii?Q?Q5N+DHtmu9xMjSH3ZOxpZT+Wr42O7sPhVy+Hjlkst/FPuPq9q+ASynZm6IUR?=
 =?us-ascii?Q?69Nd00NsAx0r1wkTzfXVy0eqospBVCXxli1ck5HRd6nySGMpnojhYMEEN2Uj?=
 =?us-ascii?Q?m6h/qqEXR/MxoUR6TFwBP2xbXMSQSmeo8rRIkQUhRcxssdIEEPGt9ADqi+0O?=
 =?us-ascii?Q?K8lxBjsD25OAcdblSSVcRVr4vsAbMOy5dQkaWyPGhkVFrckNL51ALV/VLqI+?=
 =?us-ascii?Q?/wNlZWtho5hikeLAKixLheA4qLvXeCsJSUCv/MoXfhF8Zf1DbXaqQgoXBMt1?=
 =?us-ascii?Q?2jSn5YUj4PB3QbSXWIJPxvG4RSeuln4x+QgFgyZRmNGgNkasUD9H6Ji00TLI?=
 =?us-ascii?Q?1i2eDymZ42uC7fZ6SriyUQhGVNdEzD+kkRLE3MGTgoQqCA+GvD3yNO3+oDWR?=
 =?us-ascii?Q?6dQDMqSw6cX5EkKhBxN8dP/TKB3XSdkifQ9KavQp7CfSIU4u0Ef1Pn4wVLxw?=
 =?us-ascii?Q?FhWXKaFHtHUhqImmDf3KA6gI+hFcQefp+mKdwqKekG0iYsoQ0dZzJU94qeRn?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tWVKjX4oRGSBGuoAF50uBQCvkLqAYmgK1vX6IEP9urG03eJJVmwzHtqt/Q1qRZW8gct9TAVubjinpqALJuCcYCuUwEjdZzPWY+3TURx8QKmM1MD5bVWsdaReBQsddOdVZYjEzMyTn8iguDEYK4aae3AGqM5BfAk78EQAIK3EDW/aDUKvZJ/oM1CYpGpyAbwS+pyBPF2eaRrySK8BrLDLIPwaRSRCVJfq3GgMh0NvpZcR9suYuHTHCZ5gNBbQksvfBA2rmSUYe+BvuUfjCSzxxi3BAUi8aMgLjiCCzS+MXYaM57l7m6flVLeofyQKzrOZyZoeyZU7s/LUV2UflC9a1wDKBdOD3zX9DyLIkUzNlnbv9joWz4GTPJkHTP6QeQZo1Klghwe6H3OWH2zLL/ZbJ6MJvBa1nzeiFTezQHWT3qD3yKThdClLeDU8MTygVFBFq77GiwN6b3OU/qmc2bNURafnJlvwqaRWWoNXE9EcRQNcFjkGl26VlqApRecL+jlz1GMcnPwQ8LNSJKsPE+0cD2QKCpgjTfvyIp/6wP74yYvdXi6fCFSAExgC/ORNzixxvHjIfHXPkKNup+QfBhLIxqH88je4T3EFcjMyPWmLpFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d6c394-eb60-4c8b-d895-08ddd48dce2e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:06:07.3007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u64IYbXbGkWgxNC78EOm8Uyo8LvPakIRuVkn9bp106nwC2CcO3Rhwzgc9fOrdq8s5scZGVQ4ugOK/jnQC13l20WpDaoDaUWSUjNPmzzIPoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=870 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxMyBTYWx0ZWRfXz5gp8w4pI2Cd
 TazHSiKfEVF10TxqRT8idgMynQtpuTEUue6WgBSvml9Yu7oawX1BDG1QyuzjLtfr9eUcY4RePmn
 SUQimjXES+F7u0RD5V9c2WXPsOwzmedYA5UrpWKf97y8SU32qE7m+4RKRmJdTsSW33cXIKGRpDD
 Tvv2QnRNa9OGCDOoSbtv2r8RyjGgDy6PlKd1xH+fJWuR/qF/PfSnCwjmb5VFf8iigzXh1J9cZTS
 4+ryQNNgbhsWHEGx+b3a6HaFaAqCz4bDF+dXyE4bGPfSy4ZQ2YyxE+xZPXIAU1y0unYs/GJkjw+
 BZLL7EwOftBMWdjOFDbyiWqINvEw4nsw64NMFk9Ru5vTMMrnTDcG5bbH8zkyOh6gs4wlZBPZXOo
 c+lNPSAd3QonSLXwHqFrvCJO5zfTagsFAABM34m+a5ltBjdp+ietqIuhWk4So2gq6/AAILkG
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6892b898 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12065
X-Proofpoint-ORIG-GUID: N4_qbauwzuISlEfgBSg2q3xQiw-yORVe
X-Proofpoint-GUID: N4_qbauwzuISlEfgBSg2q3xQiw-yORVe


Jiasheng,

> Remove the redundant assignment if kzalloc() succeeds to avoid memory
> leak.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
