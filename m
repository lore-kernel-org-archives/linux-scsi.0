From: Matthew Wilcox <willy@debian.org>
Subject: Re: [2.4.25], [aic79xx-2.0.8] problems with aic79xx on 2.4 (fwd)
Date: Fri, 2 Apr 2004 15:13:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040402141356.GJ16469@parcelfarce.linux.theplanet.co.uk>
References: <Pine.GSO.4.53.0404011838350.19252@compserv1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63213 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262635AbUDBOOA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 09:14:00 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.53.0404011838350.19252@compserv1>
List-Id: linux-scsi@vger.kernel.org
To: Abhishek Rai <abba@cs.sunysb.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Apr 01, 2004 at 06:41:47PM -0500, Abhishek Rai wrote:
> I have an Adaptec 29320A Ultra320 SCSI host bus adapter with which I
> connect to a SCSI array of 9 disks, each of which is capable of 320MBps.
> Initially, in the BIOS settings, I configure each disk to operate at
> 160MBps. aic79xx-2.0.8 driver for 2.4 works just fine on 2.4.25 with this
> setting. I am able to create a raid device on top of this 9-disk array,
> and everything works fine.
> 
> Now, I configure each disk in the BIOS settings to operate at 320MBps. I
> now start having trouble beginning with aic79xx module insertion itself.

Are you sure your cables are within spec (length and quality) for
320MB/s operation?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
