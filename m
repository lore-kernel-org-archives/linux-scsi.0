From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 15:41:10 -0500
Message-ID: <41991466.9060805@pobox.com>
References: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com> <4198EF00.2010305@pobox.com> <4198F579.9080606@adaptec.com> <4198FA4D.3000206@pobox.com> <41990AD4.1060900@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43981 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261697AbUKOUlc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:41:32 -0500
In-Reply-To: <41990AD4.1060900@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric.Moore@lsil.com, James Bottomley <James.Bottomley@steeleye.com>

Luben Tuikov wrote:
> I completely agree with you.  Minimalistic approach is a good thing.
> 
> As to the API: the more reason for knowlegable Linux folks to keep
> an "eye" on SDI and other relevant developing standards.
> This way there'd be yet another voice of experience (Linux).
> 
> Getting the design right is very important.  IMO, I think it'd
> better to have OS independence (SDI) as opposed to "Windows, Linux
> and other OSs are addressed" (pre-SDI).

I would prefer to see how a rough-draft Linux implementation would look 
first.  Otherwise, without an implementation, linux-scsi denizens don't 
really have a basis from which to form design input.  That's really the 
"Internet way" -- form a rough consensus based on [test | production] 
implementations, then write the standard.

This area is also a bit delicate politically, because various companies 
have various bits of "value-add" in their management utils.  This is 
delicate because it clashes with the Linux wish to be vendor-neutral.  A 
vendor-neutral "Linux-ish" management API (be it RAID or SAN or 
whatever) would strongly encourage existence of a vendor-neutral, open 
source management utility.


For a starting point...  basically the problem boils to:  you need a 
control point (/dev node, /sysfs file, ioctl, etc.) that allows you to 
create, destroy, and manipulate nodes [a.k.a. SCSI targets] and node 
attributes.  James seemed to favor creating a few transport classes 
(visible through sysfs) that could act as these control points.

I should dig up a RAID card somewhere, and see what I could do about a 
block-level RAID management API.  (thinking out loud, probably silly)

	Jeff



