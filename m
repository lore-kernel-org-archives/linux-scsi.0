From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Mon, 13 Jan 2003 01:38:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113093833.GD9558@holomorphy.com>
References: <20030113071543.GA9558@holomorphy.com> <3E22738D.3020000@torque.net> <20030113091635.GC9558@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030113091635.GC9558@holomorphy.com>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On Mon, Jan 13, 2003 at 07:06:37PM +1100, Douglas Gilbert wrote:
>> Could you determine which one is happening? If the
>> sg route is being used then the individual SCSI
>> commands can be seen by observing 'cat /proc/scsi/sg/debug'
>> while the burn is in progress. What version of cdrecord
>> are you using and what does its output look like?

On Mon, Jan 13, 2003 at 01:16:35AM -0800, William Lee Irwin III wrote:
> I'm trying Jens' patched cdrecord from people/axboe/tools/ on kernel.org
> and got:
> $ cat /proc/scsi/sg/debug
> dev_max(currently)=6 max_active_device=3 (origin 1)
>  def_reserved_size=32768
>  >>> device=sg1 scsi0 chan=0 id=3 lun=0   em=0 sg_tablesize=128 excl=0
>    FD(1): timeout=20500ms bufflen=129024 (res)sgat=4 low_dma=0
>    cmd_q=1 f_packid=0 k_orphan=0 closed=0
>      rb>> act: id=0 blen=63504 t_o/elap=40000/15ms sgat=2 op=0x2a

Okay, this spewed a coaster too. (2.5.49-mm2). Looks like I'll have to
reboot to have a chance of anything working. I'm going to take a shot
at 2.5.56-mm1 + your SG_IO fixes.

Bill
