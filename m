From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 1/5] iscsi_transport: add support for set_net_config
Date: Tue, 12 Apr 2011 22:41:37 -0500
Message-ID: <4DA51B71.6010801@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-2-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50930 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab1DMDlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2011 23:41:52 -0400
In-Reply-To: <1301769261-29896-2-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: vikas.chaudhary@qlogic.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
> +/* 20 param per iface * 10 iface per port = 200 params */
> +#define ISCSI_MAX_IFACE_PER_HW		10
> +#define ISCSI_MAX_PARAM_PER_IFACE	20
> +#define ISCSI_MAX_NET_PARAMS (ISCSI_MAX_IFACE_PER_HW * \
> +			      ISCSI_MAX_PARAM_PER_IFACE)
> +

This group is not used. Remove.
