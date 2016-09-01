From: Nilesh Javali <nilesh.javali@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla4xxx: mark symbols static where possible
Date: Thu, 1 Sep 2016 10:59:01 +0000
Message-ID: <D3EE07A2.24D3C%nilesh.javali@qlogic.com>
References: <1472467611-8574-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472467611-8574-1-git-send-email-baoyou.xie@linaro.org>
Content-Language: en-US
Content-ID: <81088465690B284E9111337D6F461980@namprd11.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@qlogic.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "arnd@linaro.org" <arnd@linaro.org>, "xie.baoyou@zte.com.cn" <xie.baoyou@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org



On 29/08/16 4:16 PM, "Baoyou Xie" <baoyou.xie@linaro.org> wrote:

>We get 1 warning when build kernel with W=3D1:
>drivers/scsi/qla4xxx/ql4_nx.c:1846:10: warning: no previous prototype for
>'ql4_84xx_ipmdio_rd_reg' [-Wmissing-prototypes]
>
>In fact, this function is only used in the file in which it is
>declared and don't need a declaration, but can be made static.
>so this patch marks this function with 'static'.
>
>Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
>---
> drivers/scsi/qla4xxx/ql4_nx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
>index ae87d6c..06ddd13 100644
>--- a/drivers/scsi/qla4xxx/ql4_nx.c
>+++ b/drivers/scsi/qla4xxx/ql4_nx.c
>@@ -1843,7 +1843,7 @@ static uint32_t ql4_84xx_poll_wait_for_ready(struct
>scsi_qla_host *ha,
> 	return rval;
> }
>=20
>-uint32_t ql4_84xx_ipmdio_rd_reg(struct scsi_qla_host *ha, uint32_t addr1,
>+static uint32_t ql4_84xx_ipmdio_rd_reg(struct scsi_qla_host *ha,
>uint32_t addr1,
> 				uint32_t addr3, uint32_t mask, uint32_t addr,
> 				uint32_t *data_ptr)
> {
>--=20
>2.7.4


Acked-by: Nilesh Javali <nilesh.javali@qlogic.com>
