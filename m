From: Michele Baldessari <michele-lists@pupazzo.org>
Subject: Re: 2.6 and DEC HSG80
Date: Fri, 18 Nov 2005 22:37:48 +0100
Message-ID: <20051118213748.GA8576@michele.pupazzo.org>
References: <20051118112540.GB13447@michele.pupazzo.org> <1132335190.27509.5.camel@aptis101.cqtel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgrava.tizianodinca.com ([195.47.199.19]:58261 "EHLO
	mail2.rhx.it") by vger.kernel.org with ESMTP id S1751038AbVKRVhu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 16:37:50 -0500
Content-Disposition: inline
In-Reply-To: <1132335190.27509.5.camel@aptis101.cqtel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wilcox <spwilcox@att.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

* Steve Wilcox (spwilcox@att.com) wrote:
> Actually that was my doing, and the below patch is incorrect (thus the
> 1/2 hour of device type 31 entries).  The correct patch has been merged
> into the 2.6.14 kernel and can be seen here: http://www.kernel.org/git/?
> p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=507caac75e86bd041c5462e5e988fb7138e21d79
> 
> The original thread that lead to the patch can be found here:
> http://sourceforge.net/forum/forum.php?thread_id=1270421&forum_id=355154
> 
> Hope that helps - feel free to e-mail me directly if you have any
> questions about the convoluted mess that led up to this.

Hi Steve,

thanks a lot for your feedback, that patch fixed all of the issues.
Funnily enough I probably wouldn't even have noticed this issue, 
if qla2* didn't oops on me for kernels >= 2.6.14 :)

thanks again for your help,
Michele

