From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Sat, 13 Nov 2010 00:26:49 -0500
Message-ID: <4CDE2199.7080309@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113042821.GE18258@parisc-linux.org> <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0KMF0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Nov 2010 00:26:53 -0500
In-Reply-To: <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 11/12/2010 11:42 PM, Linus Torvalds wrote:
> Having to inevitably do that silly double dereference
> ("cmd->device->host") seems bogus. Passing in the host you want to
> queue something on seems to be natural, and avoids that nasty chain of
> dereferences, so it really should improve the code.

As noted in the patch v4, just sent, I agree.


> So the shost pointer is certainly a lot more useful than the 'done'
> function pointer.  So yeah, I'd switch them around - pass the 'done'
> thing indirectly, and the shost directly.

You bozos would come up with this the _minute_ I sent my patch, eh?  :)

IMO, the 'done' removal should be in a separate patch from the host lock 
push-down.

It should be straightforward, if applied immediately following the 
push-down patch.  bisect remains clean.

	Jeff


