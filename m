From: adam radford <aradford@gmail.com>
Subject: Re: 3Ware 9550SX on MIPS
Date: Fri, 5 Aug 2011 15:49:24 -0700
Message-ID: <CAHtARFHqjYAcw_KON_SWumY4XdD-0KbW3-NTveyLUAeYKiDang@mail.gmail.com>
References: <CAEdQ38FKHh2+QdEz=e9HUEUg-miRYuRe730QEwsjbZYzUF28zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:39587 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1HEWtZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2011 18:49:25 -0400
Received: by iye16 with SMTP id 16so4450506iye.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2011 15:49:24 -0700 (PDT)
In-Reply-To: <CAEdQ38FKHh2+QdEz=e9HUEUg-miRYuRe730QEwsjbZYzUF28zg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Turner <mattst88@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 5, 2011 at 2:34 PM, Matt Turner <mattst88@gmail.com> wrote:

> the card will fit in. I've tried 3Ware's tw_cli utility under qemu:

That will not work.

> Are there any ways to configure this card through /proc or /sys? I
> simply want to get the card to export the single disk to the OS.

You can put the board and drive into an x86 box, hit alt-3 at 3ware
option rom bios, configure a single disk raid unit, then put it back
in your MIPS system.

Unfortunately configuring the card through /proc or /sys would involve
many thousands of lines of code (more than exist currently in the
driver) to create and populate complex raid descriptor structures, and
this code need not be in-kernel.

I have PPC32/64, but no MIPS box, otherwise I could build you a tw_cli
binary that would work.

-Adam
