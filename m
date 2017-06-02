From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI controller with CDB-16
Date: Fri, 02 Jun 2017 16:50:57 -0400
Message-ID: <yq1fufijeq6.fsf@oracle.com>
References: <CAGqcPWD2RuR5Odc+8Hf+tDgA9-DTpDiKJ4GwjF6g0qTJrjMJ8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29885 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBUvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 16:51:03 -0400
In-Reply-To: <CAGqcPWD2RuR5Odc+8Hf+tDgA9-DTpDiKJ4GwjF6g0qTJrjMJ8A@mail.gmail.com>
        (Alexander Voropay's message of "Wed, 31 May 2017 12:22:10 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Voropay <alexander.voropay@gmail.com>
Cc: linux-scsi@vger.kernel.org


Alexander,

> - Ultra320 bus does not work physically, too many errors.
> - Ultra160 bus works relable, no errors.

Ultra320 was generally problematic. I worked on two different hardware
platforms that both gave up on the original plan of using 320 and went
back to an Ultra160 ASIC between prototype and GA. Mainly due to
signaling problems. Even internal controller to disk backplane cabling
was a problem.

So make sure your cabling and termination is in good working order and
rated for 320.

> Unfortunately Adaptec does not work with CDB-16 too :(

I don't have any SPI hardware anymore. But my suggestion would be to
look for an LSI 53C1030-based card. It's a different ASIC than the 1010
you tried (has more in common with the first gen SAS controllers). It's
the final generation of SPI products and would stand the best chance of
working.

-- 
Martin K. Petersen	Oracle Linux Engineering
