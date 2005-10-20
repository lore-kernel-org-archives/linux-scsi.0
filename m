From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/16]  qla2xxx: update qla2xxx driver to 8.01.02-k.
Date: Thu, 20 Oct 2005 18:47:44 -0500
Message-ID: <1129852064.3115.18.camel@mulgrave>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
	 <20051019174209.GP9087@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55172 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964948AbVJUOTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 10:19:13 -0400
In-Reply-To: <20051019174209.GP9087@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-10-19 at 10:42 -0700, Andrew Vasquez wrote:
> Given all the activity promted with this patchset, could you provide
> some insight on which patches you have queued for inclusion into
> scsi-misc?
> 
> The scsi-misc-2.6 GIT tree has been dormant for some time and I would
> like to have some direction on which patches I should cherrypick and
> rebase given a number of updates to linux-2.6.git for the qla2xxx
> driver as well as the rport interface updates proposed by James S.

Actually, none at the moment.  When a patch set comes as a list of
patches, I generally tend to assume that they are all interdependent
(although sometimes if there's objection to only a single component
patch, I will pull that out if possible).

So for the monolithic set, I'll put them in when all the objections are
worked out on the list.  If there are pieces I can apply now which
everyone's happy with, tell me what they are.

James


