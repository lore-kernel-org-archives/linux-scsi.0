From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Unable to set hostid in sym53c8xx module
Date: Wed, 20 Oct 2004 12:32:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020113201.GT16153@parcelfarce.linux.theplanet.co.uk>
References: <200410200931.22069.news4reini123@aon.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10689 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270200AbUJTLcB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 07:32:01 -0400
Content-Disposition: inline
In-Reply-To: <200410200931.22069.news4reini123@aon.at>
List-Id: linux-scsi@vger.kernel.org
To: Reinhold Fischer <news4reini123@aon.at>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 20, 2004 at 09:31:22AM +0200, Reinhold Fischer wrote:
> I also filed bug 3588 (http://bugzilla.kernel.org/show_bug.cgi?id=3588), 
> but no response until now.

That's because Mike Anderson didn't reassign it to me.

> I tried to set other module parameter for debug and verbose outbut, but 
> it seems, that the module will ignore all parameters.

BTW, with the new code you'll specify it differently as:

modprobe sym53c8xx hostid=5

I've even updated the documentation to reflect this ;-)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
