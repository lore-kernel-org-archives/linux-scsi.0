From: Oliver Paulus <oliver@code-project.org>
Subject: Re: Fwd: kernel oops SCSI tape drive access kernel 2.6.18
Date: Sat, 17 Feb 2007 00:24:54 +0100
Message-ID: <20070217002454.37dwagdrbiww8wcc@raudies.homeip.net>
References: <20070212204752.kkm3rcnvlk84kg4g@raudies.homeip.net>
	<Pine.LNX.4.64.0702122332530.6245@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out1.kundencontroller.de ([85.31.185.13]:33876 "EHLO
	mail-out1.kundencontroller.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946287AbXBPXdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 18:33:00 -0500
In-Reply-To: <Pine.LNX.4.64.0702122332530.6245@kai.makisara.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

> It may be a known issue. A somewhat similar oops was reported in the
> Bugzilla item 7919. See
> http://marc.theaimsgroup.com/?l=linux-scsi&m=117050154700255&w=2
> for more information and a patch. The patch is also in the current linux
> git tree.
I have compiled a new 2.6.18.5 with the patch provided in bug 7919 
(with minimal
changes). It is working now.

Seems to be the same problem in the following bug reports:
1. bug 7156
2. bug 7900

Thank you.

Oliver Paulus

