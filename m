From: David Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] [SCSI] aacraid: mark aac_src_select_comm() static
Date: Wed, 7 Sep 2016 18:03:59 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15FAB7E4@avsrvexchmbx1.microsemi.net>
References: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "xie.baoyou@zte.com.cn" <xie.baoyou@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

>=20
> We get 1 warning when building kernel with W=3D1:
> drivers/scsi/aacraid/src.c:616:5: warning: no previous prototype for
> 'aac_src_select_comm' [-Wmissing-prototypes]
>=20
> In fact, this function is only used in the file in which it is declared a=
nd don't need
> a declaration, but can be made static.
> so this patch marks this function with 'static'.
>=20
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> ---
>  drivers/scsi/aacraid/src.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Dave Carroll <david.carroll@microsemi.com>
