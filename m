From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: how to use SES driver to send SES commands?
Date: Fri, 29 Nov 2013 07:50:25 -0500
Message-ID: <52988D91.1070803@interlog.com>
References: <20131129190730.B2FC.46AD7750@newtech.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53545 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab3K2MvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Nov 2013 07:51:06 -0500
In-Reply-To: <20131129190730.B2FC.46AD7750@newtech.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Newtech Tan <tan@newtech.co.jp>, linux-scsi@vger.kernel.org

On 13-11-29 05:07 AM, Newtech Tan wrote:
> Hi friends
>
>      I subscribed the mailing list just now. Would you please to give me help?
>
>      Who can tell me how to use SES driver(linux/driver/scsi/ses.c) to send SES command(SEND DIAGNOSTIC, RECEIVE DIAGNOSTIC RESULTS) in my linux program?
> (I don't want to use sg_ses.)

Then look at the source for sg_senddiag (sg_senddiag.c).
Your SES device is either /dev/sg2 or /dev/bsg/4:0:0:0

> The following is my system info. /dev/sg2 is my SES device.
>
> [root@tan-sl dev]# lsscsi -g
> [0:0:0:0]    cd/dvd  HL-DT-ST DVD+-RW GSA-H53N B104  /dev/sr0   /dev/sg0
> [3:0:0:0]    disk    ATA      TOSHIBA MK8061GS ME0A  /dev/sda   /dev/sg1
> [4:0:0:0]    enclosu LSI      SAS616x          0502  -         /dev/sg2
>
> [root@tan-sl enclosure]# pwd
> /sys/class/enclosure
> [root@tan-sl enclosure]# ls -l
> total 0
> lrwxrwxrwx 1 root root 0 Nov 29 14:51 4:0:0:0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:02:00.0/host4/port-4:0/expan
> der-4:0/port-4:0:0/end_device-4:0:0/target4:0:0/4:0:0:0/enclosure/4:0:0:0
>
> in linux, I can't find ses device.  Under /sys/class/enclosure, folder 4:0:0:0 existed.
>
> I will apprectiate for your help.

