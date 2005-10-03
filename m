From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Mon, 03 Oct 2005 17:01:45 -0400
Message-ID: <1128373305.5825.3.camel@mulgrave>
References: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41702 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932400AbVJCVBt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2005 17:01:49 -0400
In-Reply-To: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxppc64-dev@ozlabs.org

On Mon, 2005-10-03 at 15:26 -0500, brking@us.ibm.com wrote:
> Add a .config option to default the scsi scan inquiry timeout.
> Due to a broken device (SCSI/ATA converter card) that is very
> common on IBM iSeries/pSeries machines, these architectures
> need a longer default inquiry timeout.

The inquiry timeout has already been changed a while ago to be a module
parameter (or kernel parameter) for this very case.  Why does it now
need to be a config option as well?

James


