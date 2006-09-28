From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Illustration of warning explosion silliness
Date: Thu, 28 Sep 2006 19:18:22 -0400
Message-ID: <451C583E.8090501@garzik.org>
References: <20060928005830.GA25694@havoc.gtf.org>	<20060927183507.5ef244f3.akpm@osdl.org>	<451B29FA.7020502@garzik.org> <20060927203417.f07674de.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:31376 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751027AbWI1XSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 19:18:25 -0400
In-Reply-To: <20060927203417.f07674de.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

Andrew Morton wrote:
> There, I feel better now.  If you want to see the other warnings, set
> CONFIG_ENABLE_MUST_CHECK=n.

While Googling around for Hobson's Choice[1], I realized that we are 
presented with the utterly apropos Morton's Fork:

	http://en.wikipedia.org/wiki/Morton's_Fork

With CONFIG_ENABLE_MUST_CHECK warning explosion, we must choose between 
seeing warnings in our own code, but missing __must_check bugs, and 
seeing all the __must_check bugs but obscuring our own day-to-day devel 
problems.

In the future, I would hope that it would be reasonable to merge a 
feature like this along with the cleanups that avoid a warning explosion.

	Jeff


[1] http://en.wikipedia.org/wiki/Hobson's_choice

