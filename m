From: Matthew Wilcox <willy@debian.org>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take 2
Date: Mon, 6 Sep 2004 17:33:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906163336.GE642@parcelfarce.linux.theplanet.co.uk>
References: <413557CB.8010008@cs.wisc.edu> <20040901162042.GC26753@null.msp.redhat.com> <20040906143251.GB21646@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63687 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268136AbUIFQdh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2004 12:33:37 -0400
Content-Disposition: inline
In-Reply-To: <20040906143251.GB21646@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

On Mon, Sep 06, 2004 at 04:32:51PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 01, 2004 at 11:20:42AM -0500, AJ Lewis wrote:
> > Do we want all these attributes in the scsi_host class, or should we put them
> > in the iscsi devices directory?  So in /sys/bus/iscsi-sfnet/devices/iscsi1 -

Woah, woah, woah.  What's this "iscsi-sfnet" directory in sysfs?  That's
just wrong.  No way is that crap going into the kernel.  We have to have
*one* iscsi infrastructure, not a dozen.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
