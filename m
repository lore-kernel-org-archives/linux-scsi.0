From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: sg: Prevent potential double frees in sg driver
Date: Thu, 3 Aug 2017 12:34:51 -0700
Message-ID: <CAKwvOdmkCtmceK8prnZJn6QQ9oReN2EUMSukWLS=NmgF_GagiQ@mail.gmail.com>
References: <20170803190248.51537-1-ndesaulniers@google.com> <20170803192354.GA1598@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35357 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdHCTew (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2017 15:34:52 -0400
Received: by mail-qk0-f176.google.com with SMTP id d145so13652642qkc.2
        for <linux-scsi@vger.kernel.org>; Thu, 03 Aug 2017 12:34:52 -0700 (PDT)
In-Reply-To: <20170803192354.GA1598@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hare@suse.de, jthumshirn@suse.de, hch@lst.de, Mark Salyzyn <salyzyn@google.com>, Robb Glasser <rglasser@google.com>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> Why no one on the to: line?

I usually cc everyone from get_maintainer.pl. Should I be using
--to= then explicitly for named folks, and --cc= for lists?

> And do you want this in the stable kernel trees?

Looks like I can follow up on option #2 once this patch has
been reviewed+merged by maintainers.  I'll note to use
option #1 next time, unless you suggest I send a v2? I can
do so if this patch has a v2+.
-- 
Thanks,
~Nick Desaulniers
