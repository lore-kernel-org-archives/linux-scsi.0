From: Dave Wysochanski <davidw@netapp.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Sun, 27 Feb 2005 13:46:00 -0500
Message-ID: <42221568.6080508@netapp.com>
References: <1109187935.15154.164.camel@haakon> <x05mzttr8aw.fsf@null.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from mx1.netapp.com ([216.240.18.38]:29278 "EHLO mx1.netapp.com")
	by vger.kernel.org with ESMTP id S261432AbVB0Sp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Feb 2005 13:45:59 -0500
In-Reply-To: <x05mzttr8aw.fsf@null.msp.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: AJ Lewis <alewis@redhat.com>
Cc: linux-scsi@vger.kernel.org

AJ Lewis wrote:

> "Nicholas A. Bellinger" <nick@pyxtechnologies.com> writes:
>
> > The following is the first public release of the PyX Technologies iSCSI
> > Initiator Core Stack v1.6.1.20 for Linux 2.6.11-rc4.  This is a full
> > featured iSCSI Initiator stack that is capable of mulitplexing coast to
> > coast across multiple independant backbone providers using various
> > network transports _TODAY_.  This is the first release of the core 
> stack
> > and assoicated userspace tools, the accompanying authentication daemon
> > will be released shortly.
>
> Very cool - glad you're releasing this. I've gotten this setup and
> running, but I can't seem to talk to my iscsi target.  The initiator
> detects it, but it can't recognize the type:
>
> iCHANNEL[0] - No defined iSCSI Authentication Methods, skipping 
> SecurityNegotiation phase.
> iCHANNEL[0] - iSCSI login successful on CID: 0 to 192.168.44.19:3260,2
> iCHANNEL[0] - Incremented iSCSI connection count to 1 to node: 
> iqn.1992-08.com.netapp:sn.33615311
> iCHANNEL[0] - Established iSCSI session to node: 
> iqn.1992-08.com.netapp:sn.33615311
> iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
> scsi: unknown device type 31
>   Vendor: NETAPP    Model: LUN               Rev: 0.2
>   Type:   Unknown                            ANSI SCSI revision: 04
>
> Any ideas on why this wouldn't be working?  Is there a configuration
> step I'm missing?
>
Make sure the initiator name is in the igroup on the filer for
any luns that you want mapped to the intiator.

I think what you're seeing is not a real LUN, but the config LUN
or something like that, probably the result of the initiator name
not being in the igroup (see "igroup add" command on the filer).

> Also, are you planning on updating the docs for the user tools at all?
> There are several steps missing in the current README, and the man
> page lists some parameters incorrectly and misses other entirely.
>
> I'm looking forward to getting this working.
> -- 
> AJ Lewis                                   Voice:  612-638-0500
> Red Hat Inc.                               E-Mail: alewis@redhat.com
> 720 Washington Ave. SE, Suite 200
> Minneapolis, MN 55414
>   
> Current GPG fingerprint = D9F8 EDCE 4242 855F A03D  9B63 F50C 54A8 
> 578C 8715
> Grab the key at: http://people.redhat.com/alewis/gpg.html or one of the
> many keyservers out there...
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
