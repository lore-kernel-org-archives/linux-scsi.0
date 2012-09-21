From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3] scsi_lib: rate-limit the error message from failing commands
Date: Fri, 21 Sep 2012 15:15:01 -0400
Message-ID: <CAMM=eLdhuqKij12zXxTWJ9wMEHp3HxZJxbCHGCRbzBE647WK8A@mail.gmail.com>
References: <20120830210607.28119.96438.stgit@localhost6.localdomain6> <503FF64C.6040409@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47386 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2IUTPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Sep 2012 15:15:23 -0400
Received: by lbbgj3 with SMTP id gj3so4335201lbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 21 Sep 2012 12:15:22 -0700 (PDT)
In-Reply-To: <503FF64C.6040409@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: Yi Zou <yi.zou@intel.com>, Jens Axboe <axboe@kernel.dk>, "www.Open-FCoE.org" <devel@open-fcoe.org>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org

On Thu, Aug 30, 2012 at 7:25 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-08-30 14:06, Yi Zou wrote:
>> [
>> Jens/James,
>>
>> This is a rather old rate limt patch but never gets picked up in upstream, so I
>> am resending it here as v3, with some minor changes so it is directly applicable
>> to the current linux-2.6.git tree. I don't have that many LUNs that the original
>> issue was reported but the patch was already reviewed and acked in the past,
>> I did retest w/ stress I/O on 4 LUNs I have right now.
>>
>> Original thread can be found at:
>> http://comments.gmane.org/gmane.linux.scsi/73497
>> http://www.open-fcoe.org/patchwork/patch/2436/
>>
>> Can you please pull this patch in? it's been hanging there for a long time.
>> Original patch description is below.
>
> I've pulled in the block bit.

James,

Do you intend to pick up the scsi_lib.c change?
