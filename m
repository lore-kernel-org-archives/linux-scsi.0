Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B122772D;
	Tue, 21 Apr 2026 06:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776752378; cv=fail; b=qYhidB/7sVY5NKhp2P1dKYG3QCIbvnJxczmM/Y0Pkx11F1lnpbwVa5zcf+H7Q/ErTD2xNBP17nF7BM0zz1DXrYfTnQ9mQR5XWBMwy2fiFhOeOZOA7DlAC7qsy0ZpoCqR2Zyb9ovn26I/REPJqF+BLwdjIqewrFopqF1kzAJTKrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776752378; c=relaxed/simple;
	bh=0JHeLH+ASxR1DEb5ncGUCI71ez8nNbqmHmX9VKss+10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HusHutrmG99DcLvEin3Wk8FO1jH3lca295GgfYtnJSpoBpKa8VmcrYJDN83BR8GXLOZvfHyqXWTQSNEIU3Z89ktGKr+mE2uBHqCwbsTbx8NumIbhUNhkkDycsG0PIQj6KIjBkI1H30rquF5RQZtXdOLiRM/SVu1IxkQZgYIzLLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Rw0cSEPD; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ffxVspYf; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Rw0cSEPD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ffxVspYf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776752375; x=1808288375;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=0JHeLH+ASxR1DEb5ncGUCI71ez8nNbqmHmX9VKss+10=;
  b=Rw0cSEPDiKRK7hupXXrkeDJG9GEFIr8E3tN2E6F5FmOd1gSXbHPEFnr0
   U9k4Xr9Nj0zQCuQiRbrmQd6xDS+ZfaXnZ1k6LrALcnzevY09E2F+GhTHP
   WBeiuULY0dJOrGSL6Buw21hSqk6aIE9fasnhzurXdox3Ic9MPzYkRNVa/
   XGq407hvfiI++ezk8noTAiyBOxUSkTM3SCBpRqb0FSWKVRAWpcw+Dr4Zz
   fG0/Joc/4+OsjrB7ejXgLMvvCSItQ/8QpEBSBhDb+PlDxv/vLItkNbsWw
   F88lEglmzdguNi8p4JqbpBs+gi+kEvUpc9HASwFj3ijdyfb8L9WiG1Ir3
   g==;
X-CSE-ConnectionGUID: 3kVdtP63RkypaQqlmsOStw==
X-CSE-MsgGUID: Gvp/sku7RrqA9aCy5XdIHg==
X-IronPort-AV: E=Sophos;i="6.23,191,1770566400"; 
   d="scan'208";a="145350666"
