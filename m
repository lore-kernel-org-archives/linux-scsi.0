From: "Tim Wesemann" <timuel@voicenet.com>
Subject: Re: Adaptec 2200S with aacraid won't do 64-bit
Date: Tue, 22 Feb 2005 17:22:28 -0500
Message-ID: <04c801c5192d$08655ad0$de0167cf@voicenet.com>
References: <60807403EABEB443939A5A7AA8A7458BCDC69E@otce2k01.adaptec.com> <049d01c51928$7a83a040$de0167cf@voicenet.com> <20050222215541.GO28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Received: from mail08.voicenet.com ([207.103.0.34]:8849 "HELO
	mail08.voicenet.com") by vger.kernel.org with SMTP id S261298AbVBVWWp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 17:22:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org

> There's 64-bit *transfers* and 64-bit *addressing* ... but let's not
> go into that; the problem isn't on the PCI bus, it's on the SCSI bus.
> Even 32-bit, 33MHz PCI is capable of at least 80MB/s.

That sounds fine, but when connecting the same exact cabling, etc. to the 
on-board AIC-7902 or a 29320A and using a software RAID5, my writes max out 
at around 130MB/s.

Are there any more details, output, etc I could provide?

Thanks again for all the help...

--
Tim Wesemann
Voicenet Systems Administration 

