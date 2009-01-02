From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: fix the return type of the remove() method in
	sgiwd93.c
Date: Fri, 02 Jan 2009 10:32:59 -0600
Message-ID: <1230913979.3304.3.camel@localhost.localdomain>
References: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
	 <1228330800.5551.58.camel@localhost.localdomain>
	 <ac3eb2510812031229l51912169o3e96346ed51c48f0@mail.gmail.com>
	 <1228337529.5551.72.camel@localhost.localdomain>
	 <ac3eb2510812031259v1a4ebe25tc841daaa2fe5a722@mail.gmail.com>
	 <1228338142.5551.77.camel@localhost.localdomain>
	 <ac3eb2510812031328x38559660rcc13db195e01ea15@mail.gmail.com>
	 <1228340025.5551.87.camel@localhost.localdomain>
	 <1228340496.6977.19.camel@nga>
	 <1230913510.3304.2.camel@localhost.localdomain>
	 <ac3eb2510901020831q5c17f38cr65fa8cb9f49bb077@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39301 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757477AbZABQdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 11:33:04 -0500
In-Reply-To: <ac3eb2510901020831q5c17f38cr65fa8cb9f49bb077@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, Greg KH <greg@kroah.com>

On Fri, 2009-01-02 at 17:31 +0100, Kay Sievers wrote:
> On Fri, Jan 2, 2009 at 17:25, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Sorry, dropped the ball a bit on this.  I've attached the updated
> > version: it copes with the legacy 20 character copy in the ioctl by
> > brute force and also adds several other dev->bus_id -> dev_name(dev)
> > conversions.
> 
> Very nice. Thanks!
> 
> Will you get that in 2.6.29 through your SCSI tree, or should the copy
> in Greg's tree be updated?

I'll send it with my next set.

James


