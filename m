From: Carl Henrik Lunde <chlunde@ping.uio.no>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and
	partitions
Date: Fri, 24 Apr 2009 16:37:17 +0200
Message-ID: <ed038eb20904240737u4d248b63s580f7d4d1831e173@mail.gmail.com>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
	 <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
	 <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
	 <49F1B68D.3010304@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65204 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZDXOhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 10:37:20 -0400
In-Reply-To: <49F1B68D.3010304@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kay Sievers <kay.sievers@vrfy.org>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

> On Fri, Apr 24, 2009 at 07:32, Martin K. Petersen <martin.petersen@or=
acle.com> wrote:
> +What: =A0 =A0 =A0 =A0 =A0/sys/block/<disk>/alignment
> +What: =A0 =A0 =A0 =A0 =A0/sys/block/<disk>/<partition>/alignment
> +What: =A0 =A0 =A0 =A0 =A0/sys/block/<disk>/queue/minimum_io_size
> +What: =A0 =A0 =A0 =A0 =A0/sys/block/<disk>/queue/optimal_io_size

Would it also be possible and useful to include the number of
spindles/channels, i.e., how many requests the device can handle
concurrently?  CFQ could for example serve two time slices
concurrently if you have sequential reads and the device reports two
spindles.

[sorry for replying in the middle of the thread, but I didn't get the
original email]
--=20
mvh
Carl Henrik
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
