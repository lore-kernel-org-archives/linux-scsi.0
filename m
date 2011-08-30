From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Tue, 30 Aug 2011 16:07:52 -0400
Message-ID: <4E5D4318.6010809@redhat.com>
References: <1313182877-31377-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab1H3UHx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 16:07:53 -0400
In-Reply-To: <1313182877-31377-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

  On 08/12/2011 05:01 PM, Rob Evers wrote:
> replace numeric messages with string error messages when blk_execute_rq
> fails.  Also add printing of sense info.
>
> Mike Christie suggested adding printing of sense info here
>
> Signed-off-by: Rob Evers<revers@redhat.com>
>

Hi James,

Do you have any feedback on these patches?

(I already noticed the 2nd patch is a reply to the first)

I didn't see them in the last update of scsi-misc.

Thanks, Rob
