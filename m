From: David Brownell <david-b@pacbell.net>
Subject: Re: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map )
Date: Mon, 24 Jun 2002 11:04:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <af7n24$1uf$2@main.gmane.org>
References: <59885C5E3098D511AD690002A5072D3C02AB7F53@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

>>No, of course driverfs isn't for everything.  But if it's not 
>>for all drivers,
>>then what's it for -- just power management?
>  
> "Just" power management??? Like power management isn't important enough???
> ;-)

Well, it's only one of the roles I'd expect of a "driver filesystem",
and actually no -- not the most important one.  If instead it were
called "powermanagementfs" ... or if it were renamed to that ... :)


> We need a device tree to do PM. If driverfs's PM capabilities are hurt
> because it doesn't stay true to that, then the featureitis has gone too far.

And for other reasons, we also need one.  I don't think you've actually
pointed out any concrete problems for PM though.

- Dave



