From: Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 02 Apr 2010 17:24:07 -0400
Message-ID: <4BB66077.3060202@pobox.com>
References: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org>
 <4BB61237.5030000@ru.mvista.com> <4BB61975.1070406@interlog.com>
 <4BB61DAF.7090709@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB61DAF.7090709-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Cc: Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>> Confirming that, what is put in the ATA_16 sector
>> count field is what the ATA command (IDENTIFY DEVICE)
>> expects in its count field. And according to ACS-2 (rev 2)
>> for IDENTIFY DEVICE that is "N/A" which I would
>> interpret as zero.
>
> Ouch. Reviewing that "N/A" in the ATA spec: it means
> that neither the host nor device should check that
> field. So it could be any value, in this case 1.
..

I'll update hdparm (version 9.29) to supply a sector count of "1"
for IDENTIFY commands, just to satisfy the buggy bridge chip.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
