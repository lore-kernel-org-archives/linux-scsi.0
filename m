From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Sat, 14 Mar 2009 22:11:24 +0100
Message-ID: <20090314211124.GB3353@uranus.ravnborg.org>
References: <200903142003.n2EK39r4031547@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepb.post.tele.dk ([195.41.46.236]:57062 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZCNVJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Mar 2009 17:09:26 -0400
Content-Disposition: inline
In-Reply-To: <200903142003.n2EK39r4031547@blc-10-6.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

On Sat, Mar 14, 2009 at 01:03:09PM -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains code that interfaces to upper layer linux kernel, such as
> PCI, SCSI mid-layer and sysfs etc. It is created using 2.6.29-rc8 kernel.

This changelog does not say much.
What is interfacing to upper layers for example.
That it is created using 2.6.... is also useless once it is in the kernel.
Try to think of what you expect to read when you look at the changelog
of the patch as an outsider.

	Sam
