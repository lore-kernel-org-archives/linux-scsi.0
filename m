From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: problem with discard granularity in sd
Date: Tue, 11 Apr 2017 21:55:20 -0400
Message-ID: <yq14lxuv187.fsf@oracle.com>
References: <CA+Xd3XG1AN-ZTjn3SfZffrY=4vezSS8RrE88jG0QEsuyHC5k8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17446 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbdDLBz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 21:55:27 -0400
In-Reply-To: <CA+Xd3XG1AN-ZTjn3SfZffrY=4vezSS8RrE88jG0QEsuyHC5k8A@mail.gmail.com>
        (David Buckley's message of "Tue, 11 Apr 2017 11:07:43 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Buckley <dbuckley@oreilly.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


David,

> I am wondering if part of the issue is that in my use case, UNMAP and
> WRITE SAME zeros result in very different results.  With thin
> provisioned LUNs, UNMAP requests result in the blocks being freed and
> thus reduces the actual size of the LUN allocation on disk.  If WRITE
> SAME requests are used to zero the blocks, they remain allocated and
> thus the real size of the LUN grows to match the allocated size
> (effectively thick-provisioning the LUN).

The filer explicitly reported support for WRITE SAME(10/16) with UNMAP.
It seems very odd that it would then completely ignore the UNMAP bit and
do a regular WRITE SAME.

Are you running latest firmware, btw.?

In any case. The changes I mentioned are now queued up for 4.12. But
it'll obviously take a while for those to trickle into the
distributions...

-- 
Martin K. Petersen	Oracle Linux Engineering
