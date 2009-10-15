From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH] bfa: fix test in bfad_os_fc_host_init()
Date: Thu, 15 Oct 2009 11:28:21 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECF042BADEA@HQ-EXCH-7.corp.brocade.com>
References: <4AD766B5.5040509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:22490 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110AbZJOS3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 14:29:10 -0400
In-Reply-To: <4AD766B5.5040509@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> see vi drivers/scsi/bfa/include/defs/bfa_defs_port.h +45
> was this intended?
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 158c992..55d012a 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -948,7 +948,7 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
>  	if (bfad_supported_fc4s & (BFA_PORT_ROLE_FCP_IM |
> BFA_PORT_ROLE_FCP_TM))
>  		/* For FCP type 0x08 */
>  		fc_host_supported_fc4s(host)[2] = 1;
> -	if (bfad_supported_fc4s | BFA_PORT_ROLE_FCP_IPFC)
> +	if (bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
>  		/* For LLC/SNAP type 0x05 */
>  		fc_host_supported_fc4s(host)[3] = 0x20;
>  	/* For fibre channel services type 0x20 */

This is a bug. Thanks!

Jing
