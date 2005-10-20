From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: ips.c warnings
Date: Thu, 20 Oct 2005 11:05:36 -0600
Message-ID: <20051020170536.GA13287@parisc-linux.org>
References: <4357CD0A.10300@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41936 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932484AbVJTRFj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:05:39 -0400
Content-Disposition: inline
In-Reply-To: <4357CD0A.10300@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Hammer <jack_hammer@adaptec.com>
Cc: akmpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, ipslinux@adaptec.com

On Thu, Oct 20, 2005 at 12:59:54PM -0400, Jack Hammer wrote:
> I did not use kmap() because these routines can be called from the interrupt handler context and kmap() can sleep.

Is there a reason you can't use kmap_atomic() then?
