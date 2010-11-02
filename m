From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Full hostlock pushdown available
Date: Tue, 02 Nov 2010 11:38:05 -0700
Message-ID: <1288723085.27411.8.camel@haakon2.linux-iscsi.org>
References: <20101028150508.GA2385@basil.fritz.box>
	 <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de>
	 <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box>
	 <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box>
	 <4CCF0DFE.4050106@garzik.org> <20101102092111.GK25817@basil.fritz.box>
	 <4CD03578.3050801@garzik.org>  <20101102175336.GA2167@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101102175336.GA2167@basil.fritz.box>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Garzik <jeff@garzik.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-11-02 at 18:53 +0100, Andi Kleen wrote:
> > Boaz' approach is OBVIOUSLY mechanical, correct and bisectable.
> > Yours is not.
> 
> Sorry Jeff, but my patch has 100% the same locking order as Boaz.
> The only difference is in which function it is.
> 
> -Andi

Hey Guys,

Just a heads up..  I am respinning a host_lock-less-for-37-v10 that
converts to use macros following Boaz's suggesstion and Jeff's
recommendations to ensure consistency for those LLDs that we have
identified as being able to run in 'lock-less' mode.

I was hoping to have this pushed out last night but ended up getting
sidetracked.  This should be ready to go later this afternoon.

Best,

--nab

