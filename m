From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 09:47:53 -0600
Message-ID: <20060621154753.GV1630@parisc-linux.org>
References: <20060620222756.GO1630@parisc-linux.org> <44995CCF.3050200@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:5358 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751292AbWFUPry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 11:47:54 -0400
Content-Disposition: inline
In-Reply-To: <44995CCF.3050200@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 21, 2006 at 10:50:55AM -0400, Douglas Gilbert wrote:
> The peripheral device type is useful information, especially
> when it is other than "Direct Access".

*sigh*.  I wish you'd said that during the first iteration of the patch
;-P

How's this:

scsi 2:0:1:0: Direct-Access     HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 02 

I'll separate out the patches in a moment ... the first patch is a good
separate cleanup patch anyway.

