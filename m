From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] do Symmetrix multipath-tools defaults need update ?
 or scsi-to-blk errors management ?
Date: Thu, 11 Jun 2009 06:58:58 +0200 (CEST)
Message-ID: <1614009620.1734931244696338438.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <4A30431C.3030809@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:61799 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZFKE7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2009 00:59:05 -0400
In-Reply-To: <4A30431C.3030809@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Levy Jerome <Levy_Jerome@emc.com>, linux-scsi@vger.kernel.org


>>
>> ::: error log on a 2.6.9 (rhel 4.7) kernel :::
>>
>
> For RH 4.9 I did the attached patch. So this error is not fastfailed 
> (upstream does not fastfail this type of error when using dm-multipath 
> now). So now the scsi layer will retry its normal 5 times, then fail.
>
Thank you for the information. This is very good news.
Can you also advise about the rhel 5 minimum kernel version ?


>>
>> ::: error log on a 2.6.29.x kernel for a reservation conflict :::
>>
> I was just about to post new blkerr patches. For this we just wan 
> multipath to fail this IO right away right? So have scsi return some 
> fatal error then dm-multipath will see it and not retry that IO?
>
Yes, that would do. Thanks you very much for your prompt response and your work on this.

Regards,
cvaroqui
