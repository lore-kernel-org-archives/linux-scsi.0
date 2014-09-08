From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/7] Use 'Scsi_Host' as argument for host reset
Date: Mon, 08 Sep 2014 08:49:46 +0200
Message-ID: <540D518A.60206@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <20140907162113.GA4061@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaIHGtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 02:49:49 -0400
In-Reply-To: <20140907162113.GA4061@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 09/07/2014 06:21 PM, Christoph Hellwig wrote:
> Did you plan to get back to this series and revisit it per the commen=
ts?
> I'd love to at least get the first preparatory patches in ASAP.
>
Up to now I've been focussed on the printk series, and I've shelved thi=
s=20
one as the initial feedback was to have a full series converting
all _eh function.

But sure, I definitely want to see this in.
Unfortunately I'll be on vacation this week, so won't have time to
do anything here.

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
