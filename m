From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 11:44:44 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118114444.A24013@infradead.org>
References: <3FB9E777.6020404@torque.net> <OFD032B1FF.F1D45476-ONC2256DE2.0039CF43-C2256DE2.003DD890@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:24334 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262591AbTKRLoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 06:44:55 -0500
Content-Disposition: inline
In-Reply-To: <OFD032B1FF.F1D45476-ONC2256DE2.0039CF43-C2256DE2.003DD890@il.ibm.com>; from LIRANS@il.ibm.com on Tue, Nov 18, 2003 at 01:15:31PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Tue, Nov 18, 2003 at 01:15:31PM +0200, Liran Schour wrote:
> > Is there an upper limit on the size of the cdb you are interested in
> > (e.g. XDWRITE EXTENDED in SBC-2 is 64 bytes)?
> I have an upperlimit of 256 bytes.

That's far beyond what we could increase the cmnd buffers to.

> 
> > How were you planning to pass the cdb (length > 16) to the kernel?
> I am planning to build a filesystem in the kernel that will be over an OSD
> SCSI device. This layer will interact directly with the SCSI system.

I don't think there's a lot of chance to see your project supported in
mainline kernels.  Maybe we'll have to find a way to make it work when
it's ready for mainline submission, but before that you're on your own..

