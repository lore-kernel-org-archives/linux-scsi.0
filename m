From: Martin Dalecki <dalecki@evision-ventures.com>
Subject: Re: [PATCH] ide-scsi 2.5.10-dj1 compilation failure
Date: Sat, 27 Apr 2002 23:41:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CCB1B20.8050202@evision-ventures.com>
References: <3CCB22BB.BA6BDFF6@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-kernel@vger.kernel.org, axboe@suse.de, Dave Jones <davej@suse.de>, linux-scsi@vger.kernel.org

Uz.ytkownik Douglas Gilbert napisa?:
> Christoph Lameter <christoph@lameter.com> reported this
> compile error in lk 2.5.10-dj1:
> 
>>ide-scsi.c:837: unknown field `abort' specified in initializer
>>ide-scsi.c:837: warning: initialization from incompatible pointer type
>>ide-scsi.c:838: unknown field `reset' specified in initializer
>>ide-scsi.c:838: warning: initialization from incompatible pointer type
> 
> 
> Below is a patch which attempts to do the right thing:
> it wires up the scsi new eh handling and attempts to do
> a device reset.
> 
> It has been tested and oopses in start_request() inside
> ide.c when a device reset is issued :-) Since the previous
> ide-scsi logic just ignored scsi error handling, it isn't
> really a whole lot worse. There is a "fix me" at the
> appropriate point.
> 
> Doug Gilbert


Well the "hidden" queueing of some commands on the
device request queue is what is getting you here. It's subject
to be gone, so this problem will be resolved.

