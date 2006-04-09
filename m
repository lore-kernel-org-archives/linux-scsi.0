From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] sbp2: remove manipulation of inquiry response
Date: Sun, 9 Apr 2006 12:19:08 +0100
Message-ID: <20060409111907.GA20852@infradead.org>
References: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de> <4438070E.9000804@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10422 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750722AbWDILTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Apr 2006 07:19:09 -0400
Content-Disposition: inline
In-Reply-To: <4438070E.9000804@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sat, Apr 08, 2006 at 08:55:10PM +0200, Stefan Richter wrote:
> I wrote:
> >This code became ineffective a few Linux releases ago and is
> >apparently not required anyway.
> 
> PS: Of my SBP-2 devices, 3 of 3 CD-RWs and 3 of 7 HDDs report a SCSI 
> level of 0. With and without the patch.

do they expect scsi1/2-style lun encoding in the cbd or not?

