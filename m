From: Karsten Keil <keil@b1-systems.de>
Subject: Re: [PATCH 11/13] pcmcia: pcmcia_request_window() doesn't need a pointer to a pointer
Date: Fri, 13 Nov 2009 13:21:17 +0100
Message-ID: <200911131321.17363.keil@b1-systems.de>
References: <20091111203303.GA7939@comet.dominikbrodowski.net> <1257971899-9274-11-git-send-email-linux@dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1257971899-9274-11-git-send-email-linux@dominikbrodowski.net>
Sender: netdev-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
List-Id: linux-scsi@vger.kernel.org

On Mittwoch, 11. November 2009 21:38:17 Dominik Brodowski wrote:
> pcmcia_request_window() only needs a pointer to struct pcmcia_device, not
> a pointer to a pointer.
> 
> CC: netdev@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-scsi@vger.kernel.org
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Karsten Keil <isdn@linux-pingi.de>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/char/pcmcia/ipwireless/main.c         |    4 ++--
>  drivers/isdn/hisax/sedlbauer_cs.c             |    2 +-
For  ISDN 

Acked-by: Karsten Keil <keil@b1-systems.de>
