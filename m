From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH SCSI] sr: check_events() ignore GET_EVENT when TUR says
 otherwise
Date: Wed, 20 Jul 2011 09:45:16 -0700
Message-ID: <1311180316.8570.1.camel@mulgrave>
References: <20110630130348.GQ3386@htj.dyndns.org>
	 <20110720163308.GC9924@mtj.dyndns.org>
	 <CAPXgP11R=386wbqpOpymzdXYYhpvJg9Aj1Xck3wi91smud-8iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <CAPXgP11R=386wbqpOpymzdXYYhpvJg9Aj1Xck3wi91smud-8iA@mail.gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, maggu2810@googlemail.com, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-07-20 at 18:42 +0200, Kay Sievers wrote:
> On Wed, Jul 20, 2011 at 18:33, Tejun Heo <tj@kernel.org> wrote:
> > On Thu, Jun 30, 2011 at 03:03:48PM +0200, Tejun Heo wrote:
> >> From: Kay Sievers <kay.sievers@vrfy.org>
> >>
> >> Some broken devices indicates that media has changed on every
> >> GET_EVENT_STATUS_NOTIFICATION.  This translates into MEDIA_CHANGE
> >> uevent on every open() which lets udev run into a loop.
> >>
> >> Verify GET_EVENT result against TUR and if it generates spurious
> >> events for several times in a row, ignore the GET_EVENT events, and
> >> trust only the TUR status.
> 
> > James, ping.
> 
> This is a rather urgent fix, that needs to go in, and also to -stable.
> 
> Systems run into endless loops with ever-growing event queues. Nothing
> really works any more if we hit that condition, unless the (broken)
> device is disconnected.

Sorry ... I have it marked for inclusion in my internal queue, I'm just
having difficulty finding time to do a dump from queue and test.  I
should be able to get all the fixes sorted on the 'plane home tomorrow.

James


