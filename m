From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] remove generic symlink from sg
Date: Wed, 22 Mar 2006 10:25:27 -0500
Message-ID: <44216C67.2040701@torque.net>
References: <1142715978.3773.13.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:32171 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1751315AbWCVPZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 10:25:52 -0500
In-Reply-To: <1142715978.3773.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> This has been redundant ever since James Smart added the class back
> links since every scsi_device now gets one of these of the form
> scsi_generic:sg<n>.

James,
Careful with the spin:-) It is arguable which one is
redundant. I am testing this patch and it breaks
lsscsi and sg_map26 (again). Could you tell me which
version of the lk 2.6 series the scsi_generic:sg<n>
link appeared in? Because if I switch my code to
search for a scsi_generic:sg<n> symlink rather than
following the generic symlink then I will break
backward compatibility prior to that version (unless
I cope with both). At least one major distro has an
"enterprise" edition based on lk 2.6.5

> I'm open to going through the deprecated features business for this,
> since this would represent a user visible change of the scsi sysfs
> interface if you wish.

I can see from my lsscsi code and the st driver that
tape devices still have a plain old "tape" symlink.
Should I be expecting that one to break in the near
future?

Doug Gilbert
