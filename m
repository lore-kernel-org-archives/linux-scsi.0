From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Wed, 1 Jul 2009 18:28:37 +0200
Message-ID: <20090701162837.GE7964@kiste.smurf.noris.de>
References: <1245756306-29023-1-git-send-email-apw@canonical.com> <1245756306-29023-2-git-send-email-apw@canonical.com> <1245771089.4149.88.camel@mulgrave.site> <20090623160408.GA22716@smurf.noris.de> <20090701155843.GE13837@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smurf.noris.de ([192.109.102.42]:32378 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752781AbZGAQ3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 12:29:46 -0400
Content-Disposition: inline
In-Reply-To: <20090701155843.GE13837@shadowen.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

Andy Whitcroft:
> > > echo 63 > /sys/block/<disk>/queue/max_sectors_kb
> > > 
> > Thank you, I'll do that tonight.
> 
> How did this one work out for you?  I don't think I saw a reply either
> way?
> 
Bah. Thanks for the reminder; I totally forgot to send that email.
(Too much other stuff in my life right now. (Mostly good, fortunately.))

Short version: It didn't. The controller now seems dead.
It times out all the time, and is unable to find any disks.

Unfortunately the thing is built-in and can't easily be replaced;
I don't have any warranty info for this machine either, so ...

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
v4sw7$Yhw6+8ln7ma7u7L!wl7DUi2e6t3TMWb8HAGen6g3a4s6Mr1p-3/-6 hackerkey.com
 - -
Sex is a misdemeanor -- the more I miss, de meaner I get.
