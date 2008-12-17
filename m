From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 12:11:36 -0700
Message-ID: <20081217191135.GF19967@parisc-linux.org>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com> <20081217180640.GE19967@parisc-linux.org> <1229540692.3508.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39111 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYLQTLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 14:11:37 -0500
Content-Disposition: inline
In-Reply-To: <1229540692.3508.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

On Wed, Dec 17, 2008 at 02:04:52PM -0500, James Bottomley wrote:
> Actually, we can't afford to send READ CAPACITY(16) to failing devices;
> some of them never come back.

When you say 'never come back', do you mean:

a) The drive discards the command silently
b) The drive hangs until a reset is issued
c) The drive hangs until it's power-cycled
d) The drive turns into a paperweight

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
