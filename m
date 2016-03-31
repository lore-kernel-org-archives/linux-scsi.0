From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/2] Revert "scsi: fix soft lockup in
 scsi_remove_target() on module removal"
Date: Thu, 31 Mar 2016 18:18:01 +0200
Message-ID: <56FD4DB9.7050501@suse.de>
References: <cover.1459428540.git.jthumshirn@suse.de>
 <6fd7396e87d983aa307be2228d364dbe4f34f892.1459428540.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6fd7396e87d983aa307be2228d364dbe4f34f892.1459428540.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/31/2016 02:53 PM, Johannes Thumshirn wrote:
> This reverts commit 90a88d6ef88edcfc4f644dddc7eef4ea41bccf8b.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
