From: Thomas =?iso-8859-1?Q?Lang=E5s?= <tlan@stud.ntnu.no>
Subject: Re: Linux Kernel 2.4.18 and 2.4.19 problems
Date: Fri, 19 Jul 2002 23:44:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020719214437.GB14331@stud.ntnu.no>
References: <20020719192607.GA13880@stud.ntnu.no> <20020719140416.A25577@eng2.beaverton.ibm.com> <3D3883F6.7090608@fabbione.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D3883F6.7090608@fabbione.net>
List-Id: linux-scsi@vger.kernel.org
To: Fabio Massimo Di Nitto <fabbione@fabbione.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Fabio Massimo Di Nitto:
> I have an HSG80 connected on the other side and I got this problem with
> the beta6 drivers from qlogic.
> The only way I made it working was using the kernel driver shipped with 
> rh7.3
> that has been modified to support the HSG80 (according to the changelog  
> supported
> only by the beta6 series).

I find it odd if it's the driver, to be honest. Cause we've been running
with everything from 4.x-series, 5.x-series and 6.x-series on our current
in-production-system. This also runs linux vanilla, although with qla
driver patched in-kernel. (Currently 2.4.18 running).

So, the only differense between the new and old setup is:
* Dell 2550 in old vs 2650 in new (2xP3 vs 2xP4 Xeon)
* Old servers mount one disk each (and have only one HBA), but
  the new servers are supposed to have two HBAs, and have one
  disk on each HBA.

I don't see any good reason why this should result in no disks found
whatsoever.

-- 
Thomas
