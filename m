From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Adaptec AACRAID: convert fibctx->wait_sem to completion
Date: Wed, 13 Feb 2008 13:09:00 -0600
Message-ID: <1202929740.3109.79.camel@localhost.localdomain>
References: <20080213183444.GA27068@traven>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54586 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbYBMTJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:09:08 -0500
In-Reply-To: <20080213183444.GA27068@traven>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Wed, 2008-02-13 at 19:34 +0100, Matthias Kaehlcke wrote:
> Adaptec AACRAID driver: The semaphore fibctx->wait_sem is used for
> signalling an event. Convert it to a completion.

What's the purpose of doing this?  The aacraid implementation seems to
be a classic PV semaphore, so why does it need to become a completion?

James


