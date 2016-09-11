From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: status of NCR5380-based ISA drivers
Date: Sun, 11 Sep 2016 19:25:13 +0200
Message-ID: <201609111925.13269.linux@rainbow-software.org>
References: <20160911171249.GA7554@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:54826 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756123AbcIKRdC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:33:02 -0400
In-Reply-To: <20160911171249.GA7554@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org

On Sunday 11 September 2016 19:12:49 Christoph Hellwig wrote:
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

I have the HW to test g_NCR5380 - it currently works fine as it did never 
before.
I started a patch to for scsi_module.c removal (and other good things) but 
haven't had time to finish it. Hopefully, it will be ready soon.

-- 
Ondrej Zary
