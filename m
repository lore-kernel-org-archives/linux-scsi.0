Received: from aer-iport-6.cisco.com (aer-iport-6.cisco.com [173.38.203.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE5D3093BB;
	Thu, 19 Feb 2026 19:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.38.203.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771529446; cv=fail; b=ojgFDZtAJN0phmsIDjmZJG0XIwe6DG8Mkb7zhbC9fp52kgPgKLjrOZrbxqxf1x7ey+QvfEA9qLOJHrVCgJT0p8Denju3iZDSXv3VW9jssV13curW8BhK69tRLYv+BooOfy0VkCtQV/YLfE4hF7zSiZQYPCxcc/rNIq4ZCxQWA1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771529446; c=relaxed/simple;
	bh=m0XBlKHTCxlw1dJhZrqhgvkZtbBg2w2hYhqryUfOqek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fkIqcq02wg/A2z/pDI26wrCaRteng38zA6JUqkxolpepwA1vIDscoqX49xlN9/uoCZ82tVJ607umaY7qFV4tzxx+ZEbNBZA+Crhtgujlg97V/Hnfcb2E5C6xQZ+DvQ38ADKFy+4aCydj+NuCZWKKlrEaXZOsqdCFTsIhuVY4sfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=dNI0DkQR; arc=fail smtp.client-ip=173.38.203.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="dNI0DkQR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=512; q=dns/txt;
  s=iport01; t=1771529444; x=1772739044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m0XBlKHTCxlw1dJhZrqhgvkZtbBg2w2hYhqryUfOqek=;
  b=dNI0DkQR/tyM/tAy8OxTfxpCdpsFP43x1d5jQU/fqALzaF/HyFaV1HmG
   btA9JbvbmzlvqbVilEzLffuRZqua0DkdtFzIvxzK3Y3/0HSQsoF2ClWqM
   xHr1ty+m7hB4ZHeGpkqtHXxOk5WyYxWbUydVw9OFzch0zm8iGKVsQ4SQ3
   se5OipZkotxjWnWxlB2TPrIlJ4kjbypJrbI9qYC0YBNsaVjbG2ZOowLyb
   09D7zEmAvYSp2LrwEux/UEE1vNyBIwjnZqSdW55TCh1+9Lb9rM+CmeUkr
   vdTllsUWf2mk55Cquw44GaPcNYIX769sB4z1A6T8/BBaTDLybxjIgojo5
   w==;
X-CSE-ConnectionGUID: 0WM5+Iu7S4OwuYSi+DawZw==
X-CSE-MsgGUID: +WmFArdoREKAeHy70P9jnA==
X-IPAS-Result: =?us-ascii?q?A0CPAABlY5dp/9FK/pBaHQEBAQEJARIBBQUBQCWBFwgBC?=
 =?us-ascii?q?wGBbVMHgiFJiCMDhE1fhliCJJ4agX8PAQEBDQJRBAEBhQcCjR8CJjQJDgECB?=
 =?us-ascii?q?AEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGWgEBAQEDEig/E?=
 =?us-ascii?q?AIBCBgeEDElAgQOBQgahVQDAQKeagGBQAKKK3iBNIEB4C4VgTgBiFMBhXSEe?=
 =?us-ascii?q?icbgg2BV4JoPoRFhBOCLwSCIoEOii2JH1J4HANZLAFVExcLBwWBI0MDgQYjS?=
 =?us-ascii?q?wUtHYEjIR0XFB9YGwcFEiEqB4FYAgIEghN7ggEPhmx5Ay5vGg4iAiwSXFIFP?=
 =?us-ascii?q?gtfOAMLbT03FBsDBIE1BY4jP4QccX+WcLAfCoQcog4Xg3Gmei6YWKkWAgQCB?=
 =?us-ascii?q?AUCEAEBBoFoPIFZcBWDIlIZD9MHeDwCBwsBAQMJk2cBAQ?=
IronPort-PHdr: A9a23:IelLKxK1g52xYLZ6/9mcuVQyDhhOgF28FhQe5pxijKpBbeH/uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:rxRluaCGXC6uYxVW/0fiw5YqxClBgxIJ4kV8jS/XYbTApD9w0mcCy
 2QfWG2EP/fYYTanLdh1PojnpxkP78CHy9M1OVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jWmthh
 fuo+5eBYAX8imYtWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEm8pLUQIXINIjpsFoHFB19
 L80IS8/cUXW7w626OrTpuhEj8k5ac2uN4QFtzQ4nXfSDO0tRtbIRKCiCd1whWtswJoTQbCBO
 4xDMWsHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237kFEqjOG9a4K9ltqiBvpQsG+Cq
 mX80kfQDzELa4SnmDiD2yf57gPItWahMG4IL5W89/h3kBiQy3YVBRk+S1S2u7+6h1S4VtYZL
 FYbkgIqrK4v5AmwRcL8dwO3rWTCvRMGXddUVeog52mwJrH86guDQ2xBRTlbZZl+5Ik9RCch0
 RmCmNaB6SFTjYB5gEm1r9+8hTizIiMSa2QFYEc5ocEtubEPfKlbYsrzc+te
IronPort-HdrOrdr: A9a23:aDziq6Bbttny9mvlHejjsseALOsnbusQ8zAXPh9KOH9om52j9/
 xGws576fatskduZJhBo7y90KnpewK7yXcH2/hhAV7EZniohILIFvAv0WKM+UybJ8STzJ846U
 4kSdkANDSSNyk1sS+Z2njELz9I+rDum87Y55a6854ud3AXV0gK1XYBNu/vKDwMeOAwP+tAKH
 Pz3LshmxOQPV4sQoCQAH4DU+Lfp9vNuq7HTHc9bSIP2U2ltx/tzKT1PSS5834lPg+nx41MzU
 H11yjCoomzufCyzRHRk0XJ6Y5NpdfnwtxfQOSRl8k8MFzX+0aVTbUkf4fHkCE+oemp5lpvus
 LLuQ0cM8N67G6UVn2poCHqxxLr3F8VmjzfIB6j8DneSP7CNXYH4vl69MVkm9zimgwdVeRHoe
 d2NqSixsNq5F377XzADpPzJmFXfwKP0AkfeKgo/j1iuU90Us4KkWTZl3klS6soDWb07psqH/
 JpC9yZ7PFKcUmCZ3ScpWV3xsewN05DVStub3Jy8/B96QIm1ExR3g8d3ogSj30A/JUyR91N4P
 nFKL1hkPVLQtUNZaxwCe8dSY/vY1a9DC7kISaXOxDqBasHM3XCp9r+56g0/vijfNgNwIEpkJ
 rMXVtEvSo5el7oC8eJwJpXmyq9ClmVTHDo0IVT9pJ5srrzSP7iNjCCUkknl4+6r/AWEqTgKo
 CO0VJtcojexEfVaPJ0NlfFKutvwFElIbgohuo=
X-Talos-CUID: 9a23:FdadL2OAxltm2u5DABZCqQ01B58eLlrC0UbrIgyUAHlbV+jA
X-Talos-MUID: 9a23:XockeAhRK6h4KoMEx7IjjsMpd/htzY20BEc3vLYvtumVanRIajWbpWHi
X-IronPort-Anti-Spam-Filtered: true
Received: from aer-l-core-08.cisco.com ([144.254.74.209])
  by aer-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 19 Feb 2026 19:30:42 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-08.cisco.com (Postfix) with ESMTPS id 7D012180005B3;
	Thu, 19 Feb 2026 19:30:41 +0000 (GMT)
X-CSE-ConnectionGUID: IXdkh/a+RiWeXG1obO0Qhw==
X-CSE-MsgGUID: M45hkkjuRr67+L62jDioQA==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.21,300,1763424000"; 
   d="scan'208";a="70581315"
Received: from mail-cy3pr08cu00103.outbound.protection.outlook.com (HELO CY3PR08CU001.outbound.protection.outlook.com) ([40.93.6.107])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 19 Feb 2026 19:30:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PQiQItEts9iiZc4ojJw8caSk1mDgG0zL3Yr0Nz+RBR9yJ9bNJRHfD5oZ4MSboRJspOQvEL7ny8MAwrkrtg5luHY4sVGHBWiITSRSaJ8ayOJepGlPk7cDjsNHKcpCQbYh+p5wflAYVNwsbiKMPzbktx67V40/3pvpR7cKJpEqqgP2ZN9jGXBmO8Wgpn9ePfntc8Wp1JgbrWd7o7+Xgpm9ZEjtpeAzkSFRK/sNpRmH7oQCkzeSRap18j5PW0AMHjs6YjYoRSTHcKAZ0SxQps57uW7HwDyyyhwB915UN1dRCqE1Xumho3rJNHTM197weEiAnYy7m7Qwau7XxUCZIn6fCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0XBlKHTCxlw1dJhZrqhgvkZtbBg2w2hYhqryUfOqek=;
 b=RMnj4qKD3rJZOCGW/oYqx+FXS+jKT8PQ47nF3ZvocpR9jfxjWXy/ijDOcDGB/UajzMHnWl+sOgMXNPBwDyiXnqHsM+UY5yzjpZPcMQ58+G2++RJczHvIqSwM5d0vibSVnG/kY2bcSiSHXfD/wa+x2ExM+yJ5IMGYny+UhX18jcsIBafuWMvx7up13c0xBLtiAX0pt3m/pAY3ZY10FRUCb6yDGKMSqU1kZp870zctKvFxzQ5qPab3LFMJJSjzXvRus5O/klPViybik1Qgdr7AkxKY6KGW83se9b9U+v485p6ZQrDjXzfB/b1V4twyxLKZ/4xt3tsbFpPMRCiKWXmB5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 19 Feb
 2026 19:30:37 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%2]) with mapi id 15.20.9611.013; Thu, 19 Feb 2026
 19:30:37 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>,
	"Satish Kharat (satishkh)" <satishkh@cisco.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
	"revers@redhat.com" <revers@redhat.com>, Hannes Reinecke <hare@kernel.org>,
	Lee Duncan <lduncan@suse.com>
