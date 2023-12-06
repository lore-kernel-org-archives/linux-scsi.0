Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="pqWFu2ks"
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F1D5B;
	Wed,  6 Dec 2023 14:50:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWnDgfYeFtg9hTsfU4cVwj5HrNbfzhTQv/kVjnZZl4ipl7h5JJBfsDMSgZp6P6GP8pF7+idowHwuD72vgs2aNUsWb3OzUJ0kJAQO/7kR5JsI6sVzKVIwFxiguISNtJiD7uwE8CbPEgwJca26rzYdZeR+c3nyljokSL3542CizYObNoUDpOQg0ptQuuz6X8YZHqv1t5TtkbLDl4kQISm/hwks7tDySK3aJFUz8WFiIf414HKmjH5UPt/lhylh1yQgXD7bLem9vy+EHKQNbSz8ed314hRDfv4e3M7WSuFRfujab2f9lpd/NFhlu7smFq/O0S45Z/YNND2tV2Qzv0yScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vazqsV1LOXRcC7lfqRXb15yXMraHRtjG8hLYNxzDa0A=;
 b=hSddk/kM0O2waT8Bj9Gm8tBb1+cYCptTGw/oirsy4/pp1xBzXIdtjAahb2P8Vbazp2dMLwUC1eqH88rsvNwxx0obe/TcwuLu+oFupXPL/+f8zYmmqtbe752KJuabCX6cC+Z1Qt/Doq4Sc2qx/WT972yLTtmcXSPz19IDqbbCWmP26RwKRB+yxC7kTbOEFgFnFxpjs+ZmLZM7xUVoml4A0I8iBYwN12csYX+9jnGEiDU7IDZxj2CW/em9v7sxXv8uKjid2nkEuX8W9ebJLpbZTH23DeBWoAPBkxxIMIY9PXKYbc+Xv2LsaNIJfboChuEEzEjiFogDPbinIxGHYsLKdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vazqsV1LOXRcC7lfqRXb15yXMraHRtjG8hLYNxzDa0A=;
 b=pqWFu2ks5hdW/YBb1Fr6eLa5dYkuuIiCIKD0VGuw6ybNricFDoWKMX2fICeM0CD4rg/0BULspwH88UHOvS5DZiWp8nd+Uz7jfsppCCS5GC4qf7DUAIexCg+C5wqmtF7cASLeRW41p8bTOsCv3kRSKahc5EG+Oa0i1c1mt4/R+6sXI3Bbrlw5m1ELBpk072rpojSbJIsGyxvSoBkj3C1Ut7jkj1crXQGtXGfJThjJsAzb5qveXByzqTEDaRtooG8f7y8fjyPJnQs8I3OsRxwWW8GwUDX8mwXfdvK68AQ7gvSycqeGreCHIqbOyMAghLfdcOZt9GYFKvzVOxvo5GeM4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by PA4PR04MB7839.eurprd04.prod.outlook.com (2603:10a6:102:c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.26; Wed, 6 Dec
 2023 22:50:54 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee%4]) with mapi id 15.20.7068.026; Wed, 6 Dec 2023
 22:50:52 +0000
Message-ID: <8cb48bd6-14b9-44f0-a6e0-4e4970ce57db@suse.com>
Date: Wed, 6 Dec 2023 14:50:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Possible Bug? LIO does not support SCSI commands with Immediate
 Bit Set?
