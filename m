From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 05/12] pm80xx: MSI-X implementation for using 64 interrupts
Date: Tue, 26 Mar 2013 08:59:54 +0100
Message-ID: <5151557A.7000409@suse.de>
References: <5149F091.2060009@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759520Ab3CZIAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Mar 2013 04:00:00 -0400
In-Reply-To: <5149F091.2060009@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, sakthivel.sk@hcl.com, xjtuwjp@gmail.com, rich.Bono@pmcs.com, Vishwanath.Maram@pmcs.com

On 03/20/2013 06:23 PM, Anand wrote:
>  From b7704915fe98519155cb1c86d79afcc976b574b8 Mon Sep 17 00:00:00 20=
01
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Tue, 19 Mar 2013 17:56:17 +0530
> Subject: [PATCH V3 05/12] pm80xx: MSI-X implementation for using 64 i=
nterrupts
>
> Implementation of interrupt handlers and tasklets to support
> upto 64 interrupt for the device.
>
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>

Yep, that's what I had in mind.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
