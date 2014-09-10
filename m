From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 20/21] uas: Remove support for old sense ui as used in
 pre-production hardware
Date: Wed, 10 Sep 2014 16:06:44 +0200
Message-ID: <1410358004.12706.29.camel@linux-fkkt.site>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-21-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410349611-17573-21-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
> I've access to a number of different uas devices now, and none of them use
> old style sense urbs. The only case where these code-paths trigger is with
> the asm1051 and there they do the wrong thing, as the asm1051 sends 8 bytes
> status iu-s when it does not have any sense data, but uses new style
> sense iu-s regardless, as can be seen for scsi cmnds where there is sense
> data.

This looks like a bad idea over all. The version is in the spec.
And you might see true USB<->SCSI bridges passing through the
sense data.

	Regards
		Oliver
