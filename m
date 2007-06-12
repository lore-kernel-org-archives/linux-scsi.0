From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Date: Mon, 11 Jun 2007 22:11:48 -0300
Message-ID: <20070612011148.GA9808@khazad-dum.debian.net>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758095AbXFLBMZ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070611114839.907bcae2.kristen.c.accardi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
> Setting		Effect
> ----------------------------------------------------------
> min_power	ALPM is enabled, and link set to enter 
> 		lowest power state (SLUMBER) when idle
> 		Hot plug not allowed.
> 
> max_performance	ALPM is disabled, Hot Plug is allowed
> 
> medium_power	ALPM is enabled, and link set to enter
> 		second lowest power state (PARTIAL) when
> 		idle.  Hot plug not allowed.

Just some food for thought:

If you split it into a enable/disable (0/1) attribute, and a level attribute
(some sort of integer scale, or "min", "medium", "max" if you must use
strings.  You could use four levels to mimic the PCI device power state, for
example), it might make its usage more generic, and easier from userspace,
as it decouples the need to turn it on/off from the need to know which level
the user wants it set to when you turn it on.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
