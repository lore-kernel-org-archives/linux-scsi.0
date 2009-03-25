From: Bill Nottingham <notting@redhat.com>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Wed, 25 Mar 2009 15:03:21 -0400
Message-ID: <20090325190321.GB25176@nostromo.devel.redhat.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <20090325190137.GA8509@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45107 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZCYTEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 15:04:38 -0400
Content-Disposition: inline
In-Reply-To: <20090325190137.GA8509@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Christoph Hellwig (hch@infradead.org) said: 
> On Wed, Mar 25, 2009 at 03:00:46PM -0400, Bill Nottingham wrote:
> > scsi_wait_scan.ko is a bad interface for a variety of reasons:
> > - once you load it, it stays in memory doing nothing
> > - if you need to call it again, you first need to check for the module
> >   and unload it first
> > - waiting for scsi scans shouldn't require module loading privleges in
> >   any case
> > 
> > This creates a simpler interface that doesn't require as much
> > scaffolding in userspace.
> 
> /proc/scsi/scsi is deprecated, plese don't add more features to it.

Then where is a better place to put this, as scsi_wait_scan.ko is
a ridiculous interface for userspace?

Bill
