From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
Date: Wed, 15 Jan 2014 20:03:28 +0200
Message-ID: <52D6CD70.20706@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Hi MKP & SCSI folks,
>
> This series contains initial support for target mode DIF Type1+Type3
> emulation within target core, RAMDISK_MCP device backend, and tcm_loop
> fabric driver.
>
> DIF emulation is enabled via a new 'pi_prot_type' device attribute
> within configfs, which is set after initial device configuration and
> before target fabric LUN export occurs.
>
> The DIF read/write verify emulation has been made generic enough so
> it can be used by other backend drivers (eg: FILEIO), as well as
> DIF v2 in the near future.  Also note that the majority of the logic
> has been groked from existing scsi_debug.c code.
>
> The current plan is to enable basic support for emulated backends with
> tcm_loop for v3.14 code, and then move onto IBLOCK backend support
> (that requires BLOCK layer changes)

Hey Nic,
Can you please elaborate on what BLOCK layer changes are required?
I didn't spot any misses from Looking at 
Documentation/block/data-integrity.txt.

Am I missing something?

Sagi.
