From: Drew <drew.kay@gmail.com>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 07:54:42 -0700
Message-ID: <c268e4660906290754m2e30d7ecs180fd2a45843646c@mail.gmail.com>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <20090629133431.GM5480@parisc-linux.org>
	<c268e4660906290640k3364aeaey30d37b884a2ce1c6@mail.gmail.com>
	<20090629134739.GO5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:33299 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961AbZF2OzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 10:55:00 -0400
Received: by yxe26 with SMTP id 26so1332502yxe.33
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 07:55:03 -0700 (PDT)
In-Reply-To: <20090629134739.GO5480@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, linux-scsi@vger.kernel.org

>> Would you not also have to partition the drive using GPT partitions?
>> LVM aside, I thought any partition over 2TB had to be GPT.
>
> If you choose to partition the device at all -- I often create filesy=
stems
> directly on the block device. =C2=A0Regardless, you need the SCSI com=
mand
> to be able to get to the device before you can start worrying about
> partitioning schemes.

That's a given. I threw out the GPT issue because once the OP gets the
hardware seeing the drive/lun they will, if they weren't already aware
of it, run smack into the 2TB partition limit. Just trying to think a
couple of steps ahead.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