Subject: RE: [PATCH 2/5] scsi: fnic: Do not use GFP_ZERO for mempools
Thread-Topic: [PATCH 2/5] scsi: fnic: Do not use GFP_ZERO for mempools
Thread-Index: AQHcoF5wPsur3vfCoEmUS3LXxLBazbWJiwCAgADgdJA=
Date: Thu, 19 Feb 2026 19:30:37 +0000
Message-ID:
 <SJ0PR11MB58967687CC51D864732B8D80C36BA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
 <20260217223943.7938-2-kartilak@cisco.com>
 <aZaoXRkzyCsGm9n7@stanley.mountain>
In-Reply-To: <aZaoXRkzyCsGm9n7@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ1PR11MB6083:EE_
x-ms-office365-filtering-correlation-id: e501531f-b6b7-4fb0-50f8-08de6fed5bfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Ymz0U2DWS7kx0EKjejDuetnrEC7r5sHMDgnHv3Ds30NnBP3W9h3uVRUKONGH?=
 =?us-ascii?Q?prrFuWF01L8XVgEg+Y148YxWs5Qx9I9+Y2hn8ncgr1JFPX7z/V1YH5+yQhm5?=
 =?us-ascii?Q?baLN7kc7h0GOptu0Z8W/kHav/mc5LtGJIEVKxlV4Pz7GPTtaHzM1FwtK5zv9?=
 =?us-ascii?Q?Fy8e7oBmbC0uJpjxlaFvL5cjKKMk4LW2S3xvuUKaREJkEahoAXoqDpiNgGTn?=
 =?us-ascii?Q?OpDkhjmAFM64ImKxJs/PYAPjZoBhCERUgj394dIQyyLziz5EAKT+IEtGf2pY?=
 =?us-ascii?Q?DB8O4ShXZNZGNjzQ9b8/9Uj3UwzzSD516fJwyTem/ynEDXXiWUfTJqICfBp3?=
 =?us-ascii?Q?Ua5qV269cUeSlZoJgp6mGgTux+YjL/1iwMDYEgt/c13Hz8Bn3sTcRuP8fAHb?=
 =?us-ascii?Q?c7XhVWd8uxrrnqh0hVXj7h1UdvNb+LAP8rjl9UzZkX2qtlA3W1s044EVBWUG?=
 =?us-ascii?Q?YARNVSRIsnIIGxGkNI3zZRtruorb6C4dcACa9DRHtINCE2uFTTN2k6oFuv7v?=
 =?us-ascii?Q?U19m98LnpinIgDV4hdJtVzHSj27WbTftGBClF3T1j27G+MEKYVVm3UsU2EpL?=
 =?us-ascii?Q?9q2DQU+XxNS1RBc7itNFTJ7bwIyi7ascPHpqK2eC86jopBSI5o+k0VusG/LN?=
 =?us-ascii?Q?0l7YPvZI5AtJ4kHCw6KYTJJcIhovnG4Jwo1R1G1g2tTbT5wRudb6iCGvL92v?=
 =?us-ascii?Q?G6wMuG1phIKE7U7p//Z2lydV3MUPjqxaDxbTJwyfjvd+0GlFK3ujtfIiF3BV?=
 =?us-ascii?Q?OYi0Ma6IXlGSUxzSygymugosUUFW2ORwkO+pWz7Jz2/TS8XC3UfeVI3j4sWZ?=
 =?us-ascii?Q?819b/5QesoXf+BnkAt1cJ6RckT6s4SzHP+LKNNNqhRO+d21oPXZ3f9M5NtPa?=
 =?us-ascii?Q?7jppnnNZrBSQV7V2xQ/UZjFNAiuIsQmeZz55AGsxvmUVSKvGtS34A6iNgCSZ?=
 =?us-ascii?Q?ObDIdCpSWhqW1U4fsvkVgB4j4dUQPMSmB2SmmzR4VGHZ80evixtoFo2skREJ?=
 =?us-ascii?Q?bWchpZ/kvdMnc6c3yLpdso+/yv9XH+vzPXIGTHLAB5WkSj7TjD+dDoFDBYNw?=
 =?us-ascii?Q?wD3tSTTRF/NpCb39gGR+jxwEyXDyIe+ZZtJiOcKDHPXw9+W3yFv5S3/E5XBr?=
 =?us-ascii?Q?ccGvcK+YoHSLpoLEjKjdP09imMG4ajwM/3npWJfuh8Z+BXKs0bpUIyDVSxsX?=
 =?us-ascii?Q?UIHGFI6+yokISZKLqPe6i1WvRSbPCH3fWYQf4JxCkqSWnN0MsrBsi1FG3X5+?=
 =?us-ascii?Q?vVAFl7TVwqsgvGQkB9yjv82p3USCTv1BJWdoHrkfY/+OVDjSpjV+/JQYOYb8?=
 =?us-ascii?Q?txobFJSr/hgHykRbqrcPlo8dkX9gKy9/GzcrQhibJjzwACr1nTEKDk2QNLjI?=
 =?us-ascii?Q?K4sW/wfMPPPBoyWN+cRDm0oLZiMy5MfR/TCFGGSDOEiuvwF/50LyouDck6Sj?=
 =?us-ascii?Q?Dp7EJnExT8xd43DuPtCVo4wAnCHVHIZ2OW2Rx5rmRn3fTVhA2PyiXiK5bHJF?=
 =?us-ascii?Q?rHZSFS9e7LDsTRFCKq8gfZ107fgTSvw2SNETEhrVx3ryvoFR7vxcPcTtHbTD?=
 =?us-ascii?Q?0vK19AgEz7q5rTMLxoQCBBOKubGEaVzY0z/mGI8TE+WfchKHL5RwT9usMRJq?=
 =?us-ascii?Q?5yODSA+4t7Ue8ingAYA6J+M=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0w8lhh8yLFJgRXwwuQw9bVDYG8OVFdE7x7wEvy0sIk5mfZ0iYKvyzKyMQOFS?=
 =?us-ascii?Q?14LaL2Teym+2JgJBdUz1L/2km+r28EkKCfHIJC8iNdmVjF4rCU+3XsAY9ops?=
 =?us-ascii?Q?lSOK/Be+RZQRNcEyT/JAbMZEdIZNP8fBwK8CmaHLd0A8RQHhe42Q5+WhmhU1?=
 =?us-ascii?Q?9fQu+jPZIS11whMNWxgPSvICTpve3HT4t7jEQ+Gt5r7wKBdoRyxXjQ2Pkdjd?=
 =?us-ascii?Q?vjfgOzJlNRU1FetS1U9hDnnjJZItg7ADKaRMWzgKWEUuwHSHNmsiRwN0yeOD?=
 =?us-ascii?Q?1DuiuJp+Zj3qXVAo0EqqOHj+ZF4T6Qulpjg6wptH1pvAZttZ8sjXm9TNicgY?=
 =?us-ascii?Q?CelnV4EzooJQI90J8ejpV6p/+GzOEDhPyjDbLiRCMqmJ91/KU4UFOZlOs339?=
 =?us-ascii?Q?BF0tzvhNboiVbgsioTdhBcIGryXbbGxmw2vkuck5ouBM18nWHB56QD+iBqWy?=
 =?us-ascii?Q?HnnRkIw08KaOVqNwfaLEPi9Y5cNCllbAqYb2+TaxZWx99MkcbAqWQq/0aoT/?=
 =?us-ascii?Q?zvqYjQ6r/nhbAARNNR4mF0drL+BNjTRYZPMV87JkOv7gcO3UNZlwVCBh0Xby?=
 =?us-ascii?Q?SEvlK2cOKsDMbjGnHfPwCnxYCdwRNIT549Bmxl5DeCTqR0lfszmFuKmh5Flr?=
 =?us-ascii?Q?bd8paY+iiFQzMO4Dv8UsErieeHzHCxvP1Dw4aTaSYctNuqSlYoe+AI7FXlhO?=
 =?us-ascii?Q?Hf8GrKKCyjpTBVL7XI9zNTTo4PiLkV1FJkOXspfA8A5tA1Lji7xsuUP0+UqB?=
 =?us-ascii?Q?GxfWNGudg8IKNzelpP/4toXW/7yLWp6e715PnGfyYQagax206ivP+JQCmslj?=
 =?us-ascii?Q?g3oFC5BsM6i+UxSstDFawAX861oUPLYxIPP2cNGltM/LwZ322OHxewQ9QDVK?=
 =?us-ascii?Q?JKoow4aWVcf5tEQcFctCov9KdJR4Y12a6OoFvlSfjMwmkTSbhbAQDX2e/JCv?=
 =?us-ascii?Q?B+Ky1uIoQ4PlMS7t7YMRghqNDnlgBTWQ8N1KzK570V7bVCqlNlu4hMtwY0Yu?=
 =?us-ascii?Q?7eFoRyvrXdUj7G62fvlphm4zwgWC0caBeNVm82r0hDmQ56pqYrCqRMMTpq3d?=
 =?us-ascii?Q?4MhzsBqS4Hkxvy8wAPuxAobFbVwr3yX/7TD2TO37kDXx4J+pBQ9KYacUyoNS?=
 =?us-ascii?Q?oVH/+VhzA/WTYo4DiEUd3dIZfamxJlgV3+ZHCKnwxRN7+hsX8xT1k0KjCtU9?=
 =?us-ascii?Q?KoPU/AwwPP3aKNerqlrOzG0Rx8zQL2o2XNhToLk1VNf6OfRy9eMi0+m7R8QU?=
 =?us-ascii?Q?AkTBv0ZkC0GS4o6gnKQMlxh2yMS8E6OLZNL1pMoTKVhcDSVU2LmpKi13v4IM?=
 =?us-ascii?Q?rd/ayv8oR3mPrX3Jt5hBbkhaj53hTsFBCZB/7fQ0flb0gexkcbPA3G2Z2a0H?=
 =?us-ascii?Q?hLHNR1MSktm7/2OmPlyjfPePyTC5AgmYO5tJgZQYcS2QI3+EgSSAM/YGajlQ?=
 =?us-ascii?Q?G6vwPVWUNlFAkucSaTVyXlg61BIjxvkKUzOslBM/Yj7zz2sW0YI7EwLh02Mi?=
 =?us-ascii?Q?TmcgrFz3McmiIFqaLnCVpRQO8THPA2ITUaVupUCKyh2LYLy83W203NoYNwMR?=
 =?us-ascii?Q?ryxiaPfyQfD5DY57n/LDX8y1MmKFIsffJqLH55ts9+Ixvj9+y6CrkfGxKpFH?=
 =?us-ascii?Q?PdSqSVizdJIt3N7XNwEsGs++nsCDNCqqTB28g7PKg5AvETBbSDJW/g8DCjel?=
 =?us-ascii?Q?ygQ2VXlng9h2LTWVXVisnteErbjCnCx4AHgbSHhak7F6GEMD65F7G4psX7RF?=
 =?us-ascii?Q?GLEPzQJCz85wFYTVOyCAu/enWCxxNqxLgf7dyMfHFnIgIEsDYr6w?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e501531f-b6b7-4fb0-50f8-08de6fed5bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2026 19:30:37.3619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DvglPDVjZ6hFLnRFnt2b8EF4ABfTgcR9KtlfR9oiL1G2SMD11TLGPwmaOp/LLfrGXvcgtf8X5fl2bJ9kdTXOgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6083
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: aer-l-core-08.cisco.com



On Wednesday, February 18, 2026 10:06 PM, Dan Carpenter <dan.carpenter@lina=
ro.org> wrote:
>
> On Tue, Feb 17, 2026 at 02:39:40PM -0800, Karan Tilak Kumar wrote:
> > One cannot use the GFP_ZERO flag for mempool allocation, so use
> > memset() instead.
> >
>
> This kind of thing could easily translate into a static checker rule.
>
> KTODO: make a static checker rule to not pass GFP_ZERO to mempool_alloc()
>
> regards,
> dan carpenter
>

Thanks for your insights, Dan.

Regards,
Karan
