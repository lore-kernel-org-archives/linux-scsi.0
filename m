From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Mon, 6 Jun 2005 15:31:35 +0200
Message-ID: <20050606133135.GZ27119@marowsky-bree.de>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina> <1117964506.15294.130.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1117964506.15294.130.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2005-06-05T11:41:46, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

> While the focus is in this area, I'd like to mention multipath tools
> userland checkers will need to insert SG request on queue head (Ed
> Gaggin will explain this at OLS). I guess the API is lacking there, and
> would like to know if this feature is on your TODOs ...

It's on the TODO list. It's just not done yet. Essentially we need to be
able to set BW_RW_FAILFAST from user-space for SGIO.

This is Novell bugzilla #81694 and RHAT bugzilla #154436.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
