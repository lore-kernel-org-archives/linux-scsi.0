From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Fri, 1 Feb 2008 12:06:21 -0800 (PST)
Message-ID: <145599.60620.qm@web31808.mail.mud.yahoo.com>
References: <47A33EE6.5080100@cybernetics.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:45670 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754597AbYBAUGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 15:06:21 -0500
In-Reply-To: <47A33EE6.5080100@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

--- On Fri, 2/1/08, Tony Battersby <tonyb@cybernetics.com> wrote:
> 
> Also, I disagree about treating recovered error like
> hardware/medium
> error.  Recovered error is supposed to mean "the last
> command completed
> successfully, with some recovery action performed by the
> device
> server".

Which then means that you agree with
commit 03aba2f7.

But the definition of RECOVERED ERROR immediately
after what you quoted, adds:
   "Details may be determined by examining the
additional sense bytes and the INFORMATION field."

Thus the patch I sent to you for you to try on
your hardware.

     Luben

