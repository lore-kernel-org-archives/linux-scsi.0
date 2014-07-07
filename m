From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Mon, 07 Jul 2014 16:10:00 +0200
Message-ID: <53BAAA38.1000008@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-2-git-send-email-hare@suse.de> <20140704134437.GA12345@infradead.org> <53B6B646.5080301@suse.de> <20140705094147.GA18130@infradead.org> <53BA524B.7060400@suse.de> <20140707093746.GA12985@infradead.org> <53BA70D0.70801@suse.de> <20140707101121.GA15750@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbaGGOKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 10:10:03 -0400
In-Reply-To: <20140707101121.GA15750@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/07/2014 12:11 PM, Christoph Hellwig wrote:
> On Mon, Jul 07, 2014 at 12:05:04PM +0200, Hannes Reinecke wrote:
>> Ok, so I'll be sending a patchset for fixing up the build warnings
>> (and keeping the current accesses to ->lun), and prepare a different
>> patchset moving everything onto accessors so that we can use struct =
scsi_lun
>> directly.
>> Agreed?
>
> That would be my preference, yes.
>
> Btw, re the build warnings:  what's the reason you prefer casts to u8
> over just using the %lld printk specifier?  Avoiding casts generally
> seems to be the cleaner variant to me.
>
Yeah, I've been a bit inconsistent here.
In general I've been using 'u8' casts for the older SCSI parallel
drivers, on the grounds they'll never be seeing any LUN numbers=20
higher than that and I don't have to modify the printk output here.

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
