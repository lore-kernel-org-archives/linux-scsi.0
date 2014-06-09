From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 2/2] tcm_fc: Generate TASK_SET_FULL status for response
 failures
Date: Mon, 09 Jun 2014 10:16:23 -0700
Message-ID: <1402334183.5752.115.camel@vi-devel>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
	 <1402011002-20771-3-git-send-email-nab@daterainc.com>
	 <1402088605.5752.106.camel@vi-devel>
	 <1402089063.26205.16.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402089063.26205.16.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Jun Wu <jwu@stormojo.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-06 at 14:11 -0700, Nicholas A. Bellinger wrote:
> <nod>, changing this to pr_info_ratelimited and doing the same in
> ft_queue_data_in() well. 

Since doing more places and therefore can be done in separate patch.

//Vasu
