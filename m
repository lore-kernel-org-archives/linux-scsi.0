From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Tue, 3 Sep 2002 12:07:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020903120715.A11328@devserv.devel.redhat.com>
References: <20020828202534.G30927@redhat.com> <20020828174737.A27554@eng2.beaverton.ibm.com> <20020828214215.A31167@redhat.com> <20020830092257.A19730@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020830092257.A19730@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Aug 30, 2002 at 09:22:57AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, zaitcev@redhat.com

> Date: Fri, 30 Aug 2002 09:22:57 -0700
> From: Patrick Mansfield <patmans@us.ibm.com>

>[...]
> Do we really call scan_scsis and scsi_build_commandblocks while not in user
> context? Who is the caller (to scsi_register_host)?
> 
> Here is Pete's response saying he found such a case, but not where:

I did a call graph, but I discarded it since. IIRC it showed
some paths, but perhaps I made a mistake. Please ignore it.

The "fix" did not go anywhere, actually. Arjan explained that
if a box runs out of atomics, it's bad anyway. We reduced the
queue size in the driver that the guy used.

-- Pete
