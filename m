From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] aeventd logging application (Part 1)
Date: 13 Feb 2004 17:04:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076709884.2159.415.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552AD@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:9904 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267200AbUBMWEv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 17:04:51 -0500
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552AD@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2004-02-13 at 16:48, Salyzyn, Mark wrote:
> I expect this to be rejected for inclusion to the kernel source tree ...
> in that case the patch may just be done standalone (patch -p5).

Well, I can satisfy your expectation on that score ;-)

The rule is no user level tools at all in the kernel that aren't
necessary for the kernel compile, no matter how closely they're tied to
the kernel's operation.  Even things like udev don't get to go into the
kernel sources.

James


