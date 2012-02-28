From: Tullio Dovera <tdovera@gmail.com>
Subject: Re: sending ioctl warnings for a partition
Date: Tue, 28 Feb 2012 21:48:57 +0100
Message-ID: <CANDSw5i45BAJY5jPc3hkYFihd9qWMWxnvbTKU97MGE3YxBWx5Q@mail.gmail.com>
References: <20120227114846.7b824b05@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45031 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2B1Us5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2012 15:48:57 -0500
Received: by iagj37 with SMTP id j37so1657040iag.19
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2012 12:48:57 -0800 (PST)
In-Reply-To: <20120227114846.7b824b05@athlon.garagome>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?TWlsYW4gS27DrcW+ZWs=?= <knizek.confy@gmail.com>
Cc: linux-scsi@vger.kernel.org

Dear Milan,
   I have reopened the issue because I can't find it in zfs-fuse projec=
t.

The issue is #143

Best regards,
   Tullio

On Mon, Feb 27, 2012 at 11:48 AM, Milan Kn=C3=AD=C5=BEek <knizek.confy@=
gmail.com> wrote:
>
> Hello Tullio,
>
> can you pls point me where in zfs-fuse project is the issue reported?
>
> I have not found anything in zfs-fuse @ googlegroups and
> http://zfs-fuse.net/issues
>
> Thank you and regards,
> Milan
>
> --
>
> To: Paolo Bonzini <pbonzini@xxxxxxxxxx>
> Subject: Re: sending ioctl warnings for a partition
> From: Tullio Dovera <tdovera@xxxxxxxxx>
> Date: Tue, 7 Feb 2012 17:34:58 +0100
> Cc: linux-scsi <linux-scsi@xxxxxxxxxxxxxxx>, zfs-fuse@xxxxxxx
> In-reply-to: <4F2E8EB3.3010307@redhat.com>
> Thank you very much. I have opened an issue in zfs-fuse project.
>
> Tullio
>
> On Sun, Feb 5, 2012 at 3:14 PM, Paolo Bonzini <pbonzini@xxxxxxxxxx>
> wrote:
> > On 02/05/2012 12:30 AM, Paolo Bonzini wrote:
> >>
> >> That's correct. =C2=A0zfs-fuse is trying to send a SYNCHRONIZE CAC=
HE
> >> command, they should just use BLKFLSBUF (which will also give a
> >> warning due to a quirk in block/ioctl.c, but it's a false positive
> >> and the warning will go away soonish).
> >
> >
> > Not even that. =C2=A0All that is needed is fsync.
> >
> > Paolo
>
> --
> http://www.milan-knizek.net/
> About linux and photography (Czech only)
> O linuxu a fotografov=C3=A1n=C3=AD
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
