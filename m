From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Thu, 29 Aug 2013 15:06:48 +0200
Message-ID: <521F4768.5010807@suse.de>
References: <1372661455-122384-1-git-send-email-hare@suse.de> <1373488528.7420.55.camel@localhost.localdomain> <5201ECAD.7000703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3H2NGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 09:06:49 -0400
In-Reply-To: <5201ECAD.7000703@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, emilne@redhat.com, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

Hi James,

On 08/07/2013 08:43 AM, Ren Mingxin wrote:
> Hi, James:
>=20
> On 07/11/2013 04:35 AM, Ewan Milne wrote:
>> Looks good.  We have been testing this extensively.
>>
>> Acked-by: Ewan D. Milne<emilne@redhat.com>
>=20
> Do you think this patchset can be applied? If so, When? Perhaps you
> are waiting for someone's feedback?
>=20
> We've also tested and got the duration could be shortened from 6m26s
> to 44s when 'eh_deadline' was set as 1s(the minimum value of timeout)
> and 16M data were written(I/O processing time can be ignored - 0.7s).
>=20
> As Ewan said, this is efficient to fast failover policy for redundant
> environments.
>=20
> Thanks,
> Ren

Any objections to this patchset?
I have other patchsets pending (eg asynchronous command aborts)
which are based on this one.
So it would be good to have a status here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
