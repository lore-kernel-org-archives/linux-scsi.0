From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 19:29:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601182922.GR5850@parcelfarce.linux.theplanet.co.uk>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD513D@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:25573 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265114AbUFAS3X
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 14:29:23 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD513D@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andi Kleen <ak@muc.de>, linux-scsi@vger.kernel.org

On Tue, Jun 01, 2004 at 02:27:44PM -0400, Salyzyn, Mark wrote:
> It's not the driver that needs to know, it's an information box on the
> RAID applications that need to know via a management ioctl (see the
> public domain raidutil tool for the cli variant). It's the `dptsig' tool
> that reads the binary and provides version and processor type the binary
> is compiled for.

Why can't it get this information via uname?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
