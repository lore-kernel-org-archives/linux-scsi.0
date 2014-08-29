From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 09:48:59 +0200
Message-ID: <5400306B.5070007@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de> <alpine.LNX.2.00.1408291419070.29948@nippy.intranet> <540018E0.9050907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaH2HtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 03:49:11 -0400
In-Reply-To: <540018E0.9050907@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>
Cc: Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, Robert Elliot <elliot@hp.com>

Il 29/08/2014 08:08, Hannes Reinecke ha scritto:
>>
> No.
> FAILED for any eh_abort_cmd() means that the TMF hasn't been sent.
> So the midlayer escalates to the next EH step.
> The command will only ever be re-issued once EH completes.

Then the answer to Hans's question is yes.  It is legal to call
->scsi_done() after the eh_abort handler returns FAILED.

Paolo
