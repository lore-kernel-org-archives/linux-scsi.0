From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: 2.6.1: media change check fails for busy unplugged device
Date: 31 Jan 2004 08:53:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075517314.1655.8.camel@mulgrave>
References: <200401182141.12468.arvidjaar@mail.ru>
	<20040119233641.GA1859@beaverton.ibm.com>
	<200401262216.42966.arvidjaar@mail.ru>
	<20040129093051.GA1556@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:149 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264566AbUAaNx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jan 2004 08:53:56 -0500
In-Reply-To: <20040129093051.GA1556@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-29 at 04:30, Mike Anderson wrote:
> The sdev->online flag was left as is when the device state model was
> update as we where overloading the meaning on this flag. I believe James
> last statement on this was that we need to merge this in at some point
> (correct James?).

Yes, I've just been extremely reticent about doing it because it
complicates the state model.  However, I'll get off my backside and see
if I can come up with a model update including it.

James


