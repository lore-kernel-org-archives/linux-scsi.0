From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 22/82] remove linux/version.h from drivers/message/fus ion
Date: Wed, 20 Jul 2005 13:48:00 +0100
Message-ID: <20050720124800.GM10156@parcelfarce.linux.theplanet.co.uk>
References: <91888D455306F94EBD4D168954A9457C03281EB4@nacos172.co.lsil.com> <20050720031249.GA18042@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23211 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261179AbVGTMqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2005 08:46:03 -0400
Content-Disposition: inline
In-Reply-To: <20050720031249.GA18042@humbolt.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Tue, Jul 19, 2005 at 10:12:49PM -0500, Matt Domsch wrote:
> > What you illustrated above is not going to work.
> > If your doing #ifndef around a function, such as scsi_device_online, it's
> > not going to compile
> > when scsi_device_online is already implemented in the kernel tree.
> > The routine scsi_device_online is a function, not a define.  For a define
> > this would work.
> 
> Sure it does, function names are defined symbols.

uh, not to the preprocessor, they aren't.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