Received: from mail-westus3azon11012011.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2026 14:19:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M2Sd/N9qfVtEP1j7mxM2rycA7Ylp5KFElxlGt+HUnaxm8Xhrm5cco9ZNak7U/PlSXiPKNsrDb6GrjAhiCMROJcC4iiprix17rMlhjUGaF/q4F2O/j8WgckFX1uICwoh7GCoImvfytbTEhud9l8Dpb5yZUuDySeSFUU9lqbACdTvBhbCfKeNYSrEAFim7iC6xx+R9uDfYm5lTW8j8D9RKa9kr+/9E6Tcze9lwgw5onVI1pQfKJG8/TpF1L321zux0ogPxNztZdYAN3d3YJom0wiQpEd5Wfchhkajk7mmf0sn2jOcxnDTj2WKWs6WRAfqNPUx48A6z85/Ixn/5ypgDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7xRne7pOz/7VS7n2Ox6uw7bTByXCX90HjIcYrnlwWg=;
 b=cz51VdjtMCAgKm3G8K84oeqwJDbG5IcEhQoIlJm2/PcTwh6xK/zZ2IEVrO7B5d5a70nZzT3EnmrdefRRD85SbEyUsBtCdtVbI7v7A5ai3dpREaOQjhhTG4uQI4oBfydOY+sDHO4m9mEu3+whQqNNxQkiea4UVm/FgmgKLZAxn0j8WRq/kn/w/sH2uctlAmnhfcLn/iLKqnhy5s6Qi/a/cpU8WYoeDXdG/ZhK58ufDuk69L8KrDFRCJuYslyQaXruo9faoEBbzD0XUM5fX0SyhOIB5U0gA0lrGESvrxwP3Ku+qHSi8BA82eXPXwrqKdyoB6bfmHqSkIX+q4Il9mZGyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7xRne7pOz/7VS7n2Ox6uw7bTByXCX90HjIcYrnlwWg=;
 b=ffxVspYfWkbF4IQfFZd4m5PG1TK/592ut3ViQuZS7kJ/m2kgFwHG0uzLe04qZG+7l20hPJMY7Mw/bGdOaV3QQv0vkNwX40qVyUtPu0K5MToRoQGZbnyM10UcEGc6vacD9P0CbJv7am8GGyI/j/jqmH+IVmQj3mrDZhHG70IxT0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV3PR04MB9465.namprd04.prod.outlook.com (2603:10b6:408:285::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 06:19:27 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 06:19:25 +0000
Date: Tue, 21 Apr 2026 15:19:12 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Daniel Wagner <dwagner@suse.de>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Christian Brauner <brauner@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>, "willy@infradead.org" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, "amir73il@gmail.com" <amir73il@gmail.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
Message-ID: <aecTw6IYs1fo26EX@shinmob>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
 <aY77ogf5nATlJUg_@shinmob>
 <901f4daf-3226-416f-8741-dd15573e736b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <901f4daf-3226-416f-8741-dd15573e736b@linux.ibm.com>
X-ClientProxiedBy: TYCPR01CA0155.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::17) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|LV3PR04MB9465:EE_
X-MS-Office365-Filtering-Correlation-Id: 30972d5c-c00c-43bd-6e9f-08de9f6deda8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rhDD9fJHCAwjVB8nr2Y2IPd1Jc3Zdq91vdcvlKVj2aq2nykyh4vsSr2e1LesIL1z1aJp+dZFQRKjj/Q0j8jY/Hk7T7c8C2/re8D3WlzRa90hKwqDQpUFpA+ULoyro3JXInSFHNs3RFaRQqVB8jRJ5LxLGfr3AT9XKpFHtIOhUSUspMo+L98Ow8LbPaU/kjkFzCeuDWQZdLZvaUCYOWi8uPCbspJfoSXFQcr2FPGNx3DmQbqPjt5g0Z9hYNeB0/jCy1T00DEOIl6e/AnfR6P+POu500dnJoVfdokWY3YqXiaGdpDWgY/3pRoTqzIbXnRtWIVN5Ql20whc5oDtyDuajBQ4S2SBHejwoSX5xImjltTgk2Xg81Sb3jb+i5Xcis5HaFwPOvtak9wL00CPPAU6iVpZ6pACurZoiEzO7J5WqfPgNCmtFGrWTe9o+bX899QCqAhDYfgnzLuiMXfMJ/Vb5tn1zPtka+lW1PQdmz5ekuxez4FWvmdihPytX0GvffyBjwtpLaPSfONrw475nYgElZdMsrhVEOqWGI3O6k+J4JxF5f/4J578sh39ZX+iBynNCie0P/jiIqAt9j+yI9Ns6zd92Pn83AgExIfe69tsOROOW9uQMIcbJCpYVQmt23v0XSOIyWaSdIV0vIv8hEOenhGU9JgZbqWo5+t2F7N44KkEYAw0XWXrDi8c9LPAfsrs5AZ3izE+PFZ6OIimQrnf4ER+TpdFqD/pSk7MEdZMjq/vNsMjDMKkRKlEd4hUYkEj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzV6QmQ2cjNZQ2VnWEwrL2ZIQStTQmV4LzdnU1Q3SzhRNUhkc3BJSHAzUEc1?=
 =?utf-8?B?Y0VaK05xYXFDeVQxSUwzcVJncUJFZWZCKzFsYytwaHhka01wTFJENmRDYVVX?=
 =?utf-8?B?a0RwRTJzT1FUZE5yZkxGWUFmNVR1cXJlWW9OVXZ4VHIrTG1ZdmN5d2lHVjU5?=
 =?utf-8?B?Mk1TMXVZZGRDNkVmRWNNTHBMU1BxWGJPak8wQmFSRnBING0wdE91WmpOelFp?=
 =?utf-8?B?RGVHS0duakJ1NWpLS09mRjV6ZktuYlhhWG96UnA3K0FoWUxaN1U3NGNacGEv?=
 =?utf-8?B?YldlakVFbm5VaWR3UXduaUl5KzZ4aktUS1k0OEtWdzMvdzZranViR1htZGxD?=
 =?utf-8?B?TDJUUnBYZHJVK08vcUhESEgycTJuQS9CTkIyQTlaRXlIS2RPOFNSZDlWZmdq?=
 =?utf-8?B?NEN1NzkyRHZKSGpBSXlIUUdLMzNBMXdUcnJVa015a2hBNG5xZ2hwRlNuYW9U?=
 =?utf-8?B?RUw4M08zOVhlU1RudTNCSlcyVmtnTXZvTjF4d0xCdloweUQ2TVNmeVdlNHpn?=
 =?utf-8?B?MERmVER6Vk93TEdRM1YvZ3d2K2NaTVE1NFBQbXUxQnJwN3NQTXVPZzdGSUZp?=
 =?utf-8?B?OEJ1cGhUYm5Sc1A0algyRjJncXd6QWlCNVRHRlBMcTdJbzVYcC8xZ0VDYTF4?=
 =?utf-8?B?VklKVnlhNmVITlpDR01naVR3Z2VxeGs0OXRCaG5WVllqaEZrQ1JLSWFoRWhD?=
 =?utf-8?B?L2JVR1luMzJrSkJ4aDgxL0FRdVVMU0IwRzVtZEZBZTF0KzJFcFBDalZ6WE1P?=
 =?utf-8?B?TnNlUE1JZlhGYjNKVCtFNmh1MXVpeXdPSDREdkZxT0k3NkJkMWhDYWxqbWM4?=
 =?utf-8?B?OVJOaVJMK1hSbkFOQkJ4d1VaU2V2NVVxRElIRmZZOFVSaEd5Nit5VElWZjhP?=
 =?utf-8?B?TENQZnp6YnRmaVgvenpjNGpjQnh0dEQ2b3BZYmhheWZwZG5Ld3F0T25WSjlX?=
 =?utf-8?B?TXJkM2VLTE9EWGM0MDJGN1VVdUZhTDJCTGR4aFEwZ1FiOUtaWjM5L2hyOVFM?=
 =?utf-8?B?TzBTUXY2M1B4WlB6M3dpaTZjSWRDQUlKbFVZOUo4TXEwWGhDUVp3VEhRYWRD?=
 =?utf-8?B?M2lISjZrSmcvTXAxZ2w0SmVkSzltbFZVblZLMkxTZE9FNW1ScHFxRHFGTUNK?=
 =?utf-8?B?RUY4UzVhL1dtVCtNTmpCZWlxU0dtQm5rTE5DbHo5eTJqaTFNQUVXRmh3Wjgz?=
 =?utf-8?B?eUROVU9uVU85NEY4aWdOWlFzYmdJT2FHMktGN3Exd2p5cWxyNWt5bG9IcUlT?=
 =?utf-8?B?WExnMHNXbDd2T0pZaHZJWTBRSGw5S25ST0lNVm8zOW5kRGtDbTRjV05neUw5?=
 =?utf-8?B?OEFUQ1pNUnR0czE5b2VnOGlhMDZqcWtHL3hPZnJlRXlQZWtDa3FjWlFWQVla?=
 =?utf-8?B?REg2aHVjbS9BMW5oNW1qSlEyeEVseDE3TFhsQmlveU43My9MTXRnTUlxa2Ni?=
 =?utf-8?B?M1NNbi9rQm9Ua0tVMUxOVnFiUE9pMlNqWFNSZlgrWDVtZC80YllhcHp3bkhh?=
 =?utf-8?B?SEsrbVJ2eDRPNTdIdXhQVmhOWU9jRFRWUytyNmgreWFMbHFqa3Y4bFpEYXBN?=
 =?utf-8?B?UFhBaTF3Z3NhVTZtb0tmNGRXbCtEclNOZnBvaVRKVFpXRjJuTGtBd2ZYVzhi?=
 =?utf-8?B?eWNhalFONXhtUlorN3BBQjVBOTl3NmlvTDdvR3ZsY3kvYmMwNVBDa0hqSW9s?=
 =?utf-8?B?bXROZGZLUU5aOWRLZ2NZbmozNVI0N2pTVktuZkU5VXNxYmJnMFB2T1lndUZ0?=
 =?utf-8?B?UEZQU2QrVmFkVlVsSVh2VkdCOVVOd1M2L2tzTU5jUktvV3NHOGNUcE5ITGhU?=
 =?utf-8?B?NldhT2VuNFQybG9JRTJKVUxqMGNUS3VKcnZ3UjkxZU1EajNoMkFTd05iUkxK?=
 =?utf-8?B?V3I5R0lsN2dwK1NEdnMxSmVpTjlWb1llalo0UHhSczhzNnV5MlRodGJ1QVJ0?=
 =?utf-8?B?NVZ0TW4xbEg0SE42ckZ0SysyYzlVblJBMXBDSWh4enFTR3NzTTB1ODRjTE1T?=
 =?utf-8?B?dUo4RUp6UkQ5RjFMdTBxbHRnQzBseUR3ck1zNnZNakJxVUJ1RmtMTVVTRFJx?=
 =?utf-8?B?dnFodXoxekFVOC9vQnV0UyszeDVIMERmUUQzODNGRUoxZmphK3BUUk9CYUo3?=
 =?utf-8?B?K0R3bHFFUUJBUkRtK0p4V3NWWW02ZDltODl5S3pJeXZSWSt2b0lFeWx2bVEz?=
 =?utf-8?B?T0JlZmFyQ1dHRklIUEQ3WVhTZkxNMnZnY0dCV0FkRktXTnlWc29OTnVOYzJY?=
 =?utf-8?B?NG5vZ1htRWlSbERXMnhHMmNjc041Nm5rbnNxSG13MllWakxXMEU3RHBBRmFu?=
 =?utf-8?B?TUFFMnhkZWozM1dZNjk5blEreEhsb1ExbkxlRHZxWGMrS2R2aFE0czVqWFNF?=
 =?utf-8?Q?DdrrWKoU6s1F3sEY=3D?=
