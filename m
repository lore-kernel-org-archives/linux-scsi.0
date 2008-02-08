From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Fri, 08 Feb 2008 09:57:27 -0600
Message-ID: <1202486247.3102.17.camel@localhost.localdomain>
References: <20080208153217.5fc42a50@core>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42261 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757068AbYBHP5f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 10:57:35 -0500
In-Reply-To: <20080208153217.5fc42a50@core>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 15:32 +0000, Alan Cox wrote:
> The word "illegal" has a precise dictionary meaning of "prohibited by
> law". The error messages are therefore incorrect as so far nobody has
> made SCSI violations a criminal offence.

Um, I'm really reluctant to do this without an incredibly good reason.
Illegal is a defined term under the SCSI standards, and the messages you
are changing actually appear with the word Illegal in the actual
ASC/ASCQ definition.  If I accept this patch, you'll no longer be able
to look the messages up in the relevant standard:

http://www.t10.org/ftp/t10/drafts/spc3/spc3r23.pdf

By a simple text search.

I don't think the pedantry is worth the confusion ...

James


