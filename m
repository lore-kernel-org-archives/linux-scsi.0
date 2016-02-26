From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] sd: disable write same for SAT as per the comment
Date: Fri, 26 Feb 2016 12:57:30 -0800
Message-ID: <1456520250.2369.45.camel@HansenPartnership.com>
References: <56d0b08c.e99c420a.dbca1.0415@mx.google.com>
	 <1456517794.2369.43.camel@HansenPartnership.com>
	 <CAGnHSE=8d2=b3nN=0f14t_5Nf_GLsb0HXYeajZtz5As8SophsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42666 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178AbcBZU5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2016 15:57:32 -0500
In-Reply-To: <CAGnHSE=8d2=b3nN=0f14t_5Nf_GLsb0HXYeajZtz5As8SophsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2016-02-27 at 04:32 +0800, Tom Yan wrote:
> Oh I made a mistake on this one then.
> 
> Since I send it with another patch, should I resend that alone?

Yes, that's fine. but you need to explain as part of the changelog why
this condition needs inverting because your Subject just says "as per
the comment" which makes no sense if you're changing the comment.

James


