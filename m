From: Chase Venters <chase.venters@clientec.com>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Sat, 28 Jan 2006 13:46:48 -0600
Message-ID: <200601281347.10531.chase.venters@clientec.com>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz> <87ek2td4i9.fsf@amaterasu.srvr.nix> <20060128192714.GI9750@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060128192714.GI9750@suse.de>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Nix <nix@esperi.org.uk>, Ariel <askernel2615@dsgml.com>, Jamie Heilman <jamie@audible.transient.net>, Arjan van de Ven <arjan@infradead.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Saturday 28 January 2006 13:26, Jens Axboe wrote:
> It's not a bad data point, it just confirms that setting ->ordered_flush
> to 0 in the SATA drivers will fix the leak. So really, it's as expected.
> So far apparently nobody tried it, suggested it twice.

In case you still wanted the data point, I just set ordered_flush to 0 on my 
ata_piix and the slab leak disappeared.

Thanks,
Chase
