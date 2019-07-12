From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V6 0/4] Fix zone revalidation memory
 allocation failures
Date: Fri, 12 Jul 2019 22:33:21 +0000
Message-ID: <BYAPR04MB5816F76F09488AE706B49F72E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190701050918.27511-1-damien.lemoal@wdc.com>
 <BYAPR04MB5816BC7EC358F5785AEE1EA9E7F60@BYAPR04MB5816.namprd04.prod.outlook.com>
 <cb26f686-ce7e-9d1a-4735-2375d65c0ea5@kernel.dk>
 <27386e10-7494-7fcf-f203-484db5c3c69c@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On 2019/07/13 0:13, Jens Axboe wrote:
> On 7/11/19 8:05 PM, Jens Axboe wrote:
>> On 7/7/19 8:02 PM, Damien Le Moal wrote:
>>> On 2019/07/01 14:09, Damien Le Moal wrote:
>>>> This series addresses a recuring problem with zone revalidation
>>>> failures observed during extensive testing with memory constrained
>>>> system and device hot-plugging.
>>>
>>> Jens, Martin,
>>>
>>> Any comment regarding this series ?
>>
>> LGTM, I'll queue it up for this release.
> 
> This broke !CONFIG_BLK_DEV_ZONED builds for null_blk, btw. Please be
> sure to test with zoned enabled and disabled in your builds when
> changing things that affect both.

I always check the !CONFIG_BLK_DEV_ZONED case. But clearly I made a mistake
somewhere on this one and missed the problem. My apologies for that.

> 
> I fixed it up:
> 
> http://git.kernel.dk/cgit/linux-block/commit/?h=for-linus&id=e347946439ed70e3af0d0c330b36d5648e71727b

Thank you for this.


-- 
Damien Le Moal
Western Digital Research
