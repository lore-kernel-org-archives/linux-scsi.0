From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: replace deprecated hosts.h file
Date: Sat, 29 May 2004 13:11:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B8C451.1080204@pobox.com>
References: <20040529142126.GA31365@devserv.devel.redhat.com> <40B8A7FA.8070802@pobox.com> <20040529151431.GD31365@devserv.devel.redhat.com> <40B8B383.4050602@pobox.com> <20040529164056.GH31365@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49104 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265241AbUE2RL7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:11:59 -0400
In-Reply-To: <20040529164056.GH31365@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Arjan van de Ven wrote:
> On Sat, May 29, 2004 at 12:00:03PM -0400, Jeff Garzik wrote:
> 
>>Arjan van de Ven wrote:
>>
>>>On Sat, May 29, 2004 at 11:10:50AM -0400, Jeff Garzik wrote:
>>>
>>>
>>>>Rejected, libata stays with the old headers until 2.7 (when it leaves 
>>>>scsi).
>>>
>>>
>>>why ?
>>
>>Because I am actively maintaining the 2.4 version of libata.
> 
> 
> ... and that involves not fixing 2.6 drivers.... how ?

Since you are not the one maintaining libata, you do not have to deal 
with applying the same patch to 2.4 and 2.6.  Every 2.4->2.6 difference 
in libata increases work I have to do when working on libata.

	Jeff


