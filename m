From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG.
Date: Mon, 13 Jul 2009 15:43:12 -0400
Message-ID: <19035.36432.181354.977939@stoffel.org>
References: <1247513973-24899-1-git-send-email-john@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:54365 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZGMTnP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 15:43:15 -0400
In-Reply-To: <1247513973-24899-1-git-send-email-john@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

Dammit, I messed up here sending this patch.  I've just edited the
subject line and re-sent it with a bit more description.  I think this
patch is perfectly good to go into 2.6.31 right now, esp since it's
not changing code, just whether the code is turned on by default from
now on.

Thanks,
John


John> Signed-off-by: John Stoffel <john@stoffel.org>
John> ---
John>  block/Kconfig |   11 +++++++----
John>  1 files changed, 7 insertions(+), 4 deletions(-)

John> diff --git a/block/Kconfig b/block/Kconfig
John> index e7d1278..55bbefc 100644
John> --- a/block/Kconfig
John> +++ b/block/Kconfig
John> @@ -45,9 +45,9 @@ config LBD
John>  	  If unsure, say N.
 
John>  config BLK_DEV_BSG
John> -	bool "Block layer SG support v4 (EXPERIMENTAL)"
John> -	depends on EXPERIMENTAL
John> -	---help---
John> +	bool "Block layer SG support v4"
John> +	default y
John> +	help
John>  	  Saying Y here will enable generic SG (SCSI generic) v4 support
John>  	  for any block device.
 
John> @@ -57,7 +57,10 @@ config BLK_DEV_BSG
John>  	  protocols (e.g. Task Management Functions and SMP in Serial
John>  	  Attached SCSI).
 
John> -	  If unsure, say N.
John> +	  This option is required by recent UDEV versions to properly 
John> +	  access device serial numbers, etc.
John> +
John> +	  If unsure, say Y.
 
John>  config BLK_DEV_INTEGRITY
John>  	bool "Block layer data integrity support"
John> -- 
John> 1.6.3.3
