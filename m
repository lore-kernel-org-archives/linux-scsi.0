From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] Re-implement am53c974 driver
Date: Fri, 21 Nov 2014 11:33:35 +0100
Message-ID: <546F14FF.3080509@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <20141121102639.GA31016@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbaKUKdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:33:38 -0500
In-Reply-To: <20141121102639.GA31016@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, davem@davemloft.net, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On 11/21/2014 11:26 AM, Christoph Hellwig wrote:
> On Fri, Nov 21, 2014 at 10:27:47AM +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> having found some issues with the current tmscsim driver
>> I looked at the code and found is really awkward to clean
>> up.
>> Seeing that the am53c974 chip is actually based on the
>> 'ESP' chip design I've re-implemented it based on the
>> common esp_scsi routines. This new driver
>> (cunningly named 'am53c974') provides all features
>> found on the tmscsim driver, with the goal of obsoleting
>> the old tmscsim driver.
>> Tested with Tekram DC390 and qemu esp-scsi.
>=20
> This looks very nice!
>=20
> Three high level comments:
>=20
>  - please Cc Dave for changes to esp_scsi
That's what I thought, too, but 'get_maintainers.pl' doesn't
know about him. Maybe we should fix this up ...

>  - please Cc Guennadi as the tmscsim maintainer
>  - this probably should deprecated and/or remove the tmscsim driver
>=20
That was the general idea. I just thought to be conservative and
add a new driver. But yeah, the idea is to sent another patch
to remove tmscsim altogether.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
