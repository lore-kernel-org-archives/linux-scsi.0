From: Mike Miller <mike.miller@hp.com>
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
Date: Thu, 1 Oct 2009 16:42:39 -0500
Message-ID: <20091001214239.GA15691@beardog.cce.hp.com>
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com> <20091001143035.a83a7564.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29731 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZJAVlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 17:41:55 -0400
Content-Disposition: inline
In-Reply-To: <20091001143035.a83a7564.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Oct 01, 2009 at 02:30:35PM -0700, Andrew Morton wrote:
> On Thu, 01 Oct 2009 16:25:30 -0500
> "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> 
> > Add hpsa driver for HP Smart Array controllers.
> > 
> > This driver supports a subset of HP Smart Array Controllers.
> > It is a SCSI alternative to the cciss driver.
> 
> Does it support all the devices which cciss supports?
> 
> IOW, do we have a plan here to remove the cciss driver or must we
> maintain both drivers indefinitely?

Andrew,
The hpsa driver supports only the latest generation of Smart Array
controllers plus the P400 and P800. The goal was to have minimal overlap but
if we included only the very latest I suspect little testing would be done
because of the availability of new hardware.

No new controllers will be added to cciss once hpsa is accepted. We're
looking at supporting both drivers for 3 or 4 years until cciss can be
phased out completely.

-- mikem
