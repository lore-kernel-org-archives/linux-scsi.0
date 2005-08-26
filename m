From: Andrew Morton <akpm@osdl.org>
Subject: Re: regression w/ qla2300 - oopses..
Date: Fri, 26 Aug 2005 14:52:39 -0700
Message-ID: <20050826145239.6032a509.akpm@osdl.org>
References: <20050826212934.GO22165@mea-ext.zmailer.org>
	<1125092648.5079.110.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:8078 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751338AbVHZVyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:54:13 -0400
In-Reply-To: <1125092648.5079.110.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: matti.aarnio@zmailer.org, linux-scsi@vger.kernel.org, greg@kroah.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> This is known and fixed here:
> 
>  http://marc.theaimsgroup.com/?l=linux-scsi&m=112485448830217
> 
>  Andrew and Greg, could we look at actually getting this fix in too,
>  please?

yowch, that's fairly non-trivial.    And Greg didn't comment.

Is there not some nasty little hack we can do to make the crash go away in
the interim?
