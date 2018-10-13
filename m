From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] esp_scsi: De-duplicate PIO routines
Date: Sat, 13 Oct 2018 00:05:08 -0700
Message-ID: <20181013070508.GA15008@infradead.org>
References: <cover.1539391876.git.fthain@telegraphics.com.au>
 <09d3a141dc16af63921f5414263069e9b4f97222.1539391876.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <09d3a141dc16af63921f5414263069e9b4f97222.1539391876.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +#if IS_ENABLED(CONFIG_SCSI_MAC_ESP) || IS_ENABLED(CONFIG_SCSI_ZORRO_ESP)

Please add a new CONFIG_SCSI_ESP_PIO symbol that is selected by
the mac and zorro drivers instead.

> +	pr_err("FIFO is empty (sreg %02x)\n", esp_read8(ESP_STATUS));

This should probably use dev_err (at least with my series).
