From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 1/1] megaraid: Add support for change_queue_depth
Date: Sun, 09 Jul 2006 09:13:52 -0500
Message-ID: <1152454432.784.1.camel@mulgrave.il.steeleye.com>
References: <890BF3111FB9484E9526987D912B261901BE4C@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41936 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161014AbWGION7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 10:13:59 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BE4C@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: brking@charter.net, "Kolli, Neela" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org

On Thu, 2006-07-06 at 06:16 -0600, Ju, Seokmann wrote:
> Can you share any reason to have queue depth chanaged at runtime?
> It is set with MBOX_MAX_SCSI_CMDS at driver attach.

In general runtime parameters are far better than module insert time
ones (especially if the subsystem supports it), so is there a reason not
to apply this?

James


