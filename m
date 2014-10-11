From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Sat, 11 Oct 2014 10:39:02 -0700
Message-ID: <20141011173902.GA1946@infradead.org>
References: <20141010074901.GA32028@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJKRjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Oct 2014 13:39:08 -0400
Content-Disposition: inline
In-Reply-To: <20141010074901.GA32028@sucs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Fri, Oct 10, 2014 at 08:49:01AM +0100, Sitsofe Wheeler wrote:
> Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance
> even though they implement post SPC-2 features (such as thin
> provisioning) which means the Linux kernel does not go on to test for
> those features even though they are advertised.
> 
> A previous patch attempted to add a quirk to workaround this but the
> quirk was only enabled after the features had been scanned for, wouldn't
> work for "small" disks and would quirk on  all Hyper-V SCSI devices
> (e.g. passthrough disks).
> 
> The new patches partially revert the previous effort, add the quirk in a
> more traditional manner to only Hyper-V virtual disks and work on small
> virtual disks.

This seems like might want a quirk to simply "force" a SPC3 compliance
level?
