From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to disconnect a SCSI device without crashing SLES8?
Date: Fri, 4 Feb 2005 21:06:11 +0000
Message-ID: <20050204210611.GA25619@infradead.org>
References: <20050204202501.GA25126@infradead.org> <15ae01c50af9$42f42c40$650aa8c0@ehrpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:59538 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263369AbVBDVGS (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 16:06:18 -0500
Content-Disposition: inline
In-Reply-To: <15ae01c50af9$42f42c40$650aa8c0@ehrpc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Raskin <eraskin@paslists.com>
Cc: Linux-scsi@vger.kernel.org

On Fri, Feb 04, 2005 at 03:36:48PM -0500, Eric Raskin wrote:
> Thanks, Christoph.  Would we use the same commands on 2.6?

They still work if CONFIG_SCSI_PROC_FS is enabled.  Always available
and easier to use is to do echo "1" > /sys/device/N:N:N:N/device/delete
where N:N:N:N is bus, channel, target, lun of the device to be deleted.

