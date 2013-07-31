From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] scsi/isci/port_config: Fix a infinite loop.
Date: Wed, 31 Jul 2013 09:35:50 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A534640@IRSMSX105.ger.corp.intel.com>
References: <1374029641-12649-1-git-send-email-yuxinghai@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064Ab3GaJgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jul 2013 05:36:33 -0400
In-Reply-To: <1374029641-12649-1-git-send-email-yuxinghai@cn.fujitsu.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xinghai Yu <yuxinghai@cn.fujitsu.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wednesday, July 17, 2013 4:54 AM Xinghai Yu <yuxinghai@cn.fujitsu.com> wrote:
> 
> It seems the "phy_index++;" have been placed in wrong place, without it
> the while circle up will do a infinite loop.
> 
> Signed-off-by: Xinghai Yu <yuxinghai@cn.fujitsu.com>

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

> ---
>  drivers/scsi/isci/port_config.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
> index cd962da..85c77f6 100644
> --- a/drivers/scsi/isci/port_config.c
> +++ b/drivers/scsi/isci/port_config.c
> @@ -311,9 +311,9 @@ sci_mpc_agent_validate_phy_configuration(struct
> isci_host *ihost,
>  					      &ihost->phys[phy_index]);
> 
>  			assigned_phy_mask |= (1 << phy_index);
> +			phy_index++;
>  		}
> 
> -		phy_index++;
>  	}
> 
>  	return sci_port_configuration_agent_validate_ports(ihost, port_agent);
> --
> 1.7.1

