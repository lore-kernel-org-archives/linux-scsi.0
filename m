From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Mon, 1 Jul 2002 15:59:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020701155928.H776@redhat.com>
References: <20020701151553.G776@redhat.com> <Pine.BSF.4.21.0207011221020.62375-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0207011221020.62375-100000@beppo>; from mjacob@feral.com on Mon, Jul 01, 2002 at 12:23:56PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: =?iso-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Mon, Jul 01, 2002 at 12:23:56PM -0700, Matthew Jacob wrote:
> Fibre. Devices 'go away' for shortish to longish periods of time on Fibre (or
> iSCSI for that matter). Lacking a sane framework that is USB-like about
> hotpluggable that does *not* cause complete system spasm when this happens
> (and it happens a lot), what one wants is a bit of hysteresis to give the
> disks that went away a chance to log back into the fabric and thus appear
> again (as if they had never gone).

(I knew this, but it had slipped my mind).  This reminds me of something I 
was thinking about for the mid layer code stuff.  Does FreeBSD have it's 
drivers declare their connection method anywhere?  It seems to me there 
are a limited number of connection specific details that the mid layer 
would benefit from being aware of (for example > 8 luns on SCSI-2 fiber 
devices, but not on SCSI-2 SPI devices, the selection timeout issue you 
just raised with transient disk loss which should not happen on SPI, 
things like that).  Does the FreeBSD mid layer do anything with that sort 
of information?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
