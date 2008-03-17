From: Greg KH <greg@kroah.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sun, 16 Mar 2008 22:35:19 -0700
Message-ID: <20080317053519.GB5229@kroah.com>
References: <1205514958.2904.27.camel@localhost.localdomain> <1205529619.2904.87.camel@localhost.localdomain> <1205531922.3522.57.camel@lov.site> <1205590788.6767.12.camel@localhost.localdomain> <1205594256.3109.53.camel@lov.site> <1205597776.6767.40.camel@localhost.localdomain> <1205604260.3109.133.camel@lov.site> <47DD8139.1040802@emulex.com> <1205701470.11374.66.camel@lov.site> <47DDF05D.8060608@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33361 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYCQFaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 01:30:16 -0400
Content-Disposition: inline
In-Reply-To: <47DDF05D.8060608@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Mon, Mar 17, 2008 at 12:15:25AM -0400, James Smart wrote:
>
>
> Kay Sievers wrote:
>>> Well, the <classname> prefix came about because there was namespace 
>>> overlap
>>> between different classes (e.g. scsi_host and fc_host classes use the 
>>> same name,
>>> and I think where we originally saw this was in the way serial ports were 
>>> enumerated
>>> for some base systems as well).
>>>
>>> So I don't see how you can kill the <classname>:<devname> names by 
>>> SYSFS_DEPRECATED.
>> With SYSFS_DEPRECATED, nothing will change. But these links don't exist
>> with !SYSFS_DEPRECATED, because the class devices live in
>> subdirectories, named after the class they come from, there is no
>> namespace problem, or any problem to find these devices, you don't even
>> need readdir() to look them up.
>
> Ok, it should have read :
>   I don't see how you can kill the <classname>:<devname> names w/ 
> !SYSFS_DEPRECATED.
>
> You still haven't answered my question about namespace overlap. What 
> happens when the
> device belongs to multiple classes, and the classes have the same name for 
> the class
> device ?   I don't believe we ever want to be in the case where the classes 
> have to
> understand a global namespace.

I take it you haven't even looked at how !SYSFS_DEPRECATED works today,
have you?  Try it and you will see that the namespace issue has been
taken care of a long time ago :)

thanks,

greg k-h
