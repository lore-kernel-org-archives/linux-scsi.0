From: Andries.Brouwer@cwi.nl
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Fri, 11 Apr 2003 21:45:30 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200304111945.h3BJjU409008.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

    From James.Bottomley@SteelEye.com  Fri Apr 11 21:12:28 2003

    > It is me who wants compatibility as far as 8+8 device numbers are
    > concerned, while I can see lots of ways to use new number space.

    This, I'm not too sure about.  I see the value to kernel developers who
    boot between different versions of the kernel, but I think when 2.6 goes
    live and ships to end users, it's better not to have such numeric
    equivalency crufting up the SCSI interfaces.

I think compatibility is very important.
Linux does not arbitrarily break old systems. The aim must be
to have all combinations of (old/new) kernel with (old/new) glibc
to work well in all situations where old kernel + old glibc worked.

Andries
