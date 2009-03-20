From: Thomas Mueller <thomas@chaschperli.ch>
Subject: Re: aacraid: SCSI bus appears hung
Date: Fri, 20 Mar 2009 17:54:47 +0000 (UTC)
Message-ID: <gq0l97$e51$2@ger.gmane.org>
References: <gq09cm$abq$2@ger.gmane.org>
	<1237563778.12008.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47314 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbZCTRzD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2009 13:55:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lkivq-0000h5-Mu
	for linux-scsi@vger.kernel.org; Fri, 20 Mar 2009 17:54:58 +0000
Received: from 77-58-236-135.dclient.hispeed.ch ([77.58.236.135])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 17:54:58 +0000
Received: from thomas by 77-58-236-135.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 17:54:58 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi James 

>> 
>> sometimes this is only "resolveable" by rebooting the host.
>> 
>> same problem on 2 other servers with nearly identical hardware.
>> 
>> is this expected on an disk failure event?
>> 
>> maybe i should try the vanilla 2.6.28.x kernel?
> 
> Part of the problem seems to be the way the aacraid firmware is reacting
> to disk failures.  It's possible it might recovery faster with a newer
> kernel (I seem to remember seeing "hit it with a bigger hammer" type
> patches going into that).  However, your basic problem of running RAID
> on unreliable disks will still remain.
> 

ok, i think i get the point about "unreliable disks" and the Time-Limited 
Error Recovery in RE3 WD disks. damn, i just looked at "enterprise" and 
2,5". 

thanks.

- Thomas

