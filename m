From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH v2 3/5] aic7xxx: remove rules for shipped files
Date: Thu, 10 Aug 2017 00:27:09 +0200
Message-ID: <20170809222558.zptrocpcktix2pvu@qmqm.qmqm.pl>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
 <759ba18717a785f8875b74efe01ba26920d55006.1501802727.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 78-11-180-123.static.ip.netia.com.pl ([78.11.180.123]:54402
        "EHLO rere.qmqm.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752474AbdHIWgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2017 18:36:17 -0400
Content-Disposition: inline
In-Reply-To: <759ba18717a785f8875b74efe01ba26920d55006.1501802727.git.mirq-linux@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, Aug 04, 2017 at 01:28:09AM +0200, Micha³ Miros³aw wrote:
[...]
> --- a/drivers/scsi/aic7xxx/Makefile
> +++ b/drivers/scsi/aic7xxx/Makefile
> @@ -61,8 +61,6 @@ $(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
[...]
> -else
> -$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
[...]

Hi,

Please drop this patch (only this one). I didn't notice, that the file is
needed by modpost:

      Building modules, stage 2.
      MODPOST 785 modules
    WARNING: could not open drivers/scsi/aic7xxx/aic79xx_reg_print.c: No
such file or directory
      LD [M]  drivers/scsi/aic7xxx/aic79xx.ko

Best Regards,
Micha³ Miros³aw
