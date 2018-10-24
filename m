From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v4 00/11] Zoned block device support
	improvements
Date: Wed, 24 Oct 2018 08:04:53 +0000
Message-ID: <BN3PR0401MB1640DDD064340B0C074055AFE7F60@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<78778e22-9c5e-99d0-ef5c-85e04d03a4b7@kernel.dk>
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
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Jens,

On 2018/10/23 16:59, Jens Axboe wrote:
> On 10/12/18 4:08 AM, Damien Le Moal wrote:
>> This series improves zoned block device support (reduce overhead) and
>> introduces many simplifications to the code (overall, there are more deletions
>> than insertions).
>>
>> In more details:
>> * Patches 1 to 3 are SCSI side (sd driver) cleanups and improvements reducing
>>   the overhead of report zones command execution during disk scan and
>>   revalidation.
>> * Patches 4 to 9 improve the useability and user API of zoned block devices.
>> * Patch 10 is the main part of this series. This patch replaces the
>>   REQ_OP_ZONE_REPORT BIO/request operation for executing report zones commands
>>   with a block device file operation, removing the need for the command reply
>>   payload in-place rewriting in the BIO buffer. This leads to major
>>   simplification of the code in many places.
>> * Patch 11 further simplifies the code of low level drivers by providing a
>>   generic implementation of zoned block device reuest queue zone bitmaps
>>   initialization and revalidation.
> 
> I've applied this, but I have two complaints:
> 
> 1) Two had to be hand applied, it wasn't against the block tree.

My apologies for that. I had to rebase against the latest RC because of a
conflict with late fixes in DM. I should have checked more carefully against the
block tree after that. Sorry about this, I will be more careful going forward.

> 2) The ordering of the signed-off-by. Someone told me that this is
>    patchwork, but I absolutely hate it. SOB should go last, not before
>    the reviewed-by. I fixed that up too.

Thank you. I think this was me rather than patchwork when I a manually added the
reviewed-by tags with new versions of the series. I will remember this and tag
in you preferred order.

Thank you.

Best regards.

-- 
Damien Le Moal
Western Digital Research
