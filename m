From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: dc395x: "Please contact" message received in syslog
Date: Sat, 17 Jun 2006 10:39:47 +1000
Message-ID: <646765f40606161739i641c0f8cwe1b39dd31caf27e8@mail.gmail.com>
References: <646765f40606160438v7f10f390jc7804aac1d47c721@mail.gmail.com>
	 <Pine.LNX.4.60.0606162003500.4068@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:48495 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S932491AbWFQAjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jun 2006 20:39:48 -0400
Received: by py-out-1112.google.com with SMTP id i49so758928pye
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2006 17:39:47 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.60.0606162003500.4068@poirot.grange>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On 6/17/06, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Fri, 16 Jun 2006, Julian Calaby wrote:
>
> > I received the following message in my log:
> >
> > drivers/scsi/dc395x.c: Please, contact <linux-scsi@vger.kernel.org> to
> > help improve support for your system.
> >
> > Umm, so here I am =)
>
> Thanks for writing.

Not a problem - I was going to poke around in this driver, but haven't as yet.

> > I received this whilst burning a CD, and can attempt to re-produce it if
> > needed.
>
> First I'd like to ask you for some more information about your system: CPU
> (32/64 bit), amount of RAM

CPU is a P4 class Celeron running at 2.4 GHz

I have 256 MB RAM.

I'm running kernel version 2.6.16

> and if you get any other messages in your log
> around this one.

That's hard to say - I'm used to random SCSI related messages popping
up from time to time - I'll burn a CD before and after applying your
patches below and send you the results.

As for log messages, I get:
dc395x: Target 03:  Sync: 100ns Offset 8 (10.0 MB/s)
dc395x: eh_abort: (pid#171551) target=<03-0> cmd=cf1d1c80
dc395x: eh_abort: Command in progress<6>dc395x: eh_bus_reset:
(pid#171551) target=<03-0> cmd=cf1d1c80
dc395x: doing_srb_done: pids G:171551(03-0)
appearing from time to time, before and after receiving the "help us
improve support" message. I put these down to a flaky burner.

> Was it the first time you burned a CD on this system with
> this kernel? If not, maybe you could look in your logs if this message has
> come before, and, possibly, under which circumstances? Do you have other
> devices on this SCSI bus? Did the operation (CD-burning) succeed and was
> the CD burned correctly (maybe, read back and compare)?

This was the first time I've burned a CD with this kernel.

A bit of history: I have a spindle of CDs which I couldn't burn with
my previous drive, and digging through a dumpster I came across my
current one, which is the next model up from my previous one. This was
my first attempt to see if it would burn a CD.

As such, I have no other logs for when I've burnt CDs.

However, I used to get my logs spammed with:
dc395x: sg_update_list: sg_to_virt failed
lines, however this has stopped with kernel 2.6.16 (it started back
before 2.6.12)

This is also, the first time I've really played with the CD writer
under this kernel. If there are other messages, then they're lost in
the spam mentioned above.

As for the SCSI bus configuration, the CD drive is ID #3, and it is
alone on the bus, (and terminating it)

As for the CD burning itself, this did succeed. The CD read back
correctly on my IDE DVD drive.

After this had happened, I burnt another CD which, whilst appearing to
be read on a visual inspection, could not actually be read by another
CD drive.

> If indeed the message is pretty reproducible (I don't want to ask you to
> burn 10 CDs to reproduce it once more:-)), maybe you could try to apply
> the following two patches:
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114400790021967&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114565338708969&w=2
>
> in this order and re-test?

Ok, I can't do that right now, (exams) however, I will do this either
Monday night, or Tuesday. I'll get back to you with full results then.

> Thanks
> Guennadi

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
