From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Pass information about device open/close to low-level
 driver
Date: Mon, 26 Sep 2011 16:12:16 -0400
Message-ID: <20110926201216.GA18666@infradead.org>
References: <Pine.LNX.4.44L0.1109261543240.1773-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45519
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030Ab1IZUM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Sep 2011 16:12:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1109261543240.1773-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <htejun@gmail.com>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Sep 26, 2011 at 04:10:32PM -0400, Alan Stern wrote:
> James:
> 
> Something like the patch below has been requested by the virtualization
> people.

Who are "the virtualization people"?

Either way this idea is a really bad one, and if you check history long
enough you'd notice we had all that crap in kernel before 2.6 and got
rid of it all.
