From: rob@osinvestor.com (Rob Radez)
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Wed, 5 Mar 2003 23:15:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306041534.GA15791@osinvestor.com>
References: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com

On Thu, Mar 06, 2003 at 02:01:38AM +0100, Andries.Brouwer@cwi.nl wrote:
> See that 2.5.64 came out - good. Time to send the next dev_t patch.
> Unfortunately 2.5.63 and 2.5.64 do not boot.
> 
> A moment ago I looked at what goes wrong, and it turns out that
> scsi_error is activated
>   [always a bad sign - I have never see it do any good, and
>    often see it crash the machine]
> and an infinite loop occurs, leaving the machine rather dead.
> 
> (Total of 1 commands require eh work; scsi_unjam_host; requesting sense;
>  scsi_eh_done: result 0) - infinite repeat.
> 
> Have no time tonight to make a patch, but I suppose the author of
> the 2.5.63 scsi_error.c changes knows what she did wrong.

Even with the patch to scsi_error.c floating around, I still get the
same hang/infinite loop after the information for my scsi cd-rom is
printed on both 2.5.63 and .64.

Regards,
Rob Radez
