From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [bk patches] move scsi headers
Date: Tue, 27 May 2003 06:14:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527061444.A1905@infradead.org>
References: <20030527034239.GA16376@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:29191 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263461AbTE0FBc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 01:01:32 -0400
Content-Disposition: inline
In-Reply-To: <20030527034239.GA16376@gtf.org>; from jgarzik@pobox.com on Mon, May 26, 2003 at 11:42:39PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Mon, May 26, 2003 at 11:42:39PM -0400, Jeff Garzik wrote:
> 
> James, please do a
> 
> 	bk pull bk://kernel.bkbits.net/jgarzik/scsi-misc-2.5

Also I already told you that the header organisation is crap.  include/scsi
exists for a reason, the scsi.h/host.h split is broken and scsi_obsolete.h
should go away not moved around.

If you want to do something useful you could start removing scsi_obsolete.h,
make the scsi core and scsi.h/hosts.h clean of the obsolete typedefs first.
