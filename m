From: Newtech Tan <tan@newtech.co.jp>
Subject: Re: how to use SES driver to send SES commands?
Date: Wed, 04 Dec 2013 09:42:40 +0900
Message-ID: <20131204094239.3EEF.46AD7750@newtech.co.jp>
References: <20131202101210.62B1.46AD7750@newtech.co.jp> <529C9ED3.8080600@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dc31.etius.jp ([119.245.209.2]:49376 "EHLO dc31.etius.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3LDAmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 19:42:39 -0500
In-Reply-To: <529C9ED3.8080600@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Hi Douglas

Thanks! 

I am using MIPs CPU on embedded system, after cross-compliled sg3_utils package, 
I will try to use sg_senddiag to send ses command.

> I'm not sure what you expect from the ses driver
> in the kernel. If it likes an SES device (and it
> doesn't like some of them) then you will get a
> small, but useful, set of "knobs" to twiddle and
> read in sysfs. As far as I can see the ses driver does
> not create any device nodes (as found in /dev). This
> means there is no way to extend it by using the SG_IO
> ioctl to send SCSI commands to the enclosure via
> the ses driver. And there is no need since the sg and
> bsg drivers already give you that capability.
> 
> Your question is vague, if by "send SES commands" you
> are referring to SCSI commands then again my advice is
> to look at what sg_senddiag and sg_ses do. If that is not
> what you want then write something yourself using the
> SG_IO ioctl on a bsg or sg device node.
> 
> Doug Gilbert
> 
> 
> On 13-12-02 02:12 AM, Newtech Tan wrote:
> > Hi Douglas
> >
> >       Thanks for your kind reply.
> >
> >       sg_senddiag is the sg_ses utility. But i want to use SES driver(linux/driver/scsi/ses.c), do you have any advice?
> >
> >
> >> On 13-11-29 05:07 AM, Newtech Tan wrote:
> >>> Hi friends
> >>>
> >>>       I subscribed the mailing list just now. Would you please to give me help?
> >>>
> >>>       Who can tell me how to use SES driver(linux/driver/scsi/ses.c) to send SES command(SEND DIAGNOSTIC, RECEIVE DIAGNOSTIC RESULTS) in my linux program?
> >>> (I don't want to use sg_ses.)
> >>
> >> Then look at the source for sg_senddiag (sg_senddiag.c).
> >> Your SES device is either /dev/sg2 or /dev/bsg/4:0:0:0
> >>
> >>> The following is my system info. /dev/sg2 is my SES device.
> >>>
> >>> [root@tan-sl dev]# lsscsi -g
> >>> [0:0:0:0]    cd/dvd  HL-DT-ST DVD+-RW GSA-H53N B104  /dev/sr0   /dev/sg0
> >>> [3:0:0:0]    disk    ATA      TOSHIBA MK8061GS ME0A  /dev/sda   /dev/sg1
> >>> [4:0:0:0]    enclosu LSI      SAS616x          0502  -         /dev/sg2
> >>>
> >>> [root@tan-sl enclosure]# pwd
> >>> /sys/class/enclosure
> >>> [root@tan-sl enclosure]# ls -l
> >>> total 0
> >>> lrwxrwxrwx 1 root root 0 Nov 29 14:51 4:0:0:0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:02:00.0/host4/port-4:0/expan
> >>> der-4:0/port-4:0:0/end_device-4:0:0/target4:0:0/4:0:0:0/enclosure/4:0:0:0
> >>>
> >>> in linux, I can't find ses device.  Under /sys/class/enclosure, folder 4:0:0:0 existed.
> >>>
> >>> I will apprectiate for your help.

お疲れ様です。譚です。


以上、よろしくお願いいたします。

