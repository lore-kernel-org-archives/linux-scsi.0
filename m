From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 20/36] mac_scsi: Cleanup PDMA code
Date: Fri, 31 Oct 2014 09:34:34 +0100
Message-ID: <5453499A.4030001@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.955142205@telegraphics.com.au> <5451ECC1.9030103@suse.de> <5451FA96.4050901@suse.de> <alpine.LNX.2.00.1410311520400.7380@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbaJaIeg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2014 04:34:36 -0400
In-Reply-To: <alpine.LNX.2.00.1410311520400.7380@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/31/2014 08:18 AM, Finn Thain wrote:
>=20
> On Thu, 30 Oct 2014, Hannes Reinecke wrote:
>=20
>> On 10/30/2014 08:46 AM, Hannes Reinecke wrote:
>>> Any reason why you didn't re-indent [...]
>> Ahh, forget it.
>>
>> Addressed with the next patch.
>>
>=20
> So, does it get your reviewed-by tag? (Thanks for reviewing all this,=
=20
> BTW.)
>=20
Yes. You can add the reviewed-by tag to this.

> You also questioned mac_scsi.c whitespace in your review of, "[PATCH =
v2=20
> 14/36] ncr5380: Remove pointless compiler command line override macro=
s."=20
> By the end of this patch series, I thought that mac_scsi.c was in pre=
tty=20
> good shape (?)
>=20
I only later figured that you've fixed up mac_scsi.c eventually.
So that's all in good shape.

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
