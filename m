From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] IDEMA capacity adjustment
Date: Mon, 05 Jan 2009 10:04:06 -0600
Message-ID: <1231171446.3324.21.camel@localhost.localdomain>
References: <yq1mye74hhu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48052 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbZAEQEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 11:04:12 -0500
In-Reply-To: <yq1mye74hhu.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-01-04 at 03:12 -0500, Martin K. Petersen wrote:
> IDEMA, the International Disk Drive Equipment and Materials Association,
> publishes a specification that defines how to translate from LBA count
> to "marketing" gigabytes used to label drives.
> 
> This patch updates the size calculations in sd.c so that the base 10
> size is adjusted according to the IDEMA spec.

We already show the power of 10 size as GiB ... how does the IDEMA spec
actually differ from that?  It's one thing to display the truth in a
more positive light (as in use power of 10 GiB etc.) it's quite another
to display incorrect sizes ... is the IDEMA spec just optimistic but not
unreasonable rounding, or is it actually inflating sizes wrongly?

James


