From: Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: [PATCH 22/82] remove linux/version.h from drivers/message/fus
	ion
Date: Wed, 20 Jul 2005 10:30:10 +0200
Message-ID: <1121848210.12525.6.camel@tara.firmix.at>
References: <91888D455306F94EBD4D168954A9457C03281EB4@nacos172.co.lsil.com>
	 <20050720031249.GA18042@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.firmix.at ([62.141.48.66]:56734 "EHLO ns.firmix.at")
	by vger.kernel.org with ESMTP id S261282AbVGTIax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2005 04:30:53 -0400
In-Reply-To: <20050720031249.GA18042@humbolt.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Tue, 2005-07-19 at 22:12 -0500, Matt Domsch wrote:
> On Tue, Jul 19, 2005 at 06:07:41PM -0600, Moore, Eric Dean wrote:
[...]
> > What you illustrated above is not going to work.
> > If your doing #ifndef around a function, such as scsi_device_online, it's
> > not going to compile
> > when scsi_device_online is already implemented in the kernel tree.
> > The routine scsi_device_online is a function, not a define.  For a define
> > this would work.
> 
> Sure it does, function names are defined symbols.

Defined for the preprocessor or the pure C-compiler or both of them?

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

