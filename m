From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] put symbolic links between drivers and modules in the	sysfs tree
Date: Sun, 26 Sep 2004 20:37:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CBWOq-0007t6-00@gondolin.me.apana.org.au>
References: <1096118081.1715.3.camel@mulgrave>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arnor.apana.org.au ([203.14.152.115]:53253 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S269503AbUIZKhq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Sep 2004 06:37:46 -0400
In-Reply-To: <1096118081.1715.3.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: viro@parcelfarce.linux.theplanet.co.uk, greg@kroah.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@steeleye.com> wrote:
>
>> So what will your userland code do when you run it on a system with
>> non-modular kernel currently running?
> 
> Not put a module in the initial ramdisk, since it would be unnecessary. 
> The only information the patch seeks to add is the linkage between
> driver and module.  So you can work back from sysfs to know which
> devices have which modules

You're assuming that the kernel before/after the reboot have the same
configuration.  This is false in general.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
