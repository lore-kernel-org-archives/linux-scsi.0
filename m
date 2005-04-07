From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Use proper seq_file api for /proc/scsi/scsi
Date: Thu, 7 Apr 2005 12:24:12 +0100
Message-ID: <20050407112412.GA12072@infradead.org>
References: <42550173.1040503@suse.de> <20050407103123.GB9586@infradead.org> <425517B3.2010702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31975 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262438AbVDGLYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2005 07:24:16 -0400
Content-Disposition: inline
In-Reply-To: <425517B3.2010702@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Apr 07, 2005 at 01:21:23PM +0200, Hannes Reinecke wrote:
> > /proc/scsi/scsi is deprecated and even only compiled in if
> > "legacy /proc/scsi/ support" is enabled.  Please move over to lssci which
> > is using sysfs ASAP.
> > 
> Ah. And that's enough reason for it not to work properly?
> Deprecated as it may be, but one could at least expect it to _work_.

It works for those setups that already worked with 2.4.x, aka only a few
luns.

