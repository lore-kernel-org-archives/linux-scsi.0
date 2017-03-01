From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 11:00:35 -0800
Message-ID: <CA+55aFyAGqqe=Pah9Jkwq0=uwRwWxEc1npOzenXdrM9dFYPb1A@mail.gmail.com>
References: <20170227152955.1362aabb@xeon-e3> <20170227171931.30b9f619@xeon-e3>
 <20170228140812.GC20197@lst.de> <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
 <1488301573.3046.9.camel@linux.vnet.ibm.com> <20170228105741.6253bb8a@xeon-e3>
 <1488325732.11610.9.camel@linux.vnet.ibm.com> <20170228172532.280811ed@xeon-e3>
 <1488349258.20321.11.camel@linux.vnet.ibm.com> <20170301104800.00322bd4@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33117 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdCAVvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 16:51:50 -0500
Received: by mail-io0-f169.google.com with SMTP id f84so39828764ioj.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 13:50:07 -0800 (PST)
In-Reply-To: <20170301104800.00322bd4@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, Linux SCSI List <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>

On Wed, Mar 1, 2017 at 10:48 AM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> Bad 4.11 initial INQUIRY buffer
> [    1.218159] data: 00000000: 00 00 05 02 1f 00 00 02 4d 73 66 74 20 20 20 20
> [    1.225654] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20
> [    1.242930] data: 00000020: 31 2e 30 20

 "........Msft    Virtual Disk    1.0 ."

in case anybody wondered about what the ascii data was, like I did.

              Linus
