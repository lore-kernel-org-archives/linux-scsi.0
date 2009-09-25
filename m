From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 0/2] cxgb3/cxgb3i: added support of private MAC
 address and provisioning packet handler for iSCSI
Date: Fri, 25 Sep 2009 15:24:30 -0700 (PDT)
Message-ID: <20090925.152430.119503066.davem@davemloft.net>
References: <200909252225.n8PMPaqI031748@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48387
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbZIYWYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2009 18:24:11 -0400
In-Reply-To: <200909252225.n8PMPaqI031748@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, swise@opengridcomputing.com, divy@chelsio.com, rakesh@chelsio.com, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org

From: kxie@chelsio.com
Date: Fri, 25 Sep 2009 15:25:36 -0700

> From: Karen Xie <kxie@chelsio.com>
> 
> The two patches added support of private MAC address, which is derived from
> the network (i.e., public) MAC address, and provisioning packet handler for
> iSCSI traffic only.

I think I'm going to ask you to resubmit the drivers/net patch
after the necessary drivers/scsi changes get merged by the scsi
folks.

Thank you.
