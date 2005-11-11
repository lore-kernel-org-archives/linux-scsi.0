From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/1] cciss: scsi error handling
Date: Fri, 11 Nov 2005 06:36:28 -0500
Message-ID: <4374823C.1090704@pobox.com>
References: <20051104183037.GA8527@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750756AbVKKLgl@vger.kernel.org>
In-Reply-To: <20051104183037.GA8527@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.miller@hp.com
Cc: axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, steve.cameron@hp.com
List-Id: linux-scsi@vger.kernel.org

mike.miller@hp.com wrote:
> PATCH 1 of 1
> 
> This patch adds SCSI error handling code to the SCSI portion 
> of the cciss driver.
> 
> Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
> Acked-by: Mike Miller <mike.miller@hp.com>

> +#ifdef CONFIG_CISS_SCSI_TAPE

Two comments:

1) CONFIG_CISS_SCSI_TAPE should be CONFIG_CCISS_SCSI_TAPE, IMO

2) is any locking needed in your scsi eh reset handlers?  recent kernels 
eliminate the lock that's been traditionally held around the handlers.

	Jeff
