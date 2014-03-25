From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix potential NULL pointer dereference.
Date: Tue, 25 Mar 2014 08:26:29 -0700
Message-ID: <20140325152629.GA20406@infradead.org>
References: <1395752333-12185-1-git-send-email-mlombard@redhat.com>
 <20140325131306.GA25392@infradead.org>
 <20140325133046.GD2416@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaCYP0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2014 11:26:37 -0400
Content-Disposition: inline
In-Reply-To: <20140325133046.GD2416@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, m.lombardi85@gmail.com

On Tue, Mar 25, 2014 at 02:30:46PM +0100, Maurizio Lombardi wrote:
> Yes you are right, it should call scsi_autopm_put_host before returning.
> So if you already have a correct version for it then I drop this patch.

This was the version I sent out:

http://git.infradead.org/users/hch/scsi.git/commitdiff/245e16e9091f92919c09c8bbae1d982d0717ba22

It's not correct for Jame's current tree as we also need to unwind
getting a reference on sdev_gendev now.  As there's been pushback
against the patch I didn't resubmit it yet, but now that I got my other
changes in the area in it might be worth to try again.

