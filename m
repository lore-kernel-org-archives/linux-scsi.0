From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix sleeping while holding a lock on host removal and
	on killing the DV thread
Date: 18 Oct 2004 12:10:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098119447.1714.93.camel@mulgrave>
References: <416D8EBA.7060904@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50357 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267170AbUJRRKz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 13:10:55 -0400
In-Reply-To: <416D8EBA.7060904@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-13 at 15:23, Luben Tuikov wrote:
> Fix sleeping while holding a lock on host removal and on
> killing the DV thread.

This is rejecting completely again ... looks like additional space
beginning the non +/- patch lines.

As a longer term project, since I'm losing count of the number of bugs
that keep turning up in the aic DV, what would it take to move this over
to the generic DV code?

James


