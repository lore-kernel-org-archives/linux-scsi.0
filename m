From: Christoph Hellwig <hch@infradead.org>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 18:27:36 +0100
Message-ID: <20060428172736.GA11321@infradead.org>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35253 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030463AbWD1R1h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:27:37 -0400
Content-Disposition: inline
In-Reply-To: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Apr 28, 2006 at 11:54:05AM -0500, James Bottomley wrote:
> Could you send any bugs found back to linux-scsi (not the kernel
> bugzilla)?

not a bug strictly speaking, but it should stop including the firmware
blob and use request_firmware, similar to the discussion we had about
qla2xxx recently.  It would be even nicer if adaptec continued publishing
their sequencer code as with aic7xxx and aic79xx which look remarkably
similar, of course.

