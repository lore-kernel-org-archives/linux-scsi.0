From: James Smart <James.Smart@Emulex.Com>
Subject: Re: persistent scsi with udev
Date: Thu, 08 Feb 2007 09:18:41 -0500
Message-ID: <45CB3141.2030707@emulex.com>
References: <eqf3li$9s7$1@sea.gmane.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58601 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423041AbXBHOSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 09:18:47 -0500
In-Reply-To: <eqf3li$9s7$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Moroder <andreas.moroder@sb-brixen.it>
Cc: linux-scsi@vger.kernel.org

You can see if a white paper we put together, which includes information
on tapes, can help you. There's also a small section on "boot from SAN"
which talks about configuring udev in initrd for boot devices. Although
the content references distros, it should be applicable to the kernel
generically.
http://www.emulex.com/white/hba/wp_linux26udev.pdf

-- james s


Andreas Moroder wrote:
> Hello,
> 
> we have a big problem with scsi device mapping.
> 
> We have a LSI Megaraid controller and a qlogic HBA with a attached SAN
> 
> When we boot the machine without the SAN then  the first disk on the 
> MEGARAID becomes \dev\sda
> 
> When we boot with the SAN attached then the first disk in the san 
> becomes \dev\sda and the system stop.
> 
> Is there a step by step tot availabe on how to configure the udev files 
> when two SCSI devices are installed in one machine ?
> 
> Thanks
> Andreas
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
