From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi: remove redundant NULL check before kfree
Date: Tue, 23 Jun 2015 07:59:46 +0200
Message-ID: <5588F5D2.6080602@suse.de>
References: <1435030950-35999-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435030950-35999-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>, JBottomley@odin.com, hch@lst.de, michaelc@cs.wisc.edu, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com
List-Id: linux-scsi@vger.kernel.org

On 06/23/2015 05:42 AM, Maninder Singh wrote:
> There is no need of NULL check before kfree,
> So removing the same.
>=20
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Reviewed-by: Rohit Thapliyal <r.thapliyal@samsung.com>
If you insist ...

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
