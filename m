From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraidPERC 3/Di Container goes offline
Date: Wed, 24 Nov 2004 13:09:05 +0000
Message-ID: <20041124130904.GA12830@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B694FA8@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:35277 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262678AbUKXNkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 08:40:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id iAOD9GWo032602
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 05:09:17 -0800
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B694FA8@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ryan Anderson <ryan@autoweb.net>, linux-scsi@vger.kernel.org

On Wed, Nov 24, 2004 at 07:59:04AM -0500, Salyzyn, Mark wrote:
> I dropped Andrew Morton from the direct mail recipients.
> 
> Thanks, made the change in my branch of the code. This adjustment will
> probably never be submitted to MarkH since I use it only for debugging
> purposes. However, would it be nice if the global scsi timeout could be
> `user' adjustable?
> 
> Not that I advocate it as readily accessible, since any storage device
> that takes longer than ten seconds is in `trouble', and any timeout
> longer than two minutes will no doubt cause servers to go offline on the
> internet. Its purpose is only for troubleshooting.

Yes, it would probably be nice to have a writeable timeout attribute for
the scsi device.  Care to submit a patch?
