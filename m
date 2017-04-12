From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: linux-next: manual merge of the scsi-mkp tree with the char-misc
 tree
Date: Wed, 12 Apr 2017 17:44:34 +0000
Message-ID: <1492019073.2764.7.camel@sandisk.com>
References: <20170407153351.0ecafd59@canb.auug.org.au>
         <47b500d6-0700-812f-dda3-44a14014b66e@sandisk.com>
         <yq1k26qv3r5.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <yq1k26qv3r5.fsf@oracle.com>
Content-Language: en-US
Content-ID: <3609D2254566B6469993A59481755BB5@namprd04.prod.outlook.com>
Sender: linux-next-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "logang@deltatee.com" <logang@deltatee.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "greg@kroah.com" <greg@kroah.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-11 at 21:00 -0400, Martin K. Petersen wrote:
> Bart Van Assche <bart.vanassche@sandisk.com> writes:
> > Sorry that I had not yet noticed Logan's patch series. Should my two
> > patches that conflict with Logan's patch series be dropped and
> > reworked after Logan's patches are upstream?
>=20
> Obviously things break the minute you go on vacation. I'm back
> now. What's the current status?

Hello Martin,

Logan's patch series has been queued by Greg KH for kernel 4.12. So Linus
will have to resolve the merge conflict between Greg's char-misc tree and
the SCSI tree during the 4.12 merge window. See also
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/log/?h=
=3Dchar-misc-next&ofs=3D250

Bart.=
