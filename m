From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] show "Fusion MPT device support" menu only if BLK_DEV_SD
Date: Wed, 21 Jan 2004 00:08:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040121000810.A23862@infradead.org>
References: <20040120232507.GC6441@fs.tum.de> <20040120233537.A23375@infradead.org> <20040120160346.7e466ad2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:9740 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265865AbUAUAIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 19:08:13 -0500
Content-Disposition: inline
In-Reply-To: <20040120160346.7e466ad2.akpm@osdl.org>; from akpm@osdl.org on Tue, Jan 20, 2004 at 04:03:46PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: bunk@fs.tum.de, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 04:03:46PM -0800, Andrew Morton wrote:
>           [2] In order enable capability to boot the linux kernel
>           natively from a Fusion MPT target device, you MUST
>           answer Y here! (currently requires CONFIG_BLK_DEV_SD)

Well, that's true for any LLDD.

