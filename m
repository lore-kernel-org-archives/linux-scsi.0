From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Mon, 29 Oct 2007 13:12:33 -0500
Message-ID: <1193681553.3383.102.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <47261F50.3050901@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40613 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755178AbXJ2SMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 14:12:35 -0400
In-Reply-To: <47261F50.3050901@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2007-10-29 at 18:58 +0100, Stefan Richter wrote:
> James Bottomley wrote:
> >> >  struct attribute_group {
> >> >  	const char		*name;
> >> > +	int			(*filter_show)(struct kobject *, int);
> 
> > Actually, it returns a true/false value indicating whether the given
> > attribute should be displayed.
> 
> How about this:
> 
> 	int (*is_visible)(...);
> or
> 	bool (*shall_be_shown)(...);
> or
> 	bool (*should_be_displayed)(...);
> 
> or whatever, so that it indicates that this function merely answers a
> question, but doesn't filter nor show anything.

Actually, as long as it's descriptive, I really don't care about the
name.  Can we all agree on "is_visible"?

James


