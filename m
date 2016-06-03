From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Fri, 3 Jun 2016 11:19:00 +0800
Message-ID: <CAGnHSE=4QgWjt=G7hOWS12vFVu_fMFAp+-396AiDLYXrVyfcww@mail.gmail.com>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
	<20160531134335.o3jpinkdl3wg7ww2@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33562 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbcFCDam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2016 23:30:42 -0400
Received: by mail-qt0-f194.google.com with SMTP id k6so1865813qta.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jun 2016 20:30:42 -0700 (PDT)
In-Reply-To: <20160531134335.o3jpinkdl3wg7ww2@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

Why not get qemu have it fixed instead?

On 31 May 2016 at 21:43, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Tue, May 31, 2016 at 09:42:29AM -0400, Ewan D. Milne wrote:
>> Linux fails to boot as a guest with a QEMU CD-ROM:
>>
>> [    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
>> [    4.443649] ata2.00: configured for MWDMA2
>> [    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM =
     0.8. PQ: 0 ANSI: 5
>> [    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action=
 0x6 frozen
>> [    4.464319] ata2.00: BMDMA stat 0x5
>> [    4.464339] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag =
0 dma 16640 in
>> [    4.464339]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:=
00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
>> [    4.464341] ata2.00: status: { DRDY DRQ }
>> [    4.465864] ata2: soft resetting link
>> [    4.625971] ata2.00: configured for MWDMA2
>> [    4.628290] ata2: EH complete
>> [    4.646670] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action=
 0x6 frozen
>> [    4.646671] ata2.00: BMDMA stat 0x5
>> [    4.646683] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag =
0 dma 16640 in
>> [    4.646683]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:=
00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
>> [    4.646685] ata2.00: status: { DRDY DRQ }
>> [    4.648193] ata2: soft resetting link
>>
>> ...
>>
>> Fix this by suppressing VPD inquiry for this device.
>>
>> Reported-by: Jan Stancek <jstancek@redhat.com>
>> Tested-by: Jan Stancek <jstancek@redhat.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
