From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Mon, 13 Jun 2016 22:51:24 -0700
Message-ID: <CA+55aFypwCYAno1VJ5PMm8REHeq4tLpjJ4ECx5=tSLb3xWyK2Q@mail.gmail.com>
References: <1465668572.2364.26.camel@HansenPartnership.com>
 <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
 <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com>
 <1465674067.2364.43.camel@HansenPartnership.com> <CA+55aFw5xsPx0r01Z5aKXn6UbHLhGbXoa0qyGVJbfWiC7yq1WA@mail.gmail.com>
 <1465679005.2364.75.camel@HansenPartnership.com> <575E5B14.7020308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36257 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbcFNFvZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 01:51:25 -0400
In-Reply-To: <575E5B14.7020308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Jun 13, 2016 at 12:04 AM, Hannes Reinecke <hare@suse.de> wrote:
>
> And we have been running the very patch in SLES for over a year now,
> without a single issue being reported.

Oh, ok. So it's not "all qemu kvm instances are broken", it was a very
unusual issue, and the patch has actually gotten wider testing.

That makes me much happier about it.

            Linus
