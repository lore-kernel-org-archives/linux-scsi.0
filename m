From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Fri, 15 Feb 2013 08:33:21 +0100
Message-ID: <511DE4C1.5000000@acm.org>
References: <1360767971-947-1-git-send-email-hare@suse.de>  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike> <511D26B4.6070302@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net> <511D68CA.6050203@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39631 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOHdZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 02:33:25 -0500
In-Reply-To: <511D68CA.6050203@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/14/13 23:44, Jeremy Linton wrote:
> On 2/14/2013 4:04 PM, Elliott, Robert (Server Storage) wrote:
>> Like James notes, LUNs should generally be treated as opaque values.
>
> Maybe another issue to consider is how they are being displayed in userland.
> A device with two luns using one of the alternative lun addressing methods is
> going to get some pretty strange looking lun numbers showing up in userspace
> if they aren't decoded properly.

One example of this is the ibmvscsi protocol. Since the ibmvscsi target 
driver uses the LUN addressing method its LUNs show up with LUN numbers 
256  512  768 ... at a Linux SCSI initiator.

Bart.

