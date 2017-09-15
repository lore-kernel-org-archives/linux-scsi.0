From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: error: testing array offset 'bus' after
 use
Date: Fri, 15 Sep 2017 20:13:22 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B8BCD39@avsrvexchmbx1.microsemi.net>
References: <abd8be3220061294f53ed45a7487f9ea95f7aaac.1505292255.git.npajkovsky@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <abd8be3220061294f53ed45a7487f9ea95f7aaac.1505292255.git.npajkovsky@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nikola Pajkovsky <npajkovsky@suse.cz>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> Fix possible indexing array of bound for &aac->hba_map[bus][cid], where b=
us
> and cid boundary check happens later.
>=20
> Fixes: 0d643ff3c353 ("scsi: aacraid: use aac_tmf_callback for reset fib")
> Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
> ---
>  drivers/scsi/aacraid/linit.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
