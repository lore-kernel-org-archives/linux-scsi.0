From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM ATTEND] interest in blk-mq, scsi-mq, dm-cache, dm-thinp,
 dm-*
Date: Wed, 22 Jan 2014 10:54:01 +0100
Message-ID: <52DF9539.9060206@acm.org>
References: <D63B9804CB63AD4FAAD966037695664647023F7E@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yahoo.smtp.stone-is.be ([5.134.1.31]:53904 "EHLO
	yahoo.smtp.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaAVJyG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 04:54:06 -0500
In-Reply-To: <D63B9804CB63AD4FAAD966037695664647023F7E@avmb2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 01/16/14 23:35, Giridhar Malavali wrote:
> On 1/10/14 10:27 AM, "Mike Snitzer" <snitzer@redhat.com> wrote:
>> I would like to attend to participate in discussions related to topics
>> listed in the subject.  As a maintainer of DM I'd be interested to
>> learn/discuss areas that should become a development focus in the months
>> following LSF.
> 
> +1 for scsi-mq. 

(removed lsf-pc from CC-list)

Hello Giridhar,

I definitely appreciate QLogic's continuous efforts to improve
performance of their initiator and target drivers. Via your e-mail I
learned that QLogic is looking at scsi-mq, which is great news. However,
the following issue might have to be addressed before the qla2xxx driver
can fully take advantage of the scsi-mq work:
https://bugzilla.kernel.org/show_bug.cgi?id=69201. It would be
appreciated if someone could have a look at the measurements described
in that bugzilla entry.

Thanks,

Bart.
