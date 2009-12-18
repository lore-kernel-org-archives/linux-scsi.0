From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1
 (resubmit)
Date: Fri, 18 Dec 2009 01:11:03 +0100
Message-ID: <1261095063.2752.34.camel@mulgrave.site>
References: <1259545058-4358-1-git-send-email-huangj@brocade.com>
	 <04391A4E90BB2149B010D22452FA16875EF12BFE@HQ-EXCH-6.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZLRALI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2009 19:11:08 -0500
In-Reply-To: <04391A4E90BB2149B010D22452FA16875EF12BFE@HQ-EXCH-6.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

On Wed, 2009-12-16 at 19:55 -0800, Jing Huang wrote:
> What is the status of this patch set? Is there anything I can do in
> order to get it accepted in 2.6.33 merger window?

So, what actually happened is that it was submitted the day before the
merge window opened, so I started to reply and then got swamped with
merge window stabilisation work.

The reply was basically that the current split up still wasn't
acceptable.  What I want to see is one well described patch per logical
change.  What you actually did was split them up according to some
arbitrary standard, so we got changes described as

bfa: bfa changes part 1

and

bfa: bfa changes part 2

So what I can do this once is accumulate all the change logs (which were
better than the first time around) and do a single update for 2.6.33 on
promise of better change sets in future.

Is that OK?

James


