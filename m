From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 1 Oct 2004 17:55:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001165555.GF16153@parcelfarce.linux.theplanet.co.uk>
References: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de> <20041001162939.A4215@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:12712 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264726AbUJAQzz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 12:55:55 -0400
Content-Disposition: inline
In-Reply-To: <20041001162939.A4215@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>, linux-scsi@vger.kernel.org

On Fri, Oct 01, 2004 at 04:29:39PM +0100, Christoph Hellwig wrote:
> Given that no one except you noticed the lack of options so far what
> about moving it to normal parameters instead, aka one option per setting
> like all non-scsi and resent scsi drivers do?

I think it's definitely time to make this change.  I'll look at it later
today.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
