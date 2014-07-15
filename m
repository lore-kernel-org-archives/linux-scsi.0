From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state
Date: Tue, 15 Jul 2014 13:58:57 -0400
Message-ID: <yq1wqbetsf2.fsf@sermon.lab.mkp.net>
References: <20140625103532.GA12953@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625103532.GA12953@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:05:32 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> The driver would send IOC facts only if HBA is in operational
Sreekanth> or ready state. If it is in fault state, a diagnostic reset
Sreekanth> would be issued. It would wait for 10 seconds to exit out of
Sreekanth> reset state. If the HBA continues to be in reset state, then
Sreekanth> the HBA wouldn't be claimed by the driver.

Your patch header describes what used to happen. What does the patched
code do?

Also, several of your patches move large functions around within the
file. That makes it really hard to figure out what the actual code
changes are. Please split changes like that in two: One patch that moves
stuff around in bulk without any functional changes and a second that
addresses the issue at hand. That makes reviewing much easier.

-- 
Martin K. Petersen	Oracle Linux Engineering
