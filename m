From: Gorazd Golob <gorazd.golob@noviforum.si>
Subject: Re: megaraid SATA-150-4,6 on x86_64
Date: Sat, 04 Feb 2006 01:52:04 +0100
Message-ID: <1139014324.27445.43.camel@dacun.noviforum.si>
References: <1139013913.27445.40.camel@dacun.noviforum.si>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elfstone.noviforum.si ([193.189.169.107]:46786 "EHLO
	elfstone.noviforum.si") by vger.kernel.org with ESMTP
	id S1751532AbWBDAwG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 19:52:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by elfstone.noviforum.si (ESMTP) with ESMTP id 327BA1B920
	for <linux-scsi@vger.kernel.org>; Sat,  4 Feb 2006 01:51:10 +0100 (CET)
Received: from dacun.noviforum.si (dacun.noviforum.si [192.168.2.26])
	by elfstone.noviforum.si (ESMTP) with ESMTP id 049341B912
	for <linux-scsi@vger.kernel.org>; Sat,  4 Feb 2006 01:51:10 +0100 (CET)
In-Reply-To: <1139013913.27445.40.camel@dacun.noviforum.si>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I forgot to mention - same problem apear with old "MEGARAID_LEGACY" and
new one "MEGARAID_NEWGEN" .


> I'm looking for an answer or solution regarding lsi's megaraid sata-150
> working with >=2.6.11 kernel on x86_64. I've tried a few of those cards
> and have a very good experience with those on Linux kernels from 2.4.x
> to latests 2.6 on x86 platform. Suddenly I come into trouble on x86_64
> platform with 2.6 kernels - those cards are working with about 512kbytes
> per second (write) - which is strange. If I boot 32bit kernel on same
> hardware the throput is about 50mbytes/s - which is showing  that
> megaraid driver in >2.6.11 x86_64 kernels is not working properly with
> megaraid SATA-150 raid cards. Newer megaraids SATA 300-8 are working
> perfect on x86_64. Does anybody found same problem? 
> 
> Thanks, Gorazd 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

