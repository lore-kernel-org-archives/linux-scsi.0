From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH -net] scsi: fix users of SCSI_FC_ATTRS to depend on NET
Date: Tue, 16 Sep 2014 16:31:06 -0400 (EDT)
Message-ID: <20140916.163106.2212454105464887253.davem@davemloft.net>
References: <5417DA29.4060205@infradead.org>
	<20140916.161518.620276378147910368.davem@davemloft.net>
	<54189C8E.5030409@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <54189C8E.5030409@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: rdunlap@infradead.org
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, jbottomley@parallels.com, fengguang.wu@intel.com
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 16 Sep 2014 13:24:46 -0700

> typo:                     depends on SCSI_FC_ATTRS
> 
> No, I certainly have no objection and prefer depends over select anyway.

Ok, then please send me a patch which fixes things that way.

Thanks!
