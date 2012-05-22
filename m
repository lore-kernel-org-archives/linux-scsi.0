From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing
 error in ufshcd_probe.
Date: Tue, 22 May 2012 13:15:35 -0700
Message-ID: <20120522131535.22992314.akpm@linux-foundation.org>
References: <1337610936-2757-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2EVUPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 16:15:36 -0400
In-Reply-To: <1337610936-2757-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: santoshsy@gmail.com, vinholikatti@gmail.com, santosh.sy@samsung.com, James.Bottomley@HansenPartnership.com, jBottomley@parallels.com, linux-scsi@vger.kernel.org

On Mon, 21 May 2012 10:35:36 -0400
Namjae Jeon <linkinjeon@gmail.com> wrote:

> Subject: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.

Nit: conventionally, the text inside [] is to be discarded by the patch
recipient, so the title of this patch is

	ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.

which makes it look like a patch against fs/ufs/!

There is a fashion lately of people prefixing patch titles along the
lines of

  scsi: ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.

or even

  drivers: scsi: ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.

that's nuts, and I regularly turn this into a proper pathname - why
not?

  drivers/scsi/ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.


I'll stop now :)
