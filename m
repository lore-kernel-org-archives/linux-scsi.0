From: Raymond Scholz <rscholz@zonix.de>
Subject: Re: SCSI tape (Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14)
Date: Mon, 27 Nov 2006 18:50:30 +0100
Message-ID: <Impo.87d578vkwp@hush.zonix.de>
References: <Impo.871wnune7w@hush.zonix.de>
	<F7D518BF-C626-4964-B184-1AC4C6D2C3B2@cococafe.com>
	<456B2052.1060300@buf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uptime.tohserver.com ([81.169.181.71]:50383 "EHLO
	mail.tohserver.com") by vger.kernel.org with ESMTP id S1758490AbWK0Ruc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:50:32 -0500
In-Reply-To: <456B2052.1060300@buf.com> (Alexander Jolk's message of "Mon\, 27
	Nov 2006 18\:28\:50 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Jolk <alexj@buf.com>
Cc: Denny Page <denny@cococafe.com>, linux-scsi@vger.kernel.org

=B7 Alexander Jolk <alexj@buf.com> wrote:

> I have successfully used your procedure in order to get an HP LTO-3=20
> driver to work that's attached to an LSI/Fusion/MPT controller.  That
> would seem to point to the drive or the scsi driver rather than the
> controller.

My initial (private) mail didn't contain any specific hardware
versions.  So if it helps to track down the reason for the negotiation
problem, here they are:

LTO tape:

Host: scsi2 Channel: 00 Id: 06 Lun: 00
  Vendor: CERTANCE Model: ULTRIUM 2        Rev: 1823
  Type:   Sequential-Access                ANSI SCSI revision: 03

Controller:

Adaptec AIC79xx driver version: 1.3.11
Adaptec AIC7902 Ultra320 SCSI adapter
aic7902: Ultra320 Wide Channel B, SCSI Id=3D7, PCI 33 or 66Mhz, 512 SCB=
s

Raymond
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
