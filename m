From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch] SCSI I/O statistics
Date: Tue, 26 Sep 2006 12:23:47 -0600
Message-ID: <20060926182347.GH5017@parisc-linux.org>
References: <1159286194.2925.5.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <20060926103930.471b75a5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49638 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S932398AbWIZSXs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 14:23:48 -0400
Content-Disposition: inline
In-Reply-To: <20060926103930.471b75a5.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Sep 26, 2006 at 10:39:30AM -0700, Andrew Morton wrote:
> - Should it have been done at the block layer rather than at the scsi layer?

This was already mentioned when he sent it to linux-scsi a few days ago.
There are scsi commands which bypass the block layer, such as SG_IO, and
block layer stats can make an extremely busy disc look not busy.
