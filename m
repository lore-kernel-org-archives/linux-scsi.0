From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix kconfig dependency warnings for SCSI_FC_ATTRS
Date: Mon, 22 Sep 2014 07:42:13 -0700
Message-ID: <20140922144213.GA28200@infradead.org>
References: <541CC163.3080709@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <541CC163.3080709@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Anish Bhatt <anish@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 19, 2014 at 04:50:59PM -0700, Randy Dunlap wrote:
> --- linux-next-20140918.orig/drivers/scsi/qla2xxx/Kconfig
> +++ linux-next-20140918/drivers/scsi/qla2xxx/Kconfig
> @@ -30,7 +30,7 @@ config SCSI_QLA_FC
>  
>  config TCM_QLA2XXX
>  	tristate "TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs"
> -	depends on SCSI_QLA_FC && TARGET_CORE
> +	depends on SCSI_QLA_FC && TARGET_CORE && SCSI_FC_ATTRS

CONFIG_SCSI_QLA_FC currently selects SCSI_FC_ATTRS, so we shouldn't
need this here. Also any reason not to switch that one over to a
depends as well?
