Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F23204C04;
	Mon,  3 Feb 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738603561; cv=fail; b=CBWkRV0Bdiy/jJ0ByhliY8EHqFZ6yEvE4t024VJbm0L2p6V+XQXmcREUKQEEeMsXlweVpmB2eRZThcCHcDEKB4Yjl8A+KPVuYvbBdy8bv2ahKjNOwSrpPrMZQmAaXg2/mX6QDw+W3AZOw/EIGli8uGPB5PJHc1xsCFgiuTiD3tM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738603561; c=relaxed/simple;
	bh=oantHfiIPZLA1YTua9FKTtoRGHNTwvOQyW+Xheo74UY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lSGwCYG5uUXaFYl2sdafLWicd4b6W1Ie4nzhYJZWX22UyR8wMf3lPOaN6Vzd6+gMddQnz1fCN4EZqTr/0ZDtcsu6OB+sFOVVwDTrDBGMIQDbmhalFh0hpHXkjsfxRs7iJGBP6eIOdTXl4NwOYEPiFk5xyKaaQYb0QBst0oAfMlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AQU3bOyi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aQ+2dbmZ; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AQU3bOyi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aQ+2dbmZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738603559; x=1770139559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oantHfiIPZLA1YTua9FKTtoRGHNTwvOQyW+Xheo74UY=;
  b=AQU3bOyigzRXvr5awbznHxQiZNvhsHkbFfdeCMXlTzHT0mz3F3dZoL24
   M6Eg5v5OmJJlFaPQyAdOGXihGNJIGXTuHE2LesDwyrF4i1HPyTg+D1s5C
   6BadfqR69dxQtSQk1WWhutOWgV2bXaUWYMJE4XYiFRKKmntFiWZYpmnl5
   1cDOZw0B2DDvbthGQxrad1gcLgHQ9Fo6i5RNRkvNrCAWd/etQkQOkmm8M
   Ch3oXqYYXxAsGmKdG1bWkFLY6ZkXUBfhyzFG3vPl4rGIZKAxtVGphJZdW
   f7VdsmkUjtVNd2NMIdM07Il3oEl1Asl1ymgvSEH4i3XUAPcBrzHDexyRz
   w==;
X-CSE-ConnectionGUID: sMGQjHBYS32xZhD0iH//PQ==
X-CSE-MsgGUID: JJ8ZB4atRuWcrOlSwXoYrQ==
X-IronPort-AV: E=Sophos;i="6.13,256,1732550400"; 
   d="scan'208";a="36861046"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.8])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2025 01:25:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DxtFzYiP3ni48oO4ioaOslf2voYkeMPx1Xr9kqgUfM5Lw8bmxRtVvFM+AmcqYQCuaRfvqZMDgwEocPJ/eNZVFy/DD/Mi0vYrlqqU7khCpvq2oym7IeISGvsvwuF+mFysp+tNq4fXPx1XWcuuSXL1yf5O3Hdx7LYA66oZnpKzYo8aOIJ3COhcGyuzHJjpMf7JQWihj+CnZTrIbA6CoXoV/JaN1Ll+bPrrB+ggftFiMXTi7LTJQNPx5KEX3tDlVyNmrpn9QZ4Y+FCejeZ5yA0sLQO2565QKovl/WEzoBjr/K4V7w6MXhxO4GplvwRVgY0O+0oXVqYiRA8Gsqq8qCEkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oantHfiIPZLA1YTua9FKTtoRGHNTwvOQyW+Xheo74UY=;
 b=w2wiutZvpUw58eUhGXRzXuStrodAo1C34weO1GkRNv9eQVHqabAG2jDG9tKv/FDlKBM93XVTE08Q2MpGSqlD9CvWc+Bc4M2y8SPu1HUnq9Adx0n0xevdRW27vDYXa6IziubDyvzL6tm49xOMBtYgAvzqISZzkpvIKf7BTgrTkuBwKlptP9vof+ee3x3vNyigNPMXXWi0Gt0cSktgoh+zMk3m8IKVj5aD6kxqxxJaBHDfMM2Q18uujtrraT7RCBBDr5tT95ktFX8/wfwaJlcwh4nlgfVjdSca4Z7mq8quOSTslr31s85mq+89l84vyDCRC2CQff+346oQhg/1gCb/ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oantHfiIPZLA1YTua9FKTtoRGHNTwvOQyW+Xheo74UY=;
 b=aQ+2dbmZ6LhlGDLyizB+Bws0C/3xvOUt+s6v7yf8WF+5b5BxYTykmaKdC5tLXZYhdl2CH56JM2cvNP7mvzXBN0sI32Q9RZWfI+PjB/6Tj+ekKhoSk3yiiORrOgj1hc19/33RwjSzBZpvO2X3PocY9grNV6SnG5W1BmjAfvBLN4c=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by BY5PR04MB6786.namprd04.prod.outlook.com (2603:10b6:a03:221::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Mon, 3 Feb
 2025 17:25:54 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%3]) with mapi id 15.20.8398.021; Mon, 3 Feb 2025
 17:25:53 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Guenter Roeck <linux@roeck-us.net>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Add support for critical health
 notification
