From: Andries.Brouwer@cwi.nl
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Fri, 11 Apr 2003 01:33:29 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304102333.h3ANXTi28340.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:57315 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264237AbTDJXVt (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 19:21:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com

    From: Badari Pulavarty <pbadari@us.ibm.com>

    > Then we don't know which disks have disappeared. Pity.
    > If the number space is infinite then
    >    index = next_index++;
    > gives a new number each time we need one.

    Yes !! I agree. I am not worried about running out them.
    I am more worried about names slipping. I atleast hope
    to see device names not changing by just doing
    rmmod/insmod.

But you see, the present sd_index_bits[] gives no such
guarantee. In sd_detach a bit is cleared, in sd_attach
the first free bit is given out. There is no memory.

Andries
