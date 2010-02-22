From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Mon, 22 Feb 2010 18:20:36 +0530
Message-ID: <3e7aae31002220450o6f83d2f3n45c795d70ef01f72@mail.gmail.com>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
	 <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
	 <1266508049.4355.37.camel@mulgrave.site>
	 <3e7aae31002190443w44418778u6180c74d51a0f783@mail.gmail.com>
	 <1266589605.2822.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:8584 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0BVMui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2010 07:50:38 -0500
In-Reply-To: <1266589605.2822.2.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>

On Fri, Feb 19, 2010 at 7:56 PM, James Bottomley
<James.Bottomley@suse.de> wrote:

> Before we get into that, what architecture is this? =A0There are a fe=
w,
> like arm that don't have architecture support for chaining, so they c=
an
> never go over 128 segments.

I am using the desktop PC to access my device. i.e, Intel processor
with x86 architecture.

Thanks and Regards,
RD
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
