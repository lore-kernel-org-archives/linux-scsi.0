From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] fix for Domain Validation hang on some devices with sym_2driver
Date: Fri, 20 Aug 2004 17:34:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040820163438.GD14144@parcelfarce.linux.theplanet.co.uk>
References: <1092970559.1728.2520.camel@mulgrave> <1093013734.24711.202728757@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36535 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268319AbUHTQen
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 12:34:43 -0400
Content-Disposition: inline
In-Reply-To: <1093013734.24711.202728757@webmail.messagingengine.com>
List-Id: linux-scsi@vger.kernel.org
To: Kai OM <epimetreus@fastmail.fm>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 20, 2004 at 10:55:34AM -0400, Kai OM wrote:
> So, um, what I want to know is... why did the issue appear to go away
> for some people if they switched controllers?

Well, the 896 only does 80MB/s rather than 160MB/s, so it won't trigger
the bug where the 1010 will.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
