From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: Determining the UUID of a USB storage device
Date: Fri, 23 Aug 2002 10:45:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020823084544.GA5649@win.tue.nl>
References: <20BF5713E14D5B48AA289F72BD372D6812BB32@AUSXMPC122.aus.amer.dell.com> <20020822162640.E17378@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020822162640.E17378@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Gary_Lerhaupt@dell.com, linux-scsi@vger.kernel.org


> > I am attempting to glean some sort of a unique identifier from a USB storage
> > device.  As it should, the storage shows up as a SCSI disk in
> > /proc/partitions and subsequent SCSI inquiries sent to it return a page 80
> > serial number.  However, it is apparent that this serial number is actually
> > the serial number of my ZIO! smartmedia reader and not of the actual card in
> > the reader.

My SmartMedia code will report on whether a card serial number is supported.
I think the command to actually read a card serial number is secret.

See e.g. sddr09_read_deviceID() and sddr09_get_cardinfo() in sddr09.c.

        /* Byte 2 is code to signal availability of 128-bit ID */
        if (deviceID[2] == 0xa5) {
                sprintf(blurbtxt + strlen(blurbtxt),
                        ", 128-bit ID");
        }

Andries
