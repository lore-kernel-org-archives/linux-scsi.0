From: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] SCSI tape log message fixes
Date: Tue, 06 Apr 2004 23:01:07 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000901c41bdf$9fac6970$2987110a@lsd.css.fujitsu.com>
References: <Pine.LNX.4.58.0404031334490.1131@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain;	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:11480 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S263815AbUDFOBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 10:01:21 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72]) by fgwmail7.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i36E1JEr028949 for <linux-scsi@vger.kernel.org>; Tue, 6 Apr 2004 23:01:19 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from s10.gw.fujitsu.co.jp by m2.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i36E1I4e026063 for <linux-scsi@vger.kernel.org>; Tue, 6 Apr 2004 23:01:18 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from fjmail506.fjmail.jp.fujitsu.com (fjmail506-0.fjmail.jp.fujitsu.com [10.59.80.106]) by s10.gw.fujitsu.co.jp (8.12.11)
	id i36E1Wn4013119 for <linux-scsi@vger.kernel.org>; Tue, 6 Apr 2004 23:01:32 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from CARREN (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail506.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HVR00L1D5M5C7@fjmail506.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Tue,  6 Apr 2004 23:01:18 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org


----- Original Message ----- 
From: "Kai Makisara" <Kai.Makisara@kolumbus.fi>
Sent: Saturday, April 03, 2004 7:44 PM
Subject: [RFC][PATCH] SCSI tape log message fixes


> This patch changes the st console/log messages:
> 
> - __GFP_NOWARN added to buffer allocation to suppress useless messages 
>   when having to use smaller than default segments
> - move log message from enlarge_buffer() to caller so that the tape name 
>   can be printed and remove some debugging messages; now the st messages
>   should include drive name where applicable (a problem reported by 
>   Hironobu Ishii)
> - setting options is logged only when debugging; the most important 
>   options are now seen in sysfs
>  
> Kai

Thank you, Kai. 
It's OK to me. I'm happy to see this patch.

Thanks,
Hironobu Ishii.

