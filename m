From: Jari Turkia <jari.turkia@lut.fi>
Subject: Re: storvsc loops with No Sense messages
Date: Tue, 16 Apr 2013 17:00:03 +0000
Message-ID: <56D159FD540BEC438D08E93F37BE128223F02F94@ex-mbx4.win.lut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.cc.lut.fi ([157.24.2.213]:50474 "EHLO smtp2.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964856Ab3DPRIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 13:08:49 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp2.cc.lut.fi (Postfix) with ESMTP id 602533F05B3
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 17:00:04 +0000 (UTC)
Received: from smtp2.cc.lut.fi ([127.0.0.1])
	by localhost (smtp2.cc.lut.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4V1qWOYfsMvp for <linux-scsi@vger.kernel.org>;
	Tue, 16 Apr 2013 20:00:03 +0300 (EEST)
Received: from owa.lut.fi (ex-cas2.cc.lut.fi [157.24.3.27])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp2.cc.lut.fi (Postfix) with ESMTPS id D009C3F05AD
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 20:00:03 +0300 (EEST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> On Wed, Jan 30, Olaf Hering wrote:
>> Is there a way to not use WRITE_SAME at all? While browsing the code its
>> not clear if there is a conditional for this command.
>It seems scsi_device->no_write_same may avoid this command, I will
>test this patch:
># Subject: [PATCH] scsi: storvsc: avoid usage of WRITE_SAME
>Set scsi_device->no_write_same because the host does not support it.
>Also blacklist WRITE_SAME to avoid (and log) accident usage.
>Signed-off-by: Olaf Hering <olaf@aepfle.de>

Hopefully Olaf will find time to test the patch and push it forward. I did test it and it solved the issue perfectly!

Most of the current Linux-distros won't work under Windows Server 2012 or Windows 8 Hyper-V.

Regards,
Jari Turkia