From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 14:33:29 +0200
Message-ID: <53FF2199.4030300@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaH1Mdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 08:33:38 -0400
In-Reply-To: <53FF1FE8.9060108@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Il 28/08/2014 14:26, Hans de Goede ha scritto:
>> > Then, blk_complete_request will do nothing because its call to
>> > blk_mark_rq_complete returns true.
>> > 
>> > All this, of course, as long as ->scsi_done is called _before_ eh_abort
>> > returns.
> What about calling scsi_done after eh_abort if eh_abort returned FAILED?

I invoke the fifth amendment. :)

Paolo
