From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reiserfs and SCSI oops seen in 2.6.9-rc2 with local SCSI disk IO
Date: Fri, 24 Sep 2004 18:58:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040924185852.A30140@infradead.org>
References: <4154372C.7070506@netapp.com> <20040924151828.GC16153@parcelfarce.linux.theplanet.co.uk> <4154404B.3070705@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:14098 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268995AbUIXR67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 13:58:59 -0400
Content-Disposition: inline
In-Reply-To: <4154404B.3070705@netapp.com>; from davidw@netapp.com on Fri, Sep 24, 2004 at 11:42:03AM -0400
List-Id: linux-scsi@vger.kernel.org
To: David Wysochanski <davidw@netapp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 24, 2004 at 11:42:03AM -0400, David Wysochanski wrote:
> I've been seeing a lot of problems with reiserfs that I
> don't see on ext2 or ext3, so I would tend to agree with you.
> Do you know where I could post for the reiserfs folks?

linux-fsdevel@vger.kernel.org is the list for filesystem development, but
for error reports lkml is probably also okay.

