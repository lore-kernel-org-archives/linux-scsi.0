From: Sam Vilain <sam@vilain.net>
Subject: rescan-scsi-bus.sh and CONFIG_SCSI_PROC_FS legacy
Date: Wed, 06 Oct 2010 17:53:27 +1300
Message-ID: <1286340807.8788.1.camel@wilber>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from watts.utsl.gen.nz ([202.78.240.73]:56688 "EHLO mail.utsl.gen.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0JFFEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2010 01:04:08 -0400
Received: from [192.168.2.22] (leibniz.catalyst.net.nz [202.78.240.7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.utsl.gen.nz (Postfix) with ESMTPSA id 97B0E21C317
	for <linux-scsi@vger.kernel.org>; Wed,  6 Oct 2010 17:53:28 +1300 (NZDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I see that CONFIG_SCSI_PROC_FS is labelled as "legacy".
However, /proc/scsi/ is required for tools such as rescan-scsi-bus.sh

So, my question is, if /proc/scsi/ is "legacy", what replaces this
function?

Cheers,
Sam.