Thread-Topic: [PATCH 2/2] scsi: ufs: Add support for critical health
 notification
Thread-Index: AQHbdlCfPCd2yAzuRU+ZuuVKuUu117M1xveAgAAMaDA=
Date: Mon, 3 Feb 2025 17:25:53 +0000
Message-ID:
 <BL0PR04MB6564CE4996D99B8566F27E0CFCF52@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20250203152735.825010-1-avri.altman@wdc.com>
 <20250203152735.825010-3-avri.altman@wdc.com>
 <d45b05fb-e98b-4df8-a33f-37ecdd23f67d@roeck-us.net>
In-Reply-To: <d45b05fb-e98b-4df8-a33f-37ecdd23f67d@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|BY5PR04MB6786:EE_
x-ms-office365-filtering-correlation-id: 8d25c35e-df6f-49c3-4243-08dd4477cfff
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SktPMGF5cHNJR3hCeldiM2lMdXZpOEdobDh3YXJBbDRwTmZJVE9ZS2hPNUp2?=
 =?utf-8?B?aDZKZHhGeEpweXViVVpjWHlUcVI2S2FTSEIzSE82WFZUcVNYNUVkd3pRcmdK?=
 =?utf-8?B?N0FGUUVXcnZ5cGx3VlIvQnZkRlYyM3lISUR3MXBkcFhpRzNNdEp2ZlFkeGY1?=
 =?utf-8?B?WmJqM3ZVS3BBUXdicHZtYnZqY3U4TXFWTWlZc0ovOHpMQUw3N3JDOCtUbmVZ?=
 =?utf-8?B?dkhueWxEK3lqTjJYenVZa29NcXFiaE04WUk5QnhMbDFRMWh3ditoakJkbmJj?=
 =?utf-8?B?Z1hDSzQvNkptL0Fqaks2SmJCbFJWOGhLejVMNTdsS2Vxc1RuMWh3Tk1UZ0dw?=
 =?utf-8?B?aWdSQ3JGN2pzVU5xQitkMlFLVnplZVhVWVViZ2JXRzVrVXdFS1FzZU1JWUF2?=
 =?utf-8?B?TUhxTTRMUXJQbXlhc0ZybDgzYW1NUGFIN3JBV24ydXRWaFpWNzB1Wi8waXRK?=
 =?utf-8?B?TExWNFhKUHN3cHdOdG5FM2llcElHS1YrQmx3QTVYVUF4TVR5cU93c3V5Q3hO?=
 =?utf-8?B?YnF2eFdTSUlCSno5eUZ6c3VGMmRjRTdnOWpNVGZQQ3FjbGdOV0t1bFduZjRw?=
 =?utf-8?B?dGFXQTVOdmJNUmhNSWxUbHlSakdnVzdlcHoyMVNhTjRaMjhJaGZPekpOSEFm?=
 =?utf-8?B?WCs1d2VrTk9JM0tSZmMzRUg1YmN3WGUrQ1JRUzgxV0MrSWNTQjkzaDRSTzBw?=
 =?utf-8?B?L09DNzhKMFM2ZzFzeXBwQ2VRcy9Za3JZb0pvcmp1WUMwT0FSb1l2YlJ0YkF4?=
 =?utf-8?B?VnI2YjhFaDZKekxvdksyc3JGeHFvZzZaK29nWk5taXVBWHBhNWFtUVBUbU5j?=
 =?utf-8?B?aTZ2VTI1aWdRbDgvdERTdHFzT0IxWEJPVklOK09BSEhNc1FXQk5BSDVCem5m?=
 =?utf-8?B?STg4dW5wL3hTbm1DN2RTTHNTZkF1c2I4aUVSM0YrVzVpOHFkZVNYZUFCMHhV?=
 =?utf-8?B?cTd2UFhIWkFWVm5qTkdzUUFORnlFKzJXVnVMY2JqQWpjNnFOdmkvaGVUK1cv?=
 =?utf-8?B?NDZ0bHp2VXJyM3hJdm9GQk9sV2lESzYrUjlTM3g0eE5SRlZwaEgrc0FBMHdw?=
 =?utf-8?B?S1k1N2RNNlk5QnMyL1VSZ2hJSWZpWFNyeG9tWlNPSEg3YXE1YW1CcWdleEp4?=
 =?utf-8?B?TUl1SzJmNmtDYVNYT29xYURCS1N2K0RiN0w4c1lLeE4yNzFyM2VsVm55Mk9o?=
 =?utf-8?B?SUNWQlE4K3cyaXZGaXYzYTlMeVY5QWFCQVg5VDl1MjUwdEVybXdna2grcnZP?=
 =?utf-8?B?STd5aGlBQnhKOU56VGZrU2J3b1JwWForZkhPUm4wVUJ3Um5CWCtWdURVbFMy?=
 =?utf-8?B?M2hlZGF5QkQrK3R4ZysxY3h3Z2dWTEdLRVd2Rk8yNGk3MTVneVhPbDlIMm01?=
 =?utf-8?B?aFdPSzFXSjZSY25VOGJZd200L29TTnJSR1V4bE1RWFBweWthSWJZZkxodU12?=
 =?utf-8?B?ZmhzVGFLZjhUdlJtQktMTWhIR1ZoZlJqR0QwRjdsQmhmWjE5a3lnWVI5Q3Fu?=
 =?utf-8?B?YjVuMmRSVmh0bFA3b3NBUThwWHZuZ0s5SzFFalNGaDlBcTczMlY0VzFGQkRu?=
 =?utf-8?B?dHdYVkZFRFpNVm5NRkpSeEhqV1NxSjdZUkh3NEVnbUpIYzBTbjgySTdVUXpk?=
 =?utf-8?B?aGduL1FsVXZZNXRPZEhIdHJEMzJ4ZEkyTjNjbEhsbHNGcStVNW9BQUYrZm40?=
 =?utf-8?B?ZGVwaGo4K0lCUWdFMkVzSlFTVTZuV2hoMDNrNmJQb3gxUjRqRHZydDh6VTZ3?=
 =?utf-8?B?ZUU0U2JSZDZoWWhlWWovM09UYTZJMnBBOUR4SUgvK0tFaHlyUkV2c2pwVzBo?=
 =?utf-8?B?YWUrNjREZE8walVWRldCQWUydUE4bWExd0NVVjl5anVkY1JuZGJMWVpPVEIr?=
 =?utf-8?B?dnBMYWJaSDB0ZC8vRHhabDdmRDRjSjh6SHRaRG5lN2xobml3K0xFNVJMajdt?=
 =?utf-8?Q?8+iXaBmTRd05T270IggEOlxcdjqEQdsx?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MlJjbWo5NnJScXhrV0p0bkNlZ3IyMmQrSlpDekVBd2pEcWcyR3Z4UjJyVUhq?=
 =?utf-8?B?ZXFRcHN5OHY4MVdFTkJqM3FBcFJXdzJheVQ5b3VieDNMeDdDRWlWbzVCOTJr?=
 =?utf-8?B?Tk1uUmRsTmYrV2NsdWVIUUhBdW5XV1ljV2hoM3p2dStLOWtEOGliRHUwM3dS?=
 =?utf-8?B?VGovUGpQUWxhVEV1SStrcXZ4YlQrTTRldFZ1MVBzTURKYTVLUlJBNHc5N0t3?=
 =?utf-8?B?WVJkTk85ZTlDQXBQMVB5ZXR0bXdBVVVZcUtwb1RQTUhHMWcyVEYrNUpnTTJa?=
 =?utf-8?B?MktxZG1GVWJDNnFaOXJZblFKQ3BqMi8rZXhhR2JMSGJ6Z1ZCYkFTbHlUWWpx?=
 =?utf-8?B?MVRBNTlKNzRlWjR6RzVYUjg5OEJBZ29pZkQwVFR2dWVZME0wUWUxWldBcTBW?=
 =?utf-8?B?WERlR2dQWlhzWHlUOUhtU056RnlrNm9yVDdUSUhTYzNQeG4rdW9qN1N5Y2RF?=
 =?utf-8?B?aFE4MkhiYWhWeDN0ZkpCc05aNlZ2RUpKOHMyUDZQL0F3Ty9QV3lzdFJwS2Vx?=
 =?utf-8?B?d0ZjUnpnOVZyLzIvcEJUcVFST1U1WXJpTHNEc2VhVG5VTjBUU1VpbjgwSHAz?=
 =?utf-8?B?Rks0eGdxelhaNFg0eWxUR2t1dVBlNWFoOWNpdFdGcFJnT1R1OXBUajBObmRs?=
 =?utf-8?B?Qi92QXF1QUc2OExOcDZwMHJVbXRGaENodDR4T0k1dEkvdlRSeUtVTC94RWtB?=
 =?utf-8?B?dTBGS09XamtQYUZxZ3p0TXhSOWRvLzhCa1c5RDZyY0ZWQUZSaVlPWVpxRU5R?=
 =?utf-8?B?M0w3Y1hUdEZtUUVVNXF0ejhtcjFQRTRtWmFyNXpTTDF5K25LdER0eGNDRUJV?=
 =?utf-8?B?dzR4WC9zZXBFWXhmOWZRUndxV0YvT1lEV0V1bTZlSExSNkR6UkRFNUxqMkth?=
 =?utf-8?B?U0FSaXZOVmtkbS94VUYyV3lVSVh5MDRmcXNUSzdPQXRhbEhaNEFFeWRKL3hn?=
 =?utf-8?B?T1UyRjVMMERpRG5aSGpuNy81NDFvL0E3UUQxVWhUcVl3bHB0aFVBTHNEQU1z?=
 =?utf-8?B?N3krcmlqaDU0THdPZVNScTdhdnZ2ejdKdEYxcFVBZHIrc0tHK0sxczFpbHF6?=
 =?utf-8?B?dVc5ei9KTHhKTGM5V29IS0c3bUVLMTB1YkVQd09xQmM5Z0RyQ0txV3lBNGM4?=
 =?utf-8?B?cnlFbURpdzNlTTc1MzF0RXp5cEt0aHdZc2szazFvSkVVOTF1b2VrVGIvZkZi?=
 =?utf-8?B?SEFOOUwzb0xoS0ZPK3AzaTZ2K0lBWUNrRStUQnFQcUk3NW43bFJxQlRFSTY3?=
 =?utf-8?B?RE1BTlE4N283VHVmZ3ZtVVh3enJhcXFFbWJRc2EyL3EzK1kxZy9zaXphc2hy?=
 =?utf-8?B?UGNEZUs5RnNZeDEwZEpsaFZKWUE5Y0Q4dGdaQlZjeHFvY2RsNnZOdDVTbm1m?=
 =?utf-8?B?dlhyR2NkTndPd0FyV2NDNmRyZXhDYm5abUNpK1ZWdjZneWxnUUxCV2JId0xG?=
 =?utf-8?B?eXRzV1lySTJ1VkJ1OXcrZUs2eWM3TGkrV20xaGtQWEIyQ05yUEhQOWtQWjRp?=
 =?utf-8?B?K1NPM3haR1J4RnRRd3BKMVFhaDBpcTJGNjlOZEZmVDFhTGhFaFQzSXNxbkxl?=
 =?utf-8?B?UFJzaTNjWnVNbGFrQjZlbFBlem5hNFV5SmlnOUZtUFdDSnpzMjEvMjdzbjRt?=
 =?utf-8?B?dmdyd0dMbURGak5BWW13bkNKeVZtS2NnYjl4OFJKQnZYZkcxNTNJUWp2K082?=
 =?utf-8?B?Mnl5emZqN0pVUWJlQ1pVMEwxQnI0bE9zejlKK0lsY3QyQWt5aWk0L1hJdm55?=
 =?utf-8?B?VnRpWjZ6elpnWi9Mc3VJdGMrTzJEVDZvMlNNbTVyVVZXOEtYcU85dHdGblQ1?=
 =?utf-8?B?K1NKRWFkN295azVmVWNMN0p5YlJsQWdFaVBPZjkwTmtEWWt6WkI2dzZIay9p?=
 =?utf-8?B?UDZDR2U0MW1PYTByOEcrTktqWk5PRmd2VEs3MkpkSXNpakZzVUJjRU11KzNa?=
 =?utf-8?B?L1JISDFlWWQ2TGkyYit4VnNKTnQrNXJXSVc3Z1NiVy95aUYyUXNXajRDSUFI?=
 =?utf-8?B?T3Z0STR5MVIySWFNTDRDU3NpS0lYSWluUytqeGdjZEdBVW5lbEw0bDRGbTdG?=
 =?utf-8?B?cytlQnNTaGQ2WHV3ajlFdXVpV3l5anZ3d2V2K2pGQTNUQ2xEaDlYam9XbkFK?=
 =?utf-8?Q?pGDCW2p5GJfNT1NIbo3g7J31b?=
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
	7buPjUz2v8VVeyap0IyGrme0ilkkIzS6DhqGCq91Bh7EwAvU9+PdxRXXcrEtSmcl0A0SCFA5/o7uwy0ccn7n3O7tc2mii70o3jD78VppP5K01r81U0Dv4Kso7WGepuoBgFyvwX7AfGicqRuEBUzMHcyYlproJ2VnGbblWUwaTL9wIwTQurbQpjvq5PRMug50v6G9XSV9yGWOGXY1jI17N0SL4GOGNn1tDJSLh1Buo356F7rAE2se25ryXxQaNX78i+c+w3aEtq+Y5O4ROo9JNjYYFUB9mTJnxt5y9xmypcLcJZZANq4z7W+xZ579ExK8H8NC8BApKuPXi3MSikDSbWYuIAzP9L++gJT6xOU1e70uByTXyW3fSr+Y3zPQwuKyqA957fbGbWWQqyzkO50JcQpXL7fwkfSv+DPhU0KoJK7h3jb03Kf2o3QPrCkj6nJRp2d7NiYEgK4fB8kRhHSNpQ0cpepbzooAlbnjoWrEGOQOnM6Pnm5AOV3oCuBOBtDEzZ1Tk1mGp0qeLWYH22qj0jHEBDMx9b91xnHCCzmGSTDMcM6HLFl74//aOZiqM/xwGCTJysYut9lc5eQwp73D7nqBpotvCKCy8c39BT+DFbCxOpvLJAC2O3e89yy761bJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d25c35e-df6f-49c3-4243-08dd4477cfff
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2025 17:25:53.7268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0zxmbPqCpaFgaIB9KNgzkb1EZi4L2QI0GcmS7NMwMPk6ZzOibfykZP9ijUgPLsk1bhE/YRpkVKM/YQpq5AWMsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6786

