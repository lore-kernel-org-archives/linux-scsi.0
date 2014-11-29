From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_loop: Wrong I_T nexus association
Date: Fri, 28 Nov 2014 22:37:45 -0800
Message-ID: <1417243065.6016.29.camel@haakon3.risingtidesystems.com>
References: <1417010337-74779-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417010337-74779-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-11-26 at 14:58 +0100, Hannes Reinecke wrote:
> tcm_loop has the I_T nexus associated with the HBA. This causes
> commands to become misdirected if the HBA has more than one
> target portal group; any command is then being sent to the
> first target portal group instead of the correct one.
> 
> The nexus needs to be associated with the target portal group
> instead.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/loopback/tcm_loop.c | 66 +++++++++++++-------------------------
>  drivers/target/loopback/tcm_loop.h |  7 +---
>  2 files changed, 24 insertions(+), 49 deletions(-)
> 

Nice catch on this long-standing bug with tcm_loop + multi tpg export
configurations.

Applied to target-pending/for-next + stable CC.

Thanks Hannes.

--nab
