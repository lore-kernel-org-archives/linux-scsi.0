From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
Date: Tue, 10 Sep 2013 15:29:49 -0700
Message-ID: <1378852189.23501.54.camel@dabdike.int.hansenpartnership.com>
References: <20130904200555.GA28147@beardog.cce.hp.com>
	 <1378850521.23501.47.camel@dabdike.int.hansenpartnership.com>
	 <48275AD710FCA34184C2B6186B4016B32D0FCEED@G6W2491.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <48275AD710FCA34184C2B6186B4016B32D0FCEED@G6W2491.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-09-10 at 22:17 +0000, Miller, Mike (OS Dev) wrote:
> 
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Tuesday, September 10, 2013 5:02 PM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; LKML; LKML-scsi
> Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
> 
> On Wed, 2013-09-04 at 15:05 -0500, Mike Miller wrote:
> > Patch 1 of 4
> > 
> > From: Mike Miller <mike.miller@hp.com>
> 
> Just for future reference, doing it this way means I have to edit the patch.  The way git am works when applying patches is that if the first body line is a keyword it recognises (like From: or Subject: or Date:) it will fold that into the commit metadata, otherwise everything becomes the commit message.  So by putting the redundant "patch 1 of 4" first, git thinks the entire body is the commit message.
> 
> James
> 
> Sorry about that. I didn't realize git worked that way. So let me ask
> a dumb question, just having [PATCH x/y] in the subject line is
> enough?

Yes, that's what all the apply scripts go by.

>  Would you like me to resubmit the patchset?

No; I just edited the messages this time.

James
