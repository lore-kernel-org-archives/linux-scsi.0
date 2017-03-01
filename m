From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 08:13:58 -0800
Message-ID: <20170301081358.3440c134@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35801 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdCAQrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 11:47:23 -0500
Received: by mail-pf0-f181.google.com with SMTP id j5so12650111pfb.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 08:46:53 -0800 (PST)
In-Reply-To: <20170301155057.GA13167@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

Dexuan has reproduced the same problem and discovered that is related to whether virtual DVD is
attached to the VM.  My VM had empty virtual DVD (offline) from the installation of the ISO.
If the DVD device is removed then the VM boots.

This makes the problem less of a catastrophic but we still need to get to root cause.
