From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Date: Thu, 15 Mar 2012 08:56:46 +0000
Message-ID: <1331801806.2941.3.camel@dabdike>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
	 <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
	 <1331714014.8688.3.camel@dabdike>
	 <C8A4A375313D4E4DA64F2CB1D0490B0A44730306@G9W0735.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58883 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756888Ab2COI4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2012 04:56:50 -0400
In-Reply-To: <C8A4A375313D4E4DA64F2CB1D0490B0A44730306@G9W0735.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nanjappa, Sathisha (MCXS, Cupertino)" <sathisha.nanjappa@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, 2012-03-14 at 23:36 +0000, Nanjappa, Sathisha (MCXS, Cupertino)
wrote:
> > 
> > On Tue, 2012-03-13 at 11:59 -0700, Sathisha Nanjappa wrote:
> > > Bugzilla 42142 - mpt2sas: Number specified in wrong base
> > >     https://bugzilla.kernel.org/show_bug.cgi?id=42142
> > 
> > From: James Bottomley
> > Sent: Wednesday, March 14, 2012 1:34 AM
> > Do you have a better description ... like what is the user
> > visible effect of correcting the constant?
> >
> 
> Does this look better:
> 
> "This fix ensures that the IOP_LOGINFO_CODE_TASK_TERMINATED
> messages do not clutter the sas_log_info messages."

Much better, thanks.  The whole point of a commit message is to explain
what you're doing and why you're doing it.  Just translating C to
english isn't useful because everyone who looks a kernel patches can
read C.

James


