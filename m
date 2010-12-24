From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] [SCSI] scst: Move SCST devices documentation to Documentation/ABI
Date: Fri, 24 Dec 2010 13:01:35 +0100
Message-ID: <AANLkTi=TW6vGbTACZri9AERPCHpSxhGAzNC09Dp_5QNX@mail.gmail.com>
References: <201012222144.47522.bvanassche@acm.org> <201012222147.00547.bvanassche@acm.org>
 <201012231011.47995.konrad@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52689 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0LXMB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Dec 2010 07:01:57 -0500
Received: by iyi12 with SMTP id 12so5768675iyi.19
        for <linux-scsi@vger.kernel.org>; Fri, 24 Dec 2010 04:01:56 -0800 (PST)
In-Reply-To: <201012231011.47995.konrad@darnok.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, realrichardsharpe@gmail.com, scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>

On Thu, Dec 23, 2010 at 4:11 PM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
>
> > +
> > +What: =A0 =A0 =A0 =A0 =A0 /sys/bus/scst_tgt_dev/device/*/exported/=
export<nr>
> > +Date: =A0 =A0 =A0 =A0 =A0 December 2010
> > +KernelVersion: =A02.6.38
> > +Contact: =A0 =A0 =A0 =A0linux-scsi@vger.kernel.org
> > +Description:
> > + =A0 =A0 =A0 =A0 =A0 =A0 Zero or more soft links to the LUNs throu=
gh which this device
> > + =A0 =A0 =A0 =A0 =A0 =A0 has been exported. An example:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 $ readlink /sys/bus/scst_tgt_dev/devices/=
disk01/exported/export0
> > + =A0 =A0 =A0 =A0 =A0 =A0 ../../scst_local_tgt/luns/0
> > +
> > +What: =A0 =A0 =A0 =A0 =A0 /sys/bus/scst_tgt_dev/device/*/filename
> > +Date: =A0 =A0 =A0 =A0 =A0 December 2010
> > +KernelVersion: =A02.6.38
> > +Contact: =A0 =A0 =A0 =A0linux-scsi@vger.kernel.org
> > +Description:
> > + =A0 =A0 =A0 =A0 =A0 =A0 For virtual devices, the absolute path of=
 the associated file
> > + =A0 =A0 =A0 =A0 =A0 =A0 or device. Read-only. An example:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 # cat /sys/devices/disk01/filename
> > + =A0 =A0 =A0 =A0 =A0 =A0 /dev/sdc
> > + =A0 =A0 =A0 =A0 =A0 =A0 [key]
>
> Key?
>
> [ ... ]

Hello Konrad,

Thanks for the feedback. I'll do by best to clarify the documentation
according to your remarks.

Regarding the "[key]" indicator on the second line: that is an
indicator that is either present or absent. That indicator is only
used by a user-space tool (scstadmin) to find out which sysfs
attributes differ from their default value. That indicator makes it
possible to minimize the amount of information to be saved when making
the SCST state persistent.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
