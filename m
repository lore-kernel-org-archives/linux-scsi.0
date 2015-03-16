From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Mon, 16 Mar 2015 18:29:01 +0100
Message-ID: <550712DD.6060402@redhat.com>
References: <1422882086-1863-1-git-send-email-hch@lst.de> <20150305133313.GA25602@infradead.org> <54F85C27.1040108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36597 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbCPR3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2015 13:29:07 -0400
Received: by wgra20 with SMTP id a20so45813396wgr.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2015 10:29:05 -0700 (PDT)
In-Reply-To: <54F85C27.1040108@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Fam Zheng <famz@redhat.com>



On 05/03/2015 14:37, Paolo Bonzini wrote:
> 
> 
> On 05/03/2015 14:33, Christoph Hellwig wrote:
>> Any chance to get reviews for this series?  Also we should at least
>> expedite this first patch into 4.0-rc as it fixes scanning races
>> in virtio_scsi.
> 
> I reviewed 1 and 3, but I'm not really qualified for patch 2.

Christoph,

any news about these patches?

Thanks,

Paolo
