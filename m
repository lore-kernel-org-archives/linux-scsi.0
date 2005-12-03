From: Denny Page <denny@cococafe.com>
Subject: Re: Adaptec aic79xx performance
Date: Sat, 03 Dec 2005 02:01:10 -0800
Message-ID: <43916CE6.1090206@cococafe.com>
References: <439165A1.8070900@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:12426 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S1750905AbVLCKBP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Dec 2005 05:01:15 -0500
Received: from marvin.cococafe.com (gw.cococafe.com [64.142.30.237])
	by mail.cococafe.com (Postfix) with ESMTP id DA20C590
	for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2005 02:01:14 -0800 (PST)
Received: from [192.168.0.10] (daffy.cococafe.com [192.168.0.10])
	by marvin.cococafe.com (Postfix) with ESMTP id C8B9D7FD
	for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2005 02:01:14 -0800 (PST)
In-Reply-To: <439165A1.8070900@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Further info, indicating a negotiation problem:

/proc/scsi/aic7xxx:
Target 3 Negotiation Settings
     User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
     Goal: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
     Curr: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
     Channel A Target 3 Lun 0 Settings
             Commands Queued 24
             Commands Active 0
             Command Openings 1
             Max Tagged Openings 0
             Device Queue Frozen Count 0

/proc/scsi/aic79xx:
Target 3 Negotiation Settings
     User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
     Goal: 3.300MB/s transfers
     Curr: 3.300MB/s transfers
     Channel A Target 3 Lun 0 Settings
             Commands Queued 19
             Commands Active 0
             Command Openings 1
             Max Tagged Openings 0
             Device Queue Frozen Count 0

Kinda explains the abysmal data rate.  I am guessing that this is a bug. 
  Anyone looked at this?

Thanks,

Denny
