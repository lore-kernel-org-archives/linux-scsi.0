From: David Miller <davem@davemloft.net>
Subject: Re: HELP: Is writeq an atomic operation??
Date: Fri, 02 May 2008 15:49:07 -0700 (PDT)
Message-ID: <20080502.154907.216403785.davem@davemloft.net>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
	<20080502.153210.122414532.davem@davemloft.net>
	<adaabj8499n.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36373
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934198AbYEBWtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 18:49:08 -0400
In-Reply-To: <adaabj8499n.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rdreier@cisco.com
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 02 May 2008 15:43:32 -0700

> Are there any 32-bit platforms with writeq()?  A quick grep suggests not.

Right, I guess there aren't, but what drivers do currently is roll
their own 64-bit MMIO for such cases.

I noticed this when writing drivers/net/niu.c

I suppose this is on purpose, so the driver can setup any
such protection and handling, as needed.
