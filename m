From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Subject: RE: [PATCH v2] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Tue, 12 Aug 2014 06:28:39 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2B40D@EU-MBX-02.mgc.mentorg.com>
References: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140812060153.GB13231@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140812060153.GB13231@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>, "kraxel@redhat.com" <kraxel@redhat.com>, "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Done !

Thanks
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, August 12, 2014 11:32 AM
To: Sharma, Sanjeev
Cc: hdegoede@redhat.com; kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

On Tue, Aug 12, 2014 at 11:38:37AM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and 
> therefore it would be advise to replace with lockdep_assert_held().

Add "on some architectures" in here somewhere, as it's not broken on the large majority of UP cpus :)

thanks,

greg k-h
