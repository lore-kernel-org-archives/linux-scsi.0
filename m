From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: SCSI RAM driver
Date: Tue, 19 Feb 2008 22:14:53 +0900
Message-ID: <20080219221442L.tomof@acm.org>
References: <20080218063658.GF21012@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:56615 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYBSNPD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 08:15:03 -0500
In-Reply-To: <20080218063658.GF21012@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, kristen.c.accardi@intel.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 17 Feb 2008 23:36:59 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> 
> This is the first release of a driver we've been using internally at Intel
> for a few weeks which is as low-latency as possible.  It's designed to
> let us find latency issues elsewhere in the storage stack (eg filesystem,
> block layer, scsi layer)
> 
> There are a few different options, controlled through module parameters.
> The sector size and disc capacity are load-time parameters, but the
> parameters affecting performance are tweakable at runtime.
> 
> Arguably, this driver should be merged into scsi_debug.  I didn't want to
> trip over Doug's toes while developing this driver, and the two drivers
> do have very different objectives.  scsi_debug is obviously a lot more
> fully-featured and implements lots of bits of the spec I simply haven't
> bothered with.  Like MODE SENSE ;-)

I see that two drivers have very different objectives but if we add
use_thread option to scsi_debug (we can do easily), it seems that
scsi_debug can provide all the features that scsi_ram does.

If we clean up scsi_debug driver, can scsi_debug work as a nice scsi
ram driver?
