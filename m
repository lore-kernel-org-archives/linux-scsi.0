From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/6] scsi: fix a header to include linux/types.h
Date: Tue, 10 Jan 2012 16:08:20 -0800
Message-ID: <20120110160820.668cc440.akpm@linux-foundation.org>
References: <20120110234227.E28795C013D@hpza9.eem.corp.google.com>
	<1326240168.3264.88.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2AKAIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 19:08:21 -0500
In-Reply-To: <1326240168.3264.88.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, virtuoso@slind.org

On Tue, 10 Jan 2012 19:02:48 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2012-01-10 at 15:42 -0800, akpm@linux-foundation.org wrote:
> > From: Alexander Shishkin <virtuoso@slind.org>
> > Subject: scsi: fix a header to include linux/types.h
> > 
> > For headers that get exported to userland and make use of u32 style
> > type names, it is advised to include linux/types.h.
> > 
> > This fixes a headers_check warning.
> 
> Well, this patch isn't correct as I've said several times

You didn't reply to Alexander's initial email, nor to my May and
November resends of this patch.

> The warning was finally fixed by this patch instead:

OK, thanks, I'll drop the patch.

