From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Mon, 30 Aug 2004 14:03:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B43982FC-FABF-11D8-85F1-00039398BB5E@ieee.org>
References: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org> <41300511.206030
	 3@torque.net> <Pine.LNX.4.58.0408280922540.7958@kai.makisara.local><3CC78E
	D C-FAAA-11D8-85F1-00039398BB5E@ieee.org> <Pine.LNX.4.58.0408302202420.4250
	@kai.makisara.local>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:11651 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268411AbUH3UDt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 16:03:49 -0400
In-Reply-To: <Pine.LNX.4.58.0408302202420.4250@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Kai M:

> ...
>>> The severity of deferred errors ...
> ...
> What you know is that the data up to the
> previous filemark is OK, beyond that the data is suspect unless the
> application knows the drive buffer size. To be able to easily read the
> archive, it is best to rewrite the archive on another tape. Bad tapes 
> are
> not common but they do happen. That is why I say it is not a 
> catastrophy
> to see a medium error of any type.

Ah.  I think I understand (& agree) now.

The "catastrophe" I meant was that the drive and media together have 
failed.  We now have cause to suspect both.

With removable media, yes, by design, after such an event, we recommend 
trust the drive, throw away the tape or disc, buy another, hope it 
works.  Of course, when the disk is not removable, then a failure of 
the disk alone means the drive loses all value.

> A good thing with tapes is that when the error is detected, the
> application is still living. If the last close succeeds, the data is on
> the tape. With disks it may be more complicated because there may be
> pending data from several sources and the application losing its data 
> may
> not be around any more.

"Ah.  I think I understand (& agree) now."

I distinguish drag & drop from backup.  With backup, to tape or disc, 
no matter.  Either way, the backup app should by design hang around 
long enough to see all trouble reported, and a report of bad media seen 
then means start over.

> The severity of errors is largely a matter of opinion and depends on 
> what
> you are trying to do. What we can probably agree on is that the scene
> looks a little different with different types of devices that SCSI can 
> be
> used with. Besides disks and tapes, there are also other types 
> (changers,
> backplanes, ...) that may need different type of processing.

Yes.

> The high
> level driver has to be able to make the decisions if it needs to. (Some
> decisions the upper level probably does not need to do

Yes.

> like retrying and
> ABORTED command that has not done anything to the medium.)

Some app folk want to decide their own retry strategy, aye.  General 
purpose operating systems easily fall into indefinite and pointless 
retries, aye.

Pat LaVarre

