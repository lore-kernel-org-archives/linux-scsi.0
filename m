From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Updated osst driver for 2.6.x
Date: Tue, 23 Dec 2003 19:26:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031223192626.A10262@infradead.org>
References: <20031223174320.GU1277@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:56337 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262126AbTLWT02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2003 14:26:28 -0500
Content-Disposition: inline
In-Reply-To: <20031223174320.GU1277@linnie.riede.org>; from wrlk@riede.org on Tue, Dec 23, 2003 at 12:43:20PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 23, 2003 at 12:43:20PM -0500, Willem Riede wrote:
> - Supports a proc file for each drive (/proc/scsi/osst/osstX) which provides
>   ADRversion_major.minor linux_media_version first_data_ppos eod_frame_ppos filemrk_cnt

Please don't.  This is exactly what sysfs is for.

