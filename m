From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] qla2xxx: fixes for 2.6.26 [8.02.01-k4].
Date: Wed, 28 May 2008 12:22:20 -0500
Message-ID: <1211995340.3445.53.camel@localhost.localdomain>
References: <20080519212418.GH42403@plap4.local>
	 <20080528161952.GM47641@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39275 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbYE1RWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 13:22:23 -0400
In-Reply-To: <20080528161952.GM47641@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2008-05-28 at 09:19 -0700, Andrew Vasquez wrote:
> On Mon, 19 May 2008, Andrew Vasquez wrote:
> 
> > James,
> > 
> > Further testing has found some regressions in the NPIV code.  Please
> > add the following to your rc-fixes tree.
> > 
> >  drivers/scsi/qla2xxx/qla_isr.c     |   36 ++++++++++--------------------------
> >  drivers/scsi/qla2xxx/qla_mid.c     |    1 +
> >  drivers/scsi/qla2xxx/qla_os.c      |   14 ++++++++------
> >  drivers/scsi/qla2xxx/qla_version.h |    2 +-
> >  4 files changed, 20 insertions(+), 33 deletions(-)
> > 
> > commits:
> > 
> > - Revert "qla2xxx: Use proper HA during asynchrounous event handling."
> > - Correct handling of AENs postings for vports.
> > - Update version number to 8.02.01-k4.
> 
> Ack/Nack?  These fixes should really be in 2.6.26.

Next on the list to look at, honest!  I've been away for a week, so I'm
in catch up mode.

James


