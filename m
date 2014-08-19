From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Tue, 19 Aug 2014 04:30:47 -0500
Message-ID: <20140819093047.GA991@kroah.com>
References: <yes>
 <1407825621-23322-1-git-send-email-sanjeev_sharma@mentor.com>
 <53E9B418.3050303@redhat.com>
 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDA2@EU-MBX-02.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaHSJb2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 05:31:28 -0400
Content-Disposition: inline
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE94DF2FDA2@EU-MBX-02.mgc.mentorg.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: "kraxel@redhat.com" <kraxel@redhat.com>, "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>

On Tue, Aug 19, 2014 at 06:33:04AM +0000, Sharma, Sanjeev wrote:
> Hi Greg,
> 
> Any feedback on this patch ?

The merge window ended 2 days ago, _and_ I'm at the kernel summit this
week, _and_ my queue is currently sitting at:
	$ mdfrm -c ~/mail/todo/
	1317 messages in /home/gregkh/mail/todo/

So please be patient.  I'll get to it in a few weeks.

greg k-h
