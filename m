From: Adrian Sandu <dexter@d3xt3r01.tk>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in usb3 port
Date: Thu, 27 Sep 2012 21:23:34 +0300
Message-ID: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA@mail.gmail.com>
References: <CAEG-z28Whi7BufhFnUD8xLZAXjiV0qANc1JNF_62Toget_9CXg@mail.gmail.com>
 <Pine.LNX.4.44L0.1209271031340.1596-100000@iolanthe.rowland.org>
 <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
 <20120927152526.26675.qmail@stuge.se> <CAEG-z29bZGu4HLF=ZD2Rfk9c87Axo=vP-_s0VreuYMy5yA19sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48635 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab2I0SXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 14:23:55 -0400
Received: by pbbrr4 with SMTP id rr4so3970823pbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 11:23:55 -0700 (PDT)
In-Reply-To: <CAEG-z29bZGu4HLF=ZD2Rfk9c87Axo=vP-_s0VreuYMy5yA19sg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

>> Adrian Sandu wrote:
>>> I tried with a 3.3.8 , same thing happened. I don't understand why my
>>> gentoo (asrock) fails and fedora(laptop) didn't ! :|

Tried to use the live cd on my laptop, can't reproduce it in any way
on my computer ..
Using the same live cd I can reproduce the problem on the asrock :|

Tried with 3.3.8, 3.4.11, 3.5.4. I don't get what's causing the drive
to die from a simple hdparm -tT .. :|
The even more weird thing is that it's not dying every time ..
sometimes a hdparm runs successfully once or a few times before dying
.. :|
Guess I just have a bad luck .. ( altough .. I don't believe in "luck"
when it comes to hardware/software/science .. :) )
