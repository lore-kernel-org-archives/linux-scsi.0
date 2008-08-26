From: Eero Volotinen <eero.volotinen@iki.fi>
Subject: (SOLVED) mptsas and mptbase sas problems on fujitsu-siemens rx200-s3
 rack server
Date: Tue, 26 Aug 2008 16:59:33 +0300
Message-ID: <48B40C45.5030709@iki.fi>
References: <48AE9DFB.7070502@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pokat.org ([193.208.0.238]:58822 "EHLO pokat.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbYHZN77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2008 09:59:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by pokat.org (Postfix) with ESMTP id 59BA6F7B1C
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2008 16:59:56 +0300 (EEST)
Received: from pokat.org ([127.0.0.1])
	by localhost (pokat.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OH+q5E7-PJR1 for <linux-scsi@vger.kernel.org>;
	Tue, 26 Aug 2008 16:59:36 +0300 (EEST)
Received: from [192.168.0.198] (cs78141008.pp.htv.fi [62.78.141.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: eero.volotinen@pokat.org)
	by pokat.org (Postfix) with ESMTP id E0D46F7B09
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2008 16:59:35 +0300 (EEST)
In-Reply-To: <48AE9DFB.7070502@iki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> mptbase: Initiating ioc0 recovery
> mptbase: Initiating ioc0 recovery
> mptbase: Initiating ioc0 recovery
> mptbase: Initiating ioc0 recovery
> mptbase: Initiating ioc0 recovery
> mptbase: Initiating ioc0 recovery
> audit(1219309592.457:7): audit_pid=0 old=3037 by auid=4294967295
> audit(1219309592.529:8): audit_pid=11640 old=0 by auid=4294967295
> mptscsih: ioc0: attempting task abort! (sc=ffff81005a09bc80)
> sd 4:1:0:0:
>         command: Write(10): 2a 00 02 17 22 03 00 04 00 00
> mptscsih: ioc0: task abort: FAILED (sc=ffff81005a09bc80)
> mptscsih: ioc0: attempting task abort! (sc=ffff81006b7779c0)
> sd 4:1:0:0:
>         command: Write(10): 2a 00 02 17 1e 03 00 04 00 00
> mptscsih: ioc0: task abort: FAILED (sc=ffff81006b7779c0)
> mptscsih: ioc0: attempting task abort! (sc=ffff81006921d240)
> sd 4:1:0:0:

Problem is now solved and cause of failures was non-working/partially 
working SAS cable from motherboard to sas hotswap array. Big thanks to 
all people that helped me with this problem.


--
Eero
