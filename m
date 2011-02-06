From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [LSF/MM TOPIC] Sparseness in storage
Date: Sun, 6 Feb 2011 18:58:07 -0500
Message-ID: <AANLkTim9g37ATBLOGBk+OGwj+MkjwYHEN96ppLB9AMWS@mail.gmail.com>
References: <4D498F4B.3050207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53966 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1BFX6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2011 18:58:08 -0500
Received: by iwn9 with SMTP id 9so4060462iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 06 Feb 2011 15:58:08 -0800 (PST)
In-Reply-To: <4D498F4B.3050207@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 2, 2011 at 12:07 PM, Douglas Gilbert <dgilbert@interlog.com=
> wrote:
> There are a lot of zeros out there. Efficient use of sparseness
> involves techniques to detect large quantities of zeros in
> advance rather than just reading them all. And on the write side
> there are standard techniques to append zeros to a file without
> actually writing them.
>
> Seems a damn shame to read a terabyte of zeros and then write them
> to another device or file. Carrying the idea further: if we know
> random data has no meaning *** and we are asked to copy it,
> why not "write" zeros to the output file?
>
> Over the last few years various commands have been added to the
> SCSI and ATA command sets to better handle sparseness (and
> trim/unmap/write_same can be viewed in this light). File systems
> are improving their sparseness handling as well, with Linux
> playing "catch up" to NTFS in this regard (e.g. the new
> FALLOC_FL_PUNCH_HOLE flag in fallocate() ).
>
> So I am proposing a discussion of the:
> =A0- existing SCSI commands to support sparseness
> =A0- existing ATA commands to support sparseness
> =A0- suggestions for more sparseness support to be
> =A0 =A0added to the SCSI and ATA command sets
> =A0- user space tools that support sparseness
> =A0- file system support for sparseness
>
> Perhaps the latter point should involve the file system track as
> well.

Why not just acknowledge that arrays have some sort of allocation map
and ask for a T10/SCSI command to return it.

--=20
Regards,
Richard Sharpe
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
