From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/5] Updates for tcm_loop
Date: Wed, 16 Oct 2013 14:00:44 -0700
Message-ID: <1381957244.19256.642.camel@haakon3.risingtidesystems.com>
References: <1381907576-81857-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381907576-81857-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:12 +0200, Hannes Reinecke wrote:
> Hi Nic,
> 
> here are some updates to tcm_loop I've done during ALUA testing.
> I've implemented a 'transport_state' attribute to simulate
> transport failure and added command abort callbacks.
> 
> Hannes Reinecke (5):
>   tcm_loop: Check for valid hba in tcm_loop_drop_nexus()
>   tcm_loop: Implement transport offline
>   tcm_loop: separate out tcm_loop_issue_tmr
>   tcm_loop: TCQ and command abort support
>   tcm_loop: Implement target reset
> 
>  drivers/target/loopback/tcm_loop.c | 233 +++++++++++++++++++++++++++++++------
>  drivers/target/loopback/tcm_loop.h |   6 +
>  include/target/target_core_base.h  |   1 +
>  3 files changed, 204 insertions(+), 36 deletions(-)
> 

Everything looks reasonable to me..  Applied to target-pending/for-next.

Thanks Hannes!

--nab
