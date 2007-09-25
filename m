From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Date: Tue, 25 Sep 2007 07:52:53 +0200
Message-ID: <64bb37e0709242252l48d54d16w5f645d324914fd16@mail.gmail.com>
References: <20070921085711.GG2367@kernel.dk>
	 <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
	 <20070923225320I.tomof@acm.org>
	 <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
	 <64bb37e0709241148r58a99403k5f51f364de64eeb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <64bb37e0709241148r58a99403k5f51f364de64eeb5@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On 9/24/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> I will keep on using 2.6.23-rc7-mm1 and post again, if the error shows up again.

On the next boot it did show up again, so 2.6.23-rc7-mm1 still has the bug.

[   33.810000] md1: bitmap initialized from disk: read 10/10 pages, set 0 bits
[   33.810000] created bitmap (145 pages) for device md1
[   63.910000] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   63.910000] ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
cdb 0x0 data 4096 out
[   63.910000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   63.910000] ata1.00: status: {DRDY }
[   63.910000] ata1: hard resetting link
[   66.210000] ata1: softreset failed (port not ready)
[   66.210000] ata1: reset failed (errno=-5), retrying in 8 secs
[   73.910000] ata1: hard resetting link
[   76.210000] ata1: softreset failed (port not ready)
[   76.210000] ata1: reset failed (errno=-5), retrying in 8 secs
[   83.910000] ata1: hard resetting link
[   86.210000] ata1: softreset failed (port not ready)
[   86.210000] ata1: reset failed (errno=-5), retrying in 33 secs
[  118.910000] ata1: limiting SATA link speed to 1.5 Gbps
[  118.910000] ata1: hard resetting link
[  121.210000] ata1: softreset failed (port not ready)
[  121.210000] ata1: reset failed, giving up
[  121.210000] ata1.00: disabled
[  121.210000] ata1: EH complete
[  121.210000] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  121.210000] end_request: I/O error, dev sda, sector 625137161
[  121.210000] md: super_written gets error=-5, uptodate=0
[  121.210000] raid5: Disk failure on sda2, disabling device.
Operation continuing on 2 devices

After that there are many more error like this in the log:
[  135.760000] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  135.760000] end_request: I/O error, dev sda, sector 19551113
[  135.760000] Buffer I/O error on device sda2, logical block 1
or:
[  135.760000] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[  135.760000] end_request: I/O error, dev sda, sector 19551105

Torsten
