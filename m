From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Tue, 23 Jun 2009 15:11:18 +0100
Message-ID: <20090623141118.GD6682@shadowen.org>
References: <1245756306-29023-1-git-send-email-apw@canonical.com> <1245756306-29023-2-git-send-email-apw@canonical.com> <20090623115020.GA28963@kiste.smurf.noris.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:60882 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbZFWOLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2009 10:11:19 -0400
Content-Disposition: inline
In-Reply-To: <20090623115020.GA28963@kiste.smurf.noris.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 01:50:20PM +0200, Matthias Urlichs wrote:
> Hi,
> 
> Andy Whitcroft:
> > From: Mathias Urlichs <matthias@urlichs.de>
> > 
> Well ... "Matthias", if you please.

Well that is most peculiar, your name is sufficiently alien to my naive
tongue that I am sure I cut-n-pasted it wholesale to there from somewhere.
It looks like I got it from the s-o-b line in the patch:

	Signed-Off-By: Mathias Urlichs <matthias@urlichs.de>

Yeah it seems you got your name wrong in the original patch on the Kernel
bugzilla, and I have propogated it to there:

	http://bugzilla.kernel.org/show_bug.cgi?id=11120#c4

So I guess all of those references need changing.  If these patches need
regenerating please let me know.

-apw
