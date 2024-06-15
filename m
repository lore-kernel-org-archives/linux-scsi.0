Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87963D9E;
	Sat, 15 Jun 2024 03:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718423107; cv=fail; b=NPjs38niUtUfX5LgZn/t0oOg2aCqaV8Uojb33den3e6fiW2Iaf0OoJA5WblWbN4Tk+E9XTbjwZA3LI0GkLCUhq2jnJpYC2ofX2liP/SrqhP1Th4kPrll+zxoZ3k3hzf+c+YZDExRGHPuNw5usbuoB7X1fSR0/D5o5vcCk4YnVr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718423107; c=relaxed/simple;
	bh=BOrpXPxbyHcdF8ZZ2gxFFW5YWgOD27lA9jjJW4PwzDc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SIxphS/QNv/Gyp1Vf212VprDLuHZgbz125FGvOwgGhH7ybazTt0UiEgAo+oL4IaawtzZFF0wKiGDH4th1I0UB7rsK126muATUaX6m8+iEHRqOO/IEfIbA9fH3dHcYoHPXl6y9H0LdKrUc2lW+GtbMWM6biwWo5OBkr9+21gUI2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=MG8+AK2y; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=l5qn6ZxQ; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="MG8+AK2y";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="l5qn6ZxQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3108; q=dns/txt; s=iport;
  t=1718423105; x=1719632705;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BOrpXPxbyHcdF8ZZ2gxFFW5YWgOD27lA9jjJW4PwzDc=;
  b=MG8+AK2ySznLhRfd+YyGQNV53MJgb2tWxxW/JCdZG3LQ2Bk1/IPqzLTn
   XGjioiDeaT9HoCJnCkEs864MuufV78MjZmuPNcVqWc6BYjpH8Bhb0AMd1
   2gksp+rQLO5pzv/pbsITXDXzHsE1wX96kQxFrwlvHcZxrj8P3XvB9bvvG
   0=;
X-CSE-ConnectionGUID: jTukcynnTkugW9d/CEUezA==
X-CSE-MsgGUID: D9HA66qlTRC1j7rFUWgRww==
X-IPAS-Result: =?us-ascii?q?A0DEAwA3DW1m/4gNJK1aHgEBCxIMQCWBHwuBclIHc4EeS?=
 =?us-ascii?q?IRVg0wDhS2GTIIiA54MgSUDVg8BAQENAQFEBAEBhQYCFohdAiY0CQ4BAgICA?=
 =?us-ascii?q?QEBAQMCAwEBAQEBAQEBAQUBAQUBAQECAQcFgQoThXQNhlkBAQEBAxIREQwBA?=
 =?us-ascii?q?TcBDwIBCA4KAgImAgICLxUQAgQBDQUIGoVDAwGiWgGBQAKKKHqBMoEBggwBA?=
 =?us-ascii?q?QYEBd13CYEaLogxAYFZiGMnG4INgRVCgWZRMT6CYQKBYhWDRDqCL45DiASDF?=
 =?us-ascii?q?YIlg06BSYRaJgtDW4s2CUt9HANZIQIRAVUTFws+CRYCFgMbFAQwDwkLJioGO?=
 =?us-ascii?q?QISDAYGBlk0CQQjAwgEA0IDIHERAwQaBAsHd4FxgTQEE0YBDYEqiW8MgQaCK?=
 =?us-ascii?q?SmBSSeBC4MOS2yEBIFrDGGIboEQgT6BZgGDVEyEGx1AAwttPTUUGwUEOnsFr?=
 =?us-ascii?q?G4+dSgCdnsqkxBCAoJgSa1MgTMKhBOhZxeEBY0AmTSYZSCoQAIEAgQFAg8BA?=
 =?us-ascii?q?QaBZTyBWXAVgyJSGQ+OIYN6yFB4OwIHCwEBAwmKaAEB?=
