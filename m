From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 11:51:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFBD60D8A7.8D9B83B6-ON85256F3A.00670D96-88256F3A.00677FF3@us.ibm.com>
References: <20041027084202.GD32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:35236 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262580AbUJ0Sv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 14:51:56 -0400
In-Reply-To: <20041027084202.GD32712@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

>In addition verifying the size and stuff it could also check that the
>paths really (still) point to the same device (by storing the LUN WWN in
>the hw_handler context, for example)

Just to eliminate any ambiguity here, using terminology from the 
standards:  A LUN is a logical unit number.  A WWN is a fibre channel port 
or node name.  There's no such thing as a LUN WWN.  I presume you mean to 
check the logical unit device identifier, which is the world wide unique 
and persistent identifier of a logical unit.  (That's what you get (among 
other things) from Page 0x83 of the SCSI VPD read from the LU).

