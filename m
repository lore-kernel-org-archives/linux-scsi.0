From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netdev: storage address support
Date: Tue, 28 Apr 2009 04:25:32 -0700 (PDT)
Message-ID: <20090428.042532.127201433.davem@davemloft.net>
References: <20090428083048.GB27798@psychotron.englab.brq.redhat.com>
	<20090428.021249.247190041.davem@davemloft.net>
	<20090428101816.GC27798@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51340
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755334AbZD1LZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2009 07:25:39 -0400
In-Reply-To: <20090428101816.GC27798@psychotron.englab.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jpirko@redhat.com
Cc: christopher.leech@intel.com, jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org, gospo@redhat.com, linux-scsi@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Tue, 28 Apr 2009 12:18:17 +0200

> Tue, Apr 28, 2009 at 11:12:49AM CEST, davem@davemloft.net wrote:
>>Agreed, can you update your patch to provide such a 'type' tag?
> 
> Ok, I'll do that. What types do you have on the top of your head?

Just start with SAN, LAN, and the ones you need for your work.