IronPort-PHdr: A9a23:AGoaRxNrrUkYzd5WfeEl6nfPWUAX0o4cdiYc7p4hzrVWfbvmpdLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgrDmgKUYAIM/lfBXJp2GqqzsbGxHxLw1wc+f8AJLTi820/+uz4JbUJQ5PgWn1bbZ7N
 h7jtQzKrYFWmd54J6Q8wQeBrnpTLuJRw24pbV7GlBfn7cD295lmmxk=
IronPort-Data: A9a23:tsWwNKDE/DuPWBVW/0viw5YqxClBgxIJ4kV8jS/XYbTApDIrhDVUx
 mMeUTiPPquIYjH2fd1ya4iwo0pUu8CEmNVgOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4SGcYZtCCeB+39BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357hU2thh
 fuo+5eDYAH8h2YvWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEwclzD0onO4sk+ft4PjBCs
 tc1FT0fR0XW7w626OrTpuhEj8AnKozgO5kS/yomxjDCBvFgSpfGK0nIzYYHh3Fr2IYXRrCHP
 JRxhTlHNHwsZzVMM00LCZY3n8+jh2L0dHtTr1f9Sa8fuDCJlVYugei1WDbTUvDbZewLwF+cm
 ljtpmamGD8nC9Ol1iXQpxpAgceKx0sXQrk6ELy+6+4vg1CJwGEXIAMZWEH9ovSjjEO6HdVFJ
 CQ8/isosLh370ewT/HjUBCi5n2JpBgRX5xXCeJS1e2W4qPQ5wDcDW8eQ3saLtcnr8QxAzct0
 zdlgu/UONCmi5XMIVq1/baPpjT0Mi8QRVLurwdeJefZy7EPeL0Osy8=
IronPort-HdrOrdr: A9a23:YDkiJKA2AuVMrr/lHejpsseALOsnbusQ8zAXPh9KOH9om52j9/
 xGws576fatskdhZJhBo7y90KnpewKkyXcH2/hgAV7EZniphILIFvAs0WKG+UyDJ8SQzJ8h6U
 4NSdkYNDS0NykFsS+Y2nj4Lz9D+qj6zEnAv463pBkdKHAPV0gj1XYHNu/xKDwPeOAyP+tCKH
 Pq3Ls9m9PPQwVwUu2LQlM+c6zoodrNmJj6YRgAKSIGxWC15w+A2frRKTTd+g0RfQ9u7N4ZnF
 QtlTaX2oyT99WAjjPM3W7a6Jpb3PH7zMFYOcCKgs8Jbh3xlweBfu1aKv6/lQFwhNvqxEchkd
 HKrRtlFd908Wntcma8pgao8xX80Qwp92TpxTaj8DneSI3CNXcH4vh69MVkmyjimgwdVRZHof
 t2Nleixt5q5NX77XzADpbzJkpXfwGP0AkfeKYo/g5iuM0lGf9sRUh1xjIJLH/GdxiKsrwPAa
 1gCtrR6+1Rdk7fZ3fFvnN3yNjpRXgrGAyaK3Jy8PB9/gIm1EyR9XFoj/A3jzMF7tYwWpNE7+
 PLPuBhk6xPVNYfaeZ4CP0aScW6B2TRSVaUWVjibWjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DEXElDvWA/dkryAYmF3YFN8BrKXGKhNA6dh/129tx8oPnxVbDrOSqMRBQnlNahuewWBonBV/
 O6KPttcrbexKvVaPB0NiHFKu5vwCMlIbgoU/4AKiaznv4=
X-Talos-CUID: 9a23:8BYWeWMxqfZlzu5DWhV690UFHMYZcWDS8ybcZGSVNGt7YejA
X-Talos-MUID: =?us-ascii?q?9a23=3A30YBZQywgRAznrebj0LAdSyr6neaqIj/KGlTz4w?=
 =?us-ascii?q?Ch/OvbC4vIRmgszuNXZByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by alln-iport-3.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2024 03:44:58 +0000
