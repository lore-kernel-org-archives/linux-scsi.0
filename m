From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 2/3] target: Split transport_send_check_condition_and_sense()
Date: Mon, 06 Jul 2015 08:06:20 +0200
Message-ID: <559A1ADC.9030500@suse.de>
References: <1436081471-667-1-git-send-email-sagig@mellanox.com> <1436081471-667-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436081471-667-3-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 07/05/2015 09:31 AM, Sagi Grimberg wrote:
> From: Bart Van Assche <bart.vanassche@sandisk.com>
>=20
> Move the code for translating a sense_reason_t code into a SCSI statu=
s
> ASC and ASCQ codes from transport_send_check_condition_and_sense() in=
to
> the new function translate_sense_reason(). Convert the switch stateme=
nt
> that performs the translation into table-driven code.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/target/target_core_transport.c | 382 +++++++++++++----------=
----------
>  1 file changed, 147 insertions(+), 235 deletions(-)
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
