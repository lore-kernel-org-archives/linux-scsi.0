From: Rahul Karnik <rahul@genebrew.com>
Subject: Re: Linux [2.6.0-test3/mm1] aic7xxx problems.
Date: Mon, 11 Aug 2003 15:42:28 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F37F1A4.2030404@genebrew.com>
References: <1060543928.887.19.camel@blaze.homeip.net>	 <2425882704.1060622541@aslan.btc.adaptec.com> <1060623576.2826.9.camel@blaze.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1060623576.2826.9.camel@blaze.homeip.net>
To: Paul Blazejowski <paulb@blazebox.homeip.net>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Paul Blazejowski wrote:

> Is this due to my mainboard (nforce2),cpu,ACPI,devfs,sysfs...or all
> these together?

NForce2 + ACPI IRQ routing is a work in progress. Try turning off ACPI 
for the time being and see if it helps.

Thanks,
Rahul
-- 
Rahul Karnik
rahul@genebrew.com
