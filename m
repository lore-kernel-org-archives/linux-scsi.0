From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 04:52:07 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0305250447350.19617-100000@montezuma.mastecende.com>
References: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from modemcable204.207-203-24.mtl.mc.videotron.ca ([24.203.207.204]:8833
	"EHLO montezuma.mastecende.com") by vger.kernel.org with ESMTP
	id S261564AbTEYIuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 04:50:25 -0400
In-Reply-To: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: john@grabjohn.com
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On Sun, 25 May 2003 john@grabjohn.com wrote:

> Thinking ahead, by the 2.8 timescale, PATA could well be legacy hardware 
> which could be supported only by an 'old' IDE driver, much like we already
> have at the moment - I.E. we could remove the current 'old' IDE driver
> sometime during the 2.7 timescale, and support SATA only via the SCSI layer.
> 
> This would save having any more than the minimum SATA code going in to the
> existing IDE driver, and consolidate work in the future.        

PATA is in _way_ too many current boxes, those computers will continue to 
run for a very long time from now. In 10 years what is technologically 
obselete will still be very capable.

> 
> The bloat of the SCSI layer in embedded machines might be a concern, but  
> then again, maybe it won't - how many embedded machines are going to be   
> using SATA, anyway?  Once we move away from spinning disks towards solid
> state storage, (which is going to happen first in the embedded market),
> will we want to use *ATA or SCSI at all?

You're confusing media and transport.

	Zwane
-- 
function.linuxpower.ca
