From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Wed, 3 Oct 2007 17:11:14 -0700 (PDT)
Message-ID: <189434.76759.qm@web31810.mail.mud.yahoo.com>
References: <20071003.151729.95504687.davem@davemloft.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:23405 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751108AbXJDALP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 20:11:15 -0400
In-Reply-To: <20071003.151729.95504687.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

--- David Miller <davem@davemloft.net> wrote:
> From: Luben Tuikov <ltuikov@yahoo.com>
> Date: Wed, 3 Oct 2007 15:08:48 -0700 (PDT)
> 
> > Your "want to get their card working" way of view is very
> > simplistic to justify generating and assigning SAS WWN in the kernel.
> > This is the job of the manufacturer/packager, not the host OS.
> 
> When you are thousands of miles away from the data center and lose all
> of your storage and therefore can't boot correctly because the WWN
> info is corrupted, you won't have this unbelievably fascist attitude
> about this problem.
> 
> Give people an _OPTION_!
> 
> This is about as anti-social as when the Intel folks refused to
> themselves put in a driver option to try to use an eepro100 card even
> if the EEPROM was corrupted and had a bad checksum.
> 
> For the person who hits this, it's a big issue to have a way to still
> try to bring things up.
> 
> If you don't provide this, you want people to suffer more than
> necessary when something goes wrong, and that by definition makes you
> an asshole.

No, not all.

If the MS/NVRAM is corrupted (becomes corrupted) then it is better
for the admin to see that the system wouldn't boot or that the storage
domain is not visible (if the system doesn't boot from it), and provide
a sample WWN at kernel boot line or module load time, just to
connect to the storage network.

But having a WWN generator in the kernel, although not terribly
difficult to write, makes it possible to create an inconsistent
storage domain.  It is that possibility which troubles me,
due to the intention of SAS WWNs.

I guess much of this argument doesn't really matter, since
most SAS HA would really be a ROC, and as thus much more
would need to happen before the HA is useable, than just
having a MS/NVRAM with the WWN.

Here is what "modinfo aic94xx.ko" (the version I maintain)
says:

parm:           sas_addr_str:
        Provide a SAS address for a single host adapter.
        This is for testing only! You should not need to provide this!

    Luben

