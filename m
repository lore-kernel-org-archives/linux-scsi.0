From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Is scsi_cmnd::underflow still useful?
Date: 12 Jul 2004 19:55:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089680114.2074.198.camel@mulgrave>
References: <40F2E93B.3040607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63360 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264444AbUGMAzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 20:55:18 -0400
In-Reply-To: <40F2E93B.3040607@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de

On Mon, 2004-07-12 at 14:40, Douglas Gilbert wrote:
> Doesn't look like many LLDs act on scsi_cmnd::underflow.
> Seems to me that scsi_cmnd::resid is a more general
> replacement.

well, I know I suggested a recent use of it to the USB people , so I
don't think it's entirely unused.  resid can't be a replacement because
they mean different things:

resid - number of bytes left over after a transaction
underflow - driver must return error if less than this amount
transferred.

James


