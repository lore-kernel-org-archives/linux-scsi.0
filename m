From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [dm-devel] RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Fri, 23 Jan 2009 09:04:17 -0600
Message-ID: <1232723057.3250.21.camel@localhost.localdomain>
References: <D4B83214B57CAC4499F1114D069E451A01A7D765@bunker.inside.abhaisystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50071 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbZAWPER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 10:04:17 -0500
In-Reply-To: <D4B83214B57CAC4499F1114D069E451A01A7D765@bunker.inside.abhaisystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sudhakar Pannerselvam <sudhakarp@inmage.net>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Thu, 2009-01-22 at 22:22 -0800, Sudhakar Pannerselvam wrote:
> As James mentioned earlier, this is a distribution issue. I had seen
> this issue with redhat. If you observe redhat distro qlogic drivers,
> they compile firmware files along with the driver and hence they
> wouldn't observe this issue when they load through initrd as there is no
> firmware loading procedure through hotplug interface, whereas if you
> compile qlogic driver by hand without inbuilt firmware files and using
> distro's like redhat, you would encounter this issue. This has to be
> addressed in nash hotplug code. 

OK, there is one little wrinkle with Red Hat:  nash is a sort of all in
one process and it keeps going wrong.  I've opened a few bugs with red
hat about nash over the years with hotplug issues, which this is, but
they always ignore them and then close them when the distro goes end of
life.

The way I fixed my RH nash problems was to boot the RH distro with a
debian created initrd ... which is a bit of a time consuming hack, but
it worked.

These problems should be going away when Dave Jones finally kills off
nash in his initrd/boot system rewrite.

James


