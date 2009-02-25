From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sd: Try READ CAPACITY 16 first for all SCSI-3 devices
Date: Wed, 25 Feb 2009 15:31:11 -0700
Message-ID: <20090225223110.GY16891@parisc-linux.org>
References: <20081223164703.GB19967@parisc-linux.org> <yq1sko4y7e4.fsf@sermon.lab.mkp.net> <20081231135014.GE2002@parisc-linux.org> <20081231135142.GF2002@parisc-linux.org> <20090223215137.GA13649@parisc-linux.org> <1235600621.19035.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41915 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZBYWbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 17:31:13 -0500
Content-Disposition: inline
In-Reply-To: <1235600621.19035.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 25, 2009 at 02:23:41PM -0800, James Bottomley wrote:
> On Mon, 2009-02-23 at 14:51 -0700, Matthew Wilcox wrote:
> > Any reason this patch hasn't been merged into scsi-misc yet?
> 
> There was a problem with it I drew your attention to here:
> 
> http://marc.info/?l=linux-scsi&m=123308499405071

This was the updated version, sent on Dec 31, not the version you
commented on on Dec 23.

(I didn't notice your earlier request because I was on vacation when
you sent it).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
