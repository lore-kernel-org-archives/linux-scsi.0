Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1483D16FC;
	Tue,  2 Jun 2026 09:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780393333; cv=fail; b=urntPpXSwOeFn8A4jFq0UBhkIoSaf5St+o970NvAsoEZqMCl6c0AJ1gGzNZwKLLeUclyjoQ6RWPxZQXxVwEeVPf/vDEcO2c0hnfhCZzMhIBi624ZNIQ7lluDg6Qhfi6rYaJcImDCXUuAZQcqLjjn+jBLb2vagQljwTotcvZXYAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780393333; c=relaxed/simple;
	bh=pyPg3m7V505fYe/2ZW+syKiUxDYqtd6wUGxQEuW7poU=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FoU7wQqEt/c0kmih2+aC7dvBUZ6TiE/MxLzAL9TIefWG4ArctKiG4xrC+jMH6GLuo+G4ijmWVrmaAD9WHRojFmI0oYNY9cE7BHNLY+K3UbbP08TRIdQFRhCJGgntHuUe9WgulNPzeF7LEbMikG4Z7Uq9nknFDYXzR4fDvma8Jt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r6OL9guE; arc=fail smtp.client-ip=40.107.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r6OL9guE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tl5zoNVjJSYx712vUbs+V17jp162jUBnYsM1uveeJRqaKGy8FMCR1gNAWego7VaC03beNcs5j5AhSCU2piHEeU2y5rd0IRIARspZiPEy+w8zBmTh94Lc/fE2YlO+oUUAXfYXeOZGUcJdafhk6ibAMXWrfa/qQ6BzUygO/DytHUXljy25n3tJ7KjJncU8URGp9/CXvQPcOBccR6KTfgavpYy/55Im1gL+US0HocS6r2l96AmTRAivAEVRCxXJNua6HEn4UcmDZkAp611lAtD4u3yxHVKzdSN7bepkbOO/Wabaf8yWaMhKy/FGBCC6JJbKyOnxYtTL2MyHJDVQna9Oig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fL0Q49f6qebq7VNP79dNbVGfGifq5odYBw/B+1ZMMiM=;
 b=iK5rnMyo95UZk1rOIoIERPqrc83pRn7oSjBh4dz3GOS1mZh3EA/gv7pEZLVXHyMe6AsoX878p3B2TryyK66ojdoQed7C4LWGdS07n5WUbckW3e+lVEK4VXph+LntZfbRPRWQxdw/fqIUii/ycg88ycpkyuYXwqG2kbxkzvs5tE+/viESl9EeEnIHZJw2WiWeVN7bZKzKVbIaKPCNAub1hRLL57V9LwSOdIdu7bcD9yuvbJel3EZh99FnZB9ESlIb2ot78ivDVJOuP7PqJikzeV397A8tz0zg3QPIN4yeLNkobb2rabT/R9xZaLIljWO0ahUKbM+PK4i3CZWoeJcj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fL0Q49f6qebq7VNP79dNbVGfGifq5odYBw/B+1ZMMiM=;
 b=r6OL9guECSgrj/KQwJwNlZYo0Vcwemvg+ucoqAIw+1Om0aMXkG6nnUPdqbuH3uL+TQdW84IQmNwMX9aCh3Vq/+VCZ4P8abwmAYZ6nbuYT3PwKiwOvFuOzv7enIR/HU9cgZpl6A3ZAeM4JXH/dT24YTzTDrNaBhyk5W1t5gLwtsM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5479.namprd12.prod.outlook.com (2603:10b6:8:38::18) by
 SA1PR12MB6773.namprd12.prod.outlook.com (2603:10b6:806:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.17; Tue, 2 Jun 2026
 09:42:08 +0000
Received: from DM8PR12MB5479.namprd12.prod.outlook.com
 ([fe80::7c92:77b4:fa4d:cc41]) by DM8PR12MB5479.namprd12.prod.outlook.com
 ([fe80::7c92:77b4:fa4d:cc41%4]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 09:42:07 +0000
Message-ID: <c793f078-1dc0-4f38-86ef-e3eb5675e3ec@amd.com>
Date: Tue, 2 Jun 2026 15:11:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add AMD device ID support
To: Adrian Hunter <adrian.hunter@intel.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, archana.patni@intel.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260601095336.1396787-1-Rajeshkumar.Sambandham@amd.com>
 <0b812b4b-2683-44fe-8983-5322a9632c05@intel.com>
Content-Language: en-US
From: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
In-Reply-To: <0b812b4b-2683-44fe-8983-5322a9632c05@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0072.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:267::12) To DM8PR12MB5479.namprd12.prod.outlook.com
 (2603:10b6:8:38::18)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5479:EE_|SA1PR12MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ba0213-25fc-4efc-2dac-08dec08b35ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|4143699003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	yq7bvQY7IPnxc3I7EyfSGmsGQKreLYX2P/U8q12TG6wdN8OzhZC3QL50uPWO6a7rAwyZvvoLkWeGQppkXSasI3WZb71fFpGWgd/WrMpnV+0KGIUuR4olwK6HnPAPh08Gdja/raNNfIu04GJJ736qDUj4zeRbmOo/2NK/UwIMQvDeTY2swMbmXZ3x2TUY7OpUlZLsBlIruLtFeW9DUhZYtOsP7UF/aBkBYyo2n0ADqiA6BoSXx+S9V2XEnRsU5zA5pSvZcgmge58J0do4bI/Y8jEIX7rREYoaCPs7GLai0lB6b9EoyOQcXcomuxzLocYFJrlOtdlNX9CosAPitNk/3NG6UI3FpT2EyKtFZf4TzJMVC18FrbqKtit3c5GcAysHYXYf8lBwLlXRAq+qOk2tDATuglGOu7ASEQFEL6E+GoRkgVS6YgoVNVvRKyexDT/j87y0z6rOQ8K0eywR7SaUtVDJUudz78151ria4k3Jusx1I9QkuduUQ5KoiIshqnpgT72gStk/0aynHtVZzQw4FmSFZm9ZnO/n/0vnNVVSE0Qg/ELYQToINliRMWIBY+oXFqYihiRCVUzDMPUSngw3GAMRWd+JGso7uJKKbLI4kAj+4du+NEcKwO96tm50U7GOr6I6kaJm2Ho97OsdQpnH3qnutnbmiIVXLC5j2xrux+BFzPYjASeu83zNXWmFa5JB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4143699003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dE1TNTRnSTg5YTNHQ2dYUnRLSlcyRWJkYmRrUmlZVEVWK2pGL3BMV1kzd0hr?=
 =?utf-8?B?Y1AzeEhrRDZrYUg1SVhKVEtkaVRGbmJwQVZZUkkwVmtvNmxpWUNnNTBvNmpR?=
 =?utf-8?B?RWc4S1VobWR4SkhGK1NJS1lzQVhURXVKQng5Q0RrTUUrWjA4eFZ3cERtMUFF?=
 =?utf-8?B?aFljRG1acWU0ZXRLRnpUeCtkSFlkc09tb1lOS3BWMkF1bEhvMUoxMWRkK2Rh?=
 =?utf-8?B?VGMyYjJ1K2g0VkdVOVBtSFl0eXgvUzJBVjBiaVRESGJLMU90NVdiNkgyV0NF?=
 =?utf-8?B?UUhWVkxVVTIvSGdpd2s3dWhNcEQ4aEtzbmV4eDdYN201WCtjcXBjSnNEY1Zz?=
 =?utf-8?B?R1NJcy9QOHpnMEdPcUlwdkhoWjFFNmEwcTFsaGhJV212R3UwZ1pYRHBqSE1p?=
 =?utf-8?B?TkN2OU9jMC80emxNUk5wbm5IUGZOZWMwWnNPSW8rYm16SGExSDJIY1Z0WXpx?=
 =?utf-8?B?SmZYWmdlZjFvMjNSdEd6WkptNnZlZW5ZNlFoZlNzN0psUzZadmc0Rm96TjZl?=
 =?utf-8?B?cyt2Y0RIS091bGUxakliZUxXcy9CWkQzaVZYM0dZY3lBQld5SXNaMzROMjNF?=
 =?utf-8?B?aVdWMDVDbVNoTm1DWE8rbUkrejlYTTZucGQ4ajJGNU1VeEhHcUxudWd3Y1Z5?=
 =?utf-8?B?Y0s0eWNSSEhFY0V4SGt3ZzBxMlNWRDlXK0pjZm9mbmdETEpxYUdQZUxHdGdr?=
 =?utf-8?B?N3BSck50ZTR5OTRxNkwrUGUyU25OczNwWGcvR0oyTUpNeEh1MFNsTXkxL1lq?=
 =?utf-8?B?dlB0cHJVUEpDWmNVSnU1cVNXWEg4NU9Sbll1emdreGJwaVVidVdDczFzYllH?=
 =?utf-8?B?NjVIejdPM1ZlQUJ5OEpza2tHUkFNNk0wNkYwZlJiMHZiRGF4K01XMmxMa0ly?=
 =?utf-8?B?bXFnQ2M5YVlCSC9WbDZTTS8xT1NjTElheXkwSGY4czFZTEZuUytYdnVmQTJL?=
 =?utf-8?B?MFBTc0JEYzgxNEZka0t6TUp6SmVFamlUbDBxVlBXSXVVMEFNRzRBdUJ0Tk1p?=
 =?utf-8?B?NWxTekRWUHMxWjFCbGFxTGZMb1NnZm9pTzZjWVRIaUw5bXhXcTNCUEt2WERz?=
 =?utf-8?B?b2R4T0pyV2ZrUGN5VkF0TERjc1p6M05rVWs5V3d0UXJyNVBKUk5QaUpDTlNs?=
 =?utf-8?B?ZHgxNUg3QldVaU9Ec2NESjdScTliVDFBdWluL0lKaDdGTGsvMVY4RVUxMS9X?=
 =?utf-8?B?dHdiL1NWbldNSXZSUnpvd2hGRU43bk0rNHNydGgxYUp1a3Y1aWxnS1B3RmRk?=
 =?utf-8?B?aiswRGZuekU0SEsyTktNNHFXYzAxS0xmNnQ4MXFHVzdOTWtWeTBZSkNRME1J?=
 =?utf-8?B?dFYzY3c5Qm5yaWJhUHN5dCtjeVBoRzdhYWVKZ1Y0WTVIb1gzTWg3SWpYaDBi?=
 =?utf-8?B?VVFMeGF4Z3N1NWJUdEFCQkFIZUhPU2s5UVJwdURKazFIS1AvcHJJc0lyVW5r?=
 =?utf-8?B?bTVWamx0VE5ZdE1SbFNVU1lOeXdxTndybjRaanJPc0NUZjU4L1QrRFlvUGll?=
 =?utf-8?B?R3Mwd0N6cUNScmRZOGNjRllzQXV2SGd3WUhnZ2lJVkM2U1VXTTZ3Q3l0ckZH?=
 =?utf-8?B?SFlmbFFrdlRHMW91RlJhMDJ3Q2tHZFBoTlFXZ3NKN1B5SHVNTklyMlFwcFNZ?=
 =?utf-8?B?Z0V6VkVwcHBGbzVaYkFBSVdRbGp3RmN3NnRhNFJ4NHFJdkhnVlpuMHRWeGs1?=
 =?utf-8?B?UDVBeW1iRUh1Q210blBkQnIrQkZNaiswSVRYOUM0TmduVWEvcEg0Umtwa0dH?=
 =?utf-8?B?SnI0WU1hQjdBOVc2Uzg1U0pDRk5mTUF0cXFtbW9oVDFNcXpXVjlSUzQzUmU1?=
 =?utf-8?B?Rm8xNlBWaUsxc1R5NEVIdG5aY2hiSFRHVlJNMGtxQWV2UkhyZ2g4KzhKWWgy?=
 =?utf-8?B?UFMwMUV3aTdIUnB5SmkyWUZrUTgrM2QwOTdNd1BEN2NCWDE2ckZjVjlUNW1Y?=
 =?utf-8?B?YzZUcVB6V3BJenFsMkovTWxCbXNzU0dEZG5URVZXT0NRN3RGeHc4eS9TSEE5?=
 =?utf-8?B?ZVVob1duRVdGYXkzOXEyUmU1RTUvZVVmVnhiTHFnL1ltb0ZaKzBraXZvYm1E?=
 =?utf-8?B?c2tDdXBFWitUS0NYWFZZOEpudVB6TEdrSmZIZWtJRENSZlJXSHlmMVB3U1pl?=
 =?utf-8?B?VmcxWmtxR3R1NUhRYlBtS1orcjlucmlsTkhQbVM4QVlEMXgvWFo3cGRxTjVl?=
 =?utf-8?B?WEc5bkxlM2w4M2h2SW1XUjF4TUJiY0w2RC83eCszV1Z3dVpIL2dSSjMwREs1?=
 =?utf-8?B?cWpWN3hLRVFZZlZubHQxbjRoNWw2T085ZW9KTnh4Y2tUdEtBdXJValJzc0po?=
 =?utf-8?B?TmJOOXdjNXAvK3R5dSs2OTVoTlJCU25aWks1YzV4NHZuSjZBMTdXQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ba0213-25fc-4efc-2dac-08dec08b35ff
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 09:42:07.9038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lXIzvshmnKUH4OnuYPdps3F3RQp696YbAZVf5TgkSVhsWHiY9UfVI4iioTjeQwBYUGkLx6rHkGihKUPdMoJqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6773


On 01-Jun-26 3:56 PM, Adrian Hunter wrote:
> On 01/06/2026 12:53, Rajeshkumar Sambandham wrote:
>> Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.
>>
>> Signed-off-by: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
> Does not apply anymore since "scsi: ufs: ufshcd-pci: Use PCI_VDEVICE
> and named initializers for pci array"

Ack, I will update the patch accordingly and send v2.

>
>> ---
>>   drivers/ufs/host/ufshcd-pci.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
>> index 5f65dfad1a71..9ad42e07a94a 100644
>> --- a/drivers/ufs/host/ufshcd-pci.c
>> +++ b/drivers/ufs/host/ufshcd-pci.c
>> @@ -684,6 +684,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
>>   	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>>   		(kernel_ulong_t)&ufs_qemu_hba_vops },
>>   	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>> +	{ PCI_VENDOR_ID_AMD, 0x1B29, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>   	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
>>   	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
>>   	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
