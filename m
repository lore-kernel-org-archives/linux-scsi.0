From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 3/3] target: Use scsi helpers to build the sense data
 correctly
Date: Mon, 06 Jul 2015 08:08:26 +0200
Message-ID: <559A1B5A.1080106@suse.de>
References: <1436081471-667-1-git-send-email-sagig@mellanox.com> <1436081471-667-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436081471-667-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 07/05/2015 09:31 AM, Sagi Grimberg wrote:
> Instead of open coding the sense buffer construction, use
> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
> helpers which moved to scsi_common.
>=20
> This patch also fixes wrong setting of descriptor format sense data
> for t10-pi integrity errors.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/scsi/scsi_common.c             | 58 ++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/scsi_error.c              | 58 ------------------------=
----------
>  drivers/target/target_core_spc.c       | 31 +++---------------
>  drivers/target/target_core_transport.c | 24 ++++----------
>  include/scsi/scsi_common.h             |  3 ++
>  include/scsi/scsi_eh.h                 |  4 +--
>  include/target/target_core_base.h      |  9 +-----
>  7 files changed, 75 insertions(+), 112 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
