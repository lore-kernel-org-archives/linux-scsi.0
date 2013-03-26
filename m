From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] scsi_transport_iscsi: Declare portal type string
 macros for generic use
Date: Mon, 25 Mar 2013 20:37:55 -0500
Message-ID: <5150FBF3.5050503@cs.wisc.edu>
References: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37159 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab3CZBiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 21:38:11 -0400
In-Reply-To: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, manish.rangankar@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Patches 1 - 3 look ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

On 03/25/2013 07:08 AM, vikas.chaudhary@qlogic.com wrote:
> From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> 
> Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  include/scsi/iscsi_if.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
> index f1b0183..fe7f06c 100644
> --- a/include/scsi/iscsi_if.h
> +++ b/include/scsi/iscsi_if.h
> @@ -504,6 +504,10 @@ enum iscsi_host_param {
>  	ISCSI_HOST_PARAM_MAX,
>  };
>  
> +/* portal type */
> +#define PORTAL_TYPE_IPV4	"ipv4"
> +#define PORTAL_TYPE_IPV6	"ipv6"
> +
>  /* iSCSI Flash Target params */
>  enum iscsi_flashnode_param {
>  	ISCSI_FLASHNODE_IS_FW_ASSIGNED_IPV6,
> 

