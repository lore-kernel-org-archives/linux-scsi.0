From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym53c8xx: Read buffer overflow
Date: Sun, 09 Aug 2009 10:37:41 -0400
Message-ID: <1249828661.4556.3.camel@mulgrave.site>
References: <4A7EDA4F.6080402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54389 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbZHIOhq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2009 10:37:46 -0400
In-Reply-To: <4A7EDA4F.6080402@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Sun, 2009-08-09 at 16:16 +0200, Roel Kluin wrote:
> Prevent read from div_10M[-1] when no clock divisor was greater.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Can this happen?

No: The low values are only possible for lower periods.  125 is the min
period this chip would ever accept (u160) and in order to support that
it has to have a master clock at 160MHz.

James


