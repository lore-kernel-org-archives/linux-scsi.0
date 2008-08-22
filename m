From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/4 2.6.28] cxgb3i - Add iSCSI driver
Date: Fri, 22 Aug 2008 18:15:35 -0400
Message-ID: <48AF3A87.1070705@pobox.com>
References: <200808221837.m7MIbAvv004384@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48549 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYHVWPm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 18:15:42 -0400
In-Reply-To: <200808221837.m7MIbAvv004384@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: netdev@vger.kernel.org, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, michaelc@cs.wisc.edu, swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com, wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com

Karen Xie wrote:
> Hi, everyone,
> 
> Please review our new version of the iSCSI Initiator drivers for Chelsio S3 adapters. The cxgb3i driver provides iscsi acceleration (PDU digest offload and payload direct-placement) to the open-iscsi initiator. It accesses the hardware through the cxgb3 module.
> 
> The accelerated iscsi traffic uses a private IP address which is unknown to the OS.

I have not reviewed in depth, but this does appear to remove the major 
objection we had.

Thanks,

	Jeff



