From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/5] fnic: do not reset dev_loss_tmo in slave callout
Date: Fri, 06 Aug 2010 15:20:57 -0500
Message-ID: <1281126057.6245.115.camel@mulgrave.site>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
	 <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
	 <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu>
	 <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
	 <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu>
	 <4C5C24F7.3050403@cisco.com> <4C5C3926.4030105@cs.wisc.edu>
	 <4C5C3D98.9060400@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0HFUVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 16:21:06 -0400
In-Reply-To: <4C5C3D98.9060400@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com

On Fri, 2010-08-06 at 11:51 -0500, Mike Christie wrote:
> On 08/06/2010 11:32 AM, Mike Christie wrote:
> > tmo in the same way though. It does not matter to me either way though.
> 
> I take that last line back. If it is ok, I would like to have all FC 
> drivers using the fc class in the same way if possible.

OK, I think I agree with that.  How about I take this after the merge
window closes so we have time to canvass objections?

James


