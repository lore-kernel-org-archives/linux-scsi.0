From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Wed, 8 Dec 2004 15:08:20 -0500
Message-ID: <OF92E0C426.585D5E2A-ON85256F64.006E6FA1-88256F64.006E585F@us.ibm.com>
References: <20041208154010.GK10881@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:63895 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261335AbULHUId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2004 15:08:33 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iB8K8Sv5012104
	for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 15:08:28 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iB8K8S1m258948
	for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 15:08:28 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iB8K8QcE025542
	for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 15:08:27 -0500
In-Reply-To: <20041208154010.GK10881@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: 'Andrew Morton' <akpm@osdl.org>, "Mukker, Atul" <Atulm@lsil.com>, brking@us.ibm.com, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, "Doelfel, Hardy" <hdoelfel@lsil.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Matt Domsch <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

>> I would also suggest __attribute__((packed)) since you're sharing with
>> userspace just to ensure you can never get it grown by the compiler
>> (it shouldn't be, but just to be safe).
>
>That's a bad idea, it forces the compiler to pessimise accesses to the
>struct on most hardware.

How?  We're assuming that it won't actually affect the layout of this 
struct, so what does the compiler pessimize?

