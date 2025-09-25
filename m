Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98313019C1;
	Thu, 25 Sep 2025 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815201; cv=fail; b=VNxR+YQxHy0aadiubpq6KTjsVSF8O4rTyYJrXEc3h+tkF4nar5rxfm+36DTwo6J3tgAndvh7gkYOtK/DOexkWP6djhkn87m8+xOV2QkFcwSDsY2v4JjJIwTURdei8jgxOmlH9VE8aQn9yVbq/cLaeAqgcPOa6NMil2qoRu7/c8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815201; c=relaxed/simple;
	bh=2m2Lucu6g5hVyAMdG5wV4xFJIhjgWwQIWqroVskIvBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PL5wITOavkAu9YIAN4xx/+esRwxV7bx4xWoPBQGfSgA6PD5FgyL50eMgCSJZ45bsolRP7OQGtNbJuT326iUUd1OVcwqOq3Wo7EHCNbcwROGahpMOHEJCDIjCjHQ08TTjleihNZ8R0ptjlxNoJ3sbgnmJVnZiFEbSCocN0TvK1RQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=NG+lOE8d; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="NG+lOE8d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758815200; x=1790351200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2m2Lucu6g5hVyAMdG5wV4xFJIhjgWwQIWqroVskIvBc=;
  b=NG+lOE8dbt0tLuTiMlzvX5th5ETs9qeYLKVRWI+U8z2HY8Kp7Ii/6GjM
   vM/W88SZIv2YXKb9js8pya4eGYRBCCdfNNZDuNF7W3HkEUoTIT3ifA6O+
   fDy3zAF+XkLBoYgJLBM1fAj/7V86uejPSfcz2m1RB4fXxn7R5EmHiHOHo
   ++Kb1jH3G4nlejN+INa9pMCxo5bcWXGoUTFsyrCJYBPenLTArg6R+uPfI
   5uUXI8bahenZJMQuHhYD/oh+XAN2uaPtj7kKrWILn10RjY33tSXGHmE2n
   X8Ed2rJbCIfJRKpQ9CzDNydhRqSydfJzcLos45UWa0pTRGhB08el3vAzs
   w==;
X-CSE-ConnectionGUID: jsJoLyI3SS+enKFY2xNt3w==
X-CSE-MsgGUID: LMXHBMLVQlK72r8u94Kl2w==
Received: from mail-southcentralusazon11021128.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.128])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Sep 2025 08:45:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V3yCcWJJbNoQ8ok+YK3jtovZtEmOFl7SVHpiTrEcuZdo4ooYltYYP4jvoiX+B5i6lUSFwA18dNrVaQ6ciWS6pbNox6RhFopueXg65s6VcuIKKz202pu994Reh58wSF3PHcnXzEfyeL95gKlzwpeoui3ImtO3OgPNgwaDWPYFCxVsAtvDOSS6rRPE1BOey4UPfMi8rfevK/l3uICM3wzWkByUK2IeV+gcSQALliAva1RzkR2MADG2pRsdumLbt+6EBon7tILTEEQwrFV7l/IgXo8qBQG8JpUyK4PJUqT8wFrnzn0RUpEQoeu9QCh53cFx+NUCqNj3Ks8jsA1rBHCZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2m2Lucu6g5hVyAMdG5wV4xFJIhjgWwQIWqroVskIvBc=;
 b=fD3RnZTfWLzah+hPzv0yzXCmBe+8ncUyVL42MDAxWN05XrRqwY4g9aCjNTs6KtHRl8efHybHJRMr96pYiPOnXH5UVQmX701CV4cU+2yNQiRx1q+LMnqn/Xczp00edJpjIQ55uGmO9DbDro+JGOm4pd2yLwgS3g2Gv6BvBEgHz7cuPADdkVHQrW3iIFXELQWr/SY+9uTM3RkvAdlg7tegZyzXnEb0RG7Z93kGhaO+vupbfg73Q45e+/mSnmDctZCMClVBhTCoYnwUltP++Iwnadhh1bd8uWDwi6tf5aLNDHlN4JnjqGRTUH3g5xMGqrH7TGj4ET+mc0Iun83kA0UaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA1PR16MB6296.namprd16.prod.outlook.com (2603:10b6:806:3d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 15:45:28 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%5]) with mapi id 15.20.9137.021; Thu, 25 Sep 2025
 15:45:28 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bean Huo <beanhuo@iokpp.de>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/3] rpmb: move rpmb_frame struct and constants to
 common header
