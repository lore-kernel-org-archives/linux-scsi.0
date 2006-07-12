From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: question about sd_sync_cache and shutdown
Date: Wed, 12 Jul 2006 21:18:35 +0200
Message-ID: <44B54B0B.5040504@s5r6.in-berlin.de>
References: <44B44909.1000703@cs.wisc.edu> <44B5227C.5080707@s5r6.in-berlin.de> <44B52639.4040609@cs.wisc.edu> <44B54441.1030300@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:17884 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750810AbWGLTT3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 15:19:29 -0400
In-Reply-To: <44B54441.1030300@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

I wrote:
> Indeed, 2.6.16 does not call sd_sync_cache anymore when the driver 
> called scsi_remove_device.

PS:
When will the middle and upper layers of Linux' SCSI stack stop changing 
their behavior WRT hot unpluggable hardware? There were once plans to 
support that kind of hardware in the 2.6 series.
-- 
Stefan Richter
-=====-=-==- -=== -==--
http://arcgraph.de/sr/
