From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym8xx_2: Fixes call to wait_for_completion_timeout()
	with NULL argument
Date: Mon, 07 Jan 2008 16:39:35 -0600
Message-ID: <1199745575.3126.50.camel@localhost.localdomain>
References: <20080107225619.59621db7.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36755 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbYAGWjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 17:39:41 -0500
In-Reply-To: <20080107225619.59621db7.krzysztof.h1@poczta.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx


On Mon, 2008-01-07 at 22:56 +0100, Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> This patch fixes call to wait_for_completion_timeout()
> with NULL argument.

That doesn't seem to be at all what your patch is doing.  I can't see
any case in the old code where wait_for_completion_timeout() could be
called with a NULL that you fix.  What it seems you are doing is
altering the code to eliminate the finished_reset variable.

James


