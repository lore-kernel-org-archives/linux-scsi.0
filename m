From: Oliver Neukum <oliver@neukum.org>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: Tue, 5 Oct 2004 17:49:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200410051749.22245.oliver@neukum.org>
References: <1096401785.13936.5.camel@localhost.localdomain> <4162B345.9000806@rtr.ca> <1096988167.2064.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269158AbUJEQAe@vger.kernel.org>
In-Reply-To: <1096988167.2064.7.camel@mulgrave>
Content-Disposition: inline
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Lord <lsml@rtr.ca>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 5. Oktober 2004 16:56 schrieb James Bottomley:
> On Tue, 2004-10-05 at 09:44, Mark Lord wrote:
> > There seem to be other holes/races in this and related code.
> > 
> > The QStor driver implements hot insertion/removal of drives.
> > 
> > One thing it has to cope with at present is, after notifying
> > the mid-layer that a drive has been removed, the mid-layer calls
> > back with a synchronize-cache command for that drive..
> 
> This is expected behaviour.  For orderly removal an cache sync command
> must be sent to drives with a writeback cache before they're powered
> down.  For forced ejection, the driver has to error the command.

Then let the driver tell the upper layers whether the device is still
connected or not.

	Regards
		Oliver
