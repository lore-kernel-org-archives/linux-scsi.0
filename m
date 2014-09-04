From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Subject: RE: [PATCH v3] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Thu, 4 Sep 2014 07:06:34 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF478F0@EU-MBX-04.mgc.mentorg.com>
References: <yes>
 <1407825621-23322-1-git-send-email-sanjeev_sharma@mentor.com>
 <53E9B418.3050303@redhat.com>
 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDA2@EU-MBX-02.mgc.mentorg.com>
 <20140819093047.GA991@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140819093047.GA991@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "kraxel@redhat.com" <kraxel@redhat.com>, "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, August 19, 2014 3:01 PM
To: Sharma, Sanjeev
Cc: kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Hans de Goede
Subject: Re: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

On Tue, Aug 19, 2014 at 06:33:04AM +0000, Sharma, Sanjeev wrote:
> Hi Greg,
> 
> Any feedback on this patch ?

The merge window ended 2 days ago, _and_ I'm at the kernel summit this week, _and_ my queue is currently sitting at:
	$ mdfrm -c ~/mail/todo/
	1317 messages in /home/gregkh/mail/todo/

So please be patient.  I'll get to it in a few weeks.

Please let me know when this is going to be merged ?

Thanks
Sanjeev

greg k-h
