From: gaoqiang <gaoqiangscut@gmail.com>
Subject: Re: question about  path_id of scsi hard disk
Date: Mon, 23 Jul 2012 11:12:24 +0800
Message-ID: <op.whvpuyesn27o5l@gaoqiang-d1.corp.qihoo.net>
References: <op.whqka8y2n27o5l@gaoqiang-d1.corp.qihoo.net>
 <1342823514.2984.48.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34319 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2GWDMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2012 23:12:50 -0400
Received: by pbbrp8 with SMTP id rp8so10109839pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2012 20:12:50 -0700 (PDT)
In-Reply-To: <1342823514.2984.48.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

=D4=DA Sat, 21 Jul 2012 06:31:54 +0800=A3=ACJames Bottomley =20
<James.Bottomley@hansenpartnership.com> =D0=B4=B5=C0:

> On Fri, 2012-07-20 at 16:24 +0800, gaoqiang wrote:
>> I'm using udev to manage my hard disks. but I'm confusing
>> about the "PATH_ID"
>>
>> gaoqiang@h150:~$/lib/udev/path_id  /block/sda
>> ID_PATH=3Dpci-0000:01:00.0-scsi-0:0:0:0
>>
>> the path_id is about disk or about disk slot ?
>
> Neither: it's pci function and scsi host:channel:target:lun
>
> As far as I can tell, path_id returns are completely useless for
> labelling disks (since host and sometimes target are scan order
> dependent).
>
> James
>
>

I know the host:channel:target:lun but not deeply. the "lun" is about a=
 =20
disk, or a disk slot?
I mean,if I take the disk on a slot and plug in a new disk,will the =20
ID_PATH change,or not ?

many thanks.

--=20
=CA=B9=D3=C3 Opera =B8=EF=C3=FC=D0=D4=B5=C4=B5=E7=D7=D3=D3=CA=BC=FE=BF=CD=
=BB=A7=B3=CC=D0=F2: http://www.opera.com/mail/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
