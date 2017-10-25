From: idaifish <idaifish@gmail.com>
Subject: Re: [drivers/scsi/sg.c] general protection fault in sg_read
Date: Wed, 25 Oct 2017 18:04:04 +0800
Message-ID: <CADUsjN=5p9RyaY0d9ufsaMJe_iBzid0JV88eavKcEK1acRDz6w@mail.gmail.com>
References: <CADUsjNmAjxU8zLUvJD6VGdiz9RgfHA8y_0pO=GwOSgAUHM90VA@mail.gmail.com>
 <mqd1slry7u3.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:52723 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932399AbdJYKEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2017 06:04:45 -0400
Received: by mail-ua0-f181.google.com with SMTP id i35so17389738uah.9
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 03:04:45 -0700 (PDT)
In-Reply-To: <mqd1slry7u3.fsf@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: dgilbert@interlog.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

You are right.  I've tested on 4.14-rc6, and it cannot be reproducible.


On Wed, Oct 25, 2017 at 4:01 PM, Johannes Thumshirn <jthumshirn@suse.de> wr=
ote:
> idaifish <idaifish@gmail.com> writes:
>
>> Hi,
>>
>> I've got the following report while fuzzing the kernel with syzkaller.
>> (on 4.9.58)
>
> Can you test if this is already fixed on 4.14-rcX? There have been a
> number of syzkaller related fixes between 4.9 and now. Probably we just
> missed to back-port it to stable.
>
> Thanks,
>         Johannes
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850



--=20
Regards,
idaifish
