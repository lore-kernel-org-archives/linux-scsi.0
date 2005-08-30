From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] fix compiler warning in aic7770
Date: Tue, 30 Aug 2005 17:47:07 +0200
Message-ID: <9a8748490508300847422b901f@mail.gmail.com>
References: <200508300115.47618.jesper.juhl@gmail.com>
	 <20050830145157.GB3708@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.198]:31183 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751441AbVH3PrP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 11:47:15 -0400
Received: by zproxy.gmail.com with SMTP id i11so750074nzh
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 08:47:07 -0700 (PDT)
In-Reply-To: <20050830145157.GB3708@stusta.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On 8/30/05, Adrian Bunk <bunk@stusta.de> wrote:
> On Tue, Aug 30, 2005 at 01:15:36AM +0200, Jesper Juhl wrote:
> 
> > Fix compiler warning in drivers/scsi/aic7xxx/aic7770.c :
> >    drivers/scsi/aic7xxx/aic7770.c:129: warning: unused variable `l'
> >...
> 
> This patch is already in 2.6.13-rc6-mm2 (through the scsi-misc-2.6.git
> tree).
> 
Ok, I only checked 2.6.13. 
Thank you for the feedback.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
