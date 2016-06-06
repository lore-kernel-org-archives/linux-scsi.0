From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/45] block: add REQ_OP definitions and helpers
Date: Mon, 6 Jun 2016 08:13:39 +0200
Message-ID: <57551493.5050300@suse.de>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-3-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465155145-10812-3-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 06/05/2016 09:31 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>=20
> The following patches separate the operation (WRITE, READ, DISCARD,
> etc) from the rq_flag_bits flags. This patch adds definitions for
> request/bio operations (REQ_OPs) and adds request/bio accessors to
> get/set the op.
>=20
> In this patch the REQ_OPs match the REQ rq_flag_bits ones
> for compat reasons while all the code is converted to use the
> op accessors in the set. In the last patches the op will become a
> number and the accessors and helpers in this patch will be dropped
> or updated.
>=20
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
