From: Hank Janssen <hjanssen@microsoft.com>
Subject: Process for subsystem maintainers to get Hyper-V code out of
 staging.
Date: Mon, 14 Feb 2011 23:30:07 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233F95737__18777.7757797905$1297726539$gmane$org@TK5EX14MBXC114.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3.microsoft.com ([131.107.115.214]:46037 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1BNXf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 18:35:29 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, linux-ide@vger.ke
Cc: KY Srinivasan <kys@microsoft.com>, Hashir Abdi <habdi@microsoft.com>, Mike Sterling <Mike.Sterling@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>


Stephen/James/David,

Greetings to you all. As you might be aware, we submitted Hyper-V drive=
rs to the kernel 2009. =A0
We have been extending these drivers with additional functionality and =
our primary focus=20
now is doing the work needed to exit the staging area.

To give you some background, the following are Hyper-V specific Linux d=
rivers:

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hv_vmbus=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 The vmbus driver that is the bridge between guest and the=20
			host
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hv_storvsc=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 The SCSI device driver
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hv_blkvsc=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 The IDE driver
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hv_netvsc=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 The network driver

We think our drivers are pretty close to be reviewed by the subsystem m=
aintainers.

We have been  working with Greg on  hv_vmbus, and several other driver =
issues as it=20
relates to exiting staging. And now we are looking for guidance for the=
 other drivers.

	1. Most important thing of course, did we contact the correct subsyste=
m=20
	    maintainers?
		i. IDE/Blkvsc		David Miller
		ii. SCSI/Storvsc		James Bottomley
		iii. Network/Netvsc	Stephen Hemminger
	2. What is the process to submit the code for review?
	3. Which mailing list(s) do we need to use for the code reviews
	4. I assume normal patch format is required?
	5. What additional information is needed
	6. Once they leave staging where do they need to go? Because they all
	    pretty much come as a package we were thinking drivers/hyperv migh=
t
	    be a good place.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
There are still a few outstanding items we are currently working on. Bu=
t they should be=20
wrapped up shortly. (There are a few remaining FIXME comments in the co=
de we are
cleaning up as I write this). But if possible we would like to get your=
 feedback even as
we are addressing the issues we currently know about.

Thanks

Hank.




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
