From: Andries.Brouwer@cwi.nl
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Fri, 11 Apr 2003 01:53:33 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304102353.h3ANrXv10792.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:12776 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264258AbTDJXlw (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 19:41:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com

    From: Badari Pulavarty <pbadari@us.ibm.com>

    >     I am more worried about names slipping. I atleast hope
    >     to see device names not changing by just doing
    >     rmmod/insmod.
    >
    > But you see, the present sd_index_bits[] gives no such
    > guarantee. In sd_detach a bit is cleared, in sd_attach
    > the first free bit is given out. There is no memory.

    But the disks are probed in the same manner as last time
    (if the disks/controllers are not moved, crashed etc..).
    So we will end up getting same names.

Oh, but if next_index is 0 in the module (or reset by the
init_module code), then also with index = next_index++
things will be the same after rmmod/insmod.

Andries


