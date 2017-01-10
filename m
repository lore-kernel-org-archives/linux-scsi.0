From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: qedi: select UIO
Date: Tue, 10 Jan 2017 19:44:30 +0100
Message-ID: <20170110184430.GA4156@linux-x5ow.site>
References: <20170110152744.3139180-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110152744.3139180-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@cavium.com, Nilesh Javali <nilesh.javali@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Manish Rangankar <manish.rangankar@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 10, 2017 at 04:27:29PM +0100, Arnd Bergmann wrote:
> The newly added qedi driver links against the UIO framework, but can
> be built without that:
> 
> drivers/scsi/qedi/qedi_main.o: In function `qedi_free_uio':
> qedi_main.c:(.text.qedi_free_uio+0x78): undefined reference to `uio_unregister_device'
> drivers/scsi/qedi/qedi_main.o: In function `qedi_ll2_recv_thread':
> qedi_main.c:(.text.qedi_ll2_recv_thread+0x18c): undefined reference to `uio_event_notify'
> drivers/scsi/qedi/qedi_main.o: In function `__qedi_probe.constprop.1':
> qedi_main.c:(.text.__qedi_probe.constprop.1+0x1368): undefined reference to `__uio_register_device'
> 
> This adds a compile-time dependency.
> 
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks OK,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
