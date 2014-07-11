From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: arm: fas216: Use %llu to print 'u64' format
Date: Fri, 11 Jul 2014 08:30:17 +0200
Message-ID: <53BF8479.9090109@suse.de>
References: <1405035187-27737-1-git-send-email-festevam@gmail.com> <20140711062302.GA12385@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaGKGaU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 02:30:20 -0400
In-Reply-To: <20140711062302.GA12385@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Fabio Estevam <festevam@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>

On 07/11/2014 08:23 AM, Christoph Hellwig wrote:
> Thanks Fabio,
>
> this looks good to me.  Are there any other warnings you got from tha=
t
> autobuilder?
>
It _should_ have been fixed with my latest patch for fixing the=20
64bit LUN fallout. Christoph, have you applied it?

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
