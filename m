From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 06 Jan 2003 16:16:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E19F223.4020208@splentec.com>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net> <3E19EBC4.6000601@splentec.com> <20030106130547.E13916@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

Matthew Dharm wrote:
> I'm told this is a bad idea because there are some HBA which snoop the
> INQUIRY data.  Since I don't know how that snooping works, I can't comment
> further.

I do, in my own LLDDs. If anything the additional length might increase.
Others snoop it for their own awareness of the device and personal gains
to possibly result in better service to the actual device.

I cannot see how this could fail.

-- 
Luben


