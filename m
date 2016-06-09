From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix for hang of Ordered task in TCM
Date: Wed, 08 Jun 2016 22:38:10 -0700
Message-ID: <1465450690.5365.145.camel@haakon3.risingtidesystems.com>
References: <1464067904.22249.53.camel@haakon3.risingtidesystems.com>
	 <1465415022-79833-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465415022-79833-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mikecyr@linux.vnet.ibm.com, rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org, seroyer@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-06-08 at 14:43 -0500, Bryant G. Ly wrote:

<SNIP>

> 
> Hi Nic,
> 
> So I was testing the ibmvscsi target driver and I ran into some problems
> again with UA stuff and it looks like you didnt remove the UA checks from
> target_setup_cmd_from_cdb? Was that intentional? I thought we agreed to move
> it completely to target_execute_cmd and not have both?
> 
> Let me know.
> 

Ah yes, the version of the patch I've been using for future target-core
developments was missing the removal in target_setup_cmd_from_cdb().

Applied the proper version to target-pending/master here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=15ce22fa491aa3bab7acd89ac40a9fc27aeed915

Thanks for the heads up!
