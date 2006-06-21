From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 13:47:39 -0400
Message-ID: <20060621174739.GN31472@vienna.egenera.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:15553 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751046AbWFURuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 13:50:07 -0400
Content-Disposition: inline
In-Reply-To: <20060621165057.GW1630@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, linux-scsi@vger.kernel.org

Rumor has it that on Wed, Jun 21, 2006 at 10:50:57AM -0600 Matthew Wilcox said:
> On Wed, Jun 21, 2006 at 12:41:50PM -0400, Philip R. Auld wrote:
> > >     scsi 2:0:1:0: Device: DASD HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 02
> > 
> > Parsing this, (and the Matt's earlier version), there are 5 tokens
> > there in the middle for 4 fields. How does one know what the vendor
> > string is for example?
> 
> 1) This is not for parsing, it's informational for users.  Do tools
> really still parse through /var/log/dmesg?
> 

You don't read var/log/dmesgs when you are looking at a scsi issue?
I really meant eye ball parsing mostly.


> 2) This information is available other ways, such as through sysfs and
> procfs.

Why put it here at all then? ;)

> 
> 3) I know it's not obvious from the above example (damn HP firmware),
> but these are actually fixed-size fields.  The first is 8 bytes, "HP 18.2G"
> the second 16 bytes are "ATLAS10K3_18_SCA", the third is "HP05" and then
> the ANSI ver is at the end.

I know they're fixed size fields. I'm not good at counting spaces 
that's why I offered the suggestion of some sort of field sep character.

I wouldn't have thought about it if you didn't use an example with
white spaces :)


Cheers,

Phil


-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
