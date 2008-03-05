From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 05 Mar 2008 09:55:23 -0600
Message-ID: <1204732523.3047.27.camel@localhost.localdomain>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58727 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbYCEPz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 10:55:28 -0500
In-Reply-To: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rodrigo Severo <rodrigo@fabricadeideias.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-05 at 12:42 -0300, Rodrigo Severo wrote:
> Hi,
> 
> 
> I have this Adaptec 29320LPE SCSI board (used the aic79xx driver)
> which give several errors during boot time, just after it recognizes
> the HDs connected to it.
> 
> If I remove the SCSI HD there are no SCSI errors.
> 
> The very first error messages have scrolled up and I don't know how to
> get to them (is there a way?)

If you can get it to boot (say to a ramdisk with a shell) then dmesg
gives them ... otherwise you need a serial console.

>  but here is the transcript of what I can
> see:
> 
> scsi0: hwerrint, Sequencer Parity Error
> scsi0: hwerrint, Data-path Parity Error
> scsi0: hwerrint, Scratch or SCB Memory Parity Error
> scsi0: hwerrint, CIOBUS Parity Error

That's a pretty comprehensive sequence of parity errors.  Assuming
they're the root cause rather than something caused by the first error:
best case, you just need a better cable or termination; worst case, your
card is actually hosed in its internal data path.

James


