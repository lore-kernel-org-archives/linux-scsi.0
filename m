From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 8/12] repost: cciss: remove unused revalidate_allvol function
Date: Mon, 6 Nov 2006 21:32:15 +0100
Message-ID: <20061106203214.GH19471@kernel.dk>
References: <20061106202352.GH17847@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:13070 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1753746AbWKFUaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 15:30:07 -0500
Content-Disposition: inline
In-Reply-To: <20061106202352.GH17847@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 06 2006, Mike Miller (OS Dev) wrote:
> PATCH 8/12
> 
> This patch removes the no longer used revalidate_allvol function. It was
> replaced by rebuild_lun_table.
> Please consider this for inclusion.

Ack 7-8.

-- 
Jens Axboe

