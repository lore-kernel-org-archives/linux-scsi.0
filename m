From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [drivers/scsi/sg.c] general protection fault in sg_read
Date: Wed, 25 Oct 2017 10:01:24 +0200
Message-ID: <mqd1slry7u3.fsf@linux-x5ow.site>
References: <CADUsjNmAjxU8zLUvJD6VGdiz9RgfHA8y_0pO=GwOSgAUHM90VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751529AbdJYIB1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 04:01:27 -0400
In-Reply-To: <CADUsjNmAjxU8zLUvJD6VGdiz9RgfHA8y_0pO=GwOSgAUHM90VA@mail.gmail.com>
        (idaifish@gmail.com's message of "Wed, 25 Oct 2017 15:55:21 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: idaifish <idaifish@gmail.com>
Cc: dgilbert@interlog.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

idaifish <idaifish@gmail.com> writes:

> Hi,
>
> I've got the following report while fuzzing the kernel with syzkaller.
> (on 4.9.58)

Can you test if this is already fixed on 4.14-rcX? There have been a
number of syzkaller related fixes between 4.9 and now. Probably we just
missed to back-port it to stable.

Thanks,
        Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
