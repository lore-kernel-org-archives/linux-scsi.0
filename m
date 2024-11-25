Received: from SLXP216CU001.outbound.protection.outlook.com (mail-koreacentralazon11021074.outbound.protection.outlook.com [40.107.42.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4819CC32;
	Mon, 25 Nov 2024 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.42.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732533776; cv=fail; b=JjFdPKVyZ2qW9Gly2/W2tnUSaD2wqL2EVO5TPxQkf8U5P9JaMfxoun1xR2Bn1BDRhvrcPi9LMzxiVLeQ3pjUnpCYzjQFh4W5Fv/xWbPOHBBnRJ1JonZJpmH47Z07xsdx2oT7saeOXsKJGVkmKC1C0KpMSFGmLIiLEbymp1d1yxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732533776; c=relaxed/simple;
	bh=BFTO88KVhI571jT9CSRefUo4BZo5yyZHw1PqYsfce+8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YVU7kodqb8wfXz6ElGsinTMNRm4SSm/L0RRkKuKx7IzZQXOEJqBPaS8TXG8j1z+MIHboTVKb5RiV/glDZc8R8tXfF+vfk3oIZ3f7Yl3OAg+SJ8/5DyzKCe0BXrym6URw6aW4veD2yvjKoJ9P+XyMvThhJITo1zH+DziXdxXE2gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr; spf=pass smtp.mailfrom=unist.ac.kr; dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b=QBVjMy31; arc=fail smtp.client-ip=40.107.42.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b="QBVjMy31"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPC1ARLSPmZXdQI1Zt08KlKhO3h9mv0JVNAIiq1fjI6Bx1Op9yJnmG3gYXRweAg6MPxuQgXt+D+7iOoXnQLKOaMf3tqcYpM8uydvX7BbT5jObnXdZyMJEAh9fyadcML1EdVCuHuxpcLyScy/Lbu2R6yqgPQpVOi+AOQ+Bv8ik1iGkFHzKjFg+ON00OO2TFu/LdU8am5uaCAHrRabBFEj9nyKCPyQ7Q5Xv2MFwM4s43FaPt8MvO6qvNMOVIiwyU+kqDP7f59eVhm8y+Pk2yXmV08WnC/+mAztqQmONBSf/IIPoJyMgwIv2WrD3eBXcACG9hLvS8hq0MrByxOjVYV2Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFTO88KVhI571jT9CSRefUo4BZo5yyZHw1PqYsfce+8=;
 b=vegHr21u6u3JAtO8UKzL4iEY2OO44MZQ6HtDMUxlP/5rC8XLpujX0jOWXtGihmd7z1Arbt+aCiElab94Vl9rfsc8msaUAnIgwFg7yf7xlI+RJWe7+YBuKaCSRz4xj7V4bOuGwMrdBWLM0TlR4HAN00QA04MDK/jfLvhBpromsbRYw7wmm5lhBAzD5OQORliF0M48ijEf8tZsjOKvk9mSAuDqUu8WE/X4Qunnx4mNlhhaRvYrHXwpMV5qGH9xUbA1xQtHMbd76AcAJJF4xQc6ga5Fc2i8jA8cNlHTfXRL9pPGf4qdg2eSXx0nZyC6esK65zrTBQzHHi4oVD/tzO/oBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=unist.ac.kr; dmarc=pass action=none header.from=unist.ac.kr;
 dkim=pass header.d=unist.ac.kr; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unist.ac.kr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFTO88KVhI571jT9CSRefUo4BZo5yyZHw1PqYsfce+8=;
 b=QBVjMy31GuaSdIXm9bX4RRy82hZkF+F+nvtt2VO/2yDeIgpcMNcmlkUIuj0tC5kSVbNleHfB7Yx2osS3PhSzWfUk2qVg4jOzkHS3ky4tmaDNFGwkdLY8QEKTpTj+dev+9kjF9iz92Hsdh9qLqkiRChZq7BHxuRaJT32+n47pRU4=
Received: from SE1P216MB2287.KORP216.PROD.OUTLOOK.COM (2603:1096:101:15d::5)
 by SE1P216MB1962.KORP216.PROD.OUTLOOK.COM (2603:1096:101:f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 11:22:52 +0000
Received: from SE1P216MB2287.KORP216.PROD.OUTLOOK.COM
 ([fe80::abfa:51df:7a24:2f06]) by SE1P216MB2287.KORP216.PROD.OUTLOOK.COM
 ([fe80::abfa:51df:7a24:2f06%6]) with mapi id 15.20.8182.019; Mon, 25 Nov 2024
 11:22:52 +0000
From: =?utf-8?B?KO2VmeyDnSkg7J6l7J246recICjsu7Ttk6jthLDqs7XtlZnqs7wp?=
	<ingyujang25@unist.ac.kr>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "njavali@marvell.com" <njavali@marvell.com>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] qla2xxx: Fix  START_SP_W_RETRIES checks _rval with
 positive EAGAIN
Thread-Topic: [PATCH RESEND] qla2xxx: Fix  START_SP_W_RETRIES checks _rval
 with positive EAGAIN
Thread-Index: AQHbPyxdEMDBr931Ik+cgvc9cEUEOA==
Date: Mon, 25 Nov 2024 11:22:52 +0000
Message-ID:
 <SE1P216MB2287DAB6D12C14C085D0193AFD2E2@SE1P216MB2287.KORP216.PROD.OUTLOOK.COM>
References:
 <PU4P216MB2281AC76382B9FCC96105070FD562@PU4P216MB2281.KORP216.PROD.OUTLOOK.COM>
In-Reply-To:
 <PU4P216MB2281AC76382B9FCC96105070FD562@PU4P216MB2281.KORP216.PROD.OUTLOOK.COM>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=unist.ac.kr;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE1P216MB2287:EE_|SE1P216MB1962:EE_
x-ms-office365-filtering-correlation-id: e5b3d542-8d70-44ec-513e-08dd0d438063
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|41320700013|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MW1tSURqdUtQT2UxZTNzVEt6cDFyZ0twMEpMeVF0M0t4M0k0R3hYSnpHcEtX?=
 =?utf-8?B?Z052a2RaQU1ZbmZPYm9tY2liaGdlNmVmd3lnRGZ6d2tFQmhNWjdmZUtBNGw5?=
 =?utf-8?B?YXQ1Y2FXK2FCK0VQcmxUYkZWMDZmSTgzNGlxb3YxWkVaL1pUMFNhRERESHdS?=
 =?utf-8?B?YzRldndvM0ROZGlDKzFLTTFEMlppbTRseGtaNkNhd2wzb0c5bzBybzhXcjNx?=
 =?utf-8?B?V2N2ZEsrcDVRemY4Nk5mcjc0cFFDOWJneXVaUFV3TGlNUndLSFBoUDI2NmE3?=
 =?utf-8?B?VDB5SFgzdk41QnpDZjNuOGNJYmdjT2tkQ2xGYnlSNHRKUW10aUVQbXFNL1BX?=
 =?utf-8?B?b1FUVmc2b0gxcVJjM0l2RjJPMkxGOXdYYmpPQlZUMVhRZUwyN296YkcxcXFE?=
 =?utf-8?B?UVFmaUxXTWxhRitNZEZMZUhiWDVWbllnRWN4SHh1aG9XakxqWHNRVXkvdWsr?=
 =?utf-8?B?dWh4bVY0aUh2NWh5WUFBb3lURzBxOFNWencvSE9uTG96MllBUENBaW9RWmdT?=
 =?utf-8?B?cTg0L1Y2bjJqdDVoMVdGTEhzaWU4ZjlVMXdYUVpOMUc4eWwvM2RFVFhxUVZY?=
 =?utf-8?B?UHpDNmVuc2EyNGZ2bDMwdVFwdDZ3Y0lzS2dIYmJRdGt6VEcrcnZlYUJZYnhj?=
 =?utf-8?B?RFV1V1FkU3J5eWEzd0FuR1lDMUNJaUU2UDM1VWlUTG0zRytTTDF1amNGMzF5?=
 =?utf-8?B?YUloTnZZemYxNnpIR2NWZ1hYcWRkNmswcGZNZVkrVUJxQ1RIRHhqY3M2eDY4?=
 =?utf-8?B?ckdUMlFPMTh6alcxN2M1c0t3Zm00eWp3cjRSTlBCU09KalhXRzRDTk1GMldi?=
 =?utf-8?B?dDVLSDA0N0JOOGh0T0lkMUI4blRpVG1rZFRKZW1pUUsvbG5GZ3pSN21QdGlX?=
 =?utf-8?B?YXpWSklSdlNwNVZvQjBPTnk4em0yTFVEdm1wVmZRZnBQWVdZWEs3bjNYVHFK?=
 =?utf-8?B?bW9KRGZrZEFzVEVHa2VLM3AvUjB2RjdnTkJxMjZUYjFXaDYwOWlJUUYwVWtS?=
 =?utf-8?B?endlTnhlUkJ3RFk1Tm96Y1RrYkhZT1ZDdUkxWjVhSU9XY1NaaTVmWjVXY2h5?=
 =?utf-8?B?clhFMTY2V1gxNUZ3cVo0Rmg0N1pRejhlcE14UmdBMUdLems0RG5vQW1DUkFh?=
 =?utf-8?B?enlVQXJBSEorK25YZE9ENFU5a0dRUXR0UXR2QkV0NDQ2UndRNTJ2SE0rYUFZ?=
 =?utf-8?B?eFI4WC83ZXg1RWx3ZlBUVmZZNnBuV3J5Vnd5MTl5d1pNZkU4T2xvcVlmZlVO?=
 =?utf-8?B?U2FueG5JdUFNVWYyOElDWExPcjNlRXRGZGFCN2x6a1dPRWw4WTZidDhPelFM?=
 =?utf-8?B?QlNVcWRLakc5QTRvSmx0SHFFL0JxbU5tMnNiVVhVcjJKclN5SDdIN1VyKzlO?=
 =?utf-8?B?ektRQkc5cUlDTzZZdDZmU2M4eXg4Q004amY2eHkvY3BNb3BKcU5Ccm9WbEF6?=
 =?utf-8?B?RFU0NGRZM3psNDZ4QkpvODNDY0pFS3hDdmlUV1hOYytQRkpXT0l3aGZUeEdN?=
 =?utf-8?B?b0xHdHZOR0gzZkxiUXpobyttM1gzOFpwb2tyZTZVYW9EQWdYbmtlRHpoaHRD?=
 =?utf-8?B?dnV5OUl0TlZLU2xiN1JBSGY1bDUrSjFueXlkT3NYQTArRlROU3RNQjdDNGVS?=
 =?utf-8?B?SFVMSVNwWXIwQXRhU1BJQ3NWSUhiU0ZNaHlweUFrVzdXL1NqTVcrSUE3SlJt?=
 =?utf-8?B?N3pHYVc3TlNOOVk0eW9NSGI0L2JVcXZkZHlMZS9tb0tjM21DNStWVlJRZndt?=
 =?utf-8?B?YjNTZXpyUXRSVTdWMUJuSWljTW43SXFLcW9MdWRkVUJOYVZKTjIrNUZmczQ4?=
 =?utf-8?B?YmM0SUtaQkxNS2hETzVzTWdlYU5lZnlwU1BnUCt6ak5oQnJPYWxzME0vNVh6?=
 =?utf-8?B?MDB6c0Mydkt1RDFkdGwwVDdaNEF0RmNTM1pnN3R6SDBBTmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE1P216MB2287.KORP216.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(41320700013)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dEVWejQrcDdqQm9zQThxZHpuUjBXMzQzSWNYY01LN3R2bkcvYWxyZFNVSlRN?=
 =?utf-8?B?NVV4YXl2aXJkbDM3cWVDTThoNWVsUmF5UzZkaXdQNkQ5YmNyQ1JicngydEgy?=
 =?utf-8?B?cnVMVUtEa2J0MTB1MHFIeUlwVHBwdEsxTlpXUjB4dU5xZGlxbzlKcFhEd3Qx?=
 =?utf-8?B?cFQ1SzlqL1FhaG9UNkZPeVVPeHhNVG1UbjRQSmh2R253Zzl4STRZRThobDBw?=
 =?utf-8?B?WWpuejZZL2Q1elUyT1JIanhoV1lWdHFtVHlaVWhzQWIzTmdsRkJkOE9kRWZ0?=
 =?utf-8?B?VnR2a1ZDeGxvMEpzbk84VEZ0dkQ3T3RXcngxY1hwWWVOeGU0QjJvN0Fqcm42?=
 =?utf-8?B?TWM1RlhKODg0c2hKaE96a2VxamJjZ0cvQ0NnOHYrNDBqODgxczFKK0lhdzY4?=
 =?utf-8?B?MmxTblk2RHMzUjcwT3Rlc05oQUw2QnV1RFB6T2VaQVRpb1FZY3J4dWEzR1pX?=
 =?utf-8?B?TVFqUFNhL1ltL1FkOXB4WmdGeG5wdk9xNitINW9SaXRPZmw1NUV0clU3Vnl2?=
 =?utf-8?B?eExqVE5HWktlSE15ODBMRFVnQ3RtTklvQXBlNDBYalhpL0diT1ZZRWJJbkRD?=
 =?utf-8?B?YUFKeHpSVXVYQmpydnVHcWtQOGpQK2R0ZlZzYXQ2R3RGTlVPV1d3TlY3Q1lE?=
 =?utf-8?B?VnB4VGN4bm9JcEVWcVMwVk16cytQa3hYZ0dxallZb0xYWHp5eGlVTUxxVlQr?=
 =?utf-8?B?czgzSEVtNHozeWNaa3lpUzFDVzRBR29QSWEzOW53aURPa040L2c1bzZvdlBE?=
 =?utf-8?B?QlFUSEhIaGFJck42aHBNY2IvNTBYdTdaZWdYYStNbU1WQzJzUDBzVXFJYzBo?=
 =?utf-8?B?K05nZ2ZIRTMvTUNjSmpRNHM4b0xBYnFlTUxWcnUrUEFoTm9GMDZOWlVyU2Ji?=
 =?utf-8?B?WEJSNUR3NTR2V1F0R1owRUFUaDg4Y2tMK29ZRjZCMVYrbTFIL2x1ZkF0aldn?=
 =?utf-8?B?eHJjZVRIMkRiazdlL2lQNzFsWm1mS0I2UXBWTTU2bU9sOFg3Ymp6VmlsYU96?=
 =?utf-8?B?Vkx4ZjNVeElUckkxeUxSYnlicjhCbEFnemZjVXJQZ1gvWGhZNFUxNVBOdnpa?=
 =?utf-8?B?YUhkczBDVVFoM056VkRFUjE0MnQrYjgvMmlHQi9DSjZWZ2lUNEdQT1NFL0ZL?=
 =?utf-8?B?RDFoMW9DMTF5L09SOWpRSStaRlpPZFpORlBvVmlSSmdRUzhGKzZNL2FDdUpP?=
 =?utf-8?B?SUM2SU1oRjNBWVh5MitGZjMrK0lFUzhhU1Z6VENtUEFVYjhIUE54V2I1N21K?=
 =?utf-8?B?VEJFQ2IwMFhtR0R1OU5rTFNnWWUvc3p0dU05NUVUSjZOTWJYZGd6cHZwQmxh?=
 =?utf-8?B?dGNCSmtYa1JveWVhTVphYVB2UCtjODNORHZ0WEdVbHk0MTc1cmdtMXdSSWF5?=
 =?utf-8?B?MmtyRVdQWGJJak82K1h6UXpIaXVUbDhDbVpURFkzbStOUUExSTQ0aG1BZFhL?=
 =?utf-8?B?YTJHQnIwNHYxQVRaWHhlRmQ2VEY3elZVRjdETkcvMXNtQk5uaytHTWVPUXdh?=
 =?utf-8?B?OEZKVXVEc3F6M3JUM05ONFVGQXp0L3BzckZYOHRaeVNZaXlTNzBxUXpURGNU?=
 =?utf-8?B?VmlVUklVMjUrWVJVUjBXSjJ4OFh5dmE4M1p2cWpiSnlHeG1HMkdraEN2c2FW?=
 =?utf-8?B?ZVJJYk9veVEzM25mUHBhSkJ6MkRIS3BTSktuR3o2UER5UWZvbkZpcU5XSitH?=
 =?utf-8?B?UmRoSG1SQlJTcXRJblF6VXNTeG9LNnFOZEVUOG43K3dnSFlacEFZWStGRjR2?=
 =?utf-8?B?R1VaQ0pSZmFienVoSU4yRzcxTFVUbThVZ2I5SldpOXJzeDU5N01nSFVRMWNO?=
 =?utf-8?B?WmtHRFl2S0JreXI5WFBFNTdVV0pWN0lZalFYZ2Q1eUxMMWMxaFhPTXptdnM5?=
 =?utf-8?B?eUlCaTd6Y1E3OWZSVkhwSjF0NXdCUWE5UEY5aXQxZVYvaFlUbmlocTlMbzJD?=
 =?utf-8?B?a0NrVzJWM2Y0TktVTllESGZQeE5heU9HV1NyeGdXTUNYOG5LSk96OEN3M0g1?=
 =?utf-8?B?NnFQcW1KdDFmQzg0LzFCUzh1cFY4RE9KZm8wQldCbTZwWlpjV3hneGdCc0Rm?=
 =?utf-8?B?OWhXbThoOWNEMFk2NWcxK0w0TmpoL2ROMStMbjNwemFCbU80Rm53T3VyUk1r?=
 =?utf-8?Q?uNwXWEacm6JZiJiXdTUY8uFF/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: unist.ac.kr
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE1P216MB2287.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b3d542-8d70-44ec-513e-08dd0d438063
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2024 11:22:52.4049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8715ec0-6179-432a-a864-54ea4008adc2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: viVyBiaUonnDJq8FHHNG49OMxYAEuGnwAzWi/Va4GC/IALqS5bT/sjTWa4NtFp0kLG29/KtKdcK1CsC2aYNfFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1P216MB1962

CkZyb20gNmY0NTBlMjBkNDJjMjljNjIzNjU0NTUzODMxYmNiYTc0YTU2NmRhNCBNb24gU2VwIDE3
IDAwOjAwOjAwIDIwMDEKRnJvbTogSW5neXUgSmFuZyA8aW5neXVqYW5nMjVAdW5pc3QuYWMua3I+
CkRhdGU6IE1vbiwgMjUgTm92IDIwMjQgMjA6MjI6MDAgKzA5MDAKU3ViamVjdDogW1BBVENIIFJF
U0VORF0gcWxhMnh4eDogRml4wqAgU1RBUlRfU1BfV19SRVRSSUVTIGNoZWNrcyBfcnZhbCB3aXRo
IHBvc2l0aXZlCsKgRUFHQUlOCgpUaGUgU1RBUlRfU1BfV19SRVRSSUVTIG1hY3JvIGluY29ycmVj
dGx5IGNoZWNrZWQgX3J2YWwgd2l0aCBhIHBvc2l0aXZlCkVBR0FJTiwgZGVzcGl0ZSBxbGEyeDAw
X3N0YXJ0X3NwIGNvbnNpc3RlbnRseSByZXR1cm5pbmcgLUVBR0FJTiBmb3IKcmV0cmlhYmxlIGNv
bmRpdGlvbnMuIFRoaXMgbWlzbWF0Y2ggY291bGQgY2F1c2UgaW1wcm9wZXIgbG9vcGluZwpiZWhh
dmlvciwgZmFpbGluZyB0byByZXRyeSBhcyBpbnRlbmRlZCBhbmQgcG90ZW50aWFsbHkgbGVhZGlu
ZyB0bwp1bmludGVuZGVkIHJlc3VsdHMgaW4gdGhlIHN5c3RlbS4KClRoaXMgcGF0Y2ggZml4ZXMg
dGhlIG1hY3JvIHRvIGhhbmRsZSBFQUdBSU4gYXMgLUVBR0FJTiwgZW5zdXJpbmcKY29uc2lzdGVu
dCBlcnJvciBoYW5kbGluZy4KVGhpcyBjaGFuZ2UgcHJldmVudHMgYW55IHBvdGVudGlhbCBtaXNp
bnRlcnByZXRhdGlvbiB0aGF0IGNvdWxkCmludHJvZHVjZSB1bmV4cGVjdGVkIGJlaGF2aW9yLgoK
U2lnbmVkLW9mZi1ieTogSW5neXUgSmFuZyA8aW5neXVqYW5nMjVAdW5pc3QuYWMua3I+Ci0tLQrC
oGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgfCAyICstCsKgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMKaW5k
ZXggMzFmYzZhMGVjYTNlLi43NjNiZGNjNDc1NjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9pbml0LmMKKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYwpA
QCAtMjA2Myw3ICsyMDYzLDcgQEAgc3RhdGljIHZvaWQgcWxhX21hcmtlcl9zcF9kb25lKHNyYl90
ICpzcCwgaW50IHJlcykKwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGJyZWFrOyBcCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0gXArCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfcnZhbCA9IHFsYTJ4MDBfc3RhcnRfc3AoX3Nw
KTsgXAotwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoX3J2YWwgPT0gRUFHQUlOKSBc
CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChfcnZhbCA9PSAtRUFHQUlOKSBcCsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtc2xlZXAoMSk7
IFwKwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZWxzZSBcCsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsgXAotLQoyLjM0LjEKCg==
