From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/8] scsi: libsas: delete dead code in
 scsi_transport_sas.c
Date: Thu, 31 May 2018 15:26:37 +0100
Message-ID: <764348f0-a581-2bba-a2ba-da71af0c91cf@huawei.com>
References: <20180529022309.21071-1-yanaijie@huawei.com>
 <20180529022309.21071-2-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529022309.21071-2-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 29/05/2018 03:23, Jason Yan wrote:
> This code is dead and no clue implies that it will be back again.

I think PHY port identifier was dropped in 65c92b09acf0218b64f, and code 
below is just remnants.

>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Hannes Reinecke <hare@suse.com>

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>  drivers/scsi/scsi_transport_sas.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 08acbabfae07..92d966e500d4 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -623,7 +623,6 @@ sas_phy_protocol_attr(identify.target_port_protocols,
>  sas_phy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
>  		unsigned long long);
>  sas_phy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
> -//sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", int);
>  sas_phy_linkspeed_attr(negotiated_linkrate);
>  sas_phy_linkspeed_attr(minimum_linkrate_hw);
>  sas_phy_linkspeed_rw_attr(minimum_linkrate);
> @@ -1813,7 +1812,6 @@ sas_attach_transport(struct sas_function_template *ft)
>  	SETUP_PHY_ATTRIBUTE(device_type);
>  	SETUP_PHY_ATTRIBUTE(sas_address);
>  	SETUP_PHY_ATTRIBUTE(phy_identifier);
> -	//SETUP_PHY_ATTRIBUTE(port_identifier);
>  	SETUP_PHY_ATTRIBUTE(negotiated_linkrate);
>  	SETUP_PHY_ATTRIBUTE(minimum_linkrate_hw);
>  	SETUP_PHY_ATTRIBUTE_RW(minimum_linkrate);
>
