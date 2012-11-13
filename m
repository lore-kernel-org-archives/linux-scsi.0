From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/7] qla4xxx: Updates for scsi "misc" branch
Date: Tue, 13 Nov 2012 13:34:52 +0000
Message-ID: <1352813692.2505.9.camel@dabdike.sthat4.btopenzone.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
	 <2C4E81FE-8AE8-4E48-A87C-536A40E0CCBA@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55967 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab2KNHCv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2012 02:02:51 -0500
In-Reply-To: <2C4E81FE-8AE8-4E48-A87C-536A40E0CCBA@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: vikas.chaudhary@qlogic.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On Wed, 2012-10-10 at 11:08 -0500, Michael Christie wrote:
> On Oct 10, 2012, at 6:24 AM, vikas.chaudhary@qlogic.com wrote:
> 
> > From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> > 
> > James,
> > 
> > Please apply the following patches to the scsi tree at your earliest
> > convenience.
> > 
> > Thanks,
> > Vikas.
> > 
> 
> I think some of these should be common operations instead of vendor ones.
> 
> 
> > Adheer Chandravanshi (1):
> >      qla4xxx: Added new BSG command QLISCSI_VND_ABOUT_FIRMWARE
> > 
> 
> What info does this provide?
> 
> 
> > Harish Zunjarrao (3):
> >      qla4xxx: Allow reset in link down case
> >      qla4xxx: Invoke Set Address Control Block using BSG
> 
> Does this set the networking info?
> 
> 
> >      qla4xxx: Invoke DisableACB using BSG
> 
> What does this do? Disable the networking?

Ping on this, please.   Mike's points seem eminently sensible, what is
the response?

James


