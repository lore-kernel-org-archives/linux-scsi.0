From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 14:12:36 -0600
Message-ID: <20071017201236.GA10980@parisc-linux.org>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com> <20071017162747.GA32174@parisc-linux.org> <20071017184648.GB4533@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41445 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760661AbXJQUMk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 16:12:40 -0400
Content-Disposition: inline
In-Reply-To: <20071017184648.GB4533@1wt.eu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

On Wed, Oct 17, 2007 at 08:46:48PM +0200, Willy Tarreau wrote:
> Sincere thanks for your help and review. I'll apply this patch in
> 2.4.36-pre2 and in next 2.4.35.X. An ugly fix is clearly better than
> a massive change at this stage.

You're most welcome.  I have no desire to act as maintainer for sym2 in
2.4 at this point, but if you've got any other related bugs, feel free
to point me at them.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
