From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 03/36] net,rcu: convert call_rcu(fc_rport_free_rcu) to
 kfree_rcu()
Date: Fri, 18 Mar 2011 12:35:35 -0700 (PDT)
Message-ID: <20110318.123535.104071385.davem@davemloft.net>
References: <4D82D071.5020703@cn.fujitsu.com>
	<4D82D3FF.2080303@cn.fujitsu.com>
	<4D82D493.3080504@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60134
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248Ab1CRTe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 15:34:58 -0400
In-Reply-To: <4D82D493.3080504@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: laijs@cn.fujitsu.com
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, axboe@kernel.dk, robert.w.love@intel.com, James.Bottomley@suse.de, nhorman@tuxdriver.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com, shemminger@vyatta.com, tj@kernel.org, jarkao2@gmail.com, linux-kernel@vger.kernel.org, devel@open-fcoe.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:42:11 +0800

> 
> 
> The rcu callback fc_rport_free_rcu() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(fc_rport_free_rcu).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
