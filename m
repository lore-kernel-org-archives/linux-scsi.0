From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and
	partitions
Date: Fri, 24 Apr 2009 14:14:44 +0200
Message-ID: <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
References: <patchbomb.1240551141@sermon.lab.mkp.net> <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47749 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZDXMPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 08:15:01 -0400
In-Reply-To: <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 24, 2009 at 07:32, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> +What: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/sys/block/<disk>/alignment
> +What: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/sys/block/<disk>/<partition=
>/alignment
> +What: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/sys/block/<disk>/queue/mini=
mum_io_size
> +What: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/sys/block/<disk>/queue/opti=
mal_io_size

Wouldn't it be good to include "sector", like the queue files do? The
alignment of a partition could mean many things.
  /sys/block/<disk>/sector_alignment
  /sys/block/<disk>/<partition>/sector_alignment

And prefixing the io values might be easier to read when they show up
in a group?
  /sys/block/<disk>/queue/io_minimum_size
  /sys/block/<disk>/queue/io_optimal_size
  /sys/block/<disk>/queue/io_...

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
