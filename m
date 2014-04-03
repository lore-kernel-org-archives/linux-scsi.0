From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: New release of SCST/Qlogic target interface driver.
Date: Wed, 2 Apr 2014 22:27:26 -0500
Message-ID: <201404030327.s333RQTM007772@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:60367 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbaDCD2g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2014 23:28:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Good evening, I hope the week is going well for everyone.

The weather service started mumbling last night about eight more
inches of snow getting dumped on West-Central Minnesota so I figured
if I was going to get a last weekend of cross-country skiing in I had
better finish the week down at the lake before driving on the
interstate got bad.

So I loaded the pickup and pushed Izzy our Golden Retriever into the
cab and headed out.  On the way down he convinced me that since most
of the weekend would be spent working on the chicken cruncher code we
should get a new release of the SCST/Qlogic interface driver out now
that the kinks seemed to be worked out of the Selective Retransmission
Request (SRR) handling.

So any Qlogic HBA customers or storage OEM's who are interested in
running the SCST storage stack on the latest generation Qlogic HBA's
and CNA's can pick up version 1.1 of the SCST Qlogic Adapter (SQA)
interface driver at the following URL:

ftp://ftp.enjellic.com/pub/scst/sqa_driver-1.1.tar.gz

The interface driver has been subjected to enough abuse and traffic at
this point that we elected to remove the 'beta' designation with this
release.  As with any storage product, ** ALWAYS **, evaluate the
product carefully for suitability in the intended environment.

This interface driver was developed for and is in production use in a
large Cisco/Nexus fibre-channel/FCOE environment.  It has been tested
with the Qlogic 8362 CNA and 2672 HBA running in CNA personality mode
as well as the 24xx and 25xx families of fibre-channel adapters.
While not tested I would not anticipate any issues with 2672 HBA's
running in 16 GBPS FC mode.

This driver provides the interface 'glue' which allows SCST to use the
in-kernel qla2xxx core and target driver code.  It plays the same role
for SCST that the tcm_qla2xxx code does for the in-kernel LIO target.

Its now starting to snow out and despite the fact that I'm chucking
wood into the stove as fast as I can it is only about 49 degress in
the cabin.  Izzy has commandeered the bed since its the only warm spot
so I'm going to heat up a couple of pieces of pizza and wrap up in a
blanket in front of the stove.

Best wishes to everyone in Linux storage land for a similarily
enjoyable evening/weekend.

Greg and Izzy

As always,
Dr. Greg Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"A computer is like a horse, it will sense weakness."
                                -- Greg Wettstein
                                   GAUSSIAN quote.
