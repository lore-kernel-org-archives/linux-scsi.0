From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and
 remove EXPERIMENTAL dependency, since udev depends on BSG.
Date: Tue, 14 Jul 2009 09:29:01 -0400
Message-ID: <1247578141.4310.34.camel@mulgrave.site>
References: <1247513973-24899-1-git-send-email-john@stoffel.org>
	 <19035.36432.181354.977939@stoffel.org>  <4A5C27D4.5040204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753517AbZGNN3I@vger.kernel.org>
In-Reply-To: <4A5C27D4.5040204@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: John Stoffel <john@stoffel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-07-14 at 09:38 +0300, Boaz Harrosh wrote:
> On 07/13/2009 10:43 PM, John Stoffel wrote:
> >>>>>> "John" == John Stoffel <john@stoffel.org> writes:
> > 
> > Dammit, I messed up here sending this patch.  I've just edited the
> > subject line and re-sent it with a bit more description.  I think this
> > patch is perfectly good to go into 2.6.31 right now, esp since it's
> > not changing code, just whether the code is turned on by default from
> > now on.
> > 
> 
> I would like it if you'd also CC stable@kernel.org on this patch. As this
> condition is already true for distros in the field.

The stable tree is for bug *fixes*.   Moving an option out from under
experimental is basically an enhancement, even if it could be argued it
should have been done long ago.

James
