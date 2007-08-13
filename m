From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Unexpected busfree in Message-in phase
Date: Mon, 13 Aug 2007 17:44:51 +0200
Message-ID: <6bffcb0e0708130844k888bcc9ye06c766d0e1bdcab@mail.gmail.com>
References: <9a8748490708110810u2c7d6275hbd73cdede58a023d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.231]:35437 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942895AbXHMPox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 11:44:53 -0400
Received: by nz-out-0506.google.com with SMTP id s18so486235nze
        for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2007 08:44:52 -0700 (PDT)
In-Reply-To: <9a8748490708110810u2c7d6275hbd73cdede58a023d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi Jesper,

On 11/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> Hi,
>
> I just noticed this in dmesg :
>
> [ 3216.262987] (scsi0:A:4:0): Unexpected busfree in Message-in phase
> [ 3216.263058] SEQADDR == 0x16c
> [ 3216.263724]  target0:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 16)
>
> That's all there is in addition to the normal bootup messages, just
> those 3 lines.
> The machine is doing fine at the moment, no ill effects so far, but an
> explanation of what exactely could be causing that and whether or not
> it is a (fixable) problem would be very nice :-)
>
>
> Some details :
>
> $ scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux dragon 2.6.22-g1db6178c #1 SMP PREEMPT Sat Jul 14 04:10:50 CEST

Is this a regression? I do not have this commit

git-show 1db6178c
fatal: ambiguous argument '1db6178c': unknown revision or path not in
the working tree.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
