From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] libata: Implement ATA_DEV_ZAC
Date: Sat, 14 Jun 2014 08:37:47 +0200
Message-ID: <539BEDBB.6020206@suse.de>
References: <1401692478-23557-1-git-send-email-hare@suse.de> <1401692478-23557-3-git-send-email-hare@suse.de> <20140602091745.GB32301@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaFNGhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jun 2014 02:37:50 -0400
In-Reply-To: <20140602091745.GB32301@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/02/2014 11:17 AM, Christoph Hellwig wrote:
> This also need to be run past the libata maintainers and the linux-id=
e
> list..
>
>> +	if ((lbam =3D=3D 0xcd) && (lbah =3D=3D 0xab)) {
>
> The inner braces here aren't needed.
>
True, but that's the coding style within that function.
There are several conditions with every of them following the same styl=
e.

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
