From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 08/16] BNX2I: Added mutex lock protection to conn_get_param
Date: Wed, 17 Nov 2010 21:27:45 -0600
Message-ID: <4CE49D31.7060104@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-9-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41551 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0KRDTz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 22:19:55 -0500
In-Reply-To: <1289430297-30221-9-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 11/10/2010 05:04 PM, Eddie Wai wrote:
> -		return iscsi_conn_get_param(cls_conn, param, buf);
> +		len = iscsi_conn_get_param(cls_conn, param, buf);
> +		if (len == -ENOSYS)
> +			len = 0;

Why are you returning 0 here?

