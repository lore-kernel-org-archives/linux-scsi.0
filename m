From: Steve Wilcox <spwilcox@att.com>
Subject: Re: [PATCH]  DEC hsg80 needs BLIST_REPORTLUN2
Date: Tue, 09 Aug 2005 14:45:25 -0400
Message-ID: <1123613125.30193.42.camel@aptis101.cqtel.com>
References: <1123608417.30193.23.camel@aptis101.cqtel.com>
	 <1123609899.5170.32.camel@mulgrave>
	 <1123612144.30193.31.camel@aptis101.cqtel.com>
	 <1123612572.5170.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail131.messagelabs.com ([216.82.242.99]:31390 "HELO
	mail131.messagelabs.com") by vger.kernel.org with SMTP
	id S1750705AbVHISp1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 14:45:27 -0400
In-Reply-To: <1123612572.5170.35.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

That one looks good.  Thanks for all of your help there.

-steve

On Tue, 2005-08-09 at 13:36 -0500, James Bottomley wrote:
> On Tue, 2005-08-09 at 13:29 -0500, Wilcox, Stephen P, CITPC wrote:
> > Crap.  I was afraid that my mailer might mangle this...   I created the
> > patch with "diff -up" based on the info in "SubmittingPatches" in the
> > kernel source tree, but I must admit that I manually edited the patch so
> > that It would apply to RedHat's .src.rpms using their canned spec files.
> > The working (at least using RedHat's method) patch is attached this time
> > rather than pasted in.  If that one still fails to work, the single
> > change is all that's really needed.
> 
> Well, apparently your ISP mangles attachments:
> 
> > The file scsi-blacklist.patch has been replaced, as it is a file type
> > that is known for spreading viruses. For assistance, please contact
> > your local Desktop Support Personnel or refer to the following website
> > for direction. http://antivirus.security.att.com/Default.htm
> > 
> 
> However I think I have this patch here:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=67f4602a392008439ab030ab23181f75e330ba74
> 
> If you just verify I got it right.
> 
> James
> 
> 
