From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 12:56:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114125648.A5811@beaverton.ibm.com>
References: <1068825146.2134.6.camel@mulgrave> <20031114092644.A2794@beaverton.ibm.com> <20031114093503.B19467@one-eyed-alien.net> <20031114095823.A3597@beaverton.ibm.com> <20031114105212.C19467@one-eyed-alien.net> <20031114120048.A4527@beaverton.ibm.com> <20031114123031.E19467@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:47547 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262788AbTKNU5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 15:57:08 -0500
Content-Disposition: inline
In-Reply-To: <20031114123031.E19467@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Fri, Nov 14, 2003 at 12:30:31PM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 14, 2003 at 12:30:31PM -0800, Matthew Dharm wrote:
> So the vendor/model blacklist completely overrides the .flags setting in
> the host template?

Correct.

> I thought the flags were just logically-or'ed

No, so entries have to include all bits needed.

Can you apply the patch, and test it out with your devices?

I'm a bit busy today. I assume test10 or 2.6.0 will show up real soon.

Thanks.

-- Patrick Mansfield
