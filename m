From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Mon,  6 Jun 2005 19:04:09 -0500
Message-ID: <1118102649.42a4e479b5d0f@webmail.cs.wisc.edu>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina> <1117964506.15294.130.camel@zezette>
	<20050606133135.GZ27119@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050606133135.GZ27119@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quoting Lars Marowsky-Bree <lmb@suse.de>:

> On 2005-06-05T11:41:46, christophe varoqui <christophe.varoqui@free.fr>
> wrote:
>=20
> > While the focus is in this area, I'd like to mention multipath tools
> > userland checkers will need to insert SG request on queue head (Ed
> > Gaggin will explain this at OLS). I guess the API is lacking there, a=
nd
> > would like to know if this feature is on your TODOs ...
>=20
> It's on the TODO list. It's just not done yet. Essentially we need to b=
e
> able to set BW_RW_FAILFAST from user-space for SGIO.
>=20

Isn't this a seperate issue? It looks like the RHAT bugzilla asks to be a=
ble to
insert directly at the head of the queue so you do you not have to wait f=
or
possibly a hundred IO to complete before the test IO. Setting failfast ju=
st
means in case of en error it will be returned faster (no wasting time
retying).


> This is Novell bugzilla #81694 and RHAT bugzilla #154436.
>=20
