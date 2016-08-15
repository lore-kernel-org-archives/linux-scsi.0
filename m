From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/3] sas: provide stub implementations for
 scsi_is_sas_phy and sas_get_address
Date: Mon, 15 Aug 2016 10:09:55 -0700
Message-ID: <1471280995.2428.10.camel@linux.vnet.ibm.com>
References: <cover.1471273623.git.jthumshirn@suse.de>
	 <f19d5eeb5cc16ce43d3932924105e77210f1daac.1471273623.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f19d5eeb5cc16ce43d3932924105e77210f1daac.1471273623.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-08-15 at 17:12 +0200, Johannes Thumshirn wrote:
> +static inline u64 sas_get_address(struct scsi_device *sdev)
> +{
> +	return 0;
> +}

To be honest, we don't want this.  We do want the code to fail to
compile if you ever use sas_get_address where you shouldn't because the
code will be incorrect at that point.  If we could return an error,
fine, but we just return the address.

James
