From: Willem Riede <osst@riede.org>
Subject: Re: [Kernel-janitors] [PATCH] Re: no set_current_state() before
 schedule_timeout() (OSST)
Date: Wed, 14 Jul 2004 00:45:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089765906l.26949l.2l@serve.riede.org>
References: <40F41EA6.9000900@us.ibm.com>
	<1089760052l.26949l.0l@serve.riede.org>
	<29495f1d04071316362e782433@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	Format=Flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:37365 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S265891AbUGMXyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2004 19:54:06 -0400
In-Reply-To: <29495f1d04071316362e782433@mail.gmail.com> (from
	nish.aravamudan@gmail.com on Tue, Jul 13, 2004 at 19:36:01 -0400)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, kernel-janitors@lists.osdl.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

On 07/13/2004 07:36:01 PM, Nish Aravamudan wrote:
> 
> The main reason I see for using msleep() instead is if the task should
> sleep for at least 100 ms. Using TASK_INTERRUPTIBLE (or really
> anything other than msleep()) is not guaranteed to sleep as long as
> requested. If that's ok / desired, then I won't convert it, of course.

There is no need for such guarantee. The current behavior is OK, by design.

Regards, Willem Riede.

