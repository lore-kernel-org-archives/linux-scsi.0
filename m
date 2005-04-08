From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] Use proper seq_file api for /proc/scsi/scsi
Date: Fri, 8 Apr 2005 00:23:46 -0700
Message-ID: <20050408072345.GA1018765@sgi.com>
References: <42550173.1040503@suse.de> <20050407103123.GB9586@infradead.org> <425517B3.2010702@suse.de> <20050407112412.GA12072@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:42900 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S262728AbVDHHZw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2005 03:25:52 -0400
Content-Disposition: inline
In-Reply-To: <20050407112412.GA12072@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Apr 07, 2005 at 12:24:12PM +0100, Christoph Hellwig wrote:
> On Thu, Apr 07, 2005 at 01:21:23PM +0200, Hannes Reinecke wrote:
> > > /proc/scsi/scsi is deprecated and even only compiled in if
> > > "legacy /proc/scsi/ support" is enabled.  Please move over to lssci which
> > > is using sysfs ASAP.
> > > 
> > Ah. And that's enough reason for it not to work properly?
> > Deprecated as it may be, but one could at least expect it to _work_.
> 
> It works for those setups that already worked with 2.4.x, aka only a few
> luns.

Even if it's deprecated, wouldn't it be good to fix it as long as
it's there, unless it hurts something else?  Or at least fix the
out of memory error, even if it doesn't display all the luns?

jeremy
