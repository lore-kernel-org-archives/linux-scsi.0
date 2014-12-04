From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Thu, 4 Dec 2014 10:21:59 -0600
Message-ID: <201412041621.sB4GLx8g003761@wind.enjellic.com>
References: <duane.grigsby@qlogic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:41447 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbaLDQWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:22:12 -0500
In-Reply-To: Duane Grigsby <duane.grigsby@qlogic.com>
       "Re: [Scst-devel] New qla2x00tgt Driver Question" (Dec  3, 11:38pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Duane Grigsby <duane.grigsby@qlogic.com>, "greg@enjellic.com" <greg@enjellic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Dec 3, 11:38pm, Duane Grigsby wrote:
} Subject: Re: [Scst-devel] New qla2x00tgt Driver Question

> Hi Greg,

Hi Duane, hope your day is starting out well.

> I looked at your logs and also reviewed the PLOGI handling in
> Trunk-SCST.15. We found a issue with PLOGI/PRLI cleanup handling that I'm
> addressing. Whatever fixes will get pushed upstream with the qla2xxx and
> scst-qla2xxx.git.

Very good, I'm glad we were able to cast some illumination on this
issue.

If you could copy me on the fix I would be happy to roll it into the
3.10.x branch which we maintain for all of our storage infrastructure
and put it into our test harness.  I'm sure you saw the note from Vlad
in which he feels the deferred ABORT messages we are seeing before a
block device goes offline during NEXUS_LOSS_SESS handling have nothing
to do with SCST SCSI core.  Hopefully your fix will address whatever
is getting lost in the shuffle on that front.

Once we get that issue addressed we will put the fix into a second
test harness to see if it addresses the holy grail of all this which
is the catastrophic VMFS corruption which we have documented on
adapter resets.

> duane

Best wishes for a productive afternoon.

Greg

}-- End of excerpt from Duane Grigsby

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Sweeny's Law: The length of a progress report is inversely proportional
 to the amount of progress."
