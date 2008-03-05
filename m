From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 10:11:42 -0700
Message-ID: <20080305171142.GN24386@parisc-linux.org>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com> <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com> <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com> <1204734777.3047.40.camel@localhost.localdomain> <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42853 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbYCERLn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 12:11:43 -0500
Content-Disposition: inline
In-Reply-To: <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rodrigo Severo <rodrigo@fabricadeideias.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 05, 2008 at 01:52:50PM -0300, Rodrigo Severo wrote:
> I changed the following values on  29320LPE from the previous default ones:
> 
> Sync Transfer Rate: 160

Ah, you've been fooled by SCSI terminology.  U160 is 80 million
transfers per second, but each transfer is 16-bit wide, so they call it
U160.  Can you try turning that down to 80 (and just for fun, if that
fails, can you try 40?)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
