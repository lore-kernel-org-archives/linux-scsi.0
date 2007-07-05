From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Date: Thu, 5 Jul 2007 15:33:34 -0700
Message-ID: <20070705153334.08402809.akpm@linux-foundation.org>
References: <20070705194909.337398431@intel.com>
	<20070705130530.5873afeb.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070705130530.5873afeb.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 5 Jul 2007 13:05:30 -0700
Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

> +	ATA_DFLAG_IPM		= (1 << 6), /* device supports interface PM */
>  	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,

I had to bump this to (1<<7), so we've run out.
