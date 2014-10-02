From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] NCR5380: Whitespace cleanup
Date: Thu, 02 Oct 2014 13:12:13 +0200
Message-ID: <542D330D.2060500@suse.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de> <1412246593-107001-2-git-send-email-hare@suse.de> <alpine.LNX.2.00.1410022104070.22727@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaJBLMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 07:12:15 -0400
In-Reply-To: <alpine.LNX.2.00.1410022104070.22727@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org

On 10/02/2014 01:07 PM, Finn Thain wrote:
>=20
> On Thu, 2 Oct 2014, Hannes Reinecke wrote:
>=20
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/NCR5380.c | 652 +++++++++++++++++++++++++-------------=
-----------
>>  1 file changed, 333 insertions(+), 319 deletions(-)
>>
>=20
> This is going to break about 30 or 40 patches that I'm working on. Ca=
n we=20
> not do this yet? The white space clean up is a smaller patch if it ha=
ppens=20
> after all the other bug fixing and modernization work.
>=20
Oh, you're most welcome.
I've just included it as my eyes nearly fell out when turning on
syntax highlighting.
The patch is an RFC anyway, so I doubt it'll be included in 3.18.

And indeed the NCR5380 is in dire need of modernization; having
three to four identical copies with just minor modifications
between each simply cries out for consolidation.

Thanks for doing that.

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
