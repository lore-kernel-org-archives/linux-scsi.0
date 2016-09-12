From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: status of NCR5380-based ISA drivers
Date: Mon, 12 Sep 2016 20:08:53 +1200
Message-ID: <06105882-bf9c-fd1b-6d32-8a815aa3aafe@gmail.com>
References: <20160911171249.GA7554@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36108 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756825AbcILIJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2016 04:09:00 -0400
Received: by mail-pf0-f176.google.com with SMTP id 128so50087389pfb.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2016 01:09:00 -0700 (PDT)
In-Reply-To: <20160911171249.GA7554@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org

Christoph,

I test the atari_scsi front end - haven't got any ISA cards handy.
Probably no ISA slots on my PC main board either ...

Cheers,

	Michael

Am 12.09.2016 um 05:12 schrieb Christoph Hellwig:
> Hi all,
> 
> you seem to the currently active NCR580 cabal.  Which frontends to NCR5380
> do you test at the moment, or could you test?
> 
> NCR5380-based ISA drivers make up a significant part of those drivers still
> using scsi_module.c after it's 15 year deprecation period, and I'd like to
> either move them to this century or to the dust bin.
> 
> The drivers in question are: dtc, g_NCR5380, pas16 and t128.
> 
> Thanks,
> 	Christoph
> 
