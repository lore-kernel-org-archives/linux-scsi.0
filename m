From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: SCSI HBA in wrong order
Date: Fri, 9 Jul 2004 10:40:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6EBED15C.7C0610C9-ON88256ECC.00609EC2-88256ECC.00611D8B@us.ibm.com>
References: <20040709164359.GF5889@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:23029 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265119AbUGIRky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2004 13:40:54 -0400
In-Reply-To: <20040709164359.GF5889@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, raray@jam.rr.com

>> I upgraded one server to Fedora Core 2 with 2.6.6 kernel.
>> Now Linux assigns the built in HBAs as scsi2 and scsi3 and assigns the
>> LSIU40HVD as scsi0 and scsi1.
>> This really screws things up.
>
>There is no way to fix this. 

It's worth mentioning that the broader problem -- that of things getting 
really screwed up by such a reversal -- can be fixed by using another way, 
such as udev, instead of the Linux host number to identify the devices. 
Which is why this "unfixable" problem has been accepted.


