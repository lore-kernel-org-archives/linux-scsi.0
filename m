From: Matthew Wilcox <willy@debian.org>
Subject: Re: syslog message
Date: Mon, 30 Aug 2004 19:07:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040830180727.GL16196@parcelfarce.linux.theplanet.co.uk>
References: <200408301716.i7UHGagO008392@bach.leonora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13246 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268803AbUH3SHd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 14:07:33 -0400
Content-Disposition: inline
In-Reply-To: <200408301716.i7UHGagO008392@bach.leonora.org>
List-Id: linux-scsi@vger.kernel.org
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 30, 2004 at 10:16:36AM -0700, Vladimir G. Ivanovic wrote:
>    kernel: Badness in sym_complete_error at drivers/scsi/sym53c8xx_2/sym_hipd.c:5513
>    kernel:  [<82886a76>] sym_complete_error+0x96/0x233 [sym53c8xx]
>    kernel:  [<8288021f>] sym53c8xx_intr+0x59/0xc5 [sym53c8xx]

Did you write this down incorrectly, or was the entry for sym_interrupt
(and several other entries) missing in the kernel backtrace?  There's
several paths from sym53c8xx_intr to sym_complete_error and I really
can't tell what's going on without more information.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
