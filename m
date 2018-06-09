From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: sd 6:0:0:0: [sdb] Unaligned partial completion (resid=12,
 sector_sz=512)
Date: Sat, 9 Jun 2018 15:21:35 -0700
Message-ID: <f96c1329-929b-44a1-4c3a-74dbcedbbafe@infradead.org>
References: <c35dacb574365736229ff04d587abc0390ef7b78.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c35dacb574365736229ff04d587abc0390ef7b78.camel@scientia.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[adding linux-scsi mailing list]


On 06/09/2018 12:23 PM, Christoph Anton Mitterer wrote:
> Hey.
> 
> I'm seeing these errors:
> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] Unaligned partial completion (resid=16, sector_sz=512)
> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Sense Key : Medium Error [current] 
> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Add. Sense: Unrecovered read error
> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 CDB: Read(16) 88 00 00 00 00 01 cd e6 de 40 00 00 00 e0 00 00
> Jun 09 21:13:22 heisenberg kernel: print_req_error: critical medium error, dev sdb, sector 7749426752
> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] Unaligned partial completion (resid=12, sector_sz=512)
> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Sense Key : Medium Error [current] 
> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Add. Sense: Unrecovered read error
> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 CDB: Read(16) 88 00 00 00 00 00 00 14 59 60 00 00 01 00 00 00
> Jun 09 21:13:31 heisenberg kernel: print_req_error: critical medium error, dev sdb, sector 1333600
> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] Unaligned partial completion (resid=12, sector_sz=512)
> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Sense Key : Medium Error [current] 
> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Add. Sense: Unrecovered read error
> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 CDB: Read(16) 88 00 00 00 00 00 c3 a2 56 80 00 00 01 00 00 00
> Jun 09 21:13:53 heisenberg kernel: print_req_error: critical medium error, dev sdb, sector 3282196096
> 
> (many of them) on a Seagate 8TB Archive HDD.
> The disk is only a year old and barely used (since it's just one of the
> backups of my main data disks - and the primary disk another Seagate
> 8TB HDD broke just few days ago).
> 
> I have connected them via USB/SATA bridge... and when I now started
> copying from the backup (which is sdb) to a fresh HDD I started seeing
> vast numbers of these errors.
> 
> However, fsck, cp seem to do fine, and the data (as far as it has been
> copied) seems good (I have sha512 sums of all of it).
> 
> 
> Any ideas what "Unaligned partial completion" and these errors mean?
> 
> 
> Thanks,
> Chris.
> 


-- 
~Randy
