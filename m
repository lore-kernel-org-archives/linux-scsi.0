From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 16 Nov 2010 08:15:54 +0100
Message-ID: <AANLkTinkGcGLGDEWb8G371Ykt+hsRtfPNd7nMYpXsQEq@mail.gmail.com>
References: <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com>
 <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com>
 <20101115184422.GA9566@kroah.com> <4CE19A94.8080504@vlnb.net> <20101115221359.GA9530@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43603 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab0KPHQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 02:16:15 -0500
In-Reply-To: <20101115221359.GA9530@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Joe Eykholt <jeykholt@cisco.com>

On Mon, Nov 15, 2010 at 11:13 PM, Greg KH <greg@kroah.com> wrote:
> [ ... ]
> And use configfs for your configuration stuff, that's what it is there
> for, and if it doesn't somehow work properly for you, please work with
> the configfs developers to fix that up.

Hello Greg,

The reason why we use sysfs instead of configfs is that we do not only
want to export kernel objects to user space but because we also want
to allow configuration from user space. As far as I can see configfs
has been designed to allow configuration from user space only and not
for exporting kernel objects. A quote from
Documentation/filesystems/configfs/configfs.txt:

12 [What is configfs?]
13
14 configfs is a ram-based filesystem that provides the converse of
15 sysfs's functionality.  Where sysfs is a filesystem-based view of
16 kernel objects, configfs is a filesystem-based manager of kernel
17 objects, or config_items.

Bart.
