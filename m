From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] Feiya 5-in-1 Card Reader
Date: Wed, 4 Sep 2002 14:44:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020904214402.GA8368@kroah.com>
References: <UTC200208312329.g7VNTwF11470.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200208312329.g7VNTwF11470.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 01, 2002 at 01:29:58AM +0200, Andries.Brouwer@cwi.nl wrote:
> 
> Without the patch the kernel crashes, or insmod usb-storage hangs.
> With the patch the CF part of the device works perfectly.

Matt, is it ok with you for me to add this patch to the tree?

thanks,

greg k-h
