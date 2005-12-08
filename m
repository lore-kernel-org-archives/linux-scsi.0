From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 08 Dec 2005 08:52:35 +0100
Message-ID: <4397E643.8040307@s5r6.in-berlin.de>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de> <200512080319.19434.adq_dvb@lidskialf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50907 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750725AbVLHHyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 02:54:46 -0500
In-Reply-To: <200512080319.19434.adq_dvb@lidskialf.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Andrew de Quincey wrote:
>>What if you replace WRITE by READ in
>>drivers/scsi/scsi_ioctl.c::scsi_cmd_ioctl()::case CDROMEJECT ?
> 
> Yup, using READ there fixes it too (and I did remember to remove my other 
> patch before testing :)
> 
> USB storage devices still work with the CDROMEJECT ioctl and this change as 
> well.

I'll check if they have a safeguard which sbp2 should have too.
Thanks a lot.
-- 
Stefan Richter
-=====-=-=-= ==-- -=---
http://arcgraph.de/sr/
