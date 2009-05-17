From: David Miller <davem@davemloft.net>
Subject: Re: [net-next-2.6 PATCH 4/8] ixgbe: Add infrastructure code for
 FCoE large send offload to 82599
Date: Sun, 17 May 2009 13:58:13 -0700 (PDT)
Message-ID: <20090517.135813.218823230.davem@davemloft.net>
References: <20090513230924.11416.68752.stgit@localhost.localdomain>
	<20090513231043.11416.23442.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090513231043.11416.23442.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, yi.zou@intel.com
List-Id: linux-scsi@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 13 May 2009 16:10:44 -0700

> From: Yi Zou <yi.zou@intel.com>
> 
> This adds infrastructure code for FCoE Tx side offload feature to
> 82599, including Fiber Channel CRC calculation, auto insertion of
> the start of frame (SOF) and end of frame (EOF) of FCoE packets,
> and large send by FCoE Sequence Offload (FSO).
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
