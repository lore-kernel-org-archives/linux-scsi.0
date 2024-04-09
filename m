Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7817132484;
	Tue,  9 Apr 2024 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676423; cv=fail; b=RxzMoKkbD6Y33TDS+ev+vpxSMXaUeixz/wZ70vIutHC5fCr9o6c6dRlsq0KaXJeJ+untrIHNtlJK9Tc0LmqxC0F6e6TU9nZFiqegaPsvtFdyzjepRPXVUeBYf4fSdYNYgv4a7p8Ajii7B8fw+K6MLwL2Y+L/BX99kd/3ytw9s/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676423; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t5opWzwdJD2BCWxjo9QvNTyuYyBzgLnv6I+jsjGYs5mbO+WGeM4ZAjacMswdfu+xgFCGjzBHJ10TEW2zjX6e3++ZlbrqduE/3rgKG4goU9CIyWyX/LBeQISW0ZsYw1deLAQoevXz/EoSK6QndobTP0amnFBTu80DocJXKD/1lO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=h5FZZE7S; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tL2KPelZ; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="h5FZZE7S";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tL2KPelZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712676421; x=1744212421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=h5FZZE7SvruL5aOv5D0N/W/EX/5r9/pTBNza9tv1Oeuk7YM3VluJtaDh
   eYhuVqwXVTPsnRvUJSKMh1WyUlgukxhtyn+BCguOu6wB4+3fyhgg/dqgF
   1bJPWKminY8wjVlYxaTMVqvjHKsz5sN1slvxMaUNuXmDoY5YMJ8OtzenH
   onZlEScta8615JkjOMUvbUlV1M4WWzFHYGqlmDNLFOLXgF9oKSlpS0dJA
   pVR86ACVc818L00Wsq1/ptGFBBEK9PuBmOAoZ4AdTYqQXNmZpIN+Yibl4
   YjPtx8CQPCfOlr3fxqP9LaLiM12SAkKKV1GnYSmECGTP4X1CMgZEwMD4p
   Q==;
X-CSE-ConnectionGUID: n4il4sKZRamglQMU7UyOsQ==
X-CSE-MsgGUID: UspeHDZOTHGjJ9ARTpV8vw==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13602875"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:26:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVXeHE2VUYyG44iunfMhPSlU1Ia8/3Hdk3fC8lfVzlTyLy7LBVQE2M4lCzV0UX/2jPfCgmqqDYolqO6aFDerGik3Om8bPOQU94b3H+zaGXvC0hxq6Ay/ohukQg2VC8SirxDNe/+pjpty5+Ex2Ihdwrj+ePT3qWm6+YGxXiGnknFJ5VD/tn2xqlnzpjftg0wTfpnsHQPs9/6n/vsIWKRTnAWNCtZBfZuCg6Lj7S4vCmom5QftAAgCUqDqGACJRrRJYOY+DYPg059i6aVXT/wTupwWA4agytZ9HtXwKicAQIldnVv5JpIJ6tM6UKXfnfzvR7oakvlgyoAGJQZ76uFLRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=mYeCrw95tj7R3ws9JY31Yl/D8PZ3niQY0eHs4vxksBdmplijcHabnFUIbfKmfeTkN7LZa7ap5MRlQVHNSJBToGNFeTmwxDm6juS+EQwmEZstcg6uWKJBxvOdQwEGEzkC1sXr6jONW/ESk1iCjhpqCgbkQM/oNh8pe1OY7OnGGqncygq8To5Xv5awCMxT6aBkKWd4OwVrmcLzD24i4vdEgZELAiuYomJmfKsANYOwFg7RqHyBuYaKZ1GISOopIgod5LneVlP8JLL7zccI1LhZu4nh4Kn6DAkCQJFFY03KdZPpCk6WIJuAiARe40GWhLKTfO0xhSgxvLG67J70Gh0SYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=tL2KPelZX/+GiIRYcVFxocFQ+jyS8xu3m0SF8KH800h4uekTJvlIefCinAGqWbKaLpZhlNk8Yo2bb1MhK1pn+PyZeDdWF1QpJFetzNbUlg+BvrY0fuVmoWPnNRaLN0XNhq0ogyiyI7CnMHzgP55mFmglY9bGYVL1bnEPKQvYGKo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6732.namprd04.prod.outlook.com (2603:10b6:5:1::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Tue, 9 Apr 2024 15:26:56 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:26:56 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Xiang Chen <chenxiang66@hisilicon.com>, HighPoint Linux
 Team <linux@highpoint-tech.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, Brian
 King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>, Chris Leech
	<cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>, John Garry
	<john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>, "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Krzysztof
 Kozlowski <krzysztof.kozlowski@linaro.org>, Alan Stern
	<stern@rowland.harvard.edu>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org"
	<linux-ide@vger.kernel.org>, "linux1394-devel@lists.sourceforge.net"
	<linux1394-devel@lists.sourceforge.net>, "MPT-FusionLinux.pdl@broadcom.com"
	<MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "mpi3mr-linuxdrv.pdl@broadcom.com"
	<mpi3mr-linuxdrv.pdl@broadcom.com>, "linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 23/23] block: remove now unused queue limits helpers
