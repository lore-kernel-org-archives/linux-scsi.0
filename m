From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Wed, 24 Sep 2003 18:39:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924183906.A21401@infradead.org>
References: <20030924151228.8206.qmail@web60208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:39181 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261569AbTIXRjH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 13:39:07 -0400
Content-Disposition: inline
In-Reply-To: <20030924151228.8206.qmail@web60208.mail.yahoo.com>; from jpd_hp_linux_scsi@yahoo.com on Wed, Sep 24, 2003 at 08:12:28AM -0700
List-Id: linux-scsi@vger.kernel.org
To: jd <jpd_hp_linux_scsi@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Please fix your broken Reply-To, thanks.

On Wed, Sep 24, 2003 at 08:12:28AM -0700, jd wrote:
> 
> Hi,
> 
> Available for first Review & Comments.
> 
> The UNH iSCSI Project, a collaborative effort between the
> UNH IOL and Hewlett Packard Company in Austin, Texas,
> ( hosted at http://sourceforge.net/projects/unh-iscsi )
> to produce a full feature, generic iSCSI implementation ,
> has ported the 2.4.18/20 version of the iSCSI initiator to
> Linux 2.6.test5 Kernel for consideration of inclusion for
> future distribution.

Oh well, yet another iscsi.  So what is in your opinion the
advantage over the cisco implementation, what the disadvantage.
Why don't you two cooperate?  (I'm going to ask the cisco folks
the same soon, no worries).

We're certainly not going to merge two iscsi stacks, just FYI.

I gave the code a quick very quick glance (more later):

 - most files have this license clause:

 The name of IOL and/or UNH may not be used to endorse or promote products
 derived from this software without specific prior written permission.
 
   are you sure this is compatible to the GPL?

 - the intel-licensed files definitly are not GPL-compatible
 - linebreaks after 80 chars.
 - did you read Documentation/CondingStyle?
 - I can't find module_init/init_module.  Where's the entry point
   of this code?
 
