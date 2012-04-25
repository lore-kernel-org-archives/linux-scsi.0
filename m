From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 07/17] be2iscsi:Fix double free of MCCQ info memory.
Date: Wed, 25 Apr 2012 09:13:21 +0100
Message-ID: <1335341601.3075.6.camel@dabdike.lan>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
	 <1333514512-21799-8-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab2DYIN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 04:13:28 -0400
In-Reply-To: <1333514512-21799-8-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On Tue, 2012-04-03 at 23:41 -0500, michaelc@cs.wisc.edu wrote:
> Subject: [PATCH 07/17] be2iscsi:Fix double free of MCCQ info memory.

Needs a space after the colon.  I've been fixing it up on import, so
this is for future reference.

> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This from doesn't match the first signoff ... is this the right from
field?

>  In case of MCC_Q creation failed, the MCCQ info memory is freed
>  from be_mcc_queues_destroy and be_mcc_queues_create. This caused
>  kernel to panic because of double free.

The extra space here needs removing (I've been doing it on import)

> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> dd

dd?  Is this just a spurious addition or should there be something else
here?

> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

James

