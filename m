From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH] SCSI: fix the return type of the remove() method in sgiwd93.c
Date: Fri, 2 Jan 2009 17:31:02 +0100
Message-ID: <ac3eb2510901020831q5c17f38cr65fa8cb9f49bb077@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38415 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZABQbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 11:31:05 -0500
Received: by ewy10 with SMTP id 10so6815363ewy.13
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jan 2009 08:31:02 -0800 (PST)
In-Reply-To: <1230913510.3304.2.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, Greg KH <greg@kroah.com>

On Fri, Jan 2, 2009 at 17:25, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Sorry, dropped the ball a bit on this.  I've attached the updated
> version: it copes with the legacy 20 character copy in the ioctl by
> brute force and also adds several other dev->bus_id -> dev_name(dev)
> conversions.

Very nice. Thanks!

Will you get that in 2.6.29 through your SCSI tree, or should the copy
in Greg's tree be updated?

Thanks,
Kay
