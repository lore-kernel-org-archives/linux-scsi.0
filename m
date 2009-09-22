From: Kelly Bowa <kbpm@tuxedu.org>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Tue, 22 Sep 2009 16:41:04 +1200
Message-ID: <20090922044104.GB7755@tuxedu.home>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753587AbZIVEmO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

* Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp) wrote:
> Hello.
> 
> I can see below message appears for 15 times in
> /sys/kernel/debug/kmemleak after processing /init inside initramfs.
...
Hi Tetsuo,

I can confirm this on 2.6.31-rc9 with following trace:
http://www.tuxedu.org/people/kbpm/bad/scsi-trace

Thanks,
kbpm
