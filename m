From: David Miller <davem@davemloft.net>
Subject: Re: [net-next-2.6 PATCH 2/4] net: Add ndo_fcoe_get_wwn to
 net_device_ops
Date: Thu, 29 Oct 2009 01:04:44 -0700 (PDT)
Message-ID: <20091029.010444.187410674.davem@davemloft.net>
References: <20091029042339.15957.37676.stgit@localhost.localdomain>
	<20091029042434.15957.82934.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20091029042434.15957.82934.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-scsi@vger.kernel.org, yi.zou@intel.com
List-Id: linux-scsi@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 28 Oct 2009 21:24:35 -0700

> From: Yi Zou <yi.zou@intel.com>
> 
> Add ndo_fcoe_get_wwn so Fiber Channel over Ethernet (FCoE) can make use of
> the provided World Wide Port Name (WWPN) and World Wide Node Name (WWNN)
> from the underlying network interface driver.
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