X-Exchange-RoutingPolicyChecked:
	DoB1/F68UlpW7J85GILIOOLFfwYADOF7HvSGbej9xcrTYtPCp7uTu0LpBBVMfkbw1c5QCOptUVoxwa8/9zwmmYZ5UAHHmpuKxeOFJpmZROCcTcKTcWrEn+wnkQVpXM/oBfUzOwQpQFAPD1PS/G+AzsF2ehqhP0TtVMewQOjhMyYpEsxI1L+IssGyPJg0fnwS46rbi7/o2fZMVCjLOZlnVPyfODOLFMyJsK1hCLSC3dbqN9cupJYwE3QzDuWqrNlgbhgg1ikYf8H4bAZc5qGBSg4Dd6owLu6+QBPdVAJBiH+7xnAe56lLjAZeYtu1sNAl8xC/NksRh9Fb6RFRgigvag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qOXDjZY9fP/zdOOpxbyEftAYyYSRzv/UM88O5IvuUxE/XwAGoU46MmDY90jvJ4iZB9UjLq/R/BypQicStAWPsk0W/Oa3NWOlZerPzQfG7J39XV9OLCcE5gl8oVDzSL+qCbuZ4I9sba+6G8gXInpFaNFYfqV0Um0NUtf1tWQ73I4x3lvBlElIlrRNzf696FPk6HtrmOwAllcguhrQqnGBgFSY/+PNUhLTy93mUZxfhpuWXmoibKytiidfjgwOmBRgBo7x+c2QoiptHtKZgPBjZDScP4bk8e6gRsHj74WuygWatHQcnoN2eTrQ1umTM+57R0c90Alunkvf34G8wJcAj1FFE6mV07JPlNVuV2jgkAV3Rx2MNFim2MS4928nFq1Z7Tkob2m0ouvVYJ6wkd6sB2BsQpsmkr5RiAj3G1nHtoi8xcq0zOVLk1MNzR20XfObS4ZzrXlQ54xgtbx0lgBRIy3rj3jYgzWP+RmU6t3Z0tmmm4wd19rHSScPXSHHCZBAxdwW31TuMeM7mR1kNeALfVGOoSN5IEdjwOjBXg8Kw6S+gZldjagBrzSsq+jVrhNX/gEgPQQgTk+Y+dfe7xA0dgZimFBwofKuohTaO7gj8YZr2Qn2GttI4oC3yzn3Uw2L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30972d5c-c00c-43bd-6e9f-08de9f6deda8
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 06:19:23.0238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AZD8aBf6qoltFduApXfM6Iqf1yhlwvKKp4bQ8OOgkkr6ET/MN34oputUKnLuu15mGiZNN0dHPG/hkYy/0AkQGXZWFX3zVKnRANPaeiUrFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9465

