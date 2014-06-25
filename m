From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Possible use after free in scsi_put_command()?
Date: Wed, 25 Jun 2014 09:45:07 +0200
Message-ID: <53AA7E03.5070407@acm.org>
References: <53A99420.3080503@redhat.com> <53AA719C.6030204@acm.org> <53AA7432.9030709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:50936 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFYHpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 03:45:14 -0400
In-Reply-To: <53AA7432.9030709@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/25/14 09:03, Maurizio Lombardi wrote:
> On 06/25/2014 08:52 AM, Bart Van Assche wrote:
>> I agree that that cancel_delayed_work() call is confusing. Hence
>> "[PATCH] Remove two cancel_delayed_work() calls from the mid-layer"
>> (http://thread.gmane.org/gmane.linux.scsi/91027). Had you already
>> noticed that patch ?
> 
> No, I missed it, thanks for pointing it out to me.

Hello James and Christoph,

Is it correct that the patch mentioned above has not yet been queued up
? Has it already been decided in which kernel version that patch should
be included ?

Thanks,

Bart.

