From: "jack wang" <jack_wang@usish.com>
Subject: Re: SCSI reference
Date: Tue, 1 Sep 2009 15:59:12 +0800
Message-ID: <1C3EB236F2AE4177B8C5F7236DEEF81D@usish.com.cn>
References: <48e952f40909010010m1ebbbd95ra72fd42e0de3fbc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45600 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZIAH7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 03:59:13 -0400
In-Reply-To: <48e952f40909010010m1ebbbd95ra72fd42e0de3fbc6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jonathan Nell' <crtrn13@gmail.com>, linux-scsi@vger.kernel.org


I'm new to this scsi stuff. Is there any good online reference where I
can look up CDBs and the format of responses etc.
For e.g. I know that  0x43 is READ_TOC but I have no idea how to
construct the CDB and what format to response is.

You should look into t10.org to get SAM SPC SBC specs first , All SCSI
command
& response format could be found there , or you just look the kernel source
in driver/scsi 

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

