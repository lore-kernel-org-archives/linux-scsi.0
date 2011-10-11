From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mv_sas: OCZ RevoDrive3 & zDrive R4 support
Date: Tue, 11 Oct 2011 15:57:43 -0500
Message-ID: <1318366663.2992.29.camel@dabdike.int.hansenpartnership.com>
References: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
	 <1318132024-12426-1-git-send-email-robbat2@gentoo.org>
	 <robbat2-20111011T204841-021218330Z@orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34724 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039Ab1JKU5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2011 16:57:46 -0400
In-Reply-To: <robbat2-20111011T204841-021218330Z@orbis-terrarum.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Tue, 2011-10-11 at 20:50 +0000, Robin H. Johnson wrote:
> On Sat, Oct 08, 2011 at 08:47:04PM -0700, Robin H. Johnson wrote:
> > From: "Robin H. Johnson" <robbat2@gentoo.org>
> > 
> > In the OCZ RevoDrive3/zDrive R4 series, the "OCZ SuperScale Storage
> > Controller" with "Virtualized Controller Architecture 2.0" really seems
> > to be a Marvell 88SE9485 part, with OCZ firmware/BIOS.
> > 
> > Developed and tested on OCZ RevoDrive3 120GB [PCI 1b85:1021]
> 
> Is there anything blocking getting this ack'd or applied to the SCSI
> tree? I've seen no comments from the lists.
> 
> I've also posted it on the OCZ Forums, and gotten some users confirming
> it works there.

Well, when you put things like

"NOT FOR COMMIT USE; TESTING ONLY; NO WARRANTY; DANGER!"

and

"I constructed this patch for my friend to test, completely blind.
I haven't heard back from him at all yet, but I thought that the wider
community might find it useful for testing as well. I think it _should_
work, just need to figure out what the correct chip variant is."

On the patch it tends to make maintainers exercise extreme caution.
Thus comments from others (preferably successful test reports) or acks
from Marvell or Vertex would be very helpful.

James



