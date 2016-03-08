From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH resend 1/2] be2iscsi: Remove unnecessary synchronize_irq() before free_irq()
Date: Mon, 07 Mar 2016 21:07:21 -0500
Message-ID: <yq1twkhyb6u.fsf@sermon.lab.mkp.net>
References: <1457086507-5937-1-git-send-email-lars@metafoo.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24818 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbcCHCHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 21:07:37 -0500
In-Reply-To: <1457086507-5937-1-git-send-email-lars@metafoo.de> (Lars-Peter
	Clausen's message of "Fri, 4 Mar 2016 11:15:06 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com

>>>>> "Lars-Peter" == Lars-Peter Clausen <lars@metafoo.de> writes:

Lars-Peter> Calling synchronize_irq() right before free_irq() is quite
Lars-Peter> useless. On one hand the IRQ can easily fire again before
Lars-Peter> free_irq() is entered, on the other hand free_irq() itself
Lars-Peter> calls synchronize_irq() internally (in a race condition free
Lars-Peter> way), before any state associated with the IRQ is freed.

Sorry, replied to the wrong email. I applied the be2iscsi patch. The mpt
one does not have any reviews yet...

-- 
Martin K. Petersen	Oracle Linux Engineering
