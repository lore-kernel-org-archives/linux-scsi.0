From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sat, 29 Mar 2003 23:50:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303292350.04187.oliver@neukum.org>
References: <20030325100704.GC3868@beaverton.ibm.com> <20030329125302.A10565@one-eyed-alien.net> <1048974903.21704.313.camel@mulgrave>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1048974903.21704.313.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Am Samstag, 29. M=E4rz 2003 22:54 schrieb James Bottomley:
> On Sat, 2003-03-29 at 14:53, Matthew Dharm wrote:
> > My understanding was that I couldn't call set_device_offline with t=
he
> > host lock held, which is a problem because I need the host lock to
> > traverse the device list.
>
> The solution we're talking about here is from the user level hotplug
> scripts.  Once we get the remove-single-device fixed, you simply use =
the
> device hot unplug script to traverse the attached SCSI devices, clean=
 up
> the user land (kill processes, unmount filesystems etc.) and then blo=
w
> the devices away.  After the host has no devices, you should simply b=
e
> able to trigger a host removal from within your driver.

It seems you are still trying this overcomplicated going through
user space and back thing.
There's no benefit at all in this. If you make this work you can just
as well make a straightforward thing work. Which will not be a nightmar=
e
to make work right under all circumstances.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
