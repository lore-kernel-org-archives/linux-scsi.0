From: David Miller <davem@davemloft.net>
Subject: Re: [net-next-2.6 PATCH 3/4] ixgbe: Add support for
 netdev_ops.ndo_fcoe_get_wwn to 82599
Date: Thu, 29 Oct 2009 01:04:49 -0700 (PDT)
Message-ID: <20091029.010449.85779225.davem@davemloft.net>
References: <20091029042339.15957.37676.stgit@localhost.localdomain>
	<20091029042455.15957.87665.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59213
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZJ2IEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 04:04:25 -0400
In-Reply-To: <20091029042455.15957.87665.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-scsi@vger.kernel.org, yi.zou@intel.com

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 28 Oct 2009 21:24:56 -0700

> From: Yi Zou <yi.zou@intel.com>
> 
> Implements the netdev_ops.ndo_fcoe_get_wwn in 82599 if it finds valid
> prefix for the World Wide Node Name (WWNN) or World Wide Port Name (WWPN),
> as well as valid SAN MAC address.
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
