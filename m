From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically allocated array
Date: Mon, 13 Aug 2007 13:15:08 +0200
Message-ID: <9a8748490708130415j790d6e49y6ae12ca8dad780f2@mail.gmail.com>
References: <200708130016.11281.jesper.juhl@gmail.com>
	 <200708130021.07068.jesper.juhl@gmail.com>
	 <46C038E3.5090204@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:8262 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942565AbXHMLPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 07:15:10 -0400
Received: by wr-out-0506.google.com with SMTP id 36so151076wra
        for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2007 04:15:08 -0700 (PDT)
In-Reply-To: <46C038E3.5090204@emulex.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 13/08/07, James Smart <James.Smart@emulex.com> wrote:
> NACK
>
> The fix is contained in our 8.2.2 sources recently posted and pushed by James
> as part of his last scsi fixes.
>

I actually did look for it, but couldn't find any lpfc commits with me
listed as author, so I assumed it had not been merged.
I just looked again, at the source this time, up-to-date mainline git
tree, and I still see

        hbqno = tag >> 16;
        if (hbqno > LPFC_MAX_HBQS)
                return NULL;

in drivers/scsi/lpfc/lpfc_sli.c

???


> -- james s
>
> Jesper Juhl wrote:
> > (previously send on 09-Aug-2007 20:47)
> >
> > Hi,
> >
> > The Coverity checker noticed that we may overrun a statically allocated
> > array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().
...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
