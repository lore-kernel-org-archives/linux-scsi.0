From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: 26 May 2004 12:37:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085593035.2116.539.camel@mulgrave>
References: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com>
	<1085590517.2116.439.camel@mulgrave>  <20040526171514.GA1332@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:58857 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265637AbUEZRhW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 13:37:22 -0400
In-Reply-To: <20040526171514.GA1332@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Infante, Jon" <Jon.Infante@Emulex.Com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-05-26 at 12:15, Mike Anderson wrote:
> James Bottomley [James.Bottomley@steeleye.com] wrote:
> > I'd really like to see all fibre events (like loop up/down, device
> > add/remove) handled inside the FC transport class.  From there, it
> > probably still make sense to use hotplug as the mechanism for importing
> > user policy.
> 
> Currently there are no hotplug events generated from SCSI except those
> from add / remove of sysfs related structures. Are you suggesting that
> SCSI should call call_usermodehelper and generate events?

Not necessarily roll our own, just plug into the hotplug
infrastructure.  But generate events, definitely.

James


