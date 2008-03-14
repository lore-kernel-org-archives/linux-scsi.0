From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Fri, 14 Mar 2008 12:15:58 -0500
Message-ID: <1205514958.2904.27.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49456 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbYCNRQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 13:16:03 -0400
In-Reply-To: <20080313210655.GA13468@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>

On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> Here's a huge patch from Tony and Kay that converts the scsi layer to
> use struct device instead of class_device.
> 
> It doesn't seem like it could be split up any smaller due to the
> interconectedness of the whole mess, if you have any suggestions
> otherwise, it would be appreciated.
> 
> If you want, I can take this through my tree as it does depend on a
> previous IB patch to make that portion of the patch much smaller.
> 
> After this, all of the class_device code is now finally gone from the
> kernel!

Actually, I have it built and running (actually 2.6.25-rc5-mc5 which
includes all the changes in your tree).  Amazingly it's pretty much
fully functional, except ses which seems to have suffered a breakdown in
the way its model works.  I'll see if I can fix it up.

Since the patch is separable, it's probably best to take it through the
SCSI tree ... including the infiniband bits that depend on the
iser/iscsi transport classes.  You can give the rest of the infiniband
pieces to roland, since he's got a nasty set of clashes with the
__FUNCTION__->__func__ conversion which I don't want to be responsible
for.

James


