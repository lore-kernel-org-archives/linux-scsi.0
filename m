From: Christoph Hellwig <hch@lst.de>
Subject: Re: BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 22 Jul 2010 10:36:10 +0200
Message-ID: <20100722083609.GA4435@lst.de>
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44208 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab0GVIgN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 04:36:13 -0400
Content-Disposition: inline
In-Reply-To: <20100722173716.66264bef@notabene>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On Thu, Jul 22, 2010 at 05:37:16PM +1000, Neil Brown wrote:
> I suspect that problem is that "do_sync" and "do_barriers" in
> drivers/md/raid1.c are still 'bool' and should now be 'unsigned long'.
> 
> I'm not sure how wide '_Bool' is, but I'm guess it isn't wide enough.
> 
> Could you please try changing ever 'bool' in that file to 'unsigned long'
> and see if that fixes it?

Yes, that fixes it.  We even had someone sending that fix a while ago,
but it seems it's not applied to Jens' tree yet and I can't find it
anymore either right now.

