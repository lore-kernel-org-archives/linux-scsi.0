From: Matthew Wilcox <willy@debian.org>
Subject: Re: [SUBJECT CHANGE]: megaraid unified driver version 2.20.0.0-alpha1
Date: Wed, 25 Feb 2004 17:35:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225173540.GB25779@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC3E2@exa-atlanta.se.lsil.com> <20040225131640.A3966@infradead.org> <20040225112839.A14838@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30394 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261475AbUBYRfn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 12:35:43 -0500
Content-Disposition: inline
In-Reply-To: <20040225112839.A14838@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>, 'Arjan van de Ven' <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Feb 25, 2004 at 11:28:39AM -0600, Matt Domsch wrote:
> The list of PCI devices should be ordered in two buckets: ROMBs first,
> then add in cards; secondarily, oldest to newest.  We do this with
> aacraid today.

In 2.4, you can do what you like.  The list of PCI devices is in PCI
bus number order, and that's the order you get when you use the hotplug
interfaces.  Yes, this is a painful customer-visible change, but if
they use scsi discs, they must already be used to devices changing name
at random.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
