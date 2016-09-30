From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v5 0/7] ZBC / Zoned block device support
Date: Fri, 30 Sep 2016 10:18:40 -0700
Message-ID: <f1dadbae-3aa0-f0bf-8f1a-68f4ac64cfa8@sandisk.com>
References: <1475208699-27310-1-git-send-email-damien.lemoal@hgst.com>
 <e00761c2-233f-0354-f150-305f38c6c294@sandisk.com>
 <CAJVOszDkbr8-SezmuP+xH_HjOWeOm5FGNdKqjDBUCKq-B2-rJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJVOszDkbr8-SezmuP+xH_HjOWeOm5FGNdKqjDBUCKq-B2-rJw@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Damien Le Moal <damien.lemoal@hgst.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

On 09/30/2016 09:47 AM, Shaun Tancheff wrote:
> On Fri, Sep 30, 2016 at 11:10 AM, Bart Van Assche
> <bart.vanassche@sandisk.com> wrote:
>> On 09/29/16 21:11, Damien Le Moal wrote:
>>> This series introduces support for zoned block devices.
>>
>> On top of which kernel version do these patches apply? I tried to apply the
>> whole series to kernel v4.7 but that caused "git am" to complain ...
> 
> This series is against linux-next tag next-20160928.
> You should be able to "git am" the series on top of that.

Hello Shaun,

As far as I know linux-next should not be used as a basis for the
development of a patch series. Unless something has changed I think
Jens expects a patch series that applies cleanly on top of his
for-4.9/block branch. But it doesn't seem like this patch series
applies cleanly on top of that branch:

$ for p in ~/\[PATCH\ v5\ *; do echo "$(basename "$p")"; git am "$p" || break; done
[PATCH v5 1_7] block: Add 'zoned' queue limit - Damien Le Moal <damien.lemoal@hgst.com> - 2016-09-29 2111.eml
Applying: block: Add 'zoned' queue limit
[PATCH v5 2_7] blk-sysfs: Add 'chunk_sectors' to sysfs attributes - Damien Le Moal <damien.lemoal@hgst.com> - 2016-09-29 2111.eml
Applying: blk-sysfs: Add 'chunk_sectors' to sysfs attributes
[PATCH v5 3_7] block: update chunk_sectors in blk_stack_limits() - Damien Le Moal <damien.lemoal@hgst.com> - 2016-09-29 2111.eml
Applying: block: update chunk_sectors in blk_stack_limits()
[PATCH v5 4_7] block: Define zoned block device operations - Damien Le Moal <damien.lemoal@hgst.com> - 2016-09-29 2111.eml
Applying: block: Define zoned block device operations
[PATCH v5 5_7] block: Implement support for zoned block devices - Damien Le Moal <damien.lemoal@hgst.com> - 2016-09-29 2111.eml
Applying: block: Implement support for zoned block devices
error: patch failed: block/Makefile:22
error: block/Makefile: patch does not apply
error: patch failed: include/uapi/linux/Kbuild:70
error: include/uapi/linux/Kbuild: patch does not apply
Patch failed at 0001 block: Implement support for zoned block devices
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Bart.
