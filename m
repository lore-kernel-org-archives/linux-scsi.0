From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Mon, 11 Jun 2007 20:59:46 -0700
Message-ID: <466E1A32.90306@linux.intel.com>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070612035928.GB9808@khazad-dum.debian.net>
Sender: linux-ide-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeff Garzik <jeff@garzik.org>, =?ISO-8859-1?Q?Dagfinn_Ilmari_Mann?= =?ISO-8859-1?Q?s=E5ker?= <ilmari@ilmari.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 11 Jun 2007, Jeff Garzik wrote:
>>>> on/off doesn't really make sense if the question is "do you favor power
>>>> or do you favor performance".......
> 
> Actually, it does if you think of it as "do you need hotplug right now or
> not?".

that's a temporary shortcoming; even with these power savings you can 
do hotplug as long as you're willing to poll for it at a reasonable 
interval and are willing to wait the time between polls for a hotplug 
to take effect..
