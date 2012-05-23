From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing
 error in ufshcd_probe.
Date: Wed, 23 May 2012 09:52:08 +0100
Message-ID: <1337763128.3098.8.camel@dabdike.int.hansenpartnership.com>
References: <1337610936-2757-1-git-send-email-linkinjeon@gmail.com>
	 <20120522131535.22992314.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50519 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab2EWIwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2012 04:52:13 -0400
In-Reply-To: <20120522131535.22992314.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, santoshsy@gmail.com, vinholikatti@gmail.com, santosh.sy@samsung.com, linux-scsi@vger.kernel.org

On Tue, 2012-05-22 at 13:15 -0700, Andrew Morton wrote:
> On Mon, 21 May 2012 10:35:36 -0400
> Namjae Jeon <linkinjeon@gmail.com> wrote:
> 
> > Subject: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.
> 
> Nit: conventionally, the text inside [] is to be discarded by the patch
> recipient, so the title of this patch is
> 
> 	ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.
> 
> which makes it look like a patch against fs/ufs/!
> 
> There is a fashion lately of people prefixing patch titles along the
> lines of
> 
>   scsi: ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.
> 
> or even
> 
>   drivers: scsi: ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.
> 
> that's nuts, and I regularly turn this into a proper pathname - why
> not?
> 
>   drivers/scsi/ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.

Because it's a question of who has to mangle the patch title.  If it's
the latter, it's me.  The [SCSI] tree tag I use implies we're in
driver/scsi, so I only add extra bits if we move outside that.

James


