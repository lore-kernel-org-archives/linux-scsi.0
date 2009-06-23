From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Tue, 23 Jun 2009 16:43:03 +0100
Message-ID: <20090623164303.3f85a799@lxorguk.ukuu.org.uk>
References: <1245756306-29023-1-git-send-email-apw@canonical.com>
	<1245756306-29023-2-git-send-email-apw@canonical.com>
	<1245771089.4149.88.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37613 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753793AbZFWPl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2009 11:41:58 -0400
In-Reply-To: <1245771089.4149.88.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Whitcroft <apw@canonical.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Mathias Urlichs <matthias@urlichs.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> Incidentally, SGBCOUNT isn't queue depth, its maximum number of sectors
> in an individual transfer.  What we'd need to show for this to be the
> fix is that every 32 bit aacraid card is affected, which, given the
> paucity of bug reports, I don't think so.

Its usually a specific firmware revision that weird problems with aacraid
hardware are linked to so it is worth trying different firmwares.

Alan
