From: "Allexio Ju" <allexio.ju@gmail.com>
Subject: Re: [PATCH] aacraid: Add likely() and unlikely()
Date: Wed, 28 Mar 2007 08:53:40 -0700
Message-ID: <a02278b00703280853o6984e502nd7ec1e6fe04561b8@mail.gmail.com>
References: <a02278b00703270917w5dcaaf25y92e31dfd6e920b91@mail.gmail.com>
	 <1175087859.6469.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:16000 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbXC1Pxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 11:53:41 -0400
Received: by an-out-0708.google.com with SMTP id b33so3113467ana
        for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 08:53:40 -0700 (PDT)
In-Reply-To: <1175087859.6469.17.camel@laptopd505.fenrus.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: mark_salyzyn@adaptec.com, linux-scsi@vger.kernel.org

On 3/28/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 2007-03-27 at 09:17 -0700, Allexio Ju wrote:
> > I thought those macros simply tell compiler to layout code in such a
> > way that minimizes unnecessary jumps.
> it's more than that. it generally also tells the processor what the
> branch will be, at which point most processors disable their own branch
> prediction logic. Trying to hand-layout code is almost always a
> mistake... don't do that. GCC also is quite good at recognizing certain
> patterns to keep the code flow working. Trying to override that only
> hurts...
I see... thanks for clarification.

allexio
