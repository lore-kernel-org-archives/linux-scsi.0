From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [patch] qla4xxx: remove some bogus casts
Date: Wed, 25 Jan 2017 16:35:45 +0000
Message-ID: <1485362132.2646.1.camel@sandisk.com>
References: <20150817143647.GA23820@mwanda> <55D2B879.7040906@sandisk.com>
         <20150818084726.GG5610@mwanda> <55D924B8.3090407@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0080.outbound.protection.outlook.com ([104.47.32.80]:39040
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbdAYQgA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 11:36:00 -0500
In-Reply-To: <55D924B8.3090407@sandisk.com>
Content-Language: en-US
Content-ID: <E1BADF5EB41D0A4BB5891498D3C27046@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, 2015-08-22 at 18:41 -0700, Bart Van Assche wrote:
> On 08/18/15 01:47, Dan Carpenter wrote:
> > On Mon, Aug 17, 2015 at 09:45:45PM -0700, Bart Van Assche wrote:
> > > On 08/17/2015 07:36 AM, Dan Carpenter wrote:
> > > > These casts are wrong and unnecessary.  They annoy static checkers
> > > > because they imply we are planning to write sizeof(long) bytes to a
> > > > sizeof(u32) buffer which would corrupt memory.
> > >=20
> > > Hello Dan,
> > >=20
> > > Can you verify whether that patch is still needed after having
> > > applied the patch series I posted in July (and that was acknowledged
> > > by QLogic): http://thread.gmane.org/gmane.linux.scsi/103135 ?
> > >=20
> >=20
> > I think it is needed still?
>=20
> Hello Dan,
>=20
> You are right, this patch is indeed needed. Hence:
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Hello Martin,

Do you need more reviews to queue this patch?

Thanks,

Bart.=