Received: from alln-opgw-2.cisco.com (alln-opgw-2.cisco.com [173.37.147.250])
	by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 45F3iwV4015089
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 15 Jun 2024 03:44:58 GMT
X-CSE-ConnectionGUID: 2gAnBjGPTamLQsLZRz61kQ==
X-CSE-MsgGUID: 553MIOBiSeWP9j6n+ez4Rw==
Authentication-Results: alln-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=kartilak@cisco.com; dmarc=pass (p=reject dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.08,239,1712620800"; 
   d="scan'208";a="8747762"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by alln-opgw-2.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2024 03:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyfA3/6X5EJ1OCdmrX+QgV1l8m1aQJr8GSMFu+/jHm9LEdURsX2S8hA6XVAxjcAgApdmYigxmOaRNpHzfGnkB2LAYq2uOUq+OO5ZvA1eLFjRIil6bX4bpxvpW6noqfaOfI2UMjR0Jpz7womCj58J+TD6HeH75k6fL3ze8/EjhmHfzNhGd1LFzunCONGx8yfG8Db7VcHQ5j1glGUmrmmbV53mx3SWHl9mw9tCOA0wo79fONuqa8zbEtl8JGDvMKAXyKqoQyiGwkHAeUxVAHBM8bvbqujbDtVhe3gU6vUWIVYY2SO2q6cWNhXx4f3YseJLSATFTxjyhW0WyNQ2o3haKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOrpXPxbyHcdF8ZZ2gxFFW5YWgOD27lA9jjJW4PwzDc=;
 b=ilNltPvyNsIJViuTlzG/EqzfS9VAQqQX+ShEyiQClMlFhtEMm4f80trTudoKs++4TmrQbR5tSLIuCwjlAmVfbeb+G+nRwIomZDFAWtt48/0O0OUHXK+Gr45e9cw7dV0W7j0qqKGQX9Vila7jNMEvowNDdKBvnN1RbagBsTbyBuotwODoOEuhlBulP+p9XibiWrt75tQ4DlLo4Q5zKUIrEgq1M1/emJLYw0ZhnZ/NdaslwTYbPdotEXmb8aNxL7PtMyGEVI+J9A2YG4Z6NCdykw3TiP1pRXNmVNIju5nsLHXJQSjwebyf/zs+065vgOjE4J9JbUryuXNyx2VFDnd8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOrpXPxbyHcdF8ZZ2gxFFW5YWgOD27lA9jjJW4PwzDc=;
 b=l5qn6ZxQTqpwmSN2K8ix2k9/r5drKerBYOEdj+gjlDuqJ/DOBivIPbweU8ly3AqqrorHgF8Lhv4jsRRNUhx5y6BLZBD48e7Zk3Gre4i6+n+hxoCcZlAPFHtgJQ/vi/0xD2x4gzxmmFsle1nfol2SggkKOcsmZY3OpRx0E7fTinY=
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ0PR11MB5039.namprd11.prod.outlook.com (2603:10b6:a03:2da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Sat, 15 Jun
 2024 03:44:56 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%7]) with mapi id 15.20.7677.024; Sat, 15 Jun 2024
 03:44:56 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@suse.de>,
        "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat
 (satishkh)" <satishkh@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Thread-Topic: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Thread-Index: AQHau4DaQOSKJ2YKKUeWgcrHrkbAXbHDsecAgASDIGA=
Date: Sat, 15 Jun 2024 03:44:56 +0000
Message-ID:
 <SJ0PR11MB5896B7E6DCABDE98D4ADBFA1C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-8-kartilak@cisco.com>
 <43b8bd73-efca-45b0-9526-3c19c8cb3713@suse.de>
