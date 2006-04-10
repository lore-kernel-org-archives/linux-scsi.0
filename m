From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/1] cciss: bug fix for crash when running hpacucli
Date: Mon, 10 Apr 2006 15:38:00 -0700
Message-ID: <20060410153800.3c018fc1.akpm@osdl.org>
References: <20060410202541.GA28328@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:129 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932191AbWDJXl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 19:41:59 -0400
In-Reply-To: <20060410202541.GA28328@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, steve.cameron@hp.com

"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
>
> This patch fixes a crash when running hpacucli with multiple logical volumes
>  on a cciss controller. We were not properly initializing the disk->queue
>  and causing a fault.

Please confirm that this is safe&appropriate for backporting into 2.6.16.x?
