From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mptsas: support basic hotplug
Date: Fri, 13 Jan 2006 17:05:29 +0100
Message-ID: <20060113160529.GA813@lst.de>
References: <20060113100905.GA26592@lst.de> <1137167747.3365.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:217 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965013AbWAMQFl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 11:05:41 -0500
Content-Disposition: inline
In-Reply-To: <1137167747.3365.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: Christoph Hellwig <hch@lst.de>, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Fri, Jan 13, 2006 at 09:55:47AM -0600, James Bottomley wrote:
> On Fri, 2006-01-13 at 11:09 +0100, Christoph Hellwig wrote:
> > +       struct semaphore         sas_topology_mutex;
> 
> The semaphore to mutex conversion squad will have me shot if I put that
> in.  If it's just a mutex, then you need to use the new mutex types.  If
> it's actually a real counting semaphore (which it doesn't look to be)
> then call it a semaphore.

well, the scsi-misc tree doesn't have the mutex code yet, so it wouldn't
compile if I did it that way.  I'll send a followon patch to convert it
to use real mutexes ones scsi-misc has merged the latest linus tree.

