From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/5] iscsi_transport: add support for set_net_config
Date: Sat, 23 Apr 2011 00:19:38 -0500
Message-ID: <4DB2616A.6040206@cs.wisc.edu>
References: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com> <1303495666-731-2-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49460 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1DWFTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2011 01:19:50 -0400
In-Reply-To: <1303495666-731-2-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

On 04/22/2011 01:07 PM, vikas.chaudhary@qlogic.com wrote:
> +/* 20 param per iface * 10 iface per port = 200 params */
> +#define ISCSI_MAX_IFACE_PER_HW		10
> +#define ISCSI_MAX_PARAM_PER_IFACE	20
> +#define ISCSI_MAX_NET_PARAMS (ISCSI_MAX_IFACE_PER_HW * \
> +			      ISCSI_MAX_PARAM_PER_IFACE)
> +

See comment from here:
http://marc.info/?l=linux-scsi&m=130266611526117&w=2
