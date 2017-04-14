From: David Buckley <dbuckley@oreilly.com>
Subject: Re: problem with discard granularity in sd
Date: Fri, 14 Apr 2017 13:07:37 -0700
Message-ID: <CA+Xd3XEQ0353MTLj4GXj5SZ-xiR4KTB6T7uU_na89=HR+NdhHQ@mail.gmail.com>
References: <CA+Xd3XG1AN-ZTjn3SfZffrY=4vezSS8RrE88jG0QEsuyHC5k8A@mail.gmail.com>
 <yq14lxuv187.fsf@oracle.com> <CA+Xd3XFoRY+SgowfzP69X1ZCSAPGTmec=qMxStoX=trths8kDg@mail.gmail.com>
 <yq1efwvwvvb.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36035 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdDNUIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2017 16:08:19 -0400
Received: by mail-lf0-f54.google.com with SMTP id s141so45643509lfe.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Apr 2017 13:08:19 -0700 (PDT)
In-Reply-To: <yq1efwvwvvb.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Hi Martin,

I had assumed that the VPD values for the LUNs were valid, and hadn't
even thought to check if they were standards-compliant.  Based on the
SBC descriptions, it is clear that you are correct and this is an
issue with the storage not reporting a proper max_ws_blocks.  At least
now I have enough details to demonstrate to NetApp that this is an
issue on their side, and also have the relevant details from SBC.

Thank you once again for your help in understanding the underlying
technical issues responsible for the WS UNMAP failures in my
environment.  I really appreciate you taking the time to respond,
especially as this didn't turn out to be an issue with kernel code at
all.

-David
