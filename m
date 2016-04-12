From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 2/2] USB: uas: Add a new NO_REPORT_LUNS quirk
Date: Tue, 12 Apr 2016 11:09:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1604121109240.1826-100000@iolanthe.rowland.org>
References: <1460456829-20933-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1460456829-20933-2-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>, David Webb <djw@noc.ac.uk>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Apr 2016, Hans de Goede wrote:

> Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
> an usb-id of: 0bc2:331a, as these will fail to respond to a
> REPORT_LUNS command.
> 
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: David Webb <djw@noc.ac.uk>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Document new j quirk in Documentation/kernel-parameters.txt

Acked-by: Alan Stern <stern@rowland.harvard.edu>
