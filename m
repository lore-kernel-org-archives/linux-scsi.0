From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V6 0/4] Fix zone revalidation memory
	allocation failures
Date: Fri, 12 Jul 2019 09:12:54 -0600
Message-ID: <27386e10-7494-7fcf-f203-484db5c3c69c@kernel.dk>
References: <20190701050918.27511-1-damien.lemoal@wdc.com>
	<BYAPR04MB5816BC7EC358F5785AEE1EA9E7F60@BYAPR04MB5816.namprd04.prod.outlook.com>
	<cb26f686-ce7e-9d1a-4735-2375d65c0ea5@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cb26f686-ce7e-9d1a-4735-2375d65c0ea5@kernel.dk>
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
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On 7/11/19 8:05 PM, Jens Axboe wrote:
> On 7/7/19 8:02 PM, Damien Le Moal wrote:
>> On 2019/07/01 14:09, Damien Le Moal wrote:
>>> This series addresses a recuring problem with zone revalidation
>>> failures observed during extensive testing with memory constrained
>>> system and device hot-plugging.
>>
>> Jens, Martin,
>>
>> Any comment regarding this series ?
> 
> LGTM, I'll queue it up for this release.

This broke !CONFIG_BLK_DEV_ZONED builds for null_blk, btw. Please be
sure to test with zoned enabled and disabled in your builds when
changing things that affect both.

I fixed it up:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-linus&id=e347946439ed70e3af0d0c330b36d5648e71727b

-- 
Jens Axboe
