From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: aic7xxx_biosparam
Date: 18 Nov 2002 00:57:20 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037581040.5855.0.camel@irongate.swansea.linux.org.uk>
References: <20021118002742.GO3280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021118002742.GO3280@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2002-11-18 at 00:27, Doug Ledford wrote:
> So, this is the change I made to update it so that it won't puke on large 
> devices.  It seems to be working OK for me, but I didn't check the gcc 
> assembly output to see if it's horrible.  Unless someone tells me I'm 
> smoking crack for making this change, I'll submit it pretty soon (I don't 
> consider myself a partition expert, I'm just trying to make sure that when 
> geometry does get defined on my driver that it at least is something the 
> Adaptec BIOS will accept, and the Adaptec BIOS *only* accepts the two 
> listed head/sector combos).

What about using sector_div ?

