From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uas: disable UAS on Apricorn SATA dongles
Date: Fri, 12 Dec 2014 09:22:38 -0500
Message-ID: <20141212142238.GA1888@kroah.com>
References: <20141211190111.GD21955@birch.djwong.org>
 <548AC684.3020801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <548AC684.3020801@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 12, 2014 at 11:42:12AM +0100, Hans de Goede wrote:
> <Adding Greg and stable to the cc>
> 
> On 11-12-14 20:01, Darrick J. Wong wrote:
> >The Apricorn SATA dongle will occasionally return "USBSUSBSUSB" in
> >response to SCSI commands when running in UAS mode.  Therefore,
> >disable UAS mode on this dongle.
> >
> >Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks good:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> Greg, can you add this to your tree please ?

Sure, will queue up after 3.19-rc1 is out.

thanks,

greg k-h
