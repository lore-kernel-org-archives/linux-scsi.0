From: Drew <drew.kay@gmail.com>
Subject: Re: Recommended HBA management interfaces
Date: Tue, 21 Jul 2009 06:48:58 -0700
Message-ID: <c268e4660907210648m347e9d9fqb95130cf066a21ba@mail.gmail.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com>
	<4A609A55.9040404@linux.vnet.ibm.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFDC7@cosmail02.lsi.com>
	<4A64A20A.5080908@emulex.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFE16@cosmail02.lsi.com>
	<4A64C0BD.5040503@emulex.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFE88@cosmail02.lsi.com>
	<4A65B4A2.70402@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:45089 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZGUNtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 09:49:19 -0400
Received: by an-out-0708.google.com with SMTP id d40so4706870and.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2009 06:49:18 -0700 (PDT)
In-Reply-To: <4A65B4A2.70402@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> VMware attempts to emulate the linux driver/midlayer api's, but emulation is done
> in their own way, with their own semantics, for their own purposes.. Anyone
> that believes they just drop a linux driver into vmware and it works w/o
> change has a screw loose.

I must confess to some confusion James. I thought that VMware emulates
hardware and that outside of optimized drivers they don't get involved
in the higher layers of the guest OS.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
