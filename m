From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: Disable support for 256 byte/sector disks
Date: Wed, 13 May 2015 16:09:52 +0200
Message-ID: <55535B30.8080602@suse.de>
References: <1431506949-11398-1-git-send-email-hare@suse.de> <1431525655.2363.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbbEMOJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 10:09:55 -0400
In-Reply-To: <1431525655.2363.13.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 05/13/2015 04:00 PM, James Bottomley wrote:
> On Wed, 2015-05-13 at 10:49 +0200, Hannes Reinecke wrote:
>> 256 bytes per sector support has been broken since 2.6.X,
>> and no-one stepped up to fix this.
>> So disable support for it.
>=20
> I assume this should have a=20
>=20
> From: Mark Hounschell <dmarkh@cfl.rr.com>
>=20
> at the top?
>=20
> James
>=20
I wasn't sure, as I've pulled the patch off bugzilla.
But do whatever you see fit.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
