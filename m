From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 76/77] ncr5380: Fix wait for 53C80 registers registers
 after PDMA
Date: Tue, 22 Dec 2015 09:08:43 +0100
Message-ID: <5679050B.8090602@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011758.695930028@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbbLVIIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 03:08:45 -0500
In-Reply-To: <20151222011758.695930028@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>

On 12/22/2015 02:18 AM, Finn Thain wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
>
> The check for 53C80 registers accessibility was commented out because
> it was broken (inverted). Fix and enable it.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/g_NCR5380.c |   37 ++++++-----------------------------=
--
>   1 file changed, 6 insertions(+), 31 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
