From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 25/36] SCSI: sd: convert class code to use dev_groups
Date: Tue, 30 Jul 2013 12:01:29 -0700
Message-ID: <20130730190129.GC25353@kroah.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-26-git-send-email-gregkh@linuxfoundation.org>
 <1375200711.2065.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375200711.2065.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 30, 2013 at 04:11:52PM +0000, James Bottomley wrote:
> On Wed, 2013-07-24 at 15:05 -0700, Greg Kroah-Hartman wrote:
> > The dev_attrs field of struct class is going away soon, dev_groups
> > should be used instead.  This converts the scsi disk class code to use
> > the correct field.
> > 
> > It required some functions to be moved around to place the show and
> > store functions next to each other, the old order seemed to make no
> > sense at all.
> > 
> > Cc: James E.J. Bottomley <JBottomley@parallels.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > 
> > James, feel free to take this through your tree, or ACK it and I can
> > take it through mine.
> 
> Just found this ... I have the stable folder rule be git-send-email and
> from you, so it picks up your patches as well.

It seems you aren't the only one who has procmail rules for my emails :)

I wonder if I need to start sending my stable stuff out from a different
email address...

> I'll take it through my tree, just in case we're mucking about with
> attributes this cycle around.

That's fine with me, thanks.

greg k-h
