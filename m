From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 STILL dies on USB device hotplug - please merge fix ASAP
Date: Fri, 22 Jul 2011 23:44:08 +0200
Message-ID: <20110722214408.GV8006@one.firstfloor.org>
References: <20110722170214.GR8006@one.firstfloor.org> <1311364348.7153.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1311364348.7153.3.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, stable@kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

> Like I said at the time, the patch is wrong because of the relocation of
> the queue teardown.  I posted a corrected version, but did anyone test?
> Anyway, I merged it on the grounds that it worked for me, but if you
> could confirm with linux-next, that would be great (I'll send the pull

linux-next works for me too: no oops on 5 pulls or so.

> request shortly, since it now needs to go via the merge window and I'm
> currently in mid journey to Russia.

I would request this to be fixed in stable asap.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
