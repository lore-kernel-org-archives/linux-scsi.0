From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD
 reentrancy
Date: Mon, 26 Aug 2002 10:02:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF80DCCDBC.5B147AD9-ONC1256C21.002BB3EE@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>




> * SAM-3 specifies that a LUN is 64 bit. While there may not
> be any devices which actually even come close to using this
> huge space, it provides different _addressing__modes_.
>
> This very nicely fits LUN virtualization (iSCSI, LUN masking, etc),
> and would allow one to do magic for storage devices (IP SANs, etc).
>
> A 64 bit LUN could be presented to userspace which may/can then
> present a nice ``picture'' (GUI or what not) of the underlying
> physical/virtual (depending on the SCSI port name/id) storage
> network.
>
> (E.g. iSCSI communicates 64 bit LUNs only...)

To me all of the proposed changes look good. The one above I'd be
interested in particularly. It would help sorting out a lot of woes we had
with writing a fibre-channel HBA driver. For fibre-channel LUNs and port
IDs (WWPN) are 64-bit and depending on configuration, high values can be
(and in our case are) common.

Aron


