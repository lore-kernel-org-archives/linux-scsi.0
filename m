From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] adding per scsi-host workqueues for defered processing
Date: Tue, 22 Feb 2005 01:05:15 +0000
Message-ID: <20050222010515.GJ28741@parcelfarce.linux.theplanet.co.uk>
References: <20050222000937.GA7338@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31667 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262187AbVBVBFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 20:05:22 -0500
Content-Disposition: inline
In-Reply-To: <20050222000937.GA7338@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 21, 2005 at 04:09:37PM -0800, Andrew Vasquez wrote:
> * must be done from process context -- depending on transport type,
>   discovery can occur from a non-process context
> * potentially _long_ scan times -- even if discovery is done from a
>   'sleeping' capable context, halting a LLDD for discovery purposes
>   is typically undesirable.
> 
> I'd like to propose the addition of a per-Scsi_Host work-queue to
> manage these scanning as well as any other (relevant)
> lower-level-driver differed requests.

Why not use the per-host error handler thread for this?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
