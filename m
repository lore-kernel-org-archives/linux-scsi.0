From: Andries.Brouwer@cwi.nl
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Fri, 11 Apr 2003 13:42:13 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304111142.h3BBgDS11628.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:10384 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264336AbTDKLad (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2003 07:30:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com

    From: Badari Pulavarty <pbadari@us.ibm.com>

    >     > But you see, the present sd_index_bits[] gives no such
    >     > guarantee. In sd_detach a bit is cleared, in sd_attach
    >     > the first free bit is given out. There is no memory.
    >
    >     But the disks are probed in the same manner as last time
    >     (if the disks/controllers are not moved, crashed etc..).
    >     So we will end up getting same names.
    >
    > Oh, but if next_index is 0 in the module (or reset by the
    > init_module code), then also with index = next_index++
    > things will be the same after rmmod/insmod.

    Here is my problem..

    #insmod ips.o
      < found 10 disks>
    #insmod qla2300.o
      < found 10 disks>
    #rmmod ips.o
       <removed 10 disks>
    #insmod ips.o
      <found 10 disks - but new names>

OK, I see what you mean. I agree.

Andries


[I see that dougg wants to solve such things by properly naming,
but that is a higher level. Given a large number space an
easier solution is to give each module its own part of the
number space.]


