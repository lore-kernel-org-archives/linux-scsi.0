From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 13:22:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2D8FF5.9010102@splentec.com>
References: <10426732153816@kroah.com> <200301210817.12096.oliver@neukum.name> <3E2D35B7.4070909@torque.net> <200301211448.37377.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: dougg@torque.net, Alan <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
 >
> So a disconnection would look like this:
> 
1.
> scsi_set_offline_host(...);
2.
> synchronize_kernel();
3.
> error_queied_commands(...);
4.
> scsi_remove_host();

Not quite.  You want to do 3 before 2, to get 2 going as soon
as possible.  Futhermore, 3 is partly in LLDD.  1 would
take care of 3 in SCSI Core.  See my previous (by date) post.

-- 
Luben



