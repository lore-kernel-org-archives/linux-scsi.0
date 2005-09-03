From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.13-mm1 login fails
Date: Sat, 03 Sep 2005 10:37:36 -0700 (PDT)
Message-ID: <20050903.103736.56666999.davem@davemloft.net>
References: <F7DC2337C7631D4386A2DF6E8FB22B30047FA093@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:36526
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S1751151AbVICSUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 14:20:05 -0400
In-Reply-To: <F7DC2337C7631D4386A2DF6E8FB22B30047FA093@hdsmsx401.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: len.brown@intel.com
Cc: reuben-lkml@reub.net, pwil3058@bigpond.net.au, akpm@osdl.org, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

From: "Brown, Len" <len.brown@intel.com>
Date: Sat, 3 Sep 2005 12:58:15 -0400

> CONFIG_AUDIT=y indeed did the trick.
> 
> When will I be able to delete CONFIG_AUDIT from my kernel again?

It's a regression we accidently added to the netlink socket
family, we will fix it.  But please use the workaround of
enabling CONFIG_AUDIT until we fix it, thanks.
