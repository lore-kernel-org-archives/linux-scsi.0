From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI /proc query ...
Date: Wed, 22 Sep 2004 10:14:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922101426.A381@infradead.org>
References: <20040922062305.52594.qmail@web52507.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:56591 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263100AbUIVJO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 05:14:28 -0400
Content-Disposition: inline
In-Reply-To: <20040922062305.52594.qmail@web52507.mail.yahoo.com>; from shobhitmmathur@yahoo.com on Tue, Sep 21, 2004 at 11:23:05PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Shobhit Mathur <shobhitmmathur@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Sep 21, 2004 at 11:23:05PM -0700, Shobhit Mathur wrote:
> Hello,
> 
> I intend to implement /proc interface for a SCSI HBA.

Don't do that.  We're not going to take new drivers that implement ->proc_info
anymore.

