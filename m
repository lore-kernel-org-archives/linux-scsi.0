From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Status of aic79xx driver in the linux kernel
Date: Sat, 02 May 2009 08:42:46 -0500
Message-ID: <1241271766.3639.18.camel@mulgrave.int.hansenpartnership.com>
References: <49FC3DB8.4030701@cohtech.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57927 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804AbZEBNmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 09:42:47 -0400
In-Reply-To: <49FC3DB8.4030701@cohtech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Howard Wilkinson <howard@cohtech.com>
Cc: fedora-kernel-list@redhat.com, linux-scsi@vger.kernel.org

On Sat, 2009-05-02 at 13:34 +0100, Howard Wilkinson wrote:
> I have been having some problems with an Adaptec 39320A-R card and have 
> been poking around and found that the driver in the kernel claims to be 
> derived from an Adaptec version 2.0.15 which was release in October 
> 2005! There is a later version on the Adaptec site from April 2007 - 
> 2.0.26.
> 
> I was wondering if anybody knows the actual status of the driver in the 
> kernel i.e. has it diverged so far that the Adaptec updates are moot; 
> have they already been incorporated into the kernel but the docs not 
> updated to reflect this, or ...

It has diverged quite far.  The original source of the split was
removing chunks of the BSD glue layer and converting it over to use the
SPI transport class.  Adaptec has updated it since then, notably to
support the new PCIe card.

> I ask because I am trying to decide whether to invest the time to look 
> at integrating the latest Adaptec drop to see if my problems go away.

If they're not present with the adaptec supplied driver, then yes, there
must be some fix in there that needs to be in the kernel one ... the
problem will be finding it.

James


