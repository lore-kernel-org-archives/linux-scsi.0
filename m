From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: UFS utilities
Date: Tue, 5 Dec 2017 16:49:56 +0100
Message-ID: <20171205154956.GB6264@kroah.com>
References: <95e2fba3abb6447ba741b6235dd2e375@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <95e2fba3abb6447ba741b6235dd2e375@SIWEX5A.sing.micron.com>
Sender: stable-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 03:44:19PM +0000, Bean Huo (beanhuo) wrote:
> Hi, greg k-h
> 
> >
> >So what UFS commands are you missing that you need to see implemented?
> >
> >And again, have you checked the different forks of the driver?
> >
> 
> Seems there is something misunderstood, I want to use UPIU, rather than CDB.
> Maybe it is not possible based on current UFS stacks. Of course, exactly, 
> there is no missing SCSI command listed in UFS 2.1.

Again, have you looked at the different forks out there?  I bet you can
already do this...

If not, I'm sure simple patches should be able to add the missing
functionality, it would be good to get a solid UFS driver one of these
days in the tree :)

thanks,

greg k-h
