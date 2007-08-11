From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 10/30] megaraid: add CERC_ATA100 support
Date: Fri, 10 Aug 2007 21:06:44 -0400
Message-ID: <1186794404.6334.24.camel@localhost.localdomain>
References: <200708102150.l7ALodH3011345@imap1.linux-foundation.org>
	 <0631C836DBF79F42B5A60C8C8D4E8229BF18C7@NAMAIL2.ad.lsil.com>
	 <20070810153600.7cd204b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60705 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758144AbXHKBGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 21:06:46 -0400
In-Reply-To: <20070810153600.7cd204b0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Patro, Sumant" <Sumant.Patro@lsi.com>, linux-scsi@vger.kernel.org, tkrah@fachschaft.imn.htwk-leipzig.de, protasnb@gmail.com, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

On Fri, 2007-08-10 at 15:36 -0700, Andrew Morton wrote:
> On Fri, 10 Aug 2007 16:20:54 -0600
> "Patro, Sumant" <Sumant.Patro@lsi.com> wrote:
> 
> > ID being added is already supported in megaraid_mbox driver.
> 
> umm, why should that cause us to avoid supporting it in the old driver?

Because we'll have the identical ID exported from two drivers and the
automatic matching logic in the bootloaders will get confused.

If there's evidence that megaraid_mbox doesn't work for this, then we
can move the id across, but really the legacy megaraid driver isn't very
well maintained at this point so its in our interest to move as many
devices as possible to it not away.

James