On Feb 16, 2026 / 00:08, Nilay Shroff wrote:
> 
> 
> On 2/13/26 4:53 PM, Shinichiro Kawasaki wrote:
> > On Feb 12, 2026 / 08:52, Daniel Wagner wrote:
> >> On Wed, Feb 11, 2026 at 08:35:30PM +0000, Chaitanya Kulkarni wrote:
> >>>    For the storage track at LSFMMBPF2026, I propose a session dedicated to
> >>>    blktests to discuss expansion plan and CI integration progress.
> >>
> >> Thanks for proposing this topic.
> > 
> > Chaitanya, my thank also goes to you.
> > 
> Yes thanks for proposing this!
> 
> >> Just a few random topics which come to mind we could discuss:
> >>
> >> - blktests has gain a bit of traction and some folks run on regular
> >>   basis these tests. Can we gather feedback from them, what is working
> >>   good, what is not? Are there feature wishes?
> > 
> > Good topic, I also would like to hear about it.
> > 
> One improvement I’d like to highlight is related to how blktests are executed
> today. So far, we’ve been running blktests serially, but if it's possible to 
> run tests in parallel to improve test turnaround time and make large-scale or
> CI-based testing more efficient? For instance, adding parallel_safe Tags: Marking tests
> that don't modify global kernel state so they can be safely offloaded to parallel
> workers. Marking parallel_safe tags would allow the runner to distinguish:
> 
> Safe Tests: Tests that only perform I/O on a specific, non-shared device or 
> check static kernel parameters.
> 
> Unsafe Tests: Tests that reload kernel modules, modify global /sys or /proc entries,
> or require exclusive access to specific hardware addresses.
> 
> Yes adding parallel execution support shall require framework/design changes.

