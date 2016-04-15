From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] hisi_sas: add slot_index_alloc_quirk_v2_hw()
Date: Fri, 15 Apr 2016 15:51:57 +0200
Message-ID: <5710F1FD.3070002@suse.de>
References: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
 <1460727398-102091-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460727398-102091-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

On 04/15/2016 03:36 PM, John Garry wrote:
> Add v2 hw custom function slot_index_alloc_quirk_v2_hw().
> SAS devices should have IPTT bit0 equal to 1.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 28 ++++++++++++++++++++++++=
++++
>  1 file changed, 28 insertions(+)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
