From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v4 00/11] Zoned block device support
	improvements
Date: Tue, 16 Oct 2018 03:43:36 +0000
Message-ID: <BN3PR0401MB16408DC28A398B655DA37F12E7FE0@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<f6062f58-8f8a-b90a-9163-5938632e1a6a@kernel.dk>
	<BN3PR0401MB16409A77BC3EA6E37073DD17E7FD0@BN3PR0401MB1640.namprd04.prod.outlook.com>
	<af21e631-78bc-71f3-60a9-d021f074dab8@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Martin, Mike,

On 2018/10/16 11:34, Jens Axboe wrote:
> On 10/14/18 6:45 PM, Damien Le Moal wrote:
>> Jens,
>>
>> On 2018/10/14 7:43, Jens Axboe wrote:
>>> On 10/12/18 4:08 AM, Damien Le Moal wrote:
>>>> This series improves zoned block device support (reduce overhead) and
>>>> introduces many simplifications to the code (overall, there are more deletions
>>>> than insertions).
>>>>
>>>> In more details:
>>>> * Patches 1 to 3 are SCSI side (sd driver) cleanups and improvements reducing
>>>>   the overhead of report zones command execution during disk scan and
>>>>   revalidation.
>>>> * Patches 4 to 9 improve the useability and user API of zoned block devices.
>>>> * Patch 10 is the main part of this series. This patch replaces the
>>>>   REQ_OP_ZONE_REPORT BIO/request operation for executing report zones commands
>>>>   with a block device file operation, removing the need for the command reply
>>>>   payload in-place rewriting in the BIO buffer. This leads to major
>>>>   simplification of the code in many places.
>>>> * Patch 11 further simplifies the code of low level drivers by providing a
>>>>   generic implementation of zoned block device request queue zone bitmaps
>>>>   initialization and revalidation.
>>>>
>>>> Please consider the addition of these patches in 4.20.
>>>> Comments are as always welcome.
>>>
>>> How do we want to funnel this series? 1-3 look separate, so perhaps
>>> they should go through the scsi tree. Then I can take the rest. Or do
>>> some of the later ones depend on 1-3 being in, in terms of applying
>>> cleanly?  I can also take all of them, looks like only #3 needs a
>>> SCSI ack.
>>
>> Patch 10 and 11 will not apply cleanly for the scsi part without 1-3
>> in first.  1-3, 10 and 11 would need an ack/review from Martin (SCSI).
>> And 10-11 also probably need an ack/review from Mike for the DM
>> changes.
> 
> Probably want to start pinging people, if you're targeting 4.20 with
> this...

Could you please review or ack the parts relevant to SCSI and DM of this
series ?

For DM, changes are in patches 10 and 11
For SCSI, patches 1-3, 10 and 11 introduce changes.

Thank you.

Best regards.

-- 
Damien Le Moal
Western Digital Research
