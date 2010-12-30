From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 3/7] [SCSI] scst: Add scst_local driver.
Date: Thu, 30 Dec 2010 11:10:11 -0500
Message-ID: <201012301110.12253.konrad@darnok.org>
References: <201012201849.03930.bvanassche@acm.org> <201012281351.20087.konrad@darnok.org> <AANLkTingSeNi2bTvtRGWh1o1Oe5HJBPyk93spAAsVX_T@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:60237 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0L3QUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Dec 2010 11:20:15 -0500
In-Reply-To: <AANLkTingSeNi2bTvtRGWh1o1Oe5HJBPyk93spAAsVX_T@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, realrichardsharpe@gmail.com

> > pr_err? Or is this based on a module parameter?
> 
> The macro PRINT_ERROR() has been defined in the header file
> include/scst/scst_debug.h. For this macro and also for related macros
> (e.g. TRACE_DBG()) the user can configure via debugfs whether or not
> PID, function name and/or line number should be included in the
> generated messages.

Hmm, at one hand that is neat, but at other I am wondering if it would be 
better to use CONFIG_DYNAMIC_PRINTK functionality (which is what pr_debug 
could be used for) - which is a more generic framework for this.

Some of these errors look relevant to the user so perhaps going through the 
debugfs is not proper? Or is it that there are just soo many of them that it 
is unclear whcih ones would be releveant?

> 
> >> +             res = -ENOMEM;
> >> +             goto out;
> >> +     }
> >> +
> >> +     tr_id[0] = 0x00 | SCSI_TRANSPORTID_PROTOCOLID_SAS;
> > 
> > Hmm, why the 0x00? Can't you just do an assigment?
> 
> If I do not receive further feedback, I will queue the patch below:

ok.
