From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Wed, 08 Sep 2010 10:30:23 -0500
Message-ID: <1283959823.29920.172.camel@mulgrave.site>
References: <4C72D310.4040004@suse.cz> <4C7B924D.6030703@panasas.com>
	 <201009071712.54867.konrad@darnok.org> <4C86B1A4.8030308@oracle.com>
	 <4C86B320.8090709@oracle.com> <4C86B860.1070105@suse.cz>
	 <20100908080557.511d307b@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0IHPab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Sep 2010 11:30:31 -0400
In-Reply-To: <20100908080557.511d307b@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, fischer@linux-buechse.de, linux-scsi@vger.kernel.org

On Wed, 2010-09-08 at 08:05 +0200, Andi Kleen wrote:
> >=20
> > Hmm, the changelog says:
> > The warning I saw was actually for the PCMCIA aha152x driver.
> >=20
> > which I think are compiler warnings. But I see only one emitted by =
the
> > compiler and it is in a debug print.
>=20
>=20
> Don't remember the exact warning, but I was rather trigger happy
> on getting rid of all these ancient unmaintained drivers on 64bit=20
> back then.
>=20
> In hindsight it was the right thing to do -- their userbase
> seems to be near zero and there were little to no complains=20
> about it ever.

OK ... let's try it.  Ji=C5=99=C3=AD send a patch ... and if it breaks =
I'm handing
you the pieces ...

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
