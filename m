From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Sat, 28 Aug 2004 17:36:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828153601.GA28326@suse.de>
References: <20040828143124.GB2518@suse.de> <Pine.LNX.4.44L0.0408281109550.30753-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:8873 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267195AbUH1PgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 11:36:13 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0408281109550.30753-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, Aug 28 2004, Alan Stern wrote:
> > That said, it still wants splitting into two before you should go
> > higher.
> 
> I don't understand.  What needs to be split into two?  And why?

See earlier discussion on this field - it needs to be split into a 'max
hardware/driver supported value' and a 'optimal real life value' where
the latter could be controlled dynamically by looking at response and
completion times of requests.

Right now ->max_sectors is a grey area, sometimes it's a hardware/driver
limit, often it is not. But we have to treat it as such for now.

Jens

