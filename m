From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 26 Nov 2003 13:41:38 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126134138.A5897@infradead.org>
References: <200310231734.10263.krmurthy@cisco.com> <20031027153932.A16679@infradead.org> <yqujvfpdwu4f.fsf@chaapala-lnx2.cisco.com> <20031121173236.GX30485@parcelfarce.linux.theplanet.co.uk> <yqujn0apwpp2.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:38406 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263591AbTKZNll (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 08:41:41 -0500
Content-Disposition: inline
In-Reply-To: <yqujn0apwpp2.fsf@chaapala-lnx2.cisco.com>; from chaapala@cisco.com on Fri, Nov 21, 2003 at 12:18:17PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@infradead.org>, Krishna Murthy <krmurthy@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Fri, Nov 21, 2003 at 12:18:17PM -0600, Clay Haapala wrote:
> Question:  Should the implementation use the crypto api
> or be added to the lib/crc32 code?

I've talen a quick look at the code and it looks like you're doing the crc
not only for control but also for data packages, thus it seems the best idea
to make it a digest in the crypto framework.

