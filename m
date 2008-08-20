From: greg@enjellic.com
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Wed, 20 Aug 2008 18:44:12 -0500
Message-ID: <200808202344.m7KNiCs6016234@wind.enjellic.com>
References: <andrew.vasquez@qlogic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([209.243.13.15]:34501 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYHTXo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 19:44:29 -0400
In-Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
       "Re: Poisoning of Linux initiators on SCST reboot." (Aug 20,  3:30pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, vst@vlnb.net, Marcus Barrow <marcus.barrow@qlogic.com>

On Aug 20,  3:30pm, Andrew Vasquez wrote:
} Subject: Re: Poisoning of Linux initiators on SCST reboot.

Hi Andrew, thanks for the note.

> > There is a remote port defined for the target server.  The port WWN
> > and FCID match previous values.  The only difference is the LUN on
> > which the storage is being delivered.
> > 
> > We tore down the SCST storage definition on the target and re-mapped
> > the storage as LUN 1 but this had no affect on the situation.  That
> > isn't really surprising since the problem appears be secondary to the
> > initiator and target being unable to establish an N_PORT relationship.
> > 
> > I would be interested in any thoughts the group might have.  From the
> > perspective of the initiators the behavior seems somewhat identical to
> > what we experienced earlier.  The Qlogic driver is essentially
> > 'poisoned' with respect to its ability to access the remote port which
> > has seen a change in configuration.

> These upstream changes are in the queue of updates to be pushed for
> RHEL5.3.

Very good to hear, the client guys will be glad to hear that.

In the meantime is our analysis correct that this is the same problem,
only caused by the LUN change rather than the role changes?  Knowing
that would be very helpful.

If so we are hosed and will need to proceed with our outage to recover
the initiators.  It will also impact the next round of migrations we
need to do.

> Regards,
> Andrew Vasquez

Thanks for the information, will look forward to confirmation on the above.

Have a good evening.

}-- End of excerpt from Andrew Vasquez

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"How appropriate, you fight like a cow."
                                -- Guybrush Threepwood
