From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: Possible use after free in scsi_put_command()?
Date: Wed, 25 Jun 2014 09:03:14 +0200
Message-ID: <53AA7432.9030709@redhat.com>
References: <53A99420.3080503@redhat.com> <53AA719C.6030204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaFYHDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 03:03:21 -0400
In-Reply-To: <53AA719C.6030204@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

Hi Bart,

On 06/25/2014 08:52 AM, Bart Van Assche wrote:
> Hello Maurizio,
> 
> I agree that that cancel_delayed_work() call is confusing. Hence
> "[PATCH] Remove two cancel_delayed_work() calls from the mid-layer"
> (http://thread.gmane.org/gmane.linux.scsi/91027). Had you already
> noticed that patch ?
> 

No, I missed it, thanks for pointing it out to me.

Thanks,
Maurizio Lombardi
