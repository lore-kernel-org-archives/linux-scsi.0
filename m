From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to disconnect a SCSI device without crashing SLES8?
Date: Fri, 4 Feb 2005 20:25:01 +0000
Message-ID: <20050204202501.GA25126@infradead.org>
References: <156801c50aed$2348aee0$650aa8c0@ehrpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:20370 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266412AbVBDUZD (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 15:25:03 -0500
Content-Disposition: inline
In-Reply-To: <156801c50aed$2348aee0$650aa8c0@ehrpc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Raskin <eraskin@paslists.com>
Cc: Linux-scsi@vger.kernel.org

On Fri, Feb 04, 2005 at 02:12:13PM -0500, Eric Raskin wrote:
> In searching the web, I've found the "remove-scsi-device" and
> "add-scsi-device" commands that can be sent to /proc/scsi/scsi.
> 
> Does anybody know if the system will stay up if I use these commands to
> remove all my tape library devices before shutting it down?  Is this the
> proper way to repair my library without having to shut the system off?

remove-scsi-device could work, but in Linux 2.4 it's racy.

If you want to remove and add devices at runtime safely you'll have to
update to Linux 2.6.

