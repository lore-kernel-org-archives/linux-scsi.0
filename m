From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: SCSI_FC_TGT_ATTRS
Date: Mon, 14 Jul 2014 10:31:54 +0200
Message-ID: <20140714083154.GA21756@lst.de>
References: <1405326544.8281.17.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35969 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaGNIb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 04:31:59 -0400
Content-Disposition: inline
In-Reply-To: <1405326544.8281.17.camel@x220>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, Jul 14, 2014 at 10:29:04AM +0200, Paul Bolle wrote:
> 0) Commit 73685a458f2e ("tgt: removal") landed in next-20140714. It
> states that "the CONFIG_SCSI_TGT, CONFIG_SCSI_SRP_TGT_ATTRS and
> CONFIG_SCSI_FC_TGT_ATTRS kbuild variable[s] [...] are no longer needed".
> It removed the Kconfig entry for SCSI_SRP_TGT_ATTRS, but it left the
> entries for SCSI_TGT and SCSI_FC_TGT_ATTRS untouched.
> 
> 1) Both SCSI_TGT and SCSI_FC_TGT_ATTRS appear to be unused after that
> commit. Is a patch to remove their Kconfig entries queued somewhere?

We missed those two options, feel free to send a patch.

