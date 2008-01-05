From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Open-FCoE on linux-scsi
Date: Sat, 5 Jan 2008 08:28:23 +0000
Message-ID: <20080105082822.GA19066@infradead.org>
References: <20080104205938U.fujita.tomonori@lab.ntt.co.jp> <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com> <477EC411.9040703@s5r6.in-berlin.de> <477ECAD4.8010809@s5r6.in-berlin.de> <477ECD88.6090802@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40265 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYAEI2o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 03:28:44 -0500
Content-Disposition: inline
In-Reply-To: <477ECD88.6090802@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Dev, Vasu" <vasu.dev@intel.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Love, Robert W" <robert.w.love@intel.com>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, linux-scsi@vger.kernel.org

On Sat, Jan 05, 2008 at 01:21:28AM +0100, Stefan Richter wrote:
> PS: There is already an RFC 2625 implementation in Linux, but only for
> LSIFC9xx.

There has also been one for interphace cards which was removed because
the driver was entirely unmaintained.  qlogic also has/had an out of
tree driver.

Now doing IP over FC over Ethernet sounds like a lot of useless fun :)
