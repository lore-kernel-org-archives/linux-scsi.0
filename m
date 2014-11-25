From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] wd719x: Introduce Western Digital
 WD7193/7197/7296 PCI SCSI card driver
Date: Tue, 25 Nov 2014 06:44:13 -0800
Message-ID: <20141125144413.GB22764@infradead.org>
References: <1416867882-29344-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416867882-29344-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Thanks, applied the series to drivers-for-3.19.

I had to add an include of <linux/interrupt.h> to make it compile on my
setup, though.
