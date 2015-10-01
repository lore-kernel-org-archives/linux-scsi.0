From: Christoph Hellwig <hch@lst.de>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
	device
Date: Thu, 1 Oct 2015 07:21:59 +0200
Message-ID: <20151001052159.GA14247@lst.de>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp> <20150930151857.GA26594@lst.de> <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp> <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38104 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbbJAFWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 01:22:01 -0400
Content-Disposition: inline
In-Reply-To: <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Thu, Oct 01, 2015 at 04:38:45AM +0000, Junichi Nomura wrote:
> But another workload using dm-multipath still caues the same crash.
> I think a patch like the following is needed.
> What do you think?

Thanks Junichi,

I suspected that we should defer the release until we tear down
the sdev instead of unregister time.  Give me a little more time
to review your patch and actually reproduce your issue before a formal
ACK, though.

Any chance you could share all your multipath tests in a git repository
somewhere?  It seems like you're the only one actually having a good
set of reproducable but minimalistic tests.
