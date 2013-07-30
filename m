From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 25/36] SCSI: sd: convert class code to use dev_groups
Date: Tue, 30 Jul 2013 19:22:16 +0000
Message-ID: <1375212127.2065.20.camel@dabdike.int.hansenpartnership.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
	 <1374703539-9705-26-git-send-email-gregkh@linuxfoundation.org>
	 <1375200711.2065.10.camel@dabdike.int.hansenpartnership.com>
	 <20130730190129.GC25353@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:33735 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3G3TWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 15:22:16 -0400
In-Reply-To: <20130730190129.GC25353@kroah.com>
Content-Language: en-US
Content-ID: <E9B67C2971EE8D40A0C010483B1851FA@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2013-07-30 at 12:01 -0700, Greg Kroah-Hartman wrote:
> On Tue, Jul 30, 2013 at 04:11:52PM +0000, James Bottomley wrote:
> > On Wed, 2013-07-24 at 15:05 -0700, Greg Kroah-Hartman wrote:
> > > The dev_attrs field of struct class is going away soon, dev_groups
> > > should be used instead.  This converts the scsi disk class code to use
> > > the correct field.
> > > 
> > > It required some functions to be moved around to place the show and
> > > store functions next to each other, the old order seemed to make no
> > > sense at all.
> > > 
> > > Cc: James E.J. Bottomley <JBottomley@parallels.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > > 
> > > James, feel free to take this through your tree, or ACK it and I can
> > > take it through mine.
> > 
> > Just found this ... I have the stable folder rule be git-send-email and
> > from you, so it picks up your patches as well.
> 
> It seems you aren't the only one who has procmail rules for my emails :)

It's not that I don't like you, I procmail it to a different folder
because of mobile phones: my inbox is about 50 deep and a stable patch
run can basically empty the cache ... this can be damn annoying if your
hotel reservation is number 51.

> I wonder if I need to start sending my stable stuff out from a different
> email address...

You don't need a different address, just use a different tag.  I tag all
SCSI git email with 

X-Git-Tree: SCSI

Ben Hutchings tags all his stable email with:

X-mailer: LinuxStableQueue (scripts by bwh)

and so on ... any header tag does ... I'm sure git-send-email can be
persuaded to add a more meaningful one.

> > I'll take it through my tree, just in case we're mucking about with
> > attributes this cycle around.
> 
> That's fine with me, thanks.

OK, adding it to the testing queue now.

James

