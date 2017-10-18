From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Patch: add to Documentation/scsi for scsi_dev_flags and command
 line passing
Date: Wed, 18 Oct 2017 10:25:45 -0700
Message-ID: <3d702bd5-b96e-3f5b-482b-b2c36278c219@infradead.org>
References: <1508346789.13599.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45806 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdJRRZs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2017 13:25:48 -0400
In-Reply-To: <1508346789.13599.2.camel@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/18/17 10:13, Laurence Oberman wrote:
> Tired of forgetting about this so documented it for others so they also
> don't spend unnecessary time figuring this out.
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> 
> diff --git a/Documentation/scsi/scsi-parameters.txt
> b/Documentation/scsi/scsi-parameters.txt
> index 8477655..c9e9ce8 100644
> --- a/Documentation/scsi/scsi-parameters.txt
> +++ b/Documentation/scsi/scsi-parameters.txt
> @@ -116,3 +116,9 @@ parameters may be changed at runtime by the command
>  
>  	wd33c93=	[HW,SCSI]
>  			See header of drivers/scsi/wd33c93.c.
> +
> +Additional notes on passing parameters on the command line.

                                                         line:

> +Its not intuitively obvious how to pass certain parameters on the boot

   It's

> line.
> +For parameters such as scsi_dev_flags, you need to pass to the
> scsi_mod as follows

           as follows:

> +scsi_mod.dev_flags=LIO-ORG:thin2:0x80000000
> +
> -- 
> 1.8.3.1


Also the patch has some weird line breaks.


-- 
~Randy
