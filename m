From: Mark Lord <mlord@pobox.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 29 Apr 2010 08:56:23 -0400
Message-ID: <4BD981F7.2080503@pobox.com>
References: <Pine.LNX.4.44L0.1004201533220.1837-100000@iolanthe.rowland.org>
 <4BCF0605.7080508@pobox.com> <4BCF4120.4060806@pobox.com>
 <4BCF4394.3080701@gmail.com> <20100426161336.GA3889@xanatos>
 <4BD946E3.9030303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:38340 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab0D3Qvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 12:51:31 -0400
In-Reply-To: <4BD946E3.9030303@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On 29/04/10 04:44 AM, Jonas Schwertfeger wrote:
> Sorry for the delay.  Attached are both a USB3 and a USB2 dmesg log of
> running the latest version of hpdarm.
..


I'm not entirely sure _what_ you were tracing here,
but it appears that the ATA IDENTIFY DEVICE command (0xec)
succeeded in both instances, USB2 and USB3.
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
