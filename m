From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 14:37:23 +0200
Message-ID: <53FF2283.9000502@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaH1Mha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 08:37:30 -0400
In-Reply-To: <53FF2199.4030300@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 08/28/2014 02:33 PM, Paolo Bonzini wrote:
> Il 28/08/2014 14:26, Hans de Goede ha scritto:
>>>> Then, blk_complete_request will do nothing because its call to
>>>> blk_mark_rq_complete returns true.
>>>>
>>>> All this, of course, as long as ->scsi_done is called _before_ eh_abort
>>>> returns.
>> What about calling scsi_done after eh_abort if eh_abort returned FAILED?
> 
> I invoke the fifth amendment. :)

Although I appreciate the tongue in cheek answer, this was sort of a serious
question, as at the moment this may happen with the uas driver.

Regards,

Hans
