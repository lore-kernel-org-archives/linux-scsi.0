From: David Miller <davem@davemloft.net>
Subject: Re: [RESEND PATCH 1/1]cxgb3i: Fix a login over vlan issue
Date: Sun, 03 Jan 2010 21:44:35 -0800 (PST)
Message-ID: <20100103.214435.119221597.davem@davemloft.net>
References: <alpine.LFD.2.00.0912271235370.12420@rakeshpc.asicdesigner.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912271235370.12420@rakeshpc.asicdesigner.com>
Sender: netdev-owner@vger.kernel.org
To: rakesh@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, james.bottomley@hansenpartnership.com, kxie@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Rakesh Ranjan <rakesh@chelsio.com>
Date: Sun, 27 Dec 2009 12:41:58 +0530 (IST)

> From: Rakesh Ranjan <rakesh@chelsio.com>
> Date: Sun, 27 Dec 2009 12:33:08 +0530
> Fix a target login issue, when parent interface is vlan and we are using cxgb3i sepecific
> private ip address in '/etc/iscsi/ifaces/' iface file.
> 
> Acked-by: Karen Xie <kxie@chelsio.com>
> Signed-off-by: Rakesh Ranjan <rakesh@chelsio.com>

Applied.
