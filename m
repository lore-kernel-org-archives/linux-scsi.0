From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 4.11-rc3
Date: Tue, 21 Mar 2017 12:01:58 -0400
Message-ID: <20170321160158.GA16054@linux-x5ow.site>
References: <1490108931.11580.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34705 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933215AbdCUQNr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 12:13:47 -0400
Content-Disposition: inline
In-Reply-To: <1490108931.11580.5.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Mar 21, 2017 at 11:08:51AM -0400, James Bottomley wrote:
> Nine small fixes: the biggest is probably finally sorting out Kconfig
> issues with lpfc nvme.

I'm sorry to disappoint you but there's another fix from Arnd from today
here: https://lkml.org/lkml/2017/3/21/308

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
