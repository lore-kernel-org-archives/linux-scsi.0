From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: REGRESSION in 2.6.13-rc1: Massive slowdown with Adaptec SCSI
Date: Tue, 5 Jul 2005 02:21:41 +0100
Message-ID: <20050705012141.GB9312@parcelfarce.linux.theplanet.co.uk>
References: <17097.56705.490622.759154@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:19124 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261746AbVGEBUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2005 21:20:01 -0400
Content-Disposition: inline
In-Reply-To: <17097.56705.490622.759154@cse.unsw.edu.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 05, 2005 at 11:08:17AM +1000, Neil Brown wrote:
>  On 2.6.13-rc1 the same test takes just short on 1 minute and reports
>  slightly less than 2 M/Second.

That sounds like your drives have negotiated an asynchronous transfer
agreement.  Could you provide your dmesg to confirm that diagnosis?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
