From: Matthew Wilcox <willy@debian.org>
Subject: Re: sym2 probs in bk-scsi tree
Date: Thu, 8 Apr 2004 16:40:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408154045.GD18329@parcelfarce.linux.theplanet.co.uk>
References: <20040407231820.66dd76cd.akpm@osdl.org> <20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk> <40756CB3.5010902@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28371 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261899AbUDHPkq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 11:40:46 -0400
Content-Disposition: inline
In-Reply-To: <40756CB3.5010902@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Matthew Wilcox <willy@debian.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Thu, Apr 08, 2004 at 10:16:03AM -0500, Brian King wrote:
> >They certainly are scary.  What is device 15 on this scsi bus?  This
> >looks like domain validation being applied to a device that can't do it
> >to me.  Did I get that right, James?
> 
> Looks like a SES to me. Would it make sense to not log errors during 
> domain validation?

I was thinking more about disabling domain validation towards these
kinds of devices ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
