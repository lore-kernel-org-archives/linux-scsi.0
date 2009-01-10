From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] mpt fusion: Update MPI Headers to version 01.05.19
Date: Sat, 10 Jan 2009 13:10:05 -0600
Message-ID: <1231614605.3642.53.camel@localhost.localdomain>
References: <20090106092618.GC13033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57465 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZAJTKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 14:10:08 -0500
In-Reply-To: <20090106092618.GC13033@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathyap@lsi.com

On Tue, 2009-01-06 at 14:56 +0530, Kashyap, Desai wrote:
> This Patch is submitted to increment the MPI headers used by LSI MPT fusion
> drivers to the latest version 01.05.19.
> Year is changed in CopyRight.
> ---
> 
> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
> ---

Just for future reference, could you not format your patches like this.
They way git import works is that it takes all of the text up to the
first --- As the patch description and everything after it as the patch.
If you put your signoff after the ---, I lose it in the import and have
to notice and add it back manually.

James


