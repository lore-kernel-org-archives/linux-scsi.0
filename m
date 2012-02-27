From: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy@gmail.com>
Subject: Re: sending ioctl warnings for a partition
Date: Mon, 27 Feb 2012 11:48:46 +0100
Message-ID: <20120227114846.7b824b05@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37235 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2B0Kst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2012 05:48:49 -0500
Received: by bkcik5 with SMTP id ik5so80216bkc.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2012 02:48:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello Tullio,

can you pls point me where in zfs-fuse project is the issue reported?

I have not found anything in zfs-fuse @ googlegroups and
http://zfs-fuse.net/issues

Thank you and regards,
Milan

--=20

To: Paolo Bonzini <pbonzini@xxxxxxxxxx>
Subject: Re: sending ioctl warnings for a partition
=46rom: Tullio Dovera <tdovera@xxxxxxxxx>
Date: Tue, 7 Feb 2012 17:34:58 +0100
Cc: linux-scsi <linux-scsi@xxxxxxxxxxxxxxx>, zfs-fuse@xxxxxxx
In-reply-to: <4F2E8EB3.3010307@redhat.com>
Thank you very much. I have opened an issue in zfs-fuse project.

Tullio

On Sun, Feb 5, 2012 at 3:14 PM, Paolo Bonzini <pbonzini@xxxxxxxxxx>
wrote:
> On 02/05/2012 12:30 AM, Paolo Bonzini wrote:
>>
>> That's correct.  zfs-fuse is trying to send a SYNCHRONIZE CACHE
>> command, they should just use BLKFLSBUF (which will also give a
>> warning due to a quirk in block/ioctl.c, but it's a false positive
>> and the warning will go away soonish).
>
>
> Not even that.  All that is needed is fsync.
>
> Paolo

--=20
http://www.milan-knizek.net/
About linux and photography (Czech only)
O linuxu a fotografov=C3=A1n=C3=AD
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
