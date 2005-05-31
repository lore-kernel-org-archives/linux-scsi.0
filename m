From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Problem Adding Transport Class support to fusion
Date: Tue, 31 May 2005 12:40:55 -0500
Message-ID: <1117561255.4952.14.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C028C57FA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40427 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261155AbVEaRlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 13:41:03 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C028C57FA@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Well ... I seem to have got parameter getting and setting working just
about OK (modulo a few coupling issues).

The fusion driver seems to have quite a big event subsystem.  Is there
an event that will report a device transfer agreement change? (without
this it's a bit difficult to keep track of where the device and the
fusion core are with negotiation)

Thanks,

James