Thread-Topic: [PATCH 23/23] block: remove now unused queue limits helpers
Thread-Index: AQHaiowmaLIeTIqrt06GNarXiPTxDbFgD54A
Date: Tue, 9 Apr 2024 15:26:56 +0000
Message-ID: <ff283d29-8c9d-4975-b7d8-58703fae0c6d@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-24-hch@lst.de>
In-Reply-To: <20240409143748.980206-24-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6732:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 DiHsPlgBa8eb7Id1N+DFCy1JcfzF/5vXpa2YBpf4Bs7JzgVcTt6DCG36qDIdbRgEGkuSFEVPl2IJiFz+2o5DszvW8smh5eKYLfaYdpeXw2/3Ryi20MjzXPShWN2I6fwsW9mJj4igSuxHKvS/7fLUgjV/OUIoi67F2nFlfF24KwayJb7OwVTGtF475d3z7DO5OUvahZhuXzKTgXVLIkdvidd55042O1NTCFXsEV4NgHTRN6O8S6wY+/JZ8Y0zRyTtVGCWDX9zwjx6RIICdEnq8zNOdpKB/aqE/vfYrckKFPPtO9NS3kX/4HAdlQ3xIPee2R03CGIOWVa/Q09xB1q/XByuaoak5CZ8iNzSZnp+VNcfpVEfVmqlTuJLon3u2+yTuTXvjxVLd6xQ5y2lSK+FFInYrqhAaZu/1kwYyH7+8tgkDx3F3pazhk7ndEToHkRYxaZyrH0aZqy8s7Eh34xwx0mUIIXh3lX3virrFpWJA2jL8Ue7UHL4z5DoWBbAuGbtJmglfMY7T6VWsuBIeV5tVqnC7kk2el+5mnMzke+mvcJPEErl6Xx9F5xnd0jqdI24VT2/BcITFRin15DFqLJBOU1viz1U1JBDJV7an9A0sI62mi5fV3mHYC7RVeSks94KivsLQn/maQIgKTC9BV1cPh3icRXDOZ4WYLfNr2XWbuU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OHJsaElHb0hIeDhORi9IWXZTOGJZLzVIUFp0ZUtmLys5QmVPMVVOZ2ZFTWIz?=
 =?utf-8?B?eDZsSUp6cjMrYmQybFc1UUR2Z3liT2hCSjIra1ZWQy9sMCtoc1l6bVNSU0Qr?=
 =?utf-8?B?UnRwUE0zNDZCL3cvZUIxaWg0dlRVRVpyVjExSFIvVlZHNXptMzJrUTBUWWhF?=
 =?utf-8?B?clRGcUVmTHdhd0QyRG95N2h4NjdEeXNndHcrbDl5S1RmVGNuRSs4ZVE1VkxG?=
 =?utf-8?B?RkpmRlhyWGNFL0lTS1BjditkVGFncVFGUldOeTdHZEtKY1U5MkJXWXdjUXhD?=
 =?utf-8?B?L1J3NWp1Wndla3kwWFF4OU94ZVJhTGFaemh0bERuczdEVndnUkhya0trLzlk?=
 =?utf-8?B?a1VLZFUrdVdzRmFsVUcvMjgzcmNoSnZxcll1VUt6TkdaL1JZRUd3M0pHNTNI?=
 =?utf-8?B?NE5PQW9HT2k5UDFIczc2L0hKVnhyZEpNS3NMZjdLdW9GbjA4Vk1XUVV0Tm5X?=
 =?utf-8?B?bWJBbW4zQkc3QytTRkV5cXNsb3FNVFdaakVYRHJoTnFDS3FiOENTUHFqOEYy?=
 =?utf-8?B?ckJCTjFreTM4Q3NkUndSUytKdSt4YlgvZ09vdEhBM3Q1SGFJTFNERE9ramky?=
 =?utf-8?B?ZTBodU9EOUxVNFpCTkh6TU52MFVTZm83MjlYYzlzcFhuWkhXWTdzbllYSGdP?=
 =?utf-8?B?U0pDY0xzZlYvdGFiaUtrdDZyM0pWM2o1cDVuQ2h1bStUVWwyU3B4V1huQ1lF?=
 =?utf-8?B?SGdkVkJoR25XY2NuL2gwSnQxL1lzSFhITTJNaGtHZFF4QUtYc0RyYzFXYkdT?=
 =?utf-8?B?Y0JrSWwraWZ3OHNtaTloeXZwNm1nK1JFWEltMXZvVEtsRy92TzhhTGpldlE5?=
 =?utf-8?B?SXZDMCtpUnA5TkphOVdKZTRxK2J2Y1A0VCtKL1NWY2tuLy9IRzZ2MGpiLzYz?=
 =?utf-8?B?bmI3QXVLWmllc002cEMyRTBhNXVOaUszR1FlV283aW9wc2pPZVhiVWhGSCtq?=
 =?utf-8?B?ZzBNWjQwVHpnS1I1SkY2enJGSThtRVhJb1hQQzBmWVRUT0R1VElhMTNFZDJz?=
 =?utf-8?B?T1FNYlYxMmtYcG5pUjVTL3g4YmRzTVkxSVd0cHVGYmk1ZU1ySVZ6UU0zMEhT?=
 =?utf-8?B?TFZsUng0c1p3azZGb1NCVWtqMFpIdmdnRkp1SDlucVpsTnNYMmhzcGlIVm1J?=
 =?utf-8?B?UlIxRG55eGFaMEFhK3hhVDlscHFZS0ZuRFA2alNpcjNtQ2E5UjZIUmNveEZ6?=
 =?utf-8?B?WnRHTWcxdFNWV3dLT3lqekEzdE12ZzFnV2I4N2lwSThvSU1ZRi82eEZNMTBH?=
 =?utf-8?B?d1NmZkg4bTcwOTJOYklkdHBybWhMT2l6ZDZ3aUpzMmpHVWdLakZvZDdnRXBz?=
 =?utf-8?B?K2ZsL0thRkpHZUxkV1hoZGZXcDZhVmJvV2NmWGpwZEUzamtTZXJ3UUlnSWZv?=
 =?utf-8?B?eW1YeDR2dVhIeTVvQkxDOWdnQStybUFheWZ5cmxCb25YRGxDTDJPNUZBNWYv?=
 =?utf-8?B?NUs5YkhZb2loTFFiMnU4dFF1ZWlXeFNFaEUzS3hTOXBjQk90aFN2Qm43dXVh?=
 =?utf-8?B?Q0NZNkcyQytST0FIYThielRaRzhtZGdHS1FvbyttYnMwSFB5KzVuU3IxMndl?=
 =?utf-8?B?bHJhR0p2N2dBNVppNXUzV3NVa1oxTHNrWVBKWEJRTVYyMk5xaGJxVFZRV1lW?=
 =?utf-8?B?eDV0TkF3MW9LNGhvbVVGajhMcXM0MnVOdExOK3RhYkRNby9MaWMzeHN2UXNq?=
 =?utf-8?B?L2tMY085c1ZpQW9zRko3MUpGK1dVTlZOVEE0MlhUbE9MMnJiN3NVTkZWQjNY?=
 =?utf-8?B?ajBjWjBDaWlDbGJueXhPOG1STjNwSVNBMXZwdmw3a3JnamRFTklJTWJ1RFVB?=
 =?utf-8?B?UWZ1UmpoYm5ObnBYWmFmMG01Z0JMNVh3R08raDloclIxeUUwQUR4UUkzdzFC?=
 =?utf-8?B?N2FjaE9Nc0RKQUVubTYzN1o1RDdiZEtaWUJqK2VEajBnaEZQQUNQSnVSYVNC?=
 =?utf-8?B?bmEwdGdycldBWldMN2czemdkUmFpdkdYaG8xUWZCNVhQcG5oZTF1bEljZzRm?=
 =?utf-8?B?UnZlRllsd2NpNktFcGlxRndLakRvcU0rUStCRUQ1d2h3K05rMklBb3gvcU5n?=
 =?utf-8?B?M1VTYnZleEIvK0NrQVYyQ0dLbTlFRVFrRUtuOUJPVzJNb0kzSENNZ3dPUlp6?=
 =?utf-8?B?V1B0NzBmNFA5YmdVaWNOOE40dEx5dmN0dUc3NWZFK3ZBTHpuajlMWWRpOEZW?=
 =?utf-8?B?Vi9pU1N3bXRBblFoWk9JcERlYjZQYlpLcGYvOForaUo0NUJ0c2hEUm9FamE2?=
 =?utf-8?B?WDZxMktoanY4a0c0bnNhakltK1lRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B275413BD936224ABDB929A8145EED1A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d8URclKVjNIm2jv2/UZ8LD1ac4H5OtYVJkbcrGAdr75gyLIs9cUUlTBsM3K+fWJS9FycN3cuyfwIVm3T4j6Kxw81FeCkLzkysyVgMNgAA6pTU4ZrE6DsnjgqGsUDMpgO5q5QyLOYyOsHNNtJ2X24vrK5rBImw26ZsHI9mXVSL334ICcvpvPDkkRQj7PuTWy6d9iybZwHC7WDCeNjArogsCn4YDuSUQsJD0+ArRPmDr2Fv6u0KbbNsi4O0NWc52Zui0tVjWTC/zDecLFkZimpFLLmLZqBFtkEd4Sa7PbJ4Uu8koRfIK/qCvRVjy21XHP0dL4uLkOD0VUJN1/qNVmhlJkaRCea9OZF4aGJO5GAcBaBVVy27jipFBKR32YUehWUjMl+OfeNokHy9EFS3U+nIgQaQKxlc8h3rdv44owZTtPikz6N+cHScpj0aetZJK1EzyWElWIYP3ZLdyA7o+VjqNWyh1XrDgplwSksYBsA1ebCFRbvce0sVc8hO23RfngtHIty+5r8s5QE5J2AQc35U3QSgG5ePyl9uXy8kYcc0QwaubZys+uFQiKywiyUa+sUpXtjfwQi2y2u90i3CRkqAWYnU2pL5UL04Dir5QTvaPGBkWLfII8RZnomMtmoXit1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbc72ac-2b32-4468-b72f-08dc58a97e11
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:26:56.7286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vYixFq6JzWzX77rGjRfJevNRBvIwZYVtsTaqMNbzgYLg5WyC6mSP95e1VewZ5pIHsTPrxgHxeph+iPjaIq/dmD/2H/MW7SheFKc42zV/v68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6732

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
