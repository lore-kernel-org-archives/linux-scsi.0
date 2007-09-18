From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on flushing buffers and spinning down disk
Date: Tue, 18 Sep 2007 16:15:46 +0200
Message-ID: <200709181615.46537.oliver@neukum.org>
References: <200709181032.29864.oliver@neukum.org> <1190124061.3375.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:60594 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753416AbXIROPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 10:15:16 -0400
In-Reply-To: <1190124061.3375.5.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Am Dienstag 18 September 2007 schrieb James Bottomley:
> On Tue, 2007-09-18 at 10:32 +0200, Oliver Neukum wrote:
> > which function should a lldd call to make the scsi layer flush
> > a device's buffers and spin it down? Which kind of locking is
> > required?
> 
> Depends on the context. Is this for suspend? If so it's done
> automatically by the sd driver, but the device has to be marked for it
> in the manage_start_stop attributes.

It is for runtime power management. We've gotten a bug report about
a drive enclosure that doesn't properly park heads if the usb device is
simply suspended. Apparently it simply cuts power so the cache can
be lost, too.

	Regards
		Oliver
