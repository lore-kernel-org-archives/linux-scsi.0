From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Thu, 24 Feb 2005 23:50:29 -0800
Message-ID: <1109317829.5848.22.camel@haakon>
References: <1109187935.15154.164.camel@haakon>
	 <x05mzttr8aw.fsf@null.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp813.mail.sc5.yahoo.com ([66.163.170.83]:8371 "HELO
	smtp813.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S262645AbVBYHyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 02:54:00 -0500
In-Reply-To: <x05mzttr8aw.fsf@null.msp.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: AJ Lewis <alewis@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2005-02-24 at 14:51 -0600, AJ Lewis wrote:
> "Nicholas A. Bellinger" <nick@pyxtechnologies.com> writes:
> 
> > The following is the first public release of the PyX Technologies iSCSI
> > Initiator Core Stack v1.6.1.20 for Linux 2.6.11-rc4.  This is a full
> > featured iSCSI Initiator stack that is capable of mulitplexing coast to
> > coast across multiple independant backbone providers using various
> > network transports _TODAY_.  This is the first release of the core stack
> > and assoicated userspace tools, the accompanying authentication daemon
> > will be released shortly.
> 
> Very cool - glad you're releasing this. I've gotten this setup and
> running, but I can't seem to talk to my iscsi target.  The initiator
> detects it, but it can't recognize the type:
> 
> iCHANNEL[0] - No defined iSCSI Authentication Methods, skipping SecurityNegotiation phase.
> iCHANNEL[0] - iSCSI login successful on CID: 0 to 192.168.44.19:3260,2
> iCHANNEL[0] - Incremented iSCSI connection count to 1 to node: iqn.1992-08.com.netapp:sn.33615311
> iCHANNEL[0] - Established iSCSI session to node: iqn.1992-08.com.netapp:sn.33615311
> iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
> scsi: unknown device type 31
>   Vendor: NETAPP    Model: LUN               Rev: 0.2 
>   Type:   Unknown                            ANSI SCSI revision: 04
> 
> Any ideas on why this wouldn't be working?  Is there a configuration
> step I'm missing?
> 

This looks like an unknown/unsupported SCSI Peripheral device type in
the INQUIRY response data.  Is this LU just a sequential access device
that is setting those bits to some different value?

It would certainly be interesting to see with Ethereal what is in the
INQUIRY response data that Linux could possibly not support. :-)


> Also, are you planning on updating the docs for the user tools at all?
> There are several steps missing in the current README, and the man
> page lists some parameters incorrectly and misses other entirely.
> 

There are a couple of things I would like to be accomplished in the near
feature for the user tools:

1) Complete documentation of iSCSI Channel Management optertions by way
of updated initiator-ctl manual pages and basic HOWTO for iSCSI Logical
Unit Management Screnarios for iSCSI SAN Adminstitrators.
2) Initial release of authentication daemon using CHAP, with eventual
support for RFC 3720 defined SRP.
3) Work towards supporting the Internet Storage Naming Service (iSNS)
standard and assoicated open source implementations for discovery and
device information for iSCSI Target Nodes and other storage resources.

Thanks for the feedback!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>


