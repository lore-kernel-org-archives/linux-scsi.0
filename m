From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH RFC] more struct scsi_lun
Date: Mon, 24 Oct 2005 16:10:07 -0400
Message-ID: <435D3F9F.5010709@adaptec.com>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023044953.GA23354@havoc.gtf.org> <435B5C15.5070106@s5r6.in-berlin.de> <435B8CC9.5000600@s5r6.in-berlin.de> <435BBF05.6010109@pobox.com> <435D0B5B.7010706@adaptec.com> <435D3E07.5050709@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:45744 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751253AbVJXUKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 16:10:14 -0400
In-Reply-To: <435D3E07.5050709@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

On 10/24/05 16:03, Stefan Richter wrote:
> What about an 64bit integer as carrier of LUN in the first place? The
> most frequent occurrence of LUN data is when it is passed through in
> function calls but it seems rarely to be manipulated.

Nah, we don't want to do that.  A LUN is like a CDB, there is no
MSB or LSB, just a sequence of bytes, 1st, 2nd, etc.  Only when
being printed, is when you want to impose MSB, so that you can
print it humanly readable -- i.e. so that when the customer looks
at their manual/storage app, they can see the LUN and recognize it.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
