From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]  DEC hsg80 needs BLIST_REPORTLUN2
Date: Tue, 09 Aug 2005 13:36:12 -0500
Message-ID: <1123612572.5170.35.camel@mulgrave>
References: <1123608417.30193.23.camel@aptis101.cqtel.com>
	 <1123609899.5170.32.camel@mulgrave>
	 <1123612144.30193.31.camel@aptis101.cqtel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56204 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964923AbVHISgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 14:36:19 -0400
In-Reply-To: <1123612144.30193.31.camel@aptis101.cqtel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wilcox, Stephen P, CITPC" <spwilcox@att.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Tue, 2005-08-09 at 13:29 -0500, Wilcox, Stephen P, CITPC wrote:
> Crap.  I was afraid that my mailer might mangle this...   I created the
> patch with "diff -up" based on the info in "SubmittingPatches" in the
> kernel source tree, but I must admit that I manually edited the patch so
> that It would apply to RedHat's .src.rpms using their canned spec files.
> The working (at least using RedHat's method) patch is attached this time
> rather than pasted in.  If that one still fails to work, the single
> change is all that's really needed.

Well, apparently your ISP mangles attachments:

> The file scsi-blacklist.patch has been replaced, as it is a file type
> that is known for spreading viruses. For assistance, please contact
> your local Desktop Support Personnel or refer to the following website
> for direction. http://antivirus.security.att.com/Default.htm
> 

However I think I have this patch here:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=67f4602a392008439ab030ab23181f75e330ba74

If you just verify I got it right.

James