In-Reply-To: <43b8bd73-efca-45b0-9526-3c19c8cb3713@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ0PR11MB5039:EE_
x-ms-office365-filtering-correlation-id: 29c1d64f-d49a-446c-2edf-08dc8ced85dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?UHdiaitjZndQSW5URnlIT3BYVUJrQjM0VytKUitwbDc1MmtKU05SQVBBWEhn?=
 =?utf-8?B?NE56TW5KcWdySXJWWXNDeHU4RVlSK2s4K2xrc2MxQ0JWMjQyY3dnTXcxelVS?=
 =?utf-8?B?VFc0MElwWlkxWWljT2I2MkhwVXo4UTR6UzBOeWptRDJvNFA4WktGVDgwQ2hR?=
 =?utf-8?B?UjNHSE5ZOEdzUVJxTzJDQVFUbHRpOUdoVUw1U1BqY2tvUVR1bm5wV3hNNnVK?=
 =?utf-8?B?TE4yM3pjUmtuUitZTFdpWFYwbWRYcnN0YkJTYnl3WUpubnBjS292KzUxaENk?=
 =?utf-8?B?RjNYM3BHWkpicHEvS2Z0cEZaMksxbzhNNksrVzMraFByTjU0aDNFSDdMS1JN?=
 =?utf-8?B?UkZRb0FCeUtXb25VbjN3Z0U3NUdQVVUvMFEvRmY1eWlUV0lCbXlXY0gwWjl4?=
 =?utf-8?B?MnhJdnFqMnJBN1BZUjZ3Rk8ySlczZUl0eG1LVy9ST3dSQmFvK0toenFYb3d4?=
 =?utf-8?B?VGtwLzZubHh0dnVkWDhGM1o5K3NLSDFwRUI2Z3htTnZ3eUpjYTVpS00zWVRR?=
 =?utf-8?B?THJvZVBWaHRxWTBzR25CdnJNTkNZUytvdDFYSWVKNUxyTHBBbks4ejIwWWVT?=
 =?utf-8?B?TTNpVGQxMDNabFhrWVE5RHRGRVIySkJ0cEwvMjN4ckp1dml6UXVDTnpGTlcw?=
 =?utf-8?B?cTUzTU5PRHRhWFRLZTVGNzdsRjhXRGo1ZXkzc0VLQnZZL3A5Wm1nc1M5T2hU?=
 =?utf-8?B?MkZoVlF3VGNtbXl5MUJQYzQ5WlhOR2VIRzRjRlZDemVsbU81eW8weGsrNE1i?=
 =?utf-8?B?aHhvZEZRQUpObnF1a1FMR2czTmFGbm91cUFqRDh0WDZZWGN3V3l4bTFld3pC?=
 =?utf-8?B?Z3ZMSGhoZmZsaE1JNzNVaTI4VXdxNGIwRzFKbERQWUtKOVVQc0pyemJNN2Nm?=
 =?utf-8?B?elVMNFVUR2grQ1laQnNkVjBsem42bjY5R1BPT0FLSnlWVjJOQ2x6eENaei94?=
 =?utf-8?B?bGxSQm42aE9sbnFwWUoyOGNXVEVCdGRwckI0STlyV0h2bEhwbmhzSGJvL0s5?=
 =?utf-8?B?UG5TNk9kSzJWVVhzZ2UxcWJHRHRabDBzZnVMdFRiS2l2ZDE4K3RGM2d0TFN4?=
 =?utf-8?B?T095NWhyL3gvdW1JRGJsYVBQN0Q1V2RWUnBXNVFlVG5Wak5MZVo3LzlsNStk?=
 =?utf-8?B?WUxYU1VoOFRBVzRiL2hRZWJuUjdhL1BYNWRBbXJab09uWHlEb2JmQUZNeTZu?=
 =?utf-8?B?aENSbkI0clJka3cyZUw4a3E2VElxK1gvTFQ1UC9YRUxXSW1LdWFNelpPWCtl?=
 =?utf-8?B?RWZ3MHhWdjhkZDk0Z0l4QXR6dTlFczZKRS9sbG1hUUU2L0hGZkFXQWdBd21B?=
 =?utf-8?B?WjhVTUlIcFFlam9UR2hGM1huNWhBSzJONFJQWUI4YjJkc0RoMHB5ZStaVzhl?=
 =?utf-8?B?Y0x2b24yTkRxcmlwQ0xWc2N5ZzdWRFZFbXpEa2YvNzdaS1pZNE01U3FxcFln?=
 =?utf-8?B?L281MlZmd2lTWHFuNnpVUDRja2xxcXRYSE1JVWVzbHF6WGppc21uLzlEMWR1?=
 =?utf-8?B?MFhnS1o4TEZpbVJtVVB1bmV6dkZjSlpaNHNpNnFTZVdjV3IzSGRndmZvMEpZ?=
 =?utf-8?B?L2dUdlcrWjg0WnUvMHN5SWtxRGN3M0RWZm1pcXJESVJqQWNNUnkwN3RmZFRU?=
 =?utf-8?B?MTg3U1BKZGJsRks2QXlWYkhTaFphckxySWVZcjNJWDVUV1hxQUgveE5PeFZV?=
 =?utf-8?B?VXd6L01yM04zaWpkRWh4eHlCRWkwOXV0emljNzFXRVd3UGI1cEUzenRpSzli?=
 =?utf-8?B?ci9Xa0NTcFpqclFBeXZhY2pxdm1DY3VURjNEZGZXaTNldmUvWlVOc3NyT0Ur?=
 =?utf-8?Q?iGSx53HNSyUoNMY6PIbMyfrM0gyChbQVvSQOE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dXdxWWZ0ZThjRmVpZkRUaEdHY2dBOUI2TjBvWlNLOFM3RWJ3UXlzMUt1RGZ0?=
 =?utf-8?B?ekdKdURxbUdybWUyZVFrbjVBWHA0QVcySTZiVVRSb2R0QTFEMjNldUFNMmlB?=
 =?utf-8?B?MjlIRWtYMkozT0YxZm5TWXJ3OUNQYXBsazU5L0NPWG1OT2VlN004bFhONTg0?=
 =?utf-8?B?OUFEWUdWWDRnVzRGek9say9XeGp4VGJ6cWNCM3IyN2hEUStBRzlzdGZ2WW5x?=
 =?utf-8?B?RVgzaWlyUks3eUxYVDl2VTFRUXFoYlJieGF0ZXlPK3FtUFdWblNMbFpqSHFr?=
 =?utf-8?B?THpZYnFwa1FnWWdSamRweEpMVTBMMWxvaFovU1VGT3VWTTJuYWlOL2RON1ZI?=
 =?utf-8?B?WStXOHpIVk01RmorVkREOWIrN1BWbnN5SVFyMUlBSkVVMjBtTlY0NWlnelU1?=
 =?utf-8?B?S3VtMXJqdUY0SjVJRXp2MFJOQnV4aEVKT3BKTzNXUStzSUd0KzVXRzFQOEdU?=
 =?utf-8?B?Sk1MTk8wbDdUb3JqaG91ci9rbU1MS0srNmdzdlBYSldITnI4a2trNStNVFly?=
 =?utf-8?B?V1hRUlVYOVR2bGEyK2NVSUg2Rmc5STFJYU03VUMvT1JFNGhnQ3dzQ0lJTGIv?=
 =?utf-8?B?NjgrdlQwS2pIN3dwK3Q0ZnBGb3cxUGtrNFBUaTdRUmJVMWhHMG1sWENSUnRy?=
 =?utf-8?B?V0E2YW9DZ1BtWFo2NTdNU0FQVEp5REJPN1dzeDRBZGdqcGtXbG9yalErdnRh?=
 =?utf-8?B?cTh1N0ZicUNKWkxRVGpDU2VLL3dSdU5LUWpXODZROE5wQ0J1Q3U3SmxGeWZ5?=
 =?utf-8?B?VGt0bXZaL2ZtSlJYSU03QmF4di9OSVY0Wk1BRGVnakswY1NhQnovUTNSeG1K?=
 =?utf-8?B?bWluSlN6ZUpNdVN3eUpsc3lsNVh2YUpUc0Ixd2ZQK1NtL3QrY3dITFRiaUtY?=
 =?utf-8?B?QlF3dE5XZ1JmeXRFQ0Q5dnYvb0U0RFBjYUtIdjg1UFFzbXA2aHpUa1MyL0Mr?=
 =?utf-8?B?UHVMYTg2R2ZyZStFSlB3bXppWEFWZ1hEQ2tpQ2ZyUURlVTQ4YkJHMHBDSzM0?=
 =?utf-8?B?N2tMZWhXdGEvOGkxbklvN1JSdVRwTU1VMmgya1RZVjg1OHNCTmNNRlB1L2F0?=
 =?utf-8?B?UFphWWhWQmY4UjFLMkllMi9YMjdqYytoS1hPMThUWjJ2Vjh0MmlCVDBXbTg2?=
 =?utf-8?B?QUZRY3lGRE5oKzFMR3hRZDRDWk8vWDdGOStvTVZYTlBBaW8vdkxvYzFOTDFH?=
 =?utf-8?B?S1hqUjc3MjlMVHA4UFFLY0ZtOFE4TVhwaFdROVdDTXNOYUVvSXZ4Z2ZDQWYy?=
 =?utf-8?B?SWdESDd2bW9kUUovU2loemFGYjZZTkxpYVVTVnVOQ3JpeFROS1lKSmJWemJT?=
 =?utf-8?B?SUtuRE51TXdpZzJEMmlMRkZzMExFNERUR3g3dW85U1Q5OGdzaGozQk9IMWhF?=
 =?utf-8?B?WVpTZ1JtK245NXZlRnlGRkMvV283SGpOYndpQ0JBUnZXdi9mRVVEYi8zMHNC?=
 =?utf-8?B?WmM3R3ZwbmtuemV6NzhoVjUwVm82WGszckw0QlVlVndwS3lOTHluVFNNQVFu?=
 =?utf-8?B?T0l3QkUyNUpPQWZSMUIxVDYwVEw5dGtoRk92NEtHTzFqQUdOL3VjNzBXb2Rj?=
 =?utf-8?B?Q0hsKzl2bWczRkJseTArMDBXY1JBaUdyVDI3SGVYTFQ3UmgzTXY5SU1RT0Jn?=
 =?utf-8?B?MlFQbkZINVZwOXhLNnNtK09xd0VCaTJoaEc0TDZUUVc5MXJxVDBFSjFsbCs2?=
 =?utf-8?B?dGtIRGJmQmhDakI0UVVtV1dPWWJ2UnlXSllSTFhQK2Q2bzl6ZnZMU0FRVWNM?=
 =?utf-8?B?ZTM1d2NEdFJLSDhoVUgrOGl2SU1NbnE1N09BcDlONlNCT3hueTJVQlcrRDlk?=
 =?utf-8?B?OENEaFBQWWgrRDArdTZqbTA0MjhBNVZZZ29BMW0wU25QQTUxaDBsMndJUHFW?=
 =?utf-8?B?T2MwSmZiZTR5MWN5Q05YMkR2YnhidFF2cytRSjllSGhOc1JaRjZ6OVp2TTEy?=
 =?utf-8?B?aEZDeGRBemxsUis4Rzg3Q28xd3dwNFpHL28weXd5NG1YaG1ST2Jhb0pZZnV3?=
 =?utf-8?B?UGlxbUg1WHJrUlhVTGlZRzA3YTBMajYwSDU4Z2NQQjhWRktTdjF3VWhkaUhD?=
 =?utf-8?B?RS91d0xZWW9aeXMydGMxZmNQRHFwQ29UTUdMY3VBeFlkbEovV0RjY0UxMm5i?=
 =?utf-8?Q?gew158JfLZ7V/r5MDeGIpJKLe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c1d64f-d49a-446c-2edf-08dc8ced85dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2024 03:44:56.0216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PzaEYghlglKnEtO6r0pufWgREzcpQZUwCegareVlov0UUBjTudt+ZAOLso16NZ9MuHgMmqM0c8kw38FJ2u31+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5039
