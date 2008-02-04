From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 09:30:15 -0600
Message-ID: <1202139015.3096.5.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37468 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbYBDPaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 10:30:21 -0500
In-Reply-To: <47A7049A.9000105@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 15:27 +0300, Vladislav Bolkhovitin wrote:
> Vladislav Bolkhovitin wrote:
> So, James, what is your opinion on the above? Or the overall SCSI target 
> project simplicity doesn't matter much for you and you think it's fine 
> to duplicate Linux page cache in the user space to keep the in-kernel 
> part of the project as small as possible?

The answers were pretty much contained here

http://marc.info/?l=linux-scsi&m=120164008302435

and here:

http://marc.info/?l=linux-scsi&m=120171067107293

Weren't they?

James


