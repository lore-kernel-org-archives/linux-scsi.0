From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE 2/6] Linux-iSCSI High-Performance Initiator
Date: Tue, 12 Apr 2005 09:14:03 +0100
Message-ID: <20050412081403.GA551@infradead.org>
References: <425B3F58.2040000@yahoo.com> <20050412053650.GF32372@kroah.com> <20050412072733.GA32354@infradead.org> <20050412074514.GA1630@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44460 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262046AbVDLIOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 04:14:07 -0400
Content-Disposition: inline
In-Reply-To: <20050412074514.GA1630@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Aizman <itn780@yahoo.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Apr 12, 2005 at 12:45:14AM -0700, Greg KH wrote:
> Um, why?  We've been down this road before, and for types that cross the
> boundry, we _must_ use the __ version of the kernel types, not the
> uint32_t stuff.

That's total bullshit.  C99 types just work in both the kernel and userland,
while __u* types need to be typedefed to these exact C99 everywhere in
userland bnecause they're only provided in kernelspace.

