From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Mon, 13 Jan 2003 02:35:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113103502.GA940@holomorphy.com>
References: <20030113071543.GA9558@holomorphy.com> <3E22738D.3020000@torque.net> <20030113091635.GC9558@holomorphy.com> <20030113093833.GD9558@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030113093833.GD9558@holomorphy.com>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On Mon, Jan 13, 2003 at 01:38:33AM -0800, William Lee Irwin III wrote:
> Okay, this spewed a coaster too. (2.5.49-mm2). Looks like I'll have to
> reboot to have a chance of anything working. I'm going to take a shot
> at 2.5.56-mm1 + your SG_IO fixes.

Okay, 2.5.56-mm1 + your SG_IO fixes got the following in the debug stuff
with Jens' patched cdrecord:

$ cat /proc/scsi/sg/debug    
dev_max(currently)=6 max_active_device=3 (origin 1)
 def_reserved_size=32768
 >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
   FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=63504 t_o/elap=40000/29ms sgat=2 op=0x2a
The mail in /var/spool/mail/wli has been read.
$ cat /proc/scsi/sg/debug
dev_max(currently)=6 max_active_device=3 (origin 1)
 def_reserved_size=32768
 >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
   FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=63504 t_o/elap=40000/66ms sgat=2 op=0x2a
$ cat /proc/scsi/sg/debug
dev_max(currently)=6 max_active_device=3 (origin 1)
 def_reserved_size=32768
 >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
   FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     rb>> act: id=0 blen=63504 t_o/elap=40000/10ms sgat=2 op=0x2a

and it burned another coaster.


Bill
