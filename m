From: rddunlap <rddunlap@xenotime.net>
Subject: Re: 2.6.3 CONFIG_SCSI_AIC7 X X X Kconfig bug
Date: Thu, 11 Mar 2004 07:42:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040311074241.53ba782a.rddunlap@xenotime.net>
References: <20040308211148.08cd89ff.rddunlap@xenotime.net>
	<20040311124646.GG2148@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bianca.affordablehost.com ([216.46.192.8]:18659 "EHLO
	bianca.affordablehost.com") by vger.kernel.org with ESMTP
	id S261397AbUCKPog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 10:44:36 -0500
In-Reply-To: <20040311124646.GG2148@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, olh@suse.de, james.bottomley@steeleye.com, gibbs@scsiguy.com

On Thu, 11 Mar 2004 12:46:46 +0000 Matthew Wilcox wrote:

| On Mon, Mar 08, 2004 at 09:11:48PM -0800, Randy.Dunlap wrote:
| > On Mon, Feb 09, Randy.Dunlap wrote:
| > > description:	make Adaptec AIC7xyx drivers depend on SCSI tristate
| 
| This is unnecessary if you apply this patch which Christoph had some
| vague objections to but didn't comment on further when I asked him to
| go into detail:
| 
| 
| 
| This patch corrects a couple of typos in drivers/scsi/Kconfig and
| makes the SCSI drivers menu depend on SCSI rather than on SCSI!=n.
| That has the effect of making every driver depend on SCSI, so we don't
| need the explicit dependency for every driver.


Good.  James, please apply Willy's patch.

Christoph ??

--
~Randy
