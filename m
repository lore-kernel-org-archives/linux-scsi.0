From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 10:26:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B4D362.1080901@us.ibm.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com> <1085590517.2116.439.camel@mulgrave> <20040526171514.GA1332@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:34481 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265243AbUEZR2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 13:28:39 -0400
In-Reply-To: <20040526171514.GA1332@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Infante, Jon" <Jon.Infante@Emulex.Com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Anderson wrote:
> James Bottomley [James.Bottomley@steeleye.com] wrote:
> 
>>I'd really like to see all fibre events (like loop up/down, device
>>add/remove) handled inside the FC transport class.  From there, it
>>probably still make sense to use hotplug as the mechanism for importing
>>user policy.
> 
> 
> Currently there are no hotplug events generated from SCSI except those
> from add / remove of sysfs related structures. Are you suggesting that
> SCSI should call call_usermodehelper and generate events?

What about kobject_hotplug()?

Mike
