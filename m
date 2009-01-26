From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Spamming linux-kernel and linux-scsi by out-of-tree patches
	(LIO)
Date: Mon, 26 Jan 2009 09:37:14 -0600
Message-ID: <1232984234.3248.18.camel@localhost.localdomain>
References: <497DB7D0.8000302@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42616 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbZAZPhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 10:37:17 -0500
In-Reply-To: <497DB7D0.8000302@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2009-01-26 at 16:17 +0300, Vladislav Bolkhovitin wrote:
> Nicholas,
> 
> Could you stop spamming linux-kernel and linux-scsi mailing lists by 
> patches for your out-of-tree LIO project, please?
> 
> Those mailing lists are intended for patches for in-kernel components 
> only, not for all out-of-tree projects, finding their ways into the 
> mainline. I don't see any reason why your project should be an 
> exception. Think, what a mess the kernel mailing lists would get, if all 
> out-of-tree projects started sending their patches to them?

Actually, out of tree projects trying to make their way upstream are
welcome to use the various linux- mailing lists to solicit feedback and
review.  This method was, for instance, how FCoE made it in.

> My personal practical concerns about your patches that they trigger my 
> e-mail filters, so I have to spend on them much more time than I would want.

I've found that spamassassin does a good job of marking patches as non
spam.  Also, if you're using zmailer, vger seems to have some type of
patch recognition system built in which might be worth co-opting.

James


