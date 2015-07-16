From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] dm-mpath: always return reservation conflict
Date: Thu, 16 Jul 2015 16:40:34 +0200
Message-ID: <55A7C262.6060204@suse.de>
References: <1436959404-14035-1-git-send-email-hare@suse.de> <1436960108.31121.41.camel@HansenPartnership.com> <CABr-GncMR4y+Sv=cXnhbXyX+ko2d13hgsPg2xbWSp9Z-v8=nqQ@mail.gmail.com> <20150716075450.GA23334@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbGPOkg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2015 10:40:36 -0400
In-Reply-To: <20150716075450.GA23334@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On 07/16/2015 09:54 AM, Christoph Hellwig wrote:
> On Thu, Jul 16, 2015 at 05:07:03AM +0000, Christophe Varoqui wrote:
>> For reference the opensvc crm does use type 5 pr, and aims for all p=
aths
>> registered. It still does not make use of the multipathd pr janitori=
ng
>> features, and uses sg_persist directly for pr status and actions.
>=20
> The type doesn't matter here.  It's important to set the ALL_TG_PT bi=
t
> when registering the key.  As dm-mpath opens the underlying devices
> exclusively, and doesn't give you a choice which path to send to you'=
re
> in a world of pain without that.
>=20
Second that.

I would even put this in the manpage somewhere.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