PiBPbiAyLzMvMjUgMDc6MjcsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IFRoZSBVRlMgNC4xIHN0
YW5kYXJkLCByZWxlYXNlZCBvbiBKYW51YXJ5IDgsIDIwMjUsIGludHJvZHVjZXMgc2V2ZXJhbA0K
PiA+IG5ldyBmZWF0dXJlcywgaW5jbHVkaW5nIGEgbmV3IGV4Y2VwdGlvbiBldmVudDogSEVBTFRI
X0NSSVRJQ0FMLiBUaGlzDQo+ID4gZXZlbnQgbm90aWZpZXMgdGhlIGhvc3Qgb2YgYSBkZXZpY2Un
cyBjcml0aWNhbCBoZWFsdGggY29uZGl0aW9uLA0KPiA+IGluZGljYXRpbmcgdGhhdCB0aGUgZGV2
aWNlIGlzIGFwcHJvYWNoaW5nIHRoZSBlbmQgb2YgaXRzIGxpZmV0aW1lDQo+ID4gYmFzZWQgb24g
dGhlIG51bWJlciBvZiBwcm9ncmFtL2VyYXNlIGN5Y2xlcyBwZXJmb3JtZWQuDQo+ID4NCj4gPiBX
ZSB1dGlsaXplIHRoZSBod21vbiAoaGFyZHdhcmUgbW9uaXRvcmluZykgc3Vic3lzdGVtIHRvIHBy
b3BhZ2F0ZSB0aGlzDQo+ID4gaW5mb3JtYXRpb24gdmlhIHRoZSBjaGlwIGFsYXJtIGNoYW5uZWwu
DQo+ID4NCj4gDQo+IFRoYXQgaXMgb3V0c2lkZSB0aGUgc2NvcGUgb2YgdGhlIGhhcmR3YXJlIG1v
bml0b3Jpbmcgc3Vic3lzdGVtLCB0aGUNCj4gImFsYXJtcyIgYXR0cmlidXRlIGlzIGRlcHJlY2F0
ZWQgYW5kIG11c3Qgbm90IGJlIHVzZWQgaW4gbmV3IGRyaXZlcnMsIGFuZCBpdA0KPiBpc24ndCBh
Y3R1YWxseSBpbXBsZW1lbnRlZCBieSB0aGlzIGNvZGUuDQpPSy4gIFRoYW5rcyBmb3IgbGV0dGlu
ZyBtZSBrbm93Lg0KRG8geW91IHNlZSBhbnkgb3RoZXIgcGF0aCBJIGNhbiB0YWtlIHdpdGhpbiB0
aGUgaHdtb24sDQpUbyBsZXQgdGhlIHVwcGVyIHN0YWNrIC8gSEFMIGtub3cgdGhhdCB0aGUgdWZz
IGRldmljZSBpcyByZWFjaGluZyBpdHMgRU9MID8NCk9yIHNob3VsZCBJIGxvb2sgZWxzZXdoZXJl
Pw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IEkgY2FuJ3QgY29udHJvbCB3aGF0IGlzIHN1Ym1p
dHRlZCBpbnRvIHRoZSB1ZnMgY29kZSwgYnUgZnJvbSBoYXJkd2FyZQ0KPiBtb25pdG9yaW5nIHBl
cnNwZWN0aXZlIHRoaXMgaXMgYSBOQUNLLg0KPiANCj4gR3VlbnRlcg0KDQo=
