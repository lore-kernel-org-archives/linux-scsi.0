From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aeventd logging application (Part 1)
Date: Fri, 13 Feb 2004 17:40:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:9097 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267261AbUBMWkq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 17:40:46 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Excuse my (faked?) ignorance; I would like a good place to put this :-)
Any suggestions on a suitable release mechanism?

I will accept `on Adaptec media' ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Friday, February 13, 2004 5:05 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] aeventd logging application (Part 1)

On Fri, 2004-02-13 at 16:48, Salyzyn, Mark wrote:
> I expect this to be rejected for inclusion to the kernel source tree
...
> in that case the patch may just be done standalone (patch -p5).

Well, I can satisfy your expectation on that score ;-)

The rule is no user level tools at all in the kernel that aren't
necessary for the kernel compile, no matter how closely they're tied to
the kernel's operation.  Even things like udev don't get to go into the
kernel sources.

James


