From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH -net] scsi: fix users of SCSI_FC_ATTRS to depend on NET
Date: Tue, 16 Sep 2014 12:41:09 -0400 (EDT)
Message-ID: <20140916.124109.353198384505832634.davem@davemloft.net>
References: <5417DA29.4060205@infradead.org>
	<54184FB7.7020201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <54184FB7.7020201@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: maier@linux.vnet.ibm.com
Cc: rdunlap@infradead.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, jbottomley@parallels.com, fengguang.wu@intel.com
List-Id: linux-scsi@vger.kernel.org

From: Steffen Maier <maier@linux.vnet.ibm.com>
Date: Tue, 16 Sep 2014 16:56:55 +0200

> I think zfcp does not have any (direct) dependency on NET.
> 
> It looks like SCSI_FC_ATTRS selects SCSI_NETLINK (declaring
> scsi_nl_sock) and only depends on SCSI but not on NET.
> SCSI_NETLINK itself only selects NET but does not model its direct
> depencency on NET?

SCSI_NETLINK now has:

	depends on NET