Thread-Topic: [PATCH v1 1/3] rpmb: move rpmb_frame struct and constants to
 common header
Thread-Index: AQHcLKBk9K6n/AHCckaM7aGTNHWx87Sh2FRwgAImLgCAAA7nIA==
Date: Thu, 25 Sep 2025 15:45:28 +0000
Message-ID:
 <PH7PR16MB6196D9CB65C664259C166D65E51FA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
	 <20250923153906.1751813-2-beanhuo@iokpp.de>
	 <PH7PR16MB6196C3B7F5186F3E63C05A3FE51CA@PH7PR16MB6196.namprd16.prod.outlook.com>
 <af99ce08cf20977d92f3b993f3b989b91d172c79.camel@iokpp.de>
In-Reply-To: <af99ce08cf20977d92f3b993f3b989b91d172c79.camel@iokpp.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA1PR16MB6296:EE_
x-ms-office365-filtering-correlation-id: f5857829-d64b-43c1-4acd-08ddfc4a8d70
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QUJybkhpSE81WDJSajlCa0JUanJYemdjS083TnpnYzlBOFIvTGVOSTVJbDRI?=
 =?utf-8?B?NWIrQjRFUWNQRHFrTHBrNmFYd2svTlR6SzJKbkxwcmZiK0pBRVRCZnRLSGZp?=
 =?utf-8?B?TkJ0Ym9FMy9OS2ZqOXp5SThMckQzeEZUbGxZamZGaGtac1l0V0VuQ1NQUFRC?=
 =?utf-8?B?dzhUMHErcWhOakpiSzlUc3kvelQ3M3Z2Zm9jQ3NBWUV0Q2gvczh1VmpBaEpo?=
 =?utf-8?B?TVhvdHhyajAwWG5EeGU4SzRhRGYzQ01FVklQcllOUWVXblZYT2xwVHFHdm5i?=
 =?utf-8?B?L1JHQThIVklRRkg3OWxnWGFoU1RXY2lITlN3dkdGVU5ZUWM1Nm1GRXRqS1N4?=
 =?utf-8?B?QmdmRnNGR2t3ZkVHOGp5aG5TTEZjOVo5QWdmM21TUW5lamU1TE5SYk95b1V3?=
 =?utf-8?B?ZzJ0R3ZBdWJXanIwMDlPOU1IVzErYy9CdU9JRHpsRXNyWXdmK3hyRFpyMUJx?=
 =?utf-8?B?dDUxUkE0SjVhUExZZGZUZ1Frbm9YbW52anRVVGxoSUdMTSszeWhpR1QwelI5?=
 =?utf-8?B?T0V2U0JONzZXdzFLUDlDT2VoUlFSb2FyWm9oZk1ocU9VK2FpRHVFakZ0bzRZ?=
 =?utf-8?B?cHBFZ1QvUHJhRVQyeS91WnljV1M4WGxlUjVldThtbXAzZHFMWEkwamllbmRP?=
 =?utf-8?B?NXhSN1dFRFp4NFdocnVWRG9KanBsR0Ivb0VOQVpEWUpGQ0FBL0lhWEF3ek9q?=
 =?utf-8?B?RU1JOEEySUUxMDVLQllFUHQzY0ZucFN6b2tqNXViWEFMcmdGSm8vbTFCejdS?=
 =?utf-8?B?T3J6RFBOWWR0Tkk2ZzZ2cnBHUmxzNTJjMkRXV3JPRkZwbHdja3g3S3dzSElR?=
 =?utf-8?B?V1V2Nys5U0ZkbjJydXBKdnF1Uk5NWm9rU0N4MGxwM29iRWRLYk5GYXpCVFdN?=
 =?utf-8?B?WmR1NnI1eXQrNkp5c0pUVktraS9zdzNwYUhTZWlOZXJodTZUcWR5WkdlNGNz?=
 =?utf-8?B?Z0tJSVl0MnlidHUycDRmRTRQc2ZFdEg3dVVLalF3c3BJTjhBcXRWNHZIb1l6?=
 =?utf-8?B?MEk3QmpqYXZMd1RkaXpHOUJkNC9EZ2RMbFNRYm9Hb09yRThsYWRma1RXRmI5?=
 =?utf-8?B?Um9mdDZkdnQyTWJsMHhiSDZhWkt0YVc5SUJpV244MnhucXdGVTU4SnlTNGZP?=
 =?utf-8?B?bnJvSU1GV2lzRGgwZVVTRGdyWlhUMG1EQmVIc3NYRkFaZ2NObGFocXNrQWlp?=
 =?utf-8?B?Vjl3MUFMdmpJL3RudHloZXRjYUY1SjBidVlwQ3VJaURsVXo5bUJxR3RqMklB?=
 =?utf-8?B?dHY5WFNSdElUNVQzbndYZVdOb1pKYUVUYVBMY3V2aTV6eTU2ZCtOaDhyaXN2?=
 =?utf-8?B?K2x5RHYvTGxmanB4K0kvSHZQMzhHVklUczliYTJ1UjNRRzRXY3lLVi9iS0lp?=
 =?utf-8?B?YmNBVk9IbjZ6MW5abFMzaGVtY29sWER5MmU0S3dHOXYzekczZ1hYaWtuWFpx?=
 =?utf-8?B?ZS9UOTdlb2dUVUozYVFHbGp1NDRwUGtWKzBkQitOMVVtYU41YWZwZEJ0ZVhC?=
 =?utf-8?B?WmJRdUJGcTh6QzhRNS92dEFHMUpsVkI3TkNJQzM1TnpTbTVRVGI5WTZEMng3?=
 =?utf-8?B?UjdKRWpvYjRmOUR2amwxYUlxb0ZvVnJ2b3NpcmNhSmFKSzFxcHRoL09VNzhG?=
 =?utf-8?B?eVNDQjd4Ty9VcVV1OG91ZTQzd0NKK1pOMTRNOGZMUDVDRjlaaWk1aW4yMVND?=
 =?utf-8?B?VDV4RjN6Nno4T1JqZjkvSkRqakcxMVY5eXBXd3d2MHcwaUE5S1c1ZkMvVEtC?=
 =?utf-8?B?S1ZhamYyR0N3V3N2NUcyR1oxVzVycEltbzRveFV0YkJGQi9UQWVKa3RUd2F2?=
 =?utf-8?B?S2Z0VGxudzJsdEt0NmRXRnZ3ZGVranlIQS9LQmR6ZE84UVhwU0UxVXBSYW4x?=
 =?utf-8?B?MUhMUDR5eVRHU2FZYk9aZ014YnNGK01JWXpETDFRNkd3Y0xFNlZhQURSdG4z?=
 =?utf-8?B?Vkg0Q1NKRnRpMUNBZk9UeFhzbkxrTWxEUG1acU5Jbzl0Ky85dmlTSkdRN21R?=
 =?utf-8?B?SUZvelpXUmlseWtRTVhnTEVWZGwzTExma3lOZ0h0UUpNZ05sR0pob2pPM1RN?=
 =?utf-8?Q?7Rodg4?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TWNrMFh1c1BYYm85akRPVmM4cDh4MVFhNVBOcGJMcHF3d0ZLejhtNm4yWlpB?=
 =?utf-8?B?UjliN0lqakl1bHNoZ3lLM1FYOTR0bGNLcFRuenlTRXN0aU85Sk02Z2JmRktF?=
 =?utf-8?B?THMwemI0VndGUk90WDVraXRvaW04TXd1V2d0ZGdLRVU5eVphc2h2dldzWEF5?=
 =?utf-8?B?MU54NlFBU1hOcG5pUllmMzNtMURiVjJNdnp2NEtjUjUvbUw2UzlpL1drYVZJ?=
 =?utf-8?B?Z2NDUnJ2VlVBVER4MGoxTXU2VDVnZHpnNERGUXZNdytGL2JqeVduUDRyOXRN?=
 =?utf-8?B?ZlZhdlNkbzhTdHlFUXBVQWF5MzY4SnluVFI1Mk9aV0NjUm5LYmNWbWxydk05?=
 =?utf-8?B?K0c4UWxhOVRGSjVtS1Bqc1RCWVpnWWJLd3h3cEd6UXU1aHlDbkxSZnVTUHll?=
 =?utf-8?B?OE1Fb2w3Yit5RkIrOW5EOG14SUtLSG1ZV29aREhNcWlKME42SUcrbVFOSXlN?=
 =?utf-8?B?QUNNbEdpU1k4YjltMExSUHhEZTFJam9pbUtSdExGUnpYZ01aUFlYMitaSndJ?=
 =?utf-8?B?QjdNQmY1aFpTM0hhY3Y2WnRjUmZIbVJxRlF5WTE5K2hLb0NPdldrQ2ZrRkxt?=
 =?utf-8?B?VGJRVnhNcFRBRlZwTnFwQ0tuY3FUdWZPSXJLQjdPTXVnWVJ0bkZYb2hYdVVj?=
 =?utf-8?B?czlCS2NoYy9sQ1BwR05CWGNYY3lrUGxjSi9LNTNmYXVDVjRhTVh0YUtJRVQz?=
 =?utf-8?B?M3QzN2pMWk1Bc0twNUFVcE54RlVGbmRiZWtnMFJ5YXc3WWtLajVhSmNLWGF2?=
 =?utf-8?B?Q0JnVytrTUFrNGlIdFJKdGs3Ymk2d3kySVhvN0R6VnFOS3pCcHRKa3JWZjBn?=
 =?utf-8?B?d29udEpQUnppdXluS05iSDJ5clprUnIvZ0NoUU1leUlGVXJUM0dzbFNsaUpT?=
 =?utf-8?B?VXVxRGhFUGlCMUo0eDBiOVJpbVlyNUplRU5nek80WTBVV3hiRUliYmFsUFA4?=
 =?utf-8?B?aUc3NFBCOEhUZlVzTitNQkhQT0FhNllqTDIxM3U0WGEycHRuSWNmaHlDZVpr?=
 =?utf-8?B?RHEySFZlUmRyK2JCeHhkWVdKemZXblQ2MTVuREhkdDFjN3YzUmJrVUo2Ri9L?=
 =?utf-8?B?dkNoQ0VPQkxFY213VllQd0cxK3RvNHlZYWNGdnllVlN1SVd2aVo5TS84dko0?=
 =?utf-8?B?K20rWUExRy83cTJRUi95VERkT05kbDZWdHF2cEpkSXdoamh2d041TXdpOXMy?=
 =?utf-8?B?SmpSenJ0dU1xcVI4RHlPa0Vqajd1TTFXNWxsV1dIdmZZaEw2SGU5eFdZSXpv?=
 =?utf-8?B?YzJsMXIyWTR6N2FpYW5CU2htOStJNGRnbmNyTnZENDV3NC90SXJoeVVybXhk?=
 =?utf-8?B?cFhPOE1SSWZBQzgyZ0JwaGZWZmhtYWc5RTVHRE96OUlrdFlzTlQvSGtaS243?=
 =?utf-8?B?U3Y2YmM5OHlaMXNMeS9HV3BBTm5PK01UNzZMWEJ5NUZxNmJhdEpPalBaZmVt?=
 =?utf-8?B?NzNBREJJMDNKcWtsRGtGc3pvcWdqVmtZKzVaRE54c1dMYWl0RlYzTCtoUWdI?=
 =?utf-8?B?SG5jdDhqRHh3anF5VVBaREYvbTJSOUNzN1BSQnljclAyd3lXaFMxTjNCcWRI?=
 =?utf-8?B?MmVDWmlkYjNoMEREaEtYR0o3Z0RnbVJJcktFSDRGeHd3K0d0UU43S2h5RS9a?=
 =?utf-8?B?MmtBMmJMNXBEb2hQQVNGQ1cxYkZHNzNhT29CYWRRMFYvdzVkRldpdE5obW8y?=
 =?utf-8?B?NEdEV3A0Ti8yOGxEZVZGOUhLdTVENEMxaHpoSm5CbndxMjVDNTh5dnBTV0J0?=
 =?utf-8?B?ZE9vYllSWEtDRmdsclNkWUYwK1BNVko3QkE3cDgxUDhVL2lEeEZmZ2FZWTQ1?=
 =?utf-8?B?ODF5Qi9oTmRRUVNWQjRJd0luMHkrd05oK3EyT2lNdmRxdVRTWEplNHlLbXZs?=
 =?utf-8?B?RW1TaVdZblFFaEtwTlcwUm9TbWtiTm91Y3RpeVA4eFdhMnBuMTUwbGdmNkhn?=
 =?utf-8?B?NnA3dkxoSmpZaEJ0eWNSdjFHZnU4bDZYTTl0V1hwMTdiVnlmaU1ydjR4anNU?=
 =?utf-8?B?aExoTXVZT3VtdU5VOWZwdUo1MkdmQWtqZm1xenkwSyt1NElmWlZvYnRjS28z?=
 =?utf-8?B?TWdpcE5TVXovSHNuSHN6bHRsY29kTklrMlNrc242NGRwMk5UZHUrL3pFR3NR?=
 =?utf-8?Q?sFhb0R9UPDhl+c1dDYlhXjg6Y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PKEzfS+LZYqEUIe6ygFO5zg1V9a9WkNd+sFm2XAzhDAcDLwC6+nO5co2lTMpmtDngRjtw9Du39ehZpGqpzPcYNFSu8TeBY0/ZjML3EM4gMO53VHeb7XJFt0xS9Sl8IXjZuMlBCLWy4YDqQ0upnLdTzfsM1MF/IXXYDwq+3XSOj3i/93l+SmhdiBv9pK7TqcDnqhkdRL1MZYKJx6wa54Gvxkmye+zxOOhwDLUEGpma85WOHptbJOuljyLVn4TBTheLrGh72+y2sAiutz4bAi5qak2Mdlfw5NY6VACeGBoPvCsl/MW4OA5yIRMZ4CF52CngN9aCSuPdi7i9puu/teSadzuBUpCMFcocsOZluXIr2skDhaj6bbDR7b6jgxgnANPaPsgdjc2Qw6clizje/AQTR266OjuKcplkO/R4vwLPkHh8eOhtmufiorcjDRrA8CxpWxN5zYASjAkUqRyZGG93VUS6HrjMi9rkIByMiSvywt5H9euXxUGlHO1020eI1riCKx/Bmz5p3KkwsqrJp2io6QZ92SyB05pIBS4fRGYEAVhYAom3075ZGpXsP7VtcVdfVVmsev27J9cMDpaP3ss8AeKV8SBKhRYsPMJl/zwBD/5A6yCZIx3zWSRsP27FPZQw7jEQQ0NY/psEa1I5a9Syw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5857829-d64b-43c1-4acd-08ddfc4a8d70
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 15:45:28.6838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /M4lgh9Jf8LNdVGqmYkBskijQoXw/49ellentwLVLhFZP4JS4AUnVnW2ZLYNt13IWlGpiGwhVTI3M14LX1ysYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR16MB6296

