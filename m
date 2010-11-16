From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Tue, 16 Nov 2010 02:08:33 -0500
Message-ID: <4CE22DF1.3020902@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113042821.GE18258@parisc-linux.org> <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com> <1289628103.3015.608.camel@mulgrave.site> <4CE22B55.6000404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42854 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab0KPHIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 02:08:37 -0500
In-Reply-To: <4CE22B55.6000404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 11/16/2010 01:57 AM, Jeff Garzik wrote:
> It is basically your incremental patch + fas216 deadlock fix + several
> more prototype fixes.

oh and removed some dead code from atari_scsi that became 
dead-and-incorrect code.

