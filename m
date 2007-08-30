From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: FC - NPIV in 2.6.23-rc2
Date: Thu, 30 Aug 2007 16:46:38 -0700
Message-ID: <CD3B36223A7B9F40A6FE6BAAC4E2DA61D72006@AVEXCH1.qlogic.org>
References: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com> <46D6EFE7.40802@qlogic.com> <7579f7fb0708300947r4bae76a8j3715316741f3563f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31788 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbXH3Xrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 19:47:52 -0400
Content-class: urn:content-classes:message
In-Reply-To: <7579f7fb0708300947r4bae76a8j3715316741f3563f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <lydianconcepts@gmail.com>, Seokmann Ju <seokmann.ju@qlogic.com>
Cc: Abhishek Kane <abhishek.kane@gmail.com>, linux-kernel@vger.kernel.org, Linux Driver <Linux-Driver@qlogic.com>, linux-scsi@vger.kernel.org


-----Original Message-----
From: Matthew Jacob [mailto:lydianconcepts@gmail.com] 
Sent: Thursday, August 30, 2007 9:47 AM
To: Seokmann Ju
Cc: Abhishek Kane; linux-kernel@vger.kernel.org; Linux Driver;
linux-scsi@vger.kernel.org
Subject: Re: FC - NPIV in 2.6.23-rc2

> > some sought of documentation for this, please let me know.
> NPIV is a feature to provide multiple path available on one physical
port and it has implemented based on the multiport ID (MID) capability
on the switch.
> So, you have to have the switch with MID capable on the configuration
to support NPIV, besides the controller.
>

>> No, if the switch doesn't suport NP-IV, the 24XX f/w will come up in
>> Public Loop mode (FL).
Yes, NPIV is optional, if the switch is NPIV capable then you can create
virtual ports, otherwise it works as it does today. NPIV is a standard
technology that allows sharing a single physical Fabric port (N-port)
among multiple virtual fabric ports. Multiple ID(s) is a HBA feature
that allows multiple virtual Loop ID(s) on a public or private loop
topology.          
