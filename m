From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Tue, 23 Jun 2009 18:04:08 +0200
Message-ID: <20090623160408.GA22716@smurf.noris.de>
References: <1245756306-29023-1-git-send-email-apw@canonical.com> <1245756306-29023-2-git-send-email-apw@canonical.com> <1245771089.4149.88.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smurf.noris.de ([192.109.102.42]:36169 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754014AbZFWQFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2009 12:05:07 -0400
Content-Disposition: inline
In-Reply-To: <1245771089.4149.88.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Whitcroft <apw@canonical.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

James Bottomley:
> Firstly, Matthias, can you see if on an unmodified aacraid, this fixes
> the problem for you:
> 
> echo 63 > /sys/block/<disk>/queue/max_sectors_kb
> 
Thank you, I'll do that tonight.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Why did the chicken cross the road?

Ralph Waldo Emerson: It didn't cross the road; it transcended it.
