From: Christoph Hellwig <hch@infradead.org>
Subject: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 22:41:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117224141.A23032@infradead.org>
References: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>; from mingz@ele.uri.edu on Sun, Nov 17, 2002 at 05:35:52PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Doug Ledford <dledford@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 05:35:52PM -0500, Ming Zhang wrote:
> Hi, Doug
> 
> For example, like the iSCSI target code, when it start, it should find all SCSI disks or tapes link in order to export to client side.

Why you just do this in userspace?

> It need the scsi_device pointer in order to send requests to it. That is why I need it.

Umm, no.  Nothing but upperlayer drivers is supposed to talk to the scsi
midlayer directly. Implement an upperlayer driver and check for disks in
->attach instead.

