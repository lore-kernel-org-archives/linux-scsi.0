From: Sven Schuetz <sven@linux.vnet.ibm.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Fri, 13 Mar 2009 17:47:26 +0100
Message-ID: <49BA8E1E.6080809@linux.vnet.ibm.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50998 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760347AbZCMQra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2009 12:47:30 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id n2DGlSFa029240
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2009 16:47:28 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2DGlR712478280
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2009 17:47:27 +0100
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2DGlRY0016417
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2009 17:47:27 +0100
In-Reply-To: <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, futjita.tomonori@lab.ntt.co.jp, Boaz Harrosh <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

Hi Seokmann,
>
> Do we have time table for this support to make it available in the 
> upstream?
> I think it would be good to have the feature in 2.6.30 kernel, if 
> possible.
> I will continue to work on and add rest of helper function in the driver.
>
> Thank you,
> Seokmann
>
> ---

I am preparing a patch for our zfcp driver and would love to see both 
James&your fc_transport patch as well as the patches for our drivers in 
2.6.30 too :)

Tomo, Boaz - since the current implemantation is based on that patch:
http://marc.info/?l-linux-scsi&m=122785157116659&w=2
which is not agreed upon - can we start the discussion again?
My understanding from the discussion back then was that Boaz proposed a 
change to the patch which Tomo agreed to. See here: 
http://marc.info/?l=linux-scsi&m=122812818916080&w=2
However, a new version of the patch was never posted. So would a patch 
with the proposed change be ok for the two of you which could be posted 
to Jens?
I really appreciate all of your efforts, thanks a lot for that :-)
Have a nice weekend,
Sven
