From: Christoph Hellwig <hch@infradead.org>
Subject: Re: host_self_blocked question/bug?
Date: Wed, 26 Nov 2003 13:44:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126134419.A6004@infradead.org>
References: <3FC3CDCF.4030105@us.ibm.com> <1069797320.1787.220.camel@mulgrave> <3FC3D82D.2030604@us.ibm.com> <20031125163204.A5150@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:40454 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263839AbTKZNoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 08:44:23 -0500
Content-Disposition: inline
In-Reply-To: <20031125163204.A5150@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Nov 25, 2003 at 04:32:04PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Nov 25, 2003 at 04:32:04PM -0800, Patrick Mansfield wrote:
> (There should be locking around all the setting and checking of
> host_self_blocked.)

the same is true for many of the 1 bit bitfileds in struct Scsi_Host/
scsi_device, we should probably use the atomic bitmap operations for
those.  It's been on my todo list for a while, but I wonder whether
that's enough of an interface change to be postponed to 2.7.x.

