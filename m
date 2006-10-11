From: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Subject: Re: megaraid not working in 2.6.18
Date: Wed, 11 Oct 2006 08:57:43 +0200
Message-ID: <20061011065742.GE905@digitus>
References: <890BF3111FB9484E9526987D912B261932E3CE@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jugis.itk.ppke.hu ([193.225.109.42]:15338 "EHLO
	jugis.itk.ppke.hu") by vger.kernel.org with ESMTP id S932137AbWJKG5t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 02:57:49 -0400
Content-Disposition: inline
In-Reply-To: <890BF3111FB9484E9526987D912B261932E3CE@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: linux-scsi@vger.kernel.org

On 10/10, Ju, Seokmann wrote:
>  
> Hi,
> > However the legacy megaraid drivers does not work either. I get
> > unknown-block-device error when the kernel tries to mount sdaX.
> > I do not even see the megaraid driver coming up! no detecting 
> > messages like
> > in 2.6.11
> From 2.6.13 or later, old megaraid controllers, like yours, has to go with megaraid legacy driver.
> I'm not sure why the driver gets failed to load. 
> For further assist, please contact LSI customer service if you bought directly from LSI, or contact your system maker.
> 
> Thank you,

Well that's an old (legacy? ;-) server we do not want to throw out. The
vendor is HP. We do not have support for linux AFAIK we never had.

I will start examining the source (and the patches after 2.6.13) if I
can see some obvious...

But if you have any hints please tell me.

Thanks.

-- 
"If you have an apple and I have  an apple and we  exchange apples then you
and I will still each have  one apple. But  if you have an idea and I have
an idea and we exchange these ideas, then each of us will have two ideas."
                 -- George Bernard Shaw

CSILLAG Tamas (cstamas) - http://digitus.itk.ppke.hu/~cstamas
