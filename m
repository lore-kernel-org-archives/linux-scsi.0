From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 11:50:15 -0500
Message-ID: <1145033415.3520.36.camel@mulgrave.il.steeleye.com>
References: <20060414092911.71f25ac1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:207 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751282AbWDNQuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 12:50:25 -0400
In-Reply-To: <20060414092911.71f25ac1.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: sam@ravnborg.org, scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-04-14 at 09:29 -0700, Randy.Dunlap wrote:
> WARNING: drivers/scsi/3w-9xxx.o - Section mismatch: reference to .init.data: from .data between 'twa_driver' (at offset 0x18) and 'twa_error_table'
> WARNING: drivers/scsi/3w-xxxx.o - Section mismatch: reference to .init.data: from .data between 'tw_driver' (at offset 0x18) and 'tw_sense_table'
> WARNING: drivers/scsi/gdth.o - Section mismatch: reference to .init.text:gdth_detect from .data between 'driver_template' (at offset 0x270) and 'async_cache_tab'
> 
> I either don't see a problem or I'm having trouble reading/decoding
> the warning messages.  Could you look at these 3 sometime?

These seem to have been turning up all over the tree.  The only common
feature seems to be that if you re-run the build, they don't show up
again.

James


