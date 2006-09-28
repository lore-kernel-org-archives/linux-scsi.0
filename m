From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Illustration of warning explosion silliness
Date: Thu, 28 Sep 2006 00:42:24 -0400
Message-ID: <451B52B0.1090801@garzik.org>
References: <20060928005830.GA25694@havoc.gtf.org>	<20060927183507.5ef244f3.akpm@osdl.org>	<451B29FA.7020502@garzik.org>	<20060927203417.f07674de.akpm@osdl.org>	<451B4D58.9070401@garzik.org> <20060927213628.ef12b1ed.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:3543 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751373AbWI1Emh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 00:42:37 -0400
In-Reply-To: <20060927213628.ef12b1ed.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

Andrew Morton wrote:
>> You're ignoring the API issue at hand.  Let me say it again for the 
>> cheap seats:  "search"  You search a list, and stick a pointer somewhere 
>> when found.  No hardware touched.  No allocations.  Real world.  There 
>> is an example of usage in the kernel today.
> 
> If it's called in that fashion then the caller should still check the
> device_for_each_child() return value to find out if it actually got a
> match.


Or in the case of scsi_sysfs.c, it simply <does something>.

Oh well, whatever.  This thing introduces endless build noise we won't 
kill for years, making it much harder to spot much more serious stuff.

	Jeff


