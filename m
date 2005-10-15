From: Albert Lee <albertcc@tw.ibm.com>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Sat, 15 Oct 2005 13:08:34 +0800
Message-ID: <43508ED2.2060307@tw.ibm.com>
References: <43490BC8.9060504@torque.net> <434919E4.1080601@pobox.com> <435069E3.90306@torque.net> <43506AA3.3030502@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:60297 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751082AbVJOFJB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 01:09:01 -0400
In-Reply-To: <43506AA3.3030502@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> Six days have passed and "git pull ..../libata-dev" still
>> does not reflect these changes. Am I doing something
>> wrong? Should I wait before submitting more changes?
> 
> 
> Your changes are committed to the 'upstream' branch.  Maybe you need to do
>     git pull $url upstream
> ?
> 
>     Jeff
> 
> 

I can see Doug's patch like ata_scsi_set_sense() in the libata-dev upstream branch.

I've also revised the CHS follow-up patch to be based on Doug's patch.
e.g. http://marc.theaimsgroup.com/?l=linux-ide&m=112910068215803&w=2
(commit head edea3ab58f8edd5f72d31f891ab4f34382e97e3a).

Albert