Hi Nilay, thanks for the idea. I understand that shorter test time will make CI
cycles faster and improve the development efficiency.

Said that, the safe/unsafe testing idea may not be enough. I think majority of
test case does kernel module set up using null_blk, scsi_debug, or nvme target
drivers. Then I foresee the majority of the test cases will be "unsafe", and
cannot be run in parallel.

Also, parallel runs on single system will affect dmesg or kmemleak checking.
We cannot tell which run caused a dmesg message or a memory leak.

For the runtime reduction by parallel runs, I guess blktests run on VMs might be
the good approach as Haris pointed out. Anyway, this topic will need more
discussion.

[...]

> >  4. Long standing failures make test result reports dirty
> >     - I feel lockdep WARNs are tend to be left unfixed rather long period.
> >       How can we gather effort to fix them?
> 
> I agree regarding lockdep; recently we did see quite a few lockdep splats.
> That said, I believe the number has dropped significantly and only a small
> set remains. From what I can tell, most of the outstanding lockdep issues
> are related to fs-reclaim paths recursing into the block layer while the
> queue is frozen. We should be able to resolve most of these soon, or at
> least before the conference. If anything is still outstanding after that,
> we can discuss it during the conference and work toward addressing it as
> quickly as possible.

Taking this chance, I'd like to express my appreciation for the effort to
resolve the lockdep issues. It is great that a number of lockdeps are already
fixed. Said that, two lockdep issues are still observed with v7.0 kernel at
nvme/005 and nbd/002 [1]. I would like to gather attentions to the failures.

[1] https://lore.kernel.org/linux-block/ynmi72x5wt5ooljjafebhcarit3pvu6axkslqenikb2p5txe57@ldytqa2t4i2x/

