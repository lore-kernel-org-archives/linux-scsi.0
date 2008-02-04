From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Mon, 4 Feb 2008 13:02:21 -0800 (PST)
Message-ID: <134973.94460.qm@web31815.mail.mud.yahoo.com>
References: <47A72293.8050409@cybernetics.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:23445 "HELO
	web31815.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753094AbYBDVCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 16:02:34 -0500
In-Reply-To: <47A72293.8050409@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

--- On Mon, 2/4/08, Tony Battersby <tonyb@cybernetics.com> wrote:
> I _really_ _really_ hope that you don't believe that I
> am trying to take
> credit for your work. If you take another look, my original
> patch had
> the following hunk:
> 
> +
> +		/* Make sure that bad_lba is one of the sectors that the
> +		 * command was trying to access.
> +		 */
> +		if (bad_lba < start_lba ||
> +		    bad_lba >= start_lba + xfer_size / sector_size)
> +			goto out;
> +
> 
> 
> Your response patch had the following hunk:
> 
> +		if (bad_lba < start_lba)
> +			goto out;
> 
> 
> So I don't feel that it was dishonest for me to submit
> this as "my"
> work. If you were offended, then I apologize.

Oh, no, of course not.  The most important thing is
if it works for you and fixes your problem and makes
your customers happy (or you if you're a customer).

> > I think it would've been much clearer if you had
> > singled out the problems you were seeing with your
> > HW and sent a single problem with a single patch per
> > single email.
> >
> >   
> Agreed. Sometimes it is difficult to predict when something
> that seems
> so straightforward will generate so much controversy.

Nah, maybe a couple of misunderstandings (email tends to
do that), but it's all good.

I think it would've been so much better for everyone if
the RAID vendor had simply fixed their code to not
set VALID when INFORMATION is not valid (spec behaviour).
Since the bug lies in their code, that would've been
the proper course of action.  Instead, every other OS
which uses that RAID HW would have to adjust to this
RAID FW bug (if they haven't already).  Oh, well.

   Luben

