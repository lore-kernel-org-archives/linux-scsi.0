From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Sat, 2 Feb 2008 15:56:30 -0500
Message-ID: <170fa0d20802021256i224ad638ma96bdb4cbbcbac37@mail.gmail.com>
References: <47A350DF.5020404@cybernetics.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F43976569D@ADPE2K703.adaptec.com>
	 <170fa0d20802011643u600c4386wb801c0490800ea5f@mail.gmail.com>
	 <20080202202438.GB2367@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.241]:42839 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762482AbYBBU4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 15:56:35 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1368731hsz.5
        for <linux-scsi@vger.kernel.org>; Sat, 02 Feb 2008 12:56:32 -0800 (PST)
In-Reply-To: <20080202202438.GB2367@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>, Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Luben Tuikov <ltuikov@yahoo.com>

On Feb 2, 2008 3:24 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 01, 2008 at 07:43:54PM -0500, Mike Snitzer wrote:
> > Hi Greg,
> >
> > Given your recent call for review of the next 2.6.22-stable I'd
> > appreciate it if you and the rest of the stable team would strongly
> > consider this SCSI IO error propagation fix for inclusion in 2.6.22.17
> > (as well as the other stable trees).
>
> Is the patch in Linus's tree already?
>
> If so, what git commit id?  That's a requirement to go into the stable
> tree...
>
> If not, we need to wait until it is.

Fair enough.  Thanks for the clarification.

That likely leaves us with having James add it to his git tree for
Linus (provided he agrees with the change).  Which he and Luben seemed
to agree was the reasonable thin layer of protection that would be
allowed for such out of spec SCSI devices.

James, how would you like to proceed?  The patch fixes the good_bytes
!= 0 on HARDWARE_ERROR issue I have been chasing with Mark Salyzyn.

Thanks,
Mike
