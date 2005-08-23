From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: /proc/scsi/scsi patch for large number of devices
Date: Tue, 23 Aug 2005 18:42:06 +0100
Message-ID: <20050823174206.GA12359@infradead.org>
References: <1124815241.22518.11.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15588 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932244AbVHWRmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 13:42:10 -0400
Content-Disposition: inline
In-Reply-To: <1124815241.22518.11.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 23, 2005 at 09:40:40AM -0700, Mark Haverkamp wrote:
> 
> I'm not sure if people care about /proc/scsi, but here is a patch so you
> can cat /proc/scsi/scsi when you have a large number of scsi devices.  I
> have over 4000 devices configured and when I would cat /proc/scsi/scsi I
> would see a memory allocation error.  I instead used the seq_file
> iterator to display the devices.  The patch is a little brute force, but
> it only took about 2.5 seconds to display 4000 devices.

We had this before, and the answer is: don't use /proc/scsi if you have
lots of device.  Don't even enable the config option.

