From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.4.28-pre3: broken ips update
Date: Mon, 13 Sep 2004 15:42:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040913144230.GU642@parcelfarce.linux.theplanet.co.uk>
References: <A121ABA5B472B74EB59076B8E3C8F019796579@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16518 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267651AbUIMOmd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 10:42:33 -0400
Content-Disposition: inline
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F019796579@rtpe2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: Adrian Bunk <bunk@fs.tum.de>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Sep 13, 2004 at 10:28:44AM -0400, Hammer, Jack wrote:
> This trivial one line patch corrects my mistake in ips.h. I assure you
> that the previous patch was compiled and tested extensively - over a
> several month test cycle.  However, our testing concentrates on existing
> customers and shipping distro's.  Most of those changed to the 2.6
> kernel on or before 2.4.20, so we had no 2.4 kernel in our test matrix
> beyond that. I apologize for the oversight - we must update our test
> matrix to always check out latest 2.4 development kernel.
> 
> The concerns expressed below about this driver being "blindly submitted"
> or is "untested" are completely unwarranted.

I disagree.  Your testing, while I'm sure is long drawn out and massively
complicated, is missing the crucial element of testing what you're
submitting against.  I don't think you need to check the latest bleeding
unstable kernel in your test runs, partly because it changes so fast, and
partly because you'll start to hit bugs that are unrelated to your driver.

But you absolutely must at least test compiling your driver against the
tree you submit it against, and a quick boot of the resulting kernel
wouldn't add much time to your patch submission process.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
