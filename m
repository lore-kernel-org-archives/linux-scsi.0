From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Unable to set hostid in sym53c8xx module
Date: Wed, 20 Oct 2004 12:22:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020112229.GS16153@parcelfarce.linux.theplanet.co.uk>
References: <7AAD212492598A4A92463C3F5D34C54F19512B@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32958 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269917AbUJTLWg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 07:22:36 -0400
Content-Disposition: inline
In-Reply-To: <7AAD212492598A4A92463C3F5D34C54F19512B@ccd3.CC.de>
List-Id: linux-scsi@vger.kernel.org
To: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Cc: Reinhold Fischer <news4reini123@aon.at>, linux-scsi@vger.kernel.org

On Wed, Oct 20, 2004 at 11:01:00AM +0200, Heinzmann, Robert wrote:
> Reinhold, 
> 
> > Do you know, if it is fixed in 2.6.9?
> I'm not shure, probably not (there where some other fixes too). Afaik
> 2.6.10 will include a fixed sym2 driver
> (http://marc.theaimsgroup.com/?l=linux-scsi&m=109742499223501&w=2).
> Maybe the fix in the thread mentioned in the last mail helps (just as a
> workaround). It worked for me.

It is not fixed in 2.6.9.  The 2.1.18m not-yet-released version of the
driver switches to the new module_param method of specifying parameters,
I'll send that out soonish.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
