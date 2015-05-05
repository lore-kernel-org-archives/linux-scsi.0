From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7] st implement tape statistics
Date: Tue, 5 May 2015 10:42:41 -0700
Message-ID: <20150505174241.GA6033@infradead.org>
References: <DDB9C85B850785449757F9914A034FCB3BFA45A3@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbbEERmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 13:42:43 -0400
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BFA45A3@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

The subject line should be

"st: implement tape statistics" to fit the general scheme.

On Thu, Apr 23, 2015 at 08:06:50AM +0000, Seymour, Shane M wrote:
> Signed-off-by: Shane Seymour <shane.seymour@hp.com>
> Tested-by: Shane Seymour <shane.seymour@hp.com>

Tested-by is usually used for other testers, not the patch author.

Where is the description of what these staistics do and what you need
them for?  A patch with just a subject and a signoff is unlikely to get
applied.

A lot of the code seems to be duplicates of what we do in block
layer statistics, I wonder if there is any way to share that code?
