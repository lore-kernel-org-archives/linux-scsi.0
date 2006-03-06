From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Mon, 06 Mar 2006 13:50:28 -0600
Message-ID: <1141674628.3167.31.camel@mulgrave.il.steeleye.com>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
	 <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
	 <20060306193555.GA2316@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49613 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751579AbWCFTub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 14:50:31 -0500
In-Reply-To: <20060306193555.GA2316@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

On Mon, 2006-03-06 at 11:35 -0800, Mike Anderson wrote:
> > 99% is good enough for me currently. 
> 
> Can you clarify this? Are you indicating that the 99% is only ok for debug
> purposes or as a permanent solution. It would seem that if I want my system
> to always boot that I would need to utilize an initramfs solution on top
> of the driver solution.

It means I'll fix races in discovery, but the actual problem of the root
device being discovered after port discovery completes because of some
type of disk or cabling issue is beyond this type of fix.  I also have
to bet that expander configurations can get a bit random in who is
discovered first, so likewise, the full fix for those will be udev
updates.

> Alexis already created a patch that has some pieces in common with the
> older adp driver to try and sync discovery, but we did not post as it was
> failing on a x260 which has an expander configuration. Currently I believe
> she is trying to port this to your patch series. Is this effort worth
> continuing?

I can't say until I see the code.  However, if it's just fixing races,
then yes.  If it's trying to make the driver reorder or wait for a
preferred root disk, then probably not.

James


