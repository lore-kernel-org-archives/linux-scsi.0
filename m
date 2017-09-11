From: Eugene Syromyatnikov <evgsyr@gmail.com>
Subject: Re: [man-pages PATCH] cciss.4, hpsa.4: mention cciss removal in Linux 4.13
Date: Mon, 11 Sep 2017 14:36:44 +0200
Message-ID: <CACGkJdvGYZGSF0pSdh416BHWoaxY2KRkfx1th-ZZUX9u+MPzFg@mail.gmail.com>
References: <20170911025746.GA23341@asgard.redhat.com> <alpine.LRH.2.21.1709110958100.23935@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36200 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdIKMhF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2017 08:37:05 -0400
In-Reply-To: <alpine.LRH.2.21.1709110958100.23935@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-man <linux-man@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org

On Mon, Sep 11, 2017 at 8:58 AM, Meelis Roos <mroos@linux.ee> wrote:
> On Mon, 11 Sep 2017, Eugene Syromyatnikov wrote:
>
>> During the Linux 4.13 development cycle, cciss driver has been removed
>> in flavor to hpsa driver that has been amended with some legacy board
>> support.
>
> It's gone in 4.14 - 4.13 works the old way.

Uhh, my bad, sorry: forgot to add --contain to git describe. I'll
resend the patch.

-- 
Eugene Syromyatnikov
mailto:evgsyr@gmail.com
xmpp:esyr@jabber.{ru|org}