PiBPbiBXZWQsIDIwMjUtMDktMjQgYXQgMDY6MTIgKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+ID4gRnJvbTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gPiA+DQo+ID4gPiBN
b3ZlIHN0cnVjdCBycG1iX2ZyYW1lIGFuZCBSUE1CIG9wZXJhdGlvbiBjb25zdGFudHMgZnJvbSBN
TUMgYmxvY2sNCj4gPiA+IGRyaXZlciB0byBpbmNsdWRlL2xpbnV4L3JwbWIuaCBmb3IgcmV1c2Ug
YWNyb3NzIGRpZmZlcmVudCBSUE1CDQo+ID4gPiBpbXBsZW1lbnRhdGlvbnMgKFVGUywgTlZNZSwg
ZXRjLikuDQo+ID4gVUZTIFJQTUIgZGlmZmVycyBmcm9tIG1tYyBSUE1CIGluIHNldmVyYWwgbGV2
ZWxzOg0KPiA+ICAtIDkgdnMuIDUgb3BlcmF0aW9ucw0KPiA+ICAtIGZyYW1lIHN0cnVjdHVyZTog
ZXh0ZW5kZWQgNGsNCj4gPiAgLSBycG1iIHVuaXQgZGVzY3JpcHRvcg0KPiA+IGV0Yy4NCj4gPiBB
bmQgYXMgdGltZSBnb2VzIG9uLCB0aGlzIGdhcCBpcyBsaWtlbHkgdG8gYmVjb21lIGxhcmdlciwg
QXMgbW1jIGlzDQo+ID4gbm90IHZlcnkgbGlrZWx5IHRvIGludHJvZHVjZSBtYWpvciBjaGFuZ2Vz
Lg0KPiA+DQo+ID4gVGh1cywgeW91IG1pZ2h0IHdhbnQgdG8gY29uc2lkZXIgaGF2aW5nIGFuIGlu
dGVybmFsIHVmcyBoZWFkZXIgLSB3aWxsDQo+ID4gc2ltcGxpZnkgdGhpbmdzIGluIHRoZSBmdXR1
cmUuDQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gQXZyaQ0KPiANCj4gDQo+IEF2cmksDQo+IA0KPiB0
aGFua3MsIEkgZ290IHlvdXIgcG9pbnRzLg0KPiANCj4gSW4gbm9ybWFsIG1vZGUsIFVGUyBSUE1C
IHVzZXMgdGhlIHNhbWUgNTEyLWJ5dGUgZnJhbWUgZm9ybWF0IGFzIGVNTUMNCj4gUlBNQiwgd2l0
aCB0aGUgc2FtZSBmaWVsZHMgKE1BQywgbm9uY2UsIGNvdW50ZXIsIGFkZHJlc3MsIGV0Yy4pLiBU
aGF04oCZcyB3aHkgaXQNCj4gbWFrZXMgc2Vuc2UgdG8ga2VlcCBhIHNpbmdsZSBkZWZpbml0aW9u
IG9mIHRoZSBmcmFtZSBzdHJ1Y3QgaW4NCj4gaW5jbHVkZS9saW51eC9ycG1iLmgsIHNvIGJvdGgg
ZU1NQyBhbmQgVUZTIFJQTUIgZHJpdmVycyBjYW4gcmV1c2UgaXQNCj4gd2l0aG91dCBkdXBsaWNh
dGlvbi4NCj4gDQo+IFRoZSBtYWpvciBkaWZmZXJlbmNlcyBvbmx5IGV4aXN0IGluIFVGUyBSUE1C
IGFkdmFuY2VkIG1vZGUsIGNvcnJlY3Q/DQo+IA0KPiBGb3IgYWR2YW5jZWQgbW9kZSwgb3VyIHBs
YW4gaXMgdG8gaW50cm9kdWNlIGEgVUZTLXNwZWNpZmljIGhlYWRlciBmb3IgdGhlDQo+IGFkZGl0
aW9uYWwgZmVhdHVyZXMgKGV4dGVuZGVkIDRLIGZyYW1lLCBuZXcgb3Bjb2RlcywgZGVzY3JpcHRv
cnMpLCBzbyB0aGF0DQo+IFVGUyBjYW4gZXZvbHZlIGluZGVwZW5kZW50bHkgd2l0aG91dCBicmVh
a2luZyB0aGUgc2hhcmVkIGludGVyZmFjZS4NCj4gDQo+IGxldCdzIGZpcnN0bHkgZW5hYmxlIFVG
UyBSUE1CIGluIG5vcm1hbCBtb2RlLCBzaW5jZSBpdHMgT1AtVEVFIGFwcGxpY2F0aW9uIGlzDQo+
IGF2YWlhYmxlIGluIE9QLVRFRSBPUywgdGhlIGN1c3RvZW1yIGNhbiB1c2UgaXQgc2ltcGx5LiBB
cyBkaXNjdXNzZWQgd2l0aCBKZW5zLA0KPiB3ZSBjYW4gbW92ZSBuZXh0IHN0ZXAgZm9yIGFkdmFu
Y2VkIFJQTUIgZm9yIFVGUywgaXMgdGhpcyBvayBmb3IgeW91Pw0KWWVzLiAgU291bmQgZ29vZC4N
Cg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiANCj4gS2luZCByZWdhcmRzLA0KPiBCZWFuDQo+IA0K
DQo=
