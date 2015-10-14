From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] SCSI: Introduce device_lock and target_lock in Scsi_Host
Date: Wed, 14 Oct 2015 16:17:05 +0200
Message-ID: <561E63E1.2060600@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de> <f2ff8b554116663d7acf35fa84c23886bf486ffb.1444829611.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f2ff8b554116663d7acf35fa84c23886bf486ffb.1444829611.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/14/2015 03:50 PM, Johannes Thumshirn wrote:
> Introduce target_lock and device_lock to untangle the __devices and _=
_targets
> lists from the host_lock.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
Actually, you need to convert scsi_lookup_by_target, too.

That, too, relies on the host_lock.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
