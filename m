From: "Matthew Jacob" <lydianconcepts@gmail.com>
Subject: Re: Target mode support for qlogic chipsets isp2422/2432/5422/5432
Date: Tue, 23 Oct 2007 22:12:16 -0700
Message-ID: <7579f7fb0710232212l57566957l82fb1d6f0e93af01@mail.gmail.com>
References: <3b8510d80710230117l269c6356uff350caeb1ee0e31@mail.gmail.com>
	 <471DDA99.5050309@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:47378 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbXJXFMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 01:12:17 -0400
Received: by rv-out-0910.google.com with SMTP id k20so75798rvb
        for <linux-scsi@vger.kernel.org>; Tue, 23 Oct 2007 22:12:16 -0700 (PDT)
In-Reply-To: <471DDA99.5050309@qlogic.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: Thayumanavar Sachithanantham <thayumk@gmail.com>, linux-scsi@vger.kernel.org, FUJITA Tomonori <tomof@acm.org>

Hey- this is great stuff. This means I can finally give up on my stuff
for linux now that there's some better and more integral stuff in
place. Woo Hoo!

On 10/23/07, Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> Thayumanavar Sachithanantham wrote:
> > Hi All,
> >
> > Does the recent target mode support added for tgt support target mode
> > for qla chipset (qla24xx series)?
> I'm in the middle of adding the target mode support for qla24xx and newer series on top of the recent target mode patch (submitted by Tomonori).
> As an estimate, the patch will be submitted within a couple of weeks.
>
> > Can anyone say what isp chipset qla2462 belong to? ( i don't have 2462
> > with this and i need this info if possible).
> The QLA2462 has a ISP2422.
>
> Thank you,
> Seokmann
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
