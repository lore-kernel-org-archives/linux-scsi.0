From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Mon, 12 Dec 2016 10:14:29 +0530
Message-ID: <CAFqt6zZLJyDJzwQZ6U3T9XG2JwQEOrEQEMYL0yLrbOnjH=yO_A@mail.gmail.com>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15> <20161206132808.GD4818@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:32937 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753833AbcLLEoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2016 23:44:30 -0500
Received: by mail-io0-f193.google.com with SMTP id p13so19309796ioi.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2016 20:44:30 -0800 (PST)
In-Reply-To: <20161206132808.GD4818@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

Hi Martin,

On Tue, Dec 6, 2016 at 6:58 PM, Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
> On Mon, Nov 28, 2016 at 04:56:26PM +0530, Souptick Joarder wrote:
>> Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
>> replaced by pci_pool_zalloc()
>>
>> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
>> ---
>
> FWIW,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Any further comment on this ?

Regards
Souptick
