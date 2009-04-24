From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and  partitions
Date: Fri, 24 Apr 2009 11:16:32 -0400
Message-ID: <yq1skjy84kv.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
	<72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
	<ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
	<49F1B68D.3010304@garzik.org>
	<ed038eb20904240737u4d248b63s580f7d4d1831e173@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:55502 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZDXPSW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 11:18:22 -0400
In-Reply-To: <ed038eb20904240737u4d248b63s580f7d4d1831e173@mail.gmail.com>
	(Carl Henrik Lunde's message of "Fri, 24 Apr 2009 16:37:17 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Garzik <jeff@garzik.org>, Kay Sievers <kay.sievers@vrfy.org>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

>>>>> "Carl" == Carl Henrik Lunde <chlunde@ping.uio.no> writes:

Carl> Would it also be possible and useful to include the number of
Carl> spindles/channels, i.e., how many requests the device can handle
Carl> concurrently?  CFQ could for example serve two time slices
Carl> concurrently if you have sequential reads and the device reports
Carl> two spindles.

We don't really have a way to get that information at this point.

The values exported in my patch set is what the storage vendors in T10
could agree on.  I simply applied them to DM and MD devices as well.

We're talking to SSD vendors about having their devices export some
characteristics that would allow us to schedule I/O more intelligently.
The effort of defining what those values might be is work in progress.
There has been murmurs about T13 adopting the T10 knobs, much like it
happened with form factor and media rotation rate.

For more traditional storage we don't really have a good way to
distinguish between a 10GB LUN on a million dollar array and a single
disk drive.  Rotation rate can help and we already use and export that.

-- 
Martin K. Petersen	Oracle Linux Engineering