Content-Language: en-US
From: Lee Duncan <lduncan@suse.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>
References: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
In-Reply-To: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0226.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::19) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|PA4PR04MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dd7eb80-0190-4b03-a5b3-08dbf6adcc7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d/FOt5LespXumU+oEjq31W61dVnnevVCNlQSy44t8HhXyElnfEkED6nR+S9mOEfcg5Gfo4qzXsXPywpW58uD1VJHBxSZYOM3xoPk700TVB8zRgMPTc12n/TLfTERhxmXUSvjRGsLWxpugY30y4pBQR+R6iOH2GCWsLWUWHyCOo2jEC/vjqBUZnI/412QCoKoq444o6pzwNfzzSiMFgO6ornSB0wY0K6riW1ZWlZ17/oND0JwoTxll6hB5Ch4taBCGPv2oePooeJJLnOsKxL7VNKLaoJM3LXPx5mHLogXgyaB6WBLQVFDVaRMl4NdyhLWiLL+Fc8PFC4wY0F8VVVbbvgI5CavVwbRHAJYpHzQGQ7dQq2XHVGTJHEyGsu/1WMrp3vDrrEJaJ8rvOk2UcRCHxnbg31sssQhR4V+AfddRH5PZLVBI8RTbhCsyDhsgahI16CtD3cm9NRp2D5ZFpw9vg3/c+X1MWNUm/QAwUTUFwo+gqKjn8VUXb+hxjk5JDXN25ebQxyzc743vtuj0pg6bKB9aRp1QUzjEF4GB1CB/bKbTW1Agf5kcjxXGSJVooDFgVSkyYblOsRXmHulr+41AT9Km2pq1JRElsxHxc8+14Wz2Pki1J8og5yxoe6OAXG1A8RiecsP5ObAlDPwvAWhGMfNeD3V/P9R3OH1OJOJaqQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(136003)(396003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(41300700001)(36756003)(26005)(14773004)(6486002)(8676002)(6666004)(316002)(8936002)(31696002)(4326008)(86362001)(6916009)(66946007)(66556008)(66476007)(54906003)(508600001)(2616005)(6512007)(2906002)(53546011)(6506007)(5660300002)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnBnY3FGbysvY2dlWXBuZHVuREtXb0VXQ1ZFL3VZU0gvM0ZoQjQ2cG5VMUJN?=
 =?utf-8?B?MHgyUE5JdkMzSGV4blVpR3JaM3dQSHpWNGtRNVhnclhzK2pjTTRia0dmbldJ?=
 =?utf-8?B?QXczdWtJSnNVVkZzWjRvbkQ4d0RwWXRkVHFxSXFsekhvNkhDdTJqZ3UrSlRG?=
 =?utf-8?B?UjFoQzR2OWwvU2xGclNvSlZHNnFhSWc3dlZwc3lObWlzdG9IVUFpREFLZzBw?=
 =?utf-8?B?NzBHUFB3SnliQi8vYlNwRGNpOGptcmw5dURPSnV2U1BLOEllZ1ZOaTN6S0ds?=
 =?utf-8?B?ZjUwSkhINmxZNFR6NzRFMFhHYTNMZVc2aThBK1FQYW9UbzVoY2tCYjYwcGtu?=
 =?utf-8?B?dFc0VzJIa01CTzVQeVZSajFRblBBVk8rcWdSVnJhekxiRE0rVG40VU1tTnQv?=
 =?utf-8?B?VGZPOGxvVE03bTJMQWg3ZkxGbzh1d1ZSVHZWZ3VBUUZmNGJGcnB5QnUyTFFj?=
 =?utf-8?B?V2NOOXFDcnhUMHZCVW1vNFBGczhXUDBmbVFuRndNMEV2bmtSSm5XbVMxNGNP?=
 =?utf-8?B?NjhoaW13NFR6VnFpckMzdVpyOFU2ZDNlWDNkSk54VmxMNlIzam5oZTRYZGRv?=
 =?utf-8?B?SDBiQmUvRXk3bkZuMjBNU3Mya3g2T1NOTXlKYnlmUXUrRlExY0x4NXdtZ1RX?=
 =?utf-8?B?SzNCRGpCSHE1c3ZXODgrelAzMFhMeUNHYlExY1R2U0l1bkpDUXczZWtqdEtP?=
 =?utf-8?B?eUNFMWQ1c3BRQnEvanFuU1hZOVNTeGNhZ0lDN2l2Nm5MK0taMTQwS08xVWZ6?=
 =?utf-8?B?SXZXU2NtMWNTbks0eFNFUjFDbXVuaWtIajZCQWhmMWRLaThmK1AxQXJvcnRH?=
 =?utf-8?B?YzNoZ3NndlVXRkxuYkVmMGgyd2NvTVNBTTVtQ3B0WHQ3NlI1d0duakRydVQ5?=
 =?utf-8?B?cjBEdzV0NXNoZHV4MGhtQ3g1TnE5Qm5iTjExVjcyeEN4aS9IL1ZJVUxEYmcz?=
 =?utf-8?B?Y0VzbUlvOGJieCs3TWhseTliN1hJWXlWcS8zVGxpMW1vekhFQjZHOVA4aEpt?=
 =?utf-8?B?b2dNQmFEak0yQnQ4RzhwZ3Z5S2h2ZzRZdFduamRzMGtyUHdmWmkvbnNnWnAy?=
 =?utf-8?B?S1BhL2w1V2NTM3FUQzJUQ1REOTQ0UE5mY25JTFdlZVBXcG83L29ScWxIUktU?=
 =?utf-8?B?Mm8yK1Y2UWlOVGY2TTMrYW5HZm8ySUVSOUVsa0hDL2JXTDNFbzBUVldlaUlQ?=
 =?utf-8?B?L2hLVUVGNktTNzlSVXJYaW4rQmk2UEtQdGtNVnVFL0R2dTZqTm9BSUpyTDN1?=
 =?utf-8?B?bS9GR1FaVWpKY1JqVjl5T1c1SHQxaUtFRStFd05XamNDZmljZ0hEMENEcTRT?=
 =?utf-8?B?dmJERVNyQSs1TXVMd2QvMG50NTErOW9qYUUyTWpuWFJIR3hYNVNjZnVBYW1Q?=
 =?utf-8?B?VWFGWUl1TFMxNDlyam5WMVNQL1BtR3hDNUR6MEhUNURydFllUGN2TldWenAz?=
 =?utf-8?B?eU1xRmY5ZTlQWkcxNmI5bUhVblVFN084UnF1MFRCMDNZdDJxK0I1U0N3a0U5?=
 =?utf-8?B?b0JOTnIrczdOUkMyRDJhVUlyMGdFL04rSjM1a3Z1N3pCMDhNWS9WYnpxSGt4?=
 =?utf-8?B?MXp3Y2JlZlNLVXJaVjZHeFZIaEZjKzhBVWhmdlVVNTNIOFBidjhUU3NOYU13?=
 =?utf-8?B?azR1TER3bko3dDMyQ1lSankxeGN3SmxnTlU4MzRhZ2ZnSkQzMHpBVkFsTzBm?=
 =?utf-8?B?MlhScVNUMXlHRTVCRWxYY0VoL0QyS29NZS9xSTdDTlY3MUMwdXhFU2JiRTR6?=
 =?utf-8?B?U3hhTy9wUTROYzRoZTR5bkk0ZDlJcDFRdHNWNDFmcGJLM1lWTTQwb2JuK2JB?=
 =?utf-8?B?OURXYnBoMS9mK29JaGs5clNlc0RvcEFDL1JULzNVdzE2VmVIbmM4Si84TVl6?=
 =?utf-8?B?OXZlaFpvS004OWlzZHUvSWhrQUJXNnJSWGIrcGMzUlFWQnoxa1BTVFlialBs?=
 =?utf-8?B?TExtRjhVTFIwWnBSeTl4TW8vMFpBSmV5bzdTMlJIMkU0azJBWE8rTXNCWnVx?=
 =?utf-8?B?blJaVTM0V1NDMnFRZUN0d3ZZVTR3Tm5uT1RVVlJaN2FCYjlhekFzNy8rYVhH?=
 =?utf-8?B?eHVvaHlXUGdNeE9icGgvVEhxVnh0RXZXQXZicFFVYng0RHFqeFBTUHk1S04w?=
 =?utf-8?Q?3//O0S+l0gel7NXHbMY/Q5VB8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd7eb80-0190-4b03-a5b3-08dbf6adcc7e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 22:50:52.6153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGwbWvyE1AFERUwS86XRHLWbdhNKzsXRuWdVHLDBFqRsDZfiONdcMyNmcf6ECCEnmC/0qSd25gKX4NUjOkvDtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7839

On 11/25/23 10:28, Lee Duncan wrote:
> Hi Martin/list:
> 
> I am trying to track down an issue I am seeing when trying to boot using 
> iSCSI root using the fastlinq qedi converged network adapter initiator 
> and an LIO target.
> 
> In this configuration, but using a non-LIO (hardware) iSCSI target, 
> everything "just works". But when I switch to using an LIO software 
> target, I get this error when booting:
> 
>> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set 
>> Immediate Bit in iSCSI Initiator Scsi Command PDU.
>> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI 
> OpCode: 0x52
> 
> It looks like the fastlinq adapter is sending a SCSI write (0x12) with 
> the Immediate bit set (0x40).
> 
> The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:
> 
>>     if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>         pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>                 " Scsi Command PDU.\n");
>>         return iscsit_add_reject_cmd(cmd,
>>                          ISCSI_REASON_BOOKMARK_INVALID, buf);
>>     }
>>
> 
> But I looked at rfc3720, and it looks like SCSI PDUs can have the 
> Immediate Bit set:
> 
>> 10.3.  SCSI Command
>>    The format of the SCSI Command PDU is:
>>    Byte/     0       |       1       |       2       |       3       |
>>       /              |               |               |               |
>>      |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>>      +---------------+---------------+---------------+---------------+
>>     0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>>      +---------------+---------------+---------------+---------------+
>>     4|TotalAHSLength | DataSegmentLength                             |
>>      +---------------+---------------+---------------+---------------+
>>     8| Logical Unit Number (LUN)                                     |
>>      +                                                               +
>>    12|                                                               |
>>      +---------------+---------------+---------------+---------------+
>> ...
> 
> Where "I" is the immediate bit.
> 
> Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if 
> I'm mistaken here, but it looks like LIO does not allow the Immediate 
> bit (and hence Immediate data), even though the SPEC does allow it. But 
> it also looks like, during negotiation phase, LIO negotiates 
> ImmediateData like any other parameter, allowing "YES".
> 
> In our testing, if we set ImmediateData=No in the target, then our 
> problem goes away, i.e. we can now boot from an LIO target. This is 
> because Immediate Data is negotiated off, of course.
> 
> Is this a bug, or is this adapter doing something wrong? I would 
> appreciate other viewpoints.
> 
> Thank you.


Note: I have sent a set of two patches for this, but evidently my mailer 
is considered SPAM now? I'm working on getting it figured out.

-- 
Lee Duncan

