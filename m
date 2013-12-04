From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/11] hpsa: use workqueue instead of kernel thread for
 lockup detection
Date: Wed, 04 Dec 2013 09:42:09 -0800
Message-ID: <1386178929.2027.18.camel@dabdike.int.hansenpartnership.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
	 <20131107164529.3504.60292.stgit@beardog.cce.hp.com>
	 <1386007202.2018.28.camel@dabdike.int.hansenpartnership.com>
	 <20131204163154.GY31390@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56400 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981Ab3LDRmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 12:42:12 -0500
In-Reply-To: <20131204163154.GY31390@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

On Wed, 2013-12-04 at 10:31 -0600, scameron@beardog.cce.hp.com wrote:
> On Mon, Dec 02, 2013 at 10:00:02AM -0800, James Bottomley wrote:
> > On Thu, 2013-11-07 at 10:45 -0600, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > 
> > > Much simpler and avoids races starting/stopping the thread.
> > > 
> > > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > Actually, perhaps you do need to resubmit the series: this is rejecting
> > against scsi-misc because of your prior hpsa patches:
> 
> Ah, I did not realize you had taken these into your tree:
> 
> 2f2ec0b [SCSI] hpsa: bring logical drives online when format completes
> c99298f [SCSI] hpsa: hide logical drives with format in progress from linux

That's OK, I can drop them again ... I've been having a lot of trouble
with unsetting the imap labels I use to mark patches.

James


