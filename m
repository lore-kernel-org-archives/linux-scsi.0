From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] Remove T4 FCoE support
Date: Thu, 15 Jan 2015 15:25:04 +0100
Message-ID: <54B7CDC0.6040304@suse.de>
References: <cover.1421328605.git.praveenm@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1421328605.git.praveenm@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Praveen Madhavan <praveenm@chelsio.com>, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: davem@davemloft.net, JBottomley@parallels.com, hch@infradead.org, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On 01/15/2015 02:45 PM, Praveen Madhavan wrote:
> These patches removes FCoE support for chelsio T4 adapter.
> Please apply on net-next since depends on previous commits.
>=20
> Praveen Madhavan (2):
>   csiostor:Remove T4 FCoE support.
>   csiostor:Removed file csio_hw_t4.c
>=20
>  drivers/scsi/csiostor/Makefile       |   2 +-
>  drivers/scsi/csiostor/csio_hw.c      |  61 ++----
>  drivers/scsi/csiostor/csio_hw_chip.h |  43 ----
>  drivers/scsi/csiostor/csio_hw_t4.c   | 404 -------------------------=
----------
>  drivers/scsi/csiostor/csio_init.c    |   6 +-
>  drivers/scsi/csiostor/csio_wr.c      |  15 +-
>  6 files changed, 25 insertions(+), 506 deletions(-)
>  delete mode 100644 drivers/scsi/csiostor/csio_hw_t4.c
>=20
Any particular reason for this?
It worked at one point, didn't it?

So why do you want to remove it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
