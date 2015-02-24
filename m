From: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH v2 1/1] linux-firmware: Add QLogic BR Series Adapter
 Firmware
Date: Tue, 24 Feb 2015 12:58:41 -0500
Message-ID: <20150224175841.GO30928@merlin.infradead.org>
References: <1424218220-28837-1-git-send-email-rasesh.mody@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424218220-28837-1-git-send-email-rasesh.mody@qlogic.com>
Sender: netdev-owner@vger.kernel.org
To: Rasesh Mody <rasesh.mody@qlogic.com>
Cc: linux-firmware@kernel.org, NetDev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 17, 2015 at 07:10:20PM -0500, Rasesh Mody wrote:
> This patch rebrands the BFA/BNA inbox driver firmwares.
> This patch adds 3.2.5.1 firmware files for QLogic BR-series Adapters that will
> be used with the inbox drivers(BFA and BNA).
> 
> Signed-off-by: Rasesh Mody <rasesh.mody@qlogic.com>
> ---
>  WHENCE            |  13 +++++++++----
>  cbfw-3.2.5.1.bin  | Bin 0 -> 414480 bytes
>  ct2fw-3.2.5.1.bin | Bin 0 -> 584216 bytes
>  ctfw-3.2.5.1.bin  | Bin 0 -> 539144 bytes
>  4 files changed, 9 insertions(+), 4 deletions(-)
>  create mode 100644 cbfw-3.2.5.1.bin
>  create mode 100644 ct2fw-3.2.5.1.bin
>  create mode 100644 ctfw-3.2.5.1.bin
> 

Thanks, applied. Any chance on the next update of the firmware we could
move to putting new files under qlogic/*.bin?

regards, Kyle
