From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 1/2] tcm_fc: Generate TASK_SET_FULL status for DataIN
 failures
Date: Mon, 09 Jun 2014 10:19:15 -0700
Message-ID: <1402334355.5752.118.camel@vi-devel>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
	 <1402011002-20771-2-git-send-email-nab@daterainc.com>
	 <1402087865.5752.99.camel@vi-devel>
	 <1402088534.26205.8.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41168 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbaFIRTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2014 13:19:16 -0400
In-Reply-To: <1402088534.26205.8.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Jun Wu <jwu@stormojo.com>

On Fri, 2014-06-06 at 14:02 -0700, Nicholas A. Bellinger wrote:
> The break aborts the DataIN send loop and invokes ft_queue_status()
> below in an attempt to send TASK_SET_FULL status.
> 
> If the ft_queue_status() -> lport->tt.seq_send() also fails, then
> -ENOMEM will be returned to the target and a delayed re-queue attempt
> will be made.

I see.

> In any event, updating the comment above to be more precise 

I'm ok with leaving comment as is for now, just to avoid patch re-spin
for this after above clarification. Thanks for detailed clarification

//Vasu

