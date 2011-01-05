From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 6/8] BNX2I: Added jumbo MTU support for the no shost case
Date: Wed, 05 Jan 2011 14:50:31 -0600
Message-ID: <4D24D997.30104@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1294260267-17413-7-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40906 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab1AEUxf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:53:35 -0500
In-Reply-To: <1294260267-17413-7-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 01/05/2011 02:44 PM, Eddie Wai wrote:
> For scenarios where the shost is not being passed to bnx2i for the
> iSCSI offload connection request, the code would consult the routing
> table to select the CNIC device.
> This code path will erroneously error out if the corresponding L2
> interface's MTU has been setup to>  1500.
>

When have you guys actually hit this? What tools and what version does this?
