From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: syslog message
Date: Mon, 30 Aug 2004 11:16:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408301816.i7UIGuBV009608@bach.leonora.org>
References: <20040830180727.GL16196@parcelfarce.linux.theplanet.co.uk>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:4602 "EHLO
	bach.leonora.org") by vger.kernel.org with ESMTP id S268868AbUH3SRG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 14:17:06 -0400
In-Reply-To: Your message of "Mon, 30 Aug 2004 19:07:27 BST."
             <20040830180727.GL16196@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

>>>>> "mw" == Matthew Wilcox <willy@debian.org> writes:

    mw> 
    mw> On Mon, Aug 30, 2004 at 10:16:36AM -0700, Vladimir G. Ivanovic wrote:
    >> kernel: Badness in sym_complete_error at drivers/scsi/sym53c8xx_2/sym_hipd.c:5513
    >> kernel:  [<82886a76>] sym_complete_error+0x96/0x233 [sym53c8xx]
    >> kernel:  [<8288021f>] sym53c8xx_intr+0x59/0xc5 [sym53c8xx]
    mw> 
    mw> Did you write this down incorrectly, or was the entry for sym_interrupt
    mw> (and several other entries) missing in the kernel backtrace?  There's
    mw> several paths from sym53c8xx_intr to sym_complete_error and I really
    mw> can't tell what's going on without more information.

I copied-n-pasted this from my syslog. 

I filed a bug (#131287) with Fedora Buzilla.

--- Vladimir

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
