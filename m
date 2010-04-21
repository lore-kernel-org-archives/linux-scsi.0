From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 08:09:51 -0700 (PDT)
Message-ID: <515715.64668.qm@web31814.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, "<linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, "<Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org>" <Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, "<linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Apr 21, 2010, at 7:31, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:

On Wed, 21 Apr 2010, Luben Tuikov wrote:

The real problem with the Buffalo drive is that it
responds with a
phase error when it receives an ATA_16 IDENTIFY DEVICE
command with the
Sector Count field set to 0.

The Sector Count field in the ATA PASS-THROUGH (12) or (16) CDB
should be set appropriately by the Application Client as the neither
the SAT bridge nor the SATA transport will interpret the ATA Command
byte. Thus, for IDENTIFY (PACKET) DEVICE the Application Client
should set it to 1.

Why do you say that 1 is the appropriate value?  In the ATA-5 spec
(which is the most recent version I have) Sector Count is listed as
"na" for IDENTIFY DEVICE, which means that the content of that field is
not applicable to this particular command.  Hence the value shouldn't 
matter.

It is needed by the transport protocol(s). 

      Luben



Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
