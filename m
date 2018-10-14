From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 0/6] mac_esp, zorro_esp, esp_scsi: Various improvements
Date: Sun, 14 Oct 2018 14:36:51 +1300
Message-ID: <38b7cb8f-6adf-7097-d33c-7824dd9c013c@gmail.com>
References: <cover.1539391876.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539391876.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

Am 13.10.2018 um 13:51 schrieb Finn Thain:
> This series has fixes and cleanup for mac_esp, zorro_esp and the
> core esp_scsi driver.
>
> The improvements include elimination of duplicated code temporarily
> introduced for zorro_esp.
>
> Michael, would you please regression test this series on elgar,
> if convenient? So far, only mac_esp has been tested with this code.
>
>
> Finn Thain (6):
>   zorro_esp: Limit DMA transfers to 65535 bytes
>   esp_scsi: Track residual for PIO transfers
>   esp_scsi: Grant disconnect privilege for untagged commands
>   esp_scsi: Eliminate ESP_FLAG_DOING_SLOWCMD
>   esp_scsi: De-duplicate PIO routines
>   esp_scsi: Optimize PIO loops
>
>  drivers/scsi/esp_scsi.c  | 192 +++++++++++++++++++++++++++++--------
>  drivers/scsi/esp_scsi.h  |  10 +-
>  drivers/scsi/mac_esp.c   | 171 ++-------------------------------
>  drivers/scsi/zorro_esp.c | 240 +++++++----------------------------------------
>  4 files changed, 201 insertions(+), 412 deletions(-)
>

For Amiga zorro-esp:

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
