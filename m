From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Update][PATCH] SCSI / PM: Replace CONFIG_PM_RUNTIME with
 CONFIG_PM
Date: Mon, 15 Dec 2014 00:22:39 -0800
Message-ID: <20141215082239.GB24067@infradead.org>
References: <3237237.IIIiULdqDt@vostro.rjw.lan>
 <3039454.iyzHXUp3Uj@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3039454.iyzHXUp3Uj@vostro.rjw.lan>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 09, 2014 at 10:47:47PM +0100, Rafael J. Wysocki wrote:
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Feel free to add it to the linux-pm tree.

Acked-by: Christoph Hellwig <hch@lst.de>
