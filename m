From: Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [Kernel-janitors] [PATCH] Re: no set_current_state() before schedule_timeout() (OSST)
Date: Tue, 13 Jul 2004 23:36:01 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <29495f1d04071316362e782433@mail.gmail.com>
References: <40F41EA6.9000900@us.ibm.com> <1089760052l.26949l.0l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mproxy.gmail.com ([216.239.56.250]:27159 "HELO mproxy.gmail.com")
	by vger.kernel.org with SMTP id S267234AbUGMXgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 19:36:05 -0400
Received: by mproxy.gmail.com with SMTP id r65so480889cwc
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2004 16:36:01 -0700 (PDT)
In-Reply-To: <1089760052l.26949l.0l@serve.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, kernel-janitors@lists.osdl.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, 13 Jul 2004 23:07:32 +0000, Willem Riede <osst@riede.org> wrote:
> 
> 
> On 07/13/2004 01:40:54 PM, Nishanth Aravamudan wrote:

<snip>

> > If someone could tell me which state (TASK_INTERRUPTIBLE or
> > TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the
> > calls with msleep().
> 
> You're right, there is a set_current_state(TASK_INTERRUPTIBLE) missing.
> I don't know why we would want to change to use msleep() though.

<snip>

The main reason I see for using msleep() instead is if the task should
sleep for at least 100 ms. Using TASK_INTERRUPTIBLE (or really
anything other than msleep()) is not guaranteed to sleep as long as
requested. If that's ok / desired, then I won't convert it, of course.

Thanks,
Nish
