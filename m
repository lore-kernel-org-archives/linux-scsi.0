From: Steve Ralston <sjralston1@cox.net>
Subject: Re: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: Wed, 07 Aug 2002 06:12:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D510084.3040708@cox.net>
References: <20020807043057.395C74BD6@lists.samba.org> <1028720225.18156.246.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On 08/07/2002 06:37 AM, Alan Cox wrote:

>General policy - rip out version ifdefs unless the driver has a
>maintainer who actively objects ?
>

Hi Alan,

When I worked for LSI, and was actively maintaining 
drivers/message/fusion/...
code, we had a single set of driver source code that compiled and ran
across lots of linux kernels (2.2.5 thru 2.4.19).  Most of the 
version-specific
#ifdef's were isolated to one header file (linux_compat.h).  We then 
also had
a set of patch files (each pretty small) that could be applied against 
any explicit
kernel (in the supported range).  A customer could then (in theory:-) 
download
one set of driver source (including the patch file sets), untar/overlay it,
apply a single patch file, and then compile+run the drivers on any of 
those kernels.

So just curious, are you saying that you'd rather have driver maintainers
maintain a separate set of driver source for each explicit kernel (with no
version-specific #ifdef's) vs. the way we did it above?

Thanks,
-SteveR


