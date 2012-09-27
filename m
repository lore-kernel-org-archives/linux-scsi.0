From: Adrian Sandu <dexter@d3xt3r01.tk>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in usb3 port
Date: Thu, 27 Sep 2012 17:54:47 +0300
Message-ID: <CAEG-z2_9SqrSZcDSDK45Pdax3i_fJnxs1Mmi94JCgmMzUdLmvg@mail.gmail.com>
References: <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1209271044030.1596-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44344 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2I0OzI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 10:55:08 -0400
Received: by padhz1 with SMTP id hz1so1412607pad.19
        for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 07:55:08 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1209271044030.1596-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

>> I tried with a 3.3.8 , same thing happened. I don't understand why my
>> gentoo (asrock) fails and fedora(laptop) didn't ! :|
>> Why ? What causes it to shutdown ? It can copy to/from drives ( in the
>> hub or directly in the root hub ) .. but what makes it fail sometimes
>> :|
>
> If we knew the answer, the problem would already be fixed.  :-)

Would a usbmon dump on a working 3.5.2 ( my fedora ) for comparison
with the gentoo help ( when doing the same actions that would fail on
the gentoo ) ?
