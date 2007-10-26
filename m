From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Date: Fri, 26 Oct 2007 09:46:10 -0500
Message-ID: <20071026094610.37defcb3@weaponx.rchland.ibm.com>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-serial-owner@vger.kernel.org>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Sender: linux-serial-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org, rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com, benh@kernel.crashing.org, paulus@samba.org, dmitry.torokhov@gmail.com, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org, bryan.wu@analog.com, adaplas@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 26 Oct 2007 05:40:22 -0400 (EDT)
Jeff Garzik <jeff@garzik.org> wrote:

> mostly in and around irq handlers.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---

>  drivers/serial/uartlite.c                  |    2 +-

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com
