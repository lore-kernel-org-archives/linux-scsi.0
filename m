From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Tue,  7 Jun 2005 10:26:16 -0500
Message-ID: <1118157976.42a5bc98d6f75@webmail.cs.wisc.edu>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina> <20050606190205.GA6817@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050606190205.GA6817@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quoting Patrick Mansfield <patmans@us.ibm.com>:

> On Sun, Jun 05, 2005 at 12:15:27AM -0700, Mike Christie wrote:
> > On Sat, 2005-06-04 at 09:07, James Bottomley wrote:
>=20
> > > Here's the proof of concept for this one.  It converts scsi_wait_re=
q to
> > > do correct REQ_BLOCK_PC submission (and works nicely in my setup).
>=20
> That is nice ... I didn't realize Mike's change allowed that.
>=20
> > > There's some loss of functionality to this: retries are no longer
> > > controllable (except by setting REQ_FASTFAIL) and the wait_req API =
needs
> > > to be altered, but it looks very nice.
>=20
> Mike your patch did not replace the retries.
>=20
> Why can't the retries be passed down via a new blk req->retries?
>=20

Is that all that is needed for dm-multipath? I thought this would be a go=
od time
to add some code to allow the finer grained control of retries that could=
 also
be used by dm and md. For example do you only want to retry certain failu=
res X
numbeer of times?
