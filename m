From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch] [SCSI] aic79xx: NULL dereference in debug code
Date: Fri, 20 Jul 2012 16:41:34 +0200
Message-ID: <50096E1E.60709@suse.de>
References: <20120720113057.GC22245@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120720113057.GC22245@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/20/2012 01:30 PM, Dan Carpenter wrote:
> "ahd" can be NULL here and it gets dereferenced inside the call to
> ahd_name().
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
