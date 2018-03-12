From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] device_handler: remove VLAs
Date: Mon, 12 Mar 2018 07:25:08 +0100
Message-ID: <7cd80595-ca17-0474-5870-6d7c0429db7a@suse.de>
References: <20180309232933.14e39858@heffalump.sk2.org>
 <20180309223211.20473-1-steve@sk2.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309223211.20473-1-steve@sk2.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Kitt <steve@sk2.org>, hare@suse.com, axboe@kernel.dk, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/09/2018 11:32 PM, Stephen Kitt wrote:
> In preparation to enabling -Wvla, remove VLAs and replace them with
> fixed-length arrays instead.
> 
> scsi_dh_{alua,emc,rdac} use variable-length array declarations to
> store command blocks, with the appropriate size as determined by
> COMMAND_SIZE. This patch replaces these with fixed-sized arrays using
> MAX_COMMAND_SIZE, so that the array size can be determined at compile
> time.
> 
> This was prompted by https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Stephen Kitt <steve@sk2.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++----
>  drivers/scsi/device_handler/scsi_dh_emc.c  | 2 +-
>  drivers/scsi/device_handler/scsi_dh_rdac.c | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
