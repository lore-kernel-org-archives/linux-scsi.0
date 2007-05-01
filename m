From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Mon, 30 Apr 2007 21:10:32 -0500 (CDT)
Message-ID: <20070501021032.61120DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:41584 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423675AbXEACKd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 22:10:33 -0400
In-Reply-To: "from (env: rct) at Apr 30, 2007 09:33:12 am"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

rct wrote:
> Apologies to all concerned for an unfortunate delay in resolving this.
> (...)
> I'll go retrieve a more conservatively-configured source tree (closer to
> what DSL-N uses) and start over...

Success with the Debian 2.6.18-4-486 build, which is known to work
almost as well on the test platform as the 2.6.12 kernel that DSL-N
comes with.  I used an older compiler than Debian used for their
production build, so I binary-patched the aha1542.ko and sr_mod.ko
files so insmod wouldn't complain about different vermagic strings.

That's as close as it gets without redoing everything from scratch.
I'll give Alan's and James' patches a go within the next 13 hours.

(Alan: what *else* would you name a variable associated with a bounce
buffer besides Zebedee?  Thanks for the occasion to smile...)

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
