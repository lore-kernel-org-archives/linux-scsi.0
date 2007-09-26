From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 20:56:08 -0600
Message-ID: <20070926025608.GA3899@parisc-linux.org>
References: <1190768402.8707.20.camel@localhost.localdomain> <20070925065233Q.tomof@acm.org> <1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org> <46F9C5ED.6050505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41860 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbXIZC4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 22:56:11 -0400
Content-Disposition: inline
In-Reply-To: <46F9C5ED.6050505@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
> Are there any const-ness worries for scsi_host_template, or plans for 
> the future?  I do not see any other examples of the host template 
> members getting modified.

Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
I've come across trawling the horrible unmaintained drivers.  I'd love
to see scsi_host_template become const, but it's not happening any time
soon, and we can address this little piece when the time comes.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
