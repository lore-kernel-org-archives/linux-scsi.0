From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/5] scsi: libsas: delete dead code in
 scsi_transport_sas.c
Date: Mon, 17 Sep 2018 15:53:33 +0200
Message-ID: <4218aff0-92d5-dee2-2d60-8f24b71c4ad9@suse.com>
References: <20180912082946.34814-1-yanaijie@huawei.com>
 <20180912082946.34814-2-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912082946.34814-2-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 09/12/2018 10:29 AM, Jason Yan wrote:
> This code is dead and no clue implies that it will be back again.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_transport_sas.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 0cd16e80b019..0a165b2b3e81 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -612,7 +612,6 @@ sas_phy_protocol_attr(identify.target_port_protocols,
>  sas_phy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
>  		unsigned long long);
>  sas_phy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
> -//sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", int);
>  sas_phy_linkspeed_attr(negotiated_linkrate);
>  sas_phy_linkspeed_attr(minimum_linkrate_hw);
>  sas_phy_linkspeed_rw_attr(minimum_linkrate);
> @@ -1802,7 +1801,6 @@ sas_attach_transport(struct sas_function_template *ft)
>  	SETUP_PHY_ATTRIBUTE(device_type);
>  	SETUP_PHY_ATTRIBUTE(sas_address);
>  	SETUP_PHY_ATTRIBUTE(phy_identifier);
> -	//SETUP_PHY_ATTRIBUTE(port_identifier);
>  	SETUP_PHY_ATTRIBUTE(negotiated_linkrate);
>  	SETUP_PHY_ATTRIBUTE(minimum_linkrate_hw);
>  	SETUP_PHY_ATTRIBUTE_RW(minimum_linkrate);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
