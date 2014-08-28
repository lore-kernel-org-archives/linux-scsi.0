From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 08:56:38 -0700
Message-ID: <20140828155638.GA14133@infradead.org>
References: <53FF1AD8.9020800@suse.de>
 <53FF1DE9.5040605@redhat.com>
 <53FF1FE8.9060108@redhat.com>
 <53FF2199.4030300@redhat.com>
 <53FF2283.9000502@redhat.com>
 <53FF39F7.3070004@suse.de>
 <53FF430F.5060103@redhat.com>
 <53FF4709.9040801@suse.de>
 <94D0CD8314A33A4D9D801C0FE68B402958C2A1D0@G9W0745.americas.hpqcorp.net>
 <53FF50CA.70209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaH1P4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 11:56:43 -0400
Content-Disposition: inline
In-Reply-To: <53FF50CA.70209@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Aug 28, 2014 at 05:54:50PM +0200, Paolo Bonzini wrote:
> Il 28/08/2014 17:50, Elliott, Robert (Server Storage) ha scritto:
> > Is the block layer prevented from issuing a new command with the
> > same tag before the error handling is finished?
> 
> Tags are chosen by the LLDs, so it's up to it to pick the right tags.

When using scsi-mq or the older block level tagging implementation they
aren't.

