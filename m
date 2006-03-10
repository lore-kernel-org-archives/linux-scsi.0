From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [SCSI] Fix sgiwd93 build as a module.
Date: Fri, 10 Mar 2006 20:19:36 +0000
Message-ID: <20060310201936.GA13082@infradead.org>
References: <20060310201423.GA9988@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57319 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752075AbWCJUTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 15:19:38 -0500
Content-Disposition: inline
In-Reply-To: <20060310201423.GA9988@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 10, 2006 at 08:14:23PM +0000, Ralf Baechle wrote:
> wd33c93 needs to call sgiwd93_reset.

This can't work.  sgiwd93 depends on symbols from wd33c93 already,
and when wd33c93 calls directly into sgiwd93 you'd get a depency loop.

