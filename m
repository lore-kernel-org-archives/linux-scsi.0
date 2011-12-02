From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] target: virtio_scsi: SCSI host lock push-down
Date: Fri, 02 Dec 2011 22:54:31 +0100
Message-ID: <4ED94917.5050300@linutronix.de>
References: <1322860424-21640-1-git-send-email-bigeasy@linutronix.de>	 <1322862236.23492.10.camel@haakon2.linux-iscsi.org> <1322862343.25673.0.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:49389 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab1LBVyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 16:54:35 -0500
In-Reply-To: <1322862343.25673.0.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On 12/02/2011 10:45 PM, Nicholas A. Bellinger wrote:
> On Fri, 2011-12-02 at 13:43 -0800, Nicholas A. Bellinger wrote:
>> Both of these are already running in 'hock_lock-less' mode as they
>> should be, and there is no reason why it should be using DEF_SCSI_QCMD()
>> in order to revert to holding hock_lock.
>
> Or host_lock even..

Thanks for clarifying.

> --nab

Sebastian
