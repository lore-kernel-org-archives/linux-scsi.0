From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination
 (v4)
Date: Tue, 24 Apr 2018 09:25:11 +0200
Message-ID: <20180424072511.GA18419@kroah.com>
References: <20161110135443.GA28767@kroah.com>
 <1478788527-7372-1-git-send-email-andrey2805@gmail.com>
 <CAK=zhgpUo-t=xBm93NmBf6q-VD01C2s7mqFOy-C7Vo=WABGvSw@mail.gmail.com>
 <9C0A3C06154E83419DE77BA0861EAE4F011467C3A0@MCMAIL.media-clone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9C0A3C06154E83419DE77BA0861EAE4F011467C3A0@MCMAIL.media-clone.com>
Sender: stable-owner@vger.kernel.org
To: Igor Rybak <igor@media-clone.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Andrey Grodzovsky <andrey2805@gmail.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Ezra Kohavi <ezra@media-clone.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 23, 2018 at 06:28:03PM +0000, Igor Rybak wrote:
> Hi,
> 
> We are running kernel 4.4.0-22 and the patch below does not seem to be present in the mpt3sas driver. Can you please confirm?

Please update your kernel, this patch was in the 4.4.36 kernel release
which came out December 2, 2016, well over a full year ago.

thanks,

greg k-h
