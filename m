From: Steve Lord <lord@xfs.org>
Subject: 3ware driver maximum request size
Date: Thu, 17 Aug 2006 10:13:03 -0500
Message-ID: <44E4877F.2070708@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail01hq.adic.com ([63.81.117.10]:38468 "EHLO MAIL01HQ.adic.com")
	by vger.kernel.org with ESMTP id S965127AbWHQPNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 11:13:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, aradford@gmail.com


Does anyone know why the 3ware driver caps I/O at 128K bytes per scsi
request? The driver defines a scatter gather array which will always
cope with at least twice this.

I am running with the TW_MAX_SECTORS constant at 512 and getting
256K I/Os to a 6+1 raid5 lun on a 9550SX. By my calculations this
does not exceed the defined sizes of the scatter gather arrays for
this type of device (but would I guess for the escalade variant
in the code).

I know nothing about the hardware itself, but if this works it seems
like a worthwhile change for the newer devices.

Thanks

   Steve Lord

