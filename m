From: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 11:24:31 +0200
Message-ID: <4E44F14F.1020206@computerix.info>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com> <4E44DE8E.3070809@computerix.info> <4E44E13B.2050503@gmail.com> <4E44E8E5.4040707@computerix.info> <4E44EBF4.8050801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www74.your-server.de ([213.133.104.74]:49939 "EHLO
	www74.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1HLJYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2011 05:24:46 -0400
In-Reply-To: <4E44EBF4.8050801@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Mark Lord <mlord@pobox.com>

On 2011-08-12 11:01, Ric Wheeler wrote:
> Lukas has a more generic bulk tool that should do the job and has the
> advantage that it does not have to fill the file system first (it can
> lock regions and do its work).

Any pointers to that?

Thanks!

> Note that discard is not just for physical devices like SCSI or ATA, =
it
> is also useful for "software" stacks like various device mapper targe=
ts,
> virtual block devices, etc so we should be keeping the abstraction at=
 a
> high level for our tooling.

I agree, but wiper.sh has been the first such tool and is widespread
and well-known. I'm not aware of alternatives using the generic fstrim
command (which is still missing on some major distributions)
or FITRIM ioctl.

--=20
Prof. Dr. Klaus Kusche
Private address: Rainstra=DFe 9/1, 88316 Isny, Germany
+49 7562 6211377 Klaus.Kusche@computerix.info http://www.computerix.inf=
o
Office address: NTA Isny gGmbH, Seidenstra=DFe 12-35, 88316 Isny, Germa=
ny
+49 7562 9707 36 kusche@nta-isny.de http://www.nta-isny.de

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
