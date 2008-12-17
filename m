From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 14:14:09 -0500
Message-ID: <1229541249.3508.24.camel@localhost.localdomain>
References: <20081217164210.GC19967@parisc-linux.org>
	 <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>
	 <20081217180640.GE19967@parisc-linux.org>
	 <1229540692.3508.18.camel@localhost.localdomain>
	 <20081217191135.GF19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42783 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbYLQTOA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 14:14:00 -0500
In-Reply-To: <20081217191135.GF19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

On Wed, 2008-12-17 at 12:11 -0700, Matthew Wilcox wrote:
> On Wed, Dec 17, 2008 at 02:04:52PM -0500, James Bottomley wrote:
> > Actually, we can't afford to send READ CAPACITY(16) to failing devices;
> > some of them never come back.
> 
> When you say 'never come back', do you mean:
> 
> a) The drive discards the command silently
> b) The drive hangs until a reset is issued
> c) The drive hangs until it's power-cycled
> d) The drive turns into a paperweight

All of the above ... this is USB ... well, I don't *know* of a D
case ... but I wouldn't bet one doesn't exist.

James


