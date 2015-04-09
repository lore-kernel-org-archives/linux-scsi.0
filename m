From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi_transport_fc: Add support for 25Gbit speed
Date: Thu, 09 Apr 2015 08:13:03 -0400
Message-ID: <1428581583.4807.153.camel@localhost.localdomain>
References: <1428004252.6933.1.camel@myfc17>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbbDIMNG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2015 08:13:06 -0400
In-Reply-To: <1428004252.6933.1.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2015-04-02 at 15:50 -0400, James Smart wrote:
> Add FC transport support for 25Gbit speed
> 
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/scsi_transport_fc.c | 1 +
>  include/scsi/scsi_transport_fc.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 5d6f348..24eaaf6 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -265,6 +265,7 @@ static const struct {
>  	{ FC_PORTSPEED_40GBIT,		"40 Gbit" },
>  	{ FC_PORTSPEED_50GBIT,		"50 Gbit" },
>  	{ FC_PORTSPEED_100GBIT,		"100 Gbit" },
> +	{ FC_PORTSPEED_25GBIT,		"25 Gbit" },
>  	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
>  };
>  fc_bitfield_name_search(port_speed, fc_port_speed_names)
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 007a0bc..784bc2c 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -135,6 +135,7 @@ enum fc_vport_state {
>  #define FC_PORTSPEED_40GBIT		0x100
>  #define FC_PORTSPEED_50GBIT		0x200
>  #define FC_PORTSPEED_100GBIT		0x400
> +#define FC_PORTSPEED_25GBIT		0x800
>  #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
>  
>  /*

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


