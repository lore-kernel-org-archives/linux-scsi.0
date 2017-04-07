From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: linux-next: manual merge of the scsi-mkp tree with the char-misc
 tree
Date: Fri, 7 Apr 2017 19:50:58 +0000
Message-ID: <1491594657.2559.24.camel@sandisk.com>
References: <20170407153351.0ecafd59@canb.auug.org.au>
         <47b500d6-0700-812f-dda3-44a14014b66e@sandisk.com>
         <ba19c6cf-a762-f7f7-6e27-ef64e3e578c1@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <ba19c6cf-a762-f7f7-6e27-ef64e3e578c1@deltatee.com>
Content-Language: en-US
Content-ID: <830232C872956D4280080F23832D69D7@namprd04.prod.outlook.com>
Sender: linux-next-owner@vger.kernel.org
To: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "logang@deltatee.com" <logang@deltatee.com>, "greg@kroah.com" <greg@kroah.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "arnd@arndb.de" <arnd@arndb.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ooo@electrozaur.com" <ooo@electrozaur.com>, "openosd@gmail.com" <openosd@gmail.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-04-07 at 13:29 -0600, Logan Gunthorpe wrote:
> On 07/04/17 09:49 AM, Bart Van Assche wrote:
> > Sorry that I had not yet noticed Logan's patch series. Should my two
> > patches that conflict with Logan's patch series be dropped and reworked
> > after Logan's patches are upstream?
>=20
> Yeah, Greg took my patchset around a few maintainers relatively quickly.
> This is the second conflict, so sorry about that. Looks like the easiest
> thing would be to just base your change off of mine. It doesn't look too
> difficult. If you can do it before my patch hits upstream, I'd
> appreciate some testing and/or review as no one from the scsi side
> responded and that particular patch was a bit more involved than I would
> have liked.

Boaz, had you noticed Logan's osd patch? If not, can you have a look?

Thanks,

Bart.=
