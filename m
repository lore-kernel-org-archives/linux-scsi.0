From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH][SCSI] remove the queue unlock in scsi_requset_fn
Date: Mon, 13 Aug 2012 17:47:02 +0000
Message-ID: <50293D96.9020202@acm.org>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:54600 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2HMRrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 13:47:07 -0400
In-Reply-To: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: James Bottomley <JBottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

On 08/10/12 03:22, Chanho Min wrote:
> We don't need to unlock the queue before put_device in scsi_request_fn()

It looks like there is a typo in the patch subject ? Also, you can omit
"[SCSI]" from the patch subject - AFAIK James has a script that inserts
that text automatically.

Bart.

