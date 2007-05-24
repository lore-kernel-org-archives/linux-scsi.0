From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 10:21:50 -0500
Message-ID: <1180020111.3692.24.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CEF@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35508 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbXEXPVx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 11:21:53 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CEF@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Thu, 2007-05-24 at 10:28 -0400, Salyzyn, Mark wrote:
> This is not just a maintainer's issue. We see the silent ACK treatment
> all the time from all avenues of inspection whether they be maintainers,
> illuminati, interested parties or JAFO. There is a little bit of a
> volunteer in every one of us.
> 
> Requiring the maintainer to be cc'd is a burden on the submitter, I do
> not want to spank someone that comes up with a useful patch that fails
> some bureaucratic litmus test. It is still a good idea, but lets try a
> different tactic?
> 
> James, you are a volunteer, so I can not require an increase in your
> burden. But it would be 'nice' if you had a git tree that reported
> pending approval (so that makes three persistent trees if I am correct,
> scsi-misc-2.6, scsi-rc-fixes-2.6 and scsi-pending-2.6?). This way we can
> tell that you saw it, and as a maintainer we can see a change even if we
> missed the patch email. It does make it hard for the maintainer to
> report *which* patch to approve, but he could do a blanket approval of
> what he sees in the pending tree? AndrewM can tell that he no longer
> needs to track the patch, as it is now the SCSI list's responsibility
> once it is in the pending tree.

We can certainly try that approach.  Please note that scsi-pending-2.6
will essentially be a quilt like tree (i.e. constantly rebasing) so it
will be impossible to pull incrementally from it ... but you will be
able to fetch from it and just check it out to give the patches an
inspection/try out.

James


