From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/71] ncr5380: Proceed with next command after NCR5380_select()
 calls scsi_done
Date: Thu, 19 Nov 2015 15:16:58 +0100
Message-ID: <564DD9DA.7000702@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083459.541713432@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083459.541713432@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> If a target disappears from the SCSI bus, NCR5380_select() may
> subsequently fail with a time-out. In this situation, scsi_done is
> called and NCR5380_select() returns 0. Both hostdata->connected and
> hostdata->selecting are NULL and the main loop should proceed with
> the next command in the issue queue. Clarify this logic.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
