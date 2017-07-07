From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/5] target: Use macro for WRITE_VERIFY_xx operation
 codes
Date: Thu, 06 Jul 2017 22:00:19 -0700
Message-ID: <1499403619.30628.30.camel@haakon3.risingtidesystems.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
         <20170628055900.22889-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170628055900.22889-2-damien.lemoal@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Hi Damien,

On Wed, 2017-06-28 at 14:58 +0900, Damien Le Moal wrote:
> Add WRITE_VERIFY_32 definition to scsi prototypes and use this macro
> definition isntead of the hard coded value. Same for the already defined
> WRITE_VERIFY_16 command code.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/target/target_core_device.c | 4 ++--
>  include/scsi/scsi_proto.h           | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)

Note the WRITE_VERIFY_16 macro usage has already been changed by
commit 500073bb23 in target-pending/for-next.

So applied to target-pending/for-next for the WRITE_VERIFY_32 specific
bits.
