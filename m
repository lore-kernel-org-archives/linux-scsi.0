From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Wed, 14 Jan 2009 16:59:10 -0500
Message-ID: <496E602E.5050609@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2746 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZANV7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 16:59:11 -0500
In-Reply-To: <20090114213917.GB22543@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Greg KH wrote:
> I'd be interested in seeing how you propose such a change so that it
> works properly for people, because as you have noted, others have had
> this same problem.
>
> I strongly object to the use of sg_kref_get_not_zero(), as you are just
> providing a private version of this function, which you shouldn't be
> doing.
>
>   
OK, then I'll just send kref_get_not_zero() as a separate patch to
kref.c.  If there are no objections to that patch, then I'll update my
sg patch to use the new officially-blessed function.  In the meantime,
the patch I already posted should work the same way as a split patch, so
if anyone has any other objections, then let me know.

Tony
