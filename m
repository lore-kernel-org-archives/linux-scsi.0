From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 5/7] scsi/zalon: Added KERN macro to printk()
Date: Wed, 12 Jan 2005 01:39:18 +0000
Message-ID: <20050112013918.GW27371@parcelfarce.linux.theplanet.co.uk>
References: <20050111232300.DED921F225@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21475 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262983AbVALBjU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 20:39:20 -0500
Content-Disposition: inline
In-Reply-To: <20050111232300.DED921F225@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, am@misk.net

On Wed, Jan 12, 2005 at 12:23:00AM +0100, domen@coderock.org wrote:
> I have added a KERN macro to a printk() function as requested in the Kernel
> Janitor's TODO list.

I'll merge this one through the PA-RISC tree; I've actually changed this
line already, but will add the KERN_ prefix.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
