From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] scsi_timeout_mod
Date: Wed, 19 May 2004 09:46:51 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405190046.AA03256@fukuchi.jp.fujitsu.com>
References: <409669AB.7030207@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46041 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S263743AbUESArO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 20:47:14 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i4J0lC6M020235 for <linux-scsi@vger.kernel.org>; Wed, 19 May 2004 09:47:12 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s7.gw.fujitsu.co.jp by m2.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i4J0lC7u026110 for <linux-scsi@vger.kernel.org>; Wed, 19 May 2004 09:47:12 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail502.fjmail.jp.fujitsu.com (fjmail502-0.fjmail.jp.fujitsu.com [10.59.80.98]) by s7.gw.fujitsu.co.jp (8.12.11)
	id i4J0lBe0017919 for <linux-scsi@vger.kernel.org>; Wed, 19 May 2004 09:47:11 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail502.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HXX002HRRIMEB@fjmail502.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Wed, 19 May 2004 09:47:11 +0900 (JST)
In-reply-to: <409669AB.7030207@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Hi Brian,

I had a chance to use pseudo-I/O system, I tested your patch and
it worked fine.
First, I set the value of timeout to 10 seconds.
Then I accessed the device which doesn't respond to the command.
10 seconds later, scsi midlayer detected timeout and issued abort
task message.

Since we consider the early change of broken device/path, this patch
is very useful.

Thanks,
Masao Fukuchi

Brian King wrote:
>The following patch replaces the sd_timeout_mod patch I submitted earlier.
>I renamed the field to simply "timeout" and exposed in in sysfs.
>
>
>
>
>-- 
>Brian King
>eServer Storage I/O
>IBM Linux Technology Center
