From: Matthew Wilcox <willy@debian.org>
Subject: Re: [RFC] exposing the sdev_target in sysfs
Date: Mon, 6 Sep 2004 02:58:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906015836.GX642@parcelfarce.linux.theplanet.co.uk>
References: <1094254851.1712.28.camel@mulgrave> <41394901.3050804@us.ibm.com> <1094306082.1924.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31723 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267393AbUIFB6k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2004 21:58:40 -0400
Content-Disposition: inline
In-Reply-To: <1094306082.1924.0.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <mikenc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Sep 04, 2004 at 09:54:40AM -0400, James Bottomley wrote:
> On Sat, 2004-09-04 at 00:48, Mike Christie wrote:
> > device_add calls kobject_add which can sleep.
> 
> Yes, I'll move it outside the lock.
> 
> I suppose I should add a comment somewhere about our critical dependence
> on sequential LUN scanning as well just in case someone tries to
> parallelise it.

sequential on a given bus, rather than globally, right?  There's no
problem with scanning different busses simultanously, is there?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
