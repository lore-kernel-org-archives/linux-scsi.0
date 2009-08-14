From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH 04/12] ixgbe: Add support for NETIF_F_FCOE_MTU
 to 82599 devices
Date: Fri, 14 Aug 2009 16:12:54 -0700 (PDT)
Message-ID: <20090814.161254.249495127.davem@davemloft.net>
References: <20090814223857.1640.26881.stgit@localhost.localdomain>
	<20090814224217.1640.49274.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090814224217.1640.49274.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, gospo@redhat.com, yi.zou@intel.com
List-Id: linux-scsi@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 14 Aug 2009 15:42:17 -0700

> From: Yi Zou <yi.zou@intel.com>
> 
> Enable netdev feature flag bit NETIF_F_FCOE_MTU for 82599 devices and enable
> jumbo frame correspondingly when NETIF_F_FCOE_MTU is set.
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
