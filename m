From: Christoph Hellwig <hch@lst.de>
Subject: Re: IA32 (2.6.1 - 2003-12-30.22.30) - 4 New warnings (gcc 3.2.2)
Date: Wed, 31 Dec 2003 13:06:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031231120606.GA16225@lst.de>
References: <200312311132.hBVBWcg6008411@cherrypit.pdx.osdl.net> <20031231040047.19174e49.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:47772 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264108AbTLaMGL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 07:06:11 -0500
Content-Disposition: inline
In-Reply-To: <20031231040047.19174e49.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: John Cherry <cherry@osdl.org>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Dec 31, 2003 at 04:00:47AM -0800, Andrew Morton wrote:
> John Cherry <cherry@osdl.org> wrote:
> >
> > drivers/scsi/aacraid/aachba.c:1409: warning: `flag' might be used uninitialized in this function
> > drivers/scsi/eata_generic.h:84:1: warning: "TIMEOUT" redefined
> > drivers/scsi/inia100.c:421: warning: `pHCB' might be used uninitialized in this function
> > include/scsi/scsi.h:305:1: warning: this is the location of the previous definition
> 
> err, yes.  The inia100.c one is 100% deadly.

Eek, how did that update make mainline?  I just posted it to linux-scsi
looking for a tester.  Please back the change out for now.
