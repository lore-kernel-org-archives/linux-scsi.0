From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] libata.h: add stub for ata_sas_port_resume
Date: Wed, 19 Mar 2014 13:58:52 -0400
Message-ID: <20140319175852.GD19874@htj.dyndns.org>
References: <5329D7F1.4030400@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:61479 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaCSR64 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2014 13:58:56 -0400
Content-Disposition: inline
In-Reply-To: <5329D7F1.4030400@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jim Davis <jim.epost@gmail.com>, Dan Williams <dan.j.williams@intel.com>

On Wed, Mar 19, 2014 at 10:46:25AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build error when CONFIG_PM is not enabled by adding a stub
> function in <linux/libata.h>.
> 
> drivers/scsi/libsas/sas_ata.c: In function 'sas_resume_sata':
> drivers/scsi/libsas/sas_ata.c:756:3: error: implicit declaration of function 'ata_sas_port_resume' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> ---
>  include/linux/libata.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-next-20140319.orig/include/linux/libata.h
> +++ linux-next-20140319/include/linux/libata.h
> @@ -1148,6 +1148,9 @@ static inline void ata_sas_port_suspend(
>  static inline void ata_sas_port_async_resume(struct ata_port *ap)
>  {
>  }
> +static inline void ata_sas_port_resume(struct ata_port *ap)
> +{
> +}
>  #endif
>  extern int ata_ratelimit(void);
>  extern void ata_msleep(struct ata_port *ap, unsigned int msecs);

Applied to libata/for-3.15.

Thanks.

-- 
tejun
