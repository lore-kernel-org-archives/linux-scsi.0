From: Anton Blanchard <anton@samba.org>
Subject: Re: [Emulex] Ready for next round...
Date: Thu, 24 Jun 2004 01:31:46 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623153146.GD22495@krispykreme>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:39120 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S262434AbUFWX57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 19:57:59 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

 
Hi,

> [From 6/1]Re: Adam Blanchard's comment on page alloc fail on ppc64, thought
> on using a mempool & Re: other queuecommand problems - too many allocations,
> allocs under spinlock, etc.

Anton :)

We tested this version and the error messages due to slave_alloc failing
are gone now. Good stuff.

Anton
