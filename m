From: Eldad Zack <eldad@fogrefinery.com>
Subject: Re: [set5 PATCH 2/6] async: make async_synchronize_full() flush all
 work regardless of domain
Date: Fri, 22 Jun 2012 23:40:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1206222333050.1141@debianer>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com> <20120622064707.21538.22198.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120622064707.21538.22198.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, Len Brown <len.brown@intel.com>, Meelis Roos <mroos@linux.ee>, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org


On Thu, 21 Jun 2012, Dan Williams wrote:
> In response to an async related regression James noted:
> 
>   "My theory is that this is an init problem: The assumption in a lot of
>    our code is that async_synchronize_full() waits for everything ... even
>    the domain specific async schedules, which isn't true."
> 
> ...so make this assumption true.

Hi Dan,

I've applied the all 6 patches of this set. 
(HEAD 8874e812feb4926f4a51a82c4fca75c7daa05fc5 , Linus' tree)

I've tested it on the same setup and everything runs fine, and I've 
seen no suspicious messages.

If you'd like, I can test only patch #2 in isolation.

Tested-by: Eldad Zack <eldad@fogrefinery.com>

Best regards,
Eldad
