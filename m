From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] fix warning and missing failure handling for scsi_add_host in aic7xxx driver
Date: Wed, 14 Dec 2005 09:37:27 +0100
Message-ID: <9a8748490512140037s32386facq15256636164e6b8f@mail.gmail.com>
References: <200512140007.20046.jesper.juhl@gmail.com>
	 <1134534839.3133.2.camel@mulgrave>
	 <9a8748490512140002s8daf671h6db51bff1c06c834@mail.gmail.com>
	 <1134548429.3262.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.194]:35530 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932111AbVLNIh2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 03:37:28 -0500
Received: by zproxy.gmail.com with SMTP id 13so53881nzp
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2005 00:37:27 -0800 (PST)
In-Reply-To: <1134548429.3262.4.camel@mulgrave>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Daniel M. Eischen" <deischen@iworks.interworks.org>, Doug Ledford <dledford@redhat.com>

On 12/14/05, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Wed, 2005-12-14 at 09:02 +0100, Jesper Juhl wrote:
> > I'll send a new patch later today when I get home from work.
>
> Actually, the aic79xx has the identical problem, if you want to fix that
> too ...
>
Sure, will do.

--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
