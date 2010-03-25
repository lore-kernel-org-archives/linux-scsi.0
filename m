From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] [BNX2I] instruct firmware to use driver/iscsid provided
 expected statsn
Date: Thu, 25 Mar 2010 14:25:51 -0500
Message-ID: <4BABB8BF.9050200@cs.wisc.edu>
References: <1269539680.28522.68948.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43908 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab0CYT0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 15:26:21 -0400
In-Reply-To: <1269539680.28522.68948.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, mchan@broadcom.com, waie@broadcom.com

On 03/25/2010 12:54 PM, Anil Veerabhadrappa wrote:
> 	[BNX2I] instruct firmware to use driver/iscsid provided expected statsn
> 		field while constructing login pdu header.
>
> 	* Initialize 'flags' to instruct chip to use driver/iscsid provided
> 	  ExpStatSN value while constructing iSCSI login PDU header
>
> Signed-off-by: Eddie Wai<waie@broadcom.com>
> Signed-off-by: Anil Veerabhadrappa<anilgv@broadcom.com>
>

All three patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