X-Outbound-SMTP-Client: 173.37.147.250, alln-opgw-2.cisco.com
X-Outbound-Node: alln-core-3.cisco.com

T24gVHVlc2RheSwgSnVuZSAxMSwgMjAyNCAxMTo0OCBQTSwgSGFubmVzIFJlaW5lY2tlIDxoYXJl
QHN1c2UuZGU+IHdyb3RlOg0KPg0KPiBPbiA2LzEwLzI0IDIzOjUwLCBLYXJhbiBUaWxhayBLdW1h
ciB3cm90ZToNCj4gPiBBZGQgYW5kIGludGVncmF0ZSBzdXBwb3J0IGZvciBGQ29FIEluaXRpYWxp
emF0aW9uDQo+ID4gKHByb3RvY29sKSBGSVAuIFRoaXMgcHJvdG9jb2wgd2lsbCBiZSBleGVyY2lz
ZWQgb24gQ2lzY28gVUNTIHJhY2sNCj4gPiBzZXJ2ZXJzLg0KPiA+IEFkZCBzdXBwb3J0IHRvIHNw
ZWNpZmljYWxseSBwcmludCBGSVAgcmVsYXRlZCBkZWJ1ZyBtZXNzYWdlcy4NCj4gPiBSZXBsYWNl
IGV4aXN0aW5nIGRlZmluaXRpb25zIHRvIGhhbmRsZSBuZXcgZGF0YSBzdHJ1Y3R1cmVzLg0KPiA+
IENsZWFuIHVwIG9sZCBhbmQgb2Jzb2xldGUgZGVmaW5pdGlvbnMuDQo+ID4NCj4gQXJlbid0IHlv
dSBnZXR0aW5nIGEgYml0IG92ZXJib2FyZCBoZXJlPw0KPg0KPiBJIGFtIF9wb3NpdGl2ZV8gdGhh
dCB0aGUgb3JpZ2luYWwgZm5pYyBkcml2ZXIgX2RpZF8gZG8gRklQLg0KPiBXaGF0IGhhcHBlbmVk
IHRvIHRoYXQ/DQo+IFdoeSBjYW4ndCB5b3UganVzdCB1c2UgdGhhdCBpbXBsZW1lbnRhdGlvbj8N
Cj4NCj4gQW5kIGlmIHlvdSBjYW4ndCB1c2UgdGhhdCBpbXBsZW1lbnRhdGlvbiwgc2hvdWxkbid0
IHRoaXMgcmF0aGVyIGJlIGEgbmV3IGRyaXZlciBpbnN0ZWFkIG9mIHJlcGxhY2luZyBtb3N0IGlm
IG5vdCBhbGwgZnVuY3Rpb25hbGl0eSBvZiB0aGUgb3JpZ2luYWwgZm5pYyBkcml2ZXI/DQoNClRo
YW5rcyBmb3IgeW91ciByZXZpZXcgY29tbWVudHMsIEhhbm5lcy4gDQpBcyB5b3UgY2FuIHNlZSBm
cm9tIHRoaXMgcGF0Y2gsIGFuZCBzb21lIG9mIHRoZSBsYXRlciBwYXRjaGVzLCBmbmljIGRyaXZl
ciB3b3VsZCBiZSByZWxpYW50IG9uIEZETFMuDQpGRExTIGhlbHBzIHNvbHZlIHNvbWUgb2YgdGhl
IGlzc3VlcyB0aGF0IHdlIGhhdmUgc2VlbiBpbiBvdXIgaGFyZHdhcmUgd2hlcmU6DQoNCjEpIHRo
ZSBhZGFwdGVyIGhhbmdzIHN1Y2ggdGhhdCBGQyBvZmZsb2FkIGlzIGltcGFjdGVkLA0KMikgdGhl
IGZhYnJpYyBnZXRzIGludG8gYSBibGFja2hvbGUgc2l0dWF0aW9uLCB3aGVyZSBub3RoaW5nIGNv
bWVzIG91dCBvZiB0aGUgZmFicmljLg0KDQpUaGVzZSBzaXR1YXRpb25zIGdldCBlYXNpbHkgZXNj
YWxhdGVkIGFuZCBhcmUgcXVpdGUgaGFyZCB0byBkaWFnbm9zZS4gDQpGRExTIGhhcyBoZWxwZWQg
dXMgaW4gdGhlc2UgaW5zdGFuY2VzIHRvIGNoYXJ0IGEgd2F5IGZvcndhcmQsIGFuZCB0byBzb2x2
ZSB0aGUgaXNzdWUuDQoNCkNpc2NvIGhhcyBiZWVuIHNoaXBwaW5nIGFzeW5jIGZuaWMgZHJpdmVy
IGJhc2VkIG9uIEZETFMgZm9yIHRoZSBwYXN0IHNpeCB5ZWFycy4NCkNpc2NvIG9mZmljaWFsbHkg
c3VwcG9ydHMgdGhlIGFzeW5jIGRyaXZlci4NClRoZSBhc3luYyBkcml2ZXIgaGFzIHN1cHBvcnQg
Zm9yIFBDLVJTQ04gKHNlZW4gaW4gYSBsYXRlciBwYXRjaCkgYW5kIE5WTUUgaW5pdGlhdG9ycy4N
ClNpbmNlIHRoZSBhc3luYyBkcml2ZXIgaGFzIGJlZW4gaW4gdGhlIGZpZWxkIGZvciBxdWl0ZSBh
IHdoaWxlIG5vdywgaXQgaXMgYSB3ZWxsLXNlYXNvbmVkIGRyaXZlci4NCkl0IGhhcyBhbHNvIGdv
bmUgdGhyb3VnaCBsb3RzIG9mIFFBIGN5Y2xlcyB0byByZWFjaCBhIGxldmVsIG9mIHN0YWJpbGl0
eSB0b2RheS4NClRoZXJlZm9yZSwgdGhlIENpc2NvIHRlYW0gZmVlbHMgY29tZm9ydGFibGUgaW4g
dXBzdHJlYW1pbmcgdGhpcyBjaGFuZ2UuDQoNCktlZXBpbmcgaW4gbGluZSB3aXRoIHRoZSB1cHN0
cmVhbWluZyBiZXN0IHByYWN0aWNlcywgb3VyIHByZWZlcnJlZCBsaW5lIG9mIGFwcHJvYWNoIGlz
IHRvIG1vZGlmeSB0aGUgZXhpc3RpbmcgZHJpdmVyIHdpdGggdGhpcyBjaGFuZ2UuDQpJIGFzc3Vt
ZSB0aGF0IHRoZXJlIHdpbGwgYmUgY2hhbGxlbmdlcyBpbiBtYWludGFpbmluZyB0d28gc2VwYXJh
dGUgdXBzdHJlYW0gZHJpdmVycyBhbmQgaGVuY2UgdGhlIGN1cnJlbnQgYXBwcm9hY2guDQpIb3dl
dmVyLCB3ZSB3YW50IHRvIGJlIG1pbmRmdWwgb2YgeW91ciBjb21tZW50cy4gDQpJZiB5b3UgYmVs
aWV2ZSB0aGF0IGEgbmV3IGRyaXZlciBpcyB3YXJyYW50ZWQgYmFzZWQgb24gdGhlc2UgY2hhbmdl
cywgdGhlIENpc2NvIHRlYW0gY2FuIGV2YWx1YXRlIHRoYXQgYXBwcm9hY2guDQpQbGVhc2Ugc2hh
cmUgeW91ciB0aG91Z2h0cyB3aXRoIHVzLg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
