From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Marvell SATA status
Date: Tue, 17 Jan 2006 18:41:52 -0500
Message-ID: <87f94c370601171541m316aba65ld90c6f22c784fefd@mail.gmail.com>
References: <43CD67E1.7080703@int.gl3>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:62764 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932476AbWAQXlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 18:41:53 -0500
Received: by wproxy.gmail.com with SMTP id 36so37869wra
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 15:41:52 -0800 (PST)
In-Reply-To: <43CD67E1.7080703@int.gl3>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 1/17/06, Jan Bakuwel <jan.bakuwel@int.greenpeace.org> wrote:
> Hi,
>
> I need to decide whether to add an additional 3ware SATA RAID adapter to
> a server or to utilise the onboard Marvell SATA RAID adapter
> (preferred). The Marvell driver (2.6.15.1) is "highly experimental" and
> I see no traffic mentioning this driver since Sept last year... I was
> wondering what the current status is. If it's still alive I'm obviously
> offering to help debug it...
>
> cheers,
> Jan
Jan,

I believe that driver is discussed on the libata (or sata) list
(linux-ide@vger.kernel.org), not the scsi list.

A status message was just posted there saying at least one of the
Marvell SATA controllers is marked "highly experimental" for a reason,
but please post feedback as it is still being worked on.

Greg
--
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
